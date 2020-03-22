Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9CA18E7AA
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 09:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgCVIxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 04:53:15 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35459 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgCVIxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 04:53:14 -0400
Received: by mail-il1-f199.google.com with SMTP id t10so627045ilf.2
        for <kvm@vger.kernel.org>; Sun, 22 Mar 2020 01:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fs5jc3eIRHHo8L1ECG1ULfTEDpxhJnx6F8XmPXsog80=;
        b=c3eulu1D1kEA/FU78Wx2FyhHTGu7Lw1lFEb1K3tGcW078Zp111+1txA4QL4FLWD2k5
         EoEO/n6Ajb8DxA3Nc7cqEwbyen0WpdBvFuMSRE2EBcPV7dddxc4ONGs9KbI6hFWfRBDL
         rd3t7Tu95mdxiSfJ9h/HaNDLQsX79tXuOMqELKLUdxWAnjA2AHbhCM18ADVeC6gSml6n
         sOAgoh/lrDvN1CD6Lb8AYVUzAvgC/fR/KRIBe6DVFgqODiV/LRTdtrqCRCBwC0Ftl3HY
         8qNnX9A+Y55l3A1ZUdtSD4vRpGVo0OWyibEle8I+6qGMgN9pLBrkgajBiNQ2+qdUoYLI
         V8iQ==
X-Gm-Message-State: ANhLgQ3YDGma+YyFLGmOIz1AjOfMDSqXw2Y/g+edtX75bhXCrXhV65+s
        4Q8hJjoVxcqMZer7AYOXz1s1ML9aZTPTDmG3LL8C39PoUy6q
X-Google-Smtp-Source: ADFU+vuNmvXsGzWBPx94GchqX7DyUV81SJhWLj2po4wAn6k5uduZHPAkZ4hvi09+TXeGV9vhrPchthdNwhk1v89lXBTuT9P5mARf
MIME-Version: 1.0
X-Received: by 2002:a6b:b241:: with SMTP id b62mr7802759iof.99.1584867193709;
 Sun, 22 Mar 2020 01:53:13 -0700 (PDT)
Date:   Sun, 22 Mar 2020 01:53:13 -0700
In-Reply-To: <000000000000277a0405a16bd5c9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000018e82205a16da6f0@google.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in handle_external_interrupt_irqoff
From:   syzbot <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com>
To:     bp@alien8.de, clang-built-linux@googlegroups.com,
        dvyukov@google.com, hpa@zytor.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    b74b991f Merge tag 'block-5.6-20200320' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13059373e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
dashboard link: https://syzkaller.appspot.com/bug?extid=3f29ca2efb056a761e38
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1199c0c5e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15097373e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000086
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 9330b067 P4D 9330b067 PUD 9e66f067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8439 Comm: syz-executor724 Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x86
Code: Bad RIP value.
RSP: 0018:ffffc900022e7998 EFLAGS: 00010086
RAX: ffffc900022e79c8 RBX: fffffe0000000000 RCX: ffff88809dcf2500
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000ec0 R08: ffffffff83987523 R09: ffffffff811c7eca
R10: ffff88809dcf2500 R11: 0000000000000002 R12: dffffc0000000000
R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
FS:  0000000001d0d880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000005c CR3: 00000000978c3000 CR4: 00000000001426e0
Call Trace:
 handle_external_interrupt_irqoff+0x154/0x280 arch/x86/kvm/vmx/vmx.c:6274
 kvm_before_interrupt arch/x86/kvm/x86.h:343 [inline]
 handle_external_interrupt_irqoff+0x132/0x280 arch/x86/kvm/vmx/vmx.c:6272
 __irqentry_text_start+0x8/0x8
 vcpu_enter_guest+0x6c77/0x9290 arch/x86/kvm/x86.c:8405
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:476
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 tomoyo_path_number_perm+0x525/0x690 security/tomoyo/file.c:736
 security_file_ioctl+0x55/0xb0 security/security.c:1441
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
 __lock_acquire+0xc5a/0x1bc0 kernel/locking/lockdep.c:3954
 paravirt_write_msr arch/x86/include/asm/paravirt.h:167 [inline]
 wrmsrl arch/x86/include/asm/paravirt.h:200 [inline]
 native_x2apic_icr_write arch/x86/include/asm/apic.h:249 [inline]
 __x2apic_send_IPI_dest arch/x86/kernel/apic/x2apic_phys.c:112 [inline]
 x2apic_send_IPI+0x96/0xc0 arch/x86/kernel/apic/x2apic_phys.c:41
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 hlock_class kernel/locking/lockdep.c:163 [inline]
 mark_lock+0x107/0x1650 kernel/locking/lockdep.c:3642
 lock_acquire+0x154/0x250 kernel/locking/lockdep.c:4484
 rcu_lock_acquire+0x9/0x30 include/linux/rcupdate.h:208
 vcpu_run+0x3a3/0xd50 arch/x86/kvm/x86.c:8513
 kvm_arch_vcpu_ioctl_run+0x419/0x880 arch/x86/kvm/x86.c:8735
 kvm_vcpu_ioctl+0x67c/0xa80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2932
 lock_is_held include/linux/lockdep.h:361 [inline]
 rcu_read_lock_sched_held+0x106/0x170 kernel/rcu/update.c:121
 kvm_vm_release+0x50/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:858
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl fs/ioctl.c:763 [inline]
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl+0xf9/0x160 fs/ioctl.c:770
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
Modules linked in:
CR2: 0000000000000086
---[ end trace 480d6b60d5a9226d ]---
RIP: 0010:0x86
Code: Bad RIP value.
RSP: 0018:ffffc900022e7998 EFLAGS: 00010086
RAX: ffffc900022e79c8 RBX: fffffe0000000000 RCX: ffff88809dcf2500
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000ec0 R08: ffffffff83987523 R09: ffffffff811c7eca
R10: ffff88809dcf2500 R11: 0000000000000002 R12: dffffc0000000000
R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
FS:  0000000001d0d880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000005c CR3: 00000000978c3000 CR4: 00000000001426e0

