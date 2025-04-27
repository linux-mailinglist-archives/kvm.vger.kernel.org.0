Return-Path: <kvm+bounces-44468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 758B1A9DE15
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 02:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D55454653F6
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 00:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD4622425B;
	Sun, 27 Apr 2025 00:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1JL7X4r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3133A47
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 00:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745714917; cv=none; b=cF9MJ+ul3e4OQlBgITZTjjAxQ/M7vxaDob4lf+hgoPRmlcqEUo7MvbuMAEtUnm5bJZfa8NAj9+sTrLKzV3y3LPOn/mp+w6ceOA10+3btZd2/LcMkEd06zH97j+HtamvaPIBgLL2435mjVVHM8QIiCJE0H617Gv6yis2rLOpsAyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745714917; c=relaxed/simple;
	bh=1SFWXkzpihAhs71iiK47eseE8vkxRf/FapzXk75vfw8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rwJ9gXlg990WOxssvF4/Axl38/VSLabDeZL9IbC93jF0ybGe9Y8C0K1U9Djt9BCY4mgExWgTcpxohybhpfN+fy6/91hK0jV5ze2Bg/ht+j6BHkNLL1DfC6wo8cEfA/c6Ul0fIdN5rA2+waNwOm5P3is+tSey6+GkaivUdfpXk+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r1JL7X4r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 688A2C4CEEC
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 00:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745714916;
	bh=1SFWXkzpihAhs71iiK47eseE8vkxRf/FapzXk75vfw8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=r1JL7X4rzp7IgTNkRpbTh6G896aCLSY95ty3+3RlKcKg9keP15g5qPL1WIsB8nN3+
	 RWKc0UX8EOvW3wWGDzGfnVxcu15wzeRBtODik8l0BiWSBPE1bWe/YbYpaFMWZZCxpw
	 toxe/Db0TYTextxBMkAdLpTinDkCV8+tTgrwCHTdlBlDt6HMTdmedw1M34RDAbiFV6
	 bicscecVxj9YPSQ8Zl++0nk99gkEOOLW80L4JW1L9XSDk3U2JThlI0qDuQgPVeoqWj
	 EmbbZOiHkt2u8QXRxcIsvfNNLeQbnyaa2ZCQiPnXE3dI1wCskzW6NF6NEJt+5kmtm2
	 V5zlhlojxHmAg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5A063C41612; Sun, 27 Apr 2025 00:48:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Sun, 27 Apr 2025 00:48:35 +0000
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
Message-ID: <bug-220057-28872-ZEw4Bw52cY@https.bugzilla.kernel.org/>
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

--- Comment #1 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308029
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308029&action=3Dedit
revert patch

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

