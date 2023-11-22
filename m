Return-Path: <kvm+bounces-2264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2A87F41B8
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 10:33:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7679C281822
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 09:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD0A5102C;
	Wed, 22 Nov 2023 09:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9tZdAjd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0344C51012
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 09:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 801B5C433C7
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 09:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700645573;
	bh=Cr0m9SC0ISA98Cde+hB5L3DaMDf7yTqbrdLwnPkdtb4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=i9tZdAjdHdB3ryPVMxHLEn/mUyFo0lyOWlH4Te7IGnlw7WyqvaLghlQ0+xZg1D+jq
	 URdh7Eev0L3LsCbAckshM0XbvlAYxaXaDuq0a5sLHqMRs+pJt0XbPLUPMjjR63tUKy
	 8J78lekoDFSxtKQCemTFCBLA262rIoEKJw12SXTR6VLJiqSqjrmMYqqMLnDmGxRhmR
	 scHWnQRARtPhjOrHG5Gl/3lnE5rRFl0DdUDdK9qe0s07aJZBYP5BqZCgd2HxgBCra2
	 jBv+BvKsbHaqXMJfPqLKq3iWuT2sVLWxXHzwczxxfRI7XSPOwqOkiQX8PQNjA1/t9e
	 75jp2KxYeqPZg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6E768C53BD1; Wed, 22 Nov 2023 09:32:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218177] qemu got sigabrt when using vpp in guest and dpdk for
 qemu
Date: Wed, 22 Nov 2023 09:32:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhang.lei.fly@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218177-28872-r19CSZSxpj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218177-28872@https.bugzilla.kernel.org/>
References: <bug-218177-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218177

--- Comment #1 from Jeffrey zhang (zhang.lei.fly@gmail.com) ---
Created attachment 305459
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305459&action=3Dedit
qemu instance xml

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

