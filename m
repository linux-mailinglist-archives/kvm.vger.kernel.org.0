Return-Path: <kvm+bounces-14629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84D598A49CF
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 10:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39D741F24738
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE013364DA;
	Mon, 15 Apr 2024 08:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEzajtnN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243423613E
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 08:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713168582; cv=none; b=JYinigfK7XGRt8meoOa+oz+9ZqTJnwmRzBFCoKZxOkMziGN++iNP1VHKwTkU2QDAh5tzQu4FyljbtaoCAtRHdNX7Cd7vMjKLsaJMr31muAuZ6LuSW97l0S52MRR+7gZMk/dxUrRpFPSrm33YIhgqz2cXeMNW9iK5rKKU4LBAVWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713168582; c=relaxed/simple;
	bh=u73evQjQsNLA3yvgpwl923aejyJMWwCzkFx6NopO5LU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ws9MMOIdpCpfhAb5jpEtPY5nmMHY5sN+JR6Wu9vw5rEjbMrfDDLbXaoEF9Z0TRvZ1QbE9yu71EYQtDaG3GDEErD1F85wAogDt3wxJyaNan/eH9kEfOt19XzZuATDO1v7Ur7f1H77SfTNxRohNj7p9gPB1WyGXCFJsJE5Ym6wxJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEzajtnN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B49FEC32786
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 08:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713168581;
	bh=u73evQjQsNLA3yvgpwl923aejyJMWwCzkFx6NopO5LU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YEzajtnNFwAe+8SPSICw/hEkIr1i3pgxxKPZpD+8c4lljV1Qk9BMRLJpiWhaA3CBE
	 2BiG2iuJFW1vl/S15EzazLpCcg0Mc9me/EW0hph7hpjHJqoQLKsPUF+GXDgWQ6rIAe
	 EM2VDWJceW2OSus0AhvYMF1+rWN2W3X5wG/3SJeX3sSQ1GN+txtAkbW8wsnJe04A5r
	 dR7veek1dc0iSQVS5eeNaIvbRvHp5zve0yGnOLFiztKV+hFkMTRKjq3Q+ewt3aG8Cf
	 gFj0zEyiQwZZ9Gc+EygJ2JDofWYxVb+90AhHfnugpJDWLAbEm2qxlKacBTKNvucQuS
	 6wCmdeJKSR7Kw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AEB8CC433E2; Mon, 15 Apr 2024 08:09:41 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218257] [Nested VM] Failed to boot L2 Windows guest on L1
 Windows guest
Date: Mon, 15 Apr 2024 08:09:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xiangfeix.ma@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218257-28872-f0Eb46VlqT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218257-28872@https.bugzilla.kernel.org/>
References: <bug-218257-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218257

Ma Xiangfei (xiangfeix.ma@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xiangfeix.ma@intel.com

--- Comment #2 from Ma Xiangfei (xiangfeix.ma@intel.com) ---
This issue cannot reproduce in the latest kernel.
KVM commit/branch: 9bc60f73
Qemu commit/branch: 927284d6
Host Kernel: 6.9.0-rc1
Host OS: CentOS 9

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

