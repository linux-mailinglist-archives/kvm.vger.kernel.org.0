Return-Path: <kvm+bounces-30790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE78E9BD56F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:53:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E8201F2163D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D72B1EF085;
	Tue,  5 Nov 2024 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A7rTmj5P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB431DC04C;
	Tue,  5 Nov 2024 18:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832770; cv=none; b=o7yM2IKFhtpIcPzjIPT1A5t2my6zYVgAV4ZY+xgKncgnNwYi3nO71glDAWiDauk2fPBGWGZlsSu9CVTunTg9pSw1mr+bm9W7hlmssKYktli96JsOSZCrHYa0rXvlS5oE/Gu5pL5Vzi6o2yZgzl+3XD4j/jtkYnZvt+r48k93Xp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832770; c=relaxed/simple;
	bh=XyMYyo3Oig+FDBovBjyMUZ1jHCb4RkEVdx7pQNxMmBk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=jWCYrfArkokoTUvkRfTjA2aF44Dq9ssEP2103xGJF9nKsx97saaPbq8vD+AiJJ2ccMnad+6zMN0HmGOhsoWhyme/Lp/xPN9r4jwDQhX5t8tD8AeVLqxmZtGpu4XQ1hwdGC4sT4aNcLJudvo5cRQ4Q4Gb1WS0QMggT2/jhCFXg84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A7rTmj5P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F617C4CECF;
	Tue,  5 Nov 2024 18:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730832769;
	bh=XyMYyo3Oig+FDBovBjyMUZ1jHCb4RkEVdx7pQNxMmBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A7rTmj5PoDZ+NsN9ezFu87Z3DJaWy5yhmBDNis1cK/YjWCbSvzf/Gf4xgXWj8seUS
	 7duUs+45K6kf2QKCT5iubuiZSUaA0i5BqYLhjzJW88Jw/mITmeBZ5D1L8l4eXWtdm/
	 cHuzGjDjQuueUGGSmzjtIu5w0UBrbYC0gnn0FFBE=
Date: Tue, 5 Nov 2024 10:52:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+e985d3026c4fd041578e@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzkaller-bugs@googlegroups.com, kvm@vger.kernel.org
Subject: Re: [syzbot] [mm?] BUG: Bad page state in kvm_coalesced_mmio_init
Message-Id: <20241105105248.812dc586921df56e5bf78a5e@linux-foundation.org>
In-Reply-To: <6729f475.050a0220.701a.0019.GAE@google.com>
References: <6729f475.050a0220.701a.0019.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

(cc kvm list)

On Tue, 05 Nov 2024 02:33:25 -0800 syzbot <syzbot+e985d3026c4fd041578e@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    59b723cd2adb Linux 6.12-rc6
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17996587980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=11254d3590b16717
> dashboard link: https://syzkaller.appspot.com/bug?extid=e985d3026c4fd041578e
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/202d791be971/disk-59b723cd.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9bfa02908d87/vmlinux-59b723cd.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/93c8c8740b4d/bzImage-59b723cd.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e985d3026c4fd041578e@syzkaller.appspotmail.com
> 
> BUG: Bad page state in process syz.5.504  pfn:61f45
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x61f45
> flags: 0xfff00000080204(referenced|workingset|mlocked|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000080204 0000000000000000 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x400dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO), pid 8443, tgid 8442 (syz.5.504), ts 201884660643, free_ts 201499827394
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
>  prep_new_page mm/page_alloc.c:1545 [inline]
>  get_page_from_freelist+0x303f/0x3190 mm/page_alloc.c:3457
>  __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
>  alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
>  kvm_coalesced_mmio_init+0x1f/0xf0 virt/kvm/coalesced_mmio.c:99
>  kvm_create_vm virt/kvm/kvm_main.c:1235 [inline]
>  kvm_dev_ioctl_create_vm virt/kvm/kvm_main.c:5488 [inline]
>  kvm_dev_ioctl+0x12dc/0x2240 virt/kvm/kvm_main.c:5530
>  __do_compat_sys_ioctl fs/ioctl.c:1007 [inline]
>  __se_compat_sys_ioctl+0x510/0xc90 fs/ioctl.c:950
>  do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
>  __do_fast_syscall_32+0xb4/0x110 arch/x86/entry/common.c:386
>  do_fast_syscall_32+0x34/0x80 arch/x86/entry/common.c:411
>  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> page last free pid 8399 tgid 8399 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1108 [inline]
>  free_unref_folios+0xf12/0x18d0 mm/page_alloc.c:2686
>  folios_put_refs+0x76c/0x860 mm/swap.c:1007
>  free_pages_and_swap_cache+0x5c8/0x690 mm/swap_state.c:335
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:136 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:149 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:366 [inline]
>  tlb_flush_mmu+0x3a3/0x680 mm/mmu_gather.c:373
>  tlb_finish_mmu+0xd4/0x200 mm/mmu_gather.c:465
>  exit_mmap+0x496/0xc40 mm/mmap.c:1926
>  __mmput+0x115/0x390 kernel/fork.c:1348
>  exit_mm+0x220/0x310 kernel/exit.c:571
>  do_exit+0x9b2/0x28e0 kernel/exit.c:926
>  do_group_exit+0x207/0x2c0 kernel/exit.c:1088
>  __do_sys_exit_group kernel/exit.c:1099 [inline]
>  __se_sys_exit_group kernel/exit.c:1097 [inline]
>  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
>  x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> Modules linked in:
> CPU: 0 UID: 0 PID: 8442 Comm: syz.5.504 Not tainted 6.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  bad_page+0x176/0x1d0 mm/page_alloc.c:501
>  free_page_is_bad mm/page_alloc.c:918 [inline]
>  free_pages_prepare mm/page_alloc.c:1100 [inline]
>  free_unref_page+0xed0/0xf20 mm/page_alloc.c:2638
>  kvm_destroy_vm virt/kvm/kvm_main.c:1327 [inline]
>  kvm_put_kvm+0xc75/0x1350 virt/kvm/kvm_main.c:1386
>  kvm_vcpu_release+0x54/0x60 virt/kvm/kvm_main.c:4143
>  __fput+0x23f/0x880 fs/file_table.c:431
>  task_work_run+0x24f/0x310 kernel/task_work.c:239
>  exit_task_work include/linux/task_work.h:43 [inline]
>  do_exit+0xa2f/0x28e0 kernel/exit.c:939
>  do_group_exit+0x207/0x2c0 kernel/exit.c:1088
>  __do_sys_exit_group kernel/exit.c:1099 [inline]
>  __se_sys_exit_group kernel/exit.c:1097 [inline]
>  __ia32_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
>  ia32_sys_call+0x2624/0x2630 arch/x86/include/generated/asm/syscalls_32.h:253
>  do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
>  __do_fast_syscall_32+0xb4/0x110 arch/x86/entry/common.c:386
>  do_fast_syscall_32+0x34/0x80 arch/x86/entry/common.c:411
>  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
> RIP: 0023:0xf745d579
> Code: Unable to access opcode bytes at 0xf745d54f.
> RSP: 002b:00000000f75afd6c EFLAGS: 00000206 ORIG_RAX: 00000000000000fc
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 00000000ffffff9c RDI: 00000000f744cff4
> RBP: 00000000f717ae61 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

