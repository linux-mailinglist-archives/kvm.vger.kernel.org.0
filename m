Return-Path: <kvm+bounces-44862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C51EAAA4407
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D5D01C01979
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 07:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C5EB20C47B;
	Wed, 30 Apr 2025 07:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HuLP6rls"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C947519F135
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745998332; cv=none; b=uX7Ln9cjTShe5rJ/idoTpT/89tyzZ5I1vMJPJhKdXyDJH8UVF3grfGcWNZT0F5Gjg5e9L71FiPui7Bx164qBhzUHnQHND5mlTJ16WQVt8hgxr0GgQJ3H67Jo6Vr2U3yqwYTDVvgViYbYoHPj7YfdqrrW6uyhuhDN4Qnz6KSJQOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745998332; c=relaxed/simple;
	bh=M6rjW9u69SGb757RLZYzTaaEYRIuifcl7b+ckbRgU/I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r0/cq06cyc0s2sj9qj5BiDMPWXEWW++Kcf5vw5xrYW6+M6Xb+AASWOs6pFCNirANhTQ0icibWTvnozHme+8Cvfe8FvkjuILWryqbI7UUg/QGz7qYD1/TbHLr/YkwFuJrtAWYQEdeYr3vak/+qPApssYUPSAxWxxZV6xyfIpB/i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HuLP6rls; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBF6BC4CEEF
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745998322;
	bh=M6rjW9u69SGb757RLZYzTaaEYRIuifcl7b+ckbRgU/I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HuLP6rlsaAKrAzwuQdxR/F9BIRki9/iSoCam7Pfl+Hh9Nw+eQB1lMdpj9RG0/oOrT
	 agOWGW1QXqkvGu0dX+CAdSUJuLLY4HdmTPZIyHHM7Jf/dWI6OdmjyjOI/H8XazcqUD
	 P9mpTG+Xut+PqwobYHZOWYJfCY9xpQghI52LfISAKUiAWLZ/Tp+Mh1dUmt9wDyjxdD
	 CjpCpAoxhmN95DbIFv7e/Q3J9ccaDD2zw1C+/8eqBmE0W74mMKI8Wy8cy+j99MbTSs
	 lrW2WqUc6uLEFpsmz6qhV4TMbzHjY+vAqQrymFLgjR6TJ9bZAFxOulQMP/B3/QZ+84
	 Zt2A9x4UgjIsQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D5043C433E1; Wed, 30 Apr 2025 07:32:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Wed, 30 Apr 2025 07:32:01 +0000
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
Message-ID: <bug-220057-28872-36sEdswCGQ@https.bugzilla.kernel.org/>
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

--- Comment #37 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308056
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308056&action=3Dedit
vm startup 2

I'm sure it was loaded. I have it set to load on host boot, and it binds al=
l of
the VFs from the X710 network card. One of my other VMs is running OPNsense
with two VFs from the X710 passed through, so I'm 100% certain it was
loaded=E2=80=94otherwise, I wouldn't have internet access.

The issue turned out to be that I was running my patched kernel. I booted t=
he
host using the Proxmox kernel 6.14.0 instead.

It now shows the information you requested.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

