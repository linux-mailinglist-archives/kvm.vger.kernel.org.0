Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934107344A5
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 04:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjFRCNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jun 2023 22:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjFRCNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jun 2023 22:13:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A181CC7E;
        Sat, 17 Jun 2023 19:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2473760B46;
        Sun, 18 Jun 2023 02:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED63C433CA;
        Sun, 18 Jun 2023 02:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687054394;
        bh=8ltl6gAF/xJMmCjTVB9X8KzKmK4m8dyrdi7Zuk8ziOY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ppd8CLvaM9ueomrks5xcIVr1DBhZ//ZEM2Ab1roD3n2FY+IxCnl1/WbR1g3LyVCDu
         eT/18xRhC/nPymynPzA1pTTuIm+/Y5TXijKHV0jw48ei8N0HCbDOJ8kXJQ+ueV6JvI
         09qikDhtnEItWkN+SN/aZ31+Qo9l1mL6WrgV1Qnb7Nv97TIK9azGGMiDnOVTvdQTST
         5XlIMdbj6qhRWbqPTZWSWzvbYvyDg29MWBJF4PZ8rDyHtga6EOOzN69y9LoghhYsxR
         CCsByXRIviMfwbhNl+cfq0e/WEGiY4TBwPEHpNQSFQdCFVvfDX52Qx4upwnLIT4uFH
         7O3irqqNEatWw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-986d871a9beso248011066b.1;
        Sat, 17 Jun 2023 19:13:14 -0700 (PDT)
X-Gm-Message-State: AC+VfDyVnFk/CuN2zu6FPPEpRtn4QCFeGn6JhfSodv/1yLCLuaH1Z0WF
        w364qpj8NqkSYun2T/09ZLrZAQd+Pf6DB5AOJOo=
X-Google-Smtp-Source: ACHHUZ46artzFS1SO3jhQSnz0ewaSpw9FP38kkj3VN0lzdxwxlivMRSNofWcoisieHqz0VkbLVUhOUKn5ujs/6AfBQ0=
X-Received: by 2002:a17:907:9450:b0:974:86a7:d3a3 with SMTP id
 dl16-20020a170907945000b0097486a7d3a3mr6278161ejc.13.1687054392649; Sat, 17
 Jun 2023 19:13:12 -0700 (PDT)
MIME-Version: 1.0
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
 <20230616071831.1452507-1-yuzhao@google.com> <20230616082322.GA7323@alpha.franken.de>
 <ZI0R76Fx25Q2EThZ@google.com>
In-Reply-To: <ZI0R76Fx25Q2EThZ@google.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Sun, 18 Jun 2023 10:13:00 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Hdw6Ye46OOoNyXtZfO9smMiPz+hRLq8vEvmgQCMGuFQ@mail.gmail.com>
Message-ID: <CAAhV-H7Hdw6Ye46OOoNyXtZfO9smMiPz+hRLq8vEvmgQCMGuFQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
To:     Yu Zhao <yuzhao@google.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, pbonzini@redhat.com, robh+dt@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Zhao,

I have reproduced the problem, and I hope I can fix it in a few days,
of course you can also try to do that. :)

Huacai

On Sat, Jun 17, 2023 at 9:52=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrote:
>
> On Fri, Jun 16, 2023 at 10:23:22AM +0200, Thomas Bogendoerfer wrote:
> > On Fri, Jun 16, 2023 at 01:18:31AM -0600, Yu Zhao wrote:
> > > On Tue, Jul 28, 2020 at 23:58:20PM -0700, Huacai Chen wrote:
> > > > James Hogan has become inactive for a long time and leaves KVM for =
MIPS
> > > > orphan. I'm working on KVM/Loongson and attempt to make it upstream=
 both
> > > > in kernel and QEMU, while Aleksandar Markovic is already a maintain=
er of
> > > > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have alr=
eady
> > > > made some contributions in kernel and QEMU. If possible, we want to=
 take
> > > > the KVM/MIPS maintainership.
> > > >
> > > > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > > > ---
> > > >  MAINTAINERS | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index bddc79a..5f9c2fd 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -9441,9 +9441,11 @@ F: arch/arm64/kvm/
> > > >  F:       include/kvm/arm_*
> > > >
> > > >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > > > +M:       Huacai Chen <chenhc@lemote.com>
> > > > +M:       Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > > >  L:       linux-mips@vger.kernel.org
> > > >  L:       kvm@vger.kernel.org
> > > > -S:       Orphan
> > > > +S:       Maintained
> > > >  F:       arch/mips/include/asm/kvm*
> > > >  F:       arch/mips/include/uapi/asm/kvm*
> > > >  F:       arch/mips/kvm/
> > >
> > > Hi,
> > >
> > > Is kvm/mips still maintained? Thanks.
> > >
> > > I tried v6.4-rc6 and hit the following crash. It seems it has been br=
oken since
> > >
> > >   commit 45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
> > >   Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > >   Date:   Mon Mar 1 16:29:57 2021 +0100
> > >
> > >       MIPS: Remove KVM_TE support
> >
> > ok, I see what I missed when removing TE support, d'oh. Does the patch
> > below fix the issue for you ?
>
> Thanks!
>
> It made some progress but somehow crashed the guest kernel.
>
> $ qemu-system-mips64el --version
> QEMU emulator version 7.2.2 (Debian 1:7.2+dfsg-7)
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
>
> # w/o KVM
>
>   # malta: working (but slow)
>
>     $ qemu-system-mips64el -nographic -kernel lede-malta-le64-vmlinux-ini=
tramfs.elf
>     [    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc version 5.=
5.0 (LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017
>     ...
>
>   # loongson3-virt: hanged
>
>     $ qemu-system-mips64el -M loongson3-virt -m 512m -nographic -kernel v=
mlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
>     [    0.000000] Linux version 6.1.0-9-loongson-3 (debian-kernel@lists.=
debian.org) (gcc-12 (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Deb=
ian) 2.40) #1 SMP PREEMPT Debian 6.1.27-1 (2023-05-08)
>     ...
>     [    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000=
09fffffff]
>
> # w/ KVM
>
>   # malta: qemu error
>
>     $ sudo qemu-system-mips64el -M accel=3Dkvm -nographic -kernel lede-ma=
lta-le64-vmlinux-initramfs.elf
>     qemu-system-mips64el: KVM guest kernels must be linked in useg. Did y=
ou forget to enable CONFIG_KVM_GUEST?
>
>   # loongson3-virt: qemu error
>
>     $ sudo qemu-system-mips64el -M loongson3-virt,accel=3Dkvm -m 512m -no=
graphic -kernel vmlinuz-6.1.0-9-loongson-3 -initrd initrd.gz
>     qemu-system-mips64el: ../../accel/kvm/kvm-all.c:2310: kvm_init: Asser=
tion `TARGET_PAGE_SIZE <=3D qemu_real_host_page_size()' failed.
>     Aborted
>
> $ qemu-system-mips64el --version
> QEMU emulator version 8.0.2 (Debian 1:8.0.2+dfsg-1)
> Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
>
> # w/o KVM
>
>   # malta: no change
>   # loongson3-virt: no change
>
> # w/ KVM
>
>   # loongson3-virt: the same qemu error
>
>   # malta: booted very fast but guest crashed:
>
> $ sudo qemu-system-mips64el -M accel=3Dkvm -nographic -kernel lede-malta-=
le64-vmlinux-initramfs.elf
> [    0.000000] Linux version 4.9.58 (buildbot@builds) (gcc version 5.5.0 =
(LEDE GCC 5.5.0 r5218-f90f94d) ) #0 SMP Wed Nov 1 21:08:14 2017
> [    0.000000] earlycon: uart8250 at I/O port 0x3f8 (options '38400n8')
> [    0.000000] bootconsole [uart8250] enabled
> [    0.000000] Config serial console: console=3DttyS0,38400n8r
> [    0.000000] CPU0 revision is: 000d9602 (Cavium Octeon III)
> [    0.000000] FPU revision is: 00739600
> [    0.000000] Checking for the multiply/shift bug... [    0.000000] no.
> [    0.000000] Checking for the daddiu bug... [    0.000000] no.
> [    0.000000] MIPS: machine is mti,malta
> [    0.000000] Software DMA cache coherency enabled
> [    0.000000] Determined physical RAM map:
> [    0.000000]  memory: 0000000008000000 @ 0000000000000000 (usable)
> [    0.000000] Initrd not found or empty - disabling initrd
> [    0.000000] Primary instruction cache 16kB, VIVT, 8-way, linesize 128 =
bytes.
> [    0.000000] Primary data cache 8kB, 8-way, VIPT, no aliases, linesize =
128 bytes
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000000000-0x0000000000ffffff]
> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000000000-0x0000000007ffffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000007f=
fffff]
> [    0.000000] percpu: Embedded 18 pages/cpu @80000000011c5000 s33120 r81=
92 d32416 u73728
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 32320
> [    0.000000] Kernel command line:  console=3DttyS0,38400n8r
> [    0.000000] PID hash table entries: 512 (order: 0, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 16384 (order: 5, 131072 b=
ytes)
> [    0.000000] Inode-cache hash table entries: 8192 (order: 4, 65536 byte=
s)
> [    0.000000] Memory: 114464K/131072K available (4299K kernel code, 322K=
 rwdata, 1168K rodata, 7368K init, 295K bss, 16608K reserved, 0K cma-reserv=
ed)
> [    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1,=
 Nodes=3D1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 32
> [    0.000000]  RCU restricting CPUs from NR_CPUS=3D2 to nr_cpu_ids=3D1.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D1
> [    0.000000] NR_IRQS:256
> [    0.000000] CPU frequency 1999.99 MHz
> [    0.000000] clocksource: MIPS: mask: 0xffffffff max_cycles: 0xffffffff=
, max_idle_ns: 1911270662 ns
> [    0.000007] sched_clock: 32 bits at 999MHz, resolution 1ns, wraps ever=
y 2147494911ns
> [    0.003394] Console: colour dummy device 80x25
> [    0.004942] Calibrating delay loop... 653.72 BogoMIPS (lpj=3D3268608)
> [    0.276221] pid_max: default: 32768 minimum: 301
> [    0.277862] Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
> [    0.280038] Mountpoint-cache hash table entries: 512 (order: 0, 4096 b=
ytes)
> [    0.284299] Checking for the daddi bug... [    0.286094] no.
> [    0.289633] Brought up 1 CPUs
> [    0.292878] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffff=
fff, max_idle_ns: 19112604462750000 ns
> [    0.296595] futex hash table entries: 256 (order: 2, 16384 bytes)
> [    0.299743] CPU 0 Unable to handle kernel paging request at virtual ad=
dress c000000000002002, epc =3D=3D ffffffff804445d4, ra =3D=3D ffffffff8044=
4cb8
> [    0.303942] Oops[#1]:
> [    0.304738] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.9.58 #0
> [    0.307060] task: 8000000007c58000 task.stack: 8000000007c54000
> [    0.309171] $ 0   : 0000000000000000 0000000000000000 0000000000000042=
 80000000011cf1a8
> [    0.312027] $ 4   : c000000000002000 0000000000000000 0000000000000000=
 0000000000000001
> [    0.314882] $ 8   : 0000000000000006 c000000000002238 0000000e00000030=
 0000000800000054
> [    0.317913] $12   : 0000000004000015 ffffffff80326c1c 0000000000000000=
 0000000e00000028
> [    0.320774] $16   : c000000000002000 0000000000000210 8000000007c57d90=
 ffffffff8067b730
> [    0.323622] $20   : ffffffff80680000 ffffffff806e5298 ffffffff806ae2b0=
 ffffffff80de0000
> [    0.326675] $24   : 0000000000000000 ffffffff8016036c
> [    0.329539] $28   : 8000000007c54000 8000000007c57cf0 ffffffff80de0000=
 ffffffff80444cb8
> [    0.332388] Hi    : 0000000000000000
> [    0.333656] Lo    : 00000000001b4760
> [    0.335001] epc   : ffffffff804445d4 bpf_prepare_filter+0x2c/0x674
> [    0.337394] ra    : ffffffff80444cb8 bpf_prog_create+0x9c/0xdc
> [    0.339461] Status: 140027e3 KX SX UX KERNEL EXL IE
> [    0.341260] Cause : 0080004c (ExcCode 13)
> [    0.342683] PrId  : 000d9602 (Cavium Octeon III)
> [    0.344321] Modules linked in:
> [    0.345617] Process swapper/0 (pid: 1, threadinfo=3D8000000007c54000, =
task=3D8000000007c58000, tls=3D0000000000000000)
> [    0.349216] Stack : ffffffff806ae2b0 c000000000002000 00000000024080c2=
 0000000000001000
> [    0.352066]         c000000000002000 0000000000000210 8000000007c57d90=
 ffffffff8067b730
> [    0.354914]         ffffffff80680000 ffffffff806e5298 ffffffff806ae2b0=
 ffffffff80de0000
> [    0.357959]         ffffffff80de0000 ffffffff80444cb8 ffffffff80680000=
 0000000000000000
> [    0.360809]         ffffffff806a0000 0000000000000000 ffffffff806d4848=
 ffffffff806cce20
> [    0.363664]         ffffffff80680042 ffffffff806dfdb0 ffffffff806a0000=
 ffffffff806cc1b0
> [    0.366714]         ffffffff80680000 ffffffff80680000 ffffffff806cc108=
 ffffffff80100608
> [    0.369591]         0000000000000001 0000000000000000 0000000000000000=
 ffffffff80555660
> [    0.372440]         ffffffff805f6338 ffffffff805f0000 0000000000000061=
 0000000000000002
> [    0.375490]         ffffffff806d4888 000000000004093a 0000000000000061=
 0000000000000002
> [    0.378343]         ...
> [    0.379220] Call Trace:
> [    0.380111] [<ffffffff804445d4>] bpf_prepare_filter+0x2c/0x674
> [    0.382177] [<ffffffff80444cb8>] bpf_prog_create+0x9c/0xdc
> [    0.384160] [<ffffffff806cce20>] ptp_classifier_init+0x2c/0x3c
> [    0.386465] [<ffffffff806cc1b0>] sock_init+0xa8/0xc0
> [    0.388276] [<ffffffff80100608>] do_one_initcall+0xa8/0x180
> [    0.390289] [<ffffffff806aede0>] kernel_init_freeable+0x180/0x234
> [    0.392482] [<ffffffff8052aa38>] kernel_init+0x10/0x10c
> [    0.394372] [<ffffffff801062e8>] ret_from_kernel_thread+0x14/0x1c
> [    0.396780] Code: ffb10028  ffb00020  ffbe0060 <90820002> 00808025  30=
4200fe  a0820002  fc800020  64920028
> [    0.400307]
> [    0.401013] ---[ end trace 7278246801a7bc60 ]---
> [    0.402570] Kernel panic - not syncing: Fatal exception
> [    0.404311] Rebooting in 1 seconds..
> [    2.385408] Reboot failed -- System halted
>
> openwrt/malta: https://downloads.openwrt.org/snapshots/targets/malta/le64=
/
> debian/loongson-3: https://deb.debian.org/debian/dists/sid/main/installer=
-mips64el/current/images/
> debian/malta: not working
