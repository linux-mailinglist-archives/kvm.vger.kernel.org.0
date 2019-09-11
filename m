Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F68B04EB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 22:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbfIKUiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 16:38:16 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:43613 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730545AbfIKUiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 16:38:09 -0400
Received: by mail-io1-f70.google.com with SMTP id o6so15833752ioh.10
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 13:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VsEdw4++kuhDtMIyfNnnj+A7FXU5CBR0IFHybn40Fa4=;
        b=XEOoTUXkMnr8eGzspnewMlAc1d1M+q3j5lULjAcyrmVG/GTLhVZY51OuAMxAIn2jZ2
         igaTDdLrTYNzelXf/TQ9zwSIApTrxH/PqI7l1PbxxTHSne4kTyyUICpTuOCnOHMHhI7a
         rOuid9O3XfYQQWi1CMAp6EM8rZQZhrt5e1vduh1TPTNYWzmVNd7E+FapEs4VB6xlDPmi
         9qS9cDfF7nfFOyfYu0y4qQC5sFzMWS+sE7iJRrnYfBw17wjKkfRgUJBbBVK/534lHQc1
         0CYp0eta96OZvmYfysttmUfJ0Gh9wifTL9bOlmIHOcZN6bu6vmrubbGHp8NX1/VJzalv
         Q/Gg==
X-Gm-Message-State: APjAAAWoW8yYVgdvDSbtpJOlSbNKMuDMwX85Ntts4iv1YZ3zZuLpehTz
        KX9Ekl06BzJdU637D1RkGt2kmpgFbilo6D1qUHQTf3zEIwar
X-Google-Smtp-Source: APXvYqz8cuqUHeU2JqvW9uFdqvxkEfjh+magQ1vm3IKYa5g/2R50J1tvTC7vDmLso9GqP4dNnwD/HL7zdr3BNrFBRh3TnZ8Se+Fw
MIME-Version: 1.0
X-Received: by 2002:a6b:148b:: with SMTP id 133mr11055009iou.81.1568234288384;
 Wed, 11 Sep 2019 13:38:08 -0700 (PDT)
Date:   Wed, 11 Sep 2019 13:38:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af123405924cff2c@google.com>
Subject: WARNING in handle_desc
From:   syzbot <syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpeng.li@hotmail.com,
        wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6d028043 Add linux-next specific files for 20190830
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14467cf6600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82a6bec43ab0cb69
dashboard link: https://syzkaller.appspot.com/bug?extid=0f1819555fbdce992df9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12475285600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138efb99600000

The bug was bisected to:

commit 0367f205a3b7c0efe774634eef1f4697c79a4132
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue Jul 12 08:44:55 2016 +0000

     KVM: vmx: add support for emulating UMIP

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1791cd6e600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1451cd6e600000
console output: https://syzkaller.appspot.com/x/log.txt?x=1051cd6e600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
Fixes: 0367f205a3b7 ("KVM: vmx: add support for emulating UMIP")

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and  
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for  
details.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8759 at arch/x86/kvm/vmx/vmx.c:4688  
handle_desc+0x78/0x90 arch/x86/kvm/vmx/vmx.c:4688
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8759 Comm: syz-executor328 Not tainted 5.3.0-rc6-next-20190830  
#75
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2dc/0x755 kernel/panic.c:220
  __warn.cold+0x2f/0x3c kernel/panic.c:581
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:handle_desc+0x78/0x90 arch/x86/kvm/vmx/vmx.c:4688
Code: 59 00 31 f6 4c 89 e7 e8 26 d5 f4 ff 31 ff 41 89 c4 89 c6 e8 ca 16 59  
00 31 c0 45 85 e4 5b 0f 94 c0 41 5c 5d c3 e8 38 15 59 00 <0f> 0b eb cf e8  
1f f6 93 00 eb ab 0f 1f 00 66 2e 0f 1f 84 00 00 00
RSP: 0018:ffff8880981c79a0 EFLAGS: 00010293
RAX: ffff88809997e000 RBX: 0000000000000000 RCX: ffffffff811940a6
RDX: 0000000000000000 RSI: ffffffff811940d8 RDI: 0000000000000007
RBP: ffff8880981c79b0 R08: ffff88809997e000 R09: ffffed1015d06aed
R10: ffffed1015d06aec R11: ffff8880ae835763 R12: ffff888097628040
R13: 000000000000002f R14: ffff88809762bc0c R15: ffff888097628070
  vmx_handle_exit+0x299/0x15f0 arch/x86/kvm/vmx/vmx.c:5896
  vcpu_enter_guest+0x1087/0x6200 arch/x86/kvm/x86.c:8105
  vcpu_run arch/x86/kvm/x86.c:8169 [inline]
  kvm_arch_vcpu_ioctl_run+0x424/0x1750 arch/x86/kvm/x86.c:8377
  kvm_vcpu_ioctl+0x4dc/0xf50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2764
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x443819
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 1b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd0b551188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffd0b551190 RCX: 0000000000443819
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
RBP: 0000000000000000 R08: 00000000004010a0 R09: 00000000004010a0
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004048c0
R13: 0000000000404950 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
