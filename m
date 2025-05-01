Return-Path: <kvm+bounces-45103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB81AA6068
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:03:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52CC9467A05
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43EA0202965;
	Thu,  1 May 2025 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tNcsthDA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6832A1A08B8
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746111810; cv=none; b=JEBr5Gb57DqSmjHMJ0fYTCaFvDagpMngdhl8ebqbkbnfS26bbnlYpF9uF4HfqEl9C9ODf/m9lB4gaN5gle3mCva4Z7UtSf3hRxjy1egsykVgkgUqwq3/4qB73yGWa0FRL+rw8KYRGI/NOQmHwllJKC1C9+EGaaEi/gS1RbilzQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746111810; c=relaxed/simple;
	bh=K7h/S+aFrVMVnIQQFNyNcNgq2Ou6SDrrIF+M+GCjH8Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MPQy/viwJu1+fIn5PLZroT+hCeSnQG/O/UoXNfxr41INlPtEa+F7wFemuoRV21UeqvLjnIuOWGOJz6gzhhF9cjsznNGQqFXQGzdJztNB9uNqzZfS9V0Mae2Kuo8AlHjzEZLkKZVQCnwnYt1Nv3eGuDi63G5Z+z/jIpo+JF5YH0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tNcsthDA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCC53C4CEF2
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746111809;
	bh=K7h/S+aFrVMVnIQQFNyNcNgq2Ou6SDrrIF+M+GCjH8Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=tNcsthDAv2kBRgPAcC3xctnrMoxxEJcXtgYucZs2tLnJKiJ9JgJxQOog2r8kZldbj
	 9dLg8GR6BY7xBBToYm0909PpmfVO2gFAETNJ2YZeIjOTa9of+UBnuUI3GbxKfU9aps
	 yKZazBnKQvXpuUpjnnkhyNybxJN+Fu+gg+anSUV48g7Lh9e4gwgBh7e/b2xwu/4o4P
	 7h7C1KQOqm+rtxlhaSlDK8PhuGVOMicbdj5PlKm02+NRVQIw7GVsQ18FBWQnr39DFz
	 ipVuRPQYJ48n2dodVBDiy5JpqNZa21/9I1Bnrzvhbs2AmzsN/C4bCvQGVWTHnjZhJc
	 HNmJPhBgp8u4A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D733AC3279F; Thu,  1 May 2025 15:03:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Thu, 01 May 2025 15:03:29 +0000
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
Message-ID: <bug-220057-28872-74T9JTJBOP@https.bugzilla.kernel.org/>
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

--- Comment #41 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308066
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308066&action=3Dedit
hugepages_testing

I've done 2 tests. Reduced host hugepages reserve to 40, started VM up to
crash. Then I configured VM to not use 1G hugepages, proxmox uses transpare=
nt
hugepages in this case, and logged VM up to crash once more.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

