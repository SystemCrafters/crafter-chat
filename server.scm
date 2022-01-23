(use-modules (gnu))
(use-service-modules networking ssh)
(use-package-modules bootloaders ssh)

(define %)
(operating-system
 (host-name "crafter-chat")
 (timezone "Etc/UTC")

 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (targets '("/dev/vda"))
              (terminal-outputs '(console))))

 (file-systems (cons (file-system
                      (mount-point "/")
                      (device "/dev/vda1")
                      (type "ext4"))
                     %base-file-systems))

 (services
  (append (list (service dhcp-client-service-type)
                (service openssh-service-type
                         (openssh-configuration
                          (openssh openssh-sans-x)
                          (password-authentication? #f)
                          (permit-root-login #t)
                          (authorized-keys
                           `(("root" ,(local-file "id_rsa.pub")))))))
          %base-services)))
