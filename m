Return-Path: <kvm+bounces-48634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7738ACFE0C
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 10:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 163C118946FC
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 08:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318C22853EE;
	Fri,  6 Jun 2025 08:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9FjvO9H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5021DE4D2
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 08:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749197660; cv=none; b=bBw6vrJh0nqtOGjJJ3i4HDquWUYqT4mRqLLHyx+KV1a4mBifWEyb/Mj1fBGXhHGqGfHZQJE0ouxxbl/IYjB7Myga6tSmt+xETlZkQ//IB13W9GTH9n9iDGumy8gLjmNYla7Wlvd2T8y3xNKxJEbVm0ykZ7PfXpcMMLgXnPjspIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749197660; c=relaxed/simple;
	bh=rBTsQT4gvatXo9Xby2U4O5AU4djCg5pTPwHk9nMZ4Tk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KC/k872QXJa54ygE9zUHzAJ7eA6p0GT40eeHvtQlK6vBAslNNq8GBooljdjoq/skN37U+/KM9boRVl7uJi8TzOlGo6kTCnNmDrW5dDdNr3az0+QaHwdTeGDekoIQbY6KtLt+FEl0NhfU20E71kO4CpK53Jv/57B+OYcq0hqjv5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9FjvO9H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF3D5C4CEF2
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 08:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749197659;
	bh=rBTsQT4gvatXo9Xby2U4O5AU4djCg5pTPwHk9nMZ4Tk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=k9FjvO9HMmeoUq2+hbp3muhnhS4C3JwwA2TTwQGPGGoCceEcU/yhjZfDGldHToIBd
	 EQwZRn/yYie4ia6qIZxDXDvuo3Y5as9tDVsCo4tSsPKzmRjkgHO3FxsJoV19PrI4IO
	 STQTcBEzVUbVzl/udGN+gE7HJNywXqLwC3aqX9quccU9moRotgHzl/PLKzPk3E0g/2
	 9yhNuZ6tObsnx9/e3/buMiTww1t0P1GlkKMWxdGe7Qw3/OIVLOdQeuXE0kj+uFrm48
	 XrlpQgwn3QAOLk6XPgUDTPb7L0AP+0MIsokfLluT3DLgSkvOBkXMygYDxww9m7X4Lu
	 umyWM0GNoLW/Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B6CCDC41616; Fri,  6 Jun 2025 08:14:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220200] Kernel crash with WARNING: CPU: 17 PID: 4510 at
 lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
Date: Fri, 06 Jun 2025 08:14:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-220200-28872-jMzC1EwE0A@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220200-28872@https.bugzilla.kernel.org/>
References: <bug-220200-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220200

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
Please try 5.4.294 or check this thread
https://github.com/flatcar/Flatcar/issues/427

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

