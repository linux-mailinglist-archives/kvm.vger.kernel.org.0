Return-Path: <kvm+bounces-5695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCF2824BC7
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 00:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D7371F2322D
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 23:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE472D041;
	Thu,  4 Jan 2024 23:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKNEKWbt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AE02D025
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 23:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38E8AC433C7
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 23:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704410484;
	bh=A5Y0grwi69krV7ZRQyiu0UAiRYJqNPUDLMhhC04vzKM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XKNEKWbt1/jgvAOpk9ZqY3rYde+8QVWWrb1pTxHWngctemoEJM9SV+Fo8licgtQHx
	 n2i7XBDQ1LwEDV5KCLzvcjT/HXtBcrwIef0G5C5jAZlX+F09pafxD65eg/xj1kbQJx
	 RxrsUp4JDQuNaxnVY8rJio9vClzhFlRM8MqywMrai2ZOSO2SBmtNR+SX33CF0XM4n2
	 V0if3bhQNU4XDpnCtS+YgcMl8Ij7WJ5NGWYEmXP+CBcQbOYCp/TUbBElrKl6eiRv6F
	 UsWfJSH3uod76T22dAe+QFvQLOSMsDVCi2FXzIyGzC9mh0e1HsA7hseznSclJbNeCV
	 Bjc+AozGqsF1A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 233C2C53BD2; Thu,  4 Jan 2024 23:21:24 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218339] kernel goes unresponsive if single-stepping over an
 instruction which writes to an address for which a hardware read/write
 watchpoint has been set
Date: Thu, 04 Jan 2024 23:21:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anthony.louis.eden@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218339-28872-RAjRBiiYdO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218339-28872@https.bugzilla.kernel.org/>
References: <bug-218339-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218339

--- Comment #2 from Anthony L. Eden (anthony.louis.eden@gmail.com) ---
> By "the kernel", I assume you mean the guest kernel?
Yes, the guest kernel. I can no longer interact with the VM via the serial
console. It is unresponsive.

I attached a debugger to qemu-system-x86_64 to see if qemu itself was in an
infinite loop or something but the stacktraces all looked normal.

> Is this a regression or something that has always been broken?  I.e. did =
this
> work on previous host kernels?
I do not know whether this has always been broken or not.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

