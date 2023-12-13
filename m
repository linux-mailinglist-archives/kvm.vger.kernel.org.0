Return-Path: <kvm+bounces-4373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72EB4811B01
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B67F21F21AA5
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE7456B8E;
	Wed, 13 Dec 2023 17:30:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C8EF3
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:30:30 -0800 (PST)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-286e0d3e04dso8016484a91.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:30:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702488629; x=1703093429;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1dpYLkiR+l008P7TYyOS0e8q6Tq1gDi6UOb+kiDBW3g=;
        b=SEqc5GMKQEY2K5IMoDCppyV86H5gcTKfXj5P/Qpxp81ni+DlpfT6y5DyHotB8Cx/4e
         J1q5wABuerN+ecD3GyIwBm+00EV2WRqDiiPedJBrKtu8HjCBPKpZtrC89wwsYcA6rSHD
         wVlb+3XAqFYgRgv/15NKLq8nabWlEFZ9hRg0VZ2pHp8nnSXDO3cOEbbgHAX5s+I7/ZFY
         PuR8IIp4+RylyYbhHOWQlH1w8lur8AvKeTsgXqlGg2yi4XQNgV7fqVBfUyFgA9BXoCcw
         rpOm4g1XrUEOofrGiAa10H8l3FwcsWnfZ7dzQ7H6pAbnddDI3QqzoxW7i07bfLj2kLBV
         ZmEQ==
X-Gm-Message-State: AOJu0YyKZCnK9ng6jaYIOz41U5SAEy8Z/BXGHX+1FKlaHFzvaDW7PvmC
	Y8wlVy3PQkYHb6TU+dDnFqJJUFAvWoqV0A51LFfSw5wMJcGjA7M=
X-Google-Smtp-Source: AGHT+IGGlcFdvOZMy8ytduClUq+H57gGxIs2VmGRyblig5KQXMchAWKjYR4Lqeut3qf8ttNtryccMYl8+8hB1JNLvwDJT7GPcZbh
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a17:90a:bb18:b0:28a:abe8:f0e5 with SMTP id
 u24-20020a17090abb1800b0028aabe8f0e5mr349385pjr.0.1702488628971; Wed, 13 Dec
 2023 09:30:28 -0800 (PST)
Date: Wed, 13 Dec 2023 09:30:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6d051060c6785bc@google.com>
Subject: [syzbot] [kvm?] WARNING in kvm_mmu_notifier_change_pte
From: syzbot <syzbot+81227d2bd69e9dedb802@syzkaller.appspotmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f2e8a57ee903 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14fdc732e80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e56083f7dbe162c2
dashboard link: https://syzkaller.appspot.com/bug?extid=81227d2bd69e9dedb802
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129d09cae80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b8afeee80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7b75e59fc59d/disk-f2e8a57e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f853580d61be/vmlinux-f2e8a57e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8c893ce02e2c/bzImage-f2e8a57e.xz

Bisection is inconclusive: the first bad commit could be any of:

d61ea1cb0095 userfaultfd: UFFD_FEATURE_WP_ASYNC
52526ca7fdb9 fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=120b3bdae80000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81227d2bd69e9dedb802@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5067 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:734 kvm_mmu_notifier_change_pte+0x860/0x960 arch/x86/kvm/../../../virt/kvm/kvm_main.c:734
Modules linked in:
CPU: 0 PID: 5067 Comm: syz-executor813 Not tainted 6.7.0-rc4-syzkaller-00358-gf2e8a57ee903 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/10/2023
RIP: 0010:kvm_mmu_notifier_change_pte+0x860/0x960 arch/x86/kvm/../../../virt/kvm/kvm_main.c:734
Code: c7 80 16 c2 8a c6 05 61 3e f9 0d 01 e8 29 80 5d 00 e9 80 fa ff ff e8 8f 93 7d 00 90 0f 0b 90 e9 c0 fd ff ff e8 81 93 7d 00 90 <0f> 0b 90 e9 0f f9 ff ff e8 73 93 7d 00 90 0f 0b 90 e9 76 f8 ff ff
RSP: 0018:ffffc900040e73a0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000020537000 RCX: ffffffff8109f33e
RDX: ffff888016fd9dc0 RSI: ffffffff8109fa2f RDI: 0000000000000007
RBP: 0000000000000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000003 R12: ffff88801afd5f00
R13: 0000000020537000 R14: 0000000076630867 R15: ffffffff8109f1d0
FS:  00007f62e85146c0(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020537000 CR3: 00000000288fa000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __mmu_notifier_change_pte+0x10d/0x1d0 mm/mmu_notifier.c:438
 mmu_notifier_change_pte include/linux/mmu_notifier.h:446 [inline]
 wp_page_copy mm/memory.c:3197 [inline]
 do_wp_page+0x26a7/0x36b0 mm/memory.c:3511
 handle_pte_fault mm/memory.c:5055 [inline]
 __handle_mm_fault+0x1d7d/0x3d70 mm/memory.c:5180
 handle_mm_fault+0x47a/0xa10 mm/memory.c:5345
 do_user_addr_fault+0x3d1/0x1000 arch/x86/mm/fault.c:1413
 handle_page_fault arch/x86/mm/fault.c:1505 [inline]
 exc_page_fault+0x5d/0xc0 arch/x86/mm/fault.c:1561
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:570
RIP: 0010:rep_movs_alternative+0x4a/0x70 arch/x86/lib/copy_user_64.S:71
Code: 75 f1 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8b 06 48 89 07 48 83 c6 08 48 83 c7 08 83 e9 08 74 df 83 f9 08 73 e8 eb c9 <f3> a4 c3 48 89 c8 48 c1 e9 03 83 e0 07 f3 48 a5 89 c1 85 c9 75 b3
RSP: 0018:ffffc900040e7968 EFLAGS: 00050206
RAX: 0000000000000001 RBX: 0000000000001000 RCX: 0000000000000e80
RDX: 0000000000000000 RSI: ffff888010b22180 RDI: 0000000020537000
RBP: 0000000000001000 R08: 0000000000000000 R09: ffffed10021645ff
R10: ffff888010b22fff R11: 0000000000000000 R12: 0000000000536b80
R13: ffffc900040e7d60 R14: ffff888010b22000 R15: 0000000020536e80
 copy_user_generic arch/x86/include/asm/uaccess_64.h:112 [inline]
 raw_copy_to_user arch/x86/include/asm/uaccess_64.h:133 [inline]
 copy_to_user_iter lib/iov_iter.c:25 [inline]
 iterate_iovec include/linux/iov_iter.h:51 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:247 [inline]
 iterate_and_advance include/linux/iov_iter.h:271 [inline]
 _copy_to_iter+0x4ce/0x11e0 lib/iov_iter.c:186
 copy_page_to_iter lib/iov_iter.c:381 [inline]
 copy_page_to_iter+0xf1/0x180 lib/iov_iter.c:368
 process_vm_rw_pages mm/process_vm_access.c:45 [inline]
 process_vm_rw_single_vec mm/process_vm_access.c:117 [inline]
 process_vm_rw_core.constprop.0+0x5cd/0xa10 mm/process_vm_access.c:215
 process_vm_rw+0x2ff/0x360 mm/process_vm_access.c:283
 __do_sys_process_vm_readv mm/process_vm_access.c:295 [inline]
 __se_sys_process_vm_readv mm/process_vm_access.c:291 [inline]
 __x64_sys_process_vm_readv+0xe2/0x1b0 mm/process_vm_access.c:291
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x40/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b
RIP: 0033:0x7f62e855c889
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 1d 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f62e85140c8 EFLAGS: 00000216 ORIG_RAX: 0000000000000136
RAX: ffffffffffffffda RBX: 00007f62e85df3e8 RCX: 00007f62e855c889
RDX: 0000000000000002 RSI: 0000000020008400 RDI: 00000000000013ca
RBP: 00007f62e85df3e0 R08: 0000000000000286 R09: 0000000000000000
R10: 0000000020008640 R11: 0000000000000216 R12: 00007f62e85df3ec
R13: 0000000000000000 R14: 00007ffd42ee6360 R15: 00007ffd42ee6448
 </TASK>
----------------
Code disassembly (best guess):
   0:	75 f1                	jne    0xfffffff3
   2:	c3                   	ret
   3:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   a:	00 00 00 00
   e:	66 90                	xchg   %ax,%ax
  10:	48 8b 06             	mov    (%rsi),%rax
  13:	48 89 07             	mov    %rax,(%rdi)
  16:	48 83 c6 08          	add    $0x8,%rsi
  1a:	48 83 c7 08          	add    $0x8,%rdi
  1e:	83 e9 08             	sub    $0x8,%ecx
  21:	74 df                	je     0x2
  23:	83 f9 08             	cmp    $0x8,%ecx
  26:	73 e8                	jae    0x10
  28:	eb c9                	jmp    0xfffffff3
* 2a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi) <-- trapping instruction
  2c:	c3                   	ret
  2d:	48 89 c8             	mov    %rcx,%rax
  30:	48 c1 e9 03          	shr    $0x3,%rcx
  34:	83 e0 07             	and    $0x7,%eax
  37:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  3a:	89 c1                	mov    %eax,%ecx
  3c:	85 c9                	test   %ecx,%ecx
  3e:	75 b3                	jne    0xfffffff3


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

