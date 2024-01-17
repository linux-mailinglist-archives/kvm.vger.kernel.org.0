Return-Path: <kvm+bounces-6381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06776830174
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 09:46:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4DE12870B8
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 08:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1051812B74;
	Wed, 17 Jan 2024 08:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OvHk0CwV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A890125DE
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705481153; cv=none; b=ftUtPTEcQmgEt0u2kg90bs4Nt9JlRyXxo7JeGoeCV7NQ731bEgwUVOB/ZwO9/Ux6JXWbvpsy4b+IfULkB9yi4M+iAOB8RPT5ttwt9ChA5HJoloVU5znFLm965Oj9koCrb9TpcnhVFpLPWpoE5Rjd6KriLqtrpil/xgJsgD6OUWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705481153; c=relaxed/simple;
	bh=xWsG1VetkWAVVYCwg65wCUJYn7GQLU6BrhnuVqc1iPc=;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:
	 MIME-Version; b=dqB2b/T74wEx2hS/qTMp++6nXk/E0w5KWeVTWyibEO0eVVcXFBhw7mGw32eZn1dtiwQlDtvIlxLVk9xFcvY7pNK3bhLZYg573uqj+qlA7j/+evuuFFuTq3xnToHfLBipjo0lN22doNXoiXz6qjhvK3/MYgUABbLh1RV3V8DFZfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OvHk0CwV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA6D9C433F1
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 08:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705481152;
	bh=xWsG1VetkWAVVYCwg65wCUJYn7GQLU6BrhnuVqc1iPc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OvHk0CwV/0mlGWCat8CNX/Y1lt9B/UvgME8vc7czPd4VAQJfboK+rP/pOHookdhJV
	 Sq6dQ0UHFPVLwkim+GM1QwJpYO/qzmKW/GJE3HsEjX+Nu42NFsw26X2ex3SHH9ZSZ2
	 wSHj3dmTdlDpN3IIhDkmwGdFECAoqzNPH0EGZV/ehU5uSzNevK/pww0yvss7CyOcSW
	 tV9ZYTIWaYv6mkLuVXhEFqo5XiXBArlMXF8HYqzPkUB49f5s3v8jB/JxagSlxF13Vj
	 AVscJCa25oSQt48z/a/wLGrLIBjjHu0kvcB8haNjlBR76pCfxpBZ0vyZoj0Uw55FWQ
	 o53TLJNKR3qpA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AA314C53BC6; Wed, 17 Jan 2024 08:45:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218386] kvm: enabling virtualization on CPUx failed on "Ubuntu
 22.04.03 with kernel 6.5.0-14-generic"
Date: Wed, 17 Jan 2024 08:45:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: antonio.petricca@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-218386-28872-3gFHGIvuEn@https.bugzilla.kernel.org/>
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

Antonio Petricca (antonio.petricca@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|kvm: enabling               |kvm: enabling
                   |virtualization on CPUx      |virtualization on CPUx
                   |failed                      |failed on "Ubuntu 22.04.03
                   |                            |with kernel
                   |                            |6.5.0-14-generic"

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

