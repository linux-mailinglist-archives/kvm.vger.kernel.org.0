Return-Path: <kvm+bounces-4980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B9B81AF60
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 08:26:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F8461C21A3B
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 07:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA75511735;
	Thu, 21 Dec 2023 07:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZZDrDVn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140D7D2FF
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 07:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89B0BC433C7
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 07:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703143572;
	bh=SC9czqqIVWMqv7wTVyWUvQ0Ezg0+xhuK76WYjPzVcBw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NZZDrDVn4pY8Zzz/qiswSCDZdV1hiPf9yhxVcmew3HNRDwER4h3TdwpSbTKnKUkCu
	 62QEfwlLNzFdyu518iAjM0N1vnNFwzUsam5PmC2ymDVYvSjQUEHieQFRXBEuOKaz0T
	 O5/1qz/yn9xAuemRhnljb/XAiTM5CaoIl9WKhRZrvN0CQmUkUQbk3LE4S32H0sU2iI
	 dSSLa5CG5f4xcfRW+PTMlSwUqLOC9oI4zylXt+kcmAxo8qjOLjHRSYXbePUieL8rZQ
	 qYiMPtj9XHIq1fyDcambOhhA1hlYUxuiIaa4Vsw10XL9tMQIYE/eG9XIAcbe4J5Oe9
	 uQOL66jLB4K+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 70F20C53BCD; Thu, 21 Dec 2023 07:26:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218297] Kernel Panic and crash
Date: Thu, 21 Dec 2023 07:26:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218297-28872-cfrTtwd60q@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218297-28872@https.bugzilla.kernel.org/>
References: <bug-218297-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218297

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
This kernel version is not supported.

Take it to your vendor please.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

