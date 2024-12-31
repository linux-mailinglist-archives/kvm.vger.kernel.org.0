Return-Path: <kvm+bounces-34426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0AFE9FF0AA
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 17:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1892A3A25EB
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 16:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57A619E7D3;
	Tue, 31 Dec 2024 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsXCt73y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A0018BC0F
	for <kvm@vger.kernel.org>; Tue, 31 Dec 2024 16:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735662455; cv=none; b=TCGj8gUsddmxRSI06h2GEnOTTpYw1GH25IWlSHrMhwJTciMjytXfxX7npHg80Kmavz9OYK3Hd2xP6kIB70PtPuN85KP4H3MLfsOnVUMnln3Me3+5IJV2vFUKObjXpUhZIajEitnRFAqxpRAcHkP7qdhOwFWmqlvLYD19hQFPT34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735662455; c=relaxed/simple;
	bh=TR4SxjoOT0eIweh1Uui6So3pnk0Xwn3GddkK8U9aC7Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CixmpsMp6m0hj0PsXfrCJv33yRZn4ZdLRyQQJfuwtdqKsV4r7tnV3EpSAfDg1kcPWJzUV3W7pmm0kFFT+Ks7G2fDA4lnyGycf7+tNxE82GtoQpAqAN8uFjucYTZ2D+yh2CUJrvSM/ZV9L9YUDfRBDMbKcDKWBE6wkMlUv968mkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsXCt73y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E564C4CEDE
	for <kvm@vger.kernel.org>; Tue, 31 Dec 2024 16:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735662454;
	bh=TR4SxjoOT0eIweh1Uui6So3pnk0Xwn3GddkK8U9aC7Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PsXCt73yxeyqlYtsnXb2EN6HDyc5dcXCYX5BtQ5uBXbRJBBmQgl14QK2ReLrbHFMA
	 h4uplsNVRj+llK8I5PL8DJbuEtieq3DMY8eGF8siUMigPBMnW2Hicr6q/2rwygfJKO
	 niLmCQ8g32f4cPHG5hoEPCJi7qL+IwJmNTg1GOByQQn9eI+ecK4mC/TynWiElZAshv
	 qowk5T6zBrh58mpSQkdB9jId0PNJuBriMxrPDUdwfDk9I9O299y2/b6yWk5ZnhnsRe
	 0vxniatqQzOebGozVYu+pdWB4GF0Msa1EwGg109hwoaDYwRaizefoA23j0CNTL3SWV
	 ILv1dbbxTpuEg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 88B0AC41614; Tue, 31 Dec 2024 16:27:34 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219618] [SOLVED] qemu cannot not start with -cpu hypervisor=off
 parameter
Date: Tue, 31 Dec 2024 16:27:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: athul.krishna.kr@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-219618-28872-0mo2TUe4H5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219618-28872@https.bugzilla.kernel.org/>
References: <bug-219618-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219618

Athul Krishna K R (athul.krishna.kr@protonmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|[REGRESSION, BISECTED] qemu |[SOLVED] qemu cannot not
                   |cannot not start with -cpu  |start with -cpu
                   |hypervisor=3Doff parameter    |hypervisor=3Doff paramet=
er

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

