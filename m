Return-Path: <kvm+bounces-45125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF63BAA60BE
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:29:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2F1316786F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB9C7202C3B;
	Thu,  1 May 2025 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJgdkenr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F0E18D63E
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746113334; cv=none; b=Z4s6Nax/TpTf/WFym5UbZvKAZ9Vplpb2jITojcUJz1zujf2d8CQUVJ5hrI8osL06eq8h/gvQlK4HOGNq2WRtojuMORPf9uUB8TIl6VZN1u488gdvpCn0iy1hA7nCDwpbiDG2FH1h4o46I6CtfHJ79KVcvjvGqoCWwCDQEIo/hoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746113334; c=relaxed/simple;
	bh=iJYlLiTOb6MjI8bruDqCfTIgpCXPkZp8rV+QikMMDy4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ft9/C5oOsrSXqmmAv2uhqX2iMLaCb4RCsbO22VksJvcX9u/hKUoU/FHn4CayshaKBH4L4hX7vyexWv2fUtBaLDdT0DnhixXOYcoC0NLEQ2l96Yqr/q1m7kLUQzfoEpuad92PjwBtldikCSFh48+NFs2PWbkZslkWAXHyncNFUMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJgdkenr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 424BFC4CEF2
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746113334;
	bh=iJYlLiTOb6MjI8bruDqCfTIgpCXPkZp8rV+QikMMDy4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sJgdkenr40HPAnQAyHe4u5Nz3mDD0zhIAAgD6EEM2EZDZ2YDSbCRz/Ja3WOeUJFTP
	 VA7X8Up90M6O2PeZ7tAMwF9O65lZZCM8aUDjtSQnm8oFbomQrGRyKdmztk6QaFXgqQ
	 kKPBOKW1O3HkVv3sSxDV4a2WYtWAEw/gbmZohNSoy+dx5nYrjITCAZEqIEqPHw03qU
	 fhapDbV7j6qEPZ/1ZZxAYKOxsbZ8jSjyChrv1GLL5bCa+1544Aq/T6ghMQD0cuHwX0
	 6yjzkRoGQhUwoSagtmeMFgZe3419kTojb/sscm1eJO2gNridV8SQUvRoqXJapbBR1r
	 g2iMH3RmicEIA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3A872C41614; Thu,  1 May 2025 15:28:54 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Thu, 01 May 2025 15:28:53 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-axTw5nbgUT@https.bugzilla.kernel.org/>
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

--- Comment #43 from Adolfo (adolfotregosa@gmail.com) ---
Do you want(In reply to Alex Williamson from comment #42)
> If it's not a physical memory limit (I'm not able to reproduce even
> allocating 60 1GB hugepages on a 64GB host), it may be that proxmox is
> imposing cgroup memory limits on the VM.  It still doesn't make sense to =
me
> how huge_fault support could result in more memory used by the page tables
> though.  The previous behavior is effectively the worst case scenario whe=
re
> the full device memory is mapped as ptes.


Would you like to connect remotely to the machine? If so, I can email at
alex.williamson@redhat.com with the AnyDesk ID for a laptop that you can us=
e to
SSH into the machine and do your magic.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

