Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CE256322A
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 13:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiGALFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 07:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiGALFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 07:05:30 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F80804A1
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 04:05:29 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id l4-20020a056e021aa400b002dab8f7402dso1018605ilv.18
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 04:05:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=z5RdBJQHG68csQDp7gblrc3gvG+TNI2btP6vjR/yROQ=;
        b=t9r5gsW7cA7MQej6j0shQ80N/67d9HRj/Ll4eJ/0ffMS5q+XtGGR0CZdWO/v+LavCi
         dGoB+6z8vFf7G4Jez/6cBAcXi4ERcM0BnBvdBQ18n5+d3x/KMVCV+kAeImxqb9Epe33P
         HhjVVR1nVKfzVjlnFdU3oF6DOb9h4syXe55bhqoFP5U8eKA/c1pTpLpmTrAYrAGgBk0G
         Wb0vgPFcvH4A9V1dS09kxSdQTC5lJskQjXGZMcX1hxjcoyALI+QiRk+ncnOnMyOLAqJd
         rT6gt5qsIhaApLJI924kqTP4+2ZVFL4EsjfN9j2g905TBVKuhqRD7EB1rRLRP3867jrY
         55TA==
X-Gm-Message-State: AJIora93rZFRIXtlLEipdl6zAG7vX+kqeb+xyavrVC48JIGj7YPGjd1B
        k6KRF1ODwu8azSEDcf+QllZmlqEH964AXuHiKd139bw3XbeB
X-Google-Smtp-Source: AGRyM1vN6NdaoJ4FdCSTFfRgrMJr1jPuvYOhNnAF2hzvENLr4gVCmzr8iiPQBQxNHugB/sWGrKUh8/XBnfRsbU5E9efkAszcHieg
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1083:b0:2d9:2241:3e18 with SMTP id
 r3-20020a056e02108300b002d922413e18mr8096330ilj.93.1656673528681; Fri, 01 Jul
 2022 04:05:28 -0700 (PDT)
Date:   Fri, 01 Jul 2022 04:05:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002f9d9c05e2bc5d8a@google.com>
Subject: [syzbot] general protection fault in kvm_arch_vcpu_ioctl
From:   syzbot <syzbot+8cdad6430c24f396f158@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    aab35c3d5112 Add linux-next specific files for 20220627
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=129388e0080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a874f114a1e4a6b
dashboard link: https://syzkaller.appspot.com/bug?extid=8cdad6430c24f396f158
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10840388080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15793588080000

Bisection is inconclusive: the first bad commit could be any of:

987f625e0799 KVM: x86: Add APIC_LVTx() macro.
4b903561ec49 KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1395cb88080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8cdad6430c24f396f158@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
general protection fault, probably for non-canonical address 0xdffffc000000001d: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000e8-0x00000000000000ef]
CPU: 0 PID: 3601 Comm: syz-executor163 Not tainted 5.19.0-rc4-next-20220627-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvm_vcpu_ioctl_x86_setup_mce arch/x86/kvm/x86.c:4899 [inline]
RIP: 0010:kvm_arch_vcpu_ioctl+0x10d1/0x3d40 arch/x86/kvm/x86.c:5608
Code: 80 3c 02 00 0f 85 91 28 00 00 4d 8b ac 24 b0 02 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bd ec 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 62
RSP: 0018:ffffc90002eaf960 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: 0000000000000006 RCX: 0000000000000000
RDX: 000000000000001d RSI: ffffffff8110c6ee RDI: 00000000000000ec
RBP: ffffc90002eafd20 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff1fc765f R12: ffff888078e10000
R13: 0000000000000000 R14: 1ffff920005d5f36 R15: dffffc0000000000
FS:  0000555556de0300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc02f8affb8 CR3: 0000000075d2c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_vcpu_ioctl+0x973/0xf30 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4200
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fc02f868b69
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcc8febd88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc02f868b69
RDX: 0000000020000040 RSI: 000000004008ae9c RDI: 0000000000000005
RBP: 00007fc02f82cd10 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fc02f82cda0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:kvm_vcpu_ioctl_x86_setup_mce arch/x86/kvm/x86.c:4899 [inline]
RIP: 0010:kvm_arch_vcpu_ioctl+0x10d1/0x3d40 arch/x86/kvm/x86.c:5608
Code: 80 3c 02 00 0f 85 91 28 00 00 4d 8b ac 24 b0 02 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bd ec 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 62
RSP: 0018:ffffc90002eaf960 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: 0000000000000006 RCX: 0000000000000000
RDX: 000000000000001d RSI: ffffffff8110c6ee RDI: 00000000000000ec
RBP: ffffc90002eafd20 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff1fc765f R12: ffff888078e10000
R13: 0000000000000000 R14: 1ffff920005d5f36 R15: dffffc0000000000
FS:  0000555556de0300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056206923aa70 CR3: 0000000075d2c000 CR4: 00000000003526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   4:	0f 85 91 28 00 00    	jne    0x289b
   a:	4d 8b ac 24 b0 02 00 	mov    0x2b0(%r12),%r13
  11:	00
  12:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  19:	fc ff df
  1c:	49 8d bd ec 00 00 00 	lea    0xec(%r13),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx <-- trapping instruction
  2e:	48 89 f8             	mov    %rdi,%rax
  31:	83 e0 07             	and    $0x7,%eax
  34:	83 c0 03             	add    $0x3,%eax
  37:	38 d0                	cmp    %dl,%al
  39:	7c 08                	jl     0x43
  3b:	84 d2                	test   %dl,%dl
  3d:	0f                   	.byte 0xf
  3e:	85                   	.byte 0x85
  3f:	62                   	.byte 0x62


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
