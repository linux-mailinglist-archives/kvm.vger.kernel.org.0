Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC215C236
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 19:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbfGARoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 13:44:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:41077 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfGARoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 13:44:07 -0400
Received: by mail-io1-f71.google.com with SMTP id x17so15762319iog.8
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 10:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Dh+QKLYAb7KA80GtNtwXhOg1h09fQw25aUTMLxBCKqU=;
        b=U7QjEefaTjByGn8HzTL2QflL5ku7jpg7Y2bSXQSBDg6uE30sRuzu16yFddofFHjmgx
         xveSDXW4NGr1mW8+9frLtIbfMfIuNnLI0nKCiqFCljgkQak2u3fgBIuGsMzt5xF9JCxI
         A7HwOCN5+IoTjnwsd4F1zHWIxk9NfkhMV0uJ19ewnScci3SbsaFeq3bhD9mghANJQ33k
         3rwtjSKZpYGoCGXn1xfKv711aR9bU2g16uSo8oGHxLbQ4jD3kKF0OKCayUSrMa14F+HM
         +CcWxuDnWJh+gWbPFEkdWZA6s/9YOf8GFdQ39Krph60p06wHDNX9o3ikVQI25eqhWl50
         iDaQ==
X-Gm-Message-State: APjAAAVGPfMlyqSpOF81xis0Wzuh/NJgst3VH88xX2xi1eBHX35Jcwpc
        EzBXnoJtSE15UsUtUIcrbDBIHjJDqQthy6y9sUu+c/fS0DH0
X-Google-Smtp-Source: APXvYqxnwncqWNlFGAvyuADpXevH9praFT1Twhx6I5DCFArh5mkjeB5hjzdgLs/TNAQogEfrEF5YqLRsHqoGH5UUPzbaVuo4SezZ
MIME-Version: 1.0
X-Received: by 2002:a02:1087:: with SMTP id 129mr31750751jay.131.1562003047057;
 Mon, 01 Jul 2019 10:44:07 -0700 (PDT)
Date:   Mon, 01 Jul 2019 10:44:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c218c4058ca22c33@google.com>
Subject: kernel BUG at include/linux/kvm_host.h:LINE!
From:   syzbot <syzbot+bfdba32e6c49af090931@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6fbc7275 Linux 5.2-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d8d2cda00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f6451f0da3d42d53
dashboard link: https://syzkaller.appspot.com/bug?extid=bfdba32e6c49af090931
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bfdba32e6c49af090931@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at include/linux/kvm_host.h:579!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5546 Comm: syz-executor.4 Not tainted 5.2.0-rc7 #65
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:kvm_vcpu_get_idx include/linux/kvm_host.h:579 [inline]
RIP: 0010:kvm_vcpu_get_idx include/linux/kvm_host.h:571 [inline]
RIP: 0010:kvm_hv_set_msr arch/x86/kvm/hyperv.c:1082 [inline]
RIP: 0010:kvm_hv_set_msr_common+0x241d/0x2ab0 arch/x86/kvm/hyperv.c:1303
Code: fa 48 c1 ea 03 80 3c 02 00 0f 85 c6 03 00 00 48 8b 85 28 ff ff ff 45  
31 e4 49 89 87 20 2e 00 00 e9 10 dd ff ff e8 53 aa 58 00 <0f> 0b 4c 89 ff  
e8 29 58 91 00 e9 8d de ff ff 4c 89 ff e8 1c 58 91
RSP: 0018:ffff88804f8a73d8 EFLAGS: 00010216
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc9000e83e000
RDX: 0000000000001051 RSI: ffffffff811818ed RDI: 0000000000000004
RBP: ffff88804f8a74f0 R08: ffff888061eda0c0 R09: fffff52002c4bb3b
R10: fffff52002c4bb3a R11: ffffc9001625d9d3 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffc9001625d9d0 R15: ffff888057209980
FS:  00007f8cdaf27700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd93ee22db8 CR3: 00000000993e9000 CR4: 00000000001426f0
Call Trace:
  kvm_set_msr_common+0xb8f/0x2570 arch/x86/kvm/x86.c:2662
  vmx_set_msr+0x710/0x21d0 arch/x86/kvm/vmx/vmx.c:2030
  kvm_set_msr+0x18a/0x370 arch/x86/kvm/x86.c:1359
  do_set_msr+0xa6/0xf0 arch/x86/kvm/x86.c:1388
  __msr_io arch/x86/kvm/x86.c:2975 [inline]
  msr_io+0x1ad/0x2e0 arch/x86/kvm/x86.c:3011
  kvm_arch_vcpu_ioctl+0x12be/0x3000 arch/x86/kvm/x86.c:4032
  kvm_vcpu_ioctl+0x8f6/0xf90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2905
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xd5f/0x1380 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459519
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8cdaf26c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459519
RDX: 0000000020000280 RSI: 000000004008ae89 RDI: 0000000000000005
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8cdaf276d4
R13: 00000000004c249d R14: 00000000004d5708 R15: 00000000ffffffff
Modules linked in:
---[ end trace 4d93e12c89ced131 ]---
RIP: 0010:kvm_vcpu_get_idx include/linux/kvm_host.h:579 [inline]
RIP: 0010:kvm_vcpu_get_idx include/linux/kvm_host.h:571 [inline]
RIP: 0010:kvm_hv_set_msr arch/x86/kvm/hyperv.c:1082 [inline]
RIP: 0010:kvm_hv_set_msr_common+0x241d/0x2ab0 arch/x86/kvm/hyperv.c:1303
Code: fa 48 c1 ea 03 80 3c 02 00 0f 85 c6 03 00 00 48 8b 85 28 ff ff ff 45  
31 e4 49 89 87 20 2e 00 00 e9 10 dd ff ff e8 53 aa 58 00 <0f> 0b 4c 89 ff  
e8 29 58 91 00 e9 8d de ff ff 4c 89 ff e8 1c 58 91
RSP: 0018:ffff88804f8a73d8 EFLAGS: 00010216
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc9000e83e000
RDX: 0000000000001051 RSI: ffffffff811818ed RDI: 0000000000000004
RBP: ffff88804f8a74f0 R08: ffff888061eda0c0 R09: fffff52002c4bb3b
R10: fffff52002c4bb3a R11: ffffc9001625d9d3 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffc9001625d9d0 R15: ffff888057209980
FS:  00007f8cdaf27700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdcaa36dec CR3: 00000000993e9000 CR4: 00000000001426f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
