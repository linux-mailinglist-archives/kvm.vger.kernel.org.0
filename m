Return-Path: <kvm+bounces-44605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFC3CA9FC2A
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 23:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6CFC3A7F8C
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B441F872A;
	Mon, 28 Apr 2025 21:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URuuHhsv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C891FF1C9
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745875332; cv=none; b=nIWnhR3CxYJGkn5nTJjaaGLDWrY7SheXDH4J6oK1L+Zby+fV+pQPZXGgAtjoBC5DYLc0LOYTDhHiPXLhBfQoYhAK58Z5oqsAFl1oZacsWdazEYEykP+GkHlKdkbv8hKa2vyPT2IPf7h8FItLH8DvdiqTT1ke17HILgSNqJi3Xio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745875332; c=relaxed/simple;
	bh=WU5i75ImZiv+7AybYE1SCaQKV7zcONIP5XevvaR6dGg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GJGAxBqs76GF32FoFw4RBx/ez4wbbSoEiybees1Hmmw/TiFBz1s9DdMU9DXo7rQsiepGhSEz+HukuSupTvTOJXNhQHmqlDKSQV7WGy35cgg6uehSiV6+dp1cQpNJp+IUQWCYGkCCaSa8nGOKHjXBFdd6JxtSXsFls/vGi/edckU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URuuHhsv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2992CC4CEEE
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745875332;
	bh=WU5i75ImZiv+7AybYE1SCaQKV7zcONIP5XevvaR6dGg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=URuuHhsv5ejtckPE56cFdJnfwpRxTxWw+laJXDWsKDldMjBXlwEOjK5z90yNcpN15
	 A87UwNiujMZmYNPWAgemwGUq9MLoaKMEsEnV6FgUwAAcHJkJSKrOBPa8JceX+khRll
	 Dm1BvTlD/Mxc4E6PWaDI1i5U7U19URVBpUh9NCjJFs/fDenQ6XS/pmBnTUv8i9Jn36
	 1OU9zDIrTN4noVwSU53kf4zFGLWa8p/Mi+MMS7Er/q/2CXuQxrX4/OMB4Kkvj92pVI
	 mgV3a4jKgVByRDUVIMoPKDNx7nuIHCwdiLpOWCi18lRFexYeggVOrKruRlw6xCioOg
	 gYrXF1sTAWyCA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1F7A5C433E1; Mon, 28 Apr 2025 21:22:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 21:22:11 +0000
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
Message-ID: <bug-220057-28872-QUk1zeGQ77@https.bugzilla.kernel.org/>
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

--- Comment #9 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308041
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308041&action=3Dedit
Proxmox forum screenshots

You don't need a subscription. Just create an account. Either way you have =
the
screenshots attached.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

