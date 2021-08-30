Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E625D3FB328
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 11:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbhH3JfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 05:35:20 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:47972 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbhH3JfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 05:35:19 -0400
Received: by mail-il1-f198.google.com with SMTP id j17-20020a926e11000000b0022487646515so8654353ilc.14
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 02:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=T+O67gwiRaVfdJjcJ1aFvYV9X0Yl7JeqENgnYORlL/A=;
        b=BXBAgX+rM8ySiF/dDFA0yTuNL959tW3bIiht2+TSPxXkvsBuC4r23zgUr4edan1f39
         J36VUb38qNDZUjNDabnwfg2hK47icpAJ2J2xvJAKaufbPimtWtY/7gdksFbxhPeExNDR
         r5PR31hFtwtYrMWCwOHxQxYjDPv2a3cS4MRs9fbIfUKJT34OleSSwh+5TV3rRwQJeYzw
         mOVsR5An+6jLZTWAD/3inMXm842R1c8Pskq8+h/f/vWBemSiDW/W7RAZUSWfWQF1egnc
         s5nQkwwtKmev1pap1obLZiF2DAB6ekAXd3CLlPXN1HwNpxZVk/lPGJqOCn/2Z8qh0aPO
         eaBA==
X-Gm-Message-State: AOAM531wRzKcdvoONrBVkgq9ALbXoCQi//oqlXYACzg1LmHjvc2sxIzm
        CPFlL4lGyG4ltiiWGkoc+nWrrJRafFJzLROc/JJrNiAyZv68
X-Google-Smtp-Source: ABdhPJxcyU2jINHVL3lxikmSdHU+KGMvG6/+ShL3UkJuOsG7YE+DVD8IvDua3XswKiea1EF/PwMD34VO2kqCZpkeE261MnZ93GEE
MIME-Version: 1.0
X-Received: by 2002:a6b:8e50:: with SMTP id q77mr17024476iod.96.1630316065870;
 Mon, 30 Aug 2021 02:34:25 -0700 (PDT)
Date:   Mon, 30 Aug 2021 02:34:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa5aea05cac3895f@google.com>
Subject: [syzbot] WARNING in exception_type
From:   syzbot <syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3f5ad13cb012 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=156f9a4d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94074b5caf8665c7
dashboard link: https://syzkaller.appspot.com/bug?extid=200c08e88ae818f849ce
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13848dfe300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=136d69e1300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8469 at arch/x86/kvm/x86.c:525 exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
Modules linked in:
CPU: 1 PID: 8469 Comm: syz-executor531 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
Code: 31 ff 45 31 ed 44 89 e6 e8 25 75 69 00 45 85 e4 41 0f 95 c5 45 01 ed e8 d6 6d 69 00 44 89 e8 5b 41 5c 41 5d c3 e8 c8 6d 69 00 <0f> 0b e8 c1 6d 69 00 41 bd 03 00 00 00 5b 44 89 e8 41 5c 41 5d c3
RSP: 0018:ffffc90000f1f8f0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 00000000000000a2 RCX: 0000000000000000
RDX: ffff888018461c40 RSI: ffffffff810c3b28 RDI: 0000000000000003
RBP: ffff888020868000 R08: 000000000000001f R09: 00000000000000a2
R10: ffffffff810c3aaa R11: 0000000000000006 R12: 00000000000000a2
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000040
FS:  000000000179c300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffd362aad8 CR3: 00000000182ef000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 x86_emulate_instruction+0xef6/0x1460 arch/x86/kvm/x86.c:7853
 kvm_mmu_page_fault+0x2f0/0x1810 arch/x86/kvm/mmu/mmu.c:5199
 handle_ept_misconfig+0xdf/0x3e0 arch/x86/kvm/vmx/vmx.c:5336
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6021 [inline]
 vmx_handle_exit+0x336/0x1800 arch/x86/kvm/vmx/vmx.c:6038
 vcpu_enter_guest+0x2a1c/0x4430 arch/x86/kvm/x86.c:9712
 vcpu_run arch/x86/kvm/x86.c:9779 [inline]
 kvm_arch_vcpu_ioctl_run+0x47d/0x1b20 arch/x86/kvm/x86.c:10010
 kvm_vcpu_ioctl+0x49e/0xe50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3652
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x441159
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffd362c598 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 0000000000441159
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 0000000000404c50 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000404ce0
R13: 0000000000000000 R14: 00000000004ae018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
