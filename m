Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D65F38D325
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 04:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhEVCxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 22:53:48 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48907 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhEVCxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 22:53:47 -0400
Received: by mail-il1-f197.google.com with SMTP id z11-20020a92d6cb0000b02901bb992c83cbso16460446ilp.15
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 19:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Jue70gMD2bnrTWLoEZmyt/cAfGpA7FRemzX39phiOi0=;
        b=ZNJbe/szhJoLG83Iybj+gkd70WTU1r9cO1BpWBxHEI8dWQPP00GesA+mS5KQsnH8An
         dRyhw2ES/jt1WmPo0FJDE4KRiIKEAAvuA7fKEcVFhA32ba7tW8p41Bjpq9P8hcul2SRD
         1g/wrXXgwGX1rbaF55IdWYWRcNL2MDoyBhl1S8r0qql8ySfUx7WaHIhNreG5F2OZEcRX
         mb9zzFcmwNLQBks/aa4tXCKEeGN9lUU8bf3WYciK0whc6ZQXL2ob6kSG1tT6deKbDAAy
         xTljD3O+mE+yzA1nZseeETBuxbBXN6ZYfieQlBZTAdCMdL/MbIr25I0rgZSdK7bv/yI0
         ac4A==
X-Gm-Message-State: AOAM533LDjafrLyKJeflUZJa/dWbDb+tkVkpcP0caL11XgcywOFIPAfO
        ebTkSfkD11h5jaUSCCwhsitjktpZvzbxGacbXVWk8CUsqj7f
X-Google-Smtp-Source: ABdhPJxXd6oKyJwV7S5eO4/SQ1t0AMNCPK5ACa6aOpobA7MmBIMnkQlC9EE9J40eZg6IUMH5y2mWX2zk3AMpjdFrrNbN2GulgmrS
MIME-Version: 1.0
X-Received: by 2002:a6b:d20e:: with SMTP id q14mr2483179iob.200.1621651942011;
 Fri, 21 May 2021 19:52:22 -0700 (PDT)
Date:   Fri, 21 May 2021 19:52:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3fc9305c2e24311@google.com>
Subject: [syzbot] WARNING in x86_emulate_instruction
From:   syzbot <syzbot+71271244f206d17f6441@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, peterz@infradead.org,
        seanjc@google.com, steve.wahl@hpe.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8ac91e6c Merge tag 'for-5.13-rc2-tag' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16a80fc7d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dddb87edd6431081
dashboard link: https://syzkaller.appspot.com/bug?extid=71271244f206d17f6441
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d1f89bd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000

The issue was bisected to:

commit 9a7832ce3d920426a36cdd78eda4b3568d4d09e3
Author: Steve Wahl <steve.wahl@hpe.com>
Date:   Fri Jan 8 15:35:49 2021 +0000

    perf/x86/intel/uncore: With > 8 nodes, get pci bus die id from NUMA info

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152bf9b3d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=172bf9b3d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=132bf9b3d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
Fixes: 9a7832ce3d92 ("perf/x86/intel/uncore: With > 8 nodes, get pci bus die id from NUMA info")

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8431 at arch/x86/kvm/x86.c:7620 x86_emulate_instruction+0x9e8/0x1460 arch/x86/kvm/x86.c:7620
Modules linked in:
CPU: 0 PID: 8431 Comm: syz-executor681 Not tainted 5.13.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:x86_emulate_instruction+0x9e8/0x1460 arch/x86/kvm/x86.c:7620
Code: c0 74 07 7f 05 e8 a8 48 a9 00 41 0f b6 5c 24 30 bf 06 00 00 00 89 de e8 56 4d 64 00 80 fb 06 0f 85 06 05 00 00 e8 98 46 64 00 <0f> 0b e8 91 46 64 00 48 89 ef e8 89 48 fe ff c7 44 24 1c 01 00 00
RSP: 0018:ffffc90002057930 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000000000
RDX: ffff88802caad4c0 RSI: ffffffff81108cc8 RDI: 0000000000000003
RBP: ffff88802eb08000 R08: 0000000000000000 R09: 0000000000000006
R10: ffffffff81108cba R11: 0000000000000006 R12: ffff88802bd48000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000040
FS:  00000000012e3300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000001459c000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvm_mmu_page_fault+0x2eb/0x1890 arch/x86/kvm/mmu/mmu.c:5103
 handle_ept_violation+0x29c/0x6f0 arch/x86/kvm/vmx/vmx.c:5402
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6106 [inline]
 vmx_handle_exit+0x336/0x1800 arch/x86/kvm/vmx/vmx.c:6123
 vcpu_enter_guest+0x235e/0x47e0 arch/x86/kvm/x86.c:9425
 vcpu_run arch/x86/kvm/x86.c:9491 [inline]
 kvm_arch_vcpu_ioctl_run+0x47d/0x1990 arch/x86/kvm/x86.c:9719
 kvm_vcpu_ioctl+0x467/0xd10 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3458
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x440da9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe2af5d538 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 0000000000440da9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00000000004048a0 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000404930
R13: 0000000000000000 R14: 00000000004ae018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
