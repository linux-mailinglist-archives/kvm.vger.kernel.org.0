Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02421952D0
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 09:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgC0IaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 04:30:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41054 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0IaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Mar 2020 04:30:18 -0400
Received: by mail-io1-f72.google.com with SMTP id n15so7811638iog.8
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 01:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Awmrc28CDY1AZ83pA4uGFBy3Qoi504Fv29AXsnr28b8=;
        b=gu4gsa4U1EVoHFqlfvHSHmSeh5VBD+lPrJ9vBbr6XkEB6qCd02rUF7JZJrrVli5Dq2
         9CXQFekKrWz5ZinR6CaSpz7tXX3hR2hXVQgF392V/TEltPI4ufWpuyS/oHFcOYAOXGkO
         8QSPYQ3OgH5ctdJpftQlOGmPs7+uqMne3hchCnFlxE2l8LAp69QjKvzl3oip1M7CWeza
         YEo/JaAdMqKfVpCJJILUrUfyboh7m/FPPHzG8C2n0DR0PW7YYA9kR9rlZqSX6vxVc68j
         UTROVDp2HLT00I0omNNfcL4Fi4mn4IdajgmXl2BfAUjksLv3XTovFhsN/2PQ+8lhQmWD
         7JPw==
X-Gm-Message-State: ANhLgQ03xQJrdSgDFJU72SCuK/AI0jEKJAr5AohGueYdEmgsTCqzcAff
        /Vbrb5WnnWcQw6FtbojGk/XI38uPMz3lkIKIcLf3z59N6gSB
X-Google-Smtp-Source: ADFU+vtqbGigm61IfivIkl/OeGcPUHx3TUwDgup75xivGXOeYIm1ND/i+YGK9wU9iO6viFiKmUYUSYVOBnaEfwgRYqoIbbJfD6cv
MIME-Version: 1.0
X-Received: by 2002:a02:8798:: with SMTP id t24mr1757496jai.119.1585297817052;
 Fri, 27 Mar 2020 01:30:17 -0700 (PDT)
Date:   Fri, 27 Mar 2020 01:30:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003fa8d005a1d1e91c@google.com>
Subject: KASAN: null-ptr-deref Read in kvm_vfio_set_attr
From:   syzbot <syzbot+c8f52ab16178cebd5f5c@syzkaller.appspotmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    770fbb32 Add linux-next specific files for 20200228
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16974813e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=576314276bce4ad5
dashboard link: https://syzkaller.appspot.com/bug?extid=c8f52ab16178cebd5f5c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fa5e75e00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14eeae75e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16eeae75e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12eeae75e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c8f52ab16178cebd5f5c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in kvm_vfio_set_group arch/x86/kvm/../../../virt/kvm/vfio.c:235 [inline]
BUG: KASAN: null-ptr-deref in kvm_vfio_set_attr+0x7da/0xa30 arch/x86/kvm/../../../virt/kvm/vfio.c:337
Read of size 8 at addr 0000000000000000 by task syz-executor.2/9641

CPU: 0 PID: 9641 Comm: syz-executor.2 Not tainted 5.6.0-rc3-next-20200228-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 __kasan_report.cold+0x5/0x32 mm/kasan/report.c:510
 kasan_report+0xe/0x20 mm/kasan/common.c:618
 kvm_vfio_set_group arch/x86/kvm/../../../virt/kvm/vfio.c:235 [inline]
 kvm_vfio_set_attr+0x7da/0xa30 arch/x86/kvm/../../../virt/kvm/vfio.c:337
 </IRQ>
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9641 Comm: syz-executor.2 Tainted: G    B             5.6.0-rc3-next-20200228-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 end_report+0x43/0x49 mm/kasan/report.c:96
 __kasan_report.cold+0xd/0x32 mm/kasan/report.c:513
 kasan_report+0xe/0x20 mm/kasan/common.c:618
 kvm_vfio_set_group arch/x86/kvm/../../../virt/kvm/vfio.c:235 [inline]
 kvm_vfio_set_attr+0x7da/0xa30 arch/x86/kvm/../../../virt/kvm/vfio.c:337
 </IRQ>
Shutting down cpus with NMI
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
