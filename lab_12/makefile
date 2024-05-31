.PHONY: run_vm
run_vm:
	qemu-system-aarch64 -machine virt -cpu cortex-a72 -nographic \
	-smp 1 -m 512 -kernel vmlinuz-run -initrd initrd-run.img -append \
	"root=/dev/sda2 console=ttyAMA0" -global virtio-blk-device.scsi=off \
	-device virtio-scsi-device,id=scsi -drive \
	file=debian11-arm64.img,id=rootimg,cache=unsafe,if=none \
	-device scsi-hd,drive=rootimg -virtfs \
	local,\
	path=/home/gospodin/dosprogs/MYPROGS/lab_12,\
	mount_tag=host0,security_model=none,id=host0

#Вместо /home/gospodin/dosprogs/MYPROGS/lab_12 нужно указать существующий в основной ОС
#каталог, который затем будет примонтирован в гостевую ОС
