Return-Path: <kvm+bounces-44516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E37A9E526
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 01:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2E241736F6
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 23:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37AFF207A0C;
	Sun, 27 Apr 2025 23:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDjI9/0I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED9E17BCE
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 23:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745796868; cv=none; b=MbO3iyZuQj7FISWf6iy9ygXCoItkEk4azrx1pSnW7mWlKEsKjX4fZY5VCmW1n/0Smd8y+rJgHmX80aA2IkKaBR8AgsOX49DembfusYMYkmehIElucARTRpkq4HCwLHRud3WFMqcTAzlo4MZ5KAwHbgaBcDCBWW9KwiG8pwNs8+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745796868; c=relaxed/simple;
	bh=DB9hFves7cvXuQJf/YxsB1Oq0SGjWHI00UrQVtEYIsA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZkVH5A943Y1DMmp5j5IvFApHYYqPXdiJdyKoVCiSV8srK7Y8GDoTf0/T6mLc5GAP60CCuBCT6dxPFlqde6LGVIlErHyMBtJOSNZDsPDN+kEPoz5z0aJJGgdwkaeE+k73gxxhpyE504TInxyHRew7Tah7hFrBGPoNWDhRl/CJMn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDjI9/0I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D28B4C4CEF2
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 23:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745796867;
	bh=DB9hFves7cvXuQJf/YxsB1Oq0SGjWHI00UrQVtEYIsA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fDjI9/0IR0NWA41GjpJ+0Ng1aBji6yMUX9yX2xya6VSDZ9d/YUOH9Mpw9n/HTM73U
	 9por82ms8G1YA+I2pjtz9lf3a4kS9HDKzzJNtwWpBOlLb8TBDYA9ViqYf4exMePA1C
	 jLMyg8Zo5Pztv9puXaP40P5PeRPA47QNN+q0RllXeAI5qjs8lbCzl17pu50nb/iqLv
	 zu39Dk1yjYCGVJNPhY5rN4rd5jZ6oI03IU0sdwD0tDzaq/u4RbrzV9bs5aV7+tzb0c
	 l4Bdu/tzJG+ZJgi/+9vB0Y3NV2vWDwEht47iJpiiqoKLAyA28HFQe7bSnQDygYDfYi
	 oF4Zq6rN5LrqA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CC1C8C53BC7; Sun, 27 Apr 2025 23:34:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Sun, 27 Apr 2025 23:34:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-220057-28872-fG7ENhRFD6@https.bugzilla.kernel.org/>
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

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alex.williamson@redhat.com

--- Comment #2 from Artem S. Tashkinov (aros@gmx.com) ---
Alex, please take a look.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

