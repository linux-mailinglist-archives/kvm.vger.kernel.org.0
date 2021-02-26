Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3B7326077
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 10:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhBZJtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 04:49:05 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:48885 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhBZJs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 04:48:59 -0500
Received: by mail-io1-f72.google.com with SMTP id c4so6708069ioq.15
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 01:48:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KcVZgP/9WVkxwlU+PRBupSfcDLAJUgmUyhz3DYtEh1Y=;
        b=F5iSgoW3Bfg1jIQyVu7xUG8momHxp1knlcPIEGv8KgjgOvZCm3xKKUx9oMEGk5IKVA
         wjLrWgKzTg9G6scvu3AGNWvtPbbg+6lBpaisdqw7QuQ5octDYr9rSA8eUrLFoRR19s0d
         xG9RqYIttny7ZEDe3b+smKOUDvSxiexFauNHSUSmTGx6QeDFdMV2aiiAT5sFwUI82OyS
         LqgOOUGKAW7ZK4/Q2O7C5OUfSq4uUVQwjXPiox92Jj776SkrtB+9HHyrx6G3uemoDoEh
         zFJNzIRR+ytwrimyHL0OQ4NZTR8h1NOrEgjsqkgwwjK+xNQHKlurYq8DHngTB6AaXQvk
         j2+Q==
X-Gm-Message-State: AOAM530BR1fOfmi0u5BCdv4+7uku+OciqccbLEHiunL5QcfCHRsamAa6
        aOgTzn6n1gzXvQZMImEDB7mtFIVxMmBy9GLQEXTrnl9F3Q9S
X-Google-Smtp-Source: ABdhPJwvgIyYjmC3Vw9wU7/ZzmPGYs58pcSwZNJKFq8ywF+Z2rzQIC2/zBK79ypmJ3BW1d61WYHn3HOoD5i4zK8gDnQVhFHvSVTb
MIME-Version: 1.0
X-Received: by 2002:a92:6403:: with SMTP id y3mr1715148ilb.90.1614332899174;
 Fri, 26 Feb 2021 01:48:19 -0800 (PST)
Date:   Fri, 26 Feb 2021 01:48:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000001316d05bc3a2bea@google.com>
Subject: general protection fault in synic_get
From:   syzbot <syzbot+0182764296ab74754c77@syzkaller.appspotmail.com>
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

HEAD commit:    a99163e9 Merge tag 'devicetree-for-5.12' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11564f12d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=49116074dd53b631
dashboard link: https://syzkaller.appspot.com/bug?extid=0182764296ab74754c77
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0182764296ab74754c77@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000028: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000140-0x0000000000000147]
CPU: 0 PID: 13202 Comm: syz-executor.2 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:synic_get+0x37f/0x450 arch/x86/kvm/hyperv.c:165
Code: 74 08 48 89 ef e8 e1 d7 a4 00 48 8b 6d 00 48 8d 5d 20 48 81 c5 40 01 00 00 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <8a> 04 08 84 c0 0f 85 8b 00 00 00 0f b6 6d 00 45 31 f6 31 ff 89 ee
RSP: 0018:ffffc90002937be0 EFLAGS: 00010206
RAX: 0000000000000028 RBX: 0000000000000020 RCX: dffffc0000000000
RDX: ffffc9000d3e8000 RSI: 000000000000122d RDI: 000000000000122e
RBP: 0000000000000140 R08: ffffffff81177c28 R09: fffff5200052133e
R10: fffff5200052133e R11: 0000000000000000 R12: ffff888013658028
R13: ffffc900029099e8 R14: 1ffff9200052133d R15: 0000000000000000
FS:  00007f9eefe5e700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000053e038 CR3: 0000000064691000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvm_hv_synic_set_irq+0x31/0x300 arch/x86/kvm/hyperv.c:452
 kvm_set_irq+0x159/0x260 arch/x86/kvm/../../../virt/kvm/irqchip.c:89
 kvm_vm_ioctl_irq_line+0x8d/0x130 arch/x86/kvm/x86.c:5230
 kvm_vm_ioctl+0x729/0x2c40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3918
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9eefe5e188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000056c008 RCX: 0000000000465ef9
RDX: 0000000020000000 RSI: 00000000c008ae67 RDI: 0000000000000004
RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c008
R13: 00007ffe57cd4f8f R14: 00007f9eefe5e300 R15: 0000000000022000
Modules linked in:
---[ end trace f15602d881a9aa88 ]---
RIP: 0010:synic_get+0x37f/0x450 arch/x86/kvm/hyperv.c:165
Code: 74 08 48 89 ef e8 e1 d7 a4 00 48 8b 6d 00 48 8d 5d 20 48 81 c5 40 01 00 00 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <8a> 04 08 84 c0 0f 85 8b 00 00 00 0f b6 6d 00 45 31 f6 31 ff 89 ee
RSP: 0018:ffffc90002937be0 EFLAGS: 00010206
RAX: 0000000000000028 RBX: 0000000000000020 RCX: dffffc0000000000
RDX: ffffc9000d3e8000 RSI: 000000000000122d RDI: 000000000000122e
RBP: 0000000000000140 R08: ffffffff81177c28 R09: fffff5200052133e
R10: fffff5200052133e R11: 0000000000000000 R12: ffff888013658028
R13: ffffc900029099e8 R14: 1ffff9200052133d R15: 0000000000000000
FS:  00007f9eefe5e700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a3cceb4a38 CR3: 0000000064691000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
