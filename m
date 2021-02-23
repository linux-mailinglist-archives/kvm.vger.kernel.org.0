Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4606322754
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 09:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhBWI6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 03:58:04 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:42841 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhBWI5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 03:57:02 -0500
Received: by mail-il1-f197.google.com with SMTP id i16so9804670ila.9
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 00:56:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8mctaqK5Xe/nm12bfA6IP15m3s7zU7gXEAtDskYQ4P4=;
        b=jSdLZ7xA+tAixBLQ6vINBPd0e+lpQXkGymnyE7Vst2SLw6KGZdoXMz8u7WBwmIT1cS
         uqz1PCpKLMDDFH8fh88gF2MCBAhAmy/+vWFOM8N0b7OIVqKCCIm1+dsM+1QPx3ispBh1
         QNx0D+E9cPMMItIzi0KR3riZtJCl+4DiDwODUc5bUo0iLb+aHs7k3kwBYxVi23kQQy4O
         ZFikpubyLrEQRnaJcXEsN4ngKQw+9f8ApP7HwqA/Nph17hu7sAYLCOcZXroR8e7CnO27
         9/HkDLBFDtELwSgEwDo/HFUWCX8mr5PDX6Mth5lGO3G11Ktf+LBn5PB85PriekjGY7UY
         wO4g==
X-Gm-Message-State: AOAM533yXUTIWrwdxmyJqLoqFOhq0FmNULmsP233MFOIXk2vSnb7gqYa
        9RFofJzBkjNlUTgglzWwJMXOlEbJ2yj9gSxdvf9hwctrInM7
X-Google-Smtp-Source: ABdhPJxn4mXzhlcasRUD+uq+PQiDHwpsVnfyGxvSw96aVfFYUjvMLJ6yu4KyixlQq5vdpbuLAEKvm8/WYc6Wq76f4EEpk58cbLpp
MIME-Version: 1.0
X-Received: by 2002:a92:6403:: with SMTP id y3mr18312215ilb.90.1614070580999;
 Tue, 23 Feb 2021 00:56:20 -0800 (PST)
Date:   Tue, 23 Feb 2021 00:56:20 -0800
In-Reply-To: <0000000000007ff56205ba985b60@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009f7a7305bbfd17a4@google.com>
Subject: Re: general protection fault in vmx_vcpu_run (2)
From:   syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a99163e9 Merge tag 'devicetree-for-5.12' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15cd357f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=49116074dd53b631
dashboard link: https://syzkaller.appspot.com/bug?extid=42a71c84ef04577f1aef
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c7f8a8d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137fc232d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com

RBP: 0000000000402ed0 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000000400488 R11: 0000000000000246 R12: 0000000000402f60
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
==================================================================
BUG: KASAN: global-out-of-bounds in atomic_switch_perf_msrs arch/x86/kvm/vmx/vmx.c:6604 [inline]
BUG: KASAN: global-out-of-bounds in vmx_vcpu_run+0x4f1/0x13f0 arch/x86/kvm/vmx/vmx.c:6771
Read of size 8 at addr ffffffff89a000e9 by task syz-executor198/8346

CPU: 0 PID: 8346 Comm: syz-executor198 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x125/0x19e lib/dump_stack.c:120
 print_address_description+0x5f/0x3a0 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report+0x15e/0x200 mm/kasan/report.c:413
 atomic_switch_perf_msrs arch/x86/kvm/vmx/vmx.c:6604 [inline]
 vmx_vcpu_run+0x4f1/0x13f0 arch/x86/kvm/vmx/vmx.c:6771
 vcpu_enter_guest+0x2ed9/0x8f10 arch/x86/kvm/x86.c:9074
 vcpu_run+0x316/0xb70 arch/x86/kvm/x86.c:9225
 kvm_arch_vcpu_ioctl_run+0x4e8/0xa40 arch/x86/kvm/x86.c:9453
 kvm_vcpu_ioctl+0x62a/0xa30 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3295
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43eee9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe7ad00d38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043eee9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 0000000000402ed0 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000000400488 R11: 0000000000000246 R12: 0000000000402f60
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488

The buggy address belongs to the variable:
 str__initcall__trace_system_name+0x9/0x40

Memory state around the buggy address:
 ffffffff899fff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffff89a00000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffffffff89a00080: 00 00 00 00 00 00 00 00 00 00 00 00 00 01 f9 f9
                                                          ^
 ffffffff89a00100: f9 f9 f9 f9 07 f9 f9 f9 f9 f9 f9 f9 00 03 f9 f9
 ffffffff89a00180: f9 f9 f9 f9 00 06 f9 f9 f9 f9 f9 f9 00 00 00 00
==================================================================

