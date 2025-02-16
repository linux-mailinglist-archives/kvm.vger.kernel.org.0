Return-Path: <kvm+bounces-38319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F625A373AE
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 10:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52893188D3AC
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 09:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EC618DB02;
	Sun, 16 Feb 2025 09:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dj3UP8Rf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B220189520
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 09:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739699688; cv=none; b=u/Rn6VXqtgidlLv0W59dLWNnYcixWkvx3o9nkkWxlm9+uF733UsjZ6UMjDjTLoLJ+kZiZ2mkfvZrVCbmmruNt4N7IOs2yo0vvkQBfFGBlkLF+8+gAmpcxDApoWHtCOuRpDZLgfuqi0ZCAPyOl4xBa5DDpki/1BhQ+pLqXzLpgxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739699688; c=relaxed/simple;
	bh=Yx8JuCqgU773JsPycMFEZ1Vj1tjxRCHI0Wbrh+hu20E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lsE8QUr8b+EG9CSMLW7DgHGi/y3QjeURwYb2lAnijqNfGWWz81INu2OLJgu/U0/B7hVSl6nYOaUYZ8X5Ni9jB96SRYprF40OB99A9Wm9785ErRVwx+L0l6BnG5yL6Uil+jCyGSq+lLf5j7/4VFhKBfw+EgSllim4dcKQ7LIoPUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dj3UP8Rf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90FC3C4CEE9
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 09:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739699687;
	bh=Yx8JuCqgU773JsPycMFEZ1Vj1tjxRCHI0Wbrh+hu20E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Dj3UP8RfIyE+GhE+UeS4gS8DVR1S+mmiAzll1ckacJvkU5drM1usU57BT49AYb+Ak
	 YrVzUQwMS3Eu6rdea8ymdQ3VTCH6YOznALmFOqcKea/EA0SPSuAzyZnhuafgqz5CCf
	 I5A+L+ZqA0FQI8ZQVDfnpqgrQuD8FYVm1NnJDas2i/zuLPULIscLZRXJbpP8xD+Sk4
	 yRl623ywRg9OTjhfGpZ0OkqbrfUu3qd6WwJl4BOf34p5trOWl1kNrDwPhjaoHl9xEi
	 euK6Ld3hYIyGShUE4LL6vgPQag7tMeNLayi8L9mTNTE62HRznq7rNn5IR74T/2KTst
	 TbKrzOIusjjFg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 89F94C41606; Sun, 16 Feb 2025 09:54:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Sun, 16 Feb 2025 09:54:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rangemachine@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-219787-28872-PLz4mbWNZf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

rangemachine@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |6.13

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

