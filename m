Return-Path: <kvm+bounces-45071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1449CAA5C7C
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 11:05:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 682EA4685C0
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 09:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DEAF214221;
	Thu,  1 May 2025 09:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KroxY1KG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EE1213255
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 09:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746090351; cv=none; b=OkasB3IYhAwQVKf84CTW0PKF/5llDH1nG4r/hS8zT6OSE28M0C763upU8jFKfJngCmSmTtJ6N1zJwarj8WphVmK8Ysff/yFVj+Xx1E5h6p3m9OnbP/WqYUpQHcMV1zYRaBzcW/h0ZonOOyW560cu+q+9ENrmtFPO/FI/4iW4s2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746090351; c=relaxed/simple;
	bh=rh12h7cS1fnxGydi7V9Utb0kgS812w8gOG8G0+ViS6g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GPT6UWqIC8TsHLkv4W2dPF4Xw6beygikGW93G9hxJAW92pg6tGhXKl5vbDl0bH4ZYkiTc1jJn9S47MMmzD4DR9qgz7FZUEOETha0dyovnD8nk83yYapgXRHRrZeitEr7fDK5l0gNV90SRTYkDkq2xye+Slh7oHuafkGtocuBf2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KroxY1KG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 136B7C4CEF2
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 09:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746090351;
	bh=rh12h7cS1fnxGydi7V9Utb0kgS812w8gOG8G0+ViS6g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KroxY1KGSPBeK1096OqradMDEQbLCuKwxyX/dqxKBO4JgGuweUpR9jb5vxYpgkRzz
	 96DHJ3R3/ckSoSL//mtykemwv/Ev6PMU6ijWg/Dsuu6GKSm9S3g+okumeUtx5+Pp/n
	 7i1po9XI67SPQTVQBWw2Xrg2LawVZUv8jPRsseyCjy8qUWB45vZ97I1Q0lOe4MyH6s
	 y6m2w+WWCtBQzpta6F7HAbxa/lOeq3pE42J7K66vKAQgaJWYjKyZ7iRIZ1ze8Uhe6N
	 g9ujXNMW6iEOXy6q1iOvLSh5W9YM/txionnFVRk0iGygNZCnHtR7tDzp9L1DX+r5DR
	 jEcBn/UbEyhcA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0BFE8C53BBF; Thu,  1 May 2025 09:05:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Thu, 01 May 2025 09:05:50 +0000
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
Message-ID: <bug-220057-28872-y9QCn7BNCB@https.bugzilla.kernel.org/>
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

--- Comment #39 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308063
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308063&action=3Dedit
vm log

Stock 6.14.4 with only your debug patch applied up to vm crash log.=20

I also ran echo "func vfio_pci_mmap_huge_fault +p" >
/proc/dynamic_debug/control just in case before starting the vm.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

