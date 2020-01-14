Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9B13B50B
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 23:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgANWEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 17:04:13 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:44505 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728754AbgANWEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 17:04:13 -0500
Received: by mail-il1-f200.google.com with SMTP id h87so11623210ild.11
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 14:04:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eMHW3wOLXebnWAJm9k4zcnGaWoDH60aioQnabNtGfyo=;
        b=ieFiMPYH73dSPkLSsPwXVgtvLoAbueMU3hIr6CVunsSZAKa6DqinWHKGRo5J1G+YHa
         YTHcjOT0ZyK70OnJh5QH8zhjHGQQ0hYfvi0gs5Y6gXaR8jWzii1JIgn7DOG+YronfZtJ
         4YWXvsWGTZXC4yXhkNVMO2c0cdcoTlEgddxqMBqVYAyxodIVM0pWty++tB89ZgA8jChd
         hmUsxmyc+hKzuUJeMpPTrDKJOkSPApcOMq68D7g939Ftl1a68vzNbwa45NHmA+hbZRZu
         iLCfMF+/BNjAxIZRDZVMe/5tp4A9hKdW5nybOOMtaaknu8FOBcN0Fdt9rDKr51Qzd6ia
         CIvg==
X-Gm-Message-State: APjAAAUOjBipJRapctMPpFdWtmCYhdSCdFwlV+jxpB5/T3Zz1/9F8SYE
        p3Y1dHwChSdgVRPPi433RQqMZ9bBLtQBqUJ2zmq/8Tihn3FA
X-Google-Smtp-Source: APXvYqz+F+uIHCsCPgWMIVFLIEtm+KjeYSok2IWRCOjyN//4I+0dhvSlqjfGw1/XFBPusaiG1RyfcfseAU66iAJELq50R18YY/py
MIME-Version: 1.0
X-Received: by 2002:a02:ba91:: with SMTP id g17mr21576179jao.106.1579039452053;
 Tue, 14 Jan 2020 14:04:12 -0800 (PST)
Date:   Tue, 14 Jan 2020 14:04:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a04d03059c20c560@google.com>
Subject: BUG: workqueue lockup (5)
From:   syzbot <syzbot+f0b66b520b54883d4b9d@syzkaller.appspotmail.com>
To:     alexander.deucher@amd.com, christian.koenig@amd.com,
        harry.wentland@amd.com, himanshujha199640@gmail.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, rex.zhu@amd.com, rkrcmar@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    e69ec487 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=158223fee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=f0b66b520b54883d4b9d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156c569ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132251b9e00000

The bug was bisected to:

commit ebe02de2c60caa3ee5a1b39c7c8b2a40e1fda2d8
Author: Himanshu Jha <himanshujha199640@gmail.com>
Date:   Tue Aug 29 13:12:27 2017 +0000

     drm/amd/powerplay/hwmgr: Remove null check before kfree

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12e9cb25e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11e9cb25e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16e9cb25e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f0b66b520b54883d4b9d@syzkaller.appspotmail.com
Fixes: ebe02de2c60c ("drm/amd/powerplay/hwmgr: Remove null check before  
kfree")

BUG: workqueue lockup - pool cpus=1 node=0 flags=0x0 nice=0 stuck for 261s!
Showing busy workqueues and worker pools:
workqueue events: flags=0x0
   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=3/256 refcnt=4
     pending: defense_work_handler, free_obj_work, cache_reap

======================================================
WARNING: possible circular locking dependency detected
5.5.0-rc5-syzkaller #0 Not tainted
------------------------------------------------------
swapper/0/0 is trying to acquire lock:
ffffffff8999a700 (console_owner){-.-.}, at: log_next  
kernel/printk/printk.c:516 [inline]
ffffffff8999a700 (console_owner){-.-.}, at: console_unlock+0x415/0xf00  
kernel/printk/printk.c:2460

but task is already holding lock:
ffff8880ae936b58 (&(&pool->lock)->rlock){-.-.}, at: show_workqueue_state  
kernel/workqueue.c:4767 [inline]
ffff8880ae936b58 (&(&pool->lock)->rlock){-.-.}, at:  
show_workqueue_state.cold+0x156/0x802 kernel/workqueue.c:4740

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&(&pool->lock)->rlock){-.-.}:
        __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
        _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
        spin_lock include/linux/spinlock.h:338 [inline]
        __queue_work+0x285/0x1280 kernel/workqueue.c:1444
        queue_work_on+0x19f/0x210 kernel/workqueue.c:1513
        queue_work include/linux/workqueue.h:494 [inline]
        schedule_work include/linux/workqueue.h:552 [inline]
        put_pwq kernel/workqueue.c:1113 [inline]
        put_pwq+0x178/0x1d0 kernel/workqueue.c:1098
        put_pwq_unlocked.part.0+0x34/0x70 kernel/workqueue.c:1130
        put_pwq_unlocked kernel/workqueue.c:1124 [inline]
        apply_wqattrs_cleanup.part.0+0xf6/0x160 kernel/workqueue.c:3878
        apply_wqattrs_cleanup kernel/workqueue.c:4017 [inline]
        apply_workqueue_attrs_locked+0xeb/0x140 kernel/workqueue.c:4015
        apply_workqueue_attrs+0x31/0x50 kernel/workqueue.c:4046
        padata_setup_cpumasks kernel/padata.c:365 [inline]
        padata_alloc_pd+0x298/0xb60 kernel/padata.c:436
        padata_alloc kernel/padata.c:996 [inline]
        padata_alloc_possible+0x1b6/0x480 kernel/padata.c:1042
        pcrypt_init_padata+0x20/0x105 crypto/pcrypt.c:311
        pcrypt_init+0x76/0x11b crypto/pcrypt.c:342
        do_one_initcall+0x120/0x820 init/main.c:938
        do_initcall_level init/main.c:1006 [inline]
        do_initcalls init/main.c:1014 [inline]
        do_basic_setup init/main.c:1031 [inline]
        kernel_init_freeable+0x4ca/0x570 init/main.c:1202
        kernel_init+0x12/0x1bf init/main.c:1109
        ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

-> #3 (&pool->lock/1){..-.}:
        __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
        _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
        spin_lock include/linux/spinlock.h:338 [inline]
        __queue_work+0x285/0x1280 kernel/workqueue.c:1444
        queue_work_on+0x19f/0x210 kernel/workqueue.c:1513
        queue_work include/linux/workqueue.h:494 [inline]
        tty_schedule_flip drivers/tty/tty_buffer.c:413 [inline]
        tty_flip_buffer_push+0xc5/0x100 drivers/tty/tty_buffer.c:556
        pty_write+0x1a6/0x200 drivers/tty/pty.c:125
        n_tty_write+0xb1d/0x1080 drivers/tty/n_tty.c:2356
        do_tty_write drivers/tty/tty_io.c:962 [inline]
        tty_write+0x496/0x7f0 drivers/tty/tty_io.c:1046
        __vfs_write+0x8a/0x110 fs/read_write.c:494
        vfs_write+0x268/0x5d0 fs/read_write.c:558
        ksys_write+0x14f/0x290 fs/read_write.c:611
        __do_sys_write fs/read_write.c:623 [inline]
        __se_sys_write fs/read_write.c:620 [inline]
        __x64_sys_write+0x73/0xb0 fs/read_write.c:620
        do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #2 (&(&port->lock)->rlock){-.-.}:
        __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
        _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
        tty_port_tty_get+0x24/0x100 drivers/tty/tty_port.c:288
        tty_port_default_wakeup+0x16/0x40 drivers/tty/tty_port.c:47
        tty_port_tty_wakeup+0x57/0x70 drivers/tty/tty_port.c:388
        uart_write_wakeup+0x46/0x70 drivers/tty/serial/serial_core.c:104
        serial8250_tx_chars+0x495/0xaf0  
drivers/tty/serial/8250/8250_port.c:1761
        serial8250_handle_irq.part.0+0x261/0x2b0  
drivers/tty/serial/8250/8250_port.c:1834
        serial8250_handle_irq drivers/tty/serial/8250/8250_port.c:1820  
[inline]
        serial8250_default_handle_irq+0xc0/0x150  
drivers/tty/serial/8250/8250_port.c:1850
        serial8250_interrupt+0xf1/0x1a0  
drivers/tty/serial/8250/8250_core.c:126
        __handle_irq_event_percpu+0x15d/0x970 kernel/irq/handle.c:149
        handle_irq_event_percpu+0x74/0x160 kernel/irq/handle.c:189
        handle_irq_event+0xa7/0x134 kernel/irq/handle.c:206
        handle_edge_irq+0x25e/0x8d0 kernel/irq/chip.c:830
        generic_handle_irq_desc include/linux/irqdesc.h:156 [inline]
        do_IRQ+0xde/0x280 arch/x86/kernel/irq.c:250
        ret_from_intr+0x0/0x36
        native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:60
        arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:690
        default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
        cpuidle_idle_call kernel/sched/idle.c:154 [inline]
        do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
        cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
        start_secondary+0x2f4/0x410 arch/x86/kernel/smpboot.c:264
        secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242

-> #1 (&port_lock_key){-.-.}:
        __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
        _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
        serial8250_console_write+0x253/0x9a0  
drivers/tty/serial/8250/8250_port.c:3142
        univ8250_console_write+0x5f/0x70  
drivers/tty/serial/8250/8250_core.c:587
        call_console_drivers kernel/printk/printk.c:1791 [inline]
        console_unlock+0xb7a/0xf00 kernel/printk/printk.c:2473
        vprintk_emit+0x2a0/0x700 kernel/printk/printk.c:1996
        vprintk_default+0x28/0x30 kernel/printk/printk.c:2023
        vprintk_func+0x7e/0x189 kernel/printk/printk_safe.c:386
        printk+0xba/0xed kernel/printk/printk.c:2056
        register_console+0x745/0xb50 kernel/printk/printk.c:2798
        univ8250_console_init+0x3e/0x4b  
drivers/tty/serial/8250/8250_core.c:682
        console_init+0x461/0x67b kernel/printk/printk.c:2884
        start_kernel+0x653/0x943 init/main.c:712
        x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
        x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
        secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242

-> #0 (console_owner){-.-.}:
        check_prev_add kernel/locking/lockdep.c:2476 [inline]
        check_prevs_add kernel/locking/lockdep.c:2581 [inline]
        validate_chain kernel/locking/lockdep.c:2971 [inline]
        __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
        lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
        console_lock_spinning_enable kernel/printk/printk.c:1654 [inline]
        console_unlock+0x47f/0xf00 kernel/printk/printk.c:2470
        vprintk_emit+0x2a0/0x700 kernel/printk/printk.c:1996
        vprintk_default+0x28/0x30 kernel/printk/printk.c:2023
        vprintk_func+0x7e/0x189 kernel/printk/printk_safe.c:386
        printk+0xba/0xed kernel/printk/printk.c:2056
        show_pwq+0x154/0x7cb kernel/workqueue.c:4673
        show_workqueue_state kernel/workqueue.c:4769 [inline]
        show_workqueue_state.cold+0x1a6/0x802 kernel/workqueue.c:4740
        wq_watchdog_timer_fn+0x511/0x590 kernel/workqueue.c:5783
        call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
        expire_timers kernel/time/timer.c:1449 [inline]
        __run_timers kernel/time/timer.c:1773 [inline]
        __run_timers kernel/time/timer.c:1740 [inline]
        run_timer_softirq+0xdca/0x1790 kernel/time/timer.c:1788
        __do_softirq+0x262/0x98c kernel/softirq.c:292
        invoke_softirq kernel/softirq.c:373 [inline]
        irq_exit+0x19b/0x1e0 kernel/softirq.c:413
        exiting_irq arch/x86/include/asm/apic.h:536 [inline]
        smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
        apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
        native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:60
        arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:690
        default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
        cpuidle_idle_call kernel/sched/idle.c:154 [inline]
        do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
        cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
        rest_init+0x23b/0x371 init/main.c:451
        arch_call_rest_init+0xe/0x1b
        start_kernel+0x904/0x943 init/main.c:784
        x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
        x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
        secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242

other info that might help us debug this:

Chain exists of:
   console_owner --> &pool->lock/1 --> &(&pool->lock)->rlock

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&(&pool->lock)->rlock);
                                lock(&pool->lock/1);
                                lock(&(&pool->lock)->rlock);
   lock(console_owner);

  *** DEADLOCK ***

4 locks held by swapper/0/0:
  #0: ffffc90000007d50 ((&wq_watchdog_timer)){+.-.}, at: lockdep_copy_map  
include/linux/lockdep.h:172 [inline]
  #0: ffffc90000007d50 ((&wq_watchdog_timer)){+.-.}, at:  
call_timer_fn+0xe0/0x780 kernel/time/timer.c:1394
  #1: ffffffff899a5340 (rcu_read_lock){....}, at:  
show_workqueue_state+0x0/0x120 kernel/workqueue.c:4638
  #2: ffff8880ae936b58 (&(&pool->lock)->rlock){-.-.}, at:  
show_workqueue_state kernel/workqueue.c:4767 [inline]
  #2: ffff8880ae936b58 (&(&pool->lock)->rlock){-.-.}, at:  
show_workqueue_state.cold+0x156/0x802 kernel/workqueue.c:4740
  #3: ffffffff8999a960 (console_lock){+.+.}, at: console_trylock_spinning  
kernel/printk/printk.c:1716 [inline]
  #3: ffffffff8999a960 (console_lock){+.+.}, at: vprintk_emit+0x283/0x700  
kernel/printk/printk.c:1995

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1685
  check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1809
  check_prev_add kernel/locking/lockdep.c:2476 [inline]
  check_prevs_add kernel/locking/lockdep.c:2581 [inline]
  validate_chain kernel/locking/lockdep.c:2971 [inline]
  __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  console_lock_spinning_enable kernel/printk/printk.c:1654 [inline]
  console_unlock+0x47f/0xf00 kernel/printk/printk.c:2470
  vprintk_emit+0x2a0/0x700 kernel/printk/printk.c:1996
  vprintk_default+0x28/0x30 kernel/printk/printk.c:2023
  vprintk_func+0x7e/0x189 kernel/printk/printk_safe.c:386
  printk+0xba/0xed kernel/printk/printk.c:2056
  show_pwq+0x154/0x7cb kernel/workqueue.c:4673
  show_workqueue_state kernel/workqueue.c:4769 [inline]
  show_workqueue_state.cold+0x1a6/0x802 kernel/workqueue.c:4740
  wq_watchdog_timer_fn+0x511/0x590 kernel/workqueue.c:5783
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers kernel/time/timer.c:1773 [inline]
  __run_timers kernel/time/timer.c:1740 [inline]
  run_timer_softirq+0xdca/0x1790 kernel/time/timer.c:1788
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: e8 bb db f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 24 4d 51  
00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 14 4d 51 00 fb f4 <c3> cc 55 48 89  
e5 41 57 41 56 41 55 41 54 53 e8 be 8a 8b f9 e8 89
RSP: 0018:ffffffff89807ce8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff132669e RBX: ffffffff8987a140 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff8987a9d4
RBP: ffffffff89807d18 R08: ffffffff8987a140 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff8a7b87c0 R14: 0000000000000000 R15: 0000000000000000
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:690
  default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
  rest_init+0x23b/0x371 init/main.c:451
  arch_call_rest_init+0xe/0x1b
  start_kernel+0x904/0x943 init/main.c:784
  x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
  x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
workqueue events_power_efficient: flags=0x80
   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=2/256 refcnt=3
     pending: fb_flashcursor, neigh_periodic_work
   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=2/256 refcnt=3
     pending: check_lifetime, gc_worker
workqueue rcu_gp: flags=0x8
   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
     in-flight: 2826:srcu_invoke_callbacks
workqueue mm_percpu_wq: flags=0x8
   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
     pending: vmstat_update
workqueue dm_bufio_cache: flags=0x8
   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
     pending: work_fn
workqueue ipv6_addrconf: flags=0x40008
   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/1 refcnt=2
     pending: addrconf_verify_work
pool 2: cpus=1 node=0 flags=0x0 nice=0 hung=262s workers=3 idle: 3106 26


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
