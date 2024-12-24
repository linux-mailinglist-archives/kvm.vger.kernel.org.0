Return-Path: <kvm+bounces-34352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C9E9FB9ED
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 07:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C5361882155
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 06:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168E1156F3C;
	Tue, 24 Dec 2024 06:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZgRMCdq8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F838F66
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 06:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735022643; cv=none; b=GtoV0vI3BpddcjdzRWhvLiB/v2P4nLD+ESkFo6qSb09RjLRdtZxQGN/Z62xclssy8Nh8gc+7UHT4MTd6xIOxm+kSsmulkifEJDIL2c6BpdYszqJw8KZrRUXj+SQPivXfdwOjw2WuTzwWI0aYaU8Cjn+0yN0ssPNOxC2uVOpc624=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735022643; c=relaxed/simple;
	bh=viAW5ILJ8FvzLmOb0m2gUg399PSWvbt6Fx+X69lE+sg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B6kZ2fS736RIXYBF5z4ku1hp/aslS9NjKNCUSTJtl7QjrMpT6mxxsM8xMiFcsXU9c4boVVILj2UXxkcl+Ql3BtaOsDHLY5B8XHokqgwmyTZyJS/9mvMkA0PKL7bfmPptZeAZ4RXiTGDZkPxgv0cSMoW/yvvBcwvBXCdeyCnA7zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZgRMCdq8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8805C4CEE0
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 06:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735022642;
	bh=viAW5ILJ8FvzLmOb0m2gUg399PSWvbt6Fx+X69lE+sg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZgRMCdq8wh31zHyJmqeLYvopIDcOBhO/YVQI+u9ETLcMzmhmY9MRLXyonESTGljhM
	 vCQGr9rbNtwdmjDwo9HWn1KB1bZLMkrxeeb468uroVJrprFHCMjEFqZuVMm5Oz6Q7F
	 8LSNBZIE0XVTRagJycxZ9YgzhJzz9esHE50p46t6FGs/6gm+qSJXleF83A56WgRKb5
	 hWbpIs6mzbuUzfn3l9lQYdSBm9H5Fh28CJC1V3u4ZsnchIxmPZos0JHXPXitXHsaUM
	 Q8rBRUBiX8TW3v8EoINmzU4fPFykpXm4duWxXTnfd0jYPDjVWb8sirw3KKVaMPjgPF
	 E5+Jao/dVjyUA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A010CC41614; Tue, 24 Dec 2024 06:44:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Tue, 24 Dec 2024 06:44:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: shu.info.oss@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218267-28872-QUWXv7CQCD@https.bugzilla.kernel.org/>
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

shu.info.oss@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |shu.info.oss@gmail.com

--- Comment #10 from shu.info.oss@gmail.com ---
Hi Gao,

(In reply to Chao Gao from comment #7)
> I just checked the microcode release
> https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/relea=
ses.
> The microcode fix hasn't been released yet, but the erratum is already in
> SPR/EMR specification. e.g., for SPR,
>=20
> SPR141. VM Exit Following MOV to CR8 Instruction May Lead to Unexpected
> IDT Vectoring-Information
> Problem: Under certain conditions, a VM exit following execution of the M=
OV
> to CR8
> instruction may unexpectedly result in setting the Valid bit (bit 31) of =
the
> IDTVectoring Information Field in the Virtual Machine Control Structure
> (VMCS).
> Implication: Depending on the operation of the virtual-machine monitor
> (VMM), this
> may result in unexpected VM behavior.
> Workaround: It may be possible for the BIOS to contain a workaround for t=
his
> erratum

Can we resolve this bug with only BIOS updates if a update patch includes a=
 fix
for this bug?
If so, what is ticket number for a update patch of BIOS?  it is SPR141?

Thanks,
Hidehiko Matsumoto

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

