Return-Path: <kvm+bounces-4443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E03A68128E8
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 08:16:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 952E41F21BB9
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 07:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF0D12E53;
	Thu, 14 Dec 2023 07:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2Yjd8MA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5DE125A9
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 07:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 123CCC433CA
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 07:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702538157;
	bh=3Ow67Spx5Bo857JGiFoPfcrSFEyQ50BCdTap7x52Z48=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=M2Yjd8MAVtKjAnk7MvEeqFRV03ARykIteq1F6gOD8ugXP8BmoWNpat0/2XSlgehU9
	 r9QKfUuKy/sC2XDORezPNaEyf21aO3NdyHcsR6129YoVUTFNfPOTxaBuwUoIwEUQ9E
	 Tyglf1ppz+1e/eT4mzc94l7y1BDfXU92vrYkvEeuv/Fi4OiXoRR7v3moUOYTl0qQJq
	 oLymp1vWjH1L709gVAJjUoqRqx9vX/su3grxH4t139p5k2vj7pdVb8pbOSe2dkBact
	 I+7+CxzSn5mzwt5FciUInIcjBa5wGYHZpgbAfIMTnhOei0LOOORVo7pm8j9WC7ZsjH
	 RUsi31uQh04ew==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 02A7CC53BD1; Thu, 14 Dec 2023 07:15:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Thu, 14 Dec 2023 07:15:56 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218259-28872-ddCGmuIKJg@https.bugzilla.kernel.org/>
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

--- Comment #3 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
Created attachment 305596
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305596&action=3Dedit
dmesg

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

