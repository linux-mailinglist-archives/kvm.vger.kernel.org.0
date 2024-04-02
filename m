Return-Path: <kvm+bounces-13381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 826A589588E
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 17:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3E911C24325
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 15:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E854C1350CA;
	Tue,  2 Apr 2024 15:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9F04aZT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24EB132C39
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712072668; cv=none; b=STACOjwOob8iIqhO8SSaOBGRggGSE+HvX+FyuNrHByD9C5JowqensqLL9EPSqOyqnMTFBfUqJ7gtRHwymqX7W9mwNRJagW5IukChLueK0KUD5Ahn8X2WuOkcBhFdAfufpw/lz/AI7Ilqz335T5X1a0+K/Hf74KfSq5cxqNwAM6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712072668; c=relaxed/simple;
	bh=FZ1kRiCIpDWNICn01dAhDn4j0RRbl9765EuryHQVYMg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O4FZKG6aP6PlvnYuQyxVoxOFpBshlOnEwDsRRygWT5Tf/h9e8msnUUxnjDL66sJ37zEFCDfC1r+kvOuBv5BWH9nj61al9vv7H2Y/TywioJAdcPGX5kEKz9xdTw261suCELx59fXs7NF9VAEhI3oqJFrim9DnjCdpycYlWJ7U3BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9F04aZT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 850B7C433C7
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 15:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712072667;
	bh=FZ1kRiCIpDWNICn01dAhDn4j0RRbl9765EuryHQVYMg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=q9F04aZT6j1pPqPU0HzjSTYWgwd0DDpUpvI/cYBmW9lo1TMQL26dTDGK2Gs453AKy
	 Fp/LvUhC6eePmZOjqG1nZ74PqJBMw4qOz044/vcxaeVMOLivy6BoEetWW6I/o+tSbG
	 9Ri/4YWehYB0TihzGqdX15vy5Vjqo/HxDlh+jeae3buIzVi4RIgHv3RSc4B22Zh1hx
	 8lamlMQqDfSHNK3oy6qThnWFvLp6hxjvMy4+oFQaRPL/A1DsVyr5szD2qfVXiVVFuJ
	 KVTZASlRJVG2xiy+CgW9NcXaNUzCL/SfGWjmgQ3nMKgXuYLCkg3obHaWT1vWOzeasb
	 aBOPIHulgGzpQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7857BC53BD6; Tue,  2 Apr 2024 15:44:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218621] WARNING: CPU: 5 PID: 11173 at arch/x86/kvm/x86.c:12251
 kvm_vcpu_reset+0x3b0/0x610 [kvm]
Date: Tue, 02 Apr 2024 15:44:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218621-28872-YftfHWEce4@https.bugzilla.kernel.org/>
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

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
Please provide info on how to reproduce the WARN.  I suspect this is from
syzkaller triggering shutdown in SMM, but it would be nice to confirm that.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

