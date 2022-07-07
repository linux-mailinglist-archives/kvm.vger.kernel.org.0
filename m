Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED177569C27
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 09:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbiGGHtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 03:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbiGGHsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 03:48:52 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A7C3335B
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 00:48:46 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id x1so21620274qtv.8
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 00:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WcCMAL1dBpnPnrHnoJZNRPNb4eSTDD5OqhKOHuxA/Qg=;
        b=UCk7eweIi10Afexug1hOpHHoN+D5WUwIrPsptXC//j15IhV6ZzbwPJW5uSIF9AGbBu
         t1+LUPCU231+ThX2p4USepnJKMok93iYQ5ZsO6EDFnRpEnvST9uHACq10cxLTKXivwnp
         CG2P39+wbTJkKF/gUOlJjLSvD5f1URLUh9RzPJhIMgiCqHBPzv1EsX8E5ivhP7bFn0rE
         pkPCtsebECg9GM+suVfa4cmQ3ESoFN9VDkiK8B8LC+PMgxR4PS0hRe0CTx6SaxCXkmgY
         PMgBlfJdX7h8+rDPeeafOsF46thmUYZJNMiVCo6n482eKth9fDLOpl+9NXclPGG21xvC
         qe1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WcCMAL1dBpnPnrHnoJZNRPNb4eSTDD5OqhKOHuxA/Qg=;
        b=FqmgorkVVh/JUF5fAdB238TOG/eQaJnogduwKonhXTsOvvnBXKqFBY+x2tF3kfC2w8
         LPMHfh1zrPpsDkvGVmIu6GIrw0QyLEwitsVqbRWDh7jMvOUuuOUNTenodDaz5wZQLD8Y
         Dc+Tq9BmblAFUn/0pjYpum55/r0Ikue6X7AnMqhcF3ZMaWkxgj+ggHo1qEii7xcjX5/Y
         /duoxxTvlCgxINe/y4+FvBVrHifdQQx2s4RO0cf5dHTzCKw85FAyMEcAlUm7472YIaN5
         AwiqWyN9iTbJ/3REBYbExMp2JBoZswZw5aTiWPO9elxNt/AZepB04exI6I/M8fRokaEM
         c1Ow==
X-Gm-Message-State: AJIora9urWneOcUJkOdr4K62eq9MvA5i6efo2QNFay9yp3wR3JuwC5Qc
        ek7APjkb86MbC8UBc4U/qUohe5vIS1taqhR+4EE=
X-Google-Smtp-Source: AGRyM1s587oeqtFOrrJvwIQK+w1KdQANn6VeflRFF0lTr+S9p/+tbfEjRYCoPKIVI4309pkvvq9wCSxPk+XBQi38czQ=
X-Received: by 2002:ad4:594f:0:b0:470:5b16:808 with SMTP id
 eo15-20020ad4594f000000b004705b160808mr40523199qvb.51.1657180125575; Thu, 07
 Jul 2022 00:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAEUhbmWqMPakKs+nYOHiib=U9O6gZpmsBMqhUgaqkLmNe5jr_w@mail.gmail.com>
 <CAK9=C2VEqHfieOVeLPCt66xtp77YgaXk64chuw9Ku0zX4UQABw@mail.gmail.com> <CAM=mAO=RsBi1jERMR3NM9Rc-VBTA7v=AcNPsvwX_zy=dnGDC2g@mail.gmail.com>
In-Reply-To: <CAM=mAO=RsBi1jERMR3NM9Rc-VBTA7v=AcNPsvwX_zy=dnGDC2g@mail.gmail.com>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Thu, 7 Jul 2022 15:48:34 +0800
Message-ID: <CAEUhbmUwqkOSsTAA0ASrAO9xkYeJAe-wDVrZFujebiohjTzZ8g@mail.gmail.com>
Subject: Re: U-Boot S-mode payload does not boot with a multicore
 configuration in RISC-V QEMU/KVM
To:     Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        kvm-riscv@lists.infradead.org, KVM General <kvm@vger.kernel.org>
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

On Thu, Jul 7, 2022 at 2:49 PM Heinrich Schuchardt
<heinrich.schuchardt@canonical.com> wrote:
>
> When removing the pflash driver in U-Boot the blocking occurs for virtio net. If we further remove virtio net, it occurs for virtio blk.
>
> The problem is not flash specific.
>
> Best regards
>
> Heinrich
>
> Anup Patel <apatel@ventanamicro.com> schrieb am Do., 7. Juli 2022, 07:06:
>>
>> On Thu, Jul 7, 2022 at 10:19 AM Bin Meng <bmeng.cn@gmail.com> wrote:
>> >
>> > Hi Anup,
>> >
>> > U-Boot S-mode payload does not boot with RISC-V KVM on the QEMU 'virt'
>> > multicore machine. With QEMU TCG it can boot.
>> >
>> > I am using the latest v5.19-rc5 kernel, along with QEMU 7.0.0 and
>> > U-Boot v2022.04:
>> >
>> > Reproduce steps:
>> >
>> > U-Boot S-mode payload is built from U-Boot v2022.04:
>> > $ make qemu-riscv64_smode_defconfig; make
>> >
>> > The host 5.19-rc5 kernel is running on top of QEMU 7.0.0 on an x86 machine.
>> >
>> > Use QEMU to launch the VM:
>> > # qemu-system-riscv64 -M virt -accel kvm -m 2G -smp 2 -nographic
>> > -kernel u-boot -device virtio-net-device,netdev=eth0 -netdev
>> > user,id=eth0,hostfwd=tcp::8022-:22
>> >
>> > U-Boot gets stuck during boot, logs below:
>> >
>> > U-Boot 2022.04 (Jul 07 2022 - 11:23:28 +0800)
>> > CPU: rv64imafdc
>> > Model: riscv-virtio,qemu
>> > DRAM: 2 GiB
>> > Core: 17 devices, 9 uclasses, devicetree: board
>> > Flash: <========== stuck here, and QEMU is completely unresponsive
>> > (Ctrl+A, C is ignored)
>> >
>> > The kernel reports:
>> >
>> > [ 484.351698] INFO: task qemu-system-ris:1765 blocked for more than 120 seconds.
>> > [ 484.360285] Not tainted 5.19.0-rc5-custom #1
>> > [ 484.360871] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> > disables this message.
>> > [ 484.362560] task:qemu-system-ris state:D stack: 0 pid: 1765 ppid:
>> > 1515 flags:0x00000000
>> > [ 484.363785] Call Trace:
>> > [ 484.363930] [] schedule+0x50/0xb2
>> > [ 484.364758] [] schedule_timeout+0x10c/0x13c
>> > [ 484.364806] [] __wait_for_common+0x148/0x226
>> > [ 484.364840] [] wait_for_completion+0x2e/0x36
>> > [ 484.364871] [] __synchronize_srcu.part.0+0x88/0xe2
>> > [ 484.364918] [] synchronize_srcu_expedited+0x3a/0x44
>> > [ 484.364952] [] kvm_swap_active_memslots+0x186/0x1ea
>> > [ 484.364985] [] kvm_set_memslot+0x1fc/0x39c
>> > [ 484.365014] [] __kvm_set_memory_region+0x144/0x30c
>> > [ 484.365043] [] kvm_vm_ioctl+0x20a/0xc82
>> > [ 484.365075] [] sys_ioctl+0x98/0xb2
>> > [ 484.365135] [] ret_from_syscall+0x0/0x2
>> >
>> > The QEMU vcpu thread backtrace is:
>> >
>> > #0 __GI___ioctl (fd=, request=request@entry=1075883590) at
>> > ../sysdeps/unix/sysv/linux/ioctl.c:35
>> > #1 0x00aaaaaab8b916ae in kvm_vm_ioctl (s=s@entry=0xaaaaaaf1ec3e00,
>> > type=type@entry=1075883590) at ../accel/kvm/kvm-all.c:3035
>> > #2 0x00aaaaaab8b93572 in kvm_set_user_memory_region
>> > (slot=slot@entry=0xffffffaa5d90a0, new=new@entry=false,
>> > kml=0xaaaaaaf1ec4eb0, kml=) at ../accel/kvm/kvm-all.c:379
>> > #3 0x00aaaaaab8b93862 in kvm_set_phys_mem (kml=0xaaaaaaf1ec4eb0,
>> > section=section@entry=0xffffffaa513b70, add=, add@entry=false) at
>> > ../accel/kvm/kvm-all.c:1413
>> > #4 0x00aaaaaab8b93a30 in kvm_region_del (listener=,
>> > section=0xffffffaa513b70) at ../accel/kvm/kvm-all.c:1511
>> > #5 0x00aaaaaab8ad780c in address_space_update_topology_pass
>> > (as=as@entry=0xaaaaaab90b87a0 ,
>> > old_view=old_view@entry=0xaaaaaaf1f42c40,
>> > new_view=new_view@entry=0xffffff1c001400, adding=adding@entry=fa
>> > lse) at ../softmmu/memory.c:948
>> > #6 0x00aaaaaab8ad7a2a in address_space_set_flatview
>> > (as=0xaaaaaab90b87a0 ) at ../softmmu/memory.c:1050
>> > #7 0x00aaaaaab8ada508 in memory_region_transaction_commit () at
>> > ../softmmu/memory.c:1103
>> > #8 0x00aaaaaab8adb6ee in memory_region_rom_device_set_romd
>> > (mr=mr@entry=0xaaaaaaf22d6fe0, romd_mode=romd_mode@entry=false) at
>> > ../softmmu/memory.c:2289
>> > #9 0x00aaaaaab8951e1a in pflash_write (be=0, width=1, value=240,
>> > offset=0, pfl=0xaaaaaaf22d6c30) at ../hw/block/pflash_cfi01.c:451
>> > #10 pflash_mem_write_with_attrs (opaque=0xaaaaaaf22d6c30, addr=0,
>> > value=, len=, attrs=...) at ../hw/block/pflash_cfi01.c:682
>> > #11 0x00aaaaaab8ad5fa2 in access_with_adjusted_size
>> > (addr=addr@entry=0, value=value@entry=0xffffffaa513dc8,
>> > size=size@entry=1, access_size_min=, access_size_max=,
>> > access_fn=0xaaaaaab8ad7d06 <
>> > memory_region_write_with_attrs_accessor>, mr=0xaaaaaaf22d6fe0,
>> > attrs=...) at ../softmmu/memory.c:554
>> > #12 0x00aaaaaab8ad92ba in memory_region_dispatch_write
>> > (mr=mr@entry=0xaaaaaaf22d6fe0, addr=addr@entry=0, data=,
>> > data@entry=240, op=, attrs=attrs@entry=...) at
>> > ../softmmu/memory.c:1521
>> > #13 0x00aaaaaab8adee88 in flatview_write_continue
>> > (fv=fv@entry=0xaaaaaaf1f42c40, addr=addr@entry=536870912,
>> > attrs=attrs@entry=..., ptr=ptr@entry=0xffffffab730028,
>> > len=len@entry=1, addr1=, l=,
>> > mr=0xaaaaaaf22d6fe0) at ../softmmu/physmem.c:2814
>> > #14 0x00aaaaaab8adf0d8 in flatview_write (fv=0xaaaaaaf1f42c40,
>> > addr=536870912, attrs=..., buf=0xffffffab730028, len=len@entry=1) at
>> > ../softmmu/physmem.c:2856
>> > #15 0x00aaaaaab8ae1eca in address_space_write (len=1,
>> > buf=0xffffffab730028, attrs=..., addr=536870912, as=0xaaaaaab90b87a0 )
>> > at ../softmmu/physmem.c:2952
>> > #16 address_space_rw (as=0xaaaaaab90b87a0 , addr=536870912, attrs=...,
>> > attrs@entry=..., buf=buf@entry=0xffffffab730028, len=1, is_write=) at
>> > ../softmmu/physmem.c:2962
>> > #17 0x00aaaaaab8b94a3e in kvm_cpu_exec
>> > (cpu=cpu@entry=0xaaaaaaf1ec92f0) at ../accel/kvm/kvm-all.c:2929
>> > #18 0x00aaaaaab8b95572 in kvm_vcpu_thread_fn
>> > (arg=arg@entry=0xaaaaaaf1ec92f0) at ../accel/kvm/kvm-accel-ops.c:49
>> > #19 0x00aaaaaab8ca280a in qemu_thread_start (args=) at
>> > ../util/qemu-thread-posix.c:556
>> > #20 0x00ffffffab2cf5a6 in start_thread (arg=) at ./nptl/pthread_create.c:442
>> > #21 0x00ffffffab31ba02 in __thread_start () at
>> > ../sysdeps/unix/sysv/linux/riscv/clone.S:85
>> >
>> > Based on above 2 logs, we can see the QEMU vcpu thread is blocked at KVM ioctl
>> > KVM_SET_USER_MEMORY_REGION, and on the kernel side the ioctl call is
>> > blocked at synchronize_srcu_expedited() so that ioctl never returns
>> > back to the user land.
>> >
>> > If I single step the QEMU instance starting from a breakpoint at
>> > pflash_write(), the ioctl call of KVM_SET_USER_MEMORY_REGION does not
>> > block, and U-Boot can boot eventually.
>> >
>> > If I remove "-smp 2" from the QEMU command line when launching the VM,
>> > U-Boot boots without any problem. Of course removing "-accel kvm"
>> > works too.
>> >
>> > It looks to me there is a locking timing issue in the RISC-V KVM
>> > kernel when an SMP guest is launched. Any ideas?
>>
>> To further isolate the problem, does it work if QEMU does not generate
>> the pflash DT node ?

No, and QEMU freezes when U-Boot tries to probe the virtio-net driver,
logs below:

U-Boot 2022.04 (Jul 07 2022 - 11:23:28 +0800)
CPU: rv64imafdc
Model: riscv-virtio,qemu
DRAM: 2 GiB
Core: 16 devices, 8 uclasses, devicetree: board
Loading Environment from nowhere... OK
In: uart@10000000
Out: uart@10000000
Err: uart@10000000
Net: <========== stuck here

Here is the backtrace on the QEMU side, as you can see this time the
VCPU thread is blocked at the ioctl of KVM_IOEVENTFD to KVM.

#0 __GI___ioctl (fd=, request=request@entry=1077980793) at
../sysdeps/unix/sysv/linux/ioctl.c:35
#1 0x00aaaaaae53195f2 in kvm_vm_ioctl (s=0xaaaaab049a3e00,
type=type@entry=1077980793) at ../accel/kvm/kvm-all.c:3035
#2 0x00aaaaaae531a7ae in kvm_set_ioeventfd_mmio (fd=, addr=,
val=val@entry=0, assign=assign@entry=true, size=,
datamatch=datamatch@entry=true) at ../accel/kvm/kvm-all.c:1248
#3 0x00aaaaaae531a946 in kvm_mem_ioeventfd_add (listener=,
section=0xffffff8b949b00, match_data=, data=0, e=) at
../accel/kvm/kvm-all.c:1579
#4 0x00aaaaaae5260a6e in address_space_add_del_ioeventfds
(fds_old_nb=0, fds_old=0x0, fds_new_nb=3, fds_new=0xfffffefc0386d0,
as=0xaaaaaae58407a0 ) at ../softmmu/memory.c:793
#5 address_space_update_ioeventfds (as=0xaaaaaae58407a0 ) at
../softmmu/memory.c:854
#6 0x00aaaaaae52623bc in memory_region_transaction_commit () at
../softmmu/memory.c:1111
#7 0x00aaaaaae52b04b8 in virtio_device_start_ioeventfd_impl
(vdev=0xaaaaab04e24f50) at ../hw/virtio/virtio.c:3723
#8 0x00aaaaaae51d0524 in virtio_bus_start_ioeventfd
(bus=bus@entry=0xaaaaab04bf2e70) at ../hw/virtio/virtio-bus.c:229
#9 0x00aaaaaae51d47ce in virtio_mmio_start_ioeventfd
(proxy=0xaaaaab04bf2a20) at ../hw/virtio/virtio-mmio.c:63
#10 virtio_mmio_write (opaque=0xaaaaab04bf2a20, offset=, value=6,
size=) at ../hw/virtio/virtio-mmio.c:431
#11 0x00aaaaaae525faa4 in memory_region_write_accessor
(mr=0xaaaaab04bf2d40, addr=112, value=, size=, shift=, mask=,
attrs=...) at ../softmmu/memory.c:492
#12 0x00aaaaaae525dee6 in access_with_adjusted_size
(addr=addr@entry=112, value=value@entry=0xffffff8b949dc8,
size=size@entry=4, access_size_min=, access_size_max=,
access_fn=0xaaaaaae525fa2e
, mr=0xaaaaab04bf2d40, attrs=...) at ../softmmu/memory.c:554
#13 0x00aaaaaae52611fe in memory_region_dispatch_write
(mr=mr@entry=0xaaaaab04bf2d40, addr=addr@entry=112, data=,
data@entry=6, op=, attrs=attrs@entry=...) at ../softmmu/memory.c:1521
#14 0x00aaaaaae5266dcc in flatview_write_continue
(fv=fv@entry=0xfffffefc001400, addr=addr@entry=268468336,
attrs=attrs@entry=..., ptr=ptr@entry=0xffffff8cb66028,
len=len@entry=4, addr1=, l=,
mr=0xaaaaab04bf2d40) at ../softmmu/physmem.c:2814
#15 0x00aaaaaae526701c in flatview_write (fv=0xfffffefc001400,
addr=268468336, attrs=..., buf=0xffffff8cb66028, len=len@entry=4) at
../softmmu/physmem.c:2856
#16 0x00aaaaaae5269e0e in address_space_write (len=4,
buf=0xffffff8cb66028, attrs=..., addr=268468336, as=0xaaaaaae58407a0 )
at ../softmmu/physmem.c:2952
#17 address_space_rw (as=0xaaaaaae58407a0 , addr=268468336, attrs=...,
attrs@entry=..., buf=buf@entry=0xffffff8cb66028, len=4, is_write=) at
../softmmu/physmem.c:2962
#18 0x00aaaaaae531c982 in kvm_cpu_exec
(cpu=cpu@entry=0xaaaaab049a92f0) at ../accel/kvm/kvm-all.c:2929
#19 0x00aaaaaae531d4b6 in kvm_vcpu_thread_fn
(arg=arg@entry=0xaaaaab049a92f0) at ../accel/kvm/kvm-accel-ops.c:49
#20 0x00aaaaaae542a74e in qemu_thread_start (args=) at
../util/qemu-thread-posix.c:556
#21 0x00ffffff8c7055a6 in start_thread (arg=) at ./nptl/pthread_create.c:442
#22 0x00ffffff8c751a02 in __thread_start () at
../sysdeps/unix/sysv/linux/riscv/clone.S:85

Regards,
Bin
