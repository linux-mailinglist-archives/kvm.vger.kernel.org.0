Return-Path: <kvm+bounces-45118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FBDAA60A5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:22:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5E097B4BCA
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAD5201031;
	Thu,  1 May 2025 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmwGEQDo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952001A08B8
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112914; cv=none; b=iC4tyDhS8+18K39Ohb7OhvvKhwKj5uRRsHHd5DxVM3EuheRx3u4e94dxz5PIODbnRGG8/OavzbKozKHts7lVCHxmdcdd80mkD6I9gGN7M/nq5bIez2HWjI0xfCURf8Q3d1SDb/AFZVAP7BJfPv4PqZkzxTTaP6FBuqBYrOV5bhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112914; c=relaxed/simple;
	bh=SBT7e2Y3qQPvgtjuaXgXogdbt601VDbBubWxQt6cjAw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LYmDcsod7jBtRPJ29yn9CiBsa5JoBOHtnjOVjSpz4LxOIQVQ7/shqwPItIqPfyE4njhXrGT2h0iGaOIpqqG/h1o6Gr0YEnX/FkneBTpM+Q4o5Co1/f1aiR2dG0RMrVsVo/wCHbfzhd7A0PzvNaXnPpuQsuneN3xtG9hKc9pvtZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UmwGEQDo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1BC6C4CEF2
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746112914;
	bh=SBT7e2Y3qQPvgtjuaXgXogdbt601VDbBubWxQt6cjAw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UmwGEQDoKFxdJFWrFa6p6yFZxznHONTOEE0kgCG7XIq1dL4I+QjDsvgmIwpSBw15N
	 sueybtjShyfC4CD2fT/F6M1Xjj9SJPoEk0r2crL03pnuokLgU2xhEXGaLmBdT7Q/Pk
	 tM+XPMlzGZj2w0tmtj9UZE2bLDsuAsf+rkfCbqa4h6xmUJiI94gvKZz8Yz2giDypLH
	 5tGr7HGKesm7lzmFHLxNCnjBPe2f9mVNmoAnPYB7qiU/qer+FaiQD8bLagw+UaPn3f
	 Yixdom9W7kAYJqAkXZzFzesOyTLmJRxIxj1BywJ9cK/Z1mvifLLTDu4X8s5UfrlbiX
	 1gRPs2FLV4f6Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ECA32C41612; Thu,  1 May 2025 15:21:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Thu, 01 May 2025 15:21:53 +0000
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
Message-ID: <bug-220057-28872-9rntRFfMSe@https.bugzilla.kernel.org/>
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

--- Comment #42 from Alex Williamson (alex.williamson@redhat.com) ---
If it's not a physical memory limit (I'm not able to reproduce even allocat=
ing
60 1GB hugepages on a 64GB host), it may be that proxmox is imposing cgroup
memory limits on the VM.  It still doesn't make sense to me how huge_fault
support could result in more memory used by the page tables though.  The
previous behavior is effectively the worst case scenario where the full dev=
ice
memory is mapped as ptes.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

