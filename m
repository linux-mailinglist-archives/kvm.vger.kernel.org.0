Return-Path: <kvm+bounces-44613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BF3A9FD07
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 00:28:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB7313B89F7
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 22:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6E821147C;
	Mon, 28 Apr 2025 22:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIVUp6sO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B6F15ECD7
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745879276; cv=none; b=OH8kxPmsvl0NYF0np5ZmNU21xBoTJr5hasSp0LHM8NmAv0DrBP4ZgXQM2mqkAgFVPdQevoGRp1VDzKraVHZLzI96YPBj0+1OXi3/81K+g5bbpVlX/N5mNX+fZIojcoUto/FbG1U0ZiU00SKbreowSXWARivXabRc+IUvzMtgJQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745879276; c=relaxed/simple;
	bh=Ly9AKoRQ6SsJwPZVfnhxq6Vym+HWGgC2VtsmbfJOPS4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sDWDJuPmNDgG7viFzlfyOmOh8KNeKOvVyfu+W6F0IRtkKs7qMN7ug8AKpJyg5cfIkPNA8cFPiGLLXVk/okGBq9Q1SXaVX4uhQ1zkYpXHxiE0+ceeczVGJUfSxOijKMKM8N6Ph3bdJJ8e1FUTn2UHgni9ZyvLiyugLrx3ZhB6LJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIVUp6sO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFCDDC4CEED
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745879275;
	bh=Ly9AKoRQ6SsJwPZVfnhxq6Vym+HWGgC2VtsmbfJOPS4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nIVUp6sOxu9mJUjEicXGLXS3y50WXPBVKPrXcOugX9eAHOrXugwqtxWR+ASJzJb6d
	 dmAShpLTRLplrfWpQmSPv8dDlerCaUJ7xGRS98ftZ54Q7GLMi724Pb7d1Jdh0kO3W9
	 l6UtNVfS3Cx9S5qVVkpQ40QrZmBNi8QykeY1M+O3DXBFyza7eyNy8jbIvpFQ6snnf1
	 tRUOhvYXYmIymBUFStm/NHI37h2eIxaszWgF9y7yCliR3/mSL2z5NhehfrAmU8EdA4
	 wLvzhbc4UPryFxEs7A/aIjdS7+jTchMf+j5Nc1qO2FnytpLTMuOu6/l0/9lAcWvijV
	 LmUXzVtGOMhoQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A155FC53BC5; Mon, 28 Apr 2025 22:27:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 22:27:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: adolfotregosa@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-BJSPrJof9k@https.bugzilla.kernel.org/>
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

--- Comment #16 from Adolfo (adolfotregosa@gmail.com) ---
(In reply to Alex Williamson from comment #15)
> (In reply to Adolfo from comment #14)
> > Created attachment 308045 [details]
> > vfio_map_dma failed
> >=20
> > I forgot. I have no idea if this is even remotely linked but I'll leave=
 it
> > here just in case.
> >=20
> > host journalctl: vfio_map_dma failed.
>=20
> Does adding ",phys-bits=3D39" to the cpu: line in the config file resolve
> these errors?  Please include output of lscpu.

Doesn't seam to do anything, no.

----
cores: 8
cpu: host,flags=3D+pdpe1gb,phys-bits=3D39
cpuunits: 200
efidisk0: local-lvm:vm-200-disk-0,efitype=3D4m,pre-enrolled-keys=3D1,size=
=3D4
...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

