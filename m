Return-Path: <kvm+bounces-49901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0547FADF7AE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 22:29:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9485C17783C
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 20:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B1F21B9C3;
	Wed, 18 Jun 2025 20:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SvFWM6qM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72241D63C2
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 20:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750278588; cv=none; b=d1bTEH5m3ZfWSh/ahppidtTVUwE3+vtFOt6uI30waA/C9aXv1EvRyWJDxTa/81Pq1gTFVL9TvRf66vGt6nSsYrtR/+pTi2HZuqHVM9q8bHn/f+tnC69J4IKPfERe/bSBA2vTnLhD7PIrQzGgRn29ro2VpnXXHadsFA7tTFGqH5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750278588; c=relaxed/simple;
	bh=SFtAi5LhVncNgfAcXH+1Kdv2b6hpc5lIayz25geBT0w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ulAQXrFrw7D10Myj2lSaHEYxMJIzEgI4zOB0KDsIyvWGXKWijMxRuCIphw1X8+0zAcNKMh7cefniwvkgjccit3Hi3YpTqzPD8zjVVtkY0YtGbIwL6jMCAUZ15TxC4FSAMztbNM9P7wDUuydnfZ3J0av54Kn0n/zFczYjo4rfyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SvFWM6qM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51557C4CEEF
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 20:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750278588;
	bh=SFtAi5LhVncNgfAcXH+1Kdv2b6hpc5lIayz25geBT0w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SvFWM6qMl6eJgwZ5A/MJ43UkvVRE6NLSgvRMk886DfUoO2/U8eBsKksdvbzNpYxKH
	 GCD58RSCQ/apZyYtOHmV5Y6mG2YeltMLDLZ45fWWalVNUY1V+z5RIprUTKyGZhcWEJ
	 6WEqo/XaMvaidvHu46TG+O9Z0A2A9CNwK5VNS2iF2hleWLfElfkMHNuDK3yArEtqq+
	 tI1/MY9UlEJKepV3vovt9ETtCqMdprYGoc6IwvakGgLgrnp8v8fL0h3lVZgfOb6ti8
	 OrzZg71j1R8xMsW2MvaDK1Zh8KLQevDW4actrmt2I8+Wotz/vD/Ao4HPnpW25IvRBY
	 mhn1WUuGAUWSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 41BA0C53BBF; Wed, 18 Jun 2025 20:29:48 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220200] Kernel crash with WARNING: CPU: 17 PID: 4510 at
 lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
Date: Wed, 18 Jun 2025 20:29:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: gs.thiruus@gmail.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220200-28872-ZsT0WTiJtw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220200-28872@https.bugzilla.kernel.org/>
References: <bug-220200-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220200

--- Comment #4 from gs.thiruus@gmail.com ---
Appreciate if someone can respond to my queries?

Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

