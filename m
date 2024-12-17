Return-Path: <kvm+bounces-33975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 090B19F504F
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 17:07:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5DBA7A488B
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8C81F9A98;
	Tue, 17 Dec 2024 15:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZL8fTSN2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3431F75B7
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 15:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734450760; cv=none; b=o/Qoj3lCucIJHWXMaDN/tONkV0/d6rXw3ussRNF+8MZNFAKJSbghwP6lr55CNcjDzaO4NTgsgs+19yq5PgB0w4qvoFDdLwZP1LvA8EDTZZQATl5AhsnE+iCDp4OF2c5oENeUwvIg/t5rQLHF6pl9aAJCO9/d25BqgK3yU/519bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734450760; c=relaxed/simple;
	bh=JZij+wD+aNQXqNIXiQsIf0+y4ig+Hkuohj66YlIjbPQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VPgrtdTZ20WZZGUMI2srCwkwuOnaMdHZ0eXxoUQdr5uNSJUJoZ3GJBgS682SAfinjDeuoVuSYAoEWuYKBB5tJ5AERPDMFfAc29LEGEe0kniQo0LGziGugbFGzPsfXY06UqbWBD5/gOmUWkzmzota+cBH6w/w1GJRAEAaS8gH5k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZL8fTSN2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECE3DC4CEDE
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734450760;
	bh=JZij+wD+aNQXqNIXiQsIf0+y4ig+Hkuohj66YlIjbPQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZL8fTSN2PxPtMMPC21WYYZz8bipy5W7XXjFhMH3smAaH2eDp+7taInMHtP0v8vfiH
	 1mw8NfgEyPpfDdA6uKDR9zWtzE6FKYLXqIxb9qKQBSt5PilgNPsNHiXnqRJWuTEoAA
	 HWoIsydB/Npvr+Sxa5mzmCvgRRjE/UTxeL5182S2uFyTA2Rd83VS6DSRr5jQyhrx/O
	 wZ//UGsKje0AeCpMJk/dOzcExw8oQV+tN7/dCjzOwkCQIKHCB8nKu05Mwukmq0VAjL
	 dIpBKn/1spSUqfe2M4gih+4cWsm1TW2FEVI1huxfxEWQG5/k51C3mkLEgl07J8fRoU
	 r7a/gPZhvCScg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E0791C41606; Tue, 17 Dec 2024 15:52:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219602] By default kvm.enable_virt_at_load breaks other
 virtualization solutions
Date: Tue, 17 Dec 2024 15:52:39 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219602-28872-7SvCKPgI24@https.bugzilla.kernel.org/>
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

--- Comment #2 from Pinky (acmelab@proton.me) ---
(In reply to hch from comment #1)
> On Mon, Dec 16, 2024 at 09:15:22AM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > Previously (kernel 6.11 and lower) VMs of other virtualization solutions
> such
> > as VirtualBox could be started with the KVM module enabled.
>=20
> There is no other in-tree user of the hardware virtualization
> capabilities, so this can't break anything by definition.

That sounds like a dead-end argument to me. What is the use case for this n=
ew
feature actually? What would be the disadvantage to turn this off by defaul=
t?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

