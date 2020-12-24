Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6429D2E2808
	for <lists+kvm@lfdr.de>; Thu, 24 Dec 2020 17:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgLXQPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Dec 2020 11:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbgLXQPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Dec 2020 11:15:24 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B767DC061575
        for <kvm@vger.kernel.org>; Thu, 24 Dec 2020 08:14:43 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id r9so2362365ioo.7
        for <kvm@vger.kernel.org>; Thu, 24 Dec 2020 08:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8VquFk13q0B+dAaD5JwwRri5tNBP7t01nNOEJ31h/ng=;
        b=r/NhD6uAep6n8vjHzI9uu61qJ5wCC3NCLy3mIl1qGwIhL8XKOv7qY1vmzjGBjz48cR
         ybsuUmxppamOoAaoTZChFPkU/hz4DrZ1+rG0Ia9WsBG2DVRumJvvXX/+7wNAIA/QNliQ
         74/N+bLdIp9VPhz27R21xP2TW9ixzws/N56vCp3MsYFpjdXYUpUFIPdifCIMYSX59fIs
         DuvY5jUUsvxjmTsIMTooJceOCHgCgp3ShK/OBP5/+5+KVcKjTlQ49iRu6EXJck3Yu8mF
         GptHSg64kaUuC4GdXtkoNLRQRYUtwvctq/ni7As/t16LrhBAummapURQXzUuabTAUNox
         f5pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8VquFk13q0B+dAaD5JwwRri5tNBP7t01nNOEJ31h/ng=;
        b=qnvbKKOOo6u9oSQCjlULIo6BAHN82ncD+qCSbv3hatQytTxPLV6pA05UaJxSOecGIN
         DGSt6xw1LqJmxB5HvB+0xeVS4J/JIcbQ27Z1bBS6wJOs0FjUFj9OFNRjCQn8Ht767F+X
         zwI+8YIprD6ovEdfzDiNzmBUuEpNNjVV0/aH45G2Gt3Xx0QUOWzTzmT1EzYMGTDOHLRO
         XLPzonMWhRyr8d64tVmuWooYAyZU3PDpc60w3oa42ayCnWDYEJi8KcMA5Q1FjuGKPJti
         4oNnUZHQUpBpHzgxkdsqMUwmbKP6yZCbFbDhKL3rLKtRVbcwAro3nWkpFh+SFJ0KpsRZ
         uFHQ==
X-Gm-Message-State: AOAM531i0h3XFF7LtkoHIzOeWYxVP/U6LGWkzFhr+huYn/x5bhqixp6a
        8O/iOuUX6Q0vU+MeXUXarTgjegBqPDIPuvWKy34=
X-Google-Smtp-Source: ABdhPJytonRX3OtR6/PZJNuMvwj01JxvYAN/N1+smp6xXn36ZmJ9vrp7xaQYxOMbOqHUpsfUa44nvznQhbiwi2rLrHs=
X-Received: by 2002:a6b:6d1a:: with SMTP id a26mr26052461iod.158.1608826482617;
 Thu, 24 Dec 2020 08:14:42 -0800 (PST)
MIME-Version: 1.0
References: <CAKXUXMxN05q4hcrQW-mm6EVhiTQ+roesLf0SgkFXOtOVUDOhSA@mail.gmail.com>
 <CACT4Y+bmm14tXaPdvSpf9RBi8MzD-3_kH1+BX14c7-htN+Qo4Q@mail.gmail.com>
In-Reply-To: <CACT4Y+bmm14tXaPdvSpf9RBi8MzD-3_kH1+BX14c7-htN+Qo4Q@mail.gmail.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Thu, 24 Dec 2020 17:14:31 +0100
Message-ID: <CAKXUXMwHUMUP3t6nf=0WG0_mHbFUd9iMmn4s-7ToFtgu9+07JA@mail.gmail.com>
Subject: Re: KVM kernel BUG: unable to handle kernel paging request in kvm_kick_cpu
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 24, 2020 at 4:35 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Thu, Dec 24, 2020 at 4:15 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> >
> > Dear kvm folks, (CC: syzkaller users),
> >
> > I have encountered the following kernel bug running qemu on my system
> > (as part of setting up a syzkaller campaign).
> >
> > kernel version: next-20201123 [can also be triggered on earlier
> > version, such v5.10]
> > kernel configuration:
> >
> > wget https://raw.githubusercontent.com/openSUSE/kernel-source/9753528d001e0ff814f8b6938211bc47a0a2a1d8/config/x86_64/rt
> > -O .config
> > make olddefconfig
> >
> > With the following simple script, I start up the kernel on a simple
> > debian base image (as used for syzkaller fuzzing) and just observe if
> > I can run through the systemd initialisation:
> >
> > >>>
> > #!/bin/bash
> >
> > crashes=0
> > for (( total=1; total<=100; total++ ))
> > do
> >
> > timeout --foreground 10 \
> >   qemu-system-x86_64 -m 2048 -display none -serial stdio -no-reboot
> > -enable-kvm \
> >   -cpu host,migratable=off -drive file=$IMAGE/stretch.img,if=virtio \
> >   -device e1000,netdev=net0 \
> >   -netdev "user,id=net0,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22" \
> >   -snapshot -kernel $KERNEL/arch/x86/boot/bzImage \
> >   -append "earlyprintk=serial panic=-1 console=ttyS0 root=/dev/vda rw
> > kaslr crashkernel=512M minnowboard_1:eth0:::" -smp 4
> >
> > RET=$?
> >
> > if [ "$RET" = "0" ]; then
> > # echo "crashed!"
> > crashes=$((crashes+1))
> > elif [ "$RET" = "124" ]; then
> > # echo "timed out!"
> > :
> > else
> > # echo "unexpected return"
> > exit 1
> > fi
> >
> > echo "crashes / total = $crashes / $total"
> >
> > sleep 1
> >
> > done
> > <<<
> >
> > The image at $IMAGE/stretch.img was created as described at
> > https://github.com/google/syzkaller/blob/master/docs/linux/setup_ubuntu-host_qemu-vm_x86-64-kernel.md.
> >
> > Side remark: Even if no kernel crash occurs, it fails to reach the
> > login, but that is unrelated to the reported kernel issue; I just
> > reduced the kernel config during the investigation to not have
> > sufficient driver support to actually start up all services
> > successfully.
> >
> >
> > In roughly 70 of 100 cases, I hit the following kernel crash:
> >
> > [    0.474842] BUG: unable to handle page fault for address: ffffffff96044553
> > [    0.474844] #PF: supervisor write access in kernel mode
> > [    0.474844] #PF: error_code(0x0003) - permissions violation
> > [    0.474845] PGD 740c067 P4D 740c067 PUD 740d063 PMD 64001e1
> > [    0.474847] Oops: 0003 [#1] SMP PTI
> > [    0.474847] CPU: 1 PID: 34 Comm: kauditd Not tainted
> > 5.10.0-next-20201223-rt #2
> > [    0.474848] RIP: 0010:kvm_kick_cpu+0x23/0x30
> > [    0.474848] Code: 1f 84 00 00 00 00 00 66 66 66 66 90 48 63 ff 53
> > 48 c7 c0 78 15 01 00 31 db 48 8b 14 fd 60 84 db 96 0f b7 0c 02 b8 05
> > 00 00 00 <0f> 01 c1 5b c3 0f 1f 84 00 00 00 00 00 66 66 66 66 90 53 48
> > 89 fb
> > [    0.474849] RSP: 0000:ffffb1428013fbe8 EFLAGS: 00010046
> > [    0.474850] RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
> > [    0.474850] RDX: ffff8ff0bfc00000 RSI: ffffffff97699600 RDI: 0000000000000000
> > [    0.474851] RBP: 0000000000000000 R08: 0000000000000100 R09: ffff8ff0bffd5000
> > [    0.474851] R10: 303034313d657079 R11: 74203a7469647561 R12: 0000000000000001
> > [    0.474851] R13: 0000000000000005 R14: 0000000000000000 R15: 00000000000000ed
> > [    0.474852] FS:  0000000000000000(0000) GS:ffff8ff0bfc80000(0000)
> > knlGS:0000000000000000
> > [    0.474852] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    0.474853] CR2: ffffffff96044553 CR3: 0000000000c64000 CR4: 00000000003506a0
> > [    0.474853] Call Trace:
> > [    0.474853]  __pv_queued_spin_unlock_slowpath+0xa1/0xd0
> > [    0.474854]  __raw_callee_save___pv_queued_spin_unlock_slowpath+0x11/0x20
> > [    0.474854]  ? univ8250_console_exit+0x20/0x20
> > [    0.474855]  .slowpath+0x9/0xe
> > [    0.474855]  _raw_spin_unlock_irqrestore+0xa/0x10
> > [    0.474855]  serial8250_console_write+0x30c/0x330
> > [    0.474856]  console_unlock+0x37b/0x4b0
> > [    0.474856]  vprintk_emit+0xb0/0x170
> > [    0.474856]  ? audit_log_lost+0x90/0x90
> > [    0.474857]  printk+0x58/0x6f
> > [    0.474857]  kauditd_hold_skb.cold.29+0x17/0x1c
> > [    0.474857]  ? stop_machine_from_inactive_cpu+0x110/0x110
> > [    0.474858]  kauditd_send_queue+0x10f/0x150
> > [    0.474858]  kauditd_thread+0x236/0x2c0
> > [    0.474858]  ? wait_woken+0x80/0x80
> > [    0.474858]  ? auditd_reset+0x90/0x90
> > [    0.474859]  kthread+0x116/0x130
> > [    0.474859]  ? kthread_park+0x80/0x80
> > [    0.474859]  ret_from_fork+0x22/0x30
> > [    0.474860] Modules linked in:
> > [    0.474860] CR2: ffffffff96044553
> > [    0.474871] ---[ end trace 66ccf77300901455 ]---
> > [    0.474871] RIP: 0010:kvm_kick_cpu+0x23/0x30
> > [    0.474872] Code: 1f 84 00 00 00 00 00 66 66 66 66 90 48 63 ff 53
> > 48 c7 c0 78 15 01 00 31 db 48 8b 14 fd 60 84 db 96 0f b7 0c 02 b8 05
> > 00 00 00 <0f> 01 c1 5b c3 0f 1f 84 00 00 00 00 00 66 66 66 66 90 53 48
> > 89 fb
> > [    0.474873] RSP: 0000:ffffb1428013fbe8 EFLAGS: 00010046
> > [    0.474873] RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
> > [    0.474874] RDX: ffff8ff0bfc00000 RSI: ffffffff97699600 RDI: 0000000000000000
> > [    0.474874] RBP: 0000000000000000 R08: 0000000000000100 R09: ffff8ff0bffd5000
> > [    0.474875] R10: 303034313d657079 R11: 74203a7469647561 R12: 0000000000000001
> > [    0.474875] R13: 0000000000000005 R14: 0000000000000000 R15: 00000000000000ed
> > [    0.474876] FS:  0000000000000000(0000) GS:ffff8ff0bfc80000(0000)
> > knlGS:0000000000000000
> > [    0.474876] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    0.474877] CR2: ffffffff96044553 CR3: 0000000000c64000 CR4: 00000000003506a0
> > [    0.474877] Kernel panic - not syncing: Fatal exception
> > [    1.539900] Shutting down cpus with NMI
> > [    1.539902] Kernel Offset: 0x15000000 from 0xffffffff81000000
> > (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> >
> >
> > So far, I made the following further observations:
> >
> > kernel configuration needs to include PARAVIRT_SPINLOCKS = y; if set
> > to n, the kernel bug is not reproducible.
> >
> > A kernel configured with make defconfig && make kvmconfig &&
> > ./scripts/config -e PARAVIRT_SPINLOCKS does not show the kernel bug.
> > So, it requires some further configuration of the kernel configuration
> > above beyond what is in make defconfig && make kvmconfig &&
> > ./scripts/config -e PARAVIRT_SPINLOCKS to actually trigger.
> >
> > -smp option of qemu needs to be larger than 1 in the script above; it
> > is some kind of concurrency bug.
> >
> > With the script above, the issue only occurs with `timeout
> > --foreground`, not with timeout (but maybe that is a completely
> > different issue I just misunderstand in the timeout and qemu
> > interaction).
> >
> > Has this issue been observed by others?
> >
> > Can somebody reproduce this issue here?
> >
> > Are there certain kernel configurations I should try out to pinpoint
> > the issue to a certain set of kernel configurations?
> >
> > Did I miss to mention some further important information for
> > reproducing and debugging?
> >
> > Is there anything specific I can do to support debugging and fixing the issue?
> >
> >
> > Best regards,
> >
> > Lukas
>
> FWIW I can't find any crashes that mention kvm_kick_cpu in syzbot
> reports nor in my local crashes.
> We have PARAVIRT_SPINLOCKS enabled everywhere.

Thanks for letting me know. I suspect it is due to some strange serial
8250 config option (might be on a wrong track, though...) with
PARAVIRT_SPINLOCKS enabled.

It is pretty good to reproduce, so when it hits you, syzkaller will be
showing this bug above all others it might find... it already causes
crashes at start-up; so, there is no special reproducer needed and the
fuzzing has not even started with its coverage-based smartness to try
to trigger the bug.

Lukas
