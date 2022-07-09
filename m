Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D941256C683
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 05:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiGIDwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 23:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiGIDw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 23:52:29 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE00885D6C
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 20:52:27 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id u9-20020a056e021a4900b002dc685a1c13so306040ilv.19
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 20:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bzP6aJ1hpqBF9+fXYAHOKSQcB1ckT2syqlbwROuJMRY=;
        b=FMZXl9jtffHHBH/RM0ihSvu0EkXkYuHbb5FlvSisCe8rn53KiQ2l/sznIl57l63ABd
         gEEoDFUI32t/32qatxdUD5WdwF3MzTs//g0WQJIo++tZDI/bTUbEzf2VwTFDdTz/1B0g
         NSVPRYKEm5vmF1QlQL9AQZUKQ1ImZuPEtZH+CcDIXTHu4EgMmCpxDSY2XUz36oqD3gko
         6qpLWG/EnG7ktVWbDzk7MDYAUeNnOI5cxxOlp1ywOI38vftgkpQS1b45XhaOHi400cBJ
         FyX1+OZOUs/1umWYjhBv82kEIU7RS5sw5/RpFps5q/khWk99IiKFhaoyq5WM7+qiQbx2
         FJrg==
X-Gm-Message-State: AJIora8VE6pF2LOqafwHAfZzV/Qzv22ZhwWWpSoOQX0HBnJVLRzqvhTh
        8u/Grw64Pj5NlLaRxBhSxmdhy4jujW5RXkRx6bhFKcbLMSue
X-Google-Smtp-Source: AGRyM1s20bdFdcGAOgksWJX1dSTZprzEMVajKOK9qR7Pfaa+5+ZtE6c0MfCR03S3qF7nB95HpU/30qF+Ihnx024TLC5pn1U/mPY8
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c01:b0:65d:d998:680c with SMTP id
 w1-20020a0566022c0100b0065dd998680cmr3702130iov.132.1657338747229; Fri, 08
 Jul 2022 20:52:27 -0700 (PDT)
Date:   Fri, 08 Jul 2022 20:52:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004d1b5605e3573f8e@google.com>
Subject: [syzbot] INFO: rcu detected stall in dummy_timer (4)
From:   syzbot <syzbot+879882be5b42e60d4d98@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c1084b6c5620 Merge tag 'soc-fixes-5.19-2' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127615f4080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f3bf7765b1ebd721
dashboard link: https://syzkaller.appspot.com/bug?extid=879882be5b42e60d4d98
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ef6948080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c44524080000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16a1bf04080000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15a1bf04080000
console output: https://syzkaller.appspot.com/x/log.txt?x=11a1bf04080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+879882be5b42e60d4d98@syzkaller.appspotmail.com

imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 5-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 4-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 4-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-...!: (1 GPs behind) idle=a7b/1/0x4000000000000000 softirq=26067/26069 fqs=3 
	(t=10500 jiffies g=29121 q=209 ncpus=2)
rcu: rcu_preempt kthread starved for 10494 jiffies! g29121 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:26424 pid:   16 ppid:     2 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5146 [inline]
 __schedule+0x957/0xe20 kernel/sched/core.c:6458
 schedule+0xeb/0x1b0 kernel/sched/core.c:6530
 schedule_timeout+0x1b9/0x300 kernel/time/timer.c:1935
 rcu_gp_fqs_loop+0x2b9/0xfb0 kernel/rcu/tree.c:1999
 rcu_gp_kthread+0xa5/0x360 kernel/rcu/tree.c:2187
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 4628 Comm: syz-executor415 Not tainted 5.19.0-rc5-syzkaller-00049-gc1084b6c5620 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
RIP: 0010:arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
RIP: 0010:kvm_wait+0x1b0/0x1f0 arch/x86/kernel/kvm.c:1067
Code: 4c 89 e0 48 c1 e8 03 42 8a 04 28 84 c0 75 41 45 8a 34 24 e8 12 05 53 00 44 3a 74 24 1c 75 10 66 90 0f 00 2d f2 05 4f 09 fb f4 <e9> cc fe ff ff fb e9 c6 fe ff ff 44 89 e1 80 e1 07 38 c1 0f 8c 57
RSP: 0018:ffffc9000475f960 EFLAGS: 00000246
RAX: c1a516943b300f00 RBX: 1ffff920008ebf30 RCX: ffffffff816825e8
RDX: dffffc0000000000 RSI: ffffffff8a8d22c0 RDI: ffffffff8ae99700
RBP: ffffc9000475fa30 R08: dffffc0000000000 R09: fffffbfff1fa9204
R10: fffffbfff1fa9204 R11: 1ffffffff1fa9203 R12: ffff888144f9ea10
R13: dffffc0000000000 R14: 1ffff920008ebf03 R15: ffffc9000475f9a0
FS:  00005555558e1300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f88c0e041f0 CR3: 0000000018135000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 pv_wait arch/x86/include/asm/paravirt.h:603 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x70d/0xc60 kernel/locking/qspinlock.c:511
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:591 [inline]
 queued_spin_lock_slowpath+0x42/0x50 arch/x86/include/asm/qspinlock.h:51
 queued_spin_lock include/asm-generic/qspinlock.h:114 [inline]
 do_raw_spin_lock+0x264/0x360 kernel/locking/spinlock_debug.c:115
 spin_lock include/linux/spinlock.h:349 [inline]
 kset_find_obj+0x2e/0x110 lib/kobject.c:881
 module_add_driver+0x1b1/0x2e0 drivers/base/module.c:48
 bus_add_driver+0x393/0x600 drivers/base/bus.c:622
 driver_register+0x2e9/0x3e0 drivers/base/driver.c:240
 usb_gadget_register_driver_owner+0xd9/0x230 drivers/usb/gadget/udc/core.c:1558
 raw_ioctl_run+0xbd/0x300 drivers/usb/gadget/legacy/raw_gadget.c:546
 raw_ioctl+0x163/0xc20 drivers/usb/gadget/legacy/raw_gadget.c:1253
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f88c0e2f467
Code: 3c 1c 48 f7 d8 49 39 c4 72 b8 e8 c4 47 02 00 85 c0 78 bd 48 83 c4 08 4c 89 e0 5b 41 5c c3 0f 1f 44 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc3099d248 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffc3099e2a0 RCX: 00007f88c0e2f467
RDX: 0000000000000000 RSI: 0000000000005501 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000ffff R09: 000000000000000b
R10: 00007ffc3099d2c0 R11: 0000000000000246 R12: 00007ffc3099d270
R13: 0000000000000000 R14: 00007f88c0ea2440 R15: 0000000000000003
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.011 msecs
NMI backtrace for cpu 1
CPU: 1 PID: 4627 Comm: syz-executor415 Not tainted 5.19.0-rc5-syzkaller-00049-gc1084b6c5620 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 nmi_cpu_backtrace+0x473/0x4a0 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x168/0x280 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x236/0x3a0 kernel/rcu/tree_stall.h:371
 print_cpu_stall kernel/rcu/tree_stall.h:667 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:751 [inline]
 rcu_pending kernel/rcu/tree.c:3977 [inline]
 rcu_sched_clock_irq+0xfee/0x19d0 kernel/rcu/tree.c:2675
 update_process_times+0x148/0x1b0 kernel/time/timer.c:1839
 tick_sched_handle kernel/time/tick-sched.c:243 [inline]
 tick_sched_timer+0x377/0x540 kernel/time/tick-sched.c:1480
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x4cb/0xa60 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x3a6/0xfd0 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1095 [inline]
 __sysvec_apic_timer_interrupt+0xf9/0x280 arch/x86/kernel/apic/apic.c:1112
 sysvec_apic_timer_interrupt+0x3e/0xb0 arch/x86/kernel/apic/apic.c:1106
 asm_sysvec_apic_timer_interrupt+0x1b/0x20
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0xd4/0x130 kernel/locking/spinlock.c:194
Code: 9c 8f 44 24 20 42 80 3c 23 00 74 08 4c 89 f7 e8 72 31 a6 f7 f6 44 24 21 02 75 4e 41 f7 c7 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> c7 cd 27 f7 65 8b 05 c8 37 ce 75 85 c0 74 3f 48 c7 04 24 0e 36
RSP: 0018:ffffc900001e07e0 EFLAGS: 00000206
RAX: d93f2df2dd9f9600 RBX: 1ffff9200003c100 RCX: ffffffff816825e8
RDX: dffffc0000000000 RSI: ffffffff8a8d22c0 RDI: 0000000000000001
RBP: ffffc900001e0870 R08: dffffc0000000000 R09: fffffbfff1fa921b
R10: fffffbfff1fa921b R11: 1ffffffff1fa921a R12: dffffc0000000000
R13: 1ffff9200003c0fc R14: ffffc900001e0800 R15: 0000000000000246
 dummy_timer+0x301c/0x3110
 call_timer_fn+0xf5/0x210 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers+0x76a/0x980 kernel/time/timer.c:1790
 run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1803
 __do_softirq+0x382/0x793 kernel/softirq.c:571
 __irq_exit_rcu+0xec/0x170 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1106
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1b/0x20
RIP: 0010:strcmp+0x39/0xa0 lib/string.c:347
Code: bf 00 00 00 00 00 fc ff df 31 db 66 0f 1f 44 00 00 49 8d 3c 1c 48 89 f8 48 c1 e8 03 42 0f b6 04 38 84 c0 75 29 41 0f b6 2c 1c <49> 8d 3c 1e 48 89 f8 48 c1 e8 03 42 0f b6 04 38 84 c0 75 20 41 3a
RSP: 0018:ffffc900044dfc10 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802065bb00
RDX: 0000000000000000 RSI: ffffffff8b478fc0 RDI: ffff888016e8bf50
RBP: 0000000000000073 R08: ffffffff846362b6 R09: fffff5200089bf78
R10: fffff5200089bf79 R11: 1ffff9200089bf78 R12: ffff888016e8bf50
R13: ffff8881458e3a80 R14: ffffffff8b478fc0 R15: dffffc0000000000
 kset_find_obj+0x7b/0x110 lib/kobject.c:884
 module_add_driver+0x1b1/0x2e0 drivers/base/module.c:48
 bus_add_driver+0x393/0x600 drivers/base/bus.c:622
 driver_register+0x2e9/0x3e0 drivers/base/driver.c:240
 usb_gadget_register_driver_owner+0xd9/0x230 drivers/usb/gadget/udc/core.c:1558
 raw_ioctl_run+0xbd/0x300 drivers/usb/gadget/legacy/raw_gadget.c:546
 raw_ioctl+0x163/0xc20 drivers/usb/gadget/legacy/raw_gadget.c:1253
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f88c0e2f467

================================
WARNING: inconsistent lock state
5.19.0-rc5-syzkaller-00049-gc1084b6c5620 #0 Not tainted
--------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
syz-executor415/4627 [HC1[1]:SC1[1]:HE0:SE0] takes:
ffffffff8cbed438 (vmap_area_lock){?.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
ffffffff8cbed438 (vmap_area_lock){?.+.}-{2:2}, at: find_vmap_area+0x1d/0x120 mm/vmalloc.c:1805
{HARDIRQ-ON-W} state was registered at:
  lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5665
  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
  spin_lock include/linux/spinlock.h:349 [inline]
  alloc_vmap_area+0x18bb/0x1ae0 mm/vmalloc.c:1586
  __get_vm_area_node+0x18a/0x380 mm/vmalloc.c:2453
  get_vm_area_caller+0x45/0x50 mm/vmalloc.c:2506
  __ioremap_caller+0x510/0x920 arch/x86/mm/ioremap.c:280
  acpi_os_ioremap include/acpi/acpi_io.h:13 [inline]
  acpi_map drivers/acpi/osl.c:296 [inline]
  acpi_os_map_iomem+0x226/0x4b0 drivers/acpi/osl.c:355
  acpi_tb_acquire_table+0xf5/0x25d drivers/acpi/acpica/tbdata.c:142
  acpi_tb_validate_table drivers/acpi/acpica/tbdata.c:317 [inline]
  acpi_tb_validate_temp_table+0xa6/0x10b drivers/acpi/acpica/tbdata.c:400
  acpi_tb_verify_temp_table+0x82/0x8ed drivers/acpi/acpica/tbdata.c:504
  acpi_reallocate_root_table+0x328/0x584 drivers/acpi/acpica/tbxface.c:180
  acpi_early_init+0xdb/0x536 drivers/acpi/bus.c:1200
  start_kernel+0x40b/0x55b init/main.c:1098
  secondary_startup_64_no_verify+0xcf/0xdb
irq event stamp: 78847
hardirqs last  enabled at (78846): [<ffffffff8a3436eb>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (78846): [<ffffffff8a3436eb>] _raw_spin_unlock_irqrestore+0x8b/0x130 kernel/locking/spinlock.c:194
hardirqs last disabled at (78847): [<ffffffff8a2b421a>] sysvec_apic_timer_interrupt+0xa/0xb0 arch/x86/kernel/apic/apic.c:1106
softirqs last  enabled at (0): [<ffffffff814f65c0>] copy_process+0x1530/0x3fa0 kernel/fork.c:2185
softirqs last disabled at (799): [<ffffffff81519a4c>] __irq_exit_rcu+0xec/0x170 kernel/softirq.c:650

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(vmap_area_lock);
  <Interrupt>
    lock(vmap_area_lock);

 *** DEADLOCK ***

3 locks held by syz-executor415/4627:
 #0: ffff888144f9ea28 (&k->list_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
 #0: ffff888144f9ea28 (&k->list_lock){+.+.}-{2:2}, at: kset_find_obj+0x2e/0x110 lib/kobject.c:881
 #1: ffffc900001e0be0 ((&dum_hcd->timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:41 [inline]
 #1: ffffc900001e0be0 ((&dum_hcd->timer)){+.-.}-{0:0}, at: call_timer_fn+0xbb/0x210 kernel/time/timer.c:1464
 #2: ffffffff8cb23258 (rcu_node_0){-.-.}-{2:2}, at: rcu_dump_cpu_stacks+0xa5/0x3a0 kernel/rcu/tree_stall.h:366

stack backtrace:
CPU: 1 PID: 4627 Comm: syz-executor415 Not tainted 5.19.0-rc5-syzkaller-00049-gc1084b6c5620 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 mark_lock_irq+0xb20/0xf00
 mark_lock+0x21c/0x350 kernel/locking/lockdep.c:4632
 mark_usage kernel/locking/lockdep.c:4524 [inline]
 __lock_acquire+0xb43/0x1f80 kernel/locking/lockdep.c:5007
 lock_acquire+0x1a7/0x400 kernel/locking/lockdep.c:5665
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:349 [inline]
 find_vmap_area+0x1d/0x120 mm/vmalloc.c:1805
 check_heap_object+0x30/0x820 mm/usercopy.c:176
 __check_object_size+0xad/0x210 mm/usercopy.c:250
 check_object_size include/linux/thread_info.h:199 [inline]
 __copy_from_user_inatomic include/linux/uaccess.h:62 [inline]
 copy_from_user_nmi+0x98/0x100 arch/x86/lib/usercopy.c:47
 copy_code arch/x86/kernel/dumpstack.c:91 [inline]
 show_opcodes+0xa2/0x120 arch/x86/kernel/dumpstack.c:121
 show_ip arch/x86/kernel/dumpstack.c:144 [inline]
 show_iret_regs+0x2f/0x60 arch/x86/kernel/dumpstack.c:149
 __show_regs+0x29/0x500 arch/x86/kernel/process_64.c:74
 show_regs_if_on_stack arch/x86/kernel/dumpstack.c:167 [inline]
 show_trace_log_lvl+0x562/0x630 arch/x86/kernel/dumpstack.c:292
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 nmi_cpu_backtrace+0x473/0x4a0 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x168/0x280 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x236/0x3a0 kernel/rcu/tree_stall.h:371
 print_cpu_stall kernel/rcu/tree_stall.h:667 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:751 [inline]
 rcu_pending kernel/rcu/tree.c:3977 [inline]
 rcu_sched_clock_irq+0xfee/0x19d0 kernel/rcu/tree.c:2675
 update_process_times+0x148/0x1b0 kernel/time/timer.c:1839
 tick_sched_handle kernel/time/tick-sched.c:243 [inline]
 tick_sched_timer+0x377/0x540 kernel/time/tick-sched.c:1480
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x4cb/0xa60 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x3a6/0xfd0 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1095 [inline]
 __sysvec_apic_timer_interrupt+0xf9/0x280 arch/x86/kernel/apic/apic.c:1112
 sysvec_apic_timer_interrupt+0x3e/0xb0 arch/x86/kernel/apic/apic.c:1106
 asm_sysvec_apic_timer_interrupt+0x1b/0x20
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0xd4/0x130 kernel/locking/spinlock.c:194
Code: 9c 8f 44 24 20 42 80 3c 23 00 74 08 4c 89 f7 e8 72 31 a6 f7 f6 44 24 21 02 75 4e 41 f7 c7 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> c7 cd 27 f7 65 8b 05 c8 37 ce 75 85 c0 74 3f 48 c7 04 24 0e 36
RSP: 0018:ffffc900001e07e0 EFLAGS: 00000206
RAX: d93f2df2dd9f9600 RBX: 1ffff9200003c100 RCX: ffffffff816825e8
RDX: dffffc0000000000 RSI: ffffffff8a8d22c0 RDI: 0000000000000001
RBP: ffffc900001e0870 R08: dffffc0000000000 R09: fffffbfff1fa921b
R10: fffffbfff1fa921b R11: 1ffffffff1fa921a R12: dffffc0000000000
R13: 1ffff9200003c0fc R14: ffffc900001e0800 R15: 0000000000000246
 dummy_timer+0x301c/0x3110
 call_timer_fn+0xf5/0x210 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers+0x76a/0x980 kernel/time/timer.c:1790
 run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1803
 __do_softirq+0x382/0x793 kernel/softirq.c:571
 __irq_exit_rcu+0xec/0x170 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1106
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1b/0x20
RIP: 0010:strcmp+0x39/0xa0 lib/string.c:347
Code: bf 00 00 00 00 00 fc ff df 31 db 66 0f 1f 44 00 00 49 8d 3c 1c 48 89 f8 48 c1 e8 03 42 0f b6 04 38 84 c0 75 29 41 0f b6 2c 1c <49> 8d 3c 1e 48 89 f8 48 c1 e8 03 42 0f b6 04 38 84 c0 75 20 41 3a
RSP: 0018:ffffc900044dfc10 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802065bb00
RDX: 0000000000000000 RSI: ffffffff8b478fc0 RDI: ffff888016e8bf50
RBP: 0000000000000073 R08: ffffffff846362b6 R09: fffff5200089bf78
R10: fffff5200089bf79 R11: 1ffff9200089bf78 R12: ffff888016e8bf50
R13: ffff8881458e3a80 R14: ffffffff8b478fc0 R15: dffffc0000000000
 kset_find_obj+0x7b/0x110 lib/kobject.c:884
 module_add_driver+0x1b1/0x2e0 drivers/base/module.c:48
 bus_add_driver+0x393/0x600 drivers/base/bus.c:622
 driver_register+0x2e9/0x3e0 drivers/base/driver.c:240
 usb_gadget_register_driver_owner+0xd9/0x230 drivers/usb/gadget/udc/core.c:1558
 raw_ioctl_run+0xbd/0x300 drivers/usb/gadget/legacy/raw_gadget.c:546
 raw_ioctl+0x163/0xc20 drivers/usb/gadget/legacy/raw_gadget.c:1253
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f88c0e2f467
Code: 3c 1c 48 f7 d8 49 39 c4 72 b8 e8 c4 47 02 00 85 c0 78 bd 48 83 c4 08 4c 89 e0 5b 41 5c c3 0f 1f 44 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc3099d248 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffc3099e2a0 RCX: 00007f88c0e2f467
RDX: 0000000000000000 RSI: 0000000000005501 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000ffff R09: 000000000000000b
R10: 00007ffc3099d2c0 R11: 0000000000000246 R12: 00007ffc3099d270
R13: 0000000000000000 R14: 00007f88c0ea2440 R15: 0000000000000003
 </TASK>
Code: 3c 1c 48 f7 d8 49 39 c4 72 b8 e8 c4 47 02 00 85 c0 78 bd 48 83 c4 08 4c 89 e0 5b 41 5c c3 0f 1f 44 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc3099d248 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffc3099e2a0 RCX: 00007f88c0e2f467
RDX: 0000000000000000 RSI: 0000000000005501 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000ffff R09: 000000000000000b
R10: 00007ffc3099d2c0 R11: 0000000000000246 R12: 00007ffc3099d270
R13: 0000000000000000 R14: 00007f88c0ea2440 R15: 0000000000000003
 </TASK>
imon 5-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 4-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 5-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 5-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 6-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 5-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 4-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 1-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 5-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 4-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 5-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 1-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 6-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 2-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 3-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 5-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 4-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
imon 6-1:0.0: imon usb_rx_callback_intf0: status(-71): ignored
----------------
Code disassembly (best guess):
   0:	4c 89 e0             	mov    %r12,%rax
   3:	48 c1 e8 03          	shr    $0x3,%rax
   7:	42 8a 04 28          	mov    (%rax,%r13,1),%al
   b:	84 c0                	test   %al,%al
   d:	75 41                	jne    0x50
   f:	45 8a 34 24          	mov    (%r12),%r14b
  13:	e8 12 05 53 00       	callq  0x53052a
  18:	44 3a 74 24 1c       	cmp    0x1c(%rsp),%r14b
  1d:	75 10                	jne    0x2f
  1f:	66 90                	xchg   %ax,%ax
  21:	0f 00 2d f2 05 4f 09 	verw   0x94f05f2(%rip)        # 0x94f061a
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	e9 cc fe ff ff       	jmpq   0xfffffefb <-- trapping instruction
  2f:	fb                   	sti
  30:	e9 c6 fe ff ff       	jmpq   0xfffffefb
  35:	44 89 e1             	mov    %r12d,%ecx
  38:	80 e1 07             	and    $0x7,%cl
  3b:	38 c1                	cmp    %al,%cl
  3d:	0f                   	.byte 0xf
  3e:	8c                   	.byte 0x8c
  3f:	57                   	push   %rdi


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
