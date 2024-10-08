Return-Path: <kvm+bounces-28118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B82F69942C2
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:52:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 626CA1F229AE
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 08:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40FB61E0DBB;
	Tue,  8 Oct 2024 08:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdKE3weU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD4D1E0DB7
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 08:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728376202; cv=none; b=RQkTArertQlpcIP2w/L/z3FLscbwXTSSRyO6NVFQYULRXKK2bP6wAZP/RgYiWzJVPWxZ46arMpiNZsOz6O0c1iB68lzIQGGNOGu5XgeKKgWVqFpShITgVPBQSfmg+gxZBYvUzn2kbl+YMnQTwCDyVX+9jOGt09wQehULxbxoSCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728376202; c=relaxed/simple;
	bh=V7xZYh+4cOq1zee+X7Ydl9URfRFRK3UIrW1pmeYE9OI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d/vGmgA5e17m7D/tggO4xlRbHfO7Z/jRuiE2qrC5iqVWhOWLBniWYHnVLQ2Ryiy7VuNKlKUF9uCxtqqXo5kB2wTuf3ZdcXHLrGOls6DojYVYSTs08a03oHbhOc6vHpKH8GDFnwfYmkg5SVSb7w96xn9lr93FHzwvfPncaW8my38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdKE3weU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1161DC4CECF
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 08:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728376202;
	bh=V7xZYh+4cOq1zee+X7Ydl9URfRFRK3UIrW1pmeYE9OI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KdKE3weUX/xcZ7T+g2xzaP9ug5zraadO+7ANNy9j6fmL/Y32uz/XSvpA5GnPglSFE
	 0+morqcmuE3qs6LErtUM/NB7i5mBMMBAOg8lwI92dhABuAXEx2sLScMMS6ZiImkT/s
	 434wNYFa6b5bI7LE/wBvtw/txoXPV/ehSiJXtzKUGvvy8xL1sMM5szejdIqO0oBL0W
	 efBHZFsyv+eiq/D+m0TPmsoNI5ho38wRT1btDo9APswj5pmuoFMFiieb4oza4Rd9w3
	 jwqMN3uEy+uSnFl4J5sVFtRcE1dozQSWtfix5fCwdsF5hyjNiKAcmQFCsq2iDf3+ow
	 XwSrlr1zKfXYQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E5236C53BC2; Tue,  8 Oct 2024 08:30:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218025] Assertion Failure happens in kvm selftest
 vmx_preemption_timer_test
Date: Tue, 08 Oct 2024 08:30:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: like.xu.linux@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218025-28872-fRti3gVqtu@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218025-28872@https.bugzilla.kernel.org/>
References: <bug-218025-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218025

Like Xu (like.xu.linux@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |like.xu.linux@gmail.com

--- Comment #1 from Like Xu (like.xu.linux@gmail.com) ---
This issue still exists with the latest kvm-x86-next-2024.10.07 tag:=20

[root@intel-spr kvm]# ./x86_64/vmx_preemption_timer_test
Random seed: 0x6b8b4567
Stage 2: L1 PT expiry TSC (3200842488) , L1 TSC deadline (3200779744)
Stage 2: L2 PT expiry TSC (3200803666) , L2 TSC deadline (3200796320)
=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  x86_64/vmx_preemption_timer_test.c:220: uc.args[4] < uc.args[5]
  pid=3D87853 tid=3D87853 errno=3D4 - Interrupted system call
     1  0x000000000040295c: main at vmx_preemption_timer_test.c:220
     2  0x00007efe8e755f4f: ?? ??:0
     3  0x00007efe8e756008: ?? ??:0
     4  0x0000000000402b24: _start at ??:?
  Stage 2: L2 PT expiry TSC (3200803666) > L2 TSC deadline (3200796320)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

