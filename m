Return-Path: <kvm+bounces-59554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2963BBFEDA
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 03:21:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D80D3C4B1D
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 01:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B701195811;
	Tue,  7 Oct 2025 01:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8eCaoPA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9917527707
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 01:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759800113; cv=none; b=u0B5N0AmvjaTHp4LW34z3B/g4bhTdMALs601ma8FPpurs/ADwVuKgkmQaATKY6PX+1bRpxiaw/7LPBsi3UyskjlaToIMB7ZiI7++JXXNBVV0PnS9W4Dr/Tq2dJwql/x8eSR90sAQGUWNkUddn+zrasEGgZsNSbi2dYB/LtGEdCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759800113; c=relaxed/simple;
	bh=CgTyulkVQP9s5jgSL6Xt7s8zTBT9oxFDRL4CoEK4UeY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bz5kmt0m8G5t8r4OcEhmYIK5IMXwBpMhQpXCHe14gBw5GuGtJAO7JYq1Fn9TMIcYQ4ZjOL/swzZYGxZ5In0tO9GXAHcvcPPCeyVZwO9yE4R4Ayj8hZTNF9Xu2E29YDnX9Np2/Mrtb9lMyL9ht48SEMx0ugJtk4wsPyjRFIhUz9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8eCaoPA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DD53C4CEFF
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 01:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759800113;
	bh=CgTyulkVQP9s5jgSL6Xt7s8zTBT9oxFDRL4CoEK4UeY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=E8eCaoPAiZM6aP1nW7LhyvP2PC7MyR3i4bDX9S4dDAYAr9mzph0Disv4hWubtsgWY
	 ArTJOpPAQ4+CDEfritZ321fIF2JGMG6SY9BbkS8W1FHgx7lqGNBy9agskGHo2Cu/l0
	 Y5tJGKD66CrlVlVGnVH/hU8oL6PAbtbwfq0NRPqJUDE4tKALH0oIt/kSH9flC5qXLg
	 2As/tBMVRQkSAuEmGjZtOQ97Vdsnfea6r+f/O29HGHtAQBQbCyC8tgX+RjTzqFEXNX
	 Zkfwo3ZHDA89yZSkQbQa3Z+qve1Rc0gRXoWhUI41gkq72Gy5aG2HZATDc/pydDR/kg
	 Uuxh5bxocfMdw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 21870C53BC5; Tue,  7 Oct 2025 01:21:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220631] kernel crash in kvm_intel module on Xeon Silver 4314s
Date: Tue, 07 Oct 2025 01:21:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dev@boyd-family.org
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-220631-28872-YeYCSmotVu@https.bugzilla.kernel.org/>
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

Kevin Boyd (dev@boyd-family.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dev@boyd-family.org

--- Comment #5 from Kevin Boyd (dev@boyd-family.org) ---
Original poster here. Happy to try a different kernel but it seems like the
final comment suggests that the CONFIG_KVM_INTEL_PROVE_VE KFLAG should be s=
et
to =E2=80=9CN=E2=80=9D to quiet the microcode bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

