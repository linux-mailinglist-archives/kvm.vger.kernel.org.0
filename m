Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5BD3DE79D
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 09:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhHCHzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 03:55:38 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:37508 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhHCHzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 03:55:37 -0400
Received: by mail-io1-f69.google.com with SMTP id e7-20020a0566020447b029050017e563a6so13702298iov.4
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 00:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hGCRalz/8EwvCU3RGsi2BHZEUzQXFjQVuZ0VHjyBbAk=;
        b=GdGqZFNBWKD7geGNNCcnnJxpHyInGWvUWXpIhpiclvmjAldf4iC7ScyD7UYVct/c85
         MNim5K3XZTmsgYJk7C9oA/P+NpBfAVJgCKELGmql8etmJQOGa4V52A18yPxQWUDqJIFJ
         K/s4/KT9/vVKa36Wo87Z8dqBYSQhRdPIClRwzlXwzJ+rFHI+iPqp+vrDC/tfC5FsaaYw
         kFqZhmpKZCy2yrpPXG11Okn6FCGdRjzD0y/4S2wo+FFcdz8oUGBU5hu27JdwBkoXPQSL
         u+wJ8z9V5OsXge8Hax8Sx+n9DMEwODj9FDJ6StpPWfJOlF2FZ0Qs3dDCDiDo4M30WEki
         02OA==
X-Gm-Message-State: AOAM531QiveiZZmHaUPmVem1B/N8s77QDdiNaD1InLzx1MWXHqwPrEku
        UtG2CVZA3/ssu4qrSrV+aqUuv2+M4AtjpaANZ/ZHKR5JedDL
X-Google-Smtp-Source: ABdhPJyZ/gsLq+1t+4YrjnW0TDPSC+uJ0o1QzbL4bHRl9NaFfBJL9ZfbUlkgjw2lBvRmDVy+2N2KATBamN+n1EndeDdvqS/bUKUG
MIME-Version: 1.0
X-Received: by 2002:a6b:f40a:: with SMTP id i10mr102202iog.139.1627977325820;
 Tue, 03 Aug 2021 00:55:25 -0700 (PDT)
Date:   Tue, 03 Aug 2021 00:55:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003544c405c8a3026a@google.com>
Subject: [syzbot] INFO: rcu detected stall in newstat
From:   syzbot <syzbot+84ef57449019b1be878d@syzkaller.appspotmail.com>
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

HEAD commit:    7e96bf476270 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=111d1e2a300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1dee114394f7d2c2
dashboard link: https://syzkaller.appspot.com/bug?extid=84ef57449019b1be878d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f2aac9d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15470c66300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+84ef57449019b1be878d@syzkaller.appspotmail.com

mceusb 2-1:0.0: Error: urb status = -71
mceusb 5-1:0.0: Error: urb status = -71
mceusb 2-1:0.0: Error: urb status = -71
mceusb 5-1:0.0: Error: urb status = -71
mceusb 2-1:0.0: Error: urb status = -71
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 1, t=10502 jiffies, g=13449, q=1758)
rcu: All QSes seen, last rcu_preempt kthread activity 6502 (4295042261-4295035759), jiffies_till_next_fqs=1, root ->qsmask 0x0
rcu: rcu_preempt kthread starved for 6502 jiffies! g13449 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:29096 pid:   14 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 schedule_timeout+0x14a/0x2a0 kernel/time/timer.c:1879
 rcu_gp_fqs_loop kernel/rcu/tree.c:1996 [inline]
 rcu_gp_kthread+0xd34/0x1980 kernel/rcu/tree.c:2169
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 8589 Comm: systemd-udevd Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:halt arch/x86/include/asm/irqflags.h:99 [inline]
RIP: 0010:kvm_wait+0xbb/0xf0 arch/x86/kernel/kvm.c:883
Code: 5b d9 47 00 8b 74 24 0c 48 8b 3c 24 eb 82 e8 6c de 47 00 eb 07 0f 00 2d c3 d3 55 08 fb f4 eb 9b eb 07 0f 00 2d b6 d3 55 08 f4 <eb> c5 89 74 24 0c 48 89 3c 24 e8 36 74 87 00 8b 74 24 0c 48 8b 3c
RSP: 0018:ffffc90001b87660 EFLAGS: 00000046
RAX: 0000000000000003 RBX: 0000000000000000 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffffff8b981e40
RBP: ffffffff8b981e40 R08: 0000000000000001 R09: ffffffff8b981e40
R10: fffffbfff17303c8 R11: 0000000000000001 R12: 0000000000000000
R13: fffffbfff17303c8 R14: 0000000000000001 R15: ffff8880b9c52980
FS:  00007f48df6fe8c0(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff47502b08 CR3: 00000000141f0000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 pv_wait arch/x86/include/asm/paravirt.h:597 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:585 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 rcu_note_context_switch+0x294/0x16e0 kernel/rcu/tree_plugin.h:355
 __schedule+0x21f/0x26f0 kernel/sched/core.c:5837
 preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:6328
 irqentry_exit+0x31/0x80 kernel/entry/common.c:427
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:__sanitizer_cov_trace_const_cmp1+0x77/0x80 kernel/kcov.c:272
Code: f0 72 27 41 0f b6 fb 41 0f b6 c9 48 83 c2 01 48 c7 44 30 e0 01 00 00 00 48 89 7c 30 e8 48 89 4c 30 f0 4c 89 54 d8 20 48 89 10 <5b> c3 0f 1f 80 00 00 00 00 53 41 89 fb 41 89 f1 bf 03 00 00 00 65
RSP: 0018:ffffc90001b87a18 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000075 RCX: ffff8880361be2c0
RDX: 0000000000000000 RSI: ffff8880361be2c0 RDI: 0000000000000003
RBP: 000000031dee9eb7 R08: 0000000000000000 R09: 0000000000000075
R10: ffffffff81c97ccd R11: 0000000000000000 R12: ffffc90001b87bec
R13: e2f55236f51925a6 R14: ffffc90001b87bb0 R15: ffff8880342d0825
 link_path_walk.part.0+0x73d/0xd00 fs/namei.c:2272
 link_path_walk fs/namei.c:2210 [inline]
 path_lookupat+0xc8/0x860 fs/namei.c:2437
 filename_lookup+0x1c6/0x5b0 fs/namei.c:2467
 user_path_at include/linux/namei.h:57 [inline]
 vfs_statx+0x142/0x390 fs/stat.c:203
 vfs_fstatat fs/stat.c:225 [inline]
 vfs_stat include/linux/fs.h:3382 [inline]
 __do_sys_newstat+0x91/0x110 fs/stat.c:367
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f48de570295
Code: 00 00 00 e8 5d 01 00 00 48 83 c4 18 c3 0f 1f 84 00 00 00 00 00 83 ff 01 48 89 f0 77 30 48 89 c7 48 89 d6 b8 04 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 03 f3 c3 90 48 8b 15 d1 db 2b 00 f7 d8 64 89
RSP: 002b:00007fff47503388 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 0000559e49eea790 RCX: 00007f48de570295
RDX: 00007fff47503390 RSI: 00007fff47503390 RDI: 00007fff47503440
RBP: 00007fff475034b0 R08: 000000000000c0c0 R09: 0000000000000000
R10: 00007fff475034c0 R11: 0000000000000246 R12: 00007fff475034c0
R13: 0000000000000001 R14: 0000559e49ed7a40 R15: 000000000000000e

================================
WARNING: inconsistent lock state
5.14.0-rc3-syzkaller #0 Not tainted
--------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
ksoftirqd/1/19 [HC0[0]:SC1[1]:HE0:SE0] takes:
ffffffff8b981e58 (rcu_node_0){?.-.}-{2:2}, at: print_other_cpu_stall kernel/rcu/tree_stall.h:543 [inline]
ffffffff8b981e58 (rcu_node_0){?.-.}-{2:2}, at: check_cpu_stall kernel/rcu/tree_stall.h:709 [inline]
ffffffff8b981e58 (rcu_node_0){?.-.}-{2:2}, at: rcu_pending kernel/rcu/tree.c:3922 [inline]
ffffffff8b981e58 (rcu_node_0){?.-.}-{2:2}, at: rcu_sched_clock_irq+0xc9a/0x20c0 kernel/rcu/tree.c:2641
{IN-HARDIRQ-W} state was registered at:
  lock_acquire kernel/locking/lockdep.c:5625 [inline]
  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
  _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
  rcu_report_exp_cpu_mult+0x1c/0x280 kernel/rcu/tree_exp.h:237
  flush_smp_call_function_queue+0x34b/0x640 kernel/smp.c:663
  __sysvec_call_function_single+0x95/0x3d0 arch/x86/kernel/smp.c:248
  sysvec_call_function_single+0x8e/0xc0 arch/x86/kernel/smp.c:243
  asm_sysvec_call_function_single+0x12/0x20 arch/x86/include/asm/idtentry.h:646
  lock_acquire+0x1ef/0x510 kernel/locking/lockdep.c:5593
  down_write_killable+0x95/0x170 kernel/locking/rwsem.c:1417
  mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
  __bprm_mm_init fs/exec.c:257 [inline]
  bprm_mm_init fs/exec.c:376 [inline]
  alloc_bprm+0x3be/0x8f0 fs/exec.c:1521
  kernel_execve+0x55/0x460 fs/exec.c:1941
  call_usermodehelper_exec_async+0x2e3/0x580 kernel/umh.c:112
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
irq event stamp: 428515
hardirqs last  enabled at (428514): [<ffffffff892ce380>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (428514): [<ffffffff892ce380>] _raw_spin_unlock_irqrestore+0x50/0x70 kernel/locking/spinlock.c:191
hardirqs last disabled at (428515): [<ffffffff892a264b>] sysvec_apic_timer_interrupt+0xb/0xc0 arch/x86/kernel/apic/apic.c:1100
softirqs last  enabled at (392664): [<ffffffff81456d5d>] run_ksoftirqd kernel/softirq.c:920 [inline]
softirqs last  enabled at (392664): [<ffffffff81456d5d>] run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
softirqs last disabled at (392669): [<ffffffff81456d5d>] run_ksoftirqd kernel/softirq.c:920 [inline]
softirqs last disabled at (392669): [<ffffffff81456d5d>] run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(rcu_node_0);
  <Interrupt>
    lock(rcu_node_0);

 *** DEADLOCK ***

2 locks held by ksoftirqd/1/19:
 #0: ffffc90000fafc58 ((&dum_hcd->timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:35 [inline]
 #0: ffffc90000fafc58 ((&dum_hcd->timer)){+.-.}-{0:0}, at: call_timer_fn+0xd5/0x6b0 kernel/time/timer.c:1409
 #1: ffffffff8b981e58 (rcu_node_0){?.-.}-{2:2}, at: print_other_cpu_stall kernel/rcu/tree_stall.h:543 [inline]
 #1: ffffffff8b981e58 (rcu_node_0){?.-.}-{2:2}, at: check_cpu_stall kernel/rcu/tree_stall.h:709 [inline]
 #1: ffffffff8b981e58 (rcu_node_0){?.-.}-{2:2}, at: rcu_pending kernel/rcu/tree.c:3922 [inline]
 #1: ffffffff8b981e58 (rcu_node_0){?.-.}-{2:2}, at: rcu_sched_clock_irq+0xc9a/0x20c0 kernel/rcu/tree.c:2641

stack backtrace:
CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_usage_bug kernel/locking/lockdep.c:203 [inline]
 valid_state kernel/locking/lockdep.c:3933 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4136 [inline]
 mark_lock.cold+0x61/0x8e kernel/locking/lockdep.c:4593
 mark_held_locks+0x9f/0xe0 kernel/locking/lockdep.c:4194
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:4212 [inline]
 lockdep_hardirqs_on_prepare kernel/locking/lockdep.c:4280 [inline]
 lockdep_hardirqs_on_prepare+0x135/0x400 kernel/locking/lockdep.c:4232
 trace_hardirqs_on+0x5b/0x1c0 kernel/trace/trace_preemptirq.c:49
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x38/0x70 kernel/locking/spinlock.c:191
Code: 74 24 10 e8 5a 65 2d f8 48 89 ef e8 02 db 2d f8 81 e3 00 02 00 00 75 25 9c 58 f6 c4 02 75 2d 48 85 db 74 01 fb bf 01 00 00 00 <e8> 43 b5 21 f8 65 8b 05 4c 0c d5 76 85 c0 74 0a 5b 5d c3 e8 e0 10
RSP: 0018:ffffc90000faf9f0 EFLAGS: 00000206
RAX: 0000000000000006 RBX: 0000000000000200 RCX: 1ffffffff1fa5092
RDX: 0000000000000000 RSI: 0000000000000101 RDI: 0000000000000001
RBP: ffff888021db8000 R08: 0000000000000001 R09: ffffffff8fcd9977
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888146dbe440
R13: ffff888016ba9600 R14: dffffc0000000000 R15: ffff8880242d7900
 spin_unlock_irqrestore include/linux/spinlock.h:409 [inline]
 dummy_timer+0x12f6/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:2001
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1419
 expire_timers kernel/time/timer.c:1464 [inline]
 __run_timers.part.0+0x675/0xa50 kernel/time/timer.c:1732
 __run_timers kernel/time/timer.c:1713 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1745
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:920 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
------------[ cut here ]------------
timer: dummy_timer+0x0/0x32b0 include/linux/list.h:112 preempt leak: 00000100 -> 00000101
WARNING: CPU: 1 PID: 19 at kernel/time/timer.c:1425 call_timer_fn+0x664/0x6b0 kernel/time/timer.c:1425
Modules linked in:
CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:call_timer_fn+0x664/0x6b0 kernel/time/timer.c:1425
Code: e8 41 ae 10 00 89 da 4c 89 f6 48 c7 c7 a0 9d 8d 89 65 8b 0d 1e cd 9d 7e 81 e1 ff ff ff 7f c6 05 b0 ae f3 0b 01 e8 b7 b8 83 07 <0f> 0b e9 f4 fb ff ff e8 10 ae 10 00 0f 0b e9 6f fd ff ff e8 04 ae
RSP: 0018:ffffc90000fafc20 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000100 RCX: 0000000000000000
RDX: ffff888011e54140 RSI: ffffffff815cad15 RDI: fffff520001f5f76
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c4b1e R11: 0000000000000000 R12: 0000000000000000
R13: 1ffff920001f5f85 R14: ffffffff859db710 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb590071168 CR3: 000000001842b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 expire_timers kernel/time/timer.c:1464 [inline]
 __run_timers.part.0+0x675/0xa50 kernel/time/timer.c:1732
 __run_timers kernel/time/timer.c:1713 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1745
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:920 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
