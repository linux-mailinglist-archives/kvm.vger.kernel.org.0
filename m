Return-Path: <kvm+bounces-33813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3DFC9F1BE5
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6E8A16A069
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2E311187;
	Sat, 14 Dec 2024 01:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCjXD9Qo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A989C11185
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734140040; cv=none; b=d7zGDyFhq7Z+gdpbZCGuisLwS83XnFDFU9pK6aWiTTIL48aQQPw6FS8PXB6qlkUm6JKcXK8bMITcP/N2ezChgTEqHO5G/r/X8I3MQ3AslIVtWRCs4+jsU675iIKPUvfMBzqeyYvYKzKpdkVm0C/XL+n9lGGhY/KpTr2KlO+SUvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734140040; c=relaxed/simple;
	bh=0V+BvBbqJaj9CMfPRu9w7OP3dLEzbI5XfvYVGvZfmbs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kI4njYx5Q17R5Mahro/glGSVSLjZcIWYdrxU3a/QN84JAOkD+noWyCSdjDsrhsJ4r2Nf7M9vBKVenZNJf31/pU8BdBIijJtl6WO/oJC+kpQ4opoSmFBs2nH+rN4yFL5KqhvDXZyGP2lhTyO5YgLE5jZKuqcPqY0T8bJOjFHBBEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCjXD9Qo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1ADFDC4CEDE
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734140040;
	bh=0V+BvBbqJaj9CMfPRu9w7OP3dLEzbI5XfvYVGvZfmbs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vCjXD9QoQkZryOEBHROuPacx8g4m/DT98dgpfRizZ5zPLo0gCI/z8/EDPSeNArZ6D
	 QVxxk6miOS9++LPbKQfzo2XJXIC9WDAMIobEMn4vqN9eJgCl2ogjYSSwGhdAjtt3ZZ
	 PgPcLP7nipOEDFqeJO1tLgyLXdEBNIiBHhcbZd4p4od76y0JpCBWehr+BaGuv1w0yr
	 luVBTNTFWK8cyqfhMtcEHQkyfdjllgAYeVkEID1Y5L+xolQ2a8UlBhgFELt8RfEzWN
	 KzVxAZqQGzykC0Xf6HDa6R/Nprs03faSsfYJjWVxiEgDeycCbWxeWHUKXkcO5fUwQM
	 tBbDWwrLs9+mw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 122DFC41606; Sat, 14 Dec 2024 01:34:00 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Sat, 14 Dec 2024 01:33:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: chao.gao@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218267-28872-AU7abJu6jG@https.bugzilla.kernel.org/>
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

--- Comment #7 from Chao Gao (chao.gao@intel.com) ---
Hi Maxim,

I was told the erratum writeup and microcode fix would be released this mon=
th.

I just checked the microcode release
https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/release=
s.
The microcode fix hasn't been released yet, but the erratum is already in
SPR/EMR specification. e.g., for SPR,

SPR141. VM Exit Following MOV to CR8 Instruction May Lead to Unexpected
IDT Vectoring-Information
Problem: Under certain conditions, a VM exit following execution of the MOV=
 to
CR8
instruction may unexpectedly result in setting the Valid bit (bit 31) of the
IDTVectoring Information Field in the Virtual Machine Control Structure (VM=
CS).
Implication: Depending on the operation of the virtual-machine monitor (VMM=
),
this
may result in unexpected VM behavior.
Workaround: It may be possible for the BIOS to contain a workaround for this
erratum

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

