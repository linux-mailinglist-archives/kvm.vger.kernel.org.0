Return-Path: <kvm+bounces-33985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEAD9F5561
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 19:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FF59188AE12
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 17:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E84D1F893B;
	Tue, 17 Dec 2024 17:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rAhM3LEZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B711F8902
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734457860; cv=none; b=BNt4Sw0E8PrnFHeopogh9gELSJonEzDSYkVPkyMkkofuS7+q3RX7BdCmFduTUid5VpL0e+AUbdQzf20PHf3RQY9pCaXRstsijhufV9TobQ/jZYHVL6V0T1dAieKco/pzeIhb/MK0hXLqi/3LfUJsv/QvVA+fAXOpa2dnOnZpvTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734457860; c=relaxed/simple;
	bh=CXcGWZWCBUfXRPNEwYazUIuMrSoGf6QKgEo+Meuz0b8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e0ZJ+l9VRYGEP8B3Sgd41uo02J6yTOntGunGzoT5Hz17qqDP5LDq0sVBsaQGQLkx0pOeQPShv0DXRCr0xvOcY/qvEA5IeNCSSgxvT5NP3Uo870iLxWNcCOiOoFZ9R9hEAkg56pjxTcTs93Q+qTdlJDYbg6UPYox3woKJ2mM65NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rAhM3LEZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B81EAC4CEE0
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 17:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734457859;
	bh=CXcGWZWCBUfXRPNEwYazUIuMrSoGf6QKgEo+Meuz0b8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rAhM3LEZCgODfakp8YMi3kvI3odYGTQ9rZnwk2T/LcJ/UCC0vfg3rZqbsLYun3F/M
	 34+q/d17l8zkrlTQ2wOvmdHflBqJTlppBBE8MNibe7uapWFI5rF02N3P7pNnBahALC
	 GEBNLZOb8/5jBMWOc/+YquUIu64IE1moNS72wtyZngz2jsHakFGzgZABYPu8P/U9Py
	 wrPUtW+idOgqdzluBfVvpY+3yZjHzZeaaLymOmDWFw9B9JtbA58oX8CA4LaSpFL3vX
	 67WeZ5Gpid9FzusKfy0Lcs5aAFBrgePSgR/fQLt3E6b7ctXU54LKQJvxptHt/gFt7H
	 5bCCK86CnVcRA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AF534C41614; Tue, 17 Dec 2024 17:50:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219602] By default kvm.enable_virt_at_load breaks other
 virtualization solutions
Date: Tue, 17 Dec 2024 17:50:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: acmelab@proton.me
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219602-28872-W7n2wWgZ6r@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219602-28872@https.bugzilla.kernel.org/>
References: <bug-219602-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219602

Pinky (acmelab@proton.me) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--- Comment #4 from Pinky (acmelab@proton.me) ---
(In reply to Sean Christopherson from comment #3)
> FWIW, Paolo and I do want to get to a state where out-of-tree hypervisors
> don't need to do weird things, but it'll take some time to get to that st=
ate.
>=20
> https://lore.kernel.org/all/ZwQjUSOle6sWARsr@google.com

Thanks for the longer explanation (including the link's content). Given that
this was discussed already, I am going to close this then.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

