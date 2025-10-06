Return-Path: <kvm+bounces-59523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F88BBDE8E
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 13:45:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 46BA334AE31
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 11:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A948273D60;
	Mon,  6 Oct 2025 11:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kT+Y+CUt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7CB2222C8
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 11:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759751142; cv=none; b=nx7Bemu6v1A2Q8CUdW7286LBrjZJLCoLUwtazQ+1zAll7a6lFZmxuJNFfBhEKGSm7bmz4sAt0QBx24KMaB/RuNKFM1uwTmihLDHjQNAVPsRyevdCU0X9G/MpLLUvkaw9NQUIDO4fXY0DXDlQwEvAX1nrQ1byC49lMKlbq70dx8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759751142; c=relaxed/simple;
	bh=0TA1v0TiZrcKTdFc0BudrqrGWXYtiioT+N9s2xyFYkM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DXL58JvodT6uMM3vEzuz/rAvouQXXigO4GUZSRNUpwYak9PQjCJiKgi1Fcj33ow9Pb2aBioOz7E21byps+EUoIgoEZfIP7tET202cnVXr5Sc2nGoWTrK963UoeG8uiISw8guXwiOWYD4nfTge79yBGjwppeonP10rYvoV/0A64Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kT+Y+CUt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1163CC113D0
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 11:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759751142;
	bh=0TA1v0TiZrcKTdFc0BudrqrGWXYtiioT+N9s2xyFYkM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kT+Y+CUtvvP5NVa/YQO5Sxn6LcqSpkS46ngkpbKnLnu9Rv5zqmJDLLa996mE3RVkB
	 w1Caxx9KkcEoYuaTTsXTNPDrgFG4skBJauuNrFtV+tl/eBmTIHGQeXW2TskYCzu8P0
	 Wl+C81bsA1BejiMk/86dccDnkfJMlbf3NTS6W7qXVyrJkc7BESjvuQLaPeaXzJFU38
	 +154oEQlKIHSnduQrH5WXRgfG6oceSzzZn3XrSvXSJE+XImvqlGdTZrtoKG2fdkk2L
	 ttWE3nu26Bz8EfSv1GDwayKPWVki/dnrh6QydS3ha/ElACZtQEk9D/YtSbf2Fi+eWH
	 +Hh79XFJkeSLg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 06887C53BC5; Mon,  6 Oct 2025 11:45:42 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220631] kernel crash in kvm_intel module on Xeon Silver 4314s
Date: Mon, 06 Oct 2025 11:45:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status
Message-ID: <bug-220631-28872-Ph23L9V8lC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220631-28872@https.bugzilla.kernel.org/>
References: <bug-220631-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220631

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |NEEDINFO

--- Comment #2 from Artem S. Tashkinov (aros@gmx.com) ---
Vendor kernels are not supported here and neither is 6.14 because it's not =
an
LTS kernel.

Is this reproducible under 6.17.1?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

