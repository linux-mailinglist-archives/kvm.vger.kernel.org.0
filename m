Return-Path: <kvm+bounces-34461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9977E9FF597
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 03:37:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6341D16152E
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 02:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6339C9450;
	Thu,  2 Jan 2025 02:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UL82yR5K"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCDD184E
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 02:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735785423; cv=none; b=cqgP0FtHHkeF+wCpvN4cjXPifFlTYmCqRWMNGhJxM9fy5ViF/zRhgeOwqeyMNF8E1ycW5vekIbpLRoGGObQKQ6pr5rGaXSy1BKpmVoY/3eXRDV2whFLrckzAxJiRf71CSZl7H/zTrMcToG+74W4WuBdznx5n3FlPm88k1I0/sY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735785423; c=relaxed/simple;
	bh=J6PCaL1YSlEHtlSTy2pZX0hXSlVpw+hoikJ9ERxwIWc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J57Y+9UR3efLVPLC9GPDtAxf1yg6sH8chFH/x0VgP6jCyN+d8Smg8+VBTQBb5O9xdt5RuLaxasc0QrPei0KoDKUlFNAsvaG/DoCrMgTHWdIiespcvrzaA2Uq5+qaqQxBCNC3TWlgAUedP1XBJGBYmi4Rct+KWtqVC3oAPlaQ55k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UL82yR5K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1537DC4CEDD
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 02:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735785423;
	bh=J6PCaL1YSlEHtlSTy2pZX0hXSlVpw+hoikJ9ERxwIWc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UL82yR5K9Dv5af7R3cQAZdq0I7l4yqIGdgJy4SPayj3Xid2tPBeHxYSYgI6xmQEBr
	 SOtFhtMKYSmOKPG5O1FLPcbiqP+LcgTODdiyKRfqqJbMpr8bgUQxzmMDh6WcrDRKDg
	 j3oVmvJ+3pGUoAvu6oKtBk59dFxfQOemMxNkSHKms0qdnd7U+QMXcD2ug7HdAAVkvK
	 4dQWJMEA9kxvXDpZnC2SkPC15/HQanrKN478LDvIpXYgVpac8+PS1IBC1AAIxPOpdN
	 ZOB1FXYaBCTnZWMjk99VcJg4y7P0jr0lWSkKQ8kCh/gMvCY8T0+QDxMiasii7juVNF
	 s82HYE6Ln3EaA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0774AC41614; Thu,  2 Jan 2025 02:37:03 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219618] [SOLVED] qemu cannot not start with -cpu hypervisor=off
 parameter
Date: Thu, 02 Jan 2025 02:37:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219618-28872-uTp44yEhxo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219618-28872@https.bugzilla.kernel.org/>
References: <bug-219618-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219618

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

