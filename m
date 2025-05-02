Return-Path: <kvm+bounces-45275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F8FAA7C6C
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 00:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 566165A3D03
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 22:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D84021ABC3;
	Fri,  2 May 2025 22:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAJGuw0A"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76656EB79
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 22:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746226349; cv=none; b=h58oBuUGo+ZzcTjdk+l3XPw4eNdlImdGvaaaIwF8tyln+GSlI+IH+rF52O5eyRt74GXXrXfOIpsqsQ2gMaXDywQrwS0n+6lYsebfaGXUGt7SMfil8Nn3L1Ci2zVOMWo10RDr11vsLCjWXsM6KKfdQAs5ErWxGHwOGNznfDPEP/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746226349; c=relaxed/simple;
	bh=dx+XwUq3S8J5namoFEi4PJ8NOWQKrIvWCuj1Op35jUc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bajwQtxGCUPKIcWZ6ZSyLJncRIp/y9SXBvbuL4jXr9uqowT6Vv2grOCYZnc8JhTjVqv604rgAEZVBgEy1ZTeD2n7Om03TtslwQJ59RS1eaaFU7kmZFEIIKtghd5b9NfkXoejBUFFcgvGfpeuGJMKIhs/vkM2bnQjCWaYfznDko4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAJGuw0A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DDADC4CEF2
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 22:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746226349;
	bh=dx+XwUq3S8J5namoFEi4PJ8NOWQKrIvWCuj1Op35jUc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YAJGuw0AMXBBNyk+yhCyqonvt8zgdKJwYpCJ8pI3sqD+znlo7yfsBZSwQiTckB1Pa
	 +D422CBgWKgAcd1mJMjoiP8tcMNItR+qByBotlEuy4vgj08MHrsR+GsK3bS9L7si8Y
	 T2xWJxatDQiDf7fpsX/NBhkSuQunmyYiNw7FXS+8VYEbDfo3KPT2q4Hv+i2o7hmVJD
	 OXIwlECnqs5uOlnLpCVYbr6t2UlTsNgfO3p+kNQLl0dLI8i0KL/3WmV2bSLjBf+DQq
	 LsyQeSMdUhLQgWmLq6hofK/kxO0Timff259kCpMUg5SDohnAzb+3hKwKV+BpGyvNQC
	 365nwZ7hBkrQQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 07755C53BC5; Fri,  2 May 2025 22:52:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Fri, 02 May 2025 22:52:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-1sWVB9j6gI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #46 from Alex Williamson (alex.williamson@redhat.com) ---
Thanks for the prompt testing, I've posted the fix without the debug logging
here:

https://lore.kernel.org/all/20250502224035.3183451-1-alex.williamson@redhat=
.com/

Pending reviews and comments, I'll try to get it in for v6.15 for backport =
to
stable trees.

The VFIO_MAP_DMA failures are a VM configuration error and a byproduct that
Intel ships platforms where the CPU physical address width is different from
the IOMMU address width.  QEMU/vBIOS defines the MMIO layout relative to the
CPU address width, therefore the vCPU needs to reflect that address width
restriction.  QEMU makes this configuration available though a guest_phys_b=
its
option, but it doesn't appear that Proxmox provides a way to configure this=
.=20
The result is these error logs, which indicate P2P DMA mappings are not bei=
ng
created.  With the fix we're pursuing above, this should not result in a
performance/efficiency loss relative to the page table use though.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

