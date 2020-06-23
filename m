Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF22205238
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 14:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgFWMRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 08:17:18 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:52594 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729552AbgFWMRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 08:17:17 -0400
Received: by mail-il1-f200.google.com with SMTP id v14so14311667ilo.19
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 05:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wlhuLVD4u+XXQ7HeSYAD3cLeISlYbuyy5YsqjwGO8Ac=;
        b=S5o+m5h8C9J66cp8a/0LzmEOO6a4/3j3BC8FqTR0+lLNm1bCrRFRx6m19s9YdJdenI
         ssHlDRQu0X0eCe4B8Yapo+7gxPSOytVqgjMrrlO5pnHDEZfiPVdDPczMZTDfYHCwWgqP
         HyS5oNE3jbwGdR0rrTXhqE+Q3TnjzkyuzIzqPGMIUITwqprDuxyezxzLJ9rssoeHL/vf
         ssfhIsyNn2pDZc/i7tc1iic4vjYS/Yt8mrKt2TpaSAO1FSyspZnwHuxGVRGBFCWhbyEA
         iu+RdrgLfrn3GwLOxjwKxcOuSkSWwBEjLeFZcmX9ljMy9sKsHmt8bDSvtxW02wajn8Ga
         8M2Q==
X-Gm-Message-State: AOAM530vxlm68XHqp6JPHdtOW4YT4rrxaqXBoPKUBL3GJBw/EEFYTolJ
        pvEqZW1HjhiGT9lCheRdB/vvNuGCMmGD5G78Phu5Yto9FR2d
X-Google-Smtp-Source: ABdhPJyU4beGPn+n5GTW5K+FfN41A3Vtb/0AYshbsOeC1yWAFc6mdL777MAvP/4VCkWzyTUfevSP1uF075zX0wT6JKuF/ak8WPuo
MIME-Version: 1.0
X-Received: by 2002:a6b:b984:: with SMTP id j126mr24459783iof.114.1592914635879;
 Tue, 23 Jun 2020 05:17:15 -0700 (PDT)
Date:   Tue, 23 Jun 2020 05:17:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000077a6505a8bf57b2@google.com>
Subject: KASAN: null-ptr-deref Read in kvm_arch_check_processor_compat
From:   syzbot <syzbot+a99874f5323ce6088e53@syzkaller.appspotmail.com>
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

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135e7235100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=a99874f5323ce6088e53
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d001be100000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13a8e549100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1068e549100000
console output: https://syzkaller.appspot.com/x/log.txt?x=17a8e549100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a99874f5323ce6088e53@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: null-ptr-deref in kvm_arch_check_processor_compat+0x1f8/0x750 arch/x86/kvm/x86.c:9818
Read of size 8 at addr 0000000000000060 by task syz-executor.2/8085

CPU: 1 PID: 8085 Comm: syz-executor.2 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 __kasan_report mm/kasan/report.c:517 [inline]
 kasan_report.cold+0x5/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x141/0x190 mm/kasan/generic.c:192
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 kvm_arch_check_processor_compat+0x1f8/0x750 arch/x86/kvm/x86.c:9818
 </IRQ>
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8085 Comm: syz-executor.2 Tainted: G    B             5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 end_report+0x4d/0x53 mm/kasan/report.c:104
 __kasan_report mm/kasan/report.c:520 [inline]
 kasan_report.cold+0xd/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x141/0x190 mm/kasan/generic.c:192
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 kvm_arch_check_processor_compat+0x1f8/0x750 arch/x86/kvm/x86.c:9818
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
