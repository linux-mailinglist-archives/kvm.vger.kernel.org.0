Return-Path: <kvm+bounces-7662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50CE8845057
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 05:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E28F71F23C65
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 04:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9746838FBA;
	Thu,  1 Feb 2024 04:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qs9X40OQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B006F2B9A9
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 04:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706762191; cv=none; b=ZG64G0GomUHNPB4a3Sjk+NhcNZIiiuuwez6o0+1a02IFk04pTrAGgTnIgP3Caj9RGrRMNPCLGlQ5fOZlRH8RY42Qsr216bkJwOiR3YLGCtIAYjovwQnIfXcVOytlSg03Ldi8xq21fOc8W/Iv8huNTh9FMqwC0Fy0sYhwIO8RQIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706762191; c=relaxed/simple;
	bh=Krc/t3Ma/mvcqxhlGF/uEep3+48+h3aWth9DOECLnJ4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GsoOtxie7iyB/wRl6IXDHwXyJzPzDbK4yEpvPi7ra1SFhltoINXKkYslsvGdvt2jA9HJaHssyX1301N3MYpjEGmGcd9VqErCSh8ZKlwBloveNKoYUxH3syZ+tPrmpdBTS+39e2qYwD6GrHnyfBaE8eYGPgS3cWiO1+NJFxd2Wdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qs9X40OQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC69DC433B1
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 04:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706762191;
	bh=Krc/t3Ma/mvcqxhlGF/uEep3+48+h3aWth9DOECLnJ4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Qs9X40OQaNJcQWKvQurjp3sPpN1yiedl2yRQTxRCe9iobQYHBLe2VdHWqxjyVTgxL
	 FcNYWzuYSJhUexliywozRMlmFsrSocMIpXD2SnzZIBQh4c2VHS6iD65EH0M59Nxr7s
	 hKhy/1Huk9ZalVqR+yDrZAYLw3XEvSduZWIf9N1SKcc2t2FQlsYo9OIgA2CwxhEx0c
	 wS5idqrsuFSEbTMg7Gk10HWlgxCdJCKjNO34Z1BfzihHnZ1WSPEfHA/Fvf/FCzXOiu
	 dJbDnqZV1oHLl2+ikYoJ06eD+GHN/82sYWS2nNTvFLQs1enPk3nx2NBPzxdP5O1ggi
	 wcRJNOKN5iNJQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DA762C4332E; Thu,  1 Feb 2024 04:36:30 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218297] Kernel Panic and crash
Date: Thu, 01 Feb 2024 04:36:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: awaneeshkmr@gmail.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-218297-28872-EvyXMMCVpg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218297-28872@https.bugzilla.kernel.org/>
References: <bug-218297-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218297

Awaneesh (awaneeshkmr@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|ANSWERED                    |---

--- Comment #5 from Awaneesh (awaneeshkmr@gmail.com) ---
We have migrated to kernel - 5.4.254. Can someone point to the patch, we can
apply for the above issue?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

