Return-Path: <kvm+bounces-59530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C3582BBE541
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 16:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8B3944ED656
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 14:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1412D5C92;
	Mon,  6 Oct 2025 14:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlNqeMkL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB41D2D59EF
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 14:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759760783; cv=none; b=rUH77vHCT7fq+26bHF1V289SB2L3wW+XwmiBDqjfaHLSGhF2U7AOcLlSwrUtchpw8oid5vyI867Vc9bp1BX8pG1Nqfrv7LKDNY3xCjg+weZuYkbO2CIiA4c0MmDwLdtmwV0oHIgg78OR1MlflVaacX5Oq0w2jJJhWsRl4BaW5oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759760783; c=relaxed/simple;
	bh=Totni4kXA/mpx5SgLfkOvLaZoKWco3FvC3tHzeGYC78=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lIlctcBeCB7/ixCmAVm3eiI9FTmPPLsOXnavHre0G+sk3vFPrlJ7JgWIY3prciEgW2BStVA6ZEL579IchYT5yBlvITWTpVascOmiFGSlfMkE5cHeFmcI7Fno5N7xGM1MeLoIqB9AXGSzrOOPTDy7Yapbv26X2mSqFUDU5Mdljuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlNqeMkL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39539C116B1
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759760783;
	bh=Totni4kXA/mpx5SgLfkOvLaZoKWco3FvC3tHzeGYC78=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WlNqeMkLhJnyivWpTYmNcfGW+TAwO08C0uIjoqmLJ+DbEFW0QS5R41X6rCq5TfLkh
	 i5NM/Et9T0B0Oqg8We5oDbag5hueKP38Nstjzii/9YA/5TUp9Od/x9v6iiK8wSSVp4
	 PBB614bjUwqaNgtiIneXDw/HMWlG7VCI2pvV9lvFGi8oRY2KYG4NpkfeaiwPzRbOIC
	 ND3kEFko+rTD72M3qL//QHHld+V3DlLrA+6K30af/PLcOhbRFO3jpsYePQhIWs7S4/
	 Wpqr1tK1IHdlLZLStlN+C203OeXrESVgdIAhEtLoVoCUSD8f9Bkje9EHH4E+tjLCh+
	 U79j6quXSpeuw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3369DC433E1; Mon,  6 Oct 2025 14:26:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220631] kernel crash in kvm_intel module on Xeon Silver 4314s
Date: Mon, 06 Oct 2025 14:26:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-220631-28872-SpIUrECr2D@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220631-28872@https.bugzilla.kernel.org/>
References: <bug-220631-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220631

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #4 from Sean Christopherson (seanjc@google.com) ---
This is due to a known a CPU/ucode bug where some Intel CPUs generate spuri=
ous
#VEs.


[  +0.000151] kvm: #VE 65dbc7f8
[  +0.000154] kvm: #VE 65dbc7f8, spte[4] =3D 0x8010000418c52807, spte[3] =3D
0x801000045b676807, spte[2] =3D 0x86100023d0000bf7

The "fix" is to disable CONFIG_KVM_INTEL_PROVE_VE.  KVM_INTEL_PROVE_VE isn't
intended for production use (it's akin to PROVE_LOCKING), and the help text
even calls out that some CPUs generate spurious #VEs.

config KVM_INTEL_PROVE_VE
        bool "Check that guests do not receive #VE exceptions"
        depends on KVM_INTEL && EXPERT
        help
          Checks that KVM's page table management code will not incorrectly
          let guests receive a virtualization exception.  Virtualization
          exceptions will be trapped by the hypervisor rather than injected
          in the guest.

          Note: some CPUs appear to generate spurious EPT Violations #VEs
          that trigger KVM's WARN, in particular with eptad=3D0 and/or nest=
ed
          virtualization.

          If unsure, say N.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

