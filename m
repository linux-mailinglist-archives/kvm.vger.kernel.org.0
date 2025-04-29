Return-Path: <kvm+bounces-44796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 236E7AA103E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:20:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B555A1B616A1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0211221D3EE;
	Tue, 29 Apr 2025 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anMYGVcl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0896E21ADBC
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745939928; cv=none; b=lYyOhLrAOKKt0t16arhRk3i/2MzOlMxpBDPY8hZNkBU4CD6E2gDDJ3BNHFEUxrAHeE7ve3Ohoo4pkzZJo+5pjvpVp67pe1ODnLkFgdhbjHzdFsIiz5OJfPx+WVF5LRkIZeaUBbUesJa3pXD+ybHnFHAA3qsu688gjV+fUWLOk0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745939928; c=relaxed/simple;
	bh=UJibBOggi6gDw+xz0yeu8yA18SnXejs4q1oInj7goHQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AxinCblvmQL10koeckBQel1c5GdECpNeV/6hRJvXJCxT9ScIIMGHbWvCWVrp6YH+w1pFEV0fycj1v+x4yk2pIpj6k3Ca1mekXQrGhrdWFSjj/EH/3UpU3V/Y+X0OCGAilSQM7BcPtEB2xCXhQeNVIbyYnFg0ePhscX9s0/nKFf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anMYGVcl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 885C1C4CEF1
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745939927;
	bh=UJibBOggi6gDw+xz0yeu8yA18SnXejs4q1oInj7goHQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=anMYGVclo+ExivCjXXAxcnN9b51d4d6t5fOWs0AzO8M2XrXz5c9DDBLkCQQ7kNHb9
	 cRDvYKL+HwhzwVTAicXn0CSh/zzxWf4cnHquU4M3YknXp1x8UAS/wKEYdMei/q9BQV
	 sn+KGL2GTlbBNEMyMxF7S2vaOtv5E4/BfiBP+6Jf4+yBXfHwQ2IPVM4Lhbq047XgsX
	 r1dDnt80sDHwmwarkuqVQ6lkHa7UCM8+7K/swv8b/6MwqVIln/aSaWF3UZBWEpp6T+
	 islsPxlXMVejFL1TbKuaKCH5aEe7ehFEs6FJ3VbqVH9rUa2SfwpryRqyhQM9CG58cz
	 5GOS+uGtWJ62A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7FA59C433E1; Tue, 29 Apr 2025 15:18:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 15:18:47 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-Px8FA5RVqZ@https.bugzilla.kernel.org/>
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

--- Comment #29 from Adolfo (adolfotregosa@gmail.com) ---
(In reply to Alex Williamson from comment #28)
> Another option may be to set the cpu as "cpu: kvm64" which is the default=
.=20
> I noted somewhere this should present a 40-bit physical address space, wh=
ich
> might be close enough.

If I recall correctly, cpu must be set to 'host' for nvidia gpu passthrough=
 to
work. That said, I would still prefer to keep the CPU set to 'host'.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

