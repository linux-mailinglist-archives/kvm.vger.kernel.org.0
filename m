Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0DA32F4D1
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 21:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCEU4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 15:56:38 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:34141 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhCEU4U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 15:56:20 -0500
Received: by mail-io1-f71.google.com with SMTP id r3so2995227iol.1
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 12:56:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bklPqc4/Z/Eg2dQa6cE1lCcq6hgo59I5Xa1oE+nr5tY=;
        b=AMJz4gJIeZJW9Dp//MBbQXlSXwKq1J/dnarJe1qLGpEdbxu7zQz/WMFWbKBuCQX1jY
         djGu2gu7Q3HSN0EjRvXvz6eRXLfbYrpb9CwYeOxz61h8q+X59fa6Cv8bPuBAnoMSusla
         Redv4D2htJ+CHdn3GQquGZErbNYCdF/zoM2/CVIurARq98IaFcbk4T/0qp9iZk0rXt5i
         2mHB2ONa5M4FHmxO6hpNcrckwR8MZX0WCzrX2WEd/iPOfjZmbQqSI6Ep0PCKXOCawzwT
         OaN0lTcecZGChTCie6sDVBFYPcC9iop5DV10AijqGzygNuZPkOVcmvVt5JbJxoLLTO8u
         +CIw==
X-Gm-Message-State: AOAM5306tRN1NlzgpAGaPCCy43KcpB7+bdrJ54lC0pH7Qzj5pZLQB+aI
        FN++KfgB6makSH8SjVeVEGRDnpN10Q8QMW6khLxXvNTK0fFa
X-Google-Smtp-Source: ABdhPJxDKlnrHAnJAhLY3h9nokXkRtBnFKq1JjDjaV0eyGEq0wA4KKXXCYIOMVYWeo+UqCPjfAU/YHCRTq4XFZzh8vZJufsBxfaa
MIME-Version: 1.0
X-Received: by 2002:a02:289:: with SMTP id 131mr11691657jau.99.1614977778367;
 Fri, 05 Mar 2021 12:56:18 -0800 (PST)
Date:   Fri, 05 Mar 2021 12:56:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ccbedd05bcd0504e@google.com>
Subject: [syzbot] upstream boot error: WARNING in kvm_wait
From:   syzbot <syzbot+a4c8bc1d1dc7b620630d@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    280d542f Merge tag 'drm-fixes-2021-03-05' of git://anongit..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=138c7a92d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dc4003509ab3fc78
dashboard link: https://syzkaller.appspot.com/bug?extid=a4c8bc1d1dc7b620630d

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a4c8bc1d1dc7b620630d@syzkaller.appspotmail.com

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 2 PID: 213 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 2 PID: 213 Comm: kworker/u17:4 Not tainted 5.12.0-rc1-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: events_unbound call_usermodehelper_exec_work

RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: be ff cc cc cc cc cc cc cc cc cc cc cc 80 3d e4 38 af 04 00 74 01 c3 48 c7 c7 a0 8f 6b 89 c6 05 d3 38 af 04 01 e8 e7 b9 be ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
RSP: 0000:ffffc90000fe7770 EFLAGS: 00010286

RAX: 0000000000000000 RBX: ffffffff8c0e9c68 RCX: 0000000000000000
RDX: ffff8880116bc3c0 RSI: ffffffff815c0cf5 RDI: fffff520001fcee0
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff815b9a5e R11: 0000000000000000 R12: 0000000000000003
R13: fffffbfff181d38d R14: 0000000000000001 R15: ffff88802cc36000
FS:  0000000000000000(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000bc8e000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvm_wait arch/x86/kernel/kvm.c:860 [inline]
 kvm_wait+0xc9/0xe0 arch/x86/kernel/kvm.c:837
 pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 copy_fs_struct+0x1c8/0x340 fs/fs_struct.c:123
 copy_fs kernel/fork.c:1443 [inline]
 copy_process+0x4dc2/0x6fd0 kernel/fork.c:2088
 kernel_clone+0xe7/0xab0 kernel/fork.c:2462
 kernel_thread+0xb5/0xf0 kernel/fork.c:2514
 call_usermodehelper_exec_work kernel/umh.c:172 [inline]
 call_usermodehelper_exec_work+0xcc/0x180 kernel/umh.c:158
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
