Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E08B331918
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhCHVLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:11:06 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:51986 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhCHVKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 16:10:32 -0500
Received: by mail-il1-f197.google.com with SMTP id y11so8555547ilc.18
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 13:10:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MlrwDWSqQ3VwrUBIGlkHQVvbOROSKag3Yj/DlloiHp8=;
        b=B6IZdR4PsBK8oGqWzXSxVQAwcXx5swdopcdqe+z9BpVBeDPDMqhUqBU3izyThyO6S6
         KreQG2tO4JXXItwstfi5X2GCfSIt3PDNKqoIRx6HjahEk7txkDE7hSEwRbc1wvg4D1au
         xHoKzOJbChz3ax+eIhCkHlXKbWKeDJdkoAKLBYaFfUxkcM2jvDefftGvo3GtPncWgOrz
         9H0NVl8N1EJrlvU3QoFmhavUoMOEDbLIykmCFpjEUwIro05sJAKPqlaXp5mecg1Od/8P
         cJjybG4OHr5N1p9QphUrmUe/JqW9VxkBikKoIShLvOizpF48UKsZBR/19oJNsIXfDjg/
         C1Iw==
X-Gm-Message-State: AOAM532fWtq/4/gi3apnseWXiCV30M+yJrCUcimCGxpIJSAKYQCCeUif
        MjMbdB23NU5zkfxRz0/LhIZOhWdU0If22iYe3jbUFHYo9Kj8
X-Google-Smtp-Source: ABdhPJz9NWIxK779w1caAr5X0rqBsPkfMcXCRwYE4vhhhC94DD97C/JqGZXPqOwGVsWy62RvY9inLUIzwDetwD2yw5w3gWyTBIOR
MIME-Version: 1.0
X-Received: by 2002:a5d:9c50:: with SMTP id 16mr20624458iof.66.1615237832313;
 Mon, 08 Mar 2021 13:10:32 -0800 (PST)
Date:   Mon, 08 Mar 2021 13:10:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003912cf05bd0cdd75@google.com>
Subject: [syzbot] WARNING in kvm_wait
From:   syzbot <syzbot+3c2bc6358072ede0f11b@syzkaller.appspotmail.com>
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

HEAD commit:    a38fd874 Linux 5.12-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14158fdad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db9c6adb4986f2f2
dashboard link: https://syzkaller.appspot.com/bug?extid=3c2bc6358072ede0f11b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1096d35cd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16bf1e52d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3c2bc6358072ede0f11b@syzkaller.appspotmail.com

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 0 PID: 14236 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 0 PID: 14236 Comm: syz-executor143 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: be ff cc cc cc cc cc cc cc cc cc cc cc 80 3d ac 2b b0 04 00 74 01 c3 48 c7 c7 a0 8f 6b 89 c6 05 9b 2b b0 04 01 e8 f7 cb be ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
RSP: 0018:ffffc9000c29f9c0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffffc90000e1b688 RCX: 0000000000000000
RDX: ffff88801e689bc0 RSI: ffffffff815c0eb5 RDI: fffff52001853f2a
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815b9c4e R11: 0000000000000000 R12: 0000000000000003
R13: fffff520001c36d1 R14: 0000000000000001 R15: ffff8880b9c35f40
FS:  00000000018ce300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd79af41d8 CR3: 000000001c373000 CR4: 0000000000350ef0
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
 futex_wake+0x1b5/0x490 kernel/futex.c:1610
 do_futex+0x326/0x1710 kernel/futex.c:3740
 __do_sys_futex+0x2a2/0x470 kernel/futex.c:3798
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4459c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd79af41f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004459c9
RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00000000004ca408
RBP: 00000000004ca400 R08: 0000000000000000 R09: 0000000000000000
R10: 00007ffd79bec090 R11: 0000000000000246 R12: 00007ffd79af4230
R13: 00000000004ca40c R14: 0000000000000001 R15: 00000000004023b0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
