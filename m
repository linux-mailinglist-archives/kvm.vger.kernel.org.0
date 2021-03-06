Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D7232F9D4
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 12:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhCFLiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Mar 2021 06:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhCFLht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Mar 2021 06:37:49 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AA9C061760
        for <kvm@vger.kernel.org>; Sat,  6 Mar 2021 03:37:49 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id t13so2544304qta.11
        for <kvm@vger.kernel.org>; Sat, 06 Mar 2021 03:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rLZcEItVMaZT77m15hh5Bj+DXsjyuX1Wi7CvUEsHYU8=;
        b=kGkkyvuxM16s5Dd/vu0fIqgpFdef4nuJUXBQc/3cH7o636pQYm2QfEwuYjcFnIUF3+
         VSLfZe+X9py2TuwhVEGO7Wf09FSALWAnIh/2LhtXSfAQKItNguvyi0RSwbXNP0ZQWXO9
         jEVCZpjPOrEfQYGntZ2JF76WJVmOqgAiW+TxUgCRl4kTS3903KwV6HFF5kaVELDC/x4r
         nAeugQb4NgG3jKdAMnRH0rQSy8r0Z6OsGvx0bOeplv6oUxRsTk4cF/3prlFisjwNIHwN
         h/vQLNBSQFJKOd/XGkCmmdEFhMs/MmOML01q88UMCAsObuvHMOLCCBB6aqzf8+aGuu3/
         1DpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rLZcEItVMaZT77m15hh5Bj+DXsjyuX1Wi7CvUEsHYU8=;
        b=XwMfyunkDVSNaAhZMVEpMkxbbet1DMa0hg2AsyYFnVz+tionXHpwKshZ1FZa5qu5ZO
         xJ/rEdlKrk9fitgRpLjOVReiwxDznCdLXqXwsJeOWxEQVse8jiqqfJZDQGzmkumE+HtM
         rKadQ04HwJIAW3M06wpqlq8tF8kJHEX5dFriEyW6XNOiG5TO3On60hAB36nBbRXqhBvo
         g+I2Bp+NsZiuey1S1d16pZOL528TNVvPFWl+H64+uyC0jRnlGWyNJ1DZ2MfJVj5b21oH
         0Y37pBj12mcvmtbPUDKEHAa4iefP0IhC/qSCfIgVnkyS9BjRddrZwkyEwQ5/uN5Vkula
         boJw==
X-Gm-Message-State: AOAM531tDZhj2xzlZwzXpDCk0nCmInG8e0tl+EgxCvJUf3qfYgdFDfWX
        +vA/SZ1ljtPb6nFntGyINbLjRgOKxyVXMxXOGsL5Bg==
X-Google-Smtp-Source: ABdhPJxYA9ku6N1PDdsktCXehDnti2bdz0hJtZV0CfBHamUTyev7iN1pLvaay9z4cLB807kE3n8lo8+uorUNVhpJwZ0=
X-Received: by 2002:ac8:6f3b:: with SMTP id i27mr12856662qtv.67.1615030668299;
 Sat, 06 Mar 2021 03:37:48 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ccbedd05bcd0504e@google.com>
In-Reply-To: <000000000000ccbedd05bcd0504e@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 6 Mar 2021 12:37:37 +0100
Message-ID: <CACT4Y+a54q=WzJU9UgzW1P6-xvJqrTJ9doXcqCgyu+MPBFFL=w@mail.gmail.com>
Subject: Re: [syzbot] upstream boot error: WARNING in kvm_wait
To:     syzbot <syzbot+a4c8bc1d1dc7b620630d@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 5, 2021 at 9:56 PM syzbot
<syzbot+a4c8bc1d1dc7b620630d@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    280d542f Merge tag 'drm-fixes-2021-03-05' of git://anongit..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=138c7a92d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dc4003509ab3fc78
> dashboard link: https://syzkaller.appspot.com/bug?extid=a4c8bc1d1dc7b620630d
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a4c8bc1d1dc7b620630d@syzkaller.appspotmail.com

+Mark, I've enabled CONFIG_DEBUG_IRQFLAGS on syzbot and it led to this breakage.
Is it a bug in kvm_wait or in the debugging code itself? If it's a
real bug, I would assume it's pretty bad as it happens all the time.


> ------------[ cut here ]------------
> raw_local_irq_restore() called with IRQs enabled
> WARNING: CPU: 2 PID: 213 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
> Modules linked in:
> CPU: 2 PID: 213 Comm: kworker/u17:4 Not tainted 5.12.0-rc1-syzkaller #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> Workqueue: events_unbound call_usermodehelper_exec_work
>
> RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
> Code: be ff cc cc cc cc cc cc cc cc cc cc cc 80 3d e4 38 af 04 00 74 01 c3 48 c7 c7 a0 8f 6b 89 c6 05 d3 38 af 04 01 e8 e7 b9 be ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
> RSP: 0000:ffffc90000fe7770 EFLAGS: 00010286
>
> RAX: 0000000000000000 RBX: ffffffff8c0e9c68 RCX: 0000000000000000
> RDX: ffff8880116bc3c0 RSI: ffffffff815c0cf5 RDI: fffff520001fcee0
> RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff815b9a5e R11: 0000000000000000 R12: 0000000000000003
> R13: fffffbfff181d38d R14: 0000000000000001 R15: ffff88802cc36000
> FS:  0000000000000000(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000bc8e000 CR4: 0000000000150ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  kvm_wait arch/x86/kernel/kvm.c:860 [inline]
>  kvm_wait+0xc9/0xe0 arch/x86/kernel/kvm.c:837
>  pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
>  pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
>  __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
>  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
>  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
>  queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
>  do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
>  spin_lock include/linux/spinlock.h:354 [inline]
>  copy_fs_struct+0x1c8/0x340 fs/fs_struct.c:123
>  copy_fs kernel/fork.c:1443 [inline]
>  copy_process+0x4dc2/0x6fd0 kernel/fork.c:2088
>  kernel_clone+0xe7/0xab0 kernel/fork.c:2462
>  kernel_thread+0xb5/0xf0 kernel/fork.c:2514
>  call_usermodehelper_exec_work kernel/umh.c:172 [inline]
>  call_usermodehelper_exec_work+0xcc/0x180 kernel/umh.c:158
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000ccbedd05bcd0504e%40google.com.
