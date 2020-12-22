Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6AC2E0740
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 09:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgLVIg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 03:36:57 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:50804 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLVIg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 03:36:57 -0500
Received: by mail-il1-f199.google.com with SMTP id t8so11197934ils.17
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 00:36:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6myWaa8K9xi7b8Wgl0oK5a7b+azrf32/eUO0QSEaWnw=;
        b=pC0R89/pV8sd9GGFk0LNublnOZbU/+5KtkQ8DEtijqgjzKUo61tXUvqGDVbiFM6Mi5
         uKBB8nmidfLEfAnLHFJEbewBx78ORS30DV4RlSQPA1H9JTFeVU+dTuPf1an7i56zWCT/
         BfzUjiFyvjMlP2fBz/XV9ww7P3tC33zzCEHt73A2+MaKvnzuAZz6vu2r4lr3b3sMQpa1
         RunrpgKw7mw1GQGdOTfuTrP4ChHzEIW4ZUC2WwUF84+iEAqd2dZPJzkQSDiCqR2USeLO
         akM+GN/u/z9654gPTf4R81JFZqmfmwN4DKyempIBiw/7UAl+BVlBjUx+nhIByyG6E5KG
         5Eiw==
X-Gm-Message-State: AOAM532DnuI4kNN9mTB0yRQNn4DZ1lphAidVgLmpyg4b8gQboBCTUWjI
        k7vOAOHfKZF9f5X1mQ1RG16lo/uEyCGRcy8cMYbK1N5t267C
X-Google-Smtp-Source: ABdhPJw19rvJhuyRqPbLIQThv+MeiywSWq0qGCnFzM0se/RZMldtYABf1arArUipx8jI1HrZhjzhf2nLweWYWXsVQtDzGETbqANF
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8aa:: with SMTP id a10mr8245101ilt.157.1608626176594;
 Tue, 22 Dec 2020 00:36:16 -0800 (PST)
Date:   Tue, 22 Dec 2020 00:36:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5173d05b7097755@google.com>
Subject: UBSAN: shift-out-of-bounds in kvm_vcpu_after_set_cpuid
From:   syzbot <syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com>
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

HEAD commit:    5e60366d Merge tag 'fallthrough-fixes-clang-5.11-rc1' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11c7046b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db720fe37a6a41d8
dashboard link: https://syzkaller.appspot.com/bug?extid=e87846c48bf72bc85311
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com

================================================================================
UBSAN: shift-out-of-bounds in arch/x86/kvm/mmu.h:52:16
shift exponent 64 is too large for 64-bit type 'long long unsigned int'
CPU: 1 PID: 11156 Comm: syz-executor.1 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 rsvd_bits arch/x86/kvm/mmu.h:52 [inline]
 kvm_vcpu_after_set_cpuid.cold+0x35/0x3a arch/x86/kvm/cpuid.c:181
 kvm_vcpu_ioctl_set_cpuid+0x28e/0x970 arch/x86/kvm/cpuid.c:273
 kvm_arch_vcpu_ioctl+0x1091/0x2d70 arch/x86/kvm/x86.c:4699
 kvm_vcpu_ioctl+0x7b9/0xdb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3386
 kvm_vcpu_compat_ioctl+0x1a2/0x340 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3430
 __do_compat_sys_ioctl+0x1d3/0x230 fs/ioctl.c:842
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7fe8549
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f55e20cc EFLAGS: 00000296 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000004008ae8a
RDX: 00000000200000c0 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
