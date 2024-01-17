Return-Path: <kvm+bounces-6408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECCC4830D47
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 20:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B5361C21D79
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 19:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72286249F9;
	Wed, 17 Jan 2024 19:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwsPXFvb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A75B249F2
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 19:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705519671; cv=none; b=hu2Xph/Zd+EIZoBfSdzFyRlNMmRfiHV5NeI1soODMb+pR6d4b8KZ1pf7HtDidsBaPPy51IGaqg5eifwqpeCwnn24ja9yp+R/jEE4FK6atZM9cq2XuW8HdNm4IJC5ubAkHDhQZziJks3JWjDuOnMJfnxe+bY/p2Gx7Q1tAar/9nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705519671; c=relaxed/simple;
	bh=OeaNVVnq8AcJMw42KwUVaszfHHwGayct/t6qKGN+rCg=;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:
	 MIME-Version; b=nTnGjbuEyV02Z8yQJuNmXQJfWMmV5W9FTkB+kh2XRjFpvHqQilvqaIW0d0aoy7OdtwvsWLlnNop0MqeFm0p5BM6zTee9vXqAzE3Kyoq0x7zQVOwrajyGT/3ash0W6I2OOoH+DZECpl1BnINvpM/xillgmVh2oOfBv5qd9FVBxtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwsPXFvb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 151B7C43399
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 19:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705519671;
	bh=OeaNVVnq8AcJMw42KwUVaszfHHwGayct/t6qKGN+rCg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rwsPXFvb3VeeCuV2crBGqhdYsBlyvAzeBMGGHMp/OQ/C0vYUwZ4FmCd9+OuI1ReSv
	 ZqS0amLh/iieS9N7TQIAVyvCovrWmTo6N9wzRE9MbNPlrCUGKTQF4DluDB/qzn+SVT
	 ukXZjutFhTrFv2NcKU0w14mxqEXwfAFBJcgEKgaeBXE+5QFxXVYLFCn7g7I7SeSLVD
	 zIsA/FhL62ILLM5rYnfCjm/8x+QhBaNSQn3y9kThNaWd5aAcg6nM38EhjaVqfO7EiE
	 xEuCvc9ScsTw0oU72Pg7KUbUv44gO4Ie1glpIHHhHU+pav90/BWdV758G+DhbS3htP
	 Ss/3giIUNPzKA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 047CFC53BD1; Wed, 17 Jan 2024 19:27:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218386] "kvm: enabling virtualization on CPUx failed" on
 "Ubuntu 22.04.03 with kernel 6.5.0-14-generic"
Date: Wed, 17 Jan 2024 19:27:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218386-28872-RdsMhE7cld@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218386-28872@https.bugzilla.kernel.org/>
References: <bug-218386-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218386

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

