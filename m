Return-Path: <kvm+bounces-6421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE6A831720
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 11:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8011DB241C6
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 10:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79CAA22F06;
	Thu, 18 Jan 2024 10:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0nfFjKW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FD023760
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 10:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575213; cv=none; b=AUXzyALWylZvP0fBRIUHLl57Mw43XwC4SnEsUUOuMxoioojsYe/lbLZBGnI8kszNQE+2HlrHNJwF6MiVpopYTVSgsmSe9UOqvgkH/TOOrKdIoLjitagy1XExoi4K/bXxstdka3AIol4pX27qUBlOmMcPiyG4bB339SJNDp9ox3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575213; c=relaxed/simple;
	bh=cD192eJjeWuRX3LNA4pzkUfX1zV9gYHmfmv/RXrDdpU=;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:
	 MIME-Version; b=I0MxMtsXx0713w6FWdldUZD86B0b00G3wM2riMaqqcgd7v3utDvRD7TlmEWW4zKkD1cfplzy/fx3bB5LFQD8cwx2o0D9nuUeslLqU0NxOPxYsMZ7abdxb2G25dy9/74wp5WiBzRPd/XJWBAUomkdV4YRwt5HFSWq2YRVgtvcv3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0nfFjKW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F154C43390
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 10:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705575213;
	bh=cD192eJjeWuRX3LNA4pzkUfX1zV9gYHmfmv/RXrDdpU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=c0nfFjKW6wpJMUY3Z3VZJzid6t47XkwdJEl/U80zZvXM7Uoxcdp5RRCevbPWzdQVj
	 abXZEZgBNUhszUwt2+ZlSh3Dv7j3iZDLH+82A1xNTzix10c1vnZlZOFDeq0W4AgwY/
	 L3OhejTEP9uQhpBBYFlxgp2pR9uwsz10CgE86Kq9Wc3hOSO2hgoJJ31CtqMT9KRx2V
	 oxvAeDlGZnP6TSxxwHLcJN9A9tL3h5jKUG/dOMIzjv0HffocNfbjggSS0felAjC7Bt
	 ghJWKar78fdEqwPluoJTNLUKfXPb+jUmQ9/mUeoHok0KLPHX6cQ9urs2yPaLQjAvDs
	 MqqtZ1UYNILMA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 48A81C53BCD; Thu, 18 Jan 2024 10:53:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218386] "kvm: enabling virtualization on CPUx failed" on
 "Ubuntu 22.04.03 with kernel 6.5.0-14-generic"
Date: Thu, 18 Jan 2024 10:53:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: antonio.petricca@gmail.com
X-Bugzilla-Status: CLOSED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status
Message-ID: <bug-218386-28872-Df7OjCQdA3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218386-28872@https.bugzilla.kernel.org/>
References: <bug-218386-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218386

Antonio Petricca (antonio.petricca@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED

--- Comment #2 from Antonio Petricca (antonio.petricca@gmail.com) ---
Sure, thank you so much!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

