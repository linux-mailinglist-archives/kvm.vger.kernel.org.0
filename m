Return-Path: <kvm+bounces-44715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F0BAA0534
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 10:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4524F48344E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260DA27A12B;
	Tue, 29 Apr 2025 08:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2sAlxFD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB3E3595D
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 08:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745914112; cv=none; b=A3Oe59kuKupc5TqesAaq41uphahUGi5SwQfX+nOfJZ6JbtQKP6+MN7VJWoR8+S1zcZ7QVfaprTdhYBZywPOhBK0nWdtvUaGSD5GalkhTeIo/i5UtCJfbdLBVDrh0kESJMAm0yfKatWJ3qBmCcCspuJLmmitqCFVI1wjIUMaAAmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745914112; c=relaxed/simple;
	bh=WIUTwYSNkepnB8+WREYA66E+FsluTP4GO0LoKd0auHU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VaRK5pG9/kBMUgTkfKyLi8vQgtjYmA1C9MEXGRrWAsyqdBkVHITmcUCt1+Xb4ISyFDvnrau2EhTswPMTsNWZmGrb+qIUmkap9fwuqhA2fkl67ChsQgqBYJckw4Vc68xHyFXBDtz5fTB+WIQFy1Ikkmr/XcaMorBv9tM8cPbHbQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2sAlxFD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2CCBC4CEF0
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 08:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745914111;
	bh=WIUTwYSNkepnB8+WREYA66E+FsluTP4GO0LoKd0auHU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=T2sAlxFDsXBc7TSJAiC9NzgjdthgS4nkIGH/V09I+v+0ajOejWcdiI4kJYp3jn9kh
	 q4IlkLNrRTPViQX/zbIp8bEpaSpZWucVeqItkgGVk233vbD7ZCBhIbMTOl8ajSkqPY
	 NG5hR5epsvWtol+DA7KNpPdpID/5HnH0J8tv5IWEfvw7lqS0snp9VImkYVtbThu9Z3
	 4m/iSutw3JRAEjHiS878wTliW90udaGErWImoBKgFM7+gbaogF69v5S5uM4I1hLLNK
	 AtxWySSqzsHaPn+88vGN980wcoksUC/LhV7p1gUZ4VQtKeVv4GV19MdXApzVOiWqow
	 RJ2qbLa650N0A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E8D34C3279F; Tue, 29 Apr 2025 08:08:30 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 08:08:30 +0000
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
Message-ID: <bug-220057-28872-Ziu1z7pH8J@https.bugzilla.kernel.org/>
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

--- Comment #22 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308049
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308049&action=3Dedit
phys-bits=3Dhost

It seams phys-bits=3Dhost, actually changes something although the "VFIO_MA=
P_DMA
failed" still shows up.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

