Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B70311456
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 23:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhBEWEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 17:04:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:50344 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbhBEOyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:33 -0500
Received: by mail-io1-f70.google.com with SMTP id w15so6691898ioa.17
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 08:33:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QLMdobwI21unXJ8AaGTczEYpBIwx778vxux7MxwfKw0=;
        b=MKb6Nrt0bRny8i38LJYPxDyIeZ8By8AnGXLuX18kuzvuBqUYDx174UfLDwZusrXakR
         rtUvsIV6/mYA6XyJ+xXfVwO7VSED2czgib93yI1L70hSIQgY9mNubLqHjAFDkgdSV5M1
         BC22CgvbPOZ0WzTi0Ld7EnNpvYYD3MmS05txD8PWViayo9vQZOPbcjHBrfR7ft5IwPLa
         qaM15DoDcUPilp0xYxpQt+RwSdcVp3piI4kSjz/TIieayDVgZK0xN6Yl+DCMtUUA8KDg
         R99BsVOdHh4fVD3HDedEXRGWN3ZnUGTnnICC2wi6yLZNRA7U5hfKgUb2H4AgkiaqhShO
         eOQA==
X-Gm-Message-State: AOAM530egcIiHZ9cIG2rdwyooyIaJqrqhOLZGBQR2OL4YCrl0h4h8t/8
        rF8+E+MdBrpRIZrWJqs9s+V5od6eqWH9OGaA5Q9wiCz0G1KJ
X-Google-Smtp-Source: ABdhPJyTtj4JqxehYsbh8pCYlMZ6/g0siakHPFrYyRm/sexT0ghMwTNzvGcpEC0Nkz3MBf7DcpcR+YRs+wRZI/JNemcN6W8vEBul
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d88:: with SMTP id h8mr3911422ila.43.1612538416459;
 Fri, 05 Feb 2021 07:20:16 -0800 (PST)
Date:   Fri, 05 Feb 2021 07:20:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007ff56205ba985b60@google.com>
Subject: general protection fault in vmx_vcpu_run (2)
From:   syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>
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

HEAD commit:    aa2b8820 Add linux-next specific files for 20210205
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d27b54d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=15c41e44a64aa1a5
dashboard link: https://syzkaller.appspot.com/bug?extid=42a71c84ef04577f1aef

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000001e26: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x000000000000f130-0x000000000000f137]
CPU: 0 PID: 18290 Comm: syz-executor.0 Not tainted 5.11.0-rc6-next-20210205-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:atomic_switch_perf_msrs arch/x86/kvm/vmx/vmx.c:6527 [inline]
RIP: 0010:vmx_vcpu_run+0x538/0x2740 arch/x86/kvm/vmx/vmx.c:6698
Code: 8a 55 00 39 eb 0f 8d fd 00 00 00 e8 42 85 55 00 48 8b 0c 24 48 63 c3 48 8d 04 40 48 8d 2c c1 48 8d 7d 08 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 0f 85 05 1d 00 00 48 8d 7d 10 4c 8b 6d 08 48 89 f8
RSP: 0018:ffffc9000238fb00 EFLAGS: 00010003
RAX: 0000000000001e26 RBX: 0000000000000000 RCX: 000000000000f12e
RDX: 0000000000040000 RSI: ffffffff811d679e RDI: 000000000000f136
RBP: 000000000000f12e R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff811d675e R11: 0000000000000000 R12: ffff88806d8ba4d0
R13: ffff88806d8ba520 R14: ffff88806d8b8000 R15: dffffc0000000000
FS:  00007f1a30eaf700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1a30ece6b8 CR3: 000000001c387000 CR4: 00000000001526f0
Call Trace:
 vcpu_enter_guest+0x103d/0x3f90 arch/x86/kvm/x86.c:9015
 vcpu_run arch/x86/kvm/x86.c:9155 [inline]
 kvm_arch_vcpu_ioctl_run+0x440/0x1980 arch/x86/kvm/x86.c:9382
 kvm_vcpu_ioctl+0x467/0xd90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3283
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x465b09
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1a30eaf188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000056c008 RCX: 0000000000465b09
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
RBP: 00000000004b069f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c008
R13: 00007ffde3d7a22f R14: 00007f1a30eaf300 R15: 0000000000022000
Modules linked in:
---[ end trace 7085899e9678fd16 ]---
RIP: 0010:atomic_switch_perf_msrs arch/x86/kvm/vmx/vmx.c:6527 [inline]
RIP: 0010:vmx_vcpu_run+0x538/0x2740 arch/x86/kvm/vmx/vmx.c:6698
Code: 8a 55 00 39 eb 0f 8d fd 00 00 00 e8 42 85 55 00 48 8b 0c 24 48 63 c3 48 8d 04 40 48 8d 2c c1 48 8d 7d 08 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 0f 85 05 1d 00 00 48 8d 7d 10 4c 8b 6d 08 48 89 f8
RSP: 0018:ffffc9000238fb00 EFLAGS: 00010003
RAX: 0000000000001e26 RBX: 0000000000000000 RCX: 000000000000f12e
RDX: 0000000000040000 RSI: ffffffff811d679e RDI: 000000000000f136
RBP: 000000000000f12e R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff811d675e R11: 0000000000000000 R12: ffff88806d8ba4d0
R13: ffff88806d8ba520 R14: ffff88806d8b8000 R15: dffffc0000000000
FS:  00007f1a30eaf700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1a30ece6b8 CR3: 000000001c387000 CR4: 00000000001526f0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
