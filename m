Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75561104809
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 02:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfKUBZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 20:25:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:39827 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfKUBZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 20:25:09 -0500
Received: by mail-il1-f198.google.com with SMTP id t4so1449159iln.6
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 17:25:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HGyv/05KW+XaAobLS4i93zd1a8c80e9dkbLyOS+7nTE=;
        b=Ks/ycgq/wdm9oXDmLYePFi+HMj6twaTNhTQQmnnEC0k5dYVnRHit/KtLqmuAxwLOyh
         s832mxmqvAwEqd1rq57IiZ/F/KCa/ar+luGy2ct9zSKB6WYvmKgaams39Bdfa7zRP6zv
         gsCl7Jwb99yJcAsydy7OOuJV5HUDA9qFUide5+5Gsts7YSD3NaZBKxwEiULaIjlhfaXl
         jt3iXxqd10kH9g/LvPAgRLUpezqbTdlRuZ9xDTRAMgBkb52UGftbjjAqMxNMlySLLLgZ
         r1ZL/ltFYYzS0GtlpzqKmkzJgqyTsZzxkWFU0OgUEpTYERV21ZLOc2W5qt2+Lp1e+emC
         Q6ig==
X-Gm-Message-State: APjAAAX88l9ANJK48Ki/iw7Qn+mWBxu/351gSL8qS5vnet0Z9r8k/g+u
        0g7BfDhRzNOI35hJwaj2efVCRYtHNOAAzxCVTBQ4eS5J02Tk
X-Google-Smtp-Source: APXvYqyNlnQAK4ZFQ8xtVKsrfLGKh0YwPC6jcC3BdISmDpdRiUc7tjqlJun3ACKExzZGjgvD0VKvfs71YGybjkC0G0adfy4GDNSA
MIME-Version: 1.0
X-Received: by 2002:a02:1ac5:: with SMTP id 188mr6129457jai.77.1574299508737;
 Wed, 20 Nov 2019 17:25:08 -0800 (PST)
Date:   Wed, 20 Nov 2019 17:25:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd119d0597d12a56@google.com>
Subject: kernel panic: stack is corrupted in vhost_net_ioctl
From:   syzbot <syzbot+f2a62d07a5198c819c7b@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        jasowang@redhat.com, john.fastabend@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6c9594bd Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17059c6ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7654f9089a2e8c85
dashboard link: https://syzkaller.appspot.com/bug?extid=f2a62d07a5198c819c7b
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17bacb3ae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f2a62d07a5198c819c7b@syzkaller.appspotmail.com

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in:  
vhost_net_ioctl+0x1d8c/0x1dc0 drivers/vhost/net.c:366
CPU: 1 PID: 7993 Comm: syz-executor.0 Not tainted 5.4.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1fb/0x318 lib/dump_stack.c:118
  panic+0x264/0x7a9 kernel/panic.c:221
  __stack_chk_fail+0x1f/0x20 kernel/panic.c:667
  vhost_net_ioctl+0x1d8c/0x1dc0 drivers/vhost/net.c:366
  do_vfs_ioctl+0x744/0x1730 fs/ioctl.c:46
  ksys_ioctl fs/ioctl.c:713 [inline]
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0xe3/0x120 fs/ioctl.c:718
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a639
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f473d635c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a639
RDX: 0000000020d7c000 RSI: 000000004008af30 RDI: 0000000000000003
RBP: 000000000075c070 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f473d6366d4
R13: 00000000004c5b18 R14: 00000000004dab78 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
