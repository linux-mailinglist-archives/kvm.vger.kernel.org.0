Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1FF1A4887
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDJQdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 12:33:11 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:52030 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgDJQdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 12:33:11 -0400
Received: by mail-il1-f200.google.com with SMTP id i13so2958500ilq.18
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 09:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kIdJgJjTI4XqE+TdSFWC6xj+EidlJj7aQNtd5Ye8kmA=;
        b=VquIBR1ab7523dXHrLXtqMTNY+Bm8XAvzov3hqtrojlw5zAp9BV4fJ4OFLrFeHKfis
         pGieUiWu2AHK3bUVe57lBLWJW6l3lNwCQq4GWrzdpPIdBO7emyssHtNUu/96NgIZ11hd
         nGZEZE0oiWa/gBY9l1Y/NPgxBH4ZGhgPSH4ImAdIEGQ2glywt2z8Jas42iivAzmau3AJ
         MbGntMpj/XERQfy/twLfZ1MpcTDUhN2qV/u4MJ6RmPs0N2WUZ18VR6t13/tYM1CQp9hW
         NA5htZBr3/w6JxzH0T3TrSpbiRv+p6P1OU/Wxc8Fm4BlKokwy9reYB9aMwxHcRJd1CSd
         BOVw==
X-Gm-Message-State: AGi0PuZYx2Ck7UvyKLAZwdwpTBd32v53Lb0CAAkVhxVHny/FXSP+r3HP
        zzGh/+7VEjgPkmwyC/Xx39OemHUIC/xo2aY9MQwDPYyTcuJd
X-Google-Smtp-Source: APiQypIJRgDOTiSttMKYXZXZ/f4Ee2yDiM27Fyq0eib8Eh6auNsuWFnDwTi0vDZ0XCNMS3d4ETyPDmZym0BFiCXv5iN6nsRp3wCC
MIME-Version: 1.0
X-Received: by 2002:a5d:88ce:: with SMTP id i14mr5053399iol.184.1586536391140;
 Fri, 10 Apr 2020 09:33:11 -0700 (PDT)
Date:   Fri, 10 Apr 2020 09:33:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000046e4f05a2f24a4b@google.com>
Subject: KASAN: slab-out-of-bounds Read in gfn_to_pfn
From:   syzbot <syzbot+25a50e1a4e196faed650@syzkaller.appspotmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f5e94d10 Merge tag 'drm-next-2020-04-08' of git://anongit...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1450c657e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ca75979eeebf06c2
dashboard link: https://syzkaller.appspot.com/bug?extid=25a50e1a4e196faed650
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+25a50e1a4e196faed650@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in search_memslots include/linux/kvm_host.h:1051 [inline]
BUG: KASAN: slab-out-of-bounds in __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
BUG: KASAN: slab-out-of-bounds in gfn_to_memslot arch/x86/kvm/../../../virt/kvm/kvm_main.c:1597 [inline]
BUG: KASAN: slab-out-of-bounds in gfn_to_pfn+0x4a6/0x4c0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1977
Read of size 8 at addr ffff88809ddb0468 by task syz-executor.2/22057

CPU: 1 PID: 22057 Comm: syz-executor.2 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 search_memslots include/linux/kvm_host.h:1051 [inline]
 __gfn_to_memslot include/linux/kvm_host.h:1063 [inline]
 gfn_to_memslot arch/x86/kvm/../../../virt/kvm/kvm_main.c:1597 [inline]
 gfn_to_pfn+0x4a6/0x4c0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1977
 reexecute_instruction arch/x86/kvm/x86.c:6521 [inline]
 reexecute_instruction+0x1fa/0x430 arch/x86/kvm/x86.c:6486
 x86_emulate_instruction+0x880/0x1c50 arch/x86/kvm/x86.c:6795
 kvm_mmu_page_fault+0x308/0x15d0 arch/x86/kvm/mmu/mmu.c:5495
 vmx_handle_exit+0x2b8/0x1700 arch/x86/kvm/vmx/vmx.c:5953
 vcpu_enter_guest+0xfea/0x59d0 arch/x86/kvm/x86.c:8470
 vcpu_run arch/x86/kvm/x86.c:8533 [inline]
 kvm_arch_vcpu_ioctl_run+0x3fb/0x16a0 arch/x86/kvm/x86.c:8755
 kvm_vcpu_ioctl+0x493/0xe60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3138
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c889
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fdba05c4c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fdba05c56d4 RCX: 000000000045c889
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000003be R14: 00000000004c64be R15: 000000000076bf0c

Allocated by task 22057:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:739 [inline]
 kvzalloc include/linux/mm.h:747 [inline]
 kvm_dup_memslots arch/x86/kvm/../../../virt/kvm/kvm_main.c:1101 [inline]
 kvm_set_memslot+0x115/0x1530 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1118
 __kvm_set_memory_region+0xcf7/0x1320 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1300
 kvm_set_memory_region+0x29/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1321
 kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1333 [inline]
 kvm_vm_ioctl+0x678/0x23e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3604
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 21458:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 kvfree+0x42/0x50 mm/util.c:603
 __free_fdtable+0x2d/0x70 fs/file.c:31
 put_files_struct fs/file.c:420 [inline]
 put_files_struct+0x248/0x2e0 fs/file.c:413
 exit_files+0x7e/0xa0 fs/file.c:445
 do_exit+0xb04/0x2dd0 kernel/exit.c:790
 do_group_exit+0x125/0x340 kernel/exit.c:893
 get_signal+0x47b/0x24e0 kernel/signal.c:2739
 do_signal+0x81/0x2240 arch/x86/kernel/signal.c:784
 exit_to_usermode_loop+0x26c/0x360 arch/x86/entry/common.c:161
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

The buggy address belongs to the object at ffff88809ddb0000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1128 bytes inside of
 2048-byte region [ffff88809ddb0000, ffff88809ddb0800)
The buggy address belongs to the page:
page:ffffea0002776c00 refcount:1 mapcount:0 mapping:00000000cff1b606 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00028d7ec8 ffffea00023c1148 ffff8880aa000e00
raw: 0000000000000000 ffff88809ddb0000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809ddb0300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88809ddb0380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88809ddb0400: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
                                                          ^
 ffff88809ddb0480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809ddb0500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
