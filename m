Return-Path: <kvm+bounces-6718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAAB38386B3
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 06:23:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BB4128559F
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 05:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B243D0A4;
	Tue, 23 Jan 2024 05:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="usLlKCoP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131B93BB21
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 05:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705987400; cv=none; b=NoG/rQKsEpP1IAmhGE/3wb3EbNSVmPIJrzcHrTgLu86vFrRlJX3hyraeQ4EV/bRxYIcUjaNa9Gck8PJgjyI4CgpzCXXU8MaReZn1EmGXsEqxNuV1HPn5sNHc3H4O/0F1gCHIPNRPD3aaSvGs096RbSENBEsBpY6P+pm4uYNVA7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705987400; c=relaxed/simple;
	bh=s4OWTO0eW7MmisXq2K5uiEgYuPTLFlqWrEEGhlGKGfM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fPrt6RH+43/HIA5eRYQxAAkk2HiOolDL8j6Txaetiut9tdwkXr2L6X5LLZdKzAISKfcXytkD54bKVhmd1neY4/kZ5xwsMCAsgi8homiiAhnDJlUsonnVN/L0LGyAKOcdquWusC/15D7zGWFcrjDcVw1id63sIh4vVQtZW06Nl9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=usLlKCoP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8754BC43399
	for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 05:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705987399;
	bh=s4OWTO0eW7MmisXq2K5uiEgYuPTLFlqWrEEGhlGKGfM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=usLlKCoPrfO7k2ArYt/wbSMgVEHFrCU+r5qytoJigFCLD5oQUCXWle+/Xahzuoshy
	 +tBSXvGCmKIUwYimj3E/Mf+f118j/BCwZJ7Hru1x0U0sa8GdTZzMZEzyn9T47ehmwz
	 IJkgeENakFoTbn0V8qL8D7n9M2UK7eQNoEODBLN6K3B4ZQiDgGIyN3kTj4K7s2Z4ZF
	 fm7pGFTMc3aoBjC4iJRbUhRg7wTHhkSKilaN85XIEnLOBE0ZKpAAlchT0SW+XWAJZm
	 x49ar1fcLvFbCxkjhe7zmYmJJB670ZqZXBiK1eBy8BxnSSClK03w0UhdLvoVTli5Tp
	 5vsMlC3caN8SA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 77174C53BCD; Tue, 23 Jan 2024 05:23:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218297] Kernel Panic and crash
Date: Tue, 23 Jan 2024 05:23:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: caiyxu@cisco.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218297-28872-gUSOz3Vghh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218297-28872@https.bugzilla.kernel.org/>
References: <bug-218297-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218297

--- Comment #4 from Cai (caiyxu@cisco.com) ---
Attaching call trace here for reference. Appropriate any thoughts.


[    1.299570] --> Failed to ioremap(405798912, 215625728)
[    1.300415] --> Failed to map header
[    1.301002] BUG: kernel NULL pointer dereference, address: 0000000000000=
3f8
[    1.301994] #PF: supervisor read access in kernel mode
[    1.301994] #PF: error_code(0x0000) - not-present page
[    1.301994] PGD 0 P4D 0
[    1.301994] Oops: 0000 [#1] PREEMPT SMP PTI
[    1.301994] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W=20=20=20=
=20=20=20=20=20
5.4.244-staros-v3-scale-64 #1
[    1.301994] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
[    1.301994] RIP: 0010:del_gendisk+0x12/0x2b0
[    1.301994] Code: ff ff eb ee 48 c7 c0 ed ff ff ff eb e5 48 c7 c0 ea ff =
ff
ff c3 0f 1f 00 0f 1f 44 00 00 41 55 41 54 55 53 48 89 fb 48 83 ec 18 <48> 8=
3 bf
f8 03 00 00 00 74 39 e8 bf fe ff ff 48 c7 c7 00 54 2b 8e
[    1.301994] RSP: 0000:ffffac188001fdf0 EFLAGS: 00010286
[    1.301994] RAX: 00000000fffffff7 RBX: 0000000000000000 RCX:
ffffffff8e247d38
[    1.301994] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[    1.301994] RBP: ffffffffffffffff R08: 00000000000001f6 R09:
0000000000000027
[    1.301994] R10: 0000000000000000 R11: ffffac188001fd45 R12:
0000000000000000
[    1.301994] R13: ffffffff8e70964c R14: 0000000000000000 R15:
ffffffff8e035eee
[    1.301994] FS:  0000000000000000(0000) GS:ffffa4229f800000(0000)
knlGS:0000000000000000
[    1.301994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.301994] CR2: 00000000000003f8 CR3: 000000001820a001 CR4:
00000000001606f0
[    1.301994] Call Trace:
[    1.301994]  ? __die+0x86/0xc8
[    1.301994]  ? no_context+0x15a/0x330
[    1.301994]  ? async_page_fault+0x34/0x40
[    1.301994]  ? do_early_param+0x8b/0x8b
[    1.301994]  ? del_gendisk+0x12/0x2b0
[    1.301994]  ? _raw_spin_unlock+0xa/0x20
[    1.301994]  ? __close_fd+0x88/0xa0
[    1.301994]  ? do_early_param+0x8b/0x8b
[    1.301994]  device_exit+0x37/0x2e0
[    1.301994]  ? image_proc_virt_read_try_part.part.7.cold.18+0x48/0x48
[    1.301994]  ? do_early_param+0x8b/0x8b
[    1.301994]  device_init+0x3ed/0xc34
[    1.301994]  ? image_proc_virt_read_try_part.part.7.cold.18+0x48/0x48
[    1.301994]  ? do_early_param+0x8b/0x8b
[    1.301994]  do_one_initcall+0x3c/0x210
[    1.301994]  ? do_early_param+0x8b/0x8b
[    1.301994]  ? do_early_param+0x8b/0x8b
[    1.301994]  kernel_init_freeable+0x1bd/0x249
[    1.301994]  ? rest_init+0xb9/0xb9
[    1.301994]  kernel_init+0xa/0x107
[    1.301994]  ret_from_fork+0x24/0x30
[    1.301994] Modules linked in:
[    1.301994] CR2: 00000000000003f8
[    1.301994] ---[ end trace ed4a0af627b03b12 ]---
[    1.301994] RIP: 0010:del_gendisk+0x12/0x2b0
[    1.301994] Code: ff ff eb ee 48 c7 c0 ed ff ff ff eb e5 48 c7 c0 ea ff =
ff
ff c3 0f 1f 00 0f 1f 44 00 00 41 55 41 54 55 53 48 89 fb 48 83 ec 18 <48> 8=
3 bf
f8 03 00 00 00 74 39 e8 bf fe ff ff 48 c7 c7 00 54 2b 8e
[    1.301994] RSP: 0000:ffffac188001fdf0 EFLAGS: 00010286
[    1.301994] RAX: 00000000fffffff7 RBX: 0000000000000000 RCX:
ffffffff8e247d38
[    1.301994] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[    1.301994] RBP: ffffffffffffffff R08: 00000000000001f6 R09:
0000000000000027
[    1.301994] R10: 0000000000000000 R11: ffffac188001fd45 R12:
0000000000000000
[    1.301994] R13: ffffffff8e70964c R14: 0000000000000000 R15:
ffffffff8e035eee
[    1.301994] FS:  0000000000000000(0000) GS:ffffa4229f800000(0000)
knlGS:0000000000000000
[    1.301994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.301994] CR2: 00000000000003f8 CR3: 000000001820a001 CR4:
00000000001606f0
[    1.301994] Kernel panic - not syncing: Attempted to kill init!
exitcode=3D0x00000009
[    1.301994] Kernel Offset: 0xc000000 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffffbfffffff)
[    1.301994] ---[ end Kernel panic - not syncing: Attempted to kill init!
exitcode=3D0x00000009 ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

