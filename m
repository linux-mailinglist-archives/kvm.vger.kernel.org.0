Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851096168B0
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbiKBQZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbiKBQYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:24:34 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B615FAB
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:19:49 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id 14-20020a05660220ce00b006c1bdc8ef72so14637412ioz.23
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WuSpMg6jpkSc98wDnd1IFQKREWSr/w4x6W3idg3S90w=;
        b=LsbFHt8ew+LbkzLeR/drsZCFA9WqHhSummexjPnarnvL/FaUSIMuKWU7g3l6zMmhQB
         IWhSutd00tJHlZ/E6p/7W6BKFEf7LQe42nk9oSvcn3VtMxiiAz7qQm3QSEQKTxIlAakr
         Rw9Eq9+9E+Wp1ZY2LlwHaPJavnn1ovB9uKk+rSFG4Hg2gc1c1hqYJNw2UxBcGfF9fXop
         cE2batWEQgUJHW6t8gI4OPONfcE/uxG8/Pav9W/LQxBfrLC7rso7aqI36nPkCIzi5HM0
         X/jx9JWaiU13rRBX197Ux+LS9yMHKvUpuZ00N4IrayfANlBFl5mqAN32YVEdCWqMmToo
         fQuw==
X-Gm-Message-State: ACrzQf0bhRAZas3XdwbdeQ4xq4Lal2fnvrOZA4T3h8skrqyIkXHjEAkN
        XLDTtKlxGSnpyvgqr9hmWVzYymmERd4PgV6FnGGVEWFnCkHL
X-Google-Smtp-Source: AMsMyM62P8DExrr3vduoVun5da4oeuWTM1WY1lHqwKQS3qoKYtsNBk1NKJRUldNCSgK0JuFEA95WrPuYBa1SINXO7p+YyIpzpm3h
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:be3:b0:300:c33d:4ad7 with SMTP id
 d3-20020a056e020be300b00300c33d4ad7mr6499696ilu.150.1667405988511; Wed, 02
 Nov 2022 09:19:48 -0700 (PDT)
Date:   Wed, 02 Nov 2022 09:19:48 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a4496905ec7f35b7@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in vmx_handle_exit_irqoff
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

Hello,

syzbot found the following issue on:

HEAD commit:    61c3426aca2c Add linux-next specific files for 20221102
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1238c561880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acb529cc910d907c
dashboard link: https://syzkaller.appspot.com/bug?extid=8cdd16fd5a6c0565e227
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

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
CPU: 0 PID: 5970 Comm: syz-executor.4 Not tainted 6.1.0-rc3-next-20221102-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:gate_offset arch/x86/include/asm/desc_defs.h:100 [inline]
RIP: 0010:handle_external_interrupt_irqoff arch/x86/kvm/vmx/vmx.c:6818 [inline]
RIP: 0010:vmx_handle_exit_irqoff arch/x86/kvm/vmx/vmx.c:6830 [inline]
RIP: 0010:vmx_handle_exit_irqoff+0x334/0x750 arch/x86/kvm/vmx/vmx.c:6822
Code: 00 01 be 01 03 00 00 48 89 ef e8 27 a4 e8 ff e9 96 fd ff ff e8 9d 3d 5c 00 48 89 e8 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 <0f> b6 0c 10 48 8d 45 01 48 89 c6 48 c1 ee 03 0f b6 14 16 48 89 ee
RSP: 0018:ffffc90005667b38 EFLAGS: 00010806
RAX: 1fffffc0000001d8 RBX: ffff88804eabc000 RCX: ffffc9000a923000
RDX: dffffc0000000000 RSI: ffffffff8120a3b3 RDI: 0000000000000005
RBP: fffffe0000000ec0 R08: 0000000000000005 R09: 0000000080000000
R10: 0000000080000000 R11: 0000000000000000 R12: 00000000800000ec
R13: 0000000080000000 R14: 00000000142ec3c6 R15: ffff88804eabc038
FS:  00007f1a62148700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbc0000001d8 CR3: 0000000025903000 CR4: 00000000003526f0
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
RIP: 0033:0x7f1a6148b5a9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1a62148168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f1a615abf80 RCX: 00007f1a6148b5a9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f1a614e67b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffcaaf540cf R14: 00007f1a62148300 R15: 0000000000022000
 </TASK>
Modules linked in:
CR2: fffffbc0000001d8
---[ end trace 0000000000000000 ]---
RIP: 0010:gate_offset arch/x86/include/asm/desc_defs.h:100 [inline]
RIP: 0010:handle_external_interrupt_irqoff arch/x86/kvm/vmx/vmx.c:6818 [inline]
RIP: 0010:vmx_handle_exit_irqoff arch/x86/kvm/vmx/vmx.c:6830 [inline]
RIP: 0010:vmx_handle_exit_irqoff+0x334/0x750 arch/x86/kvm/vmx/vmx.c:6822
Code: 00 01 be 01 03 00 00 48 89 ef e8 27 a4 e8 ff e9 96 fd ff ff e8 9d 3d 5c 00 48 89 e8 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 <0f> b6 0c 10 48 8d 45 01 48 89 c6 48 c1 ee 03 0f b6 14 16 48 89 ee
RSP: 0018:ffffc90005667b38 EFLAGS: 00010806
RAX: 1fffffc0000001d8 RBX: ffff88804eabc000 RCX: ffffc9000a923000
RDX: dffffc0000000000 RSI: ffffffff8120a3b3 RDI: 0000000000000005
RBP: fffffe0000000ec0 R08: 0000000000000005 R09: 0000000080000000
R10: 0000000080000000 R11: 0000000000000000 R12: 00000000800000ec
R13: 0000000080000000 R14: 00000000142ec3c6 R15: ffff88804eabc038
FS:  00007f1a62148700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbc0000001d8 CR3: 0000000025903000 CR4: 00000000003526f0
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


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
