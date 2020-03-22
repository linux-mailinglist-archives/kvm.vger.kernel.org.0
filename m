Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18A118E721
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 07:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgCVGnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 02:43:16 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:33144 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgCVGnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 02:43:15 -0400
Received: by mail-il1-f200.google.com with SMTP id e7so9369172ilc.0
        for <kvm@vger.kernel.org>; Sat, 21 Mar 2020 23:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wv/2UGF5kabN9EEOv4z2Ow9WAicDcFU5RQkZ7pucyB0=;
        b=e/Qo2enlNUKiTSlOFcqdNywvhrUpZKpGETTHM4hvDyNTp5nEeorxVhWphd14TYmfPM
         fwYA3+QmvOxXXLCdM94g9KqVlsxu4vIBemNqKam+sV2xp4BrZptlXuJ8omT9gLFb8a7T
         QUWReQuxOZjSWJTk9bTt915VxiBOF4RdtGtG5qfOMa3tGuIUzWsMXEiVAUTPn/4x5l8X
         4teDY98Ba6Hpy4qSy0y6roxEMYrTQxJWDgcMSS2Y/aAHEzYMU7q187ET2Qr6jz2cgBDm
         CT3KR2zccq+lEK2g8zxraa4WcIX20FfISTIJCuYkLyhns/uA5YnfXfy9MhlU2AGPlFnZ
         A2pQ==
X-Gm-Message-State: ANhLgQ3Fqa1LnCfU54PraMh+as9VBC8+ih4aVOOjXTnEadZLKiR3u+kI
        GOolCerAVoirCt9PYj3m3CwsksskQZsjGdVs0mSwK8se79sh
X-Google-Smtp-Source: ADFU+vvquubI8dGpFseC2Ei0DUvjZKxJrkikh5RCLWOtXbSUoiMVcMYH3a7lLyO1hc/9OQ4tE2sYsnGJv5+bUd2KTp8uDMMZwCj5
MIME-Version: 1.0
X-Received: by 2002:a92:8312:: with SMTP id f18mr15328045ild.98.1584859393258;
 Sat, 21 Mar 2020 23:43:13 -0700 (PDT)
Date:   Sat, 21 Mar 2020 23:43:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000277a0405a16bd5c9@google.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in handle_external_interrupt_irqoff
From:   syzbot <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com>
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

HEAD commit:    b74b991f Merge tag 'block-5.6-20200320' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16403223e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
dashboard link: https://syzkaller.appspot.com/bug?extid=3f29ca2efb056a761e38
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000086
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD a63a4067 P4D a63a4067 PUD a7627067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9785 Comm: syz-executor.2 Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x86
Code: Bad RIP value.
RSP: 0018:ffffc90001ac7998 EFLAGS: 00010086
RAX: ffffc90001ac79c8 RBX: fffffe0000000000 RCX: 0000000000040000
RDX: ffffc9000e20f000 RSI: 000000000000b452 RDI: 000000000000b453
RBP: 0000000000000ec0 R08: ffffffff83987523 R09: ffffffff811c7eca
R10: ffff8880a4e94200 R11: 0000000000000002 R12: dffffc0000000000
R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
FS:  00007fb50e370700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000005c CR3: 0000000092fc7000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 handle_external_interrupt_irqoff+0x154/0x280 arch/x86/kvm/vmx/vmx.c:6274
 kvm_before_interrupt arch/x86/kvm/x86.h:343 [inline]
 handle_external_interrupt_irqoff+0x132/0x280 arch/x86/kvm/vmx/vmx.c:6272
 __irqentry_text_start+0x8/0x8
 vcpu_enter_guest+0x6c77/0x9290 arch/x86/kvm/x86.c:8405
 save_stack mm/kasan/common.c:72 [inline]
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:476
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 tomoyo_path_number_perm+0x525/0x690 security/tomoyo/file.c:736
 security_file_ioctl+0x55/0xb0 security/security.c:1441
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
 __lock_acquire+0xc5a/0x1bc0 kernel/locking/lockdep.c:3954
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 hlock_class kernel/locking/lockdep.c:163 [inline]
 mark_lock+0x107/0x1650 kernel/locking/lockdep.c:3642
 lock_acquire+0x154/0x250 kernel/locking/lockdep.c:4484
 rcu_lock_acquire+0x9/0x30 include/linux/rcupdate.h:208
 kvm_check_async_pf_completion+0x34e/0x360 arch/x86/kvm/../../../virt/kvm/async_pf.c:137
 vcpu_run+0x3a3/0xd50 arch/x86/kvm/x86.c:8513
 kvm_arch_vcpu_ioctl_run+0x419/0x880 arch/x86/kvm/x86.c:8735
 kvm_vcpu_ioctl+0x67c/0xa80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2932
 kvm_vm_release+0x50/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:858
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl fs/ioctl.c:763 [inline]
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl+0xf9/0x160 fs/ioctl.c:770
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
Modules linked in:
CR2: 0000000000000086
---[ end trace 4da75c292cd7e3e8 ]---
RIP: 0010:0x86
Code: Bad RIP value.
RSP: 0018:ffffc90001ac7998 EFLAGS: 00010086
RAX: ffffc90001ac79c8 RBX: fffffe0000000000 RCX: 0000000000040000
RDX: ffffc9000e20f000 RSI: 000000000000b452 RDI: 000000000000b453
RBP: 0000000000000ec0 R08: ffffffff83987523 R09: ffffffff811c7eca
R10: ffff8880a4e94200 R11: 0000000000000002 R12: dffffc0000000000
R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
FS:  00007fb50e370700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000005c CR3: 0000000092fc7000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
