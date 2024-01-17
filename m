Return-Path: <kvm+bounces-6407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4409830D44
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 20:27:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D28528BD70
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 19:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834F9249EE;
	Wed, 17 Jan 2024 19:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k85TZGL0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4D9249E5
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 19:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705519653; cv=none; b=T6b0pRqDcvbpDcdpsg/qj3kJ5/14/236Ys//jiw/MYyKLXOWwM6unyrdA4TqlqOcEYZu0eeVY1XU9Glx2gcGJgcbEKV6SLp9q1LbAs6xN6HXiU7SemdTSN6wn6+FkBrLUh15Qq42u2/LuUI248Rrn0QVCvWrZ7Z92rJjln9OthM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705519653; c=relaxed/simple;
	bh=/PinyvQJyXWES5y2bO2RgedemUFAR34hz+Br4YYlcRA=;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:
	 MIME-Version; b=aexIOM/ayk/Z7abGt1HKjOzZ9OqlqE7t3jKulOVT2uBsldsZ0R1zPf2ihce/33HpD4HO08h7FHHx2aEhKz1UmmGMiYiZawkXZrTlgBN4qIYEOrJ2E9PyKIceNHCQi0KW/HY1yAVriwu/RNxgpLSsyIHLG4akrbI4UBQIYJF9hyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k85TZGL0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17FD2C43394
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 19:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705519653;
	bh=/PinyvQJyXWES5y2bO2RgedemUFAR34hz+Br4YYlcRA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=k85TZGL0ryKHWeHesOTTcQtxqcJJMbpGfoMJoAi747cq4c7vpFRKtAw5lA0Vh2dzV
	 ssLkEM8GPAlLHRsYVLQgj8Q+SAAGYsh+58TAjijNvAIYjQSzmOg6G0hsIxIDlUebGI
	 FN8WjLKIilKzwvqlrhTURnxcSZdhlYqxOys98r3WoRNIK7YFn/883n0DbseAf7mGU4
	 xfzg+V662Y/2ZouFYQtjH03IUWAsFNlsEeOy8vVRKPOBm6vF7btT504+szC3rEstn6
	 jXaVTOR7o0+gebrqZDuKZ9oem3erTIT99E7sgNuTF9uZD8BrXmHd5kOxa9GChaBrRf
	 GkfC+pA6utyvw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E4884C53BD1; Wed, 17 Jan 2024 19:27:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218386] "kvm: enabling virtualization on CPUx failed" on
 "Ubuntu 22.04.03 with kernel 6.5.0-14-generic"
Date: Wed, 17 Jan 2024 19:27:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218386-28872-B0ffwZPrHy@https.bugzilla.kernel.org/>
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

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
Please refile here:

https://bugs.launchpad.net/ubuntu

This is a bug tracker for the vanilla kernel which is at version 6.7/6.6.12
now.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

