Return-Path: <kvm+bounces-38774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6D6A3E4A1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:04:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 896C64249B4
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04C82638B1;
	Thu, 20 Feb 2025 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+EGY+pq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB4D2144D6
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740078055; cv=none; b=j8XXQsM7naLjhDnG1z96RWrWK217jyKJ0kEfkTaStqJ75UHOh2dat7EZDIa0f7q82hSqHyLyyKg/HTMTV4IPS2+Dp4LqIH5fpIh9V8fSdHsaDaa/Up+UHSAAufgeMa9z61XTMzzqH+t+lYGWc2UQRpx0dKrtkljwluQuqM0tFwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740078055; c=relaxed/simple;
	bh=QOUUBSpvA4SGQ5iCkspF/RzYXBsBc8xX5yWhOIj3+BI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OTPUXwcvQlemlUbr/cfdFzXKI6tLuh9u/szFow+LSVqWjlkmDPQpMBZ9/9hUF5DnkzxLduQR7GVt/wMe++Vay9WsCIPBubzJ+eckTTMEnqP1mEE1u3gy+5SQlNSbGt9rDH8c0ueEX9oJT9Lws15NkB0r6hVD//QRLLapD6dAbaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+EGY+pq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D992EC19425
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 19:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740078054;
	bh=QOUUBSpvA4SGQ5iCkspF/RzYXBsBc8xX5yWhOIj3+BI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=l+EGY+pqIyaXzHfuSKxP/mcqJaCMLVWe2wqHk4tTUHWuL7ELfxg0N4Q1iMumzWXvw
	 1X2zglNuD/FBn7X+s3NihoZ58LqEwOsRhMPQnoIsUdOFIGuz/nXwFQmqYIiBnI94Rv
	 xG1TAQDQzihPn2FRDTejpqd7NLEXUsKhkn/AYG4Ht+8+RpRw0QiFOWApHNTxeNs8/t
	 1QDhWORElyA/ahmV1x7qH9FsOrouOpe/3ld6RdGXaKyw2F35T1OKXYfjcJ9xRAyYFD
	 ZVa7kdUaSjCZmi3WLAHsXPjLscqpm43F/PWn7EHQ+bFp4HEtyU/RUFmsvbgSnH8nP5
	 14xg73WD+o+uw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CEF33C41606; Thu, 20 Feb 2025 19:00:54 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Thu, 20 Feb 2025 19:00:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rangemachine@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219787-28872-sXUXsdIC2G@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

--- Comment #8 from rangemachine@gmail.com ---
(In reply to Sean Christopherson from comment #6)
> Please let me know if you'll be able to bisect (or not).  Unless I have a
> random
> epiphany, this will likely require bisection.

Yes, I will try to bisect it tomorrow.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

