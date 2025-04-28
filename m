Return-Path: <kvm+bounces-44611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E0CA9FC89
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 23:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6D7817568F
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB9DF1EF39B;
	Mon, 28 Apr 2025 21:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wpew325E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D455735973
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745876951; cv=none; b=PEIWBJHaV5tJpxhD+Qql6Qd86bbiLdElZgx3g5vHK3Wuk1MhF5XMGnX4dpghLjf/yBwWoL7wDcW1CyROFJEIFdaOMERUGPWKliGlmdD+9Vp9wevIJ3GfgZYQTzMo/V4jALzBYLe7smiclbXpUhzlllNM5MdInpSFi486Zteg+Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745876951; c=relaxed/simple;
	bh=EsvQDxqm4duRsISk9T1Zc+KRcskLD9WrrR7EMMPq6YE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UMULS99aS5jyTHKlYLzCkW1LI3Jt0DHrjbvt72LdhpXXcRzK2qfxwrPdI6uBsNPUj7+dOfQ1dYt0FtzyHbwrS6f1yxagsukT96+niu5lLSJJ3tx+BCsl1mEvAHq8or3roQUY6WulcHs74a/Gj1XULND0PlsrRpTU5xZRkAgg+PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wpew325E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 513E6C4CEEF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745876950;
	bh=EsvQDxqm4duRsISk9T1Zc+KRcskLD9WrrR7EMMPq6YE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Wpew325EezHTJ0z0guqHC2E5oabZu3PjrHroLPouXXHH9bOrQPstEXJOGDJ+D3Kcr
	 7e+C7lzLiN3UD5EMfAtfCLGD11ILH124QUWSF8YH46t5IicTb1M3JqHvowPeGoeLKK
	 mRa+vFZzNbudh3gy7qjHS1fAYZ0zosULBLzc9wW1MvboNvuGieVIRrR7jGl+l6Rmob
	 MjuZOXzD4utpD9TQIVKUjku3P3KbItAGlqNk8hkIIP3dsa4/LeEXqYjS5Q7opNgBq6
	 NHdE+wSheD7sF5abQcN9YU6M6OrtNdBBvkr1rxke4XXVPWKt0MOZXsVP7tHdHnSt3Z
	 Yve7sFNwY+1yg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 443C1C53BC5; Mon, 28 Apr 2025 21:49:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 21:49:09 +0000
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
Message-ID: <bug-220057-28872-YDSGrLyR6E@https.bugzilla.kernel.org/>
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

--- Comment #14 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308045
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308045&action=3Dedit
vfio_map_dma failed

I forgot. I have no idea if this is even remotely linked but I'll leave it =
here
just in case.

host journalctl: vfio_map_dma failed.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

