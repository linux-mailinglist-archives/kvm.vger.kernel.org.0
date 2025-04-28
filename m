Return-Path: <kvm+bounces-44614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B2FA9FD0A
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 00:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAE7A1A87B41
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 22:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3C821147C;
	Mon, 28 Apr 2025 22:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SmmQV+7j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BB815ECD7
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745879375; cv=none; b=fvFSqQ8vO9ppgbOeXdgmWB2a2BiEzTkXEPYcBkJdvwAiccC11m4dVjCm6YkaHlript89XmfdAVGWiblylQVJnlQ3lNhh0PJv9dVC1ZuCuKrAte16qPLijKcLBW7/3vL6q/agL9M0BahOYGk5SDPhQhJw5lehUDjJ63qLAf+nKYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745879375; c=relaxed/simple;
	bh=Y7Tr/APYYGaMI834mQtrhUPjbD6Go3EnTnCeehtR+K8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dgXZqYdE/ICii4We0wQZUnPtSOyYE9INi45aIk2S5NVF+zUOxEUwqahF1WsQKWJLNadEy9NZ/ZeZ1AFxDCZmLnyqnGwwi/fBB3PEfodZvF3sSpyEp8WmrPPi8PvoXQP8XX8cQ/8Oz4DJ0bJR76KYPWJeI641I1hDr2qi91a1BmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SmmQV+7j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A724C4CEEF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745879375;
	bh=Y7Tr/APYYGaMI834mQtrhUPjbD6Go3EnTnCeehtR+K8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SmmQV+7jQ8tRusgnwptXGz1v4nZQjh6GSks7PHI2P2eqZrugcejl5vcz/30GwmBg0
	 QikpnvvkZW9zvh8E5tEObrVxVwEQjoTeN8pIunVfcme3tbS0lg3ikozJ74MZk4xmf2
	 ja5/LxE/DrbcC4RVK999C1uzC+amxI+OmZ/Y9/VrIDSg/+vmWwzzOroOvEkJ0xH8XA
	 yw9p7jrsVNwgTTzgcQdYZ4uzb8WAi419YsBFOc7rGp3IAAAlUhs3BWIwZ9t/Q48Y5z
	 a2yWR+90f/Hg1tTTH/Wf98wwoGdjvWJeY9gEXhjQ4/FLDtvNeYAcF2ER0B+GdZP1FH
	 jeu9TxfOxpK+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 729AAC41612; Mon, 28 Apr 2025 22:29:35 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 22:29:35 +0000
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
Message-ID: <bug-220057-28872-E97SQ9YTEh@https.bugzilla.kernel.org/>
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

--- Comment #17 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308046
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308046&action=3Dedit
phys-bits=3D39

log with phys-bits=3D39 on cpu line

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

