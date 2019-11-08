Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BC4F56F2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 21:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390686AbfKHTON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 14:14:13 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:56039 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390416AbfKHTOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 14:14:10 -0500
Received: by mail-io1-f69.google.com with SMTP id c67so6100676iof.22
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2019 11:14:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=m6WBr8JhldJsCHGo+l8MVKtDCmIYXLcSEAEq3QAgNQM=;
        b=WWaxg1lkj5bDXH/05L/x+oTHvGRz+CGuzGSdHjxaYGV3x2X+cTPDVEZ57WDo4VCr/2
         ot16KGBw8pxilMNnK/z20C8q2HiojQxVlgueWoBDGWOaMPIUHZAd+MoWjTXWN28TJCy3
         MO0JS2pmWCtubQieHnKbiawkKSfEVyzE86Ebwks0JZq1jGfuru7eFsyp4e+Yb4GO+uBa
         /on+CGVxHFqrnShbWqEz1z9sw7h91SJeK+DfR3cxORR+V5jT1ey/2Q+WxpYU+I7f0lE7
         OTFY8lQfYTmwizGokrf/LWTT3o91OD/XnC7BvglVjFZm3Ta/g3zwRoUyHLvOtrl+KY0Z
         tsZQ==
X-Gm-Message-State: APjAAAW67Gq/BD2odr4tlMkRBPJ/X3FcwmlFupmJYrD1gPgZ8pxN9I3U
        M5AogZOsalFRIAjlVkba1OJHLxjQ47YcJbPtXGHPYJB3bVON
X-Google-Smtp-Source: APXvYqzxESX9ewsNLy+icmQIbXyev1khcj7aj6dMItQPL8fJwi+pRBvozfPDfP8OAHURCedOOa9RY/LUPnbXMBy/L8hH+RuegjFJ
MIME-Version: 1.0
X-Received: by 2002:a92:5fd3:: with SMTP id i80mr3594383ill.275.1573240448805;
 Fri, 08 Nov 2019 11:14:08 -0800 (PST)
Date:   Fri, 08 Nov 2019 11:14:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000018f5440596da964b@google.com>
Subject: kernel BUG at arch/x86/kvm/mmu.c:LINE! (2)
From:   syzbot <syzbot+824609cfabee9c6e153c@syzkaller.appspotmail.com>
To:     abbotti@mev.co.uk, bp@alien8.de, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, hpa@zytor.com,
        hsweeten@visionengravers.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, olsonse@umich.edu, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    847120f8 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12d60164e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5e2eca3f31f9bf
dashboard link: https://syzkaller.appspot.com/bug?extid=824609cfabee9c6e153c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e2a12ce00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13314994e00000

The bug was bisected to:

commit 1ffe8bdc09f8bfcaad76d71ae68b623c7e03f20f
Author: Spencer E. Olson <olsonse@umich.edu>
Date:   Mon Oct 10 14:14:19 2016 +0000

     staging: comedi: ni_mio_common: split out ao arming from ni_ao_inttrig

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122977fae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=162977fae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+824609cfabee9c6e153c@syzkaller.appspotmail.com
Fixes: 1ffe8bdc09f8 ("staging: comedi: ni_mio_common: split out ao arming  
from ni_ao_inttrig")

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and  
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for  
details.
------------[ cut here ]------------
kernel BUG at arch/x86/kvm/mmu.c:3324!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8688 Comm: syz-executor906 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:transparent_hugepage_adjust+0x490/0x530 arch/x86/kvm/mmu.c:3324
Code: 63 00 48 8b 45 b8 48 83 e8 01 e9 19 fd ff ff e8 36 3c 63 00 48 8b 45  
b8 48 83 e8 01 48 89 45 c8 e9 a1 fd ff ff e8 20 3c 63 00 <0f> 0b 48 89 df  
e8 66 9e 9e 00 e9 9f fb ff ff 4c 89 ff e8 59 9e 9e
RSP: 0018:ffff88809753f690 EFLAGS: 00010293
RAX: ffff88809549e6c0 RBX: ffff88809753f778 RCX: ffffffff810fe787
RDX: 0000000000000000 RSI: ffffffff810fe8c0 RDI: 0000000000000007
RBP: ffff88809753f6d8 R08: ffff88809549e6c0 R09: ffffed10131ed682
R10: ffffed10131ed681 R11: ffff888098f6b40b R12: ffff88809753f768
R13: 0000000000000083 R14: 000000000008fe81 R15: 0000000000000000
FS:  000000000158e880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000009f2a4000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  tdp_page_fault+0x56e/0x650 arch/x86/kvm/mmu.c:4216
  kvm_mmu_page_fault+0x1dd/0x1800 arch/x86/kvm/mmu.c:5439
  handle_ept_violation+0x259/0x560 arch/x86/kvm/vmx/vmx.c:5185
  vmx_handle_exit+0x29f/0x1730 arch/x86/kvm/vmx/vmx.c:5929
  vcpu_enter_guest arch/x86/kvm/x86.c:8227 [inline]
  vcpu_run arch/x86/kvm/x86.c:8291 [inline]
  kvm_arch_vcpu_ioctl_run+0x1cb8/0x70d0 arch/x86/kvm/x86.c:8498
  kvm_vcpu_ioctl+0x4dc/0xfc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2772
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x443f49
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b d8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd991d67d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002e0 RCX: 0000000000443f49
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
RBP: 00000000006ce018 R08: 00000000004002e0 R09: 00000000004002e0
R10: 00000000004002e0 R11: 0000000000000246 R12: 0000000000401c50
R13: 0000000000401ce0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 911095bae56804bc ]---
RIP: 0010:transparent_hugepage_adjust+0x490/0x530 arch/x86/kvm/mmu.c:3324
Code: 63 00 48 8b 45 b8 48 83 e8 01 e9 19 fd ff ff e8 36 3c 63 00 48 8b 45  
b8 48 83 e8 01 48 89 45 c8 e9 a1 fd ff ff e8 20 3c 63 00 <0f> 0b 48 89 df  
e8 66 9e 9e 00 e9 9f fb ff ff 4c 89 ff e8 59 9e 9e
RSP: 0018:ffff88809753f690 EFLAGS: 00010293
RAX: ffff88809549e6c0 RBX: ffff88809753f778 RCX: ffffffff810fe787
RDX: 0000000000000000 RSI: ffffffff810fe8c0 RDI: 0000000000000007
RBP: ffff88809753f6d8 R08: ffff88809549e6c0 R09: ffffed10131ed682
R10: ffffed10131ed681 R11: ffff888098f6b40b R12: ffff88809753f768
R13: 0000000000000083 R14: 000000000008fe81 R15: 0000000000000000
FS:  000000000158e880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000009f2a4000 CR4: 00000000001426f0
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
