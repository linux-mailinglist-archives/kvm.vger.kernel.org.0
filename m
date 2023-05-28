Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187A47138DA
	for <lists+kvm@lfdr.de>; Sun, 28 May 2023 11:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjE1JXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 May 2023 05:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjE1JXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 May 2023 05:23:09 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68975B9;
        Sun, 28 May 2023 02:23:06 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30ac4e7f37bso1299760f8f.2;
        Sun, 28 May 2023 02:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685265785; x=1687857785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v8E+r2XJKDAXZexSMw5ufFmLlUyvRAToLfB8UBiyX+0=;
        b=aIGp92ryRkZGLiaEpa6el1yI0J4mMnFFG8s2p3dAvBLTAP82ELi8zAOWssGx01DWKv
         e6GtVhOdQRcYnXWcsoeUoLxpdRBcxdPxoHcd9RY92TdBMZ+k1tMwMmxzkRmb0Xf5bCMK
         guC1SicERfPUa3xtl4/Gm86Bvl32aUpI8wdS3ExtWvBp2snYAz3D+Z3fiVf9E3SJgLbZ
         wlDB937xmYaXb/YagOp8rEJGwOA2R6ERuiCmO1acCmXwjwNeuF8j7LThxQV0zPCEoS92
         RraoS9hJe2D/U7Hl8y2R+2FhGkslaLoGWoPP8ZADLcJx6T4hgb2SHpTXACs1J/SPLEji
         6Fmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685265785; x=1687857785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v8E+r2XJKDAXZexSMw5ufFmLlUyvRAToLfB8UBiyX+0=;
        b=It/ONXFex6AyeX20LM6VH4kJX4sXns9pXMqWLvf9a/J9nE4MJHNx9nkj72a884lnrt
         mpkDU+xj50XfH8mhukwoKS5zF6X7cI/vz+0RgZ0ORBPvM1Gk3eIOiv94kw167JSD+Oi9
         IqM/ouD4iP+HzIht+1t0Zu9sxE1x4FEYjLt3auR117kTzQNfezLDC2lEf2pTxSVcNVcn
         YMfjyp3A5mzixAL2gEKOjEEK9dxP3DayEHa7CfbrTqdELRCnNhKO/8GnjCI9AjzT4e3R
         KtD3cEJqTC+29eh6iyFZ+x4XaoBZcFm+O1Cr2fcM6AefwMGdTL4HWnC+v7gb4nXl1ggS
         WJuw==
X-Gm-Message-State: AC+VfDwWUX7onzNHGMM3IWwb3k3br3dnQFTBaR/9HNl1VlBvtu+FRWbI
        fe7VJPJ7ox0eTXWHWJL2TFso1ROCmEpnBNJkaDKwVkFuAxTawA==
X-Google-Smtp-Source: ACHHUZ5O0jwMS9zNw85y81/3ILSVrj+GraKAxGyzI4F92v7xYacSBCYWOiwc6ZiDnbHKB22Lkruwc0jj8I/g5bsSIfA=
X-Received: by 2002:adf:d089:0:b0:306:297b:927f with SMTP id
 y9-20020adfd089000000b00306297b927fmr5973224wrh.25.1685265784515; Sun, 28 May
 2023 02:23:04 -0700 (PDT)
MIME-Version: 1.0
References: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
 <ZHDl6rXQ0UTWdk2O@google.com>
In-Reply-To: <ZHDl6rXQ0UTWdk2O@google.com>
From:   Fabio Coatti <fabio.coatti@gmail.com>
Date:   Sun, 28 May 2023 11:22:53 +0200
Message-ID: <CADpTngWQUqOF6c-nSrUShCvmHeUu380973Dm0zVwTY62TS7wHA@mail.gmail.com>
Subject: Re: WARNING trace at kvm_nx_huge_page_recovery_worker on 6.3.4
To:     Sean Christopherson <seanjc@google.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Il giorno ven 26 mag 2023 alle ore 19:01 Sean Christopherson
<seanjc@google.com> ha scritto:

> > I'm using vanilla kernels on a gentoo-based laptop and since 6.3.2
>
> What was the last kernel you used that didn't trigger this WARN?

6.3.1

>
> > I'm getting the kernel log  below when using kvm VM on my box.
>
> Are you doing anything "interesting" when the WARN fires, or are you just running
> the VM and it random fires?  Either way, can you provide your QEMU command line?

I'm not able to spot a specific action that triggers the dump. Now it
happened when I was "simply" opening a new chrome page in the guest
VM. I guess this can cause some work on mm side, but not really an
"interesting" action, I'd say. Basically, I fired up the guest machine
(ubuntu 22.04 very basic) on a newly rebooted host, connected a USB
device (yubikey) and started chrome. No message just after starting
chrome, only when I opened a new page.

Anyway, this is the command line (libvirt managed VM)

/usr/sbin/qemu-system-x86_64 -name guest=ubuntu-u2204-kvm,debug-threads=on -S
-object {"qom-type":"secret","id":"masterKey0","format":"raw","file":"/var/lib/libvirt/qemu/domain-1-ubuntu-u2204-kvm/master-key.aes"}
-blockdev {"driver":"file","filename":"/usr/share/edk2-ovmf/OVMF_CODE.secboot.fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}
-blockdev {"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","file":"libvirt-pflash0-storage"}
-blockdev {"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/ubuntu-u2204-kvm_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"discard":"unmap"}
-blockdev {"node-name":"libvirt-pflash1-format","read-only":false,"driver":"raw","file":"libvirt-pflash1-storage"}
-machine pc-q35-7.1,usb=off,vmport=off,smm=on,dump-guest-core=off,memory-backend=pc.ram,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-format,hpet=off,acpi=on
-accel kvm
-cpu host,migratable=on
-global driver=cfi.pflash01,property=secure,value=on
-m 16384
-object {"qom-type":"memory-backend-ram","id":"pc.ram","size":17179869184}
-overcommit mem-lock=off
-smp 4,sockets=4,cores=1,threads=1
-uuid 160141fc-ec2e-4d91-bc1c-3e597643bcfd
-no-user-config
-nodefaults
-chardev socket,id=charmonitor,fd=30,server=on,wait=off
-mon chardev=charmonitor,id=monitor,mode=control
-rtc base=utc,driftfix=slew
-global kvm-pit.lost_tick_policy=delay
-no-shutdown
-global ICH9-LPC.disable_s3=1
-global ICH9-LPC.disable_s4=1
-boot strict=on
-device {"driver":"pcie-root-port","port":16,"chassis":1,"id":"pci.1","bus":"pcie.0","multifunction":true,"addr":"0x2"}
-device {"driver":"pcie-root-port","port":17,"chassis":2,"id":"pci.2","bus":"pcie.0","addr":"0x2.0x1"}
-device {"driver":"pcie-root-port","port":18,"chassis":3,"id":"pci.3","bus":"pcie.0","addr":"0x2.0x2"}
-device {"driver":"pcie-root-port","port":19,"chassis":4,"id":"pci.4","bus":"pcie.0","addr":"0x2.0x3"}
-device {"driver":"pcie-root-port","port":20,"chassis":5,"id":"pci.5","bus":"pcie.0","addr":"0x2.0x4"}
-device {"driver":"pcie-root-port","port":21,"chassis":6,"id":"pci.6","bus":"pcie.0","addr":"0x2.0x5"}
-device {"driver":"pcie-root-port","port":22,"chassis":7,"id":"pci.7","bus":"pcie.0","addr":"0x2.0x6"}
-device {"driver":"pcie-root-port","port":23,"chassis":8,"id":"pci.8","bus":"pcie.0","addr":"0x2.0x7"}
-device {"driver":"pcie-root-port","port":24,"chassis":9,"id":"pci.9","bus":"pcie.0","multifunction":true,"addr":"0x3"}
-device {"driver":"pcie-root-port","port":25,"chassis":10,"id":"pci.10","bus":"pcie.0","addr":"0x3.0x1"}
-device {"driver":"pcie-root-port","port":26,"chassis":11,"id":"pci.11","bus":"pcie.0","addr":"0x3.0x2"}
-device {"driver":"pcie-root-port","port":27,"chassis":12,"id":"pci.12","bus":"pcie.0","addr":"0x3.0x3"}
-device {"driver":"pcie-root-port","port":28,"chassis":13,"id":"pci.13","bus":"pcie.0","addr":"0x3.0x4"}
-device {"driver":"pcie-root-port","port":29,"chassis":14,"id":"pci.14","bus":"pcie.0","addr":"0x3.0x5"}
-device {"driver":"qemu-xhci","p2":15,"p3":15,"id":"usb","bus":"pci.2","addr":"0x0"}
-device {"driver":"virtio-serial-pci","id":"virtio-serial0","bus":"pci.3","addr":"0x0"}
-blockdev {"driver":"file","filename":"/var/lib/libvirt/images/ubuntu22.04.qcow2","node-name":"libvirt-2-storage","auto-read-only":true,"discard":"unmap"}
-blockdev {"node-name":"libvirt-2-format","read-only":false,"discard":"unmap","driver":"qcow2","file":"libvirt-2-storage","backing":null}
-device {"driver":"virtio-blk-pci","bus":"pci.4","addr":"0x0","drive":"libvirt-2-format","id":"virtio-disk0","bootindex":1}
-device {"driver":"ide-cd","bus":"ide.0","id":"sata0-0-0"} -netdev
{"type":"tap","fd":"32","vhost":true,"vhostfd":"34","id":"hostnet0"}
-device {"driver":"virtio-net-pci","netdev":"hostnet0","id":"net0","mac":"52:54:00:17:0a:44","bus":"pci.1","addr":"0x0"}
-chardev pty,id=charserial0 -device
{"driver":"isa-serial","chardev":"charserial0","id":"serial0","index":0}
-chardev socket,id=charchannel0,fd=28,server=on,wait=off
-device {"driver":"virtserialport","bus":"virtio-serial0.0","nr":1,"chardev":"charchannel0","id":"channel0","name":"org.qemu.guest_agent.0"}
-chardev spicevmc,id=charchannel1,name=vdagent -device
{"driver":"virtserialport","bus":"virtio-serial0.0","nr":2,"chardev":"charchannel1","id":"channel1","name":"com.redhat.spice.0"}
-device {"driver":"usb-tablet","id":"input0","bus":"usb.0","port":"1"}
-audiodev {"id":"audio1","driver":"spice"}
-spice port=0,disable-ticketing=on,image-compression=off,seamless-migration=on
-device {"driver":"virtio-vga","id":"video0","max_outputs":1,"bus":"pcie.0","addr":"0x1"}
-device {"driver":"ich9-intel-hda","id":"sound0","bus":"pcie.0","addr":"0x1b"}
-device {"driver":"hda-duplex","id":"sound0-codec0","bus":"sound0.0","cad":0,"audiodev":"audio1"}
-global ICH9-LPC.noreboot=off
-watchdog-action reset
-chardev spicevmc,id=charredir0,name=usbredir
-device {"driver":"usb-redir","chardev":"charredir0","id":"redir0","bus":"usb.0","port":"2"}
-chardev spicevmc,id=charredir1,name=usbredir
-device {"driver":"usb-redir","chardev":"charredir1","id":"redir1","bus":"usb.0","port":"3"}
-device {"driver":"virtio-balloon-pci","id":"balloon0","bus":"pci.5","addr":"0x0"}
-object {"qom-type":"rng-random","id":"objrng0","filename":"/dev/urandom"}
-device {"driver":"virtio-rng-pci","rng":"objrng0","id":"rng0","bus":"pci.6","addr":"0x0"}
-sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
-msg timestamp=on

ps output (of course a different run from the first message report):
     57176 ?        I<     0:00 [kvm]
     57178 ?        S      0:00 [kvm-nx-lpage-recovery-57159]
     57189 ?        S      0:00 [kvm-pit/57159]


> > Not sure which other infos can be relevant in this context; if you
> > need more details just let me know, happy to provide them.
> >
> > [Fri May 26 09:16:35 2023] ------------[ cut here ]------------
> > [Fri May 26 09:16:35 2023] WARNING: CPU: 5 PID: 4684 at
> > kvm_nx_huge_page_recovery_worker+0x38c/0x3d0 [kvm]
>
> Do you have the actual line number for the WARN?  There are a handful of sanity
> checks in kvm_recover_nx_huge_pages(), it would be helpful to pinpoint which one
> is firing.  My builds generate quite different code, and the code stream doesn't
> appear to be useful for reverse engineering the location.

That's the full message I get. Maybe I should recompile the host
kernel with some debug active, any specific suggestion?



-- 
Fabio
