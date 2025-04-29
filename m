Return-Path: <kvm+bounces-44800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F26EAA1069
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:26:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F38C1B661C8
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB99221703;
	Tue, 29 Apr 2025 15:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UexgQLl+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8907221555
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745940361; cv=none; b=ORLIh3j4VNv+D0SOxt2jGG1Q0juYCwpObzXLeqBBjt3ChxUjf+RHz4KwisLyMcXL1p4JJQbdXa4X4c7WqV/hfxIdMWOXzoq/tT+MVMqC9a5/fqwEUAEYouaTHTeSAc6OgGO6g3S3UhmXZtC1JjBhIzjwZy1u9ig3mMWhbl0tTM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745940361; c=relaxed/simple;
	bh=iPPS59ubPgYRAGxhM20ubQpCZvgP540nQs22zPDK6Lk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HYIITamCEaMpqE17fgF6ko4dCrR3nFMNyASwoDBwlyixYrYZizV4vDmBdEU7Jgw8dszad2u+AeAMT/nk+Pgkx8A74h7R6zeqwTCQhm3cVz6BQLC9hWtyIdFUReUI9W7k5aXGOMH/TiqXEvoANjybRL4XfTOU4cQdg6tKyv9e60M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UexgQLl+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 507DFC4CEF1
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745940360;
	bh=iPPS59ubPgYRAGxhM20ubQpCZvgP540nQs22zPDK6Lk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UexgQLl+z/aSxN3Qkgoq+KA7xa6RVKOb82XPECFR1ml1omo+gDRuESEQbSr2xLt+Z
	 +/OJtHLNw+mPuFY8r6qvLg1vFyna2Rnq4LUZC5sDIWnxCJEkOnoIQgZcsnlaIq9I6W
	 MHRLGjTmUKlgrapva0wQig50u+VAIKJf5U7xCZoBb5GbdmSBLpMOi1i5tOOf/jATlq
	 G8fV2VL+3bsWtnbtd53MuGQkWeGQvEeaHJ/VuAyd/h1bOAYZSwnXIlT0fo+D3iG7h0
	 0upS4WoZIXRFjwzzIO0EHH73GVeQPAbLaFxH0jIY6FCSwRz30xhAfWI2ll5HXsbDJj
	 SFbBfU3T7pf6g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 49463C53BC5; Tue, 29 Apr 2025 15:26:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 15:25:59 +0000
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
Message-ID: <bug-220057-28872-XvixHGqVJ4@https.bugzilla.kernel.org/>
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

--- Comment #31 from Adolfo (adolfotregosa@gmail.com) ---
(In reply to Alex Williamson from comment #30)
> (In reply to Adolfo from comment #29)
> > (In reply to Alex Williamson from comment #28)
> > > Another option may be to set the cpu as "cpu: kvm64" which is the
> default.=20
> > > I noted somewhere this should present a 40-bit physical address space,
> > which
> > > might be close enough.
> >=20
> > If I recall correctly, cpu must be set to 'host' for nvidia gpu passthr=
ough
> > to work. That said, I would still prefer to keep the CPU set to 'host'.
>=20
> kvm64 works just fine with NVIDIA GPU assignment to a Linux guest for me.

I just tested it remotely. VM will not even start.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

