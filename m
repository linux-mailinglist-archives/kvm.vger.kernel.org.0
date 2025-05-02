Return-Path: <kvm+bounces-45276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F154AA7C9A
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 01:06:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9FE137B29DB
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF19321A435;
	Fri,  2 May 2025 23:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EiEHRAKw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B79F9CB
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 23:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746227183; cv=none; b=b4AnZNaetKcxdld/Q9upxyZDzSPMwJMVR3SIncLObYw2WJ19Sr2f8Cv6uUVcL3y8+KE/IQvMa3U0tn5fOFlthZIu3gonyqYdKkhcqq6fGNP/H3qtXLtK67NOe7TUy3sGR2VM7/GQDGLGlqehU7fFtuHZeSZ/CwQq2WVsTEvwuP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746227183; c=relaxed/simple;
	bh=L3qz6kcFEdQeDdedCbuGaBBQYXNuWvAQxAS7kYlZyF8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MKrfotwkKVnZ5u8K4KgUfy41BoqXkDT17jJudISWKcilk48MGqB3Jtr58HDf25CB7D3zWCHVzljPjbiVWn9ch1c00TZhFjQW4EGDYTQ71b57Jy3u6DmahFwdDa6KmGC8OQVApe44hTzUWgKhQ1wkdxADXJAUzrVnrUTiaKx9tKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EiEHRAKw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5781BC4CEF2
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 23:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746227183;
	bh=L3qz6kcFEdQeDdedCbuGaBBQYXNuWvAQxAS7kYlZyF8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=EiEHRAKwTPh+ljyfh7zZKifsac9TRm3BbqQpk0Rk40MlTwa36Ber0nj3XQYhjNT+a
	 P6G03haRKhkG1DFOqx4AyvyvYKjV2HNIPmd6zTXiPBt2cxhww6dE/sLWyLq2FPEJ5Z
	 7LbXl1YBOYMAbc4iB4zaIWD/sOaDDjxFygSbHS8sEYs8dWETGU1As2VvLW/UQNpwGS
	 SNHEP+PXWYe0Weao+ePUdm5ekj6y40Cwl1gLM848z1lCQtclyF58J1B9ZSBa60sJLu
	 pa2LMSofP0T+0iisMEHVnNGog3Q5hEq42dhz9xnie9CJmeU4qrp1bvOWOYTq9R1BmA
	 Tv1LjZ8/6D1CQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4EA38C41614; Fri,  2 May 2025 23:06:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Fri, 02 May 2025 23:06:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: adolfotregosa@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-220057-28872-EBgLujFVsX@https.bugzilla.kernel.org/>
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

Adolfo (adolfotregosa@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--- Comment #47 from Adolfo (adolfotregosa@gmail.com) ---
Thank you once more. I'll mark it as resolved.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

