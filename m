Return-Path: <kvm+bounces-44615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F39A9FD0B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 00:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE0715A5DBA
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 22:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A52F20E704;
	Mon, 28 Apr 2025 22:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LSiprqDY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D41139CE3
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745879487; cv=none; b=YFj0nvZhtogdlGMBLnsAPrcjbcQF0nFPxwjOshofCxT+WtL6lRkL7IOQ+iRTddpkUTfUHCj+5Im35DZNwHfIRETLguSnrxhUGoHyVenDxl7CNdBuGCOO5nHTJRgMzabPrD3mCwKrbPENznZKcUkGoKTZJcYbyx6JSRolYWZFmGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745879487; c=relaxed/simple;
	bh=j6ZBehtM7oDxSHW/r05lIxNL4kOdi+rnQ1wxLD72FWc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V20UPjIBq+K/+Zvo9XrDVEbG662LuHmRKd7pj5KwHkAwlQKhuc3IMz1TVXtPQLzNHeo35BYG4AFIN7JrcsAdo8lY8UlMkF34p0kSOwVvzztW/GrTmSw2z0NDSpV9dYrXdp5GZI/gyzmOsp4Z/PR3j/uBtGyt+sfPpVpIaz2r2Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LSiprqDY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A21EC4CEEF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745879487;
	bh=j6ZBehtM7oDxSHW/r05lIxNL4kOdi+rnQ1wxLD72FWc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LSiprqDYniFb36fwmCtuJavans4/Ka5go0qLSzqAik0TMi4vI+5kJ1ZeP9FbYEd7r
	 +Bk1z4Q6yqgqQUs/tTG40EXRfQZrTBnGhC8hYZQxo+TkKL9tUZdDgj5DLPuQy0Emmj
	 CII5I7hgoOFE2iH3srcydFVpoZtvtP8OmGnuk5CAlV5HPu9YncDX7SKvOiJBWwNZa+
	 ZRV+ym72sRAkekbp6HdG6eeXQenpRlTBgUFZ5SxrOPq6PLPzD5qn1sUQoMUc5/u5FU
	 UM77fgEj0Sj0RgpEEcHghkgVux9r8tdvloe8hrs/OgjZ7zZhLBfYbdJ5ZL2sRvPy1G
	 4y9ykJVJGK/4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E7EADC4160E; Mon, 28 Apr 2025 22:31:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 22:31:26 +0000
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
Message-ID: <bug-220057-28872-54r6UnXgP8@https.bugzilla.kernel.org/>
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

--- Comment #18 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308047
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308047&action=3Dedit
lspcu output

lspcu output has requested.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

