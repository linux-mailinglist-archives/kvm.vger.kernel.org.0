Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A7C459734
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 23:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239975AbhKVWRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 17:17:40 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:53153 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239945AbhKVWRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 17:17:39 -0500
Received: by mail-io1-f71.google.com with SMTP id k12-20020a0566022a4c00b005ebe737d989so12699899iov.19
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:14:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Kz/44B8X7NBFkqbuicYsbZq4Sql/M2zFV0XxqztyEos=;
        b=eTV7KN3eurtR0L+Ass7o8J+TlYgw5V9Akc5ga02X8g2QtauQNae2/mWUpfJY5steC9
         RrIcbif0jyker5EOPJ7Jc0qFbivV/7YL3lPQfRz3ebbwuEIV4Me4jziHYSyKq07M5xm6
         N2mnNUyI1lTTxII9n2xBj1CZ+B3pA0uwQzQ9B4Cyq3DdG9h768xAQhkdkLj/2Wz1DXDi
         AUDxqXTb7bEvzbOklbtbkV59fVG/OaJBFj3ewS/kOroCLQysoeSWpbq/PuzVwshuGkuh
         UiVSfi34fXcFYrzDk9SkUmyBY/sSgfB+uKhf0KEBk+Q1Bhw066WHwDounocp3pwY1v+c
         f7jg==
X-Gm-Message-State: AOAM531ZwaPxKe4Daf9TKWcgGaUO9RzRd2R4l4Dav3GDEArmdaJJBWuv
        ZxE/yu2Y9hr0x2m+4ZMvxjTJWAfYJJzHiB3Usfh305Ptxo7T
X-Google-Smtp-Source: ABdhPJwtWfap1cILHXA8iY6bhxmVBc5DuHMjm1DNzMmWeuU1dmiVBqd5gR4zDlKDr42C/cujKKfJcxy+RDqnjoVt+wBxmFTK/rtM
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3a4:: with SMTP id z4mr521453jap.76.1637619271749;
 Mon, 22 Nov 2021 14:14:31 -0800 (PST)
Date:   Mon, 22 Nov 2021 14:14:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f854ec05d167f227@google.com>
Subject: [syzbot] kernel BUG in kvm_read_guest_offset_cached
From:   syzbot <syzbot+7b7db8bb4db6fd5e157b@syzkaller.appspotmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4c388a8e740d Merge tag 'zstd-for-linus-5.16-rc1' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=171ff6eeb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
dashboard link: https://syzkaller.appspot.com/bug?extid=7b7db8bb4db6fd5e157b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b7db8bb4db6fd5e157b@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:2955!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 27639 Comm: syz-executor.0 Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvm_read_guest_offset_cached+0x3aa/0x440 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2955
Code: 00 48 c7 c2 c0 08 a2 89 be 0b 03 00 00 48 c7 c7 60 0d a2 89 c6 05 71 f9 73 0c 01 e8 62 19 f8 07 e9 d6 fc ff ff e8 36 1b 6f 00 <0f> 0b e8 2f 1b 6f 00 48 8b 74 24 10 4c 89 ef 4c 89 e1 48 8b 54 24
RSP: 0018:ffffc9000589fa18 EFLAGS: 00010216
RAX: 0000000000003b75 RBX: ffff8880722ba798 RCX: ffffc90002b94000
RDX: 0000000000040000 RSI: ffffffff81087cda RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000004 R09: ffffc900049dbf53
R10: ffffffff81087a0f R11: 0000000000000002 R12: 0000000000000004
R13: ffffc900049d1000 R14: 0000000000000000 R15: ffff8880886c0000
FS:  00007fd7a562f700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000200 CR3: 0000000038e62000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000c0fe
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 handle_vmptrld arch/x86/kvm/vmx/nested.c:5304 [inline]
 handle_vmptrld+0x39d/0x820 arch/x86/kvm/vmx/nested.c:5266
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6012 [inline]
 vmx_handle_exit+0x4f7/0x18a0 arch/x86/kvm/vmx/vmx.c:6029
 vcpu_enter_guest+0x2b41/0x4440 arch/x86/kvm/x86.c:9941
 vcpu_run arch/x86/kvm/x86.c:10008 [inline]
 kvm_arch_vcpu_ioctl_run+0x4fc/0x21a0 arch/x86/kvm/x86.c:10203
 kvm_vcpu_ioctl+0x570/0xf30 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3709
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd7a80b9ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd7a562f188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fd7a81ccf60 RCX: 00007fd7a80b9ae9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
RBP: 00007fd7a8113f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd7a8700b2f R14: 00007fd7a562f300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 05ad48ac8b464d71 ]---
RIP: 0010:kvm_read_guest_offset_cached+0x3aa/0x440 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2955
Code: 00 48 c7 c2 c0 08 a2 89 be 0b 03 00 00 48 c7 c7 60 0d a2 89 c6 05 71 f9 73 0c 01 e8 62 19 f8 07 e9 d6 fc ff ff e8 36 1b 6f 00 <0f> 0b e8 2f 1b 6f 00 48 8b 74 24 10 4c 89 ef 4c 89 e1 48 8b 54 24
RSP: 0018:ffffc9000589fa18 EFLAGS: 00010216
RAX: 0000000000003b75 RBX: ffff8880722ba798 RCX: ffffc90002b94000
RDX: 0000000000040000 RSI: ffffffff81087cda RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000004 R09: ffffc900049dbf53
R10: ffffffff81087a0f R11: 0000000000000002 R12: 0000000000000004
R13: ffffc900049d1000 R14: 0000000000000000 R15: ffff8880886c0000
FS:  00007fd7a562f700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f18994c5000 CR3: 0000000038e62000 CR4: 00000000003526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000003000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
