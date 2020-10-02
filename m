Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25CE281205
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 14:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgJBMJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 08:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgJBMJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 08:09:19 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA610C0613D0
        for <kvm@vger.kernel.org>; Fri,  2 Oct 2020 05:09:17 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id q21so1100804ota.8
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 05:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=LHVb/vtYQP7Y0nXe+eNVK4scUaxj8uOtbztUFlpFnXU=;
        b=re1kz61Q12tf8bXtqJev0JzQQeWjpPocouCzKdcSdANbksMqqDItrkDloHDiLY06Ck
         gAP48Zp3KESXzDyzQZ/67RJXMVZHmJ0EPe7lyhn3rlP1CT2uqQBLmPOUysEVO/j+Eex4
         yM2DLPosvWVNal3lNm4OuDl/fi+ohsdTcP8gBlIlxiAWgL6jUIl0UuzDns2dyQTg//La
         B/5QmMHDPfKC2VOhNBFQw7iXv65iasDIu6UhnR6NgXTnHPGfAPax1f/FfPQVbLWaK7sy
         CVvFvShdT6V4scnxR4eWmaKLirIauIhyvubxYa81xPJxtYVvwpbyxehaV6BhJywZf9UG
         78OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LHVb/vtYQP7Y0nXe+eNVK4scUaxj8uOtbztUFlpFnXU=;
        b=IQcpcsF/7DSijvKON09C/DthGWzCaisRkgMSzWObPpqSpdYhLvU0izYnGhsx15Q8FI
         rnA7fDonF4mxCB+Mrw1ux1RLUuOkT2+ffT+fi4LtB5iaSpY+q+Kgx2HUMY1HLFaiiRj4
         tBzbGtwRJDgDZxDU/DHT1X1XFnSXY0xwuv1LjYULlXRQA9z0IpwFX59RGZBX7OEcYCHp
         I9MdoPIOnnD+hx00AZWi75l9GFfJiX4rcuLvPXTTTWenNZ3mehlE9+WGGKAHD6xY+cce
         FCTbllZmYGnylPb/oNFllV2Lz7a/DYXOU4WUiWvpheH8RqOxPnjTWr4/pphpH/xCrfSI
         H3dw==
X-Gm-Message-State: AOAM531AZWC2YH7K0CMwsU8qLj6lrfnrjOKn7s9SZ7PJ9KYpKCx3MG4N
        DmIhzTnmQLuIA6ZcKBhGYYyLLGUJxJXmVQQJ0JJE9HP7edc=
X-Google-Smtp-Source: ABdhPJzWN/1F01G47+zJeDGTW79ItzKp3JBIftstdjQQ3giwGpHiRqRrBYGO8scRcLC2o5Bif9sRdXWV9BJlvC1YRwM=
X-Received: by 2002:a05:6830:454:: with SMTP id d20mr1521721otc.139.1601640556876;
 Fri, 02 Oct 2020 05:09:16 -0700 (PDT)
MIME-Version: 1.0
From:   Quentin Grolleau <quentin.grolleau@gmail.com>
Date:   Fri, 2 Oct 2020 14:09:09 +0200
Message-ID: <CA+BWSia-x86d3+C_zm+B0ZJEJWSne+Q95Z+cy02XHkr+pOtQGQ@mail.gmail.com>
Subject: Qemu crash when trying to boot a VM with 4 NVME in PCI passthrough
 with KVM internal error. Suberror: 1
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,


I wanted to know where i can file a bug about "KVM internal error. Suberror: 1"

Is it on Qemu side, Kernel side or Kvm one ?


More details :


I having problems getting VM to run with QEMU 4.0 and 4 NVME in PCI passthrough
When I create a VM, it quickly goes into a paused state and never
seems to start working.

Log shows emulation failure :

KVM internal error. Suberror: 1
emulation failure
EAX=00000086 EBX=000041d8 ECX=00000001 EDX=00008e68
ESI=00000f01 EDI=00000000 EBP=0000004f ESP=00008e4e
EIP=00000000 EFL=00210093 [--S-A-C] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =9000 00090000 0000ffff 00009300
CS =bffc 000bffc0 0000ffff 00009f00
SS =9000 00090000 0000ffff 00009300
DS =9000 00090000 0000ffff 00009300
FS =9000 00090000 0000ffff 00009300
GS =9000 00090000 0000ffff 00009300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT=     00008160 00000028
IDT=     00000000 000003ff
CR0=00000010 CR2=00000000 CR3=00000000 CR4=00000000
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000000
Code=<20> 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20
07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07 20 07
20 07 20 07 20 07

I try to trace the error and got to this:


 <...>-62567 [030] 2758596.349023: kvm_entry:            vcpu 0
 <...>-62588 [031] 2758596.349024: kvm_fpu:              unload
 <...>-62588 [031] 2758596.349025: kvm_userspace_exit:   reason
KVM_EXIT_UNKNOWN (0)
 <...>-62591 [010] 2758596.349032: kvm_fpu:              load
 <...>-62591 [010] 2758596.349034: kvm_fpu:              unload
 <...>-62567 [030] 2758596.349036: kvm_exit:             reason
EPT_VIOLATION rip 0xfff0 info 784 0
 <...>-62591 [010] 2758596.349036: kvm_userspace_exit:   reason
KVM_EXIT_UNKNOWN (0)
 <...>-62567 [030] 2758596.349038: kvm_page_fault:       address
fffffff0 error_code 784
 <...>-62585 [034] 2758596.349040: kvm_fpu:              load

Qemu version : 4.0

Kernel Version: 4.18.0-25

OS : Ubuntu 16.04


Qemu command :


LC_ALL=C \
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin \
HOME=/var/lib/libvirt/qemu/domain-8-instance-00210982 \
XDG_DATA_HOME=/var/lib/libvirt/qemu/domain-8-instance-00210982/.local/share \
XDG_CACHE_HOME=/var/lib/libvirt/qemu/domain-8-instance-00210982/.cache \
XDG_CONFIG_HOME=/var/lib/libvirt/qemu/domain-8-instance-00210982/.config \
QEMU_AUDIO_DRV=none \
/usr/bin/qemu-system-x86_64 \
-name guest=instance-00210982,debug-threads=on \
-S \
-object secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-8-instance-00210982/master-key.aes
\
-machine pc-i440fx-bionic,accel=kvm,usb=off,dump-guest-core=off \
-cpu Haswell-noTSX,md-clear=on,vmx=on \
-m 180000 \
-overcommit mem-lock=off \
-smp 32,sockets=32,cores=1,threads=1 \
-uuid 77046f18-e107-48e7-939c-57eba163c478 \
-smbios 'type=1,manufacturer=OpenStack Foundation,product=OpenStack
Nova,version=14.1.1,serial=5b429103-2856-154f-1caf-5ffb5694cdc3,uuid=77046f18-e107-48e7-939c-57eba163c478,family=Virtual
Machine' \
-no-user-config \
-nodefaults \
-chardev socket,id=charmonitor,fd=27,server,nowait \
-mon chardev=charmonitor,id=monitor,mode=control \
-rtc base=utc,driftfix=slew \
-global kvm-pit.lost_tick_policy=delay \
-no-hpet \
-no-shutdown \
-boot strict=on \
-device piix3-usb-uhci,id=usb,bus=pci.0,addr=0x1.0x2 \
-device virtio-scsi-pci,id=scsi0,bus=pci.0,addr=0x4 \
-device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x5 \
-drive file=/home/instances/77046f18-e107-48e7-939c-57eba163c478/disk,format=raw,if=none,id=drive-scsi0-0-0-0,cache=none,discard=unmap,aio=native,throttling.iops-total=2000
\
-device scsi-hd,bus=scsi0.0,channel=0,scsi-id=0,lun=0,device_id=drive-scsi0-0-0-0,drive=drive-scsi0-0-0-0,id=scsi0-0-0-0,bootindex=1,write-cache=on
\
-netdev tap,fd=29,id=hostnet0,vhost=on,vhostfd=30 \
-device virtio-net-pci,netdev=hostnet0,id=net0,mac=fa:16:3e:55:8e:0d,bus=pci.0,addr=0x3
\
-add-fd set=3,fd=32 \
-chardev file,id=charserial0,path=/dev/fdset/3,append=on \
-device isa-serial,chardev=charserial0,id=serial0 \
-chardev pty,id=charserial1 \
-device isa-serial,chardev=charserial1,id=serial1 \
-chardev socket,id=charchannel0,fd=31,server,nowait \
-device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=org.qemu.guest_agent.0
\
-device usb-tablet,id=input0,bus=usb.0,port=1 \
-vnc 10.224.136.153:0 \
-device cirrus-vga,id=video0,bus=pci.0,addr=0x2 \
-device vfio-pci,host=1a:00.0,id=hostdev0,bus=pci.0,addr=0x6 \
-device vfio-pci,host=18:00.0,id=hostdev1,bus=pci.0,addr=0x7 \
-device vfio-pci,host=da:00.0,id=hostdev2,bus=pci.0,addr=0x8 \
-device vfio-pci,host=d8:00.0,id=hostdev3,bus=pci.0,addr=0x9 \
-device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0xa \
-sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
\
-msg timestamp=on
char device redirected to /dev/pts/0 (label charserial1)



Quentin
