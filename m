Return-Path: <kvm+bounces-44793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A84AA100D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7781176C86
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701F521D3FD;
	Tue, 29 Apr 2025 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nclgYA97"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A74C40C03
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745939393; cv=none; b=FtWdQvLvGT9ZJWnSe6oedkBsfM7qEoJfN6EaQjidgoManatEb/ih1W9E6051Ko31Qr3kWsoyCFaMPEp2ZnTe0nLAV4rDza8rVwUaSN9fx5Jq2IFfR23o1ah5WJSQNVA9Qq7FtqHomUcMSc1kew5XEKkYN0pHop3B+0/43mkhk4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745939393; c=relaxed/simple;
	bh=MtV+iztLz/NY1L4gUBsYeU7+UciAgrlBZCsnyxxWHZk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i2ACitZaBHXF4H6n9i7wPUbhyyL658HfHrvTOH3b62D1RA0Lk5yawzCRAeX8HF0pYXGYzFOt8fpjFbIVPJumdPGlkNVmR3RTGBi5U9BhivR8YRXt1hiDv0hSz3nFibLrfvVCps40jJ0sBtF7zwgmTQdPE94r7irMKphL1sUpMUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nclgYA97; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EFE8C4CEED
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745939393;
	bh=MtV+iztLz/NY1L4gUBsYeU7+UciAgrlBZCsnyxxWHZk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nclgYA97P7ruuqMY2tk6YGsBP2EswWNbZC8lCUeRMB+dPsFNMc9sei5MyOBsdsMOq
	 xG9d2SbguViWsr0KyjrAWsuXho8M+d8BmTtWAxXJUg2R9YaGKP3jMPGsSJAtNSm+Gl
	 IT0IfseCnmfSE5EOatBqOAsP9MNMxGAcupAU4DfriwGzGo4bcDBWpDzUI8F36bZ/xy
	 8hNDuqERLtWk4OzwImpsi2CClIGj+xXYY7+eqPrTXVWzs4m3O6MTGP2b/xR43kSZpc
	 rV0OPobdOu5AK29rb/F7Hc+wCOKwZn/bTFrP9WGw5nUoHFi8ib5F4RczKkXGO8wZsC
	 slptSCvLWLqVA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 00047C41614; Tue, 29 Apr 2025 15:09:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 15:09:52 +0000
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
Message-ID: <bug-220057-28872-N5DiSZBcLe@https.bugzilla.kernel.org/>
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

--- Comment #27 from Adolfo (adolfotregosa@gmail.com) ---
(In reply to C=C3=A9dric Le Goater from comment #25)
> "-cpu host,guest-phys-bits=3D39" should help to define compatible address
> spaces.
> Could you try please ?

vm 200 - unable to parse value of 'cpu' - format error
guest-phys-bits: property is not defined in schema and the schema does not
allow additional properties

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

