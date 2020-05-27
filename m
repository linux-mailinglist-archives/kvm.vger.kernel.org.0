Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7FE1E386D
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 07:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgE0FoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 01:44:19 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52375 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgE0FoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 01:44:18 -0400
Received: by mail-io1-f69.google.com with SMTP id p8so3658360ios.19
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 22:44:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Bgc0xyKMKmH4kXUgb0xUwmRShDBAHn+UVKmj3Ak5adw=;
        b=XbvW6YeaYuHQCh566sWVS5h3OTw3qAlpx6qFs7SkL66gtXaz2fDg2xXQZMk5F7yPoT
         7yNodbSHPVXykYMukOW2A5n2n1QiVpUcNNQ4xY5kkPaVILUvTUFjJjk+uUi310d9YZrl
         8+w9mayvvmIzr4vprSmcgb02OfNVXp/pc+khfSBC6F1yegOYtVtpAGsao1nYnhVfK5iq
         /lkucXMy0yvcq+ztgpLpjhny1n0TCr2y4g7TGBP7KVAEQvNjAX3tuK+WFeWskUT76SD/
         4j6Plo+hCpRqDChgTK3pVMNaRgh1ST/ZBr/XLTBDxODM59VTFFvj1UYPtYIrgiZZwSUM
         s7Hg==
X-Gm-Message-State: AOAM533e1goR5t0vFm7oSo6vu1S3VSFNytCj1nHy0ix5eeEDK/PwQwnq
        FiKmuBIuLvtZlqEcefi+sP0lyWBjyxTrtLckEcB2l5+0gN1g
X-Google-Smtp-Source: ABdhPJyRQx+VCNT1AAHzgYEbnMlG5JGfdWtKKqElQSKZh9lfzwSUvbiRMORMxEj6lF3a5ZG8K+H/7LBJXUeB2FptzhRwNy0iSn7m
MIME-Version: 1.0
X-Received: by 2002:a02:5448:: with SMTP id t69mr4261710jaa.37.1590558257060;
 Tue, 26 May 2020 22:44:17 -0700 (PDT)
Date:   Tue, 26 May 2020 22:44:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e8226505a69ab3c7@google.com>
Subject: general protection fault in start_creating
From:   syzbot <syzbot+705f4401d5a93a59b87d@syzkaller.appspotmail.com>
To:     eesposit@redhat.com, gregkh@linuxfoundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c11d28ab Add linux-next specific files for 20200522
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1135d53c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3f6dbdea4159fb66
dashboard link: https://syzkaller.appspot.com/bug?extid=705f4401d5a93a59b87d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110448d2100000

The bug was bisected to:

commit 63d04348371b7ea4a134bcf47c79763d969e9168
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue Mar 31 22:42:22 2020 +0000

    KVM: x86: move kvm_create_vcpu_debugfs after last failure point

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1366069a100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10e6069a100000
console output: https://syzkaller.appspot.com/x/log.txt?x=1766069a100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+705f4401d5a93a59b87d@syzkaller.appspotmail.com
Fixes: 63d04348371b ("KVM: x86: move kvm_create_vcpu_debugfs after last failure point")

general protection fault, probably for non-canonical address 0xdffffc000000002a: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000150-0x0000000000000157]
CPU: 0 PID: 8143 Comm: syz-executor.0 Not tainted 5.7.0-rc6-next-20200522-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0xe1b/0x48a0 kernel/locking/lockdep.c:4250
Code: b6 0a 41 be 01 00 00 00 0f 86 ce 0b 00 00 89 05 ab 87 b6 0a e9 c3 0b 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 d2 48 c1 ea 03 <80> 3c 02 00 0f 85 e5 2c 00 00 49 81 3a 40 75 e5 8b 0f 84 b0 f2 ff
RSP: 0018:ffffc900043cf7b8 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 000000000000002a RSI: 0000000000000000 RDI: 0000000000000150
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000150 R11: 0000000000000001 R12: 0000000000000000
R13: ffff8880966f8240 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f6300c10700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6300bcbdb8 CR3: 0000000092f4d000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4959
 down_write+0x8d/0x150 kernel/locking/rwsem.c:1531
 inode_lock include/linux/fs.h:801 [inline]
 start_creating+0xa8/0x250 fs/debugfs/inode.c:334
 __debugfs_create_file+0x62/0x400 fs/debugfs/inode.c:383
 kvm_arch_create_vcpu_debugfs+0x9f/0x200 arch/x86/kvm/debugfs.c:52
 kvm_create_vcpu_debugfs arch/x86/kvm/../../../virt/kvm/kvm_main.c:2998 [inline]
 kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:3075 [inline]
 kvm_vm_ioctl+0x1c28/0x2460 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3603
 vfs_ioctl fs/ioctl.c:48 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:753
 __do_sys_ioctl fs/ioctl.c:762 [inline]
 __se_sys_ioctl fs/ioctl.c:760 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:760
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca29
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6300c0fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004e73c0 RCX: 000000000045ca29
RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000005
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000396 R14: 00000000004c62c6 R15: 00007f6300c106d4
Modules linked in:
---[ end trace b2ea4e12631736e7 ]---
RIP: 0010:__lock_acquire+0xe1b/0x48a0 kernel/locking/lockdep.c:4250
Code: b6 0a 41 be 01 00 00 00 0f 86 ce 0b 00 00 89 05 ab 87 b6 0a e9 c3 0b 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 d2 48 c1 ea 03 <80> 3c 02 00 0f 85 e5 2c 00 00 49 81 3a 40 75 e5 8b 0f 84 b0 f2 ff
RSP: 0018:ffffc900043cf7b8 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 000000000000002a RSI: 0000000000000000 RDI: 0000000000000150
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000150 R11: 0000000000000001 R12: 0000000000000000
R13: ffff8880966f8240 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f6300c10700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6300bcbdb8 CR3: 0000000092f4d000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
