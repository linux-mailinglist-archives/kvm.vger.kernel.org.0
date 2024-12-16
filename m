Return-Path: <kvm+bounces-33847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0100A9F2CE2
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 10:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C0231884B70
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 09:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95824201100;
	Mon, 16 Dec 2024 09:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3lzmvYm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4151FFC6E
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 09:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734340960; cv=none; b=LH4emZnoxoep8QZnfSjjnX5v+XJ7k5lYq+nvLcGJOckj/Q8iMuBmOfpuYxG5ubEXhoGcYjl3OXoULsI7e/0+lJeWOmANZkGuaxJ/5bkq6GoE4O2wLxtN960GcINLkVMt44zOj1moK2zOvQvLSPcIuGDjjbjnV39HdIgM74Q8sEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734340960; c=relaxed/simple;
	bh=0YbztXg+uS7nE+smxjJ3yIA+JgXvXTIRM9za3d02Slw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NuBBQnue7qeIpegGpDfaM4J6O1xdtbjBvn4QWwtW7gtwBfwMfn4EjWEVPWSQ2aDGVo6AR3M4jOvt0n0cIg3AVClLwQqi9v6bz/AZJvyDiC4pBc94i9CYqqa31NfcGJgRl2x3PERYCBzYXRpTwEayH+o7+V5VfjLPBOGAS8PfHMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3lzmvYm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 385BFC4CEDD
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 09:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734340960;
	bh=0YbztXg+uS7nE+smxjJ3yIA+JgXvXTIRM9za3d02Slw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=X3lzmvYm1v+0PtDKTd/EzM44osdt72V9IYZY9yZHaX4f9IkNMnQ2NbvtyjXgcVdGM
	 iF0duVJjbruugqlxMe6MaE4miQSKag6m6YzPfkrEUt72gXBJVBERar7cn8v7M148Vh
	 bMphpiCDSb1eOIhfRBejPOS+Ftlsvx9pHj5VM6Ql7Ez8cfS7htRxlGjCBsv/4wXxHc
	 ozbnckKg6llyEq0QloJX5tmAimqQqItqrSIrMjJDP/tlwyXgo1V0EsqkNpZTFvm8ez
	 NweVe67krrtEbickx7j9JRhFYIB4Q9RzXQsmQBs+2EX0TtaO25M8amOPh+mxk/w+mN
	 3P1dlL5UReagA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2C73CC41614; Mon, 16 Dec 2024 09:22:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219602] Default of kvm.enable_virt_at_load breaks other
 virtualization solutions (by default)
Date: Mon, 16 Dec 2024 09:22:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: acmelab@proton.me
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_bisect_commit cf_kernel_version cf_regression
Message-ID: <bug-219602-28872-YNWHJIP8RR@https.bugzilla.kernel.org/>
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
 Bisected commit-id|                            |b4886fab6fb620b96ad7eeefb98
                   |                            |01c42dfa91741
     Kernel Version|                            |6.12
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

