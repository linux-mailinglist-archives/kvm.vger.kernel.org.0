Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538FE6EB22C
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 21:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbjDUTQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 15:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjDUTQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 15:16:50 -0400
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990FC172C
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 12:16:48 -0700 (PDT)
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-32addcf3a73so88437405ab.0
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 12:16:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682104608; x=1684696608;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QxtOVbkNxSHHb3brNs8tJk7Ry7nocLpql9jiJZVqGeM=;
        b=PW+JZeydo529BJmejUeR/vO2Yp2jpXqWRDHBqom0ylZJPRJUbHendDiveA0ycXnHv1
         eY9MpqA7TjjEoEmAMhgXhu7ebsau+T0Y3ydQJYrlW80uRzLQfsLAMspDJAZ2hy9WrP6V
         ctAfxpRkLRQsiADjEzXkXp+qVQDVrraY4qN3jM2OjBLZwn8g4wDMqMR3HBPP/xNoG3M4
         XUq+i7J0ufRItoDB6W7cRtmcZz1+ELhH9dikUnqYTq/lW4mhIKRm0xs33CJaNzpaxfKR
         TP5lRe8EtWwY8Go2wY2jE9xhS0czEEQGWtWuUliO0sZEA+5rC3i1M2WA2wjB8ZuAJ/vk
         JPmA==
X-Gm-Message-State: AAQBX9cvHWs7qf9veQM4GmFqSJoB1Ve1IuU2zx6y9pT0iUmFnejULiI0
        mhRZgjisY+KDCtUWcJGcmhqDn2NKVjtfnFdMWyhg7R1GkTBX
X-Google-Smtp-Source: AKy350b94zy4qEncxn7krhtVj+JkC0j3IV5KMCRSJLxww+6OGm++UjRnppSHMo7ysbSNgNTWGFUkAtZsXOwFWTDM/Qt5K1Qxv1e7
MIME-Version: 1.0
X-Received: by 2002:a92:d344:0:b0:32c:b806:d4a3 with SMTP id
 a4-20020a92d344000000b0032cb806d4a3mr7131ilh.1.1682104607880; Fri, 21 Apr
 2023 12:16:47 -0700 (PDT)
Date:   Fri, 21 Apr 2023 12:16:47 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0bc2b05f9dd7fab@google.com>
Subject: [syzbot] [kvm?] WARNING in kvm_tdp_mmu_invalidate_all_roots
From:   syzbot <syzbot+094a74444165dbcd3a54@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d3e1ee0e67e7 Add linux-next specific files for 20230421
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16ac3de0280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53c789efbcc06cf6
dashboard link: https://syzkaller.appspot.com/bug?extid=094a74444165dbcd3a54
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c558a9e1fe6a/disk-d3e1ee0e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2ec100a34c4c/vmlinux-d3e1ee0e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1afcd9936dc1/bzImage-d3e1ee0e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+094a74444165dbcd3a54@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 12623 at arch/x86/kvm/mmu/tdp_mmu.c:943 kvm_tdp_mmu_invalidate_all_roots+0x2bd/0x370 arch/x86/kvm/mmu/tdp_mmu.c:943
Modules linked in:
CPU: 0 PID: 12623 Comm: syz-executor.3 Not tainted 6.3.0-rc7-next-20230421-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
RIP: 0010:kvm_tdp_mmu_invalidate_all_roots+0x2bd/0x370 arch/x86/kvm/mmu/tdp_mmu.c:943
Code: 00 e8 a7 67 64 00 49 8d 7c 24 18 31 f6 e8 eb 23 ec 08 31 ff 89 c3 89 c6 e8 b0 63 64 00 85 db 0f 85 00 fe ff ff e8 83 67 64 00 <0f> 0b e9 f4 fd ff ff 48 89 ef e8 94 46 b7 00 e9 88 fd ff ff e8 4a
RSP: 0018:ffffc90005f7fc80 EFLAGS: 00010212
RAX: 0000000000015eaf RBX: 0000000000000000 RCX: ffffc9000e5cd000
RDX: 0000000000040000 RSI: ffffffff811f7dcd RDI: 0000000000000005
RBP: ffffc900062ba788 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc900062b1000
R13: 0000000000000000 R14: 0000000000000006 R15: ffffc900062b19d8
FS:  00007f9c99c7c700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa626bad988 CR3: 000000001cd68000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_mmu_uninit_tdp_mmu+0x16/0x100 arch/x86/kvm/mmu/tdp_mmu.c:48
 kvm_mmu_uninit_vm+0x6a/0x70 arch/x86/kvm/mmu/mmu.c:6239
 kvm_arch_destroy_vm+0x369/0x490 arch/x86/kvm/x86.c:12465
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1245 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:5017 [inline]
 kvm_dev_ioctl+0x11be/0x1bb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:5059
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f9c98e8c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9c99c7c168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f9c98fac120 RCX: 00007f9c98e8c169
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000005
RBP: 00007f9c98ee7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff0f7a772f R14: 00007f9c99c7c300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
