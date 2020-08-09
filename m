Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D99240073
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 01:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHIX50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Aug 2020 19:57:26 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:42120 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgHIX50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Aug 2020 19:57:26 -0400
Received: by mail-il1-f200.google.com with SMTP id a17so6641955ilk.9
        for <kvm@vger.kernel.org>; Sun, 09 Aug 2020 16:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=knm+QemWG+MSMV1DpBju98nanbq8BEEg/qz4pwuH2RU=;
        b=rdc+wXFIY7PBUJ/hrp+kY56NENmns5eRpS3ly914PNsyIxVNZxhm8LORZJw+CGQlU2
         DaKXYZPFFxQTpMXK4bCRRQzu7tZL/XbxXwU9cbyKuqQxj4tyJX3fniY1mjKfK8NLz8sW
         ARPI4GUPUlH5mTEnGKDZ377hljVAFfgSSxnyO5NVIOXVPm5b6oKrZFGWKfOZ6aaAPNE8
         Jd9yfyLBOYRasEXWS88BjHgR9xm8uPkYhxtKpWqxyGHSegZKY/+rgGfVGkxojzs4cFMn
         WookdWbHRoZH/h2L8RlIoDIWZmc1VIMNGo/o7ICBuJ7Jw2cp7FCMx/8FOV1MwLK4h/U5
         yy3A==
X-Gm-Message-State: AOAM5307mcvxEnxlngoPHBc5pQdEaiYmHdSHgUW0HKOuFw+FrU+dSSLz
        7JBwKpYLqihJjfjWHMRRGBwdUT0ZAXGuCvXiaxtGTa4obGwW
X-Google-Smtp-Source: ABdhPJz9EkwbBlV75D+8HR7J/csv+ohFbZePeo8SDnCuowGv+BAzELV77UA1enouHvmiWJfeR48SdchzM4mgHZ+7ffftpTOXqgKZ
MIME-Version: 1.0
X-Received: by 2002:a6b:8e8c:: with SMTP id q134mr15009228iod.147.1597017445119;
 Sun, 09 Aug 2020 16:57:25 -0700 (PDT)
Date:   Sun, 09 Aug 2020 16:57:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000843c1005ac7a990c@google.com>
Subject: WARNING in rcu_irq_exit
From:   syzbot <syzbot+c116bcba868f8148cd3e@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    47ec5303 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17228c62900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c783f658542f35
dashboard link: https://syzkaller.appspot.com/bug?extid=c116bcba868f8148cd3e
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c116bcba868f8148cd3e@syzkaller.appspotmail.com

device lo entered promiscuous mode
------------[ cut here ]------------
WARNING: CPU: 1 PID: 29030 at kernel/rcu/tree.c:772 rcu_irq_exit+0x19/0x20 kernel/rcu/tree.c:773
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 29030 Comm: syz-executor.2 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:rcu_irq_exit+0x19/0x20 kernel/rcu/tree.c:773
Code: 0b c3 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 83 3d fd fb 68 01 00 74 0b 65 8b 05 50 00 dc 77 85 c0 75 05 e9 07 ff ff ff <0f> 0b e9 00 ff ff ff 41 56 53 83 3d da fb 68 01 00 74 0f 65 8b 05
RSP: 0018:ffffc90001806e70 EFLAGS: 00010002
RAX: 0000000000000001 RBX: 0000000000000082 RCX: 0000000000040000
RDX: ffffc9000da6b000 RSI: 0000000000003173 RDI: 0000000000003174
RBP: ffff8880a2ce9fa8 R08: ffffffff817a9064 R09: ffffed1015d26cf5
R10: ffffed1015d26cf5 R11: 0000000000000000 R12: dffffc0000000000
R13: 000000000000003c R14: dffffc0000000000 R15: 000000000000003c
 rcu_irq_exit_irqson+0x80/0x110 kernel/rcu/tree.c:827
 trace_console_rcuidle+0x15d/0x1c0 include/trace/events/printk.h:10
 call_console_drivers kernel/printk/printk.c:1809 [inline]
 console_unlock+0x74c/0xec0 kernel/printk/printk.c:2501
 vprintk_emit+0x1f8/0x3c0 kernel/printk/printk.c:2029
 printk+0x62/0x83 kernel/printk/printk.c:2078
 report_bug+0x1e1/0x2e0 lib/bug.c:194
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:rcu_irq_enter+0x19/0x20 kernel/rcu/tree.c:1058
Code: 74 f8 f0 83 a0 a0 67 03 00 fe c3 66 0f 1f 44 00 00 83 3d 2d fa 68 01 00 74 0b 65 8b 05 80 fe db 77 85 c0 75 05 e9 07 ff ff ff <0f> 0b e9 00 ff ff ff e8 fb 04 00 00 89 c0 48 8b 04 c5 e0 18 2e 89
RSP: 0018:ffffc90001807170 EFLAGS: 00010002
RAX: 0000000000000001 RBX: 0000000000000082 RCX: 0000000000040000
RDX: ffffc9000da6b000 RSI: 00000000000003f1 RDI: 00000000000003f2
RBP: 0000000000000001 R08: ffffffff817a9064 R09: fffffbfff131daa6
R10: fffffbfff131daa6 R11: 0000000000000000 R12: ffffffff81332ba5
R13: 1ffffffff1641e9c R14: dffffc0000000000 R15: 0000000000000001
 rcu_irq_enter_irqson+0x80/0x110 kernel/rcu/tree.c:1072
 trace_irq_disable_rcuidle+0xc9/0x1c0 include/trace/events/preemptirq.h:36
 kvm_wait+0x95/0x1d0 arch/x86/kernel/kvm.c:800
 pv_wait arch/x86/include/asm/paravirt.h:666 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x701/0xc00 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:656 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:82 [inline]
 lockdep_lock+0x170/0x2c0 kernel/locking/lockdep.c:94
 graph_lock kernel/locking/lockdep.c:119 [inline]
 lookup_chain_cache_add kernel/locking/lockdep.c:3150 [inline]
 validate_chain+0x170/0x88a0 kernel/locking/lockdep.c:3183
 __lock_acquire+0x1161/0x2ab0 kernel/locking/lockdep.c:4426
 lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
 __mutex_lock_common+0x189/0x2fc0 kernel/locking/mutex.c:956
 __mutex_lock kernel/locking/mutex.c:1103 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
 packet_diag_dump+0x123/0x1e50 net/packet/diag.c:200
 netlink_dump+0x4be/0x10d0 net/netlink/af_netlink.c:2246
 __netlink_dump_start+0x538/0x700 net/netlink/af_netlink.c:2354
 netlink_dump_start include/linux/netlink.h:246 [inline]
 packet_diag_handler_dump+0x19b/0x220 net/packet/diag.c:242
 __sock_diag_cmd net/core/sock_diag.c:233 [inline]
 sock_diag_rcv_msg+0x2ff/0x3d0 net/core/sock_diag.c:264
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:275
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 sock_write_iter+0x317/0x470 net/socket.c:998
 call_write_iter include/linux/fs.h:1868 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0xa09/0xc50 fs/read_write.c:578
 ksys_write+0x11b/0x220 fs/read_write.c:631
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ccd9
Code: 2d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd1ca9eec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000000358c0 RCX: 000000000045ccd9
RDX: 000000000000002f RSI: 00000000200003c0 RDI: 0000000000000005
RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007fff08f9eaff R14: 00007fd1ca9ef9c0 R15: 000000000078bf0c
Kernel Offset: disabled


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
