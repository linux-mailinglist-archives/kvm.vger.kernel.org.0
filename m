Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F2350C973
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 12:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiDWK7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Apr 2022 06:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiDWK7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Apr 2022 06:59:19 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FAF391
        for <kvm@vger.kernel.org>; Sat, 23 Apr 2022 03:56:21 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso7349572ioo.13
        for <kvm@vger.kernel.org>; Sat, 23 Apr 2022 03:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4ZC6JurtOjiWgIN9rlfDIfJmEZpcHUsletaGslS+hg8=;
        b=yCZINPFe+U3drNlZp8JUHzIl0OLB/Ast6ql7MKVsJQHSn6l8F1hrgrYsgnqTGgdFck
         7R1qoMr/YxdCsyE8X2dQIgKNCbbWMB50ivzHX7qKZTVEhJ9qmW0z1PmQ3cD70hvvxJmz
         LMvC0jc6+hjJFZE2JqlQ17gLbh8oLJHmYg+OR5S1/Twr1VUiSZ9T2LSQvdFTGBanpHmd
         L8cZOBCUXXapie5MKaTuZ6bKWwj15AEPIWJvW5JknZql9ieX1wWWxemLkDxXn5qAgSk7
         ulDy+RhJkmWx6HHrFV2t1VSVsLlJBjkPXZdT6cw8tUp7/SD3V49nDQ98JeS8Umag2cMA
         b3+Q==
X-Gm-Message-State: AOAM533HJj+ceiyJI2F39qeKeDT/ocTVnKsV80vDXxS2NoyvYQhPFNO5
        CCXcNPyE9xRo3HvjB/EOAK26vSYuwfOMUK5uV4zFXoUzG2vf
X-Google-Smtp-Source: ABdhPJwH+Ju16HpN/76ava733ey+RNkvdy90QfhZclJDv5RWeWtPVxXi71kYagFRzFnBojUZIXuH67I/DOsb1rUDFbqKJm9WbqEx
MIME-Version: 1.0
X-Received: by 2002:a05:6638:481a:b0:326:6a2c:2396 with SMTP id
 cp26-20020a056638481a00b003266a2c2396mr3785189jab.122.1650711381294; Sat, 23
 Apr 2022 03:56:21 -0700 (PDT)
Date:   Sat, 23 Apr 2022 03:56:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000082452505dd503126@google.com>
Subject: [syzbot] WARNING in kvm_mmu_uninit_tdp_mmu (2)
From:   syzbot <syzbot+a8ad3ee1525a0c4b40ec@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    59f0c2447e25 Merge tag 'net-5.18-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15a61430f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bc13fa21dd76a9b
dashboard link: https://syzkaller.appspot.com/bug?extid=a8ad3ee1525a0c4b40ec
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134363d0f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ed3e34f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a8ad3ee1525a0c4b40ec@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3597 at arch/x86/kvm/mmu/tdp_mmu.c:57 kvm_mmu_uninit_tdp_mmu+0xf8/0x130 arch/x86/kvm/mmu/tdp_mmu.c:57
Modules linked in:
CPU: 1 PID: 3597 Comm: syz-executor294 Not tainted 5.18.0-rc3-syzkaller-00060-g59f0c2447e25 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:kvm_mmu_uninit_tdp_mmu+0xf8/0x130 arch/x86/kvm/mmu/tdp_mmu.c:57
Code: 83 d8 a0 00 00 48 39 c5 75 24 e8 e3 4d 5a 00 e8 9e e0 45 00 5b 5d e9 d7 4d 5a 00 e8 b2 42 a5 00 e9 3d ff ff ff e8 c8 4d 5a 00 <0f> 0b eb ad e8 bf 4d 5a 00 0f 0b eb d3 e8 c6 42 a5 00 e9 64 ff ff
RSP: 0018:ffffc90002e37c08 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc90002cda000 RCX: 0000000000000000
RDX: ffff888023f1e180 RSI: ffffffff811e1688 RDI: 0000000000000001
RBP: ffffc90002ce40e8 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817ead48 R11: 0000000000000000 R12: ffffc90002cda000
R13: ffffc90002e37c50 R14: 0000000000000003 R15: ffffc90002cdb240
FS:  0000000000000000(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560ac4d0cd68 CR3: 000000000ba8e000 CR4: 0000000000152ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_arch_destroy_vm+0x350/0x470 arch/x86/kvm/x86.c:11860
 kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1230 [inline]
 kvm_put_kvm+0x4fa/0xb70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1264
 kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1287
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:37 [inline]
 do_exit+0xaff/0x2a00 kernel/exit.c:795
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f0327505409
Code: Unable to access opcode bytes at RIP 0x7f03275053df.
RSP: 002b:00007ffc4a0be998 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f0327578350 RCX: 00007f0327505409
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 68742f636f72702f
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f0327578350
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
