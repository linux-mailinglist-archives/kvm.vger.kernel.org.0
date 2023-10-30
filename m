Return-Path: <kvm+bounces-38-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4969C7DB306
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04D2228133E
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 05:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C0A17F5;
	Mon, 30 Oct 2023 05:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="On0y1XHH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5651370
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 05:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A14E9C433D9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 05:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698645376;
	bh=2DW+eotKiU5P31XdUD56f9NhlTdGavb0IOdEYyK8JMs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=On0y1XHHrQhubybUxE4Wo7MgSfMM/15rHaOvY9eirxXhYMvOYB5zbCSa0uBbNOQFV
	 CCkpPlaLEsVfL+rypAvNFiBOggbtLBU+I4uH45YLA20kXPP4YMvfY3CacMS5tHNlj3
	 77To/ZRIoeONZNLJ69FvmdLgT2gI2oQm1lOOdNUh3mFQr6wsf+EcNCQyZgmPmKWxDM
	 O9yrJRRcQcDbcgiwDc67kr7DZv8txierkk13JjLmXaAFc1VTp9VMsgM+6Es1fQki8Y
	 cFt7UxTbn5xiv8ZaR3+5yJpnGb4QNfnSA2Zq172UWHrahESOh8gX5zy94mNGRanakf
	 84IIqeGUv6AKg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 90676C53BD1; Mon, 30 Oct 2023 05:56:16 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date: Mon, 30 Oct 2023 05:56:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Drivers
X-Bugzilla-Component: Network
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-217558-28872-qegfkqxGSq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

Chen, Fan (farrah.chen@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

