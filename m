Return-Path: <kvm+bounces-6382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CDB4830178
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 09:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB01F287D97
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 08:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B233312B99;
	Wed, 17 Jan 2024 08:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tcEa+KR/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1CA12B6F
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 08:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705481177; cv=none; b=kBRFwQNFAv/3n7rN0dsIsyaA+QC5XYTR5yXmc0aM76RbtmBuW5/7kpYrsl7VmRvjAZAe/+0ZyTo26xPVLHi60lenc0tri6KPptGHzCM9UcYCyrhYf6+vpVuwEJARvFjafUc3eeatRmt0LU8+P9kKKTNR77sT252D6dGbPAXg5d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705481177; c=relaxed/simple;
	bh=MkBgEMAMHfAqC3Z0N5flWiKbqS4K2pwm5sNJNtYXq7M=;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:
	 MIME-Version; b=MUjmSj5lvf6bPWyq6H25dTveVykPTjdi5gM2jIIiP3D7f2KWM3Z6kM9FycJ9HCM66OYhUELQlxsm6FAWR3JoU69Hm5j9VJi+K9irsV2YXuGWFFUpAudkeIXw4BLfZf2D+8rFzOXqVcMMQn/4NGB50dxa4KeXbz8h2ua6c9Psqq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tcEa+KR/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DA79C43394
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 08:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705481177;
	bh=MkBgEMAMHfAqC3Z0N5flWiKbqS4K2pwm5sNJNtYXq7M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=tcEa+KR/6AcwyHiLarDl5AgV5gDOVpJWSJj2Z0Lv+TNX5HskOSNhNRXis13ViviNa
	 wP2LyKC0kS8+KX9/zeyzAVnMSksbyVPrgwng/0Xky2BWeiFU4G1B3ZkSSEnu5/6GsY
	 fmLOGBMSAcdnTVECwQUG0rfi+OqEC8Da7oO6rd6xlEgtAJbWHryG1OGklWlC1+vOiR
	 lRk2MpvZ2SsgrBxoNn13AFlj/aIu/4ULrDxu/zJ26wKq0c6oHDow5R4+PY/pJxoJtO
	 MDQPo6ulHcomL+wC14I0Mr1nRvlxES7Jb3Mbupn5ef2WeFJLhgCnk+eBZ7r4BgTnND
	 xxWv3md6o4SrQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5F0E6C53BC6; Wed, 17 Jan 2024 08:46:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218386] "kvm: enabling virtualization on CPUx failed" on
 "Ubuntu 22.04.03 with kernel 6.5.0-14-generic"
Date: Wed, 17 Jan 2024 08:46:17 +0000
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
Message-ID: <bug-218386-28872-LyrVQvbkdl@https.bugzilla.kernel.org/>
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
            Summary|kvm: enabling               |"kvm: enabling
                   |virtualization on CPUx      |virtualization on CPUx
                   |failed on "Ubuntu 22.04.03  |failed" on "Ubuntu 22.04.03
                   |with kernel                 |with kernel
                   |6.5.0-14-generic"           |6.5.0-14-generic"

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

