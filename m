Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4593C3EC150
	for <lists+kvm@lfdr.de>; Sat, 14 Aug 2021 10:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbhHNIFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 04:05:48 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:33419 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhHNIFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Aug 2021 04:05:47 -0400
Received: by mail-io1-f72.google.com with SMTP id k21-20020a5e93150000b02905b30d664397so833042iom.0
        for <kvm@vger.kernel.org>; Sat, 14 Aug 2021 01:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xMcztoibsZM0kct6X4eiVmQTed25Y4uqzZEe/3c2JIA=;
        b=tN05eW/Z5OWnAcYggGWXbyKCq+BzLqZOzV4W54pvU3wNTGLOOOZrnZ+hfX1ajIKasm
         Cm+GPnDIKgdIwUjm1sg2dXhXivmv4ATwlt+zRjyNVAyn+RFTctK3eQ7Y8sY59d1OzbtY
         eOPi6YZwTeJrokC6hZeTAKgYstiKsUvP+nS1mDmU7MrJIMd4OWSMjxr48T56R6+ceepY
         4BqJt/sZlNqQ1yGFtbwwYsw28t8tsxEYfxw6detM1yrg2frQPnnAizvkxCKlqBr7cG2C
         G/AAfEss1BBQZufZ1Y4ElxI0PFh4rzNc7Fabzm/vhLZMXoOmBcuv6T3cb8+W4CMv7eRy
         4qsw==
X-Gm-Message-State: AOAM5330JYSBlvBMYnZGsrVciIG5yR9X2s1w+hcXoYTT+kz2GWUyOb1C
        66kSMXno9/G/zty/aw47ECqqVQ2ZClSaTIBWQvgvTFwPt8Hz
X-Google-Smtp-Source: ABdhPJzyrBSScHlWo+w7h+qeqyzSKlMUXcfCmYreKwxaNcrXKWbKd5oPHnrsG3begxJwVpBBW3VS0IMYpqf9uW7PV4OCwcmbUxZq
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174a:: with SMTP id y10mr609378ill.121.1628928319198;
 Sat, 14 Aug 2021 01:05:19 -0700 (PDT)
Date:   Sat, 14 Aug 2021 01:05:19 -0700
In-Reply-To: <00000000000084943605c64a9cbd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d49b4e05c9806d11@google.com>
Subject: Re: [syzbot] general protection fault in rcu_segcblist_enqueue
From:   syzbot <syzbot+7590ddacf9f333c18f6c@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, bp@alien8.de, hpa@zytor.com, jack@suse.cz,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        paolo.valente@linaro.org, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    4b358aabb93a Add linux-next specific files for 20210813
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13fb40f9300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b99612666fbe2d6a
dashboard link: https://syzkaller.appspot.com/bug?extid=7590ddacf9f333c18f6c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12b34781300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10249f79300000

The issue was bisected to:

commit 71217df39dc67a0aeed83352b0d712b7892036a2
Author: Paolo Valente <paolo.valente@linaro.org>
Date:   Mon Jan 25 19:02:48 2021 +0000

    block, bfq: make waker-queue detection more robust

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127c2700300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=117c2700300000
console output: https://syzkaller.appspot.com/x/log.txt?x=167c2700300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7590ddacf9f333c18f6c@syzkaller.appspotmail.com
Fixes: 71217df39dc6 ("block, bfq: make waker-queue detection more robust")

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 8358 Comm: syz-executor858 Not tainted 5.14.0-rc5-next-20210813-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rcu_segcblist_enqueue+0xb9/0x130 kernel/rcu/rcu_segcblist.c:348
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 89 ea 48 c1 ea 03 <80> 3c 02 00 75 21 48 89 75 00 48 89 73 20 48 83 c4 08 5b 5d c3 48
RSP: 0018:ffffc90002d1fbe0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880b9c00080 RCX: ffffffff815b8cb0
RDX: 0000000000000000 RSI: ffffc90002d1fcc8 RDI: ffff8880b9c000a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff520005a3f6e R11: 0000000000000000 R12: ffffc90002d1fcc8
R13: ffff8880b9c00080 R14: 0000000000000000 R15: ffff8880b9c00040
FS:  00007f6a0b6c7700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d2700 CR3: 0000000073719000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 srcu_gp_start_if_needed+0x116/0xbc0 kernel/rcu/srcutree.c:823
 __call_srcu kernel/rcu/srcutree.c:883 [inline]
 __synchronize_srcu+0x21f/0x290 kernel/rcu/srcutree.c:929
 kvm_mmu_uninit_vm+0x18/0x30 arch/x86/kvm/mmu/mmu.c:5625
 kvm_arch_destroy_vm+0x4e7/0x680 arch/x86/kvm/x86.c:11317
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1075 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4548 [inline]
 kvm_dev_ioctl+0xfe6/0x1a40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4603
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x446a69
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6a0b6c7278 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004cb4d0 RCX: 0000000000446a69
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 00000000004cb4dc R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000049b2a8
R13: 00007f6a0b6c7280 R14: 6d766b2f7665642f R15: 00000000004cb4d8
Modules linked in:
---[ end trace 87a789ef23d34c4d ]---
RIP: 0010:rcu_segcblist_enqueue+0xb9/0x130 kernel/rcu/rcu_segcblist.c:348
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 89 ea 48 c1 ea 03 <80> 3c 02 00 75 21 48 89 75 00 48 89 73 20 48 83 c4 08 5b 5d c3 48
RSP: 0018:ffffc90002d1fbe0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880b9c00080 RCX: ffffffff815b8cb0
RDX: 0000000000000000 RSI: ffffc90002d1fcc8 RDI: ffff8880b9c000a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff520005a3f6e R11: 0000000000000000 R12: ffffc90002d1fcc8
R13: ffff8880b9c00080 R14: 0000000000000000 R15: ffff8880b9c00040
FS:  00007f6a0b6c7700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d2700 CR3: 0000000073719000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 7 bytes skipped:
   0:	df 48 89             	fisttps -0x77(%rax)
   3:	fa                   	cli    
   4:	48 c1 ea 03          	shr    $0x3,%rdx
   8:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   c:	75 4e                	jne    0x5c
   e:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  15:	fc ff df 
  18:	48 8b 6b 20          	mov    0x20(%rbx),%rbp
  1c:	48 89 ea             	mov    %rbp,%rdx
  1f:	48 c1 ea 03          	shr    $0x3,%rdx
  23:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  27:	75 21                	jne    0x4a
  29:	48 89 75 00          	mov    %rsi,0x0(%rbp)
  2d:	48 89 73 20          	mov    %rsi,0x20(%rbx)
  31:	48 83 c4 08          	add    $0x8,%rsp
  35:	5b                   	pop    %rbx
  36:	5d                   	pop    %rbp
  37:	c3                   	retq   
  38:	48                   	rex.W

