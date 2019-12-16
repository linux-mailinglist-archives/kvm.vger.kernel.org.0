Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7F812099D
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfLPPZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:25:12 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:56303 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbfLPPZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 10:25:12 -0500
Received: by mail-il1-f198.google.com with SMTP id p8so5085721ilp.22
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:25:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=t7KLeeGHAQU+IfhPXlUYZnaYXa0avOmf8P/RRgGivPY=;
        b=jSFpcEnRMNLJdCzBk67vKB/dUYwYUjk2sSvZeLX3vr1ArRwO2kIAQ3QToVATn8l6Ny
         GrnAvS3XSzYgYjICGWkYrsOEaba80cxqLnhh6zWVG26FaS7/yselAssb/aswAgrAdN8f
         G9sTHy62tfMIJxvyzXacK2+hL+lL6g5izDzxjxe/pfuIRVz7k8PGoiXPFe2AzBlhLHXd
         vmgjlaX88pIQSpru60RyrsxNvgNLlB2IddeLdUPCJR63tqj2zROa4xF5+JuSCBCy4iZF
         ClGSFFrCJMCaR2NLkmKV7wI8tJh5nZ4pcC7Gyt07kAbc36OYUpbPFSXLh2fYTowqWu0B
         280Q==
X-Gm-Message-State: APjAAAWdcZ7ER2aJsettWw5nx3Ymd2gb6lJ2n2und6c3i77v2W9I3B3Y
        5LD2OM868enilx9v7OwxlfxuCN6gXrU4zwnq4JXir6ZR+B7a
X-Google-Smtp-Source: APXvYqxIG5w0KqPgovhJhP5e7TaZ7DIVJV+bqbUePz2yqOaSRDfukAuXlxhWqIajh2m81bDfCxk7jVklYLCx7AZl/LWfB7RYdGOO
MIME-Version: 1.0
X-Received: by 2002:a92:901:: with SMTP id y1mr11977034ilg.274.1576509911135;
 Mon, 16 Dec 2019 07:25:11 -0800 (PST)
Date:   Mon, 16 Dec 2019 07:25:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003cffc30599d3d1a0@google.com>
Subject: kernel BUG at arch/x86/kvm/mmu/mmu.c:LINE!
From:   syzbot <syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ae4b064e Merge tag 'afs-fixes-20191211' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=149c0cfae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
dashboard link: https://syzkaller.appspot.com/bug?extid=c9d1fb51ac9d0d10c39d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a97b7ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15128396e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at arch/x86/kvm/mmu/mmu.c:3416!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9988 Comm: syz-executor218 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:transparent_hugepage_adjust+0x4c8/0x550  
arch/x86/kvm/mmu/mmu.c:3416
Code: ff ff e8 eb 5d 5e 00 48 8b 45 b8 48 83 e8 01 48 89 45 c8 e9 a3 fd ff  
ff 48 89 df e8 c2 f8 9b 00 e9 7b fb ff ff e8 c8 5d 5e 00 <0f> 0b 48 8b 7d  
c8 e8 ad f8 9b 00 e9 ba fc ff ff 49 8d 7f 30 e8 7f
RSP: 0018:ffffc90001f27678 EFLAGS: 00010293
RAX: ffff8880a875a200 RBX: ffffc90001f27768 RCX: ffffffff8116cc87
RDX: 0000000000000000 RSI: ffffffff8116cdc8 RDI: 0000000000000007
RBP: ffffc90001f276c0 R08: ffff8880a875a200 R09: ffffed1010d79682
R10: ffffed1010d79681 R11: ffff888086bcb40b R12: 00000000000001d3
R13: 0000000000094dd3 R14: 0000000000094dd1 R15: 0000000000000000
FS:  0000000000fff880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000009af1b000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  tdp_page_fault+0x580/0x6a0 arch/x86/kvm/mmu/mmu.c:4315
  kvm_mmu_page_fault+0x1dd/0x1800 arch/x86/kvm/mmu/mmu.c:5539
  handle_ept_violation+0x259/0x560 arch/x86/kvm/vmx/vmx.c:5163
  vmx_handle_exit+0x29f/0x1730 arch/x86/kvm/vmx/vmx.c:5921
  vcpu_enter_guest+0x334f/0x6110 arch/x86/kvm/x86.c:8290
  vcpu_run arch/x86/kvm/x86.c:8354 [inline]
  kvm_arch_vcpu_ioctl_run+0x430/0x17b0 arch/x86/kvm/x86.c:8561
  kvm_vcpu_ioctl+0x4dc/0xfc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2847
  vfs_ioctl fs/ioctl.c:47 [inline]
  file_ioctl fs/ioctl.c:545 [inline]
  do_vfs_ioctl+0x977/0x14e0 fs/ioctl.c:732
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:749
  __do_sys_ioctl fs/ioctl.c:756 [inline]
  __se_sys_ioctl fs/ioctl.c:754 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440359
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc16334278 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440359
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401be0
R13: 0000000000401c70 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace e1a5b9c09fef2e33 ]---
RIP: 0010:transparent_hugepage_adjust+0x4c8/0x550  
arch/x86/kvm/mmu/mmu.c:3416
Code: ff ff e8 eb 5d 5e 00 48 8b 45 b8 48 83 e8 01 48 89 45 c8 e9 a3 fd ff  
ff 48 89 df e8 c2 f8 9b 00 e9 7b fb ff ff e8 c8 5d 5e 00 <0f> 0b 48 8b 7d  
c8 e8 ad f8 9b 00 e9 ba fc ff ff 49 8d 7f 30 e8 7f
RSP: 0018:ffffc90001f27678 EFLAGS: 00010293
RAX: ffff8880a875a200 RBX: ffffc90001f27768 RCX: ffffffff8116cc87
RDX: 0000000000000000 RSI: ffffffff8116cdc8 RDI: 0000000000000007
RBP: ffffc90001f276c0 R08: ffff8880a875a200 R09: ffffed1010d79682
R10: ffffed1010d79681 R11: ffff888086bcb40b R12: 00000000000001d3
R13: 0000000000094dd3 R14: 0000000000094dd1 R15: 0000000000000000
FS:  0000000000fff880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000009af1b000 CR4: 00000000001426f0
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
