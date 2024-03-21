Return-Path: <kvm+bounces-12349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60647881BCE
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 05:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8116C1C2142D
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 04:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8FFC153;
	Thu, 21 Mar 2024 04:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJJ89nQZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333D3BE6B
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 04:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710994188; cv=none; b=u309E+X/i5ewIS6tHRPFwJOobi3g/zpbp/ntQTSdqBFZyg/nbLHCbPIlpe8PbalJiysyI9EzEu7aQs4P56gj96C6BVCscUokRg4Hz3XZkW1erb3oq5aGRjWpTXCih2clRbcSGBvZPsR70AkyXn4M0gL/AT4nJVdcI8XA8KAAE6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710994188; c=relaxed/simple;
	bh=3Na1Cynvhp69tNzJi/RUXOlPeJ4HmO7/o9+Mm0j2NcM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BRXF0R1kZp0jUwCI0kSfDeRpcmWaw71ypzT3kDcM4d8jU5GJQ7SI2fnZ8jN6yu9F0eCmJMU3x9K03RpQTfiCuAPhhZHNnhELPC1Yi+F7/KytzekuhN22u2FNcW3j6JmO9uQn4dygI4zX8/wVJx/QxdGq7yCZCaTImvK4AJsfZrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJJ89nQZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2423C43394
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 04:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710994187;
	bh=3Na1Cynvhp69tNzJi/RUXOlPeJ4HmO7/o9+Mm0j2NcM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VJJ89nQZzaAW7gkZgc6FIlDFhOojtv7bl4OZY15TVi4DeEHPPETrkcrP+TMtZTcwa
	 zT+OoxHecr3HZPr3PiXvY1ZVTbmGck991flXWk2VjE6Jyf/CLL1IEczEuyDzkvwc+K
	 4T2PTmmBNQcSux3EdPVHm6s8sNvwLhOCkc2495Xgjl2Vej18X3pcjDpHxlVw/YEL3s
	 ONFE4ZVefD2IdKscOT9v9RNUMui85d9tKUI4D7+DtHkTU2pzoCuSx3hTJTeMGmDscD
	 cMihWpq+O4BEQjl45v2dyN5QxTOCMWXQt6cVMh7ic1UbxjBi2Bv7vv+rX6qgwnny8O
	 TlHwyXN/W4IaA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AB5F4C53BD4; Thu, 21 Mar 2024 04:09:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218621] WARNING: CPU: 5 PID: 11173 at arch/x86/kvm/x86.c:12251
 kvm_vcpu_reset+0x3b0/0x610 [kvm]
Date: Thu, 21 Mar 2024 04:09:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ne-vlezay80@yandex.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc cf_kernel_version
Message-ID: <bug-218621-28872-eoMWq9m8ZH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218621-28872@https.bugzilla.kernel.org/>
References: <bug-218621-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218621

Alexey Boldyrev (ne-vlezay80@yandex.ru) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ne-vlezay80@yandex.ru
     Kernel Version|                            |6.8.1

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

