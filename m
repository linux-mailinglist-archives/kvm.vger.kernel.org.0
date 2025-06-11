Return-Path: <kvm+bounces-48965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF291AD4A21
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 07:00:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54BA33A5D5E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 05:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1C61D7999;
	Wed, 11 Jun 2025 05:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cghMkPUr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A95F8F5B
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749618023; cv=none; b=TvymP3244nN7jqHlFnz/Z49+0oHam4kYPwnRsKZVFzBxUMyYaqTLCHdmeSe12zbxtDQ3twm7VIHEcjVxedIGqHTzh7RSQHYxHXSNgcS32fYFipk21KtBvKDj3nY7Qh4ddvfHFKl5mdQDfrICgIiRbPVNDuaEKMspI/dBTu790qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749618023; c=relaxed/simple;
	bh=qYGYqF9Cz6m7XirxtBhGfPA5BcE0G1iXrMWDxWUx320=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fP6nrQUwmoPNexCZ5R6bKeKvNCDEuxsVQQF/0nOQbvgiBZklTBE8UIo1OrqJ9T3y2ZxtYDRIgvbSTRGRwRYlKv9V5D1uBsVPoIHk19MnzTEAyL2d0TOxrlblJ+GY2kxy27agBYTv5fb6gHBIy0lOi1Ou7RvcRXBSWGiipfxZ6qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cghMkPUr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37A03C4CEF2
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 05:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749618023;
	bh=qYGYqF9Cz6m7XirxtBhGfPA5BcE0G1iXrMWDxWUx320=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cghMkPUroYxM835qCb9u40zmFPz6BeX/PKpEqyuHhUglEJ6+YArWzQbh18aIUmngH
	 GtJCvyTIxN06dkbOS8BB2oATipOxkGr8fyse+grRQMjsp5MkOHE0v6pkj4uWdK8Mp2
	 mJwvXhhv7Q7xb3LEW7LVO7cD1h1RD6RxVQJ4j0pCPWwj30z7ZsnEG3o8PjO/qF1aB7
	 cMPY0jN/yoDIK3ygvlmcAYYrJn88zILFIqdVYx4SuT06ytL3f4wHG3A4udaTSj9Qxd
	 6/9KZbAxQes2cDZin4C1uc81Lk89HG+DnE/beZLzpelDUYr9QWn/UNvpZ3zPxiD/Yx
	 O2QDzqJetNCuw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 2B8A1C53BC5; Wed, 11 Jun 2025 05:00:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220200] Kernel crash with WARNING: CPU: 17 PID: 4510 at
 lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
Date: Wed, 11 Jun 2025 05:00:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: gs.thiruus@gmail.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220200-28872-6DKTdnJBqS@https.bugzilla.kernel.org/>
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

--- Comment #3 from gs.thiruus@gmail.com ---
Thank you for suggesting to try kernel version 5.4.294. Could you please
provide more details about the specific kernel code changes or fixes in this
version that address the crash we observed in our setup?
Based on our analysis of the call trace, which points to a NULL pointer
dereference in ipv6_sock_mc_close, the issue seems to stem from a prior
use-after-free scenario where the kernel attempts to operate on a freed obj=
ect.
We would greatly appreciate if you could share additional insights or detai=
ls
that would help us understand how upgrading to version 5.4.294 might resolve
this issue.

Thank you for your support.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

