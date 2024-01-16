Return-Path: <kvm+bounces-6337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20E8282EFB3
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 14:29:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9C821F23C25
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 13:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811381BC5A;
	Tue, 16 Jan 2024 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DApzo0Ld"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C82EEAB
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 13:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F129C43390
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 13:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705411744;
	bh=ktq2gLubpY+GpOOn4gXs/mkT3iNDPr8HKuRbQwgo4bU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=DApzo0Ld61ILE7WEUCoArDrWuUKNxJ4hGmRIroSwTlTusjbJ9+NuU4a1bnLmD+7pj
	 iznIZohY7Fwp97k87caXTjR1lrzi3DywP3ep764JYSJ6LbUeJw5A1RvMbG9AO0bRbk
	 /zTzh/Excz8ogLzibzrEE0qx+W/P9HRJumBwdyUuW2fjmwEdkCsc5YkOuhuRVy/Jp2
	 UwhhpYiO2SnNP6QmnJle/rJl8IMFQ0kuVrwrxeJVtMbiOE/i9weXvSJ6IUln5UZDio
	 4wWDFfrleFdVV/wX9yZBA3adncjTbG6njfPJkjs79ZB+5poQ/FFJ4Pnp2fI7lGIf74
	 AhKZzvnnra81A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 05715C53BD2; Tue, 16 Jan 2024 13:29:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Tue, 16 Jan 2024 13:29:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernelbugs2012@joern-heissler.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218259-28872-qkES9Kx8Zg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218259-28872@https.bugzilla.kernel.org/>
References: <bug-218259-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218259

--- Comment #9 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
(In reply to Sean Christopherson from comment #5)
> On Thu, Dec 14, 2023, bugzilla-daemon@kernel.org wrote:

> While the [tdp_mmu] module param is writable, it's effectively snapshotte=
d by
> each VM during creation, i.e. toggling it won't affect running VMs.

How can I see which MMU a running VM is using?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

