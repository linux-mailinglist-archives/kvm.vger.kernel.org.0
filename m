Return-Path: <kvm+bounces-22502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C00293F511
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 14:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA7791F2253B
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 12:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473CE147C71;
	Mon, 29 Jul 2024 12:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGRKtP1u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740081D69E
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 12:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722255623; cv=none; b=ocMMKS/SKn2LUiLn6CQgKXuW1qEtifQ6aNi/iQDOn2HZaqxyLFQ5J/+NpW+ImRumaOCF/ASBBwG38sTCsTFscsZGn272WJY43BF7kytdKDvNtnx3sDKHAY53gjBD76rmt3EC/YZBPY559TftLNeFQPrqmvA+aMQ/XtpikNMMrpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722255623; c=relaxed/simple;
	bh=Nd4ud9Q06Ot4z5oOBOxDlmS4VLbQ4YXjCt4Br8wc7DU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qo/npf08JFQr1M/rEt2CXJJ0Z9oOwDPdQw33I5BR8jYXKQeKQJLTseGn4LgWr/0QLe/78Uvn2qdd49SF5gXzZ0xEIPx4zuhxnp+lLZTGEtYEBt6BhdrukOEc4f3PRCAeEJsBtalkw+d5wWKoeVPAr0qJyyytb8viDLgA7240mDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hGRKtP1u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 396BCC4AF0A
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 12:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722255623;
	bh=Nd4ud9Q06Ot4z5oOBOxDlmS4VLbQ4YXjCt4Br8wc7DU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hGRKtP1uRHAH/KRno0An4/FJ+VuouiYYDrYx4zRMW7am/tsDV53zu8uch57iZCZyj
	 cLyfuR+0mpoh9pSVuLSUUXyFR/F4z2QwP3fBe5/9QlfGOs1H87UMBTh+W8FQeqr8Qx
	 LjdJt3RqQ5Opjz9kYOveI/06z3QFOnVk+UnSXS2tB/Go02RPzZOdSFkjqwmDSWTM9/
	 A3cbTFzRr6UA4KB+RzBUbkIFg3/7vPU6g5U3moPyrn2RUaNR45sYTJHZ9NoDjDuEac
	 3nPPnY73xbNJtlMhh+kMeXled3sHXUpQ4F7Cns/mkZbktnok5cW0XRM4AbF9x7GZ51
	 61sXOkQ+pB5Ow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 349C3C53BB8; Mon, 29 Jul 2024 12:20:23 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219104] A simple typo in kvm_main.c which will lead to
 erroneous memory access
Date: Mon, 29 Jul 2024 12:20:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: trivial
X-Bugzilla-Severity: low
X-Bugzilla-Who: zyr_ms@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_severity
Message-ID: <bug-219104-28872-jqoFtxTWas@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219104-28872@https.bugzilla.kernel.org/>
References: <bug-219104-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219104

zyr_ms@outlook.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Severity|normal                      |low

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

