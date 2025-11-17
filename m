Return-Path: <kvm+bounces-63354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 999F3C639C4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 11:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8D3BE3561F6
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C3D328B7F;
	Mon, 17 Nov 2025 10:44:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A72E31A55E
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 10:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763376267; cv=none; b=n1qVAlRIJ9f5lZSt+GozuySuNdWSlycJSj8o9fiR7bqV4Jk9dI993o6Lot0oXjBzu6Igs/XGIXun57GLf2VOztEknnQDUz21wqWJino3SSEscegQnm1JMvIHqhzFDmed1Y4+vhUnYIXfGB3S2kScVjdyNlVwvR94E4nhiSbXi/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763376267; c=relaxed/simple;
	bh=jaYR214fbwWMVmH/D4J33ikkYRDliintKt3GuxVd/aQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bKvQD1Jcl/xURDf5SspPJ+SRl7bY5BhWSAluh+hbgwB847czIL5wgMKIUW92J0Uyy/tCN5XS/OnV355eLA3NX6P9ic7VHhJheMqWdxVgwxKPdzYto2602Ss7dAxOwurkPVk/PoEKii+u5FbS5j9LEijxkDzpldjUCxW80C+lZjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-94908fb82e0so82111039f.3
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 02:44:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763376265; x=1763981065;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RoiSHQ95L8ivg00U2CqwFDdEW5EuyvMqF//3zpqLyC0=;
        b=Ii2JjYq4gzMjxOOLLdpTVxNvMUDSx95Ulh7KCNwSBxoCChKs2kTh8TGbIpvO1FpBcj
         dKY1b3yNtmuf0GmUw+BvczqtgDdCnIohi5w1L4weyelwxr5zfQiIu/Q1wBaVvx0nKVjz
         28uCw2ly/RrVqzrODSPzTwNDbmWJFeKTIXYHeBN4Vv2zWF6DbE5hRb5OA4WLO7s0ypGv
         nwVRbHJsuJqNE1BJgtfJN+mQhs5EvP6baxYF3AO/R9XfjpGNeXpo0dT0RsFh4h5iEOCB
         yuovoqDIAeQaQVK3TFYTzS1li6BJnbp2XOveKihkP9v8gTLdhs9pm0Z8lhFFnbdaruXA
         cahQ==
X-Gm-Message-State: AOJu0Yw6pBSvFMWglyfsxSxGmXE+czroa0ebWGzidIWAeE28e7QGAlzU
	DVDZXAXYqlGX0Xc0PC/TWE6MngpXFUQ7dB5tWryjBufAPRqA1YWB1tMY3wRQ/2XI7V7aPao34lS
	e6kVew6liE39AuM730R1dsORYPGAyKoIgkJhv6iPZfMZHWu6USpqmt4vNQ93TUw==
X-Google-Smtp-Source: AGHT+IE0Lyt59OpKxP18HPk9o9J9B7146rZ0ZOuAHbNmnZTgwJcuJ1S03+UuQ3H1q5D1ttTE/QjXgD04srezgZ6EFTUoSvjL4T5x
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3713:b0:433:5a5c:5d75 with SMTP id
 e9e14a558f8ab-4348c937a17mr155242035ab.18.1763376265249; Mon, 17 Nov 2025
 02:44:25 -0800 (PST)
Date: Mon, 17 Nov 2025 02:44:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691afc89.a70a0220.3124cb.009a.GAE@google.com>
Subject: [syzbot] [kvm?] INFO: task hung in kvm_swap_active_memslots (2)
From: syzbot <syzbot+5c566b850d6ab6f0427a@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3a8660878839 Linux 6.18-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=160a05e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e854293d7f44b5a5
dashboard link: https://syzkaller.appspot.com/bug?extid=5c566b850d6ab6f0427a
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/87a66406ce1a/disk-3a866087.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7c3300da5269/vmlinux-3a866087.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b4fcefdaf57b/bzImage-3a866087.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5c566b850d6ab6f0427a@syzkaller.appspotmail.com

INFO: task syz.2.1185:11790 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.1185      state:D stack:25976 pid:11790 tgid:11789 ppid:5836   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5325 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6929
 __schedule_loop kernel/sched/core.c:7011 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:7026
 kvm_swap_active_memslots+0x2ea/0x7d0 virt/kvm/kvm_main.c:1642
 kvm_activate_memslot virt/kvm/kvm_main.c:1786 [inline]
 kvm_create_memslot virt/kvm/kvm_main.c:1852 [inline]
 kvm_set_memslot+0xd3b/0x1380 virt/kvm/kvm_main.c:1964
 kvm_set_memory_region+0xe53/0x1610 virt/kvm/kvm_main.c:2120
 kvm_set_internal_memslot+0x9f/0xe0 virt/kvm/kvm_main.c:2143
 __x86_set_memory_region+0x2f6/0x740 arch/x86/kvm/x86.c:13242
 kvm_alloc_apic_access_page+0xc5/0x140 arch/x86/kvm/lapic.c:2788
 vmx_vcpu_create+0x503/0xbd0 arch/x86/kvm/vmx/vmx.c:7599
 kvm_arch_vcpu_create+0x688/0xb20 arch/x86/kvm/x86.c:12706
 kvm_vm_ioctl_create_vcpu virt/kvm/kvm_main.c:4207 [inline]
 kvm_vm_ioctl+0xfec/0x3fd0 virt/kvm/kvm_main.c:5158
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3c9978eec9
RSP: 002b:00007f3c9a676038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f3c999e5fa0 RCX: 00007f3c9978eec9
RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000003
RBP: 00007f3c99811f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3c999e6038 R14: 00007f3c999e5fa0 R15: 00007ffda33577e8
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e3c42e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e3c42e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8e3c42e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0 kernel/locking/lockdep.c:6775
2 locks held by getty/8058:
 #0: ffff88803440d0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000e0cd2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x41b/0x14f0 drivers/tty/n_tty.c:2222
2 locks held by syz.2.1185/11790:
 #0: ffff888032d640a8 (&kvm->slots_lock){+.+.}-{4:4}, at: class_mutex_constructor include/linux/mutex.h:228 [inline]
 #0: ffff888032d640a8 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_alloc_apic_access_page+0x27/0x140 arch/x86/kvm/lapic.c:2782
 #1: ffff888032d64138 (&kvm->slots_arch_lock){+.+.}-{4:4}, at: kvm_set_memslot+0x34/0x1380 virt/kvm/kvm_main.c:1915
4 locks held by kworker/u8:44/13722:
 #0: ffff88801ba9f148 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x12a2/0x1b70 kernel/workqueue.c:3238
 #1: ffffc9000b6cfd00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x929/0x1b70 kernel/workqueue.c:3239
 #2: ffffffff900e8630 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xad/0x8b0 net/core/net_namespace.c:669
 #3: ffffffff8e3cf878 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock+0x1a3/0x3c0 kernel/rcu/tree_exp.h:343
4 locks held by syz-executor/14037:
 #0: ffff888056654dc8 (&hdev->req_lock){+.+.}-{4:4}, at: hci_dev_do_close+0x26/0x90 net/bluetooth/hci_core.c:499
 #1: ffff8880566540b8 (&hdev->lock){+.+.}-{4:4}, at: hci_dev_close_sync+0x3ae/0x11d0 net/bluetooth/hci_sync.c:5291
 #2: ffffffff90371248 (hci_cb_list_lock){+.+.}-{4:4}, at: hci_disconn_cfm include/net/bluetooth/hci_core.h:2118 [inline]
 #2: ffffffff90371248 (hci_cb_list_lock){+.+.}-{4:4}, at: hci_conn_hash_flush+0xbb/0x260 net/bluetooth/hci_conn.c:2602
 #3: ffff88803179c338 (&conn->lock#2){+.+.}-{4:4}, at: l2cap_conn_del+0x80/0x730 net/bluetooth/l2cap_core.c:1762
1 lock held by syz.0.1905/15421:
 #0: ffffffff900e8630 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x2d6/0x690 net/core/net_namespace.c:576
1 lock held by syz.0.1905/15423:
 #0: ffffffff900e8630 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x2d6/0x690 net/core/net_namespace.c:576
2 locks held by syz.1.1908/15436:
 #0: ffff88807a444dc8 (&hdev->req_lock){+.+.}-{4:4}, at: hci_dev_do_close+0x26/0x90 net/bluetooth/hci_core.c:499
 #1: ffff88807a4440b8 (&hdev->lock){+.+.}-{4:4}, at: hci_dev_close_sync+0x3ae/0x11d0 net/bluetooth/hci_sync.c:5291

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x27b/0x390 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x29c/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:332 [inline]
 watchdog+0xf3f/0x1170 kernel/hung_task.c:495
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

