Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8EA4154103
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 10:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgBFJSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 04:18:11 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:50897 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgBFJSK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 04:18:10 -0500
Received: by mail-io1-f71.google.com with SMTP id e13so3527151iob.17
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 01:18:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=F/YgXsQezNfnzRwAhiZ34iyNL92Vrra+LrLR7z1xL7A=;
        b=AIpfGzGUAlBn71/MIbVGAcUIMVh6Wv0ni2oiNVQLcobz91YIcumZXAP0wBbrB8DRGS
         yUvHUPWu68yNKnvBczo1ukzObpvFoxj+J3w8UCIDqDOVFK4VvPyyfnmkKYDaFF+5t/un
         v5oXEeqFjFvMY6O7MBZpMiznYLfxUB0P44w2o8oVWtNSJkVx3kwJAH6/yaeQc62HozdN
         zpzlR54se/BFmz46KhePGyxdKEIjGsM9kK+d4ofnRv09UjbmxjSsyMn7UX6LBO1iGV9x
         BHD4tNIbbdDqRCjkIQdxQ4lUzOmH3uAmlJTk+KeXLTX4KVos3/LTo52AOVi8X3oZ1fBF
         gPYA==
X-Gm-Message-State: APjAAAVxhVmyEU/NRfKnAVkTMPeBI3dNke/SltTOQ6VBODxV1Scy9wLR
        B/XOPSsOpF78iTeojDA2oTJV6KyC4lb+Y+EYCEuXV+swjIzp
X-Google-Smtp-Source: APXvYqxA952ys+wNAHXU4FI6yQnJghYenjU6PWhcUITPY+DjXjgiwm321D7ztyweIycNz6zSGfURMAyOL4rjtI8nLCy5AuDw0CRT
MIME-Version: 1.0
X-Received: by 2002:a92:58d7:: with SMTP id z84mr2695432ilf.179.1580980689701;
 Thu, 06 Feb 2020 01:18:09 -0800 (PST)
Date:   Thu, 06 Feb 2020 01:18:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006813c8059de4c0f2@google.com>
Subject: INFO: rcu detected stall in ksys_ioctl
From:   syzbot <syzbot+4484fe09c3f9ab423f32@syzkaller.appspotmail.com>
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

syzbot found the following crash on:

HEAD commit:    94f2630b Merge tag '5.6-rc-small-smb3-fix-for-stable' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16aec776e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=99db4e42d047be3
dashboard link: https://syzkaller.appspot.com/bug?extid=4484fe09c3f9ab423f32
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ab98d9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1416f735e00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10249f66e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12249f66e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14249f66e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4484fe09c3f9ab423f32@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
	(detected by 1, t=10502 jiffies, g=10641, q=2)
rcu: All QSes seen, last rcu_preempt kthread activity 10503 (4295021069-4295010566), jiffies_till_next_fqs=1, root ->qsmask 0x0
syz-executor543 R  running task    27000 10496  10495 0x00000000
Call Trace:
 <IRQ>
 sched_show_task kernel/sched/core.c:5954 [inline]
 sched_show_task.cold+0x2ee/0x35d kernel/sched/core.c:5929
 print_other_cpu_stall kernel/rcu/tree_stall.h:430 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:558 [inline]
 rcu_pending kernel/rcu/tree.c:3030 [inline]
 rcu_sched_clock_irq.cold+0xb23/0xc37 kernel/rcu/tree.c:2276
 update_process_times+0x2d/0x70 kernel/time/timer.c:1726
 tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:171
 tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1314
 __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
 __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
 hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1641
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
 smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1135
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752 [inline]
RIP: 0010:lock_acquire+0x20b/0x410 kernel/locking/lockdep.c:4487
Code: 94 08 00 00 00 00 00 00 48 c1 e8 03 80 3c 10 00 0f 85 d3 01 00 00 48 83 3d 19 cf 58 08 00 0f 84 53 01 00 00 48 8b 7d c8 57 9d <0f> 1f 44 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 65 8b
RSP: 0018:ffffc90001f57ad0 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff136753f RBX: ffff888089b4a140 RCX: ffffffff815a7ff0
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: 0000000000000286
RBP: ffffc90001f57b18 R08: 1ffffffff16a137b R09: fffffbfff16a137c
R10: ffff888089b4aa00 R11: ffff888089b4a140 R12: ffffc90001fcae18
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000002
 rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
 srcu_read_lock include/linux/srcu.h:155 [inline]
 vcpu_enter_guest+0x323d/0x6100 arch/x86/kvm/x86.c:8364
 vcpu_run arch/x86/kvm/x86.c:8445 [inline]
 kvm_arch_vcpu_ioctl_run+0x430/0x17b0 arch/x86/kvm/x86.c:8667
 kvm_vcpu_ioctl+0x4dc/0xfc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2931
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x123/0x180 fs/ioctl.c:747
 __do_sys_ioctl fs/ioctl.c:756 [inline]
 __se_sys_ioctl fs/ioctl.c:754 [inline]
 __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4478a9
Code: e8 8c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb c4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdda97c7c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004478a9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000009
RBP: 00000000006d2018 R08: 00000000004002e0 R09: 00000000004002e0
R10: 00000000004002e0 R11: 0000000000000246 R12: 0000000000404200
R13: 0000000000404290 R14: 0000000000000000 R15: 0000000000000000
rcu: rcu_preempt kthread starved for 10542 jiffies! g10641 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29224    10      2 0x80004000
Call Trace:
 context_switch kernel/sched/core.c:3386 [inline]
 __schedule+0x934/0x1f90 kernel/sched/core.c:4082
 schedule+0xdc/0x2b0 kernel/sched/core.c:4156
 schedule_timeout+0x486/0xc50 kernel/time/timer.c:1895
 rcu_gp_fqs_loop kernel/rcu/tree.c:1658 [inline]
 rcu_gp_kthread+0xa10/0x1940 kernel/rcu/tree.c:1818
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
