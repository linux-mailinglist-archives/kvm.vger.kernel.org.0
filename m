Return-Path: <kvm+bounces-44525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC26CA9E907
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6BB918987B2
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 07:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA29428399;
	Mon, 28 Apr 2025 07:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrlU1Cp0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93461C1F2F
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 07:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745824734; cv=none; b=eIznd8R8bz09Tf8lWmzgufhDvTb4+uk7kq212Dec7tPxo+rXk25CPlg+Af58tW4kdzdgj0CV17ECEN6/s7j/lw6ZQUTlXInopMy83AUARY54sVMLzWN2Uc7TWFEVws1uri2JQP8Bpg0Yoe1RQUwW02HaGdgMBDfAGDetDzqG53w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745824734; c=relaxed/simple;
	bh=opNqKYVBnijVWLqO9qR3WdgPB8+RebZkzP9BOxxYtjA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cqtajda0Pv82VBRYI68sD0aS858zb3INHdm5wuEi4IOUAPw3ooOh7/A0rUaHZflDmL1+4FEERODVDo7gczoSz/5XcRXjSREBGPehNEHHhKkFhX3GW7knT7YTH/uksJmyth0kKb0qVdpN7gbDFCG05dzzrUwIiDCY0iV6PpBwaj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nrlU1Cp0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C8B0C4CEEF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 07:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745824733;
	bh=opNqKYVBnijVWLqO9qR3WdgPB8+RebZkzP9BOxxYtjA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nrlU1Cp0Aiu5nJWr6oGjM86dT6VUlrXFsCUHIlHFpIOebx9s52tTqCBLEOyEu8NiG
	 ItQlsMUxGAOky1++gT9/gKouxTHq7wfr20Yyhv3pmoMQpNzvLw4udfc7LdbI5REFUl
	 qHwd5yTakTrYyN3MhXcUljsK6ysiGtSjizPalWKwXokNqz16DqLWlK4lGLs/aji56K
	 P7CoNT5gX7N20f4YddaN6eg9pYIVSxpR77luDy2aIGYNRBQ831LJhmHvSK6DkE42UD
	 saLpQULvcHKxJvNVEeipwA98j/VcP0eRasJOJSATEg4otimw4Dml1f5VdgrhyPTYR0
	 CNiUHMRnXaYbw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5FD99C4160E; Mon, 28 Apr 2025 07:18:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 07:18:53 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-9qbPb9eXiw@https.bugzilla.kernel.org/>
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

--- Comment #4 from Adolfo (adolfotregosa@gmail.com) ---
(In reply to Alex Williamson from comment #3)
> https://github.com/torvalds/linux/commit/
> 09dfc8a5f2ce897005a94bf66cca4f91e4e03700

I should have specified that I'm running kernel 6.14.4.=20

If that helps.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

