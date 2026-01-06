Return-Path: <kvm+bounces-67090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC115CF6600
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 02:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D7A9430393CD
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 01:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D45218AAB;
	Tue,  6 Jan 2026 01:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="UHUpsDMd"
X-Original-To: kvm@vger.kernel.org
Received: from mail3-167.sinamail.sina.com.cn (mail3-167.sinamail.sina.com.cn [202.108.3.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B17203710
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 01:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767664042; cv=none; b=IknWQ0AwGLOk/jSGxL5y6AyVKP0sjujr22HWD7vMTSfwUPH61YSI8qaUa8P+/BTFP3pwYZK6gIs9JSm4xrVoJ7E1NKZtahJWznA49XvTkfy6YqiPJhVKSNO2wT4Pci/MICKHphJ2AY1xWe5wtqpZIsI9Ec662FamnQXpujgTXoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767664042; c=relaxed/simple;
	bh=lVBqusKPZZ/1nwmuQ7qndyCqUkSFP3t4BKwDvC/Od4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOsGq74HNKuAaFm9ygjih1ikJdkwUOq/07z3ydssBUiX52uKuwHX1/ClO3wdvoGkw98odmUy+6FEycY9Y2gbPAovSOR0EZ/sPxxzLm8PibH/twtB0zVkqYDjIEaKUdnSlutFvxChEIGFUUEWRHH95PUdr6oB223WE83UR/6wjAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=UHUpsDMd; arc=none smtp.client-ip=202.108.3.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1767664038;
	bh=nmat42RkEPb/07NoBwPDgmj1owQJJNwq2Dpwdkc1oo4=;
	h=From:Subject:Date:Message-ID;
	b=UHUpsDMdqDULCC7AxiFsYVwHdGEmArG0LRCy7q5f/EKBaL5bToZbfreI/EPO0pM/H
	 NBtTTEQFnxN1Z5UJyfB6vn1rGtEr+32ZA4Jpm6W2mqBQyAQjHux3g+1GVPANmibHx2
	 KpAZjnj3wdwdAqOmoQgfNtizFDrTkU50nNZNFaZs=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.57.85])
	by sina.com (10.54.253.33) with ESMTP
	id 695C697C000069A9; Tue, 6 Jan 2026 09:46:39 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 3475526685328
X-SMAIL-UIID: C3AE74A8FD52404E938EAB30399424C8-20260106-094639-1
From: Hillf Danton <hdanton@sina.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: syzbot <syzbot+a9528028ab4ca83e8bac@syzkaller.appspotmail.com>,
	eperezma@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev
Subject: Re: [syzbot] INFO: task hung in vhost_worker_killed (2)
Date: Tue,  6 Jan 2026 09:46:30 +0800
Message-ID: <20260106014632.2007-1-hdanton@sina.com>
In-Reply-To: <20260105042045-mutt-send-email-mst@kernel.org>
References: <695b796e.050a0220.1c9965.002a.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 5 Jan 2026 04:22:37 -0500 "Michael S. Tsirkin" wrote:
> On Mon, Jan 05, 2026 at 12:42:22AM -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    349bd28a86f2 Merge tag 'vfio-v6.19-rc4' of https://github...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13ccf29a580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a94030c847137a18
> > dashboard link: https://syzkaller.appspot.com/bug?extid=a9528028ab4ca83e8bac
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a67222580000
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/47d669d196ca/disk-349bd28a.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/f856a256a5eb/vmlinux-349bd28a.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/0f8e3de3614b/bzImage-349bd28a.xz
> > mounted in repro #1: https://storage.googleapis.com/syzbot-assets/3eec5fbffba2/mount_0.gz
> > mounted in repro #2: https://storage.googleapis.com/syzbot-assets/c9eff1484b09/mount_6.gz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+a9528028ab4ca83e8bac@syzkaller.appspotmail.com
> > 
> > INFO: task vhost-7617:7618 blocked for more than 143 seconds.
> >       Not tainted syzkaller #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > task:vhost-7617      state:D stack:29600 pid:7618  tgid:7593  ppid:5977   task_flags:0x404440 flags:0x00080000
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5256 [inline]
> >  __schedule+0x149b/0x4fd0 kernel/sched/core.c:6863
> >  __schedule_loop kernel/sched/core.c:6945 [inline]
> >  schedule+0x165/0x360 kernel/sched/core.c:6960
> >  schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7017
> >  __mutex_lock_common kernel/locking/mutex.c:692 [inline]
> >  __mutex_lock+0x7e6/0x1350 kernel/locking/mutex.c:776
> >  vhost_worker_killed+0x12b/0x390 drivers/vhost/vhost.c:476
> >  vhost_task_fn+0x3d1/0x430 kernel/vhost_task.c:62
> >  ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> >  </TASK>
> > 
> > Showing all locks held in the system:
> > 1 lock held by khungtaskd/32:
> >  #0: ffffffff8df41aa0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
> >  #0: ffffffff8df41aa0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
> >  #0: ffffffff8df41aa0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
> > 2 locks held by getty/5579:
> >  #0: ffff88814e3cb0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
> >  #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x449/0x1460 drivers/tty/n_tty.c:2211
> > 1 lock held by syz-executor/5978:
> >  #0: ffffffff8df475f8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:311 [inline]
> >  #0: ffffffff8df475f8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x2b1/0x6e0 kernel/rcu/tree_exp.h:956
> > 2 locks held by syz.5.259/7601:
> > 3 locks held by vhost-7617/7618:
> >  #0: ffff888054cc68e8 (&vtsk->exit_mutex){+.+.}-{4:4}, at: vhost_task_fn+0x322/0x430 kernel/vhost_task.c:54
> >  #1: ffff888024646a80 (&worker->mutex){+.+.}-{4:4}, at: vhost_worker_killed+0x57/0x390 drivers/vhost/vhost.c:470
> >  #2: ffff8880550c0258 (&vq->mutex){+.+.}-{4:4}, at: vhost_worker_killed+0x12b/0x390 drivers/vhost/vhost.c:476
> > 1 lock held by syz-executor/7850:
> >  #0: ffffffff8df475f8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:343 [inline]
> >  #0: ffffffff8df475f8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x36e/0x6e0 kernel/rcu/tree_exp.h:956
> > 1 lock held by syz.2.640/9940:
> > 4 locks held by syz.3.641/9946:
> > 3 locks held by syz.1.642/9954:
> > 
> > =============================================
> > 
> > NMI backtrace for cpu 0
> > CPU: 0 UID: 0 PID: 32 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
> >  nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:113
> >  nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
> >  trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
> >  __sys_info lib/sys_info.c:157 [inline]
> >  sys_info+0x135/0x170 lib/sys_info.c:165
> >  check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
> >  watchdog+0xf95/0xfe0 kernel/hung_task.c:515
> >  kthread+0x711/0x8a0 kernel/kthread.c:463
> >  ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> >  </TASK>
> > Sending NMI from CPU 0 to CPUs 1:
> > NMI backtrace for cpu 1
> > CPU: 1 UID: 0 PID: 5961 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> > RIP: 0010:wq_watchdog_touch+0xb4/0x160 kernel/workqueue.c:7654
> > Code: d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 e2 ba 9b 00 49 c7 c6 78 52 80 92 4c 03 33 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 <74> 08 4c 89 f7 e8 b2 bb 9b 00 49 89 2e eb 18 e8 88 9a 35 00 48 8d
> > RSP: 0018:ffffc90003157480 EFLAGS: 00000046
> > RAX: 1ffff110170e484f RBX: ffffffff8d9aedd8 RCX: ffff88807d8b9e80
> > RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000008
> > RBP: 0000000100002ff4 R08: ffff888022760237 R09: 1ffff110044ec046
> > R10: dffffc0000000000 R11: ffffffff8b583250 R12: 00000000000036b0
> > R13: 0000000100002326 R14: ffff8880b8724278 R15: dffffc0000000000
> > FS:  0000555582bd2500(0000) GS:ffff888125f1f000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000000 CR3: 0000000077fb2000 CR4: 0000000000350ef0
> > Call Trace:
> >  <TASK>
> >  touch_nmi_watchdog include/linux/nmi.h:149 [inline]
> >  wait_for_lsr+0x16a/0x2f0 drivers/tty/serial/8250/8250_port.c:1968
> >  fifo_wait_for_lsr drivers/tty/serial/8250/8250_port.c:3234 [inline]
> >  serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:3257 [inline]
> >  serial8250_console_write+0x1301/0x1b60 drivers/tty/serial/8250/8250_port.c:3342
> >  console_emit_next_record kernel/printk/printk.c:3129 [inline]
> >  console_flush_one_record kernel/printk/printk.c:3215 [inline]
> >  console_flush_all+0x713/0xb00 kernel/printk/printk.c:3289
> >  __console_flush_and_unlock kernel/printk/printk.c:3319 [inline]
> >  console_unlock+0xbb/0x190 kernel/printk/printk.c:3359
> >  vprintk_emit+0x47b/0x550 kernel/printk/printk.c:2426
> >  _printk+0xcf/0x120 kernel/printk/printk.c:2451
> >  __nilfs_msg+0x349/0x410 fs/nilfs2/super.c:78
> >  nilfs_segctor_destroy fs/nilfs2/segment.c:2798 [inline]
> >  nilfs_detach_log_writer+0x697/0xa30 fs/nilfs2/segment.c:2882
> >  nilfs_put_super+0x4d/0x150 fs/nilfs2/super.c:509
> >  generic_shutdown_super+0x135/0x2c0 fs/super.c:643
> >  kill_block_super+0x44/0x90 fs/super.c:1722
> >  deactivate_locked_super+0xbc/0x130 fs/super.c:474
> >  cleanup_mnt+0x425/0x4c0 fs/namespace.c:1318
> >  task_work_run+0x1d4/0x260 kernel/task_work.c:233
> >  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
> >  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
> >  exit_to_user_mode_loop+0xef/0x4e0 kernel/entry/common.c:75
> >  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
> >  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
> >  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
> >  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
> >  do_syscall_64+0x2b7/0xf80 arch/x86/entry/syscall_64.c:100
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7efe38790a77
> > Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
> > RSP: 002b:00007ffc337cbd88 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> > RAX: 0000000000000000 RBX: 00007efe38813d7d RCX: 00007efe38790a77
> > RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffc337cbe40
> > RBP: 00007ffc337cbe40 R08: 0000000000000000 R09: 0000000000000000
> > R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffc337cced0
> > R13: 00007efe38813d7d R14: 0000000000067345 R15: 00007ffc337ccf10
> >  </TASK>
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > 
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> > 
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing.
> > 
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> > 
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> > 
> > If you want to undo deduplication, reply with:
> > #syz undup
> 
> 
> Yea well
> 
> static void vhost_worker_killed(void *data)
> {
>         struct vhost_worker *worker = data;
>         struct vhost_dev *dev = worker->dev;
>         struct vhost_virtqueue *vq;
>         int i, attach_cnt = 0;
>         
>         mutex_lock(&worker->mutex);
>         worker->killed = true;
>         
>         for (i = 0; i < dev->nvqs; i++) {
>                 vq = dev->vqs[i];
>         
>                 mutex_lock(&vq->mutex);
>                 if (worker ==
>                     rcu_dereference_check(vq->worker,
>                                           lockdep_is_held(&vq->mutex))) {
>                         rcu_assign_pointer(vq->worker, NULL);
>                         attach_cnt++;
>                 }
>                 mutex_unlock(&vq->mutex);
>         }
>         
>         worker->attachment_cnt -= attach_cnt;
>         if (attach_cnt)
>                 synchronize_rcu();
>         /*
>          * Finish vhost_worker_flush calls and any other works that snuck in
>          * before the synchronize_rcu.
>          */ 
>         vhost_run_work_list(worker);
>         mutex_unlock(&worker->mutex);
> }
> 
> 
> taking vq mutex in a kill handler is probably not wise.
> we should have a separate lock just for handling worker
> assignment.
> 
Better not before showing us the root cause of the hung to
avoid adding a blind lock.

