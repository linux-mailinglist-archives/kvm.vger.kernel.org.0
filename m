Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19D36EC695
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 08:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjDXGx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 02:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjDXGxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 02:53:49 -0400
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F53B186
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 23:53:47 -0700 (PDT)
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-32ab192a7b3so28006125ab.1
        for <kvm@vger.kernel.org>; Sun, 23 Apr 2023 23:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682319227; x=1684911227;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=32zq2/JPkNYeQH0FDpopQchv7UkOOuBJY0UjL9bCTK0=;
        b=Ayc/xja/r/TRYDjd9xJVCc+2nHANku/17hfrUS4HGEM7CZPQ/hblOWjvuSQ3C3CS1N
         rFVb64gphti4XUuUQLAl0vCj8hkw50wyZhkvLVHbcnvY94GENaDhdpS4IPjYO75YUB2C
         iS52pnijvrb6oh5kXSOl3Qd3M+1Re1/QaVcGdDtxBUlihyFMe+bVK3PKc/glxGcoVPGC
         AFq+Shh0LrUKOJQImFyrjR0ROytTi9KeKrkNqzgul16FSponeU9s8UGhyxTDPIh3dkfM
         VVSDrpIBX5CU+OHD5X5u266FaYw5CovvDtOJqSnWxAqUCREyOFDKjajXmVuZBTmnDRhZ
         GiZg==
X-Gm-Message-State: AAQBX9fNv24gWhCFf2UTNZ3UVOli1D7lHrX62unKoRWoF4pe4ZulKqWG
        2fQyWRdJQf6aGj8bIHHxlYARZTbvfbEFZ3oyZ2LXIqiqADE2
X-Google-Smtp-Source: AKy350bFJm66N/3FwsOmmTrNrTN95Te6Pn3usv2p+46irOHypDfvx9HYWnZE2JUVaK95IijGAGI03SIcqglFPfnW79U2w+IKl5ho
MIME-Version: 1.0
X-Received: by 2002:a92:c112:0:b0:32b:59f2:41da with SMTP id
 p18-20020a92c112000000b0032b59f241damr4309525ile.5.1682319227000; Sun, 23 Apr
 2023 23:53:47 -0700 (PDT)
Date:   Sun, 23 Apr 2023 23:53:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000eca0b905fa0f7756@google.com>
Subject: [syzbot] [kvm?] KASAN: slab-use-after-free Read in kvm_tdp_mmu_invalidate_all_roots
From:   syzbot <syzbot+864ac0b626794668b732@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d3e1ee0e67e7 Add linux-next specific files for 20230421
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=118a0520280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53c789efbcc06cf6
dashboard link: https://syzkaller.appspot.com/bug?extid=864ac0b626794668b732
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c558a9e1fe6a/disk-d3e1ee0e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2ec100a34c4c/vmlinux-d3e1ee0e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1afcd9936dc1/bzImage-d3e1ee0e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+864ac0b626794668b732@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in kvm_tdp_mmu_invalidate_all_roots+0x2e3/0x370 arch/x86/kvm/mmu/tdp_mmu.c:945
Read of size 8 at addr ffff88807c27d528 by task syz-executor.2/5817

CPU: 0 PID: 5817 Comm: syz-executor.2 Not tainted 6.3.0-rc7-next-20230421-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
 print_report mm/kasan/report.c:462 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:572
 kvm_tdp_mmu_invalidate_all_roots+0x2e3/0x370 arch/x86/kvm/mmu/tdp_mmu.c:945
 kvm_mmu_uninit_tdp_mmu+0x16/0x100 arch/x86/kvm/mmu/tdp_mmu.c:48
 kvm_mmu_uninit_vm+0x6a/0x70 arch/x86/kvm/mmu/mmu.c:6239
 kvm_arch_destroy_vm+0x369/0x490 arch/x86/kvm/x86.c:12465
 kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1313 [inline]
 kvm_put_kvm+0x4da/0xae0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1347
 kvm_vcpu_release+0x51/0x70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3846
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f426b83e01b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007ffe38a35070 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000008 RCX: 00007f426b83e01b
RDX: 0000000000000000 RSI: 0000001b32b3a7d4 RDI: 0000000000000007
RBP: 00007f426b9ad980 R08: 0000000000000000 R09: 0000000075ee794b
R10: 0000000000000000 R11: 0000000000000293 R12: 000000000003d553
R13: 00007ffe38a35170 R14: 00007ffe38a35190 R15: 0000000000000032
 </TASK>

Allocated by task 5819:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:328
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:711 [inline]
 slab_alloc_node mm/slub.c:3451 [inline]
 slab_alloc mm/slub.c:3459 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3466 [inline]
 kmem_cache_alloc+0x17c/0x3b0 mm/slub.c:3475
 mmu_memory_cache_alloc_obj arch/x86/kvm/../../../virt/kvm/kvm_main.c:389 [inline]
 __kvm_mmu_topup_memory_cache+0x19c/0x490 arch/x86/kvm/../../../virt/kvm/kvm_main.c:418
 mmu_topup_memory_caches arch/x86/kvm/mmu/mmu.c:707 [inline]
 mmu_topup_memory_caches+0xb4/0xd0 arch/x86/kvm/mmu/mmu.c:688
 kvm_mmu_load+0xd6/0x2140 arch/x86/kvm/mmu/mmu.c:5493
 kvm_mmu_reload arch/x86/kvm/mmu.h:130 [inline]
 vcpu_enter_guest+0x33e8/0x55e0 arch/x86/kvm/x86.c:10657
 vcpu_run arch/x86/kvm/x86.c:10945 [inline]
 kvm_arch_vcpu_ioctl_run+0x9d8/0x24f0 arch/x86/kvm/x86.c:11166
 kvm_vcpu_ioctl+0x574/0xea0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4102
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 21:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:521
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3786 [inline]
 kmem_cache_free+0xe9/0x480 mm/slub.c:3808
 rcu_do_batch kernel/rcu/tree.c:2115 [inline]
 rcu_core+0x806/0x1a70 kernel/rcu/tree.c:2377
 __do_softirq+0x1d4/0x905 kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
 __call_rcu_common.constprop.0+0x99/0x790 kernel/rcu/tree.c:2627
 kvm_tdp_mmu_put_root+0x2f6/0x460 arch/x86/kvm/mmu/tdp_mmu.c:147
 tdp_mmu_zap_root_work+0x5b/0x70 arch/x86/kvm/mmu/tdp_mmu.c:117
 process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
 worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
 kthread+0x33e/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:491
 insert_work+0x48/0x360 kernel/workqueue.c:1365
 __queue_work+0x5c6/0xfb0 kernel/workqueue.c:1526
 queue_work_on+0xf2/0x110 kernel/workqueue.c:1554
 queue_work include/linux/workqueue.h:505 [inline]
 tdp_mmu_schedule_zap_root arch/x86/kvm/mmu/tdp_mmu.c:126 [inline]
 kvm_tdp_mmu_invalidate_all_roots+0x27c/0x370 arch/x86/kvm/mmu/tdp_mmu.c:948
 kvm_mmu_uninit_tdp_mmu+0x16/0x100 arch/x86/kvm/mmu/tdp_mmu.c:48
 kvm_mmu_uninit_vm+0x6a/0x70 arch/x86/kvm/mmu/mmu.c:6239
 kvm_arch_destroy_vm+0x369/0x490 arch/x86/kvm/x86.c:12465
 kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1313 [inline]
 kvm_put_kvm+0x4da/0xae0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1347
 kvm_vcpu_release+0x51/0x70 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3846
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807c27d528
 which belongs to the cache kvm_mmu_page_header of size 200
The buggy address is located 0 bytes inside of
 freed 200-byte region [ffff88807c27d528, ffff88807c27d5f0)

The buggy address belongs to the physical page:
page:ffffea0001f09f40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7c27d
memcg:ffff888021a31c01
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000000200 ffff888145ca9000 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800f000f 00000001ffffffff ffff888021a31c01
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112cc0(GFP_USER|__GFP_NOWARN|__GFP_NORETRY), pid 5819, tgid 5817 (syz-executor.2), ts 252534287823, free_ts 252119040126
 prep_new_page mm/page_alloc.c:1729 [inline]
 get_page_from_freelist+0xf7c/0x2aa0 mm/page_alloc.c:3493
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4759
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2277
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x28e/0x380 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3192
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3291
 __slab_alloc_node mm/slub.c:3344 [inline]
 slab_alloc_node mm/slub.c:3441 [inline]
 slab_alloc mm/slub.c:3459 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3466 [inline]
 kmem_cache_alloc+0x38e/0x3b0 mm/slub.c:3475
 mmu_memory_cache_alloc_obj arch/x86/kvm/../../../virt/kvm/kvm_main.c:389 [inline]
 __kvm_mmu_topup_memory_cache+0x19c/0x490 arch/x86/kvm/../../../virt/kvm/kvm_main.c:418
 mmu_topup_memory_caches arch/x86/kvm/mmu/mmu.c:707 [inline]
 mmu_topup_memory_caches+0xb4/0xd0 arch/x86/kvm/mmu/mmu.c:688
 kvm_mmu_load+0xd6/0x2140 arch/x86/kvm/mmu/mmu.c:5493
 kvm_mmu_reload arch/x86/kvm/mmu.h:130 [inline]
 vcpu_enter_guest+0x33e8/0x55e0 arch/x86/kvm/x86.c:10657
 vcpu_run arch/x86/kvm/x86.c:10945 [inline]
 kvm_arch_vcpu_ioctl_run+0x9d8/0x24f0 arch/x86/kvm/x86.c:11166
 kvm_vcpu_ioctl+0x574/0xea0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4102
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x4d8/0xb80 mm/page_alloc.c:2555
 free_unref_page+0x33/0x370 mm/page_alloc.c:2650
 vfree+0x180/0x7e0 mm/vmalloc.c:2798
 delayed_vfree_work+0x57/0x70 mm/vmalloc.c:2719
 process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
 worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
 kthread+0x33e/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Memory state around the buggy address:
 ffff88807c27d400: fc fc fc fc fa fb fb fb fb fb fb fb fb fb fb fb
 ffff88807c27d480: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
>ffff88807c27d500: fc fc fc fc fc fa fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88807c27d580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff88807c27d600: fc fc fc fc fc fc fa fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
