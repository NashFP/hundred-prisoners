(ns hundred-prisoners.core-test
  "Generative tests for the game."
  (:require [clojure.test.check.clojure-test :as tct]
            [clojure.test.check :as tc]
            [clojure.test.check.properties :as prop]
            [clojure.test.check.generators :as gen]
            [clojure.test :refer :all]
            [hundred-prisoners.core :as core]))

(defn prisoner-list
  "Generate a list of prisoner ids for entering the room.

  Duplicates are allowed.

  n - The number of prisoners"
  [n]
  (gen/vector (gen/resize (dec n)
                          gen/nat)
              0
              (* 100 n)))

(tct/defspec prisoners-never-die 1000
  (let [pc 100]
    (prop/for-all [pl (prisoner-list pc)]
      (not= (:status (core/run-game pc
                                    pl))
            :slaughter-them-all!))))

(defn base-success-case [n]
  (interleave (range n)
              (repeat 0)))

(defn success-case
  "A success case for this solution will always be of the
  basic form:

  [0 1 0 2 ... n 0]

  Any number of random prisoner-ids may be inserted into
  this basic form, and it should still be successful."
  [n]
  (let [bc (base-success-case n)]
    (gen/fmap (fn [rdms]
                (mapcat (fn [bcv rdms]
                          (apply vector bcv rdms))
                        bc
                        rdms))
              (gen/vector (gen/vector (gen/resize (dec n)
                                                  gen/nat)
                                      0
                                      (count bc))
                          (count bc)))))

(tct/defspec success-case-always-free 1000
  (let [pc 100]
    (prop/for-all [pl (success-case pc)]
      (= (:status (core/run-game pc
                                 pl))
         :you-may-go-free))))
