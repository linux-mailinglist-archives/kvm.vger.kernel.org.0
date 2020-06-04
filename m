Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E441EE017
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 10:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgFDIuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 04:50:19 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:49331 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgFDIuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 04:50:18 -0400
Received: by mail-io1-f72.google.com with SMTP id h17so3164056ior.16
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 01:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A2HBUdAMpWbKBpNbzC++zcPeQhDXmhmI0aCAyr/UXfk=;
        b=P0HcGVQbcUjA979VD3r8NQk35kZAynqa7RK6JZIMAGGTjryroAp1h7xoScygJtgJxM
         fRhKO9Zgd3agOEdnIEqEF8D4Gynv/Zi/1n/XVwWQV7nMRTl3Gh7IlM1rr7GqJ1nXmTuv
         Y90pU+cb/xkWwCyGT18iUi1JEw/0oP9Sxexz8ZlgoE250MNYL28pKKffgACzAtY0J0yl
         pviVNJHi+a1B5l51F94WAtfnyQOF224jCpLk5JA4rZP2GNw1FwD4jVjZ1qV80Es4hn77
         jGyeDv0NLaagFIR0vAFeVAZYE2ghaMLVAlHb/IgJJz/f8OHUenbRHIcfXqrUq2uiccBV
         bT0A==
X-Gm-Message-State: AOAM532Oou2eifus7iHUWYUyDkZfYd0zlNwVaRFCTEFAqftpqwiLQ2YT
        KlEK710E8FrQw4tdWh6nPiuSgB52jQl0IzCKfQCeXGbgbGBi
X-Google-Smtp-Source: ABdhPJwhHXrd9hyDDeUrOTmPuneHcL4rL4S3D/rQ5xbu/pyI62sptAnY0k9viO1BJbH1sfUlGLIwZjG+dQp3Xr5rsc6hyuJWuFxn
MIME-Version: 1.0
X-Received: by 2002:a92:b00e:: with SMTP id x14mr2918527ilh.219.1591260616368;
 Thu, 04 Jun 2020 01:50:16 -0700 (PDT)
Date:   Thu, 04 Jun 2020 01:50:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8a76e05a73e3be3@google.com>
Subject: WARNING in kvm_inject_emulated_page_fault
From:   syzbot <syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cb8e59cc Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14dedfe2100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a16ddbc78955e3a9
dashboard link: https://syzkaller.appspot.com/bug?extid=2a7156e11dc199bdbd8a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134ca2de100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178272f2100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6819 at arch/x86/kvm/x86.c:618 kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6819 Comm: syz-executor268 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:105 [inline]
 fixup_bug arch/x86/kernel/traps.c:100 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:197
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:216
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:kvm_inject_emulated_page_fault+0x210/0x290 arch/x86/kvm/x86.c:618
Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 79 48 8b 53 08 4c 89 f6 48 89 ef e8 fa 04 0c 00 e9 10 ff ff ff e8 10 ac 68 00 <0f> 0b e9 3a fe ff ff 4c 89 e7 e8 21 74 a7 00 e9 5d fe ff ff 48 89
RSP: 0018:ffffc90000f87968 EFLAGS: 00010293
RAX: ffff888095202540 RBX: ffffc90000f879e0 RCX: ffffffff810ae417
RDX: 0000000000000000 RSI: ffffffff810ae5e0 RDI: 0000000000000001
RBP: ffff888088ce0040 R08: ffff888095202540 R09: fffff520001f0f58
R10: ffffc90000f87abf R11: fffff520001f0f57 R12: 0000000000000000
R13: 0000000000000001 R14: ffffc90000f87ab8 R15: ffff888088ce0380
 nested_vmx_get_vmptr+0x1f9/0x2a0 arch/x86/kvm/vmx/nested.c:4638
 handle_vmon arch/x86/kvm/vmx/nested.c:4767 [inline]
 handle_vmon+0x168/0x3a0 arch/x86/kvm/vmx/nested.c:4728
 vmx_handle_exit+0x29c/0x1260 arch/x86/kvm/vmx/vmx.c:6067
 vcpu_enter_guest arch/x86/kvm/x86.c:8604 [inline]
 vcpu_run arch/x86/kvm/x86.c:8669 [inline]
 kvm_arch_vcpu_ioctl_run+0x2723/0x68a0 arch/x86/kvm/x86.c:8890
 kvm_vcpu_ioctl+0x46a/0xe20 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3163
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:771
 __do_sys_ioctl fs/ioctl.c:780 [inline]
 __se_sys_ioctl fs/ioctl.c:778 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:778
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x443569
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffece6351a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffece6351b0 RCX: 0000000000443569
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000020003800 R09: 0000000000400eb0
R10: 00007ffece633610 R11: 0000000000000246 R12: 0000000000404610
R13: 00000000004046a0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
