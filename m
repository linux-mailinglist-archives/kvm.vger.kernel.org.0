Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF8047847
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 04:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfFQCzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jun 2019 22:55:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:48718 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbfFQCzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jun 2019 22:55:05 -0400
Received: by mail-io1-f72.google.com with SMTP id z19so10612832ioi.15
        for <kvm@vger.kernel.org>; Sun, 16 Jun 2019 19:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=euDDqb7rxlNkibCfMmfIJi1MEBtdDr5Z4oTu8ZibbCc=;
        b=JZRPlR/rlXEslUKXf5MtUUm7pRbd8ThM/7pDNj0bAWmjHteSHfA3jktYsErDH1M7mB
         xvDYE/dP3gsNmqZ/yEUmdvLDi2BmSE7rfED9uCNR59aFTyZk2Ty8Jv+65F6Sr68zOg2p
         OOlUg/mkwS2Ya2I3Mwt0An8aRQVuqU1gLE9K20e2+52JcqWLU0Gw1neHJGlCnbskn7sq
         XvUPzXQ97y2ZfEOtlg54w7PO7K0FURBYxIeT6Gyj9INtkTuBx4RLQZMxUsNznXQatrk0
         QgsfKQfnlSyBPZJzRyyqm1I0Vkwecdd8F8aR6mR0Jduq00FctSPwy97ZUeE5/Gji3w8V
         OrBQ==
X-Gm-Message-State: APjAAAU68hIvc+xd0JRMj/XXJqwg3r4y103KfZu8NbkslIq3yUB2hzao
        2xFuzobrSuGu/q4iWgCIPzaKQnD97C+QUCNRAoGTGDp+b7gl
X-Google-Smtp-Source: APXvYqy4wJ6t+52hlj4WAfJFDQi5RDlvW0Y1G+WY5Eqrd7k7jJqkzkeU3EqY4gkDNispYi3kjzXmcK3HkKNjP1abrY6ceTHOd4Rj
MIME-Version: 1.0
X-Received: by 2002:a6b:7909:: with SMTP id i9mr44048580iop.8.1560740104829;
 Sun, 16 Jun 2019 19:55:04 -0700 (PDT)
Date:   Sun, 16 Jun 2019 19:55:04 -0700
In-Reply-To: <000000000000d05a78056873bc47@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000089165c058b7c1f44@google.com>
Subject: Re: WARNING in kvm_arch_vcpu_ioctl_run (3)
From:   syzbot <syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, gleb@kernel.org,
        hpa@zytor.com, kernellwp@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, pbonzini@redhat.com,
        peterz@infradead.org, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    963172d9 Merge branch 'x86-urgent-for-linus' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11422276a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9f7e1b6a8bb586
dashboard link: https://syzkaller.appspot.com/bug?extid=760a73552f47a8cd0fd9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103d3e21a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1645f956a00000

The bug was bisected to:

commit 706249c222f68471b6f8e9e8e9b77665c404b226
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Jul 24 13:06:37 2015 +0000

     locking/static_keys: Rework update logic

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175cc587200000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14dcc587200000
console output: https://syzkaller.appspot.com/x/log.txt?x=10dcc587200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com
Fixes: 706249c222f6 ("locking/static_keys: Rework update logic")

WARNING: CPU: 1 PID: 9153 at arch/x86/kvm/x86.c:8302  
kvm_arch_vcpu_ioctl_run+0x1d8/0x1740 arch/x86/kvm/x86.c:8302
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9153 Comm: syz-executor142 Not tainted 5.2.0-rc4+ #53
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x744 kernel/panic.c:219
  __warn.cold+0x20/0x4d kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
RIP: 0010:kvm_arch_vcpu_ioctl_run+0x1d8/0x1740 arch/x86/kvm/x86.c:8302
Code: 80 3c 02 00 0f 85 09 14 00 00 49 8b 9c 24 18 0d 00 00 31 ff 48 89 de  
e8 56 93 62 00 48 85 db 0f 84 77 0c 00 00 e8 a8 91 62 00 <0f> 0b e8 a1 91  
62 00 49 8d 7e 01 48 b8 00 00 00 00 00 fc ff df 48
RSP: 0018:ffff8880a0a6fb30 EFLAGS: 00010293
RAX: ffff8880863945c0 RBX: 0000000000000001 RCX: ffffffff810e3c69
RDX: 0000000000000000 RSI: ffffffff810e2fb8 RDI: 0000000000000005
RBP: ffff8880a0a6fb98 R08: ffff8880863945c0 R09: ffffed1015d26be0
R10: ffffed1015d26bdf R11: ffff8880ae935efb R12: ffff8880a4048040
R13: 0000000000000000 R14: ffff8880937c8000 R15: ffff8880a38d2680
  kvm_vcpu_ioctl+0x4dc/0xf90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2755
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xd5f/0x1380 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x448cb9
Code: e8 8c b0 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 4b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff6ad8dcce8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000006ddc58 RCX: 0000000000448cb9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00000000006ddc50 R08: 00007ff6ad8dd700 R09: 0000000000000000
R10: 00007ff6ad8dd700 R11: 0000000000000246 R12: 00000000006ddc5c
R13: 00007ffdd645a21f R14: 00007ff6ad8dd9c0 R15: 20c49ba5e353f7cf
Kernel Offset: disabled
Rebooting in 86400 seconds..

