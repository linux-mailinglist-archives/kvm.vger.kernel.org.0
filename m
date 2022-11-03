Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39686174AA
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiKCC6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKCC6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:58:40 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E9313FB2
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 19:58:39 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id w16-20020a6b4a10000000b006a5454c789eso284626iob.20
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 19:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sL5eEqpqsj3L6/i5wWPNiCL2KlnJXhfZkRVBWGmMBmE=;
        b=gOU7vngkDaUPCR+qFgWNDP/lVe02ymwSgEAasvnVaLyTFdQ7eUEkRs+0aG2ZyYqGRS
         9ClaiXeLni9zOeG6pt90MYymO+IIgc7p5h67sXl7LqXpSg60lC5CfjzKZLS+Lf+nchNJ
         7J52YjlbotFLVy9BoX9+vXaV2BUkHQj81rEH4uHKylwP2OQSC7FVYtG1Dw54DR/cJCNB
         2DVfcJofje/35xF6yPghXIKTqAFP58nMXu2/txeA98utMqhP8NEqW9SXQ3U6lu6ZF0aF
         nnFZqfJ4oYrZbudZIy2ifz5jE7Ub0fMlz0IacfH6Jr2vIvuuGU7MHt12KYY8TohSCQ0t
         ACjw==
X-Gm-Message-State: ACrzQf3oT7g49QPw3ZHL5Fo/88AfASic8sLkHuU+krjfSxgurHjE5onJ
        LoOoo+4xd6uqEItDvDGwidAeKH/4NtX88F2oRq+svhsHtviN
X-Google-Smtp-Source: AMsMyM7akPKhYuki0KeArMITl5oRpEd1aQDUG/CAcjqNDqnZyvXKHUxz+uJK9W5973oVMfw7PiEWjiRZurwwmbLKUy3Vx4p+c5Cv
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d94:b0:300:229:d9e8 with SMTP id
 h20-20020a056e021d9400b003000229d9e8mr16662349ila.66.1667444318739; Wed, 02
 Nov 2022 19:58:38 -0700 (PDT)
Date:   Wed, 02 Nov 2022 19:58:38 -0700
In-Reply-To: <000000000000a4496905ec7f35b7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004d244705ec88228c@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in vmx_handle_exit_irqoff
From:   syzbot <syzbot+8cdd16fd5a6c0565e227@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    61c3426aca2c Add linux-next specific files for 20221102
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13596541880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acb529cc910d907c
dashboard link: https://syzkaller.appspot.com/bug?extid=8cdd16fd5a6c0565e227
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d036de880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d5e00a880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cc56d88dd6a3/disk-61c3426a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5921b65b080f/vmlinux-61c3426a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/39cbd355fedd/bzImage-61c3426a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8cdd16fd5a6c0565e227@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: fffffbc0000001d8
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 23ffe4067 P4D 23ffe4067 PUD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5404 Comm: syz-executor526 Not tainted 6.1.0-rc3-next-20221102-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:gate_offset arch/x86/include/asm/desc_defs.h:100 [inline]
RIP: 0010:handle_external_interrupt_irqoff arch/x86/kvm/vmx/vmx.c:6818 [inline]
RIP: 0010:vmx_handle_exit_irqoff arch/x86/kvm/vmx/vmx.c:6830 [inline]
RIP: 0010:vmx_handle_exit_irqoff+0x334/0x750 arch/x86/kvm/vmx/vmx.c:6822
Code: 00 01 be 01 03 00 00 48 89 ef e8 27 a4 e8 ff e9 96 fd ff ff e8 9d 3d 5c 00 48 89 e8 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 <0f> b6 0c 10 48 8d 45 01 48 89 c6 48 c1 ee 03 0f b6 14 16 48 89 ee
RSP: 0018:ffffc90004217b38 EFLAGS: 00010806
RAX: 1fffffc0000001d8 RBX: ffff88801f964000 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: ffffffff8120a3b3 RDI: 0000000000000005
RBP: fffffe0000000ec0 R08: 0000000000000005 R09: 0000000080000000
R10: 0000000080000000 R11: 0000000000000000 R12: 00000000800000ec
R13: 0000000080000000 R14: 000000000121e226 R15: ffff88801f964038
FS:  0000555555e9c3c0(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbc0000001d8 CR3: 00000000213a8000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vcpu_enter_guest+0x33d1/0x59e0 arch/x86/kvm/x86.c:10815
 vcpu_run arch/x86/kvm/x86.c:10964 [inline]
 kvm_arch_vcpu_ioctl_run+0xa80/0x2b90 arch/x86/kvm/x86.c:11185
 kvm_vcpu_ioctl+0x570/0xfc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4065
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fb696cd1f89
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd0f7a3e18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffd0f7a3e50 RCX: 00007fb696cd1f89
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000d3e4
R10: 00007ffd0f7a3e20 R11: 0000000000000246 R12: 00000000000f4240
R13: 000000000000d3e4 R14: 00007ffd0f7a3e3c R15: 00007ffd0f7a3e40
 </TASK>
Modules linked in:
CR2: fffffbc0000001d8
---[ end trace 0000000000000000 ]---
RIP: 0010:gate_offset arch/x86/include/asm/desc_defs.h:100 [inline]
RIP: 0010:handle_external_interrupt_irqoff arch/x86/kvm/vmx/vmx.c:6818 [inline]
RIP: 0010:vmx_handle_exit_irqoff arch/x86/kvm/vmx/vmx.c:6830 [inline]
RIP: 0010:vmx_handle_exit_irqoff+0x334/0x750 arch/x86/kvm/vmx/vmx.c:6822
Code: 00 01 be 01 03 00 00 48 89 ef e8 27 a4 e8 ff e9 96 fd ff ff e8 9d 3d 5c 00 48 89 e8 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 <0f> b6 0c 10 48 8d 45 01 48 89 c6 48 c1 ee 03 0f b6 14 16 48 89 ee
RSP: 0018:ffffc90004217b38 EFLAGS: 00010806
RAX: 1fffffc0000001d8 RBX: ffff88801f964000 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: ffffffff8120a3b3 RDI: 0000000000000005
RBP: fffffe0000000ec0 R08: 0000000000000005 R09: 0000000080000000
R10: 0000000080000000 R11: 0000000000000000 R12: 00000000800000ec
R13: 0000000080000000 R14: 000000000121e226 R15: ffff88801f964038
FS:  0000555555e9c3c0(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbc0000001d8 CR3: 00000000213a8000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 01                	add    %al,(%rcx)
   2:	be 01 03 00 00       	mov    $0x301,%esi
   7:	48 89 ef             	mov    %rbp,%rdi
   a:	e8 27 a4 e8 ff       	callq  0xffe8a436
   f:	e9 96 fd ff ff       	jmpq   0xfffffdaa
  14:	e8 9d 3d 5c 00       	callq  0x5c3db6
  19:	48 89 e8             	mov    %rbp,%rax
  1c:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  23:	fc ff df
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 0c 10          	movzbl (%rax,%rdx,1),%ecx <-- trapping instruction
  2e:	48 8d 45 01          	lea    0x1(%rbp),%rax
  32:	48 89 c6             	mov    %rax,%rsi
  35:	48 c1 ee 03          	shr    $0x3,%rsi
  39:	0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
  3d:	48 89 ee             	mov    %rbp,%rsi

