Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73F10D25D
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 09:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfK2IUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 03:20:14 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:43263 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfK2IUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 03:20:12 -0500
Received: by mail-io1-f69.google.com with SMTP id b17so7309491ioh.10
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 00:20:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xVR2E33E57gP3WHNwoEF1Nitw4WLWCmTkXaj4CCkoHA=;
        b=P14mU0p9jcltJcYSYBUl5tnLhg9X63SLysvD3PuvbVMhk+MrAS/L70hdp8sNnE3Tih
         CWgpnzc/6o8DxEdMxHY+tmjXJdcXj18ik5NAZQfjyHGpCgox5HKUiaw4n8GuAosHp4Hj
         1WPOmpVTQcKABX8qXZeFBAdaY7073+3ysvOe9QyS8WXf7GDEvybdDLhP2cE2ZfyWa7Ws
         dQl1LwhtM2Y6xxIVAIJaMhx2Dkyu6AUjudf/GsmkYkrGxXQgo+HYlIurapSQT4gPtfWp
         /gMej6kTkboK4CszXNFsBrMTKE0xf3UEHu50oX+DO60dF2Rl/OFbWidJpgLra4Fs3Ffl
         haFA==
X-Gm-Message-State: APjAAAWI+pPatgsl1kOTRn1Z8RgKwpTGK4O774KEZZ+NvAl4LIzCKcW0
        VwqOnhjzXpsl+tBfbDSx2MKc27j8jow1p+RYX6oNGosOAyR8
X-Google-Smtp-Source: APXvYqwdCe1U7S/I44jBVgKxlTWKlpY4ux151fW+V79MvqSdIt1FOf5+SuwPAbBxqB63sQx9SD86rmFajVIrgr/9PlCpcwd/3QQj
MIME-Version: 1.0
X-Received: by 2002:a5e:c20c:: with SMTP id v12mr31373543iop.35.1575015610408;
 Fri, 29 Nov 2019 00:20:10 -0800 (PST)
Date:   Fri, 29 Nov 2019 00:20:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f965b8059877e5e6@google.com>
Subject: WARNING in vcpu_enter_guest
From:   syzbot <syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ad062195 Merge tag 'platform-drivers-x86-v5.4-1' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=154910ad600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9fc16a6374d5fd0
dashboard link: https://syzkaller.appspot.com/bug?extid=00be5da1d75f1cc95f6b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 15173 at arch/x86/kvm/x86.c:8007  
vcpu_enter_guest+0x4b29/0x5e90 arch/x86/kvm/x86.c:8007
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 15173 Comm: syz-executor.5 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2dc/0x755 kernel/panic.c:219
  __warn.cold+0x20/0x4c kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:vcpu_enter_guest+0x4b29/0x5e90 arch/x86/kvm/x86.c:8007
Code: 00 fc ff df 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e e9 11 00  
00 41 83 a5 20 27 00 00 fb e9 5c bf ff ff e8 97 9e 65 00 <0f> 0b e9 98 be  
ff ff e8 8b 9e 65 00 31 ff be 07 00 00 00 e8 ef 97
RSP: 0018:ffff8880572bfa10 EFLAGS: 00010046
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc900109ce000
RDX: 0000000000040000 RSI: ffffffff810d3599 RDI: 0000000000000007
RBP: ffff8880572bfb20 R08: ffff8880576b62c0 R09: ffffed100aed6c59
R10: ffffed100aed6c58 R11: ffff8880576b62c7 R12: ffff88805fa9866c
R13: ffff88805fa98640 R14: 0000000000000001 R15: ffff88805fa98670
  vcpu_run arch/x86/kvm/x86.c:8159 [inline]
  kvm_arch_vcpu_ioctl_run+0x464/0x1750 arch/x86/kvm/x86.c:8367
  kvm_vcpu_ioctl+0x4dc/0xfd0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2765
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4598e9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f84f3c93c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004598e9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f84f3c946d4
R13: 00000000004c2c68 R14: 00000000004d6330 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
