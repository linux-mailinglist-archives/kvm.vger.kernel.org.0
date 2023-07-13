Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563AA751889
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 08:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbjGMGHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 02:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjGMGHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 02:07:31 -0400
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1891BC6
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 23:07:29 -0700 (PDT)
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-560fba06e7eso647564eaf.3
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 23:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689228449; x=1691820449;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ym4Wk39RoN+n/NCXheA5gg8womnq4gmFrZ2biI2hyGg=;
        b=gz/mmvZ6xYlFXNgg6bwUCYLFqe1hkftzfhmbgbQe3NQNZnbJ9DPcBnWtnuLFMP1NKE
         aA4KN3Di0s4RoH1PQWZaqnzNE1f8ORLzDX1IEGp62SnLKRMQ3RHxUZuEpsEpbAPns9H+
         Vzw/IJoEFrbmKuhUNqN3higaTY6fk087RaRCH59Jj7uuLqkiA8Cy8zu35wtaWEaar9rF
         L1zJOYVaeHKdqf6cCD5LZO2ozNPgqTzdG6NJYx9shl6MRxJZYF/fBFqStCyurMDPK6sH
         9yqh1f7pqkVSgxfgpyDa2bd7AVkHX4GH8HWV0++2RDT1ztpRGLRQ6U+kQ5zpcVz3rcdE
         0Ixw==
X-Gm-Message-State: ABy/qLaXauHF9M0/xSw0djR1huQQNH8wjyqZ4EIyG6NZnHMHh8CJhwvq
        L60rSB198D4t8WBRiz+iKwmbmt5SG19F/Fn0RZ3UncCbNIuS
X-Google-Smtp-Source: APBJJlGolIXkPkhx6uLxab7k5qmejxJ0G6h3kGEEo22nHCEhAVhfiKj+4qIpnz96geK0e30ymQ8neh+JBu/Ex7+k8cdx70T0oliE
MIME-Version: 1.0
X-Received: by 2002:a05:6870:5b35:b0:1b0:6bf2:f039 with SMTP id
 ds53-20020a0568705b3500b001b06bf2f039mr886366oab.7.1689228448967; Wed, 12 Jul
 2023 23:07:28 -0700 (PDT)
Date:   Wed, 12 Jul 2023 23:07:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a531410600582572@google.com>
Subject: [syzbot] [kvm?] WARNING in __load_segment_descriptor
From:   syzbot <syzbot+5234e75fb68b86fe89e3@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1c7873e33645 mm: lock newly mapped VMA with corrected orde..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=106f1664a80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7ad417033279f15a
dashboard link: https://syzkaller.appspot.com/bug?extid=5234e75fb68b86fe89e3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146864a8a80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134a32bca80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7eb52a4d9cf3/disk-1c7873e3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b9aa9a9e09e8/vmlinux-1c7873e3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/782d5e4196e2/bzImage-1c7873e3.xz

The issue was bisected to:

commit 65966aaca18a5cbf42ac22234cb9cbbf60a4d33c
Author: Sean Christopherson <seanjc@google.com>
Date:   Thu Feb 16 20:22:54 2023 +0000

    KVM: x86: Assert that the emulator doesn't load CS with garbage in !RM

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16c70f4ca80000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15c70f4ca80000
console output: https://syzkaller.appspot.com/x/log.txt?x=11c70f4ca80000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5234e75fb68b86fe89e3@syzkaller.appspotmail.com
Fixes: 65966aaca18a ("KVM: x86: Assert that the emulator doesn't load CS with garbage in !RM")

kvm_intel: set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5022 at arch/x86/kvm/emulate.c:1648 __load_segment_descriptor+0xf89/0x1200 arch/x86/kvm/emulate.c:1648
Modules linked in:
CPU: 0 PID: 5022 Comm: syz-executor486 Not tainted 6.4.0-syzkaller-12454-g1c7873e33645 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/03/2023
RIP: 0010:__load_segment_descriptor+0xf89/0x1200 arch/x86/kvm/emulate.c:1648
Code: 70 00 44 0f b6 7c 24 37 0f b6 7c 24 30 44 89 fe e8 4c f9 70 00 44 38 7c 24 30 0f 84 96 fb ff ff e9 06 f9 ff ff e8 d7 fd 70 00 <0f> 0b 44 0f b6 7c 24 20 e9 43 f2 ff ff e8 c5 fd 70 00 44 0f b6 7c
RSP: 0018:ffffc90003abf898 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8880275e5940 RSI: ffffffff8113e3b9 RDI: 0000000000000005
RBP: ffff8880765e8000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000050
R13: 0000000000000050 R14: ffff8880765e8030 R15: 0000000000000000
FS:  00005555566133c0(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020032008 CR3: 0000000025f5b000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 load_segment_descriptor arch/x86/kvm/emulate.c:1775 [inline]
 __emulate_int_real+0x561/0x6f0 arch/x86/kvm/emulate.c:2061
 emulate_int_real+0x7d/0xd0 arch/x86/kvm/emulate.c:2075
 kvm_inject_realmode_interrupt+0x102/0x340 arch/x86/kvm/x86.c:8435
 vmx_inject_exception+0x33b/0x470 arch/x86/kvm/vmx/vmx.c:1793
 kvm_check_and_inject_events arch/x86/kvm/x86.c:10082 [inline]
 vcpu_enter_guest+0x386/0x6020 arch/x86/kvm/x86.c:10646
 vcpu_run arch/x86/kvm/x86.c:10951 [inline]
 kvm_arch_vcpu_ioctl_run+0xa35/0x2820 arch/x86/kvm/x86.c:11172
 kvm_vcpu_ioctl+0x574/0xe90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x19d/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f281d28c749
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffced680a68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffced680a78 RCX: 00007f281d28c749
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007ffced680a70 R08: 0000000000000000 R09: 00007f281d24d2d0
R10: 0000000000009120 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
