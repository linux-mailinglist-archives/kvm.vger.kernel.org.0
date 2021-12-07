Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6C246B9FD
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 12:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhLGLXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 06:23:52 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:47909 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhLGLXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 06:23:52 -0500
Received: by mail-io1-f69.google.com with SMTP id o11-20020a0566022e0b00b005e95edf792dso12238552iow.14
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 03:20:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FLdmf4Rq17HycYROUSA7LsjtKRSQdTlOPzNz3T5AO/c=;
        b=WjldQCoPFfeZlzN5HpXg4l+Urye5CrMdKDIJCqvlAfCdAFLjyhJQvNjwiygNxG5MzW
         jHeSxbM09m7auOZbH9d2gzteiYjjwDh8TavC5YN8VdN1MbM0LhSUX03Neo4zPSBPALNx
         E5K+euUlGEvYI9sVvMs85y7fvHPh2ginwtxabf0XWJ/uDkVzVrRXg2VZQtvRB2VWtFhM
         YvjBNKYjh5F7XYx5ohkYH0CqZGjAslyCW/BD17U9ziT5IAEasQzWpCEEtYbdg/UFbJG2
         jgRIjQI5lJv3opfYAzE3Cj23UcZwWUWOklhZ7b4uuBZywctptG9gkO//7X9Wv9Qmmy4S
         IIIg==
X-Gm-Message-State: AOAM530Y34mGimhyphwh/W9kS65XJKyJr9znKXqnN6FIHHb8j/gAIu65
        Uc4YCtFdOff4aaBneOaAYDUz5lxeh+9re2J11slIXbnJVVCS
X-Google-Smtp-Source: ABdhPJwXzj88yby1G8XCe3pT8+q/qG6Fbo4XGQNYFGIwh70be5G373CY2cBJkvsDSzG8dYv+1vaSWUHBmkRfcfL6s0UiJbZG5uc6
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d04:: with SMTP id c4mr37776539iow.146.1638876021917;
 Tue, 07 Dec 2021 03:20:21 -0800 (PST)
Date:   Tue, 07 Dec 2021 03:20:21 -0800
In-Reply-To: <00000000000051f90e05d2664f1d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001e0bf405d28c8fdb@google.com>
Subject: Re: [syzbot] WARNING in nested_vmx_vmexit
From:   syzbot <syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, fgheet255t@gmail.com,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, mlevitsk@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    f80ef9e49fdf Merge tag 'docs-5.16-3' of git://git.lwn.net/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b11d89b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d5e878e3399b6cc
dashboard link: https://syzkaller.appspot.com/bug?extid=f1d2136db9c80d4733e8
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1603533ab00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=175b5f3db00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6503 at arch/x86/kvm/vmx/nested.c:4550 nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4549
Modules linked in:
CPU: 0 PID: 6503 Comm: syz-executor767 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4549
Code: df e8 07 8e a9 00 e9 b1 f7 ff ff 89 d9 80 e1 07 38 c1 0f 8c 51 eb ff ff 48 89 df e8 3d 8d a9 00 e9 44 eb ff ff e8 53 b9 5d 00 <0f> 0b e9 2e f8 ff ff e8 47 b9 5d 00 0f 0b e9 00 f1 ff ff 89 e9 80
RSP: 0018:ffffc90001a5fa50 EFLAGS: 00010293
RAX: ffffffff8126de2d RBX: 0000000000000000 RCX: ffff88807482d700
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 0000000000000001 R08: ffffffff8126d650 R09: ffffed10041fb808
R10: ffffed10041fb808 R11: 0000000000000000 R12: ffff888020fdc000
R13: ffff8880797e8000 R14: dffffc0000000000 R15: 1ffff1100f2fd05d
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020002000 CR3: 000000000c88e000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vmx_leave_nested arch/x86/kvm/vmx/nested.c:6222 [inline]
 nested_vmx_free_vcpu+0x83/0xc0 arch/x86/kvm/vmx/nested.c:330
 vmx_free_vcpu+0x11f/0x2a0 arch/x86/kvm/vmx/vmx.c:6799
 kvm_arch_vcpu_destroy+0x6b/0x240 arch/x86/kvm/x86.c:10990
 kvm_vcpu_destroy+0x29/0x90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:441
 kvm_free_vcpus arch/x86/kvm/x86.c:11427 [inline]
 kvm_arch_destroy_vm+0x3ef/0x6b0 arch/x86/kvm/x86.c:11546
 kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1189 [inline]
 kvm_put_kvm+0x751/0xe40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1220
 kvm_vm_release+0x42/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1243
 __fput+0x3fc/0x870 fs/file_table.c:280
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0x705/0x24f0 kernel/exit.c:832
 do_group_exit+0x168/0x2d0 kernel/exit.c:929
 __do_sys_exit_group+0x13/0x20 kernel/exit.c:940
 __se_sys_exit_group+0x10/0x10 kernel/exit.c:938
 __x64_sys_exit_group+0x37/0x40 kernel/exit.c:938
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe968c95c09
Code: Unable to access opcode bytes at RIP 0x7fe968c95bdf.
RSP: 002b:00007ffc762ba918 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fe968d09270 RCX: 00007fe968c95c09
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe968d09270
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

