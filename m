Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDA3271E79
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 11:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIUJCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 05:02:22 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:48097 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgIUJCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 05:02:22 -0400
Received: by mail-il1-f205.google.com with SMTP id p10so7297361ilp.14
        for <kvm@vger.kernel.org>; Mon, 21 Sep 2020 02:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=25Y+FvxN/Mb5eh9wDznBxrs0ksxheuHIjZSbxOFijK0=;
        b=efGHEHNl2/oTtLKIOKNVtsBuWbFsN6kn/QfBYO2XaScjIKUzDtRvCLM+uvV7AIVxbV
         CEP6zASX94cLQqRXQ90bi0KrI+RpbLX/Og+eBxuZuTGu2g7tYLOoMDZt82TQfkYypNbx
         GqZQmO5Zb94kXzt6PAZwsSmDiOcruNwzn5gmnYJKTqnscCwKGTZuO8aa47ZP95L1vHJb
         L6qPZkQbh7RsRyqBjXAMmgimdXA9eWDSnvO8LgmC0ckCMTEPC8hmSlVrx8+j4JCDrF9b
         S/ljGUiYh97KHHRnyUCgPCON1yPDU9H44gTa+NRsocomA9Pl2UzLZp0KElhxN5BbwZv8
         D4Jw==
X-Gm-Message-State: AOAM532AFHQeZqRChM2aq0oBtP8+9pJeSRYH5o4hOz1TAP+o3/maIgGW
        9OOkCSMe4WQew5xO2R3dB5DSQqQNuqGc1N51GZ+M9Sa/vjPH
X-Google-Smtp-Source: ABdhPJyK6A11DIgqEui9yX2KtMi10k/3FxnPcYZ9rmH8F1J2GtGbvc0XeFPToNlRQxoLN6eJtEuGrA2e5NwevoelZmw+hBhSoE5d
MIME-Version: 1.0
X-Received: by 2002:a6b:d908:: with SMTP id r8mr35825863ioc.21.1600678941468;
 Mon, 21 Sep 2020 02:02:21 -0700 (PDT)
Date:   Mon, 21 Sep 2020 02:02:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4ac9e05afcf1b13@google.com>
Subject: WARNING in cleanup_srcu_struct (2)
From:   syzbot <syzbot+735579fbeb0c09a90cfa@syzkaller.appspotmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5925fa68 Merge tag 'perf-tools-fixes-for-v5.9-2020-09-16' ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14b72f01900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c61f6bd349c981f3
dashboard link: https://syzkaller.appspot.com/bug?extid=735579fbeb0c09a90cfa
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+735579fbeb0c09a90cfa@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 14586 at kernel/rcu/srcutree.c:389 cleanup_srcu_struct+0x23b/0x2d0 kernel/rcu/srcutree.c:408
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 14586 Comm: syz-executor.5 Not tainted 5.9.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x347/0x7c0 kernel/panic.c:231
 __warn.cold+0x20/0x46 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:cleanup_srcu_struct+0x23b/0x2d0 kernel/rcu/srcutree.c:389
Code: 84 24 98 04 00 00 00 00 00 00 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b e9 36 ff ff ff 48 8b 3c 24 e8 45 88 53 00 e9 b7 fe ff ff 48
RSP: 0018:ffffc90018f27a18 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff839a9211
RDX: ffff88804f2de100 RSI: ffffffff839a92c3 RDI: 0000000000000006
RBP: 0000000000000001 R08: 0000000000000040 R09: 0000000000000001
R10: 0000000000000040 R11: 0000000000000000 R12: ffffc900057b3020
R13: ffffc900057a9000 R14: ffff88806cfbf000 R15: ffffc900057b2840
 kvm_destroy_vm+0x777/0xbe0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:882
 kvm_put_kvm arch/x86/kvm/../../../virt/kvm/kvm_main.c:899 [inline]
 kvm_vm_release+0xac/0xe0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:922
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x428/0x1f00 kernel/signal.c:2757
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:159 [inline]
 exit_to_user_mode_prepare+0x1ae/0x200 kernel/entry/common.c:190
 irqentry_exit_to_user_mode+0x5/0x30 kernel/entry/common.c:278
 asm_common_interrupt+0x1e/0x40 arch/x86/include/asm/idtentry.h:572
RIP: 0033:0x41221c
Code: Bad RIP value.
RSP: 002b:00007ffe0eb2c660 EFLAGS: 00000202
RAX: 0000000036b92991 RBX: 000000003787d99d RCX: 0000001b2da20000
RDX: 0000000036b92991 RSI: 0000000000000991 RDI: ffffffff36b92991
RBP: 0000000000001914 R08: 0000000036b92991 R09: 0000000036b92995
R10: 00007ffe0eb2c7d0 R11: 0000000000000246 R12: 000000000118cfc8
R13: 00007fb1a8045008 R14: 00007fb1a8045000 R15: 000000000003ce98
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
