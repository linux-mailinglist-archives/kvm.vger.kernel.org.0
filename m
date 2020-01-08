Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA543134C44
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgAHUDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:03:10 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:37146 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgAHUDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:03:10 -0500
Received: by mail-io1-f71.google.com with SMTP id t70so2801828iof.4
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 12:03:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QQ9jOivQ5dWlzW4Uw5qGquEM4NzrI4svewZeUOhhorU=;
        b=GZTqUpuhl56W9x6IGYgSR6Jxes8CmL1g7zo5T+D/b1LLS2qTDpRACd+8Bijbqap1sP
         M0QJMxyGNe4kW2i+EL2O6Bzyj8v34+WimchJJVWfVDT9T5FCOA/7mFh/uXhVBMTgiQE/
         H+iK+E1ADdkGNtLLB9xOSvcYM5KyBad4QK8wQ+VsRfypY2/yt2PVI0+9Y81aZbbfyoa9
         AIu5HIcK0sG+Tb53w+7FDK3Mhr0DKuj59JFYDcWA+88IcE/RCnahXXpisnZ+TN81liWO
         FlyLm8swauB7rGXux4+MWiSdgY/cPcOIG0vNXzPVast5wQDH2PijeFc1YnnT1+m/t48t
         OpMQ==
X-Gm-Message-State: APjAAAXnwwsUl+D+O61n/XxuraSWx8+l5sGMx9di1OzVDtm2PIHFZe43
        xfibKDlDyYMWlj2MtaJW8SJzC9qcl4nCnfIS4gcvKz+y4KHU
X-Google-Smtp-Source: APXvYqz0BI05gYGVmIHHEvl+gsQDHnvqHHzmwZlsd320DiZ+LMJUChh+kqDODJf2mW1P003T7f2zAqVujnPBE/0HiLWSqTd4jZ3W
MIME-Version: 1.0
X-Received: by 2002:a6b:731a:: with SMTP id e26mr4600874ioh.254.1578513789740;
 Wed, 08 Jan 2020 12:03:09 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:03:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b5eb9e059ba66172@google.com>
Subject: WARNING in cleanup_srcu_struct
From:   syzbot <syzbot+1b1043fa771618e68377@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
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

HEAD commit:    3a562aee Merge tag 'for-5.5-rc4-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13672869e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=1b1043fa771618e68377
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1b1043fa771618e68377@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 18326 at kernel/rcu/srcutree.c:376  
cleanup_srcu_struct+0x248/0x2d0 kernel/rcu/srcutree.c:395
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 18326 Comm: syz-executor.1 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:cleanup_srcu_struct+0x248/0x2d0 kernel/rcu/srcutree.c:376
Code: 84 24 48 04 00 00 00 00 00 00 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f  
5d c3 0f 0b 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e9 3c ff  
ff ff 48 8b 7d c0 e8 48 4c 51 00 e9 bd fe ff ff 48
RSP: 0018:ffffc900019a7b60 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000004 RCX: ffffc90004ed9000
RDX: 000000000000b393 RSI: ffffffff839b22b7 RDI: 0000000000000006
RBP: ffffc900019a7bb0 R08: ffff8880a6bdc580 R09: 0000000000000040
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90001ee9c48
R13: 0000000000000000 R14: ffffc90001ee19f0 R15: dffffc0000000000
  kvm_page_track_cleanup+0x19/0x20 arch/x86/kvm/mmu/page_track.c:167
  kvm_arch_destroy_vm+0x4aa/0x5f0 arch/x86/kvm/x86.c:9667
  kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:758 [inline]
  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3519  
[inline]
  kvm_dev_ioctl+0x11af/0x17d0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3571
  vfs_ioctl fs/ioctl.c:47 [inline]
  file_ioctl fs/ioctl.c:545 [inline]
  do_vfs_ioctl+0x977/0x14e0 fs/ioctl.c:732
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:749
  __do_sys_ioctl fs/ioctl.c:756 [inline]
  __se_sys_ioctl fs/ioctl.c:754 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe9be746c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe9be7476d4
R13: 00000000004c44c7 R14: 00000000004da970 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
