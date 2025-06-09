Return-Path: <kvm+bounces-48750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35255AD2596
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 20:27:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C9923B1531
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 18:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5A021CC47;
	Mon,  9 Jun 2025 18:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfDTl6Qr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD0927718
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 18:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749493650; cv=none; b=fdwKzfJkJoLnLyX06f8p3gnoVKCVSiN6H8h5qJA1PA2R1XAB/jPZun6J35jGqRiARcwN+WNoHod4brGbxU1Q2Z/lAkN2zHWz4bPPtBMHrHromb8iEq4Qtu4O4N0JuBD+g3X/BLSTuYkws7oTtvV2QtoRZPg1r2RPevrKZnDbVFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749493650; c=relaxed/simple;
	bh=xxyZAdOTMsvcG7qSAfDJeFKOJ423QBPTf4734rfg0Xo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gfRm+Ynj0nvy7ihGxR+pdV9L+C3eLrOd61SNjP1QXnGuuiLmOdkwV99HGpvubuqi9Rr/JpJg7U418KcN26gMN6uQkiuHGsUE6p4AQta019nd3b9hcNwZzZ9osUKJPcrAEG/0DblcOItwi+FYd8R8cvfa+rVvjgaFfkykpmlLFwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfDTl6Qr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72CEAC4CEF0
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749493649;
	bh=xxyZAdOTMsvcG7qSAfDJeFKOJ423QBPTf4734rfg0Xo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NfDTl6Qr4qULza0gbwdd6k8AJ0Gkn3LhsFh6U42LC1PeVhnnDA1ot6Q6Z3+jCFiE4
	 dERXv1YuYzdvGy1VsyMNNIpnXNfhI4tP3jKXB2kJ94qli2Qd6+xaxOjOBg75A9dY/L
	 p7BSy1lLCJJkPBN1koGA2HEWHvo4tSLf9vRMWSdOiRLIoYV7YIUxTBYZwLezXn/hVw
	 w8T/vtjZXqjAu/uCHppY+7uPJFLpSB2PLQHrvBAh3SlAysm0KG4vzzd6OtLlkllbh/
	 hv7jAi5UUJUjWwl+ZqVaY0ZzmKoUZU2B1hNKP7776eSGPoiDhPhRF3KCu86cOjr12j
	 wMxgxtWXUQAFQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 693DFC4160E; Mon,  9 Jun 2025 18:27:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220200] Kernel crash with WARNING: CPU: 17 PID: 4510 at
 lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
Date: Mon, 09 Jun 2025 18:27:29 +0000
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
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-220200-28872-gtRVfqlbey@https.bugzilla.kernel.org/>
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

gs.thiruus@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|ANSWERED                    |---

--- Comment #2 from gs.thiruus@gmail.com ---
Thanks for your response.=20

Though the warning and RIP info matching with the one shared in the thread
(https://github.com/flatcar/Flatcar/issues/427) which you shared,=20
WARNING: CPU: 10 PID: 13791 at lib/refcount.c:28
refcount_warn_saturate+0xa6/0xf0=20
RIP: 0010:refcount_warn_saturate+0xa6/0xf0

I see the call trace observed in our setup, not matching.

as per the link shared, fix provided in netfilter module.=20

Could you please share more details how will it help to fix the trace obser=
ved
in our setup?

Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

