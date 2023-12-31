(load (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname)))

(declaim (ftype (function (number number number number number number) float) 
                calculate-distance))
;;(require 'asdf)
(require :uiop)
;;(require "split-sequence")
(ql:quickload "split-sequence")

(defun calculate-distance (x1 y1 z1 x2 y2 z2)
  (let ((x-diff (- x2 x1))
        (y-diff (- y2 y1)) 
        (z-diff (- z2 z1)))
    (format t "xの差分: ~a~%" x-diff)
    (format t "yの差分: ~a~%" y-diff)
    (format t "zの差分: ~a~%" z-diff)
    (let ((x-sq (expt x-diff 2))
          (y-sq (expt y-diff 2))
          (z-sq (expt z-diff 2)))
      (format t "xの2乗: ~a~%" x-sq)
      (format t "yの2乗: ~a~%" y-sq)
      (format t "zの2乗: ~a~%" z-sq)
      (sqrt (+ x-sq y-sq z-sq)))))

;;(defun create-directory-and-write-file 
;;  (let ((directory-path "../")
;;        (file-name "caches.txt")
;;        (content ""))
;;    (ensure-directories-exist directory-path)
;;    (with-open-file (stream (concatenate 'string directory-path file-name) :direction :output :if-exists :supersede)
;;      (write-string content stream))))

(defun parse-coordinates (input-str)
  (let ((cleaned-str (remove-if (lambda (char) (or (char= char #\() (char= char #\)))) input-str)))
    (mapcar #'parse-integer (split-sequence:split-sequence #\Space cleaned-str))))

(defun write-result-to-cache (coords1 coords2 distance)
  (let ((directory-path "../")
        (file-name "caches.txt"))
    (ensure-directories-exist directory-path)
    (with-open-file (stream (concatenate 'string directory-path file-name) :direction :output :if-exists :supersede)
      (format stream " ~A~%" coords1)
      (format stream " ~A~%" coords2)
      (format stream " ~A" distance))))


(defun main() 
  (format t "1点目の座標を入力 (x y z): ")(terpri)
  (let* ((coords1 (parse-coordinates (read-line)))
         (x1 (first coords1))
         (y1 (second coords1))
         (z1 (third coords1)))
    (format t "2点目の座標を入力 (x y z): ")(terpri)
    (let* ((coords2 (parse-coordinates (read-line)))
           (x2 (first coords2))
           (y2 (second coords2))
           (z2 (third coords2))
           (distance (calculate-distance x1 y1 z1 x2 y2 z2))
           (distance-squared (expt distance 2)))
      (format t "2点間の距離: √~A" distance-squared)
      (write-result-to-cache coords1 coords2 (format nil "~A" distance)))))

(compile 'main)

(sb-ext:save-lisp-and-die "AutoCoordDistance"
                          :toplevel #'main
                          :executable t)


