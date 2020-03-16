Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0525186CCE
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 15:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbgCPOHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 10:07:13 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:55968 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730724AbgCPOHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 10:07:13 -0400
Received: by mail-io1-f69.google.com with SMTP id k5so11660267ioa.22
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 07:07:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4JiZZGrDgYdWRzN/bDURxroqaFHr/bhJkGKhmDYaOuk=;
        b=eG0YMuLDFD0QZrqXWJCWEu5K0rWNAzoRzUNAxmOxj/zVLfXzSLDkzoCZdEBgdknYtP
         JlJCJo0eEutS0iygawFEWf5+7etS0TNBL5cB0B3OsJQ/N/LlZ8hNv7msh4rYdQpum6SS
         0MuVgmD4/leeX7rALJtX2uu3gVZ3uPeONMoT6KsSRpg3Fo7jecfmqr6nGnsj62ZpFRrh
         /4hEwBy9BtT6FtcndW4qeg9q7O7OwiBA9GoOehkXHkTMEinKA6FFzvVGRFpSNPZUt2vB
         rQjnnnBoge+hBta7il1Udnw5TkwAfOmVDUiKDWp2a2fQWR7HBAYQ0/ZfeZU1sVvAUHQp
         4T1A==
X-Gm-Message-State: ANhLgQ3IaOE37qHxwuWyNnLNUV3MHLd8RvPkQeGTuZ/Pob/uNbsQWQzP
        RXzA6t7mgmyZKU0eoOALMkn8CttgWuRMGTk/QUlue45pl8Zb
X-Google-Smtp-Source: ADFU+vt394A4zTcPymmt40GyT+CgIm6/r2bbD9S9NBZ2dUgvWYtR5hXyvQ6gSvTB47DHk/PDVdflzb8pZkTgkNISlWSPKGJ8PyAJ
MIME-Version: 1.0
X-Received: by 2002:a92:c52b:: with SMTP id m11mr27518014ili.38.1584367632349;
 Mon, 16 Mar 2020 07:07:12 -0700 (PDT)
Date:   Mon, 16 Mar 2020 07:07:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000eb7df505a0f955dd@google.com>
Subject: KASAN: user-memory-access Read in kvmclock_cpufreq_notifier
From:   syzbot <syzbot+59cd93bc8960efdbae86@syzkaller.appspotmail.com>
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

HEAD commit:    e6e6ec48 Merge tag 'fscrypt-for-linus' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=163a5753e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=59cd93bc8960efdbae86
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144d1619e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115c4475e00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=165b512de00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=155b512de00000
console output: https://syzkaller.appspot.com/x/log.txt?x=115b512de00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+59cd93bc8960efdbae86@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: user-memory-access in atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: user-memory-access in __kvmclock_cpufreq_notifier arch/x86/kvm/x86.c:7133 [inline]
BUG: KASAN: user-memory-access in kvmclock_cpufreq_notifier+0x1e9/0x580 arch/x86/kvm/x86.c:7172
Read of size 4 at addr 00000000896bb8f0 by task syz-executor372/10372

CPU: 0 PID: 10372 Comm: syz-executor372 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 __kasan_report.cold+0x5/0x32 mm/kasan/report.c:510
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x128/0x190 mm/kasan/generic.c:192
 atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
 __kvmclock_cpufreq_notifier arch/x86/kvm/x86.c:7133 [inline]
 kvmclock_cpufreq_notifier+0x1e9/0x580 arch/x86/kvm/x86.c:7172
 </IRQ>
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 10372 Comm: syz-executor372 Tainted: G    B             5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 end_report+0x43/0x49 mm/kasan/report.c:96
 __kasan_report.cold+0xd/0x32 mm/kasan/report.c:513
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x128/0x190 mm/kasan/generic.c:192
 atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
 __kvmclock_cpufreq_notifier arch/x86/kvm/x86.c:7133 [inline]
 kvmclock_cpufreq_notifier+0x1e9/0x580 arch/x86/kvm/x86.c:7172
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
