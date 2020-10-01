Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D66728084F
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 22:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733006AbgJAUS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 16:18:26 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:45993 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgJAUSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 16:18:25 -0400
Received: by mail-io1-f79.google.com with SMTP id p65so4464660iod.12
        for <kvm@vger.kernel.org>; Thu, 01 Oct 2020 13:18:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OXIZsSnUOlc4gw4iyjdMyg6484OMYqcylRmSwR+4wSw=;
        b=SkZzvGZu7ah05ESE3BgbcCr3F6/Ocivz5YKBwqzZOxhBcP6A/l3xWNVko/TO29xcrr
         UWeAmgTm6QaVunfNVxN43suwXtUyI6vY/SJAY1QcxwXt/vYpo3BXJ4PglvfBz2I4IPGc
         H2m6sDpL+fiPVpQOy3YKolVEGW7JBz2ZlMeHKqhGesJyYeXizlldu+5ZPKxFO8z8udqF
         gRqz4EkLqhn76J90WyZ8pVgEgDGUH3TO6f5Q0P/zTG7Wk51AMIyd/AAG2PwBCgLhObeF
         vkKuTDvRo4St7/Jz67E9VwqU8w83/tc7tfPHT0Glax8O1Ju4Utt9TkPvNOUSeVBQyJ6x
         l4Dw==
X-Gm-Message-State: AOAM530kb45KULMhTqYSCub4jUvJJXXwso8pb5P4mprvg350DNmprveE
        gC8khvoH4g02jdxT+jCaDoX7FDqp7/Fw7+gkPH+imN95Irbh
X-Google-Smtp-Source: ABdhPJwT/dpYIRCW3/PoHCOUt9O1bS/nQ9SMyEkaCehe2TanjqOnWqQbBKb5eZrQlzsed5b2jOZsjZDiHJWLKEX47Ksdg2cuvdi/
MIME-Version: 1.0
X-Received: by 2002:a5e:820d:: with SMTP id l13mr6866782iom.3.1601583504502;
 Thu, 01 Oct 2020 13:18:24 -0700 (PDT)
Date:   Thu, 01 Oct 2020 13:18:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd392b05b0a1b7ac@google.com>
Subject: WARNING in handle_exception_nmi
From:   syzbot <syzbot+4e78ae6b12b00b9d1042@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fb0155a0 Merge tag 'nfs-for-5.9-3' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a7329d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=adebb40048274f92
dashboard link: https://syzkaller.appspot.com/bug?extid=4e78ae6b12b00b9d1042
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173937ad900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1041373d900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4e78ae6b12b00b9d1042@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6854 at arch/x86/kvm/vmx/vmx.c:4809 handle_exception_nmi+0x1051/0x12a0 arch/x86/kvm/vmx/vmx.c:4809
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6854 Comm: syz-executor665 Not tainted 5.9.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 panic+0x2c0/0x800 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:handle_exception_nmi+0x1051/0x12a0 arch/x86/kvm/vmx/vmx.c:4809
Code: fd 98 00 e9 17 f1 ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c da f0 ff ff 48 89 df e8 a9 fd 98 00 e9 cd f0 ff ff e8 1f 19 59 00 <0f> 0b e9 e0 f6 ff ff 89 d1 80 e1 07 80 c1 03 38 c1 0f 8c f4 f1 ff
RSP: 0018:ffffc90000e979b0 EFLAGS: 00010293
RAX: ffffffff811be461 RBX: fffffffffffffff8 RCX: ffff888091f42200
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: ffffffff811bdb3a R09: ffffed1014faf071
R10: ffffed1014faf071 R11: 0000000000000000 R12: ffff8880a7d78380
R13: 1ffff11014faf026 R14: ffff8880a7d78040 R15: 0000000000000002
 vcpu_enter_guest+0x6725/0x8a50 arch/x86/kvm/x86.c:8655
 vcpu_run+0x332/0xc00 arch/x86/kvm/x86.c:8720
 kvm_arch_vcpu_ioctl_run+0x451/0x8f0 arch/x86/kvm/x86.c:8937
 kvm_vcpu_ioctl+0x64f/0xa50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3230
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443bb9
Code: e8 dc a3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 00 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff4f9aff08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000443bb9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00000000006ce018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000012 R11: 0000000000000246 R12: 0000000000404120
R13: 00000000004041b0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
