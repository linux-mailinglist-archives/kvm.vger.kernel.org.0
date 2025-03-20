Return-Path: <kvm+bounces-41573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 389DDA6A90B
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17ADA46008D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8341E1308;
	Thu, 20 Mar 2025 14:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JikOV9vA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CC83594B
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742482124; cv=none; b=mip6s1/t5giSFq18B8MFtNmpS3LvGwFJWMwsYlb8TS3PyvzKHGeWFOSgx5OTCp8yfx+EYpTZyGV+hjAuUhf+fEBSbJGqpFQV1YkWJCkKNGxac5csixB+4JIZIqVyKRoUtHmrISiJ0E3EpLaHta7tiTSRVrRym1e3EjXnaweqSXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742482124; c=relaxed/simple;
	bh=mrR04/0wGINvQ+lyTC97PYkg6l19gBfoRD44tC5PSEM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R3kWJOQMIpK8rO5HlHguWA4wIPuKNoB3gfyahYlZZwF1R4WgHtYXFzuFg1ol4ZiFwxR76zUQhF8bV21d/rsQfhBcC+IYoanHnqwQdeP4qtPnFl8+Gg1okqD9P67ILJ3ingjWMdiChR7jaEflGX/Td2fz8tMWCPFpIWxZ/xJsYDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JikOV9vA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9ED23C4CEE8
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742482122;
	bh=mrR04/0wGINvQ+lyTC97PYkg6l19gBfoRD44tC5PSEM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JikOV9vAYEIRWDjkna+oReBiFyfZVEwossQwWQViU+l0BZ3Ne0WXQQ/EK2akGhl18
	 vclxUpwibiHeE2bFkdzbaNwIHn5O2zt+WnkxIZL52cuJiRBFlxIyXcqc4rlxVb+6Rd
	 do9X3+6SwqhtxuiIqb1T5RhOud2zZoKCIW8NuTBnd4M+I5zzlBxpNG1U7l4mkhmzWB
	 f0ACTxcQT+S9nONuLRfDVsfYyAK0KZifSnz8a3nStf8bET0+27Fa0R+i1GVzekCacH
	 f2wERA/vh1PvhAAgAYLYXazs4byF+8hW4l0Hc8VK/LVcmd7664hrHkHiABbNirIP2J
	 /7dSzk+rtvIAQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 97C40C41612; Thu, 20 Mar 2025 14:48:42 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219588] [6.13.0-rc2+]WARNING: CPU: 52 PID: 12253 at
 arch/x86/kvm/mmu/tdp_mmu.c:1001 tdp_mmu_map_handle_target_level+0x1f0/0x310
 [kvm]
Date: Thu, 20 Mar 2025 14:48:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: leiyang@redhat.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219588-28872-t1F7LHHwLc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219588-28872@https.bugzilla.kernel.org/>
References: <bug-219588-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219588

leiyang@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

