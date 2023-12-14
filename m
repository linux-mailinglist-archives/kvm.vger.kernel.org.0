Return-Path: <kvm+bounces-4444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3AD88128ED
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 08:16:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E4B6281FCB
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 07:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B718DDDC;
	Thu, 14 Dec 2023 07:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+c3+x94"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F9FD26E
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 07:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 185EFC433CA
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 07:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702538186;
	bh=W4QHKZhIedZQ1cZMw+tK+Bry4CBdVBScjm1Qtop48/4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=N+c3+x94vQqxRYGGIZwftdksEvn+A2K2XclnoQSLQ3ZlIvag/qbuXF2ByKavtk4XW
	 WJSAtv4HT1p3vP1ryB0jRjRB+CAKx6BQXOYcq3RFkuK9VuVcbo2JiKQv1fnV0JCzoa
	 epKg8TJCSHFRzxQv1TaZMI0Y1iLZnlXGsvEHftSBYZXzKQJ7Niup2TEAb6s3mjPMJj
	 2/69SMqpFzl/E/jlQtk3SmVN1okCrf+AL842sAkLbrl5wVCHllKcE6+7gzHggmtGr4
	 pdsU5NZwTnBNVKQipUgRioBA6cCOzEvttSieMdBsH9fbZkq0mggDN7aEKTv43H1lWV
	 Anue+P/azLUAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 08605C53BD1; Thu, 14 Dec 2023 07:16:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Thu, 14 Dec 2023 07:16:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernelbugs2012@joern-heissler.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218259-28872-fud6TikVgw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218259-28872@https.bugzilla.kernel.org/>
References: <bug-218259-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218259

--- Comment #4 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
Created attachment 305597
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305597&action=3Dedit
lspci -v

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

