Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1FD2D3C5A
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 08:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgLIHdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 02:33:52 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:45743 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbgLIHdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 02:33:52 -0500
Received: by mail-il1-f197.google.com with SMTP id x10so633473ilq.12
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 23:33:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eStcawb44va1PiUp6/gLCccvFdDf+NyB7gv2v4oCOEA=;
        b=XlOqyja0xyIkQqt6U40rjZK6uvzabcGjPfJGc1E+nDS6Td8iYDQMu6Tnnwa6+LO7jP
         vdxSIBspXzErM22WJUYPRCBu6YKN9sPjUsYpxs+NYSznOsb7krHAU9DbywV7I5UGG/jy
         qmr0dXho98gSDWE1QoLxB2DX3C5bJeM6lbp0F32aGhXFJIUKs6PdwfI4ghW/gelJByNW
         DO9Wzh3+79w89Gt5iuViCJvXi8DUbAla+SFCc9feGzrm3Tb9E4/I7bFCfUD8SVeIsRpQ
         PrQH866xtZJKdppW9UGha8jtZODjNvq7mA2vU6UDFAmsBzUxXk/lIEJqaTFWUkeSASz8
         RGOQ==
X-Gm-Message-State: AOAM532JJCOgPgo70oFuQFfvelKhmnAlEb26g2UKeneqldfhqfAh/4Bo
        nC03oNVhhmfXsicmQcwbYBPilbNNMm5WxSyzAcQmkqBhD+tz
X-Google-Smtp-Source: ABdhPJwmAYRmZZ86Jb0ZNdjkn3rp9WZx01fiHADUt8KCjBhTC1T6D1UJofF+UBslJD7tYDB6AY1yRULR30+vBL2xmwIWvuVSHA06
MIME-Version: 1.0
X-Received: by 2002:a5d:85c7:: with SMTP id e7mr1147485ios.162.1607499191235;
 Tue, 08 Dec 2020 23:33:11 -0800 (PST)
Date:   Tue, 08 Dec 2020 23:33:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045373e05b603126f@google.com>
Subject: UBSAN: shift-out-of-bounds in intel_pmu_refresh
From:   syzbot <syzbot+ae488dc136a4cc6ba32b@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    15ac8fdb Add linux-next specific files for 20201207
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10e6b923500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3696b8138207d24d
dashboard link: https://syzkaller.appspot.com/bug?extid=ae488dc136a4cc6ba32b
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168d927b500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e0f703500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ae488dc136a4cc6ba32b@syzkaller.appspotmail.com

================================================================================
UBSAN: shift-out-of-bounds in arch/x86/kvm/vmx/pmu_intel.c:348:45
shift exponent 197 is too large for 64-bit type 'long long unsigned int'
CPU: 0 PID: 8491 Comm: syz-executor902 Not tainted 5.10.0-rc6-next-20201207-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 intel_pmu_refresh.cold+0x75/0x99 arch/x86/kvm/vmx/pmu_intel.c:348
 kvm_vcpu_after_set_cpuid+0x65a/0xf80 arch/x86/kvm/cpuid.c:177
 kvm_vcpu_ioctl_set_cpuid2+0x160/0x440 arch/x86/kvm/cpuid.c:308
 kvm_arch_vcpu_ioctl+0x11b6/0x2d70 arch/x86/kvm/x86.c:4709
 kvm_vcpu_ioctl+0x7b9/0xdb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3386
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x448f39
Code: e8 3c ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 4b ff fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fdfd8aadd98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000006ddc68 RCX: 0000000000448f39
RDX: 0000000020000480 RSI: 000000004008ae90 RDI: 0000000000000008
RBP: 00000000006ddc60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006ddc6c
R13: ddd82e0065000000 R14: 099a300f0078010f R15: 2e320fc0000080b9
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
