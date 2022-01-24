Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C6B498397
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 16:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbiAXPdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 10:33:21 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:50808 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiAXPdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 10:33:20 -0500
Received: by mail-io1-f72.google.com with SMTP id m185-20020a6bbcc2000000b00605898d6b61so12385771iof.17
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 07:33:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Mry99N6iPIKy3cjwP5Cz2+xI8pMASkNhENwJAhEUElM=;
        b=t/dx/X7SzVKlEioqrTo5XVfBdztK9NfYIs0ocSmDfysZwgBb+zz5TDoDnVrQSeyRJr
         LykcEJ7NCRoY6R+qy489ihmpHIx40NltGy6ki1IVbkdfQTr6DnbIjeSDmRrRyPdoHOLA
         EVertD3TilJG6rxKFLZ7tHYO/QHkC2oE52W8waTK6T10FDsZT5TW4Deu0/P5TFuSVRiY
         vdC4jY3Mhi3yI90XQS5XxvveoNlw8tDBBt3nnVXO6WVe6MmCGT4LeZ12BbI3jjjyDZDf
         XwP1aG4CaforHfm4c8tzg2CmKnvsbaaWtGbrsUxJ8RVHnbEKDqVaSqHRaEukGQc/WACy
         ckHg==
X-Gm-Message-State: AOAM530OIYwqToR8jRNizFWonII9r+PwEWQZwGLaHnnZiGTzCEjrTbJD
        0KTvXZEQLoIbvakZqntfbRIMjOrrm7htVuRHpuXZ0K3DjRl9
X-Google-Smtp-Source: ABdhPJzhUPkKA7cUxXakLctP8xEq5DBmQoVBiEn3H9/v82Whk0G7QSUFIGTrHR5mQBsotDViMgenfJDBsnEITr1RaS8ltnN5U/u0
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:144a:: with SMTP id p10mr9296910ilo.152.1643038399809;
 Mon, 24 Jan 2022 07:33:19 -0800 (PST)
Date:   Mon, 24 Jan 2022 07:33:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002c4f0905d655b052@google.com>
Subject: [syzbot] WARNING in free_loaded_vmcs (3)
From:   syzbot <syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com>
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

HEAD commit:    dd81e1c7d5fb Merge tag 'powerpc-5.17-2' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a31ae0700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=916d34c0d501b86
dashboard link: https://syzkaller.appspot.com/bug?extid=8112db3ab20e70d50c31
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16c7b51fb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1212815bb00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1736d857b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14b6d857b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10b6d857b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3606 at arch/x86/kvm/vmx/vmx.c:2665 free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
WARNING: CPU: 0 PID: 3606 at arch/x86/kvm/vmx/vmx.c:2665 free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
Modules linked in:
CPU: 1 PID: 3606 Comm: syz-executor725 Not tainted 5.17.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
RIP: 0010:free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
Code: 81 e8 bc 8c 4c 00 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 75 49 48 8b 2b e9 25 ff ff ff e8 38 17 58 00 <0f> 0b eb b3 e8 8f 4d 9f 00 e9 f7 fe ff ff 48 89 df e8 92 4d 9f 00
RSP: 0018:ffffc90001d2f890 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888079c1a2e8 RCX: 0000000000000000
RDX: ffff888021b65700 RSI: ffffffff81204388 RDI: ffff888079c1a2f0
RBP: ffff88807594d000 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817ea048 R11: 0000000000000001 R12: 0000000000000000
R13: ffff888079c18000 R14: 0000000000000003 R15: ffffc90001d2f918
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc975b8a328 CR3: 000000007f686000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_arch_vcpu_destroy+0x72/0x2f0 arch/x86/kvm/x86.c:11123
 kvm_vcpu_destroy arch/x86/kvm/../../../virt/kvm/kvm_main.c:441 [inline]
 kvm_destroy_vcpus+0x11f/0x290 arch/x86/kvm/../../../virt/kvm/kvm_main.c:460
 kvm_free_vcpus arch/x86/kvm/x86.c:11564 [inline]
 kvm_arch_destroy_vm+0x2e8/0x470 arch/x86/kvm/x86.c:11676
 kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1217 [inline]
 kvm_put_kvm+0x4fa/0xb00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1250
 kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1273
 __fput+0x286/0x9f0 fs/file_table.c:311
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xb29/0x2a30 kernel/exit.c:806
 do_group_exit+0xd2/0x2f0 kernel/exit.c:935
 get_signal+0x4b0/0x28c0 kernel/signal.c:2862
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc975b35729
Code: Unable to access opcode bytes at RIP 0x7fc975b356ff.
RSP: 002b:00007fc975ae5308 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fc975bbe408 RCX: 00007fc975b35729
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fc975bbe408
RBP: 00007fc975bbe400 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fc975bbe40c
R13: 00007fc975b8b0b8 R14: 6d766b2f7665642f R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
