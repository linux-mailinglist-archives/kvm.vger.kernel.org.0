Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC65B33827F
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 01:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCLAh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 19:37:28 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:35037 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbhCLAhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 19:37:12 -0500
Received: by mail-il1-f200.google.com with SMTP id i7so16927960ilu.2
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 16:37:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kzzLyjEooH5a1ePxMOJOMCLElnyMMvuRoZP/W6R9Py4=;
        b=E2EODEXta36Tvl6Ac01MPCjuqSJrGp1l1SWZ56lNu+BojoCt0cbMPGUE/3B6jj4Kdt
         OrJlEe/NkSUVazNS3TCm6FoGhrMVdfMWn5/hgfxGWGHNjjTwV6XZRzZXg10195gyobGe
         E6H/1o9ltzcUAS1gxnMDdzjO2RaV/DEuICmfK46KOXN9b7dUoMvFrzFdGsqCJjGcjBwJ
         HgEFD8RnYK3CtuNQ3W195P5AU4c2KlNmso+cGvL0g/7ZM5kKifY5ILy9AZ9zFxcYjzBc
         24qKOH5NobS8UvP9JXzE24rq/7MCgaTeRpUGH3fK4SpTA0JBn0qyW1drNgcdhWRSCKE4
         qHTA==
X-Gm-Message-State: AOAM533dR2Q42FHbLr+b8lxoqTtb5UQvae7yrnNLhxAKz0hSrsX5EvO0
        b6xo18Z+XY6JBZ/NN88PHVJRW/C/N618BWiacNQhE/jy2CH/
X-Google-Smtp-Source: ABdhPJzrJY8+RgG1fy9BrJUCN4ZBicF49h/Ia+1gbtBU2f8M8/mlQPc44Bp9cwl2b3ADRvK/hfgQ0SZeP+HOZGfTDz+jxVtLBzgm
MIME-Version: 1.0
X-Received: by 2002:a92:730a:: with SMTP id o10mr900022ilc.160.1615509431996;
 Thu, 11 Mar 2021 16:37:11 -0800 (PST)
Date:   Thu, 11 Mar 2021 16:37:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d356ca05bd4c1974@google.com>
Subject: [syzbot] WARNING in handle_mm_fault
From:   syzbot <syzbot+7d7013084f0a806f3786@syzkaller.appspotmail.com>
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

HEAD commit:    05a59d79 Merge git://git.kernel.org:/pub/scm/linux/kernel/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16f493ead00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=750735fdbc630971
dashboard link: https://syzkaller.appspot.com/bug?extid=7d7013084f0a806f3786

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7d7013084f0a806f3786@syzkaller.appspotmail.com

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 0 PID: 8412 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 0 PID: 8412 Comm: syz-fuzzer Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: be ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 11 d1 ad 04 00 74 01 c3 48 c7 c7 20 79 6b 89 c6 05 00 d1 ad 04 01 e8 75 5b be ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
RSP: 0000:ffffc9000185fac8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8880194268a0 RCX: 0000000000000000
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
R13: ffffed1003284d14 R14: 0000000000000001 R15: ffff8880b9c36000
FS:  000000c00002ec90(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
Call Trace:
 handle_mm_fault+0x1bc/0x7e0 mm/memory.c:4549
Code: 48 8d 05 97 25 3e 00 48 89 44 24 08 e8 6d 54 ea ff 90 e8 07 a1 ed ff eb a5 cc cc cc cc cc 8b 44 24 10 48 8b 4c 24 08 89 41 24 <c3> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 48 8b
RAX: 00000000000047f6 RBX: 00000000000047f6 RCX: 0000000000d60000
RDX: 0000000000004c00 RSI: 0000000000d60000 RDI: 000000000181cad0
RBP: 000000c000301890 R08: 00000000000047f5 R09: 000000000059c5a0
R10: 000000c0004e2000 R11: 0000000000000020 R12: 00000000000000fa
R13: 00aaaaaaaaaaaaaa R14: 000000000093f064 R15: 0000000000000038
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8412 Comm: syz-fuzzer Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 panic+0x306/0x73d kernel/panic.c:231
 __warn.cold+0x35/0x44 kernel/panic.c:605
 report_bug+0x1bd/0x210 lib/bug.c:195
 handle_bug+0x3c/0x60 arch/x86/kernel/traps.c:239
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:259
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:575
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: be ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 11 d1 ad 04 00 74 01 c3 48 c7 c7 20 79 6b 89 c6 05 00 d1 ad 04 01 e8 75 5b be ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
RSP: 0000:ffffc9000185fac8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8880194268a0 RCX: 0000000000000000
RDX: ffff88802f7b2400 RSI: ffffffff815b4435 RDI: fffff5200030bf4b
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ad19e R11: 0000000000000000 R12: 0000000000000003
R13: ffffed1003284d14 R14: 0000000000000001 R15: ffff8880b9c36000
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
 pmd_lock include/linux/mm.h:2264 [inline]
 huge_pmd_set_accessed+0x103/0x320 mm/huge_memory.c:1265
 __handle_mm_fault+0xeeb/0x4f70 mm/memory.c:4445
 handle_mm_fault+0x1bc/0x7e0 mm/memory.c:4549
 do_user_addr_fault+0x483/0x1210 arch/x86/mm/fault.c:1390
 handle_page_fault arch/x86/mm/fault.c:1475 [inline]
 exc_page_fault+0x9e/0x180 arch/x86/mm/fault.c:1531
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:577
RIP: 0033:0x59072c
Code: 48 8d 05 97 25 3e 00 48 89 44 24 08 e8 6d 54 ea ff 90 e8 07 a1 ed ff eb a5 cc cc cc cc cc 8b 44 24 10 48 8b 4c 24 08 89 41 24 <c3> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 48 8b
RSP: 002b:000000c0003017b0 EFLAGS: 00010246
RAX: 00000000000047f6 RBX: 00000000000047f6 RCX: 0000000000d60000
RDX: 0000000000004c00 RSI: 0000000000d60000 RDI: 000000000181cad0
RBP: 000000c000301890 R08: 00000000000047f5 R09: 000000000059c5a0
R10: 000000c0004e2000 R11: 0000000000000020 R12: 00000000000000fa
R13: 00aaaaaaaaaaaaaa R14: 000000000093f064 R15: 0000000000000038
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
