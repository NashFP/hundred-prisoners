(ns hundred-prisoners.core)

(defn game-state [prisoner-count]
  {:day 0
   :status :continue
   :light :off
   :prisoners (mapv (fn [i]
                      {:id i
                       :leader-id 0
                       :prisoner-count prisoner-count
                       :seen []})
                    (range prisoner-count))
   :wardens-list #{}})

(defn enter-room [{:keys [id
                          leader-id
                          seen
                          prisoner-count] :as prisoner}
                  light]
  (let [flip         (fn [l]
                       (if (= :on l)
                         :off
                         :on))
        assert-done? (fn [{:keys [id leader-id seen]} prisoner-count]
                       (and (= id leader-id)
                            (= prisoner-count
                               (count (filter #{:off}
                                              seen)))))
        light'       (cond
                       (= id leader-id) :on

                       (and (= :on light)
                            (not-any? #{:on}
                                      seen))
                       (flip light)

                       :else light)
        prisoner'    (assoc prisoner
                       :seen (conj seen light))]
    {:light light'
     :prisoner prisoner'
     :assert-done? (assert-done? prisoner' prisoner-count)}))

(defn actually-done? [prisoners wardens-list]
  (= (into #{}
           (map :id
                prisoners))
     wardens-list))

(defn next-day [{:keys [day
                        status
                        light
                        prisoners
                        wardens-list] :as s}
                prisoner-id]
  {:pre [(contains? prisoners prisoner-id)]}
  (if (not= status :continue)
    s
    (let [{light' :light
           prisoner' :prisoner
           assert-done? :assert-done?}
          (enter-room (get prisoners
                           prisoner-id)
                      light)
          wardens-list' (conj wardens-list prisoner-id)]
      (-> s
          (assoc-in [:prisoners prisoner-id] prisoner')
          (assoc :day (inc day)
                 :light light'
                 :wardens-list wardens-list'
                 ;; needs access to new wardens-list
                 :status (if assert-done?
                           (if (actually-done? prisoners wardens-list')
                             :you-may-go-free
                             :slaughter-them-all!)
                           :continue))))))

(defn run-game
  ([prisoner-count]
   (run-game prisoner-count
             (repeatedly #(rand-int prisoner-count))))
  ([prisoner-count prisoner-id-list]
   (reduce (fn [s id]
             ;; this is the same as just calling `next-day`
             ;; except it short-circuits when the game is done
             ;; allowing us to operate on infinite prisoner-id-lists
             (let [{:keys [status] :as s'}
                   (next-day s id)]
               (if (= status :continue)
                 s'
                 (reduced s'))))
           (game-state prisoner-count)
           prisoner-id-list)))
