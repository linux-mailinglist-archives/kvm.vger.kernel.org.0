Return-Path: <kvm+bounces-44794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24711AA1029
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46CB91BA1722
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FECB22257E;
	Tue, 29 Apr 2025 15:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/sWUE/4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE572222C4
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745939711; cv=none; b=Dx+13aTB1zXfCQRNI66aJMyNNTO6axf5FXIHOceSNPIxMiQv645VwaVicGMXykFT5SV5NTo6k4LGC/C2T6ixP9Q5jOEL71C6OGzMvjRgfMMH4NeCp/4Oayjw05qcn5yJTxDoDDtcTCSzCpeBKxtJkflspSZ/mNyLrePhbSUQuQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745939711; c=relaxed/simple;
	bh=VUFejSUO7HiiNKG9R1Cq6h5pV0SUE+e2PHWS5BKf674=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M5c4HD5JWxogb9PecR2r9po4HWf5TSbPCNjAryiv71fftiNd3DMjc27UFG+kaRCyn0Xw/XrF6e6P+Ut5jnmXbrp/tv0LmuQRDVtaZL1SxcUvuuecSAHxKnng4RabIPsJxfvPaUIEjbr8UnicS7CH+ZUmPp8QuA5xLro/kOzUICs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/sWUE/4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFD2FC4CEF5
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745939710;
	bh=VUFejSUO7HiiNKG9R1Cq6h5pV0SUE+e2PHWS5BKf674=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=m/sWUE/42bL8PA5LB0mRfUTH9FxIKDm6uIYf2uyfju86BRh5jjNrXfJSNRlQMGhYS
	 gaE38dA3I4jrw3dis0oNbFE4a6xvaDBpYlCup/EOenw1IYFBoMZhF5tsYRyUyFZ8wM
	 o2UeJEeKKXn+lCIj9k/S+88ClyKNQunFDckfqMqQZVnEm3Rla6YJsU+N1zPdsHjrV4
	 uuJAoOG6A6DcKH/GHofetCFe+Us7j1J1zZFXohqG5MFQSYKrSQmv0/YdAW0xq9RIZ3
	 R4ShijKqeysaZzBXd/CME0H4E7yGzc1D6GPaQtC35sTrZXwsGGzeaz3YIARJaxtSSs
	 mP/amGuVpxkJw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C988AC53BC7; Tue, 29 Apr 2025 15:15:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 15:15:10 +0000
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
Message-ID: <bug-220057-28872-9EeF1sLtSc@https.bugzilla.kernel.org/>
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

--- Comment #28 from Alex Williamson (alex.williamson@redhat.com) ---
Another option may be to set the cpu as "cpu: kvm64" which is the default. =
 I
noted somewhere this should present a 40-bit physical address space, which
might be close enough.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

