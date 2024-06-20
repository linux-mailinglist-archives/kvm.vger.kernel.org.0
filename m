Return-Path: <kvm+bounces-20174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D05F291149D
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 23:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B6F9B22501
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 21:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955428288F;
	Thu, 20 Jun 2024 21:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="doc5DPE3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8038003A
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918929; cv=none; b=KRxLafDZd1dfJRAmLnw0gFfB7BweLFi4LL/YiwJ5gvjK7NOyN16FZoFoegUdHxc6mPCkmZfP7yGKU8RbNwXiql4aFlaoO3nuxboZZVLmmfUJ4TUTdfbYHBjRjhh9S1jmWxdTlQayQTcZ19CfOAj0mbu90YBasKWdvhryfimgjfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918929; c=relaxed/simple;
	bh=X2XL2Lpa6AMk0eExlvxAn7Y3vFAGsaJ/nQJGuXKMN5Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=efu9IFGpboVzau2XXSzM8ZhinoUh3DLQe2M5cCsQjDMNYdCwjkx3++AkgeRkNnTkQlLD+hrEvGGKqHVN8It0rev6It5xOJHfa3Nk8QNVWOxYwYL3mKq+y9zsisbnSz9B/UxgU8QRb9YmzbfH7t67shmgJYHcMULN0Z2GQVsHD9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=doc5DPE3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6480EC4AF0F
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 21:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718918929;
	bh=X2XL2Lpa6AMk0eExlvxAn7Y3vFAGsaJ/nQJGuXKMN5Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=doc5DPE3kikgOgdTYx6FpEymWqA53WCo6h8GgiZeQOpx/KBGsGpCRzofzlEQCFMmf
	 F5ml14p52KWPWukgVMnGG228WsNjJKsQv7LTJDxYeWTr9EEDEpXdNeljUx09EZFIIj
	 GkfsWIpF/KyWfOhQW5v+ib4vS0BSxH/zGtJK1DQB+auyjHuQdCfM1xR/TOONrcSRec
	 OSDRn+isUDpUXlSJRbEQX0odbAv5Xad7fA+ND4F98P0OEasOaWbqGDfmNBHcvN3a1G
	 sNiqF4LOscotZPZf76saWlUSBW3ZiLK0jiGf6QfRb0xTtwP2l5zfP6SMEXTRqVqbtB
	 THuEZahN6+T9Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5C105C53B73; Thu, 20 Jun 2024 21:28:49 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218739] pmu_counters_test kvm-selftest fails with (count !=
 NUM_INSNS_RETIRED)
Date: Thu, 20 Jun 2024 21:28:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218739-28872-udFlRMujgv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218739-28872@https.bugzilla.kernel.org/>
References: <bug-218739-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218739

--- Comment #5 from mlevitsk@redhat.com ---
I tested several approaches to eliminate the issue, but none of them seem t=
o be
very robust.

In particular:
 - I tried to clflush a global memory location outside of the loop, then ac=
cess
it.
   0 LLC misses still happen, once in a while.

 - I also tried to access a location on the stack.
   Here the test started failing on INTEL_ARCH_TOPDOWN_SLOTS_INDEX sometime=
s,
   I am not sure why. I did push/pop, maybe ucode is smart enough to elide
this?


I now found a new and a more or less robust solution, which is to clflush on
each loop iteration.

That both increases the chances of at least one clflush working and it shou=
ld
also confuse the speculation code enough.

It survived about 4 hours of testing.

I attached a draft patch with this solution, if you think that it is
reasonable, I'll send it to LKML.

Note that I dropped the mfence instruction thinking that it doesn't help mu=
ch
since it helps with memory loads/stores while we clflush the memory which is
fetched for code execution.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

