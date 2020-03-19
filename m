Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B0D18B195
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 11:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgCSKfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 06:35:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:51734 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgCSKfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 06:35:17 -0400
Received: by mail-io1-f71.google.com with SMTP id d1so1308957iod.18
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 03:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=75IFSF+U0YhTbbRGzRYltGi5QkhePC6VgWPG6wybEig=;
        b=ZWBfBaxV4D0dApl6tCjeRc7O/PWYL2QOpwz6SV3tQ24ZxjtFUt35+mYXzxVNqOx4dE
         qTwVKBZfEr+dJktFWqF8446BNKbMfE/Mico7f0sb6/FzFdE12WsuCLpIq8jm4gYupmwu
         R/4B88S3osUaa9+Q1m0OEiuoylMhtUFzwxdPFUBUDWY2qQjR3sJnHl628FJF18CV0caK
         0/lizBgAgQt2/b4QwltkD4I6yoDqIvKYEqZLhKLJZuIgpJug+pWlbBykhiGcyCda6LCR
         vyUlJRFOLDUibg+wzppHnIcxO5/Y4y+B2fEZnHYGIz2yx1jv5Gr3SQCyse163rrVDpwT
         Caeg==
X-Gm-Message-State: ANhLgQ3yp9rXVv2Mwi584IP1P9/CoBUztpfaOu6TyGwvXR4in9UG1vDA
        G3x8x+klRtCSIxgTPHqhWAS5RsFXZ3jxOvMwt1M+4wsPgPdl
X-Google-Smtp-Source: ADFU+vsdroRqSLGN56Cc3Nn2W+BmUiajwugkafWJeacGc4vIpO1oUXD2MhjHgSjlm5KXkDc//S5OUmRIgWgxDpDverVTVgn3ZG4F
MIME-Version: 1.0
X-Received: by 2002:a92:dad0:: with SMTP id o16mr2312812ilq.27.1584614116260;
 Thu, 19 Mar 2020 03:35:16 -0700 (PDT)
Date:   Thu, 19 Mar 2020 03:35:16 -0700
In-Reply-To: <000000000000f965b8059877e5e6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000081861f05a132b9cd@google.com>
Subject: Re: WARNING in vcpu_enter_guest
From:   syzbot <syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    5076190d mm: slub: be more careful about the double cmpxch..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=143ca61de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid=00be5da1d75f1cc95f6b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bb4023e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 9833 at arch/x86/kvm/x86.c:2447 kvm_guest_time_update arch/x86/kvm/x86.c:2447 [inline]
WARNING: CPU: 0 PID: 9833 at arch/x86/kvm/x86.c:2447 vcpu_enter_guest+0x3cf3/0x6120 arch/x86/kvm/x86.c:8175
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9833 Comm: syz-executor.0 Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:kvm_guest_time_update arch/x86/kvm/x86.c:2447 [inline]
RIP: 0010:vcpu_enter_guest+0x3cf3/0x6120 arch/x86/kvm/x86.c:8175
Code: f3 7e 0f 94 c3 31 ff 89 de e8 d9 03 64 00 84 db 0f 84 62 ea ff ff e8 9c 02 64 00 e8 fb 43 f2 ff e9 53 ea ff ff e8 8d 02 64 00 <0f> 0b e9 e7 dc ff ff e8 81 02 64 00 bf 00 94 35 77 45 31 e4 4c 69
RSP: 0018:ffffc900024afb50 EFLAGS: 00010293
RAX: ffff888097b88040 RBX: fffffffffffff8d2 RCX: ffffffff810dff78
RDX: 0000000000000000 RSI: ffffffff810e2293 RDI: 0000000000000007
RBP: ffffc900024afcc0 R08: ffff888097b88040 R09: fffffbfff180e58f
R10: fffffbfff180e58e R11: ffffffff8c072c77 R12: 0000000000000000
R13: ffffc90002521000 R14: ffff88808e620378 R15: ffff88808e620340
 vcpu_run arch/x86/kvm/x86.c:8513 [inline]
 kvm_arch_vcpu_ioctl_run+0x41c/0x1790 arch/x86/kvm/x86.c:8735
 kvm_vcpu_ioctl+0x493/0xe60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2932
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c849
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f5029f2ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f5029f2f6d4 RCX: 000000000045c849
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000003be R14: 00000000004c647e R15: 000000000076bf0c
Kernel Offset: disabled
Rebooting in 86400 seconds..

