Return-Path: <kvm+bounces-12805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5363988DD01
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F51282D63
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0371D12836A;
	Wed, 27 Mar 2024 11:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S41pFGRJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305C1CA7D
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 11:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540767; cv=none; b=NXSVFqCM7BxziLASurTywx55050xI2t0NDcYI0unVnmnejQImkBhj21KZ92O/Bi8DmXSNN9TMC2slfuD2Ude/foOUQwu9FC+ygPsA3xdl+XYtBSHcrX4i2PLJlcwFmZZzBkjpSm9tOBi8KV4ARHv8+jRsttKvG6Lz64g4dYl21w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540767; c=relaxed/simple;
	bh=K4QOSJClOnuW1RdWcwCnwqzvYgjBL9H5ZMNW4e58Bvo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=afHSd7G91yqt+lD1l46TtUg6ekKmCW/rSCRMB7Ujn7PVY+FEV5vp1yUhFAntTKycHplrcYBqqXpfE+iEDDDkMiLSpx1DCn072Zq9j4qy/al1ElIrWfDKZjTsDeINNBf9xSnkmMS7c94pcPhci8F/EkhmzFYSvayXcWcyre6SKgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S41pFGRJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B00DCC43399
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 11:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711540766;
	bh=K4QOSJClOnuW1RdWcwCnwqzvYgjBL9H5ZMNW4e58Bvo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=S41pFGRJB7ipL5bTT+SOp6aeltkAI+fp/6uAoPVTyHhi1u6eoXZW2FqEu1bFx+4Oi
	 f4+aV6y/DUWEm04c90X+HbDb3vKQYuRmyNKIG3yPCR94WxZ2RWMPWCylU37dlVrs5T
	 JUzEeeReuuseZZ8LuX3VeueFeNT4QGJ1lBrGYe1p8fprJvM2Hd6vbgKKZbwVasGKfl
	 3pLpQYT/GuCG2G4gfTNa9BKGpcmP4Di8WjY2EzGBOa/tej6OlVBE34lUYz4KmXFBZP
	 D3vE65448Hc9/3TRT+5oUqhWSRQGD4Mn0zVIsEs2VRfDvBsg0JpIx6VP8pNnaCTsfL
	 pknE1MSfPlDKQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A51D3C53BCD; Wed, 27 Mar 2024 11:59:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Wed, 27 Mar 2024 11:59:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: yuxiating@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218267-28872-5ZXEFNQYN2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218267-28872@https.bugzilla.kernel.org/>
References: <bug-218267-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218267

--- Comment #2 from yuxiating (yuxiating@gmail.com) ---
Do you have any progress on this issue?

I have the same error on Windows 2008R2, but the same virtual machine works
fine on an Ice Lake CPU

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

