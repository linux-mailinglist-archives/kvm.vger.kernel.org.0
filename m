Return-Path: <kvm+bounces-67656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F3ED0DB4D
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 20:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A3118303894B
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 19:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC250279DAE;
	Sat, 10 Jan 2026 19:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Njr8G34Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A4442050
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 19:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768072959; cv=none; b=n595G9HtWV6PWbP932zdwLK6so0gnt7TBN3XFUiygdDa/VHZ35n7NOOqbmV1YgVFmqsBRe/8F3+iNCcrsNX1GnEpejwNNORD/6gGmxIRd7nTiG6LWMVi8eF7++7PzgMgsK2bZOt3zM9D14uz+ebelTyN6aaZh1P8NEK4VOC9Su8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768072959; c=relaxed/simple;
	bh=uSohGplnS8h15P4Z9erIaQtUpOz4cXnTJjQsRuKcePM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qj9au52JnCjPIrzISBOktLJU6Ots6O9EySYNU9NTOaFFTXVvxabsLh1I5gdl2Vjhb6SnUJ0drSC6M7idmr6iKUr2McXFQ+yxlDIrd0uDqFVWYTtjrwATvQ+vuMT3juTd5gUiDzCzx98UfzazBfzaWXppo4vq2/TC1XtYVqdeMxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Njr8G34Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88740C19424
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 19:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768072958;
	bh=uSohGplnS8h15P4Z9erIaQtUpOz4cXnTJjQsRuKcePM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Njr8G34Y7crIodX28+67ekG4zL4ZwsuU5UGj3HJBle4xqqbYDQa0wQM98npxxGcvN
	 hYEuWrDAwtOCD1VEe8M0P/HJGpjA10YkvPhihFDkeQqPxvFHr4ZF11u/ZYFRuZtmvl
	 /g+k+mcVykvoPNT6+vgbROaZgvR2VNMwwQqVjeiHOZXXj6mG+apXdtFmMUU76HhWpy
	 wYny5/i6anZHgQSZGSGhy1ce4zVmNf22iFzc+0IyTGgXRxhnKIsEnC7cVwEiHRmZxd
	 7OTG9YG25eNRVWdK5N2cGpPtam4S8JouICNHHZ6asG6gvtH5lBUj50qDIf6rxYU3M7
	 iYcZspP3bkPZQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 80121C53BC5; Sat, 10 Jan 2026 19:22:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 204177] ProcessorTrace: missing filtering on the MSRs
Date: Sat, 10 Jan 2026 19:22:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: max@m00nbsd.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-204177-28872-VR2pe1H9tg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204177-28872@https.bugzilla.kernel.org/>
References: <bug-204177-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D204177

Maxime Villard (max@m00nbsd.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|PT: Missing filtering on    |ProcessorTrace: missing
                   |the MSRs                    |filtering on the MSRs

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

