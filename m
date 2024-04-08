Return-Path: <kvm+bounces-13839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F2BD89B71F
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7033F1C20E76
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 05:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E604F79C0;
	Mon,  8 Apr 2024 05:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdJu6Sex"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B586FC5
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 05:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712553699; cv=none; b=NlgIkB4gqSrwncnx59E8u/pUpN0QDqiheo4ReLE6y6IImnjSnpZ9pi/aogGXVfUOcMuJRoNAx0S2THBR3P8kbLORwYgQ9cPti1srZOmWKSlS4DWMmV6Mbh5sslQUpnq5xu1xf9/nXLnU5jEYv3dhVYeJVmrikV28FHKWcLBh9zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712553699; c=relaxed/simple;
	bh=GDgTj9m4FQAki97WJEu27dtqVRWvwUifJjXjsRvyTjQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r0HLKT/GAeCRVTEmN7mbd9B3/MN7WzOGaskXCVbHp5FxfeOfhtdR6ResJcUn02zDV066MEuZKWL8I58pE9sMllztSQqVlpUeaA5pWFSLBM7XFh7GbOAqed3M/elbcUOgv2tJTjmNq2/WN+/tsBUCQ1xNooHNwKgKo1UZbVSwqKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdJu6Sex; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 912F6C43399
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 05:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712553698;
	bh=GDgTj9m4FQAki97WJEu27dtqVRWvwUifJjXjsRvyTjQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JdJu6SexLj8brxaeQqzfXsYOSElaxii/2gkG47L/YTpj+GbBCnILxqwQTqgmQLib+
	 S5MzE5xnbfngxZplYq1Nt95LDlJGjaDoyHHghPkP5tgDZjav4j2qDW45kosjKVmTZn
	 k/BeFaeygf4FfhGQgzHYIruuJhJzfEexZsE6nrJzTi1ZXnBLSP04HDjEswbe/j56MW
	 +IMjBpUWG+po4QjkI7ztI90dlaWGRDdzEpUW3S7g56GhUaOXV6v/L7aG0JKnY+f/Jd
	 Q6LR3/NCVGB1Cra4PXT5/ePB3J9QnAGGKA/hpOOs5h791ksvHepxKVW0hDnDy5tj0l
	 bBH7O+C455a/Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 85829C53BDC; Mon,  8 Apr 2024 05:21:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Mon, 08 Apr 2024 05:21:38 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218267-28872-idOxF0nLUf@https.bugzilla.kernel.org/>
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

Chao Gao (chao.gao@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chao.gao@intel.com

--- Comment #3 from Chao Gao (chao.gao@intel.com) ---
This is not considered a Linux/KVM issue.

Guoqiang, could you close this ticket?

Yuxiating, I assume you are using APICv and also have "hv-vapic" in qemu
cmdline. At this point, you can remove "hv-vapic" to work around this issue.
Note that, APICv outperforms Hyper-V's synthetic MSRs; regardless of this b=
ug,
it is recommended to remove "hv-vapic" if KVM enables APICv.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

