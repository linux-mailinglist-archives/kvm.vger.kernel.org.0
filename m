Return-Path: <kvm+bounces-18151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6992E8CEF48
	for <lists+kvm@lfdr.de>; Sat, 25 May 2024 16:20:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 055371F21532
	for <lists+kvm@lfdr.de>; Sat, 25 May 2024 14:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25B04EB51;
	Sat, 25 May 2024 14:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTLTt8Gi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049B427462
	for <kvm@vger.kernel.org>; Sat, 25 May 2024 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716646841; cv=none; b=aahZz/TLxwKm8/ZiUXQLR2iI0iJ8M5Hi2H8gcZKhGYDARxtkeHrbvuA8dEeCQNWIMHv95n9+NPYB4hUjoq2I1Et4D0c6dDcjvICiz3LejgS84P8QvRFRO+evJrYXCg0S6XcBNTbJSFH3rzD+qKx1KfzhnZNi2DhgSu4p2+KpGrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716646841; c=relaxed/simple;
	bh=RP0C5IAT5K6Df0aiggOrDsdB5g59Bi+UKKhmHKrhG/s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NYNYmn82pQ1LCQ6o9XYClydu96x8Brl17QD5K42se68ubvpLBey7T7XMiCn5QcQfr5mqnV9mMFeOe+BMZIJ7RvuElvWfkke9ZxiGaJgtaxdqB4p4tJFjb98hhbUmK1ROsNN57P1df1BZm5L9huRCV0BNgyFyYN5exfW8Bz6k/p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTLTt8Gi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8711DC3277B
	for <kvm@vger.kernel.org>; Sat, 25 May 2024 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716646840;
	bh=RP0C5IAT5K6Df0aiggOrDsdB5g59Bi+UKKhmHKrhG/s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uTLTt8GiZov4+u2+QY/Q2sjI9OdtRQc4Y7+di9pxY3V5USUoNpRiyzDTsO6ab2sFi
	 1tsSEeUKqjaZcbiLGXqd2miLJbCegNvwJhNp7gLnKbwahIbMdl327bluk1uUNSBF72
	 5tXBmiyBZhCU4bcftqGRWms1qmR6BlNTL5bwyJ6iRhyJdabSec9YcAr6Ej9twqpg0X
	 x0otGmFrSFP90JPpOWocofBChr0W8P42qt2jB1R0Xfrf124JFj3Bz2ppLMhlEtOmE6
	 i6buU/n9OGH4rM6LYMZv878EtpezxNImZwrzdd6CWUVU/pWZaxm9HxjwHUygwYmcZn
	 vs22Tu2/abGyA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7614BC53BB8; Sat, 25 May 2024 14:20:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Sat, 25 May 2024 14:20:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: linux@iam.tj
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218876-28872-G4ukuuGwGf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218876-28872@https.bugzilla.kernel.org/>
References: <bug-218876-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218876

--- Comment #8 from TJ (linux@iam.tj) ---
Argh! noticed typos in the rule name and the rule!

# this is /etc/udev/rules.d/00-vfio-pci.rules
SUBSYSTEM=3D=3D"pci", ATTR{vendor}=3D=3D"1912", ATTR{device}=3D=3D"0014", R=
UN+=3D"modprobe
vfio-pci ids=3D1912:0014"

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

