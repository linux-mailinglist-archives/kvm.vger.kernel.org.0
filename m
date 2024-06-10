Return-Path: <kvm+bounces-19153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05432901A37
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 07:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F1A828157B
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 05:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C28101D4;
	Mon, 10 Jun 2024 05:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgMeKwP7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C730EB64C
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 05:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717997806; cv=none; b=cxNfN8cJOZYRTojtrOQJq0aWqWWqDvQVfzM1rUWIJ9I6U6J03DtQ6ZWuC2D72STEXLIQA9B0FsNFLuD4//AJz9mJcrJxKlBEDwpmvg84MtqPQljSdQvs5HUcUaB9VyI9rWaeU+SPowflX+PTTGVsrjnk8Fry+9wtcIel8zATwqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717997806; c=relaxed/simple;
	bh=ITtXZGENWjoI0Fg7PAbVhcUoLbGw5ExnOvejqXNKdZM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZOU/NcemNKh+tWtC5+eCMa4thF3KXqY2GQDG7sAFOoq1QeWwIv1kJeq6VeoFEfX8i6f7oqfv9msYK2cL+myi8qwo0SIUxRHrJhPqgcMPjftRQHLQ12Zc4hGzaRTpYVogP3pprA1zGG+/CWRfFiLEkOvmBaIbuCmDTkfC8/khkHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgMeKwP7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFC56C4AF1C
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 05:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717997805;
	bh=ITtXZGENWjoI0Fg7PAbVhcUoLbGw5ExnOvejqXNKdZM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XgMeKwP7gkPMpNvCOUPqamCfL7T60AqGRQgUG9uL1UZH5JP72rg25/IoFSTx76B7u
	 Z58H61rb8Ko/S85waHSd4Zsqa0CLQ35dKuFmydI0HIAIxhQ01nOzoqHmhg2Ebpw2uH
	 IEESw0zuh7B2sJ+gqDkkWGcoIUZTm9zuRosY3jADdWJyUeA5K4jVjrUznaLQqOk2O6
	 hJT+bZCPMa5vIu072pGr190FL0Y66vX/rWcP1cgnfDKrcQ/yT7v0mEsS6w7YXxBdyY
	 WH+RM1x+KKQKp+WD3zqPdJW7iDNPTpkNxaPS3OWLM0xVmQSTW57kQVMmTS8H8yn+g6
	 hZhM5AEB4fRFQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id ACB84C53BB8; Mon, 10 Jun 2024 05:36:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218949] Kernel panic after upgrading to 6.10-rc2
Date: Mon, 10 Jun 2024 05:36:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version cf_regression
Message-ID: <bug-218949-28872-Yc62AD234U@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218949-28872@https.bugzilla.kernel.org/>
References: <bug-218949-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218949

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |6.10-rc2
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

