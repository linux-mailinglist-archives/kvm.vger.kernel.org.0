Return-Path: <kvm+bounces-4974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 190D481AE27
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 05:53:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B01C9B2515D
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 04:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D788F77;
	Thu, 21 Dec 2023 04:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EvOvlB34"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22EF8F52
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 04:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19865C433C8
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 04:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703134383;
	bh=kDk0qY0VAE1/kRIzvN4GE4tVBgE46kv1PYH38qjgqow=;
	h=From:To:Subject:Date:From;
	b=EvOvlB34aSPJZVm3YtD+SwzpRmqVZ6Jch+k+D5DH8V1oTolFtIP3qppM3A0Xyvz+5
	 DQuwFm0HjsmzynAPGjaymXVlLZUfTv6046VUFBykJQ91x0ZdkE5zc1rjM2q++O6wmX
	 tOpME9va86GNZyoNjaM4IhQav4PByFPoYHRF7CKBFYFo+B/YRR0euVTD9K3fsQPhey
	 m97wbalCdGclQK6swnC9zPI6czZapncMKYW0zwAbxDdB2mI02r7NwXx0kwfi2Xmkvk
	 XWlLnJGNQ2HhUXs4AND0udcnJsxHhQ+XheNmAZPEm/DFY+Z+OqpcWAyT50KFriQJPS
	 S2wxDgEL4T2HQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 00F85C53BD2; Thu, 21 Dec 2023 04:53:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218297] New: Kernel Panic and crash
Date: Thu, 21 Dec 2023 04:53:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: awaneeshkmr@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218297-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 218297
           Summary: Kernel Panic and crash
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: awaneeshkmr@gmail.com
        Regression: No

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
=E2=80=A6
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

