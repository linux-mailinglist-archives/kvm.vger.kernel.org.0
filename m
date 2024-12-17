Return-Path: <kvm+bounces-33902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C0469F41AD
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 05:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 350C17A5756
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 04:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEEF1531D5;
	Tue, 17 Dec 2024 04:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUjqBDDM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD92014F135
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 04:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734409202; cv=none; b=UTgc9rasllG8zol31Wr4mTZu3cMU/ztIyZpoX7hIunoCKYcx4MiTKx+q2FLUYOIBKEXrrCmwOci1QmyiVAXnRQmO0TSdGOOIP1XhGJrRNHj/7GnO68k4eVXvlgi0hDchOvMCj0RpMkqJabtA6+xAaOCHiJ5PWGBMh7RspVDl3Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734409202; c=relaxed/simple;
	bh=BZ+0aMRtkTHw4hiZS4dpDrHsWMmkMYrYGVKjJ7dr9ow=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EXplY8aiBXV61J6aGDwODC54CcXcMY0JuRdShY6Q3SoFfmR+lURV3DnWHQEvr8WOVHTjjkONfPcykBfVqsIBWIOOeW103A5134Xn+XLbH3aCKvSi1ghmMvCRAy2nPVcXrKMtFg+56w63Xb8Sl+/P35e0pGaZrwQP1CZNxzD1MAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUjqBDDM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D9EDC4CED7
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 04:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734409202;
	bh=BZ+0aMRtkTHw4hiZS4dpDrHsWMmkMYrYGVKjJ7dr9ow=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YUjqBDDMfvEgkzktuiWS0pK0zLo0F9g31QXub+SQj9yLJsf7oMsZzYKZb0pdsWwvp
	 FUDtNO78sKsfhbDeEE5J2+M4AbiVeKHRhiZZ6aKWTn2GYPE6ULp1okNZEBmrXT8ig3
	 dmDH5NZ95OhpytGk88O7cGskD9kLxpp/84TIWyy5IZcxSpn2AbMw7gbQXASGUz26Hq
	 CpCE3Ek8Xjzw7hWR0tVJ+cP6s3u8pZgqd0vS7GH7TboABeWK32wLPL7bfjCdTfyA2x
	 IacQCYVX/8qYFD9yYzBTigaXcI6UJb/M+WnulQwuZGl5/jpzidFW8XYLV8n85/pwJJ
	 lSmQsdk2rGHVQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 75195C41615; Tue, 17 Dec 2024 04:20:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219602] By default kvm.enable_virt_at_load breaks other
 virtualization solutions
Date: Tue, 17 Dec 2024 04:20:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hch@infradead.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219602-28872-hRFFciAPBp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219602-28872@https.bugzilla.kernel.org/>
References: <bug-219602-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219602

--- Comment #1 from hch@infradead.org ---
On Mon, Dec 16, 2024 at 09:15:22AM +0000, bugzilla-daemon@kernel.org wrote:
> Previously (kernel 6.11 and lower) VMs of other virtualization solutions =
such
> as VirtualBox could be started with the KVM module enabled.

There is no other in-tree user of the hardware virtualization
capabilities, so this can't break anything by definition.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

