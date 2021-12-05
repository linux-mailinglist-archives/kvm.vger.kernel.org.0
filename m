Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C71F468B21
	for <lists+kvm@lfdr.de>; Sun,  5 Dec 2021 14:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhLENpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Dec 2021 08:45:50 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:38544 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhLENpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Dec 2021 08:45:50 -0500
Received: by mail-io1-f71.google.com with SMTP id l124-20020a6b3e82000000b005ed165a1506so6176957ioa.5
        for <kvm@vger.kernel.org>; Sun, 05 Dec 2021 05:42:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BLoWO8fU/36NhcynxRAv4DAnmt9NebCBPZToTu7jfYs=;
        b=55HdTEnlUscoQ52NbCDwlcfRycKonzV61qUpuRnEkbQpdT+xjSHvqVL5ZaWTpDSB1l
         t0KHsOUOm/iYwLsc8SarOP3wEmRB9kEuhbwTXKXt2BLW/miC3sQjG4cwkR/IBsE/wRGY
         Eyn7gIyZgAMSB5WpZeh/1upsr4ARKMCP0H25smg9/AXUWaeyTHQzcZ2nt7sXmab1gZ6R
         3qa3DUV2PvLBZZkdvPnpyUCk9agga+f+3Vlyj0uzzxbapcNC/nME8wAPRzBbhYahYWc1
         y0I4d70grXBmpqdnyWrDGpca1b5GR2HHm9yUg3b0eLrAiD+N9Psb4CXG/vsSNSEGpltT
         Qu+g==
X-Gm-Message-State: AOAM5303Kefq4SQxMTB7Auwe33yUxg+8CF2sndAF6eFUAQdITv2jpdqN
        YhnbquXd0RcsR3vmTWJ/NTNzZvlSykW5+1i7yX9ytzciUL3X
X-Google-Smtp-Source: ABdhPJzDpALVFkLTv3cF+GFRyhzE6CAXHW18DU8Sfw1XQ4Dx9HxYL4n0bZh6sz49+UxzGYA6idE/XnhUhbVlSAKUWJNW2+0vIMqW
MIME-Version: 1.0
X-Received: by 2002:a6b:7306:: with SMTP id e6mr28206422ioh.25.1638711742821;
 Sun, 05 Dec 2021 05:42:22 -0800 (PST)
Date:   Sun, 05 Dec 2021 05:42:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000051f90e05d2664f1d@google.com>
Subject: [syzbot] WARNING in nested_vmx_vmexit
From:   syzbot <syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5f58da2befa5 Merge tag 'drm-fixes-2021-12-03-1' of git://a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14927309b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e9ea28d2c3c2c389
dashboard link: https://syzkaller.appspot.com/bug?extid=f1d2136db9c80d4733e8
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 21158 at arch/x86/kvm/vmx/nested.c:4548 nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4547
Modules linked in:
CPU: 0 PID: 21158 Comm: syz-executor.1 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4547
Code: df e8 17 88 a9 00 e9 b1 f7 ff ff 89 d9 80 e1 07 38 c1 0f 8c 51 eb ff ff 48 89 df e8 4d 87 a9 00 e9 44 eb ff ff e8 63 b3 5d 00 <0f> 0b e9 2e f8 ff ff e8 57 b3 5d 00 0f 0b e9 00 f1 ff ff 89 e9 80
RSP: 0018:ffffc9000439f6e8 EFLAGS: 00010293
RAX: ffffffff8126d4cd RBX: 0000000000000000 RCX: ffff888032290000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 0000000000000001 R08: ffffffff8126ccf0 R09: ffffed1003cd9808
R10: ffffed1003cd9808 R11: 0000000000000000 R12: ffff88801e6cc000
R13: ffff88802f96e000 R14: dffffc0000000000 R15: 1ffff11005f2dc5d
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb73aecedd8 CR3: 00000000143a4000 CR4: 00000000003526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vmx_leave_nested arch/x86/kvm/vmx/nested.c:6220 [inline]
 nested_vmx_free_vcpu+0x83/0xc0 arch/x86/kvm/vmx/nested.c:330
 vmx_free_vcpu+0x11f/0x2a0 arch/x86/kvm/vmx/vmx.c:6799
 kvm_arch_vcpu_destroy+0x6b/0x240 arch/x86/kvm/x86.c:10989
 kvm_vcpu_destroy+0x29/0x90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:441
 kvm_free_vcpus arch/x86/kvm/x86.c:11426 [inline]
 kvm_arch_destroy_vm+0x3ef/0x6b0 arch/x86/kvm/x86.c:11545
 kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1189 [inline]
 kvm_put_kvm+0x751/0xe40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1220
 kvm_vcpu_release+0x53/0x60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3489
 __fput+0x3fc/0x870 fs/file_table.c:280
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0x705/0x24f0 kernel/exit.c:832
 do_group_exit+0x168/0x2d0 kernel/exit.c:929
 get_signal+0x1740/0x2120 kernel/signal.c:2852
 arch_do_signal_or_restart+0x9c/0x730 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x191/0x220 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
 do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f3388806b19
Code: Unable to access opcode bytes at RIP 0x7f3388806aef.
RSP: 002b:00007f338773a218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f338891a0e8 RCX: 00007f3388806b19
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f338891a0e8
RBP: 00007f338891a0e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f338891a0ec
R13: 00007fffbe0e838f R14: 00007f338773a300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
