Return-Path: <kvm+bounces-13907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BAA89CAA9
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 19:22:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06A791F2537E
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 17:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 761E514389C;
	Mon,  8 Apr 2024 17:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUzAjG7H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7F2142E68
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 17:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712596945; cv=none; b=QwRdf2nWy1FE9ZxQ752RgrSVU7EaNgOt5f0qhh1sb/TC6WvSfO5IhNlolNWj5QL2r+gemC3Xkb9FhtpFn1TF/wQIu2q5pdzC22DcLL9vr/jAcERh8Z+Kb59a75KOw8sXzNxyV0zdzLzcz/USYjaDuDBpEgB2GSomvivwHINT7aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712596945; c=relaxed/simple;
	bh=eveAdsjMzBqEo/9BiGU1Oi8tiSvTsQ4HiPlQFZ82CLM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cQuWCflswhmJyf074ZapGkjRmA+IBiU06/O++YY1Se++M9w19HT+IG1xQhotni14jloZKQG2qn9NXxmLSimhP8Sgjz6CZDqKNA8Wao+VxcUCR94fBbE83LQGloUCI+nLL6H4SNwd1ZbSvlYnZOesH3FLYcP3aEGoJipfrZp6gho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUzAjG7H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D946C433A6
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712596945;
	bh=eveAdsjMzBqEo/9BiGU1Oi8tiSvTsQ4HiPlQFZ82CLM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mUzAjG7H0PueoegxoZGyV5GbZwpfz1oq1K/6eKIgS9gwLhSFm5Uwne4mntDrfzBtg
	 AJXbak3Sj6GUsocp+2E0MLrGdY7PM9GfGerc7dK6tGHMdHoA43w+qIPa4onZ1cnkuq
	 Bhmn5xxCSCJhGFqKmUeOSX3ijSx7GFWzp3xp2PvKsJ0+7WhXk1IL/eQJ44RS/XFbvb
	 +ttkS4qf694I5qpG9yxb4M0gCWVzwGHENrMBCqkuKUtoe5qYSiX2kHuwJcXHooJfCi
	 ILpv2ywQxX1r5iknYHGzlzNpkjnoesRzx5PYENRkPJ0sgLKlbrBVVDjG0y/Rav2MiF
	 PD7Op1WcpkkLA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1EF45C53BD3; Mon,  8 Apr 2024 17:22:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Mon, 08 Apr 2024 17:22:24 +0000
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
Message-ID: <bug-218267-28872-wmTSPzaVQh@https.bugzilla.kernel.org/>
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

--- Comment #4 from Sean Christopherson (seanjc@google.com) ---
On Mon, Apr 08, 2024, bugzilla-daemon@kernel.org wrote:
> This is not considered a Linux/KVM issue.

Can you elaborate?  E.g. if this an SPR ucode/CPU bug, it would be nice to =
know
what's going wrong, so that at the very least we can more easily triage iss=
ues.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

