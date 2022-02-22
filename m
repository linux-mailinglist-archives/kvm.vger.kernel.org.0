Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627144BF119
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 06:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiBVFTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 00:19:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiBVFT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 00:19:28 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ADEEEA72
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 21:18:57 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id y11-20020a056602164b00b00640ddd94d80so3662704iow.11
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 21:18:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OoHalkeGw+3WmTkM0UYjuhTqCHPPQ1/v7C2mH0CvZos=;
        b=JYfux7/KaPISGaelp0P3Gz586PQbOuL+fSom5gqE3OBISQ8RjGyPM0CEpI2TPZE93i
         sxdj5jELy8ATUe3hAoLDV1FQelgcStatQk2Sm0V/34HMyvIvB7HB2BGDVXBwt8rjd/ra
         PRqrtxm3UnFscdWRPp4ThLoo7KLoNfnALhYT/tqVVkiUqWrklBEB674InwaqXlU4741Z
         v1I17vgm6tTxwbCLrnoFfiws7nN6lAyMRrBjcgIaWyqCbvzk/C8jXRumYGzsMf3aDP17
         OeLCFaj2B3T+UQCbY/mivQcD1infGHtvzWCZEQ77sSk41tPVUFWgZwyfj7VkPTNfsFe+
         Gx8Q==
X-Gm-Message-State: AOAM5317y/NAMJOVNMSycMXwhk6CPm7X0zMrjfeWr485uak8yPuuZHvN
        upPQKLA1Ys97/8yt/pUpnlepT2qlJoLRbHoA15oMInc9NPeb
X-Google-Smtp-Source: ABdhPJxB6U+s6r8NY7+MQc5zQbVVzpQtlYSlCHJsryRsTsSmJJmcaYKCqrltGE8PXjkn4+2VI3SbYSUdnZu4deIhKMzfsUw5TKdt
MIME-Version: 1.0
X-Received: by 2002:a5d:85d2:0:b0:5ed:a17c:a25c with SMTP id
 e18-20020a5d85d2000000b005eda17ca25cmr18265498ios.85.1645507097811; Mon, 21
 Feb 2022 21:18:17 -0800 (PST)
Date:   Mon, 21 Feb 2022 21:18:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a5eae05d8947adb@google.com>
Subject: [syzbot] WARNING in handle_exception_nmi (2)
From:   syzbot <syzbot+4688c50a9c8e68e7aaa1@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
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

HEAD commit:    80d47f5de5e3 mm: don't try to NUMA-migrate COW pages that ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a7324c700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f6a069ed94a1ed1d
dashboard link: https://syzkaller.appspot.com/bug?extid=4688c50a9c8e68e7aaa1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4688c50a9c8e68e7aaa1@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 7975 at arch/x86/kvm/vmx/vmx.c:4906 handle_exception_nmi+0xfdc/0x1190 arch/x86/kvm/vmx/vmx.c:4906
Modules linked in:
CPU: 0 PID: 7975 Comm: syz-executor.0 Not tainted 5.17.0-rc4-syzkaller-00055-g80d47f5de5e3 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:handle_exception_nmi+0xfdc/0x1190 arch/x86/kvm/vmx/vmx.c:4906
Code: 0f 84 c8 f3 ff ff e8 03 a8 56 00 48 89 ef c7 85 a4 0d 00 00 00 00 00 00 e8 51 1a ec ff 41 89 c4 e9 af f3 ff ff e8 e4 a7 56 00 <0f> 0b e9 69 f6 ff ff e8 d8 a7 56 00 be f5 ff ff ff bf 01 00 00 00
RSP: 0018:ffffc9000615fad8 EFLAGS: 00010216
RAX: 000000000001e2fd RBX: 0000000000000000 RCX: ffffc90002b71000
RDX: 0000000000040000 RSI: ffffffff81216b3c RDI: 0000000000000003
RBP: ffff888025308040 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff812161a4 R11: 0000000000000000 R12: fffffffffffffc4d
R13: ffff888025308288 R14: 0000000000000000 R15: 0000000080000300
FS:  00007f47cabb1700(0000) GS:ffff88802cd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000111c960 CR3: 000000001bb69000 CR4: 0000000000152ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6179 [inline]
 vmx_handle_exit+0x498/0x1950 arch/x86/kvm/vmx/vmx.c:6196
 vcpu_enter_guest+0x29dd/0x4450 arch/x86/kvm/x86.c:10163
 vcpu_run arch/x86/kvm/x86.c:10245 [inline]
 kvm_arch_vcpu_ioctl_run+0x521/0x21a0 arch/x86/kvm/x86.c:10451
 kvm_vcpu_ioctl+0x570/0xf30 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3908
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f47cc23c059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f47cabb1168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f47cc34ef60 RCX: 00007f47cc23c059
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f47cc29608d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd6f43c1df R14: 00007f47cabb1300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
