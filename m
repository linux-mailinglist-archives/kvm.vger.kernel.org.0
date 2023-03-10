Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BC56B3397
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 02:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCJBSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 20:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCJBSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 20:18:08 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7952E194
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 17:17:57 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id a25so14594556edb.0
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 17:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678411076;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=btqqT7YSfIpXPwH4xJcHkmeMraMmQ+ww5jZ/jSwVxVA=;
        b=qs9YwzyqRaGgsf2MPLq2Cmj2IValTGfkvVt17AkOlKS+zlOfz0Yz0FnGYjEPgZcg1Z
         65SNVNfRD1TPKNxRU4Z/EltlIrJfAtPiZy1IMYXIMWeznvCEgnAZqQfRaYLVqCeR3q/A
         9nK2i9337etoF2R7kspwc0nsUlSfPJI2MuNEhnA0gxihhAAZd+eaEdorli0/XERCARPY
         SnT6PNfuI1HjOUMYoaNDCY741QSD+kM2R+yFMZcFNOpiNh2b50BL23pdF5BJK73nwYR2
         NDfqwMpRvPB63Tqt5kTCI6TMm0QkMrrAPkJdzdXcdu6N1BlVTGxKVPL4G8lXjsZMmc8O
         4TGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678411076;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=btqqT7YSfIpXPwH4xJcHkmeMraMmQ+ww5jZ/jSwVxVA=;
        b=XpfPbSaX525typWHiQlrzI0iSGyAStFdiyIaSMTdRzv4qy8N/7eFYymb1xe9hgnnp5
         lwgtY4H7u1Ut0XkrNIGxWjc3l9kC2Ablzpfe4x4CTz1y8eqoxGBLINr9X1kKpzlYQ1rI
         C3Cp9jcTH+P83FHdl3JfeI5UQ4pyIwdeHYYTauLniTv2Cos4e/l1p2M/Zis+zS0bxPS7
         q2eTl+gwtRFxlqDz8fWJTVtmTDCbvFhaAfXkjj9KFQ1pPOShdH8cF9eLzCnWlguyAGBU
         FHIoF/RUfH326JlA/8ppk0QgOQLa/ZaKqay0TZ+g/WqPFLBYskOW6pbpT/Ed3nob7jAU
         WnKw==
X-Gm-Message-State: AO0yUKVPDGr0T0e9QI62Q5HBOKoGzRe0jckMa1R25ujks1OGiqSEljJy
        +55pbyKEvgTNGefzGLjOfd6qMH0aw9ATa2cM2LzZix8vA5MFmw==
X-Google-Smtp-Source: AK7set9J06sGm2xIpRJnE6KPlgcbTzauHByCL7G0Lm4sOLdVxRdeYAFkRXmk2Vl15cw45Dt+IxngwbNsq/hUx+ZqTuQ=
X-Received: by 2002:a17:906:3503:b0:8b2:8876:cdd4 with SMTP id
 r3-20020a170906350300b008b28876cdd4mr12106759eja.7.1678411075565; Thu, 09 Mar
 2023 17:17:55 -0800 (PST)
MIME-Version: 1.0
References: <CACQapsBJxdH2SpwuSgD1rKhqymw9vAME+BdzLO82a=hV2V5=Lw@mail.gmail.com>
In-Reply-To: <CACQapsBJxdH2SpwuSgD1rKhqymw9vAME+BdzLO82a=hV2V5=Lw@mail.gmail.com>
From:   "David N." <taact135200@gmail.com>
Date:   Thu, 9 Mar 2023 20:17:44 -0500
Message-ID: <CACQapsBBouUARPdP_MCudazX3_eLaZ4KjvhB5-Ei6SyqL8RVxw@mail.gmail.com>
Subject: Re: Bug: Intel Arc A-Series GPUs VFIO pass through no video out
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm including required information I failed to include in my initial email.
I can use the graphical console from virt-manager from another machine
to see what's going on with and interact the guest.

System Information:
Processor: AMD Ryzen 9 5900X 12-Core Processor
Linux Kernel Version: 6.2.2-arch1-1
Host Kernel Arch: x86_64
Guest OS: Windows 10 64-bit

With -machine kernel_irqchip=3Doff, the vm fails to start. Errors below.

error: Failed to start domain 'win10_vm'
error: internal error: qemu unexpectedly closed the monitor:
2023-03-10T00:09:07.243117Z qemu-system-x86_64: warning: Do not use
kernel-irqchip except for the -M isapc machine type.
2023-03-10T00:09:07.243243Z qemu-system-x86_64: warning: Userspace
local APIC is deprecated for KVM.
2023-03-10T00:09:07.243247Z qemu-system-x86_64: warning: Do not use
kernel-irqchip except for the -M isapc machine type.
2023-03-10T00:09:07.243372Z qemu-system-x86_64: warning: Userspace
local APIC is deprecated for KVM.
2023-03-10T00:09:07.243376Z qemu-system-x86_64: warning: Do not use
kernel-irqchip except for the -M isapc machine type.
2023-03-10T00:09:09.851570Z qemu-system-x86_64: -device
{"driver":"vfio-pci","host":"0000:1b:00.3","id":"hostdev2","bus":"pci.8","a=
ddr":"0x0"}:
warning: vfio 0000:1b:00.3: failed to setup resample irqfd: Invalid
argument
2023-03-10T00:09:09.851920Z qemu-system-x86_64: error: failed to set
MSR 0x4b564d06 to 0x0
qemu-system-x86_64: ../qemu-7.2.0/target/i386/kvm/kvm.c:3177:
kvm_buf_set_msrs: Assertion `ret =3D=3D cpu->kvm_msr_buf->nmsrs' failed.

With -accel tcg
No change.

QEMU Command Line:

LC_ALL=3DC PATH=3D/usr/local/sbin:/usr/local/bin:/usr/bin
HOME=3D/var/lib/libvirt/qemu/domain--1-win10_vm
XDG_DATA_HOME=3D/var/lib/libvirt/qemu/domain--1-win10_vm/.local/share
XDG_CACHE_HOME=3D/var/lib/libvirt/qemu/domain--1-win10_vm/.cache
XDG_CONFIG_HOME=3D/var/lib/libvirt/qemu/domain--1-win10_vm/.config
TZ=3DUS/Eastern /usr/bin/qemu-system-x86_64
-name guest=3Dwin10_vm,debug-threads=3Don
-S -object '{"qom-type":"secret","id":"masterKey0","format":"raw","file":"/=
var/lib/libvirt/qemu/domain--1-win10_vm/master-key.aes"}'
-blockdev '{"driver":"file","filename":"/usr/share/edk2-ovmf/x64/OVMF_CODE.=
fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"=
unmap"}'
-blockdev '{"node-name":"libvirt-pflash0-format","read-only":true,"driver":=
"raw","file":"libvirt-pflash0-storage"}'
-blockdev '{"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/win10_v=
m_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"dis=
card":"unmap"}'
-blockdev '{"node-name":"libvirt-pflash1-format","read-only":false,"driver"=
:"raw","file":"libvirt-pflash1-storage"}'
-machine pc-q35-7.1,usb=3Doff,vmport=3Doff,kernel_irqchip=3Don,dump-guest-c=
ore=3Doff,memory-backend=3Dpc.ram,pflash0=3Dlibvirt-pflash0-format,pflash1=
=3Dlibvirt-pflash1-format
-accel kvm -cpu
host,migratable=3Don,topoext=3Don,hv-relaxed=3Don,hv-vapic=3Don,hv-spinlock=
s=3D0x1fff
-m 28672
-object '{"qom-type":"memory-backend-ram","id":"pc.ram","size":30064771072}=
'
-overcommit mem-lock=3Doff
-smp 24,sockets=3D1,dies=3D1,cores=3D12,threads=3D2
-uuid 274bd08e-ede2-4514-a969-441932781414
-no-user-config
-nodefaults
-chardev socket,id=3Dcharmonitor,path=3D/var/lib/libvirt/qemu/domain--1-win=
10_vm/monitor.sock,server=3Don,wait=3Doff
-mon chardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol
-rtc base=3Dlocaltime
-no-shutdown
-global ICH9-LPC.disable_s3=3D1
-global ICH9-LPC.disable_s4=3D1
-boot strict=3Don
-device '{"driver":"pcie-root-port","port":16,"chassis":1,"id":"pci.1","bus=
":"pcie.0","multifunction":true,"addr":"0x2"}'
-device '{"driver":"pcie-root-port","port":17,"chassis":2,"id":"pci.2","bus=
":"pcie.0","addr":"0x2.0x1"}'
-device '{"driver":"pcie-root-port","port":18,"chassis":3,"id":"pci.3","bus=
":"pcie.0","addr":"0x2.0x2"}'
-device '{"driver":"pcie-root-port","port":19,"chassis":4,"id":"pci.4","bus=
":"pcie.0","addr":"0x2.0x3"}'
-device '{"driver":"pcie-root-port","port":20,"chassis":5,"id":"pci.5","bus=
":"pcie.0","addr":"0x2.0x4"}'
-device '{"driver":"pcie-root-port","port":21,"chassis":6,"id":"pci.6","bus=
":"pcie.0","addr":"0x2.0x5"}'
-device '{"driver":"pcie-root-port","port":22,"chassis":7,"id":"pci.7","bus=
":"pcie.0","addr":"0x2.0x6"}'
-device '{"driver":"pcie-root-port","port":23,"chassis":8,"id":"pci.8","bus=
":"pcie.0","addr":"0x2.0x7"}'
-device '{"driver":"pcie-root-port","port":24,"chassis":9,"id":"pci.9","bus=
":"pcie.0","multifunction":true,"addr":"0x3"}'
-device '{"driver":"pcie-root-port","port":25,"chassis":10,"id":"pci.10","b=
us":"pcie.0","addr":"0x3.0x1"}'
-device '{"driver":"pcie-root-port","port":26,"chassis":11,"id":"pci.11","b=
us":"pcie.0","addr":"0x3.0x2"}'
-device '{"driver":"pcie-root-port","port":27,"chassis":12,"id":"pci.12","b=
us":"pcie.0","addr":"0x3.0x3"}'
-device '{"driver":"pcie-root-port","port":28,"chassis":13,"id":"pci.13","b=
us":"pcie.0","addr":"0x3.0x4"}'
-device '{"driver":"pcie-root-port","port":29,"chassis":14,"id":"pci.14","b=
us":"pcie.0","addr":"0x3.0x5"}'
-device '{"driver":"pcie-root-port","port":30,"chassis":15,"id":"pci.15","b=
us":"pcie.0","addr":"0x3.0x6"}'
-device '{"driver":"pcie-pci-bridge","id":"pci.16","bus":"pci.3","addr":"0x=
0"}'
-device '{"driver":"qemu-xhci","p2":15,"p3":15,"id":"usb","bus":"pci.2","ad=
dr":"0x0"}'
-device '{"driver":"virtio-scsi-pci","id":"scsi0","bus":"pci.6","addr":"0x0=
"}'
-device '{"driver":"virtio-serial-pci","id":"virtio-serial0","bus":"pci.4",=
"addr":"0x0"}'
-blockdev '{"driver":"file","filename":"/home/david/Downloads/Win10_21H2_En=
glish_x64.iso","node-name":"libvirt-4-storage","auto-read-only":true,"disca=
rd":"unmap"}'
-blockdev '{"node-name":"libvirt-4-format","read-only":true,"driver":"raw",=
"file":"libvirt-4-storage"}'
-device '{"driver":"ide-cd","bus":"ide.1","drive":"libvirt-4-format","id":"=
sata0-0-1"}'
-blockdev '{"driver":"file","filename":"/home/david/Downloads/virtio-win-0.=
1.229.iso","node-name":"libvirt-3-storage","auto-read-only":true,"discard":=
"unmap"}'
-blockdev '{"node-name":"libvirt-3-format","read-only":true,"driver":"raw",=
"file":"libvirt-3-storage"}'
-device '{"driver":"ide-cd","bus":"ide.3","drive":"libvirt-3-format","id":"=
sata0-0-3"}'
-blockdev '{"driver":"host_device","filename":"/dev/disk/by-id/nvme-WD_Blue=
_SN570_2TB_21523V801428-part2","aio":"native","node-name":"libvirt-2-storag=
e","cache":{"direct":true,"no-flush":false},"auto-read-only":true,"discard"=
:"unmap"}'
-blockdev '{"node-name":"libvirt-2-format","read-only":false,"discard":"unm=
ap","cache":{"direct":true,"no-flush":false},"driver":"raw","file":"libvirt=
-2-storage"}'
-device '{"driver":"scsi-hd","bus":"scsi0.0","channel":0,"scsi-id":0,"lun":=
4,"device_id":"drive-scsi0-0-0-4","drive":"libvirt-2-format","id":"scsi0-0-=
0-4","bootindex":1,"write-cache":"on"}'
-blockdev '{"driver":"host_device","filename":"/dev/disk/by-id/nvme-Samsung=
_SSD_980_PRO_2TB_S6B0NL0T945389T","aio":"native","node-name":"libvirt-1-sto=
rage","cache":{"direct":true,"no-flush":false},"auto-read-only":true,"disca=
rd":"unmap"}'
-blockdev '{"node-name":"libvirt-1-format","read-only":false,"discard":"unm=
ap","cache":{"direct":true,"no-flush":false},"driver":"raw","file":"libvirt=
-1-storage"}'
-device '{"driver":"scsi-hd","bus":"scsi0.0","channel":0,"scsi-id":0,"lun":=
5,"device_id":"drive-scsi0-0-0-5","drive":"libvirt-1-format","id":"scsi0-0-=
0-5","write-cache":"on"}'
-chardev pty,id=3Dcharserial0 -device
'{"driver":"isa-serial","chardev":"charserial0","id":"serial0","index":0}'
-chardev spicevmc,id=3Dcharchannel0,name=3Dvdagent -device
'{"driver":"virtserialport","bus":"virtio-serial0.0","nr":1,"chardev":"char=
channel0","id":"channel0","name":"com.redhat.spice.0"}'
-device '{"driver":"usb-tablet","id":"input0","bus":"usb.0","port":"1"}'
-audiodev '{"id":"audio1","driver":"spice"}'
-spice port=3D5901,addr=3D0.0.0.0,disable-ticketing=3Don,image-compression=
=3Doff,seamless-migration=3Don
-device '{"driver":"virtio-vga","id":"video0","max_outputs":1,"bus":"pcie.0=
","addr":"0x1"}'
-device '{"driver":"ich9-intel-hda","id":"sound0","bus":"pcie.0","addr":"0x=
1b"}'
-device '{"driver":"hda-duplex","id":"sound0-codec0","bus":"sound0.0","cad"=
:0,"audiodev":"audio1"}'
-chardev spicevmc,id=3Dcharredir0,name=3Dusbredir
-device '{"driver":"usb-redir","chardev":"charredir0","id":"redir0","bus":"=
usb.0","port":"2"}'
-chardev spicevmc,id=3Dcharredir1,name=3Dusbredir
-device '{"driver":"usb-redir","chardev":"charredir1","id":"redir1","bus":"=
usb.0","port":"3"}'
-device '{"driver":"vfio-pci","host":"0000:18:00.0","id":"hostdev0","bus":"=
pci.1","addr":"0x0"}'
-device '{"driver":"vfio-pci","host":"0000:19:00.0","id":"hostdev1","bus":"=
pci.7","addr":"0x0"}'
-device '{"driver":"vfio-pci","host":"0000:1b:00.3","id":"hostdev2","bus":"=
pci.8","addr":"0x0"}'
-device '{"driver":"virtio-balloon-pci","id":"balloon0","bus":"pci.5","addr=
":"0x0"}'
-sandbox on,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=3Ddeny,resourcec=
ontrol=3Ddeny
-msg timestamp=3Don

On Sun, Mar 5, 2023 at 11:52=E2=80=AFAM David N. <taact135200@gmail.com> wr=
ote:
>
> Hi,
>
> I'm not entirely sure if this is the right place for this. I'd
> previously opened a report on the Intel GPU Community Issue Tracker
> and they suggested I open a bug for the VM software I'm using.
>
> The issue:
>
> If you try to pass through an Intel Arc A770 LE (or any other Arc
> A-series GPU) from a Linux host to a Windows guest, you do not get any
> video out or detected monitors on the Arc card. But, the card is being
> picked up by the drivers and will run whatever workload you throw at
> it, there's just no picture on the monitor. The monitor detects
> something on VM boot, but nothing other than a black screen is
> visible.
>
> There is a "fix" discovered by taoj17v on reddit: Unplug the display
> cables from the GPU, boot the host and then the VM. Once the guest has
> finished booting, connect the cables.
>
> He also points out that it is likely a bug in the firmware.
