Return-Path: <kvm+bounces-2350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E6CC7F5805
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 07:09:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B98BCB21058
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 06:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21F6CA41;
	Thu, 23 Nov 2023 06:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTYpzZlM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ACDC2C3
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 06:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06D24C433C8
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 06:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700719743;
	bh=B0ScQGNA/2bTbFldRauAN8+OaoWmtWxZO5w6jCxLv7A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hTYpzZlMFaCWHdcqWDzzhozOR3MVjvu2ZoHbR275hQLOl83jRjFo1pHpG/dqyZum2
	 SXSvzEjbts9PlxETj6+6ouLso7l8hXq99c9IMM8p2s/PtUS1c6woPvX4QXAEypBlDW
	 VyXxIaOfSJ2M/d/CmkvWl7/tHOTXtS1hQqB0523NqEoZhdO2zOAlk2YfFFf5w9ef+N
	 Z9kjSWDc5RzjxvjUsbJVX9mZLC2EYkOm7WHtVenx1ew3jyLVElcnuFPf1Rpx3jkrmD
	 Ms2wGmWY4LHmzYLLgwk/Rp67kB3qXOTsE1BQFJVSBWjJcpFXXhUNQquAbAtNmK27BF
	 10Xh4ZYSuo59Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E34D3C53BC6; Thu, 23 Nov 2023 06:09:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218177] qemu got sigabrt when using vpp in guest and dpdk for
 qemu
Date: Thu, 23 Nov 2023 06:09:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhang.lei.fly@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218177-28872-UEAn7FoX13@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218177-28872@https.bugzilla.kernel.org/>
References: <bug-218177-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218177

--- Comment #5 from Jeffrey zhang (zhang.lei.fly@gmail.com) ---
i also file a bug in qemu site:
https://gitlab.com/qemu-project/qemu/-/issues/1999

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

