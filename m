Return-Path: <kvm+bounces-45244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11081AA788D
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 19:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 560753A012D
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 17:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B8526157E;
	Fri,  2 May 2025 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUzyK8vM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690D21A0BFA
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 17:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746206142; cv=none; b=eP0TMd25UiTfNeXF54Vm0HefWrEbo2Ey8PU3ODlu2+4Mw8fKlU0+oy+PTPx5YXHWAqoVqNuioYNvp+H5lWET99OpyNg7VW/M+/LZGHbqyo6Uj84WK4bggUxVr2g0ysC1zCA/GUyPINW8QaixtFTkzyHn5Ugin0VfdNWZfSdo/uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746206142; c=relaxed/simple;
	bh=I1x63GW1Vaj+f/5bbv8PjNun1aAi9H+/Dasu7gHhQB4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W0OHivjeC+HHS7G4FSV+TOBXai8dzi8Xz2NFheK6TzzkmAGqzgVOTMQpdRcCnjHdWaLH7+YlgVW9PAoJl7/1pHb8Tu3ONTOL3wlhgbaAvr/h80voyemtmUsXAERTt+gPFRJ+2EfCBWLmu8FgcQAdeR6E31IC0qS6daN+M4a4A2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUzyK8vM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF3B7C4CEF1
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746206140;
	bh=I1x63GW1Vaj+f/5bbv8PjNun1aAi9H+/Dasu7gHhQB4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=DUzyK8vMsSbM0eo/A5v1U1nYhNEdAe7ZhWqNrYZGpaDJpILuEAPh5fsBVrZwuKuud
	 3Nob6bxb1akSVS90Yl5JhqMAUVL2iiLpx+zA6LAAR3nl3ADhi3Ig7zKlUgr6XX9n/L
	 TsdZaLmjF69i6vNE2aS5E8jLs5M4fc6MB6PyIrid+6Is3izvrySEWgun0QVoBQvGk3
	 pq6vTMklWIxc8wP2X7ecgB2QzQPcMF7I0vmrutNHi6LfgPbG9E1BxJ01rTAxHz5Ft1
	 LGtewNB4ZqPmIDp0zEB5T/YCNAOvX658R+hv63CDa9GddRShcAUs2Sy7gd76sShCu7
	 OThQoZCcWCKxg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D8A93C4160E; Fri,  2 May 2025 17:15:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Fri, 02 May 2025 17:15:40 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220057-28872-Akkqos0tTb@https.bugzilla.kernel.org/>
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

--- Comment #45 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308072
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308072&action=3Dedit
log with new patch

patch applied to the newly released 6.14.5 kernel. VM no longer crashes. Log
attached. There are still VFIO_MAP_DMA failed messages but I cannot make th=
e VM
crash so far.

Thank you for not giving up.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

