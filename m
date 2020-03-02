Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B47A3175461
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 08:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgCBHVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 02:21:49 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42541 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCBHVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 02:21:49 -0500
Received: by mail-oi1-f194.google.com with SMTP id l12so9318693oil.9;
        Sun, 01 Mar 2020 23:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XDeCfi9XJqeuRf7rLMn7Ijrhku3XoT1qJXxLkqVDdTc=;
        b=ppRCtyID7JZCImPAe2rbGkkXKOWJXunFds2P8SvtF3DXoy/FdX5OuSjpEcEHANk5iA
         A9AhC62zi89J3JlT3jmGV7Vu6PggcdBBJaamHoSJ67dIKLKIcbqCgCmCFtpucNOz50SX
         AbmSBDnayKgO6ckZIcOVqlhVIlmoI0313ytSUv+WmWt4+t7r6SOKP6krLpwAuC92o/Ih
         Fp5J3kXYxqUqVCu6xqd5/GpxKf/YCY49IB71RMEmPyS0Xp9VxiUsex+9J50wDcotaKRl
         OR6E+SAtrPEb6oH3T48itog0mtI0AZKGWLu9SmhiIYnkyw921SVLrdRtr44ETLaemQdW
         vYVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XDeCfi9XJqeuRf7rLMn7Ijrhku3XoT1qJXxLkqVDdTc=;
        b=fmk4M0ml5fTwa2jD9Ito75S5cMmJrXrOB6NodmG7PBaVvHBHYRsipxlnYwCmRkmtsZ
         pbeR+BWGihP+KQ3u+uH/D3zLhjAz6gWFFWaGiDTI97sI2ypou9hj97STBnKv+AxFm3v5
         gIoXlz/YQErUDPZSQeRDbUaFeGzJ7HNtyAYwUVokviLV0fneWVy4MP3Vm5rC4ZJVAG30
         WLRk3vfIkTzVv1T+h/PqObHk5pHcXlwwsU+rFoEz6/+ptyxEqfuU2KceqTwZtBcqLb+K
         9CewKSaI6NhBKjHSgO/YqCdU9ibV4+fOudBg8BNW2cgu1vJKHzTYYyzV5TdKo9aN7ukl
         PERQ==
X-Gm-Message-State: APjAAAU6EQNT6iLhMO1Ub2yXkILzO6iNLqv95qFpSL0DXecFf7ptuZVw
        hi2VB4ApkjQevzKrIFxu56+OF4TUvUUF9EEjEiY=
X-Google-Smtp-Source: APXvYqywUSsgAcoIJ3kTyjZ+CkbIbsjsoWciDWJmvR3IX5LsEObDZCKbXEO8WGJHZ38fVBwMsEPXYThV4qebz8r8iQ8=
X-Received: by 2002:aca:44d7:: with SMTP id r206mr10804247oia.33.1583133706573;
 Sun, 01 Mar 2020 23:21:46 -0800 (PST)
MIME-Version: 1.0
References: <1583089390-36084-1-git-send-email-pbonzini@redhat.com> <CA+G9fYtYqEbH9AUtVr744BKxLq0s1YuD=_kT9Ej=85dteHME4Q@mail.gmail.com>
In-Reply-To: <CA+G9fYtYqEbH9AUtVr744BKxLq0s1YuD=_kT9Ej=85dteHME4Q@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 2 Mar 2020 15:21:35 +0800
Message-ID: <CANRm+CyYLQ45wK86odRcDNpQfpgytnH-2qKoChi6w90byN624w@mail.gmail.com>
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 5.6-rc4 (or rc5)
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Anders Roxell <anders.roxell@linaro.org>, oupton@google.com,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2 Mar 2020 at 13:39, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Mon, 2 Mar 2020 at 00:33, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > Linus,
> >
> > The following changes since commit a93236fcbe1d0248461b29c0f87cb0b510c94e6f:
> >
> >   KVM: s390: rstify new ioctls in api.rst (2020-02-24 19:28:40 +0100)
> >
> > are available in the git repository at:
> >
> >   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
> >
> > for you to fetch changes up to 86f7e90ce840aa1db407d3ea6e9b3a52b2ce923c:
> >
> >   KVM: VMX: check descriptor table exits on instruction emulation (2020-03-01 19:26:31 +0100)
> >
> > ----------------------------------------------------------------
> > More bugfixes, including a few remaining "make W=1" issues such
> > as too large frame sizes on some configurations.  On the
> > ARM side, the compiler was messing up shadow stacks between
> > EL1 and EL2 code, which is easily fixed with __always_inline.
> >
> > ----------------------------------------------------------------
> > Christian Borntraeger (1):
> >       KVM: let declaration of kvm_get_running_vcpus match implementation
> >
> > Erwan Velu (1):
> >       kvm: x86: Limit the number of "kvm: disabled by bios" messages
> >
> > James Morse (3):
> >       KVM: arm64: Ask the compiler to __always_inline functions used at HYP
> >       KVM: arm64: Define our own swab32() to avoid a uapi static inline
> >       arm64: Ask the compiler to __always_inline functions used by KVM at HYP
> >
> > Jeremy Cline (1):
> >       KVM: arm/arm64: Fix up includes for trace.h
> >
> > Mark Rutland (1):
> >       kvm: arm/arm64: Fold VHE entry/exit work into kvm_vcpu_run_vhe()
> >
> > Oliver Upton (1):
> >       KVM: VMX: check descriptor table exits on instruction emulation
> >
> > Paolo Bonzini (4):
> >       KVM: SVM: allocate AVIC data structures based on kvm_amd module parameter
> >       KVM: allow disabling -Werror
> >       KVM: x86: avoid useless copy of cpufreq policy
> >       Merge tag 'kvmarm-fixes-5.6-1' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
> >
> > Valdis Kletnieks (1):
> >       KVM: x86: allow compiling as non-module with W=1
> >
> > Wanpeng Li (2):
> >       KVM: Introduce pv check helpers
> >       KVM: Pre-allocate 1 cpumask variable per cpu for both pv tlb and pv ipis
>
> Kernel panic noticed on latest Linux mainline kernel.
> qemu_x86_64 boot failed due to kernel panic.
> Please investigate this problem.
>

Just give a quick shot. https://lkml.org/lkml/2020/3/2/78

> Meanwhile we will also investigate by using git bisect to identify bad patch.
>
> /usr/bin/qemu-system-x86_64 -cpu host -enable-kvm -nographic \
>  -net nic,model=virtio,macaddr=DE:AD:BE:EF:66:05 -net tap \
> -m 1024 -monitor none -kernel
> bzImage--5.5+git0+98d54f81e3-r0-intel-corei7-64-20200301225337-2502.bin
> \
> --append "root=/dev/sda  rootwait console=ttyS0,115200" \
>  -hda rpb-console-image-lkft-intel-corei7-64-20200301225337-2502.rootfs.ext4 \
>  -m 4096 -smp 4 -nographic \
>  -drive format=qcow2,file=lava-guest.qcow2,media=disk,if=virtio,id=lavatest
>
> [    0.000000] Linux version 5.6.0-rc4 (oe-user@oe-host) (gcc version
> 7.3.0 (GCC)) #1 SMP Sun Mar 1 22:59:08 UTC 2020
> <trim>
> [    0.762542] kvm: no hardware support
> [    0.763123] BUG: kernel NULL pointer dereference, address: 000000000000028c
> [    0.763425] #PF: supervisor read access in kernel mode
> [    0.763425] #PF: error_code(0x0000) - not-present page
> [    0.763425] PGD 0 P4D 0
> [    0.763425] Oops: 0000 [#1] SMP NOPTI
> [    0.763425] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0-rc4 #1
> [    0.763425] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [    0.763425] RIP: 0010:kobject_put+0x12/0x1c0
> [    0.763425] Code: 4a 01 89 d0 f0 0f b1 0f 75 ef 89 d1 eb d9 66 2e
> 0f 1f 84 00 00 00 00 00 48 85 ff 0f 84 bd 00 00 00 55 48 89 e5 41 55
> 41 54 53 <f6> 47 3c 01 48 89 fb 74 22 48 8d 7b 38 b8 ff ff ff ff f0 0f
> c1 43
> [    0.763425] RSP: 0018:ffffbd2800013de8 EFLAGS: 00010206
> [    0.763425] RAX: 0000000000000000 RBX: ffffffff996e9660 RCX: 0000000000000000
> [    0.763425] RDX: 0000000000000046 RSI: 0000000000000006 RDI: 0000000000000250
> [    0.763425] RBP: ffffbd2800013e00 R08: 0000000000000000 R09: 0000000000000000
> [    0.763425] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [    0.763425] R13: 0000000000003ad0 R14: 0000000000000000 R15: ffffffff99a896be
> [    0.763425] FS:  0000000000000000(0000) GS:ffff92ec7bc00000(0000)
> knlGS:0000000000000000
> [    0.763425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.763425] CR2: 000000000000028c CR3: 0000000049c10000 CR4: 00000000003406f0
> [    0.763425] Call Trace:
> [    0.763425]  cpufreq_cpu_put+0x15/0x20
> [    0.763425]  kvm_arch_init+0x1f6/0x2b0
> [    0.763425]  kvm_init+0x31/0x290
> [    0.763425]  ? svm_check_processor_compat+0xd/0xd
> [    0.763425]  ? svm_check_processor_compat+0xd/0xd
> [    0.763425]  svm_init+0x21/0x23
> [    0.763425]  do_one_initcall+0x61/0x2f0
> [    0.763425]  ? rdinit_setup+0x30/0x30
> [    0.763425]  ? rcu_read_lock_sched_held+0x4f/0x80
> [    0.763425]  kernel_init_freeable+0x219/0x279
> [    0.763425]  ? rest_init+0x250/0x250
> [    0.763425]  kernel_init+0xe/0x110
> [    0.763425]  ret_from_fork+0x27/0x50
> [    0.763425] Modules linked in:
> [    0.763425] CR2: 000000000000028c
> [    0.763425] ---[ end trace 239abf40c55c409b ]---
> [    0.763425] RIP: 0010:kobject_put+0x12/0x1c0
> [    0.763425] Code: 4a 01 89 d0 f0 0f b1 0f 75 ef 89 d1 eb d9 66 2e
> 0f 1f 84 00 00 00 00 00 48 85 ff 0f 84 bd 00 00 00 55 48 89 e5 41 55
> 41 54 53 <f6> 47 3c 01 48 89 fb 74 22 48 8d 7b 38 b8 ff ff ff ff f0 0f
> c1 43
> [    0.763425] RSP: 0018:ffffbd2800013de8 EFLAGS: 00010206
> [    0.763425] RAX: 0000000000000000 RBX: ffffffff996e9660 RCX: 0000000000000000
> [    0.763425] RDX: 0000000000000046 RSI: 0000000000000006 RDI: 0000000000000250
> [    0.763425] RBP: ffffbd2800013e00 R08: 0000000000000000 R09: 0000000000000000
> [    0.763425] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [    0.763425] R13: 0000000000003ad0 R14: 0000000000000000 R15: ffffffff99a896be
> [    0.763425] FS:  0000000000000000(0000) GS:ffff92ec7bc00000(0000)
> knlGS:0000000000000000
> [    0.763425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.763425] CR2: 000000000000028c CR3: 0000000049c10000 CR4: 00000000003406f0
> [    0.763425] BUG: sleeping function called from invalid context at
> /usr/src/kernel/include/linux/percpu-rwsem.h:38
> [    0.763425] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid:
> 1, name: swapper/0
> [    0.763425] INFO: lockdep is turned off.
> [    0.763425] irq event stamp: 696816
> [    0.763425] hardirqs last  enabled at (696815):
> [<ffffffff98c929d1>] _raw_read_unlock_irqrestore+0x31/0x50
> [    0.763425] hardirqs last disabled at (696816):
> [<ffffffff97e01f3b>] trace_hardirqs_off_thunk+0x1a/0x1c
> [    0.763425] softirqs last  enabled at (696776):
> [<ffffffff99000338>] __do_softirq+0x338/0x43a
> [    0.763425] softirqs last disabled at (696769):
> [<ffffffff97f045e8>] irq_exit+0xb8/0xc0
> [    0.763425] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G      D
>   5.6.0-rc4 #1
> [    0.763425] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [    0.763425] Call Trace:
> [    0.763425]  dump_stack+0x7a/0xa5
> [    0.763425]  ___might_sleep+0x163/0x250
> [    0.763425]  __might_sleep+0x4a/0x80
> [    0.763425]  exit_signals+0x33/0x2d0
> [    0.763425]  do_exit+0xb6/0xcf0
> [    0.763425]  ? kernel_init_freeable+0x219/0x279
> [    0.763425]  ? rest_init+0x250/0x250
> [    0.763425]  rewind_stack_do_exit+0x17/0x20
> [    0.763425] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x00000009
>
>
> metadata:
>   git branch: master
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>   git describe: v5.6-rc4
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-mainline/2502/config
>
> git log --online
> 98d54f81e36b (HEAD -> master, tag: v5.6-rc4, origin/master,
> origin/HEAD) Linux 5.6-rc4
> e70869821a46 Merge tag 'ext4_for_linus_stable' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
> f853ed90e2e4 Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
> 86f7e90ce840 KVM: VMX: check descriptor table exits on instruction emulation
> fb279f4e2386 Merge branch 'i2c/for-current-fixed' of
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
> 37b0b6b8b99c ext4: potential crash on allocation error in
> ext4_alloc_flex_bg_array()
> 38b17afb0ebb macintosh: therm_windtunnel: fix regression when
> instantiating devices
> 6c5d91124929 jbd2: fix data races at struct journal_head
> 7557c1b3f715 Merge tag 'scsi-fixes' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
>
>
> ref:
> https://lkft.validation.linaro.org/scheduler/job/1261774#L461
> https://lkft.validation.linaro.org/scheduler/job/1261816#L477
>
> --
> Linaro LKFT
> https://lkft.linaro.org
