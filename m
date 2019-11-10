Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DABF1F6936
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2019 14:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfKJN4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Nov 2019 08:56:08 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:39917 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfKJN4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Nov 2019 08:56:08 -0500
Received: by mail-il1-f200.google.com with SMTP id t4so1025743iln.6
        for <kvm@vger.kernel.org>; Sun, 10 Nov 2019 05:56:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nlS1l9MxSuED0ZlOb4RmmDwaqDvte1G/YuN8sqrxTd8=;
        b=DF+5iLrWXHUkHr2e2VHSVaoKZjVstyeAhpOqqqtJmKzqe2zoI5TroYOOpyLcjZ0FVg
         Tjzy8OyMhqp68wAuw8JmD+X4VEurRSZeiZJoAOc87lG3tIRfWxCDgDDvTxyt4pfVnBaN
         gIvzfqRXy2q8o+O5TQt9/C9R/Lvhoy4hwsufvcKXrv27OGmrU9WatGQ3/9ebah+Hzr3K
         7uzxwqf0/sII0AICzEf0JS7CNOB8DsgCfgQY0Bx27vL2EZmmK0MNqGcKBPtzuKb28j9Q
         Ja8XJ2/NkuBIcHMnS/KT7McX4YDVngJ1BrCf66zcmbQEAjLcGgiffZ3vAcb3qzOqe+ik
         aHfA==
X-Gm-Message-State: APjAAAWP/ig12LS/jUIMjEcDISUMhWOXkUVtebdPlROrcOSlNkQZsZrZ
        lXf1Y3sLAv0/9DXSqg6gUv45uFHhOg7MkcMMPjYaP1hCVS2Y
X-Google-Smtp-Source: APXvYqzjUaZ1vBw/aECJNlYHarHMpT5CKXFoXHsOtvfHE48QPYL4ftY0c8+9y7EBOUvMhXfRNId2GDEmvFwRFD/3S6l3q6VpMHK9
MIME-Version: 1.0
X-Received: by 2002:a92:25c9:: with SMTP id l192mr25430816ill.84.1573394167932;
 Sun, 10 Nov 2019 05:56:07 -0800 (PST)
Date:   Sun, 10 Nov 2019 05:56:07 -0800
In-Reply-To: <000000000000be219705967f9963@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000078b1710596fe60a3@google.com>
Subject: Re: general protection fault in kvm_coalesced_mmio_init
From:   syzbot <syzbot+e27e7027eb2b80e44225@syzkaller.appspotmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    00aff683 Merge tag 'for-5.4-rc6-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1777fb52e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=896c87b73c6fcda6
dashboard link: https://syzkaller.appspot.com/bug?extid=e27e7027eb2b80e44225
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ed65aae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e27e7027eb2b80e44225@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 20263 Comm: syz-executor.2 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:kvm_coalesced_mmio_init+0x59/0xf0  
arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:121
Code: 00 00 00 fc ff df e8 46 7d 6b 00 48 c1 e3 06 49 be 00 00 00 00 80 08  
05 00 49 01 de 49 8d bf d8 96 00 00 48 89 f8 48 c1 e8 03 <42> 80 3c 20 00  
74 05 e8 bb bb a4 00 4d 89 b7 d8 96 00 00 49 8d bf
RSP: 0018:ffff888091647d10 EFLAGS: 00010206
RAX: 00000000000012db RBX: fffa80009cb1b000 RCX: ffff8880a42d21c0
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 00000000000096d8
RBP: ffff888091647d30 R08: ffffffff83486eda R09: ffffed1015d46b05
R10: ffffed1015d46b05 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000000 R14: ffff88809cb1b000 R15: 0000000000000000
FS:  00007fb51eb61700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa986fb7000 CR3: 000000009c69d000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3448  
[inline]
  kvm_dev_ioctl+0x18fa/0x1fd0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3496
  do_vfs_ioctl+0x744/0x1730 fs/ioctl.c:46
  ksys_ioctl fs/ioctl.c:713 [inline]
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0xe3/0x120 fs/ioctl.c:718
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a219
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb51eb60c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a219
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000004
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb51eb616d4
R13: 00000000004c348b R14: 00000000004d7708 R15: 00000000ffffffff
Modules linked in:
---[ end trace 15ab0f35a80c9e5d ]---
RIP: 0010:kvm_coalesced_mmio_init+0x59/0xf0  
arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:121
Code: 00 00 00 fc ff df e8 46 7d 6b 00 48 c1 e3 06 49 be 00 00 00 00 80 08  
05 00 49 01 de 49 8d bf d8 96 00 00 48 89 f8 48 c1 e8 03 <42> 80 3c 20 00  
74 05 e8 bb bb a4 00 4d 89 b7 d8 96 00 00 49 8d bf
RSP: 0018:ffff888091647d10 EFLAGS: 00010206
RAX: 00000000000012db RBX: fffa80009cb1b000 RCX: ffff8880a42d21c0
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 00000000000096d8
RBP: ffff888091647d30 R08: ffffffff83486eda R09: ffffed1015d46b05
R10: ffffed1015d46b05 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000000 R14: ffff88809cb1b000 R15: 0000000000000000
FS:  00007fb51eb61700(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000625208 CR3: 000000009c69d000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

