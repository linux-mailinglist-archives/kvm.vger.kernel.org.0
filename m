Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 046D718C77C
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 07:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgCTGdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 02:33:13 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:46492 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgCTGdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 02:33:12 -0400
Received: by mail-il1-f199.google.com with SMTP id a2so4125811ill.13
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 23:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aIjWOOeVSbMqGFDf1KXbdBDP3+ZOOZ1c61Dtot2dRLk=;
        b=mOVl8U6pTsfhplPq9EZsx/zw9sHcofMtBGS08Cyhg3unLud9WMNqAD+VQOZ4HMJI+j
         PqxDbWGSy4mDFBJNNFbDbvud/oQ7BpX/XOUhnm57Md/36NwMzviyUh63MiVEmJXLrK9N
         Wk/3qvSuU+dbcn4NxswAhD1cYJ7pG48KmusVu5NppraAXNCaQnfbJGNlg9v/XrT2SPdI
         SkMGFD8I7KeEba2XYZg8MMPiYndPR1HwqbW6fm+mUvcXZbIxdlFI8yzxTV2UlyeV6N6W
         o6kYOKkKuR5V9KO4buSO+fVy3udvsR0Az37WzCHSDPnW7CqHQoW2k7l9zxzI7JYCgMKQ
         k8lw==
X-Gm-Message-State: ANhLgQ3NwYESAb+mXWqsquc23V0upm3w6I3WnmzOQqWO3WqH+RMCFuFw
        h31xWbDi5C/2aGl0zKeEB0ohJcUyvqHQwjxFW3ZETa1s5ftN
X-Google-Smtp-Source: ADFU+vtTq8cIJVuWt0w5KzYYk7j+KyKZMlUfEI2gf6aCXrGEhN2SYodBb+wCExJNrmBYFSZnrAmpUyZX8fMHlb5TGTenb24Q2T1o
MIME-Version: 1.0
X-Received: by 2002:a02:94cb:: with SMTP id x69mr6360372jah.19.1584685991884;
 Thu, 19 Mar 2020 23:33:11 -0700 (PDT)
Date:   Thu, 19 Mar 2020 23:33:11 -0700
In-Reply-To: <000000000000e0d794057592192b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a079b705a1437544@google.com>
Subject: Re: INFO: rcu detected stall in kvm_vcpu_ioctl
From:   syzbot <syzbot+e9b1e8f574404b6e4ed3@syzkaller.appspotmail.com>
To:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    770fbb32 Add linux-next specific files for 20200228
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1589e139e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=576314276bce4ad5
dashboard link: https://syzkaller.appspot.com/bug?extid=e9b1e8f574404b6e4ed3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1576a61de00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178ef32de00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e9b1e8f574404b6e4ed3@syzkaller.appspotmail.com

hrtimer: interrupt took 60270 ns
rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-....: (15560 ticks this GP) idle=16a/1/0x4000000000000002 softirq=11581/11583 fqs=5243 
	(t=10500 jiffies g=8917 q=171)
NMI backtrace for cpu 1
CPU: 1 PID: 9821 Comm: syz-executor148 Not tainted 5.6.0-rc3-next-20200228-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:165 [inline]
 rcu_dump_cpu_stacks+0x19e/0x1e8 kernel/rcu/tree_stall.h:254
 print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
 rcu_pending kernel/rcu/tree.c:3237 [inline]
 rcu_sched_clock_irq.cold+0x560/0xcfa kernel/rcu/tree.c:2308
 update_process_times+0x25/0x60 kernel/time/timer.c:1727
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:171
 tick_sched_timer+0x4e/0x140 kernel/time/tick-sched.c:1314
 __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
 __hrtimer_run_queues+0x32c/0xdd0 kernel/time/hrtimer.c:1579
 hrtimer_interrupt+0x312/0x770 kernel/time/hrtimer.c:1641
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1119 [inline]
 smp_apic_timer_interrupt+0x15b/0x600 arch/x86/kernel/apic/apic.c:1144
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:lock_acquire+0x1b/0x420 kernel/locking/lockdep.c:4709
Code: ff 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 48 b8 00 00 00 00 00 fc ff df 41 57 4d 89 cf 41 56 41 89 ce 41 55 41 89 d5 41 54 <41> 89 f4 55 48 89 fd 65 48 8b 14 25 c0 1e 02 00 48 8d ba 9c 08 00
RSP: 0018:ffffc90001e575f8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: dffffc0000000000 RBX: ffff88808ac24140 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88808e54b318
RBP: ffffffff8821ec40 R08: 0000000000000001 R09: 0000000000000000
R10: ffffed1011329681 R11: ffff88808994b40b R12: 0000000000000045
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
 __might_fault mm/memory.c:4780 [inline]
 __might_fault+0x152/0x1d0 mm/memory.c:4765
 __copy_from_user include/linux/uaccess.h:69 [inline]
 __kvm_read_guest_page+0x65/0xc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2046
 kvm_fetch_guest_virt+0x13d/0x1b0 arch/x86/kvm/x86.c:5473
 __do_insn_fetch_bytes+0x2f9/0x6c0 arch/x86/kvm/emulate.c:907
 x86_decode_insn+0x176c/0x5730 arch/x86/kvm/emulate.c:5179
 x86_emulate_instruction+0x8bc/0x1c20 arch/x86/kvm/x86.c:6787
 kvm_mmu_page_fault+0x37b/0x1660 arch/x86/kvm/mmu/mmu.c:5488
 vmx_handle_exit+0x2b8/0x1710 arch/x86/kvm/vmx/vmx.c:5955
 vcpu_enter_guest+0x33df/0x6120 arch/x86/kvm/x86.c:8447
 vcpu_run arch/x86/kvm/x86.c:8511 [inline]
 kvm_arch_vcpu_ioctl_run+0x41c/0x1790 arch/x86/kvm/x86.c:8733
 kvm_vcpu_ioctl+0x493/0xe60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2932
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x444349
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc83efaa28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffc83efaa30 RCX: 0000000000444349
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000402070 R09: 0000000000402070
R10: fffffffffffffffe R11: 0000000000000246 R12: 00000000004053f0
R13: 0000000000405480 R14: 0000000000000000 R15: 0000000000000000

