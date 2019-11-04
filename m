Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2D0ED91B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 07:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfKDGlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 01:41:09 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:37211 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbfKDGlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 01:41:08 -0500
Received: by mail-il1-f200.google.com with SMTP id u68so14917750ilc.4
        for <kvm@vger.kernel.org>; Sun, 03 Nov 2019 22:41:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zjUEm4n2QGZiAjQ0l6i1nAlpzkEMT32Bo7zHdLCO1XU=;
        b=Uyy2QKPpWoSEICKLPB0WALN8EGIOuVP2mmoyJjYNrYzAmvEWlfj6mSZ5t9IF6Et3ox
         zLExl3Vb493sTglInnHmXLcdJRC7CaA8J91k9FpNYiFG/8SJsKjKuRYyl7vBksnCo+MF
         38ACAMM5sirvpGDi9GwEkC1rV9l7oOIhDLwpUtjGyekHT4eW9C+uCjCoQypBr57dJWrI
         nIzJl9g1crlofpY5TqPOwA5bV/0IZHuw/QqIsUYiLIAhk8sg625eGhLm5KaQUN9hkzfk
         tLALxYVdWTdUyqnFIHRPB4QNVtlmh17QJh+ZwuSzv9LazsJyWUjrz/jXhFDrPWzlu+gm
         ihnw==
X-Gm-Message-State: APjAAAX87bdncXr9SJou51UM2BVZG8d4i55asO2gOb4OXnQ1o4PViX+N
        ENIoiHHRlfpBqF/6M6A/PJC7I90LZWK7lOJww3pnGuPS1/fK
X-Google-Smtp-Source: APXvYqw+nreieLrPYdIUFcEgEIU44O5Aj8bhewrX26iSFPuIizX+8N8mif2nt3olFQIV1G+LODV1ZggdSh1NHF3G1yy+tzwEuBRx
MIME-Version: 1.0
X-Received: by 2002:a5e:d716:: with SMTP id v22mr21059204iom.152.1572849667938;
 Sun, 03 Nov 2019 22:41:07 -0800 (PST)
Date:   Sun, 03 Nov 2019 22:41:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000be219705967f9963@google.com>
Subject: general protection fault in kvm_coalesced_mmio_init
From:   syzbot <syzbot+e27e7027eb2b80e44225@syzkaller.appspotmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9d234505 Merge tag 'hwmon-for-v5.4-rc6' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1780f6a4e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbbed3e8d4eb64bf
dashboard link: https://syzkaller.appspot.com/bug?extid=e27e7027eb2b80e44225
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e27e7027eb2b80e44225@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 19030 Comm: syz-executor.1 Not tainted 5.4.0-rc5+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:kvm_coalesced_mmio_init+0x67/0x120  
arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:121
Code: 00 48 01 c3 48 89 fa 48 b8 00 00 00 00 80 88 ff ff 48 c1 fb 06 48 c1  
ea 03 48 c1 e3 0c 48 01 c3 48 b8 00 00 00 00 00 fc ff df <80> 3c 02 00 0f  
85 9a 00 00 00 49 89 9c 24 d8 96 00 00 48 c7 c2 60
RSP: 0018:ffff88808e5cfc08 EFLAGS: 00010286
RAX: dffffc0000000000 RBX: ffff88809a815000 RCX: ffffc90008156000
RDX: 00000000000012db RSI: ffffffff8108569c RDI: 00000000000096d8
RBP: ffff88808e5cfc18 R08: 0000000000000000 R09: ffffed1015d06b75
R10: ffffed1015d06b74 R11: ffff8880ae835ba3 R12: 0000000000000000
R13: dffffc0000000000 R14: ffffc90001921000 R15: ffff88805bf80000
FS:  00007f1e8b8a5700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020800000 CR3: 0000000097aee000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3448  
[inline]
  kvm_dev_ioctl+0x81e/0x1610 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3496
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459f49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1e8b8a4c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459f49
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f1e8b8a56d4
R13: 00000000004c30a8 R14: 00000000004d7018 R15: 00000000ffffffff
Modules linked in:
---[ end trace bc86b75fc185a9a9 ]---
RIP: 0010:kvm_coalesced_mmio_init+0x67/0x120  
arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:121
Code: 00 48 01 c3 48 89 fa 48 b8 00 00 00 00 80 88 ff ff 48 c1 fb 06 48 c1  
ea 03 48 c1 e3 0c 48 01 c3 48 b8 00 00 00 00 00 fc ff df <80> 3c 02 00 0f  
85 9a 00 00 00 49 89 9c 24 d8 96 00 00 48 c7 c2 60
RSP: 0018:ffff88808e5cfc08 EFLAGS: 00010286
RAX: dffffc0000000000 RBX: ffff88809a815000 RCX: ffffc90008156000
RDX: 00000000000012db RSI: ffffffff8108569c RDI: 00000000000096d8
RBP: ffff88808e5cfc18 R08: 0000000000000000 R09: ffffed1015d06b75
R10: ffffed1015d06b74 R11: ffff8880ae835ba3 R12: 0000000000000000
R13: dffffc0000000000 R14: ffffc90001921000 R15: ffff88805bf80000
FS:  00007f1e8b8a5700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbe165b8330 CR3: 0000000097aee000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
