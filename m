Return-Path: <kvm+bounces-36678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 417D8A1DC1A
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:32:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C6BF165D0A
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995C718D621;
	Mon, 27 Jan 2025 18:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZJqtakt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B821225A63B
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738002742; cv=none; b=q87UYOCAJUa5Q1S1U+eNyBmW3GGrM5JpJx/O7pm1w+gnlGSPh2r1nqjffY37SpK/zcdpo5w/ZV4YycuZ5tiLrUkZgP/QmMbFAW9oG64DkOP4qScsBLtGuiRQi7IOT4aPFwLQkQQT8T0fm41b6YW3vmvBkfEZwx7rVxajVUM3NfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738002742; c=relaxed/simple;
	bh=iY7lbnlCU1dMWdDNlXzpOIXicbjDgROlkJWby+mI2oA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IuMN48guaj4mGTJK1qT49fXsuxmECGwINbSp6WH2jdanIJSopaBiI6jncToy0VIC2zYGtSXhRqCHkGHECGX8pnmDibSWANt0r6GikhQKbMm6ZWpRbhgjk/vXoJJRfy/0+EeIRgs2MhYxDXKejhZhBp2UPsAOGVOj/OCiiV4W+Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LZJqtakt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A3DEC4CEE8
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 18:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738002742;
	bh=iY7lbnlCU1dMWdDNlXzpOIXicbjDgROlkJWby+mI2oA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LZJqtakt7ujn5OgtWfChm3lZKBwaOpgD641ZKWRWTDnF+uuz7yiLSsZuh3bCqPlwl
	 d6+L80mVilC6hXOf0FC8S+P/++2mUO2J/lH7/IZUOjgEzYXCKCel+0GJu/Xm3RN68S
	 qXPxteh7AjxwKrrjLUnC8UUObeeq2e3LwIaCTxLULqR01WsCiVt1KWGwzit8QZBvz/
	 ttsjLjZSShnjU5kz7sKuVEMM1aDYKTbhAfLUCL0RdnZ2JPAApFYwVVgmorJx8Vg2Oa
	 eGDDrztjsFMz7kI1+1gFx9J+UG3+9mKmD3AbBTOXKXTDrvsjb6PF1MLPXc+3VZx0zq
	 CTesh0ae7hxsA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 232A5C3279F; Mon, 27 Jan 2025 18:32:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Mon, 27 Jan 2025 18:32:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218267-28872-Xpwv0XnAmB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218267-28872@https.bugzilla.kernel.org/>
References: <bug-218267-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218267

--- Comment #12 from Sean Christopherson (seanjc@google.com) ---
I'm not terribly concerned about the complexity, I'm more concerned about t=
he
efficacy of a software workaround, and to a lesser extent the risk of doing
more harm than good (this seems unlikely though).  E.g. if an exit that _ca=
n_
occur during vectoring collides with the bug, then KVM will inject a spurio=
us
fault into the guest.  And if our list of "impossible" exits is wrong, KVM
could incorrectly suppress an exception.

I suppose we could mitigate the efficacy concerns by emitting a pr_err_once=
()
to suggest a ucode update if the erratum is hit.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

