Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE851ED2A3
	for <lists+kvm@lfdr.de>; Sun,  3 Nov 2019 10:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfKCJCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Nov 2019 04:02:10 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:51291 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfKCJCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Nov 2019 04:02:10 -0500
Received: by mail-io1-f69.google.com with SMTP id r11so10899417iom.18
        for <kvm@vger.kernel.org>; Sun, 03 Nov 2019 01:02:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3F2odmmIpoz1tUWwBUEz8M1KzLKVxN4/nVb79PfsGmI=;
        b=eELBPz6PDL3eBUZVpJKocBrKqqiK7WablXwSFu8SZp6ItlXn6gqqP5Kjh0qGXxRI1K
         BKNvBnk2J4Oy/YpRVBy4CtoZG3dwPPXi7HdhuPa0r7KM+tSHgxGAivdg2T/dnnX6oa7I
         LIHi7CMpz9BT3hMZo1DfjV54r9EJwBGfMDYkmwAKdSSKk/wdDb1cvHxp4j1Kqk58jPZ3
         fgfqATC4B6Yd8EoszHTq7BGkWiuavXVYDoQgS5ezvKqdJQAjkvG6yuI1HaXJzIcKQkMQ
         SE4vE3G5cJvGKOwFv+BanGpou3GMb3k0DEfDSosx2+EmVMHymCzU0SWiiYfy5wXPWSYp
         Y/cg==
X-Gm-Message-State: APjAAAUb5qISZdUhdWtMadQwMdPnRheZBYL3ye1BJa9Jb1FhbH48daiF
        wlBNyENOSoUntIjTv6/uPfA7wJBq3RID2HobXbSDkkUqlhlW
X-Google-Smtp-Source: APXvYqzykRD3o1Mjn2Wkrrw8F8b5iJYXv/8FrV0SAZwUMlaH4HRG38CB6ktvSzS9jVSK6e6SMBV/AqfGfc3B1CBwPGZBnSTtiCtD
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1cc:: with SMTP id w12mr10150075iot.133.1572771727741;
 Sun, 03 Nov 2019 01:02:07 -0800 (PST)
Date:   Sun, 03 Nov 2019 01:02:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000251bba05966d7473@google.com>
Subject: INFO: task hung in synchronize_rcu
From:   syzbot <syzbot+89a8060879fa0bd2db4f@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9d234505 Merge tag 'hwmon-for-v5.4-rc6' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12f33cc8e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbbed3e8d4eb64bf
dashboard link: https://syzkaller.appspot.com/bug?extid=89a8060879fa0bd2db4f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13509b84e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+89a8060879fa0bd2db4f@syzkaller.appspotmail.com

INFO: task syz-executor.4:9453 blocked for more than 143 seconds.
       Not tainted 5.4.0-rc5+ #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.4  D27888  9453   9054 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3384 [inline]
  __schedule+0x94f/0x1e70 kernel/sched/core.c:4069
  schedule+0xd9/0x260 kernel/sched/core.c:4136
  schedule_timeout+0x717/0xc50 kernel/time/timer.c:1871
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
  __synchronize_srcu+0x197/0x250 kernel/rcu/srcutree.c:921
  synchronize_srcu_expedited kernel/rcu/srcutree.c:946 [inline]
  synchronize_srcu+0x239/0x3e8 kernel/rcu/srcutree.c:997
  kvm_page_track_unregister_notifier+0xe7/0x130 arch/x86/kvm/page_track.c:212
  kvm_mmu_uninit_vm+0x1e/0x30 arch/x86/kvm/mmu.c:5828
  kvm_arch_destroy_vm+0x4a2/0x5f0 arch/x86/kvm/x86.c:9579
  kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:702 [inline]
  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3444  
[inline]
  kvm_dev_ioctl+0x11e6/0x1610 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3496
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459f49
Code: Bad RIP value.
RSP: 002b:00007f8436c4dc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459f49
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8436c4e6d4
R13: 00000000004c30a8 R14: 00000000004d7018 R15: 00000000ffffffff
INFO: task syz-executor.3:9459 blocked for more than 143 seconds.
       Not tainted 5.4.0-rc5+ #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D27664  9459   9048 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3384 [inline]
  __schedule+0x94f/0x1e70 kernel/sched/core.c:4069
  schedule+0xd9/0x260 kernel/sched/core.c:4136
  schedule_timeout+0x717/0xc50 kernel/time/timer.c:1871
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
  __synchronize_srcu+0x197/0x250 kernel/rcu/srcutree.c:921
  synchronize_srcu+0x2dc/0x3e8 kernel/rcu/srcutree.c:999
  kvm_page_track_unregister_notifier+0xe7/0x130 arch/x86/kvm/page_track.c:212
  kvm_mmu_uninit_vm+0x1e/0x30 arch/x86/kvm/mmu.c:5828
  kvm_arch_destroy_vm+0x4a2/0x5f0 arch/x86/kvm/x86.c:9579
  kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:702 [inline]
  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3444  
[inline]
  kvm_dev_ioctl+0x11e6/0x1610 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3496
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459f49
Code: Bad RIP value.
RSP: 002b:00007f33f0b0ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459f49
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f33f0b0f6d4
R13: 00000000004c30a8 R14: 00000000004d7018 R15: 00000000ffffffff

Showing all locks held in the system:
1 lock held by khungtaskd/1069:
  #0: ffffffff88fab340 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x27e kernel/locking/lockdep.c:5337
1 lock held by rsyslogd/8877:
  #0: ffff88809b271ba0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/8999:
  #0: ffff88809cf04090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f652e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9000:
  #0: ffff8880947ee090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f692e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9001:
  #0: ffff88809f756090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f592e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9002:
  #0: ffff888080ded090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f4d2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9003:
  #0: ffff888099aee090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f6d2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9004:
  #0: ffff8880a82b4090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f512e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/9005:
  #0: ffff8880a7f65090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f3d2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1069 Comm: khungtaskd Not tainted 5.4.0-rc5+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
  watchdog+0x9d0/0xef0 kernel/hung_task.c:289
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
