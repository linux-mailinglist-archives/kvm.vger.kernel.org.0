Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA6320B9FF
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 22:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgFZUIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 16:08:20 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:32855 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgFZUIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 16:08:20 -0400
Received: by mail-io1-f71.google.com with SMTP id x2so7058950iof.0
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 13:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dtnkD+akOW0FGGW63gF00wjPRoN0fMAttFlcVW1sdeQ=;
        b=H7wTFBhPS+mg6Ohe8VJNpcuB1xpnm3dICUtWISZSedDo1ekB3nMBw0fRc5muqvuMEU
         DkCLRK6t/UVKXHLK7+1y97j/O4U3jSYup99zhPusSwCVK9lWfw0Jo/09dViwko0AO+5O
         lc8KcPcWwkNvc5aZyHO9KKbe0ALWKdbRWvfopjk3CvHsZx5DSjBDFnpCc7VONvzAwlsK
         BYXXCiVyKmmLAgWNs6D7b1cdSIsH4cULfWf1CeOp3GITROy2GENawzoC+4FIOgyUt588
         pwKPpo32Irhd6wOlu5D7gYhTLKMeSSnna9CcAFqNLTvx4t3mLHxg6gArBfRurnXRWP5A
         5Yag==
X-Gm-Message-State: AOAM530d19JSoPIT26lgZLz3EQyVk/dU59o5jRRsaedmjY3zaNSLdVN+
        1CnUeAMVUOru7vSNKS6MtUp1WObDylLHLf+LPkhaLsXZUNHp
X-Google-Smtp-Source: ABdhPJyhhHPTgYRHLjTWhT0wiJEBuw33hT2u+i0HguFA5DDP5BEdzCQmPm15ik/HGLCLO+DY/CMM5QsjLPA041era1o5XCxRescX
MIME-Version: 1.0
X-Received: by 2002:a92:cf42:: with SMTP id c2mr4946215ilr.13.1593202099251;
 Fri, 26 Jun 2020 13:08:19 -0700 (PDT)
Date:   Fri, 26 Jun 2020 13:08:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002e703905a902457b@google.com>
Subject: general protection fault in pvclock_gtod_notify
From:   syzbot <syzbot+b46fb19f175c5c7d1f03@syzkaller.appspotmail.com>
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

HEAD commit:    4a21185c Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16958f4d100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=b46fb19f175c5c7d1f03
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1080e9c5100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1685d2e3100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b46fb19f175c5c7d1f03@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0x1ffffffff135a2b4: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:pvclock_gtod_notify+0x0/0x4d0 arch/x86/kvm/x86.c:7400
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 0018:ffffc90000007bf8 EFLAGS: 00010046
RAX: 1ffffffff135a2b4 RBX: 00000000ffffffff RCX: ffffffff814db41b
RDX: ffffffff8c90a9c0 RSI: 0000000000000000 RDI: ffffffff89ad15a0
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8c58aa27
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff89ad15a0
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8ae8dd4e78 CR3: 00000000a1f9e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 update_pvclock_gtod kernel/time/timekeeping.c:578 [inline]
 timekeeping_update+0x28a/0x4a0 kernel/time/timekeeping.c:672
 timekeeping_advance+0x663/0x9a0 kernel/time/timekeeping.c:2119
 tick_do_update_jiffies64.part.0+0x183/0x290 kernel/time/tick-sched.c:101
 tick_do_update_jiffies64 kernel/time/tick-sched.c:64 [inline]
 tick_sched_do_timer kernel/time/tick-sched.c:147 [inline]
 tick_sched_timer+0x22c/0x290 kernel/time/tick-sched.c:1313
 __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
 __hrtimer_run_queues+0x1d5/0xfc0 kernel/time/hrtimer.c:1584
 hrtimer_interrupt+0x32a/0x930 kernel/time/hrtimer.c:1646
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x142/0x5e0 arch/x86/kernel/apic/apic.c:1097
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 sysvec_apic_timer_interrupt+0x18f/0x220 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:596
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: ff 4c 89 ef e8 63 70 cb f9 e9 8e fe ff ff 48 89 df e8 56 70 cb f9 eb 8a cc cc cc cc e9 07 00 00 00 0f 00 2d 24 79 61 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 14 79 61 00 f4 c3 cc cc 55 53 e8 a9
RSP: 0018:ffffffff89a07c70 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffffffff155cb92
RDX: ffffffff89a86580 RSI: ffffffff87e736f8 RDI: ffffffff89a86e00
RBP: ffff8880a6b58064 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880a6b58064
R13: 1ffffffff1340f98 R14: ffff8880a6b58065 R15: 0000000000000001
 arch_safe_halt arch/x86/include/asm/paravirt.h:150 [inline]
 acpi_safe_halt+0x8d/0x110 drivers/acpi/processor_idle.c:111
 acpi_idle_do_entry+0x15c/0x1b0 drivers/acpi/processor_idle.c:525
 acpi_idle_enter+0x3f9/0xab0 drivers/acpi/processor_idle.c:651
 cpuidle_enter_state+0xff/0x960 drivers/cpuidle/cpuidle.c:234
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:345
 call_cpuidle kernel/sched/idle.c:117 [inline]
 cpuidle_idle_call kernel/sched/idle.c:207 [inline]
 do_idle+0x431/0x6a0 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:365
 start_kernel+0x9cb/0xa06 init/main.c:1043
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243
Modules linked in:
---[ end trace 7b036d48895e60ed ]---
RIP: 0010:pvclock_gtod_notify+0x0/0x4d0 arch/x86/kvm/x86.c:7400
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <00> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
RSP: 0018:ffffc90000007bf8 EFLAGS: 00010046
RAX: 1ffffffff135a2b4 RBX: 00000000ffffffff RCX: ffffffff814db41b
RDX: ffffffff8c90a9c0 RSI: 0000000000000000 RDI: ffffffff89ad15a0
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8c58aa27
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff89ad15a0
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8ae8dd4e78 CR3: 00000000a1f9e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
