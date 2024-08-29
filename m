Return-Path: <kvm+bounces-25366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9029648DD
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1960B1F21B33
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93AE31B143C;
	Thu, 29 Aug 2024 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FXX0/7ur"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8331B142B
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724942696; cv=none; b=oYWEpmdH2pmjUY+EMGHDVPnXOSVI0BREb8In6wRB2GS9cGwJnLC5bnYoX7O4thdYnfXF2gneJBpb9UsSMG2fCjNV9knwI87URPmSPIeXwJRqXRQAGE8CS8CouxC3O5eOwreNem3s/hl2BCK9ywAQzucnB7JSIoTkGBGUIknMjIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724942696; c=relaxed/simple;
	bh=NvADEVTKF+t+kG4cPjP5jq6YyDMm4BGNSyXI6KvsS/U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tBj8OAR7Nb6Ru6m3lIRCFaHLtaFPxQ8vh2bt1gZwDA1crXX3TasMFrEsOs41c/phMR99TWQxz3Fh+upyrO9DkH1tYAwnJ9Wg/rB7O8xLGjoisV74dj/7C5946xC+EGv7QFvrtkkqmU8Y3mmsQkM/uha+Juhi3WLmEThySGxIeq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FXX0/7ur; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 606ECC4CEC3
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724942696;
	bh=NvADEVTKF+t+kG4cPjP5jq6YyDMm4BGNSyXI6KvsS/U=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FXX0/7urT1uhAP2PfvOAugjdQBqLX4nI59qP1D4SGkZm4xIWgOudp2CQaOM9mx/UC
	 3u6zRhTO4oMo0P2h1nBfbKbSlz9XElqpyNOm+glgy9AVWDllx0d9ckgBR3zZFwo4zG
	 OU6MTNbxOvWbNpqCePeGZSDWoZR6R1gjf+E3vjZeHANtJHFxcLaemD2Tx/R/BJGwuz
	 664xoDti49zV/RyvC5NmVNvgXCc6aDwNo+Q98Pu3rme0hYv5BcmNYYpWNQ+H6HiN7V
	 KsdXYjcr5OvdYr//S9mq3x9l0FkWCma5BRqZcySFD03YOCiKbdp2XHLfY0Y5XIC467
	 GfH+wSI/EEHQw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5291AC53BC2; Thu, 29 Aug 2024 14:44:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219210] [kvm-unit-tests] kvm-unit-tests vmx_posted_intr_test
 failed
Date: Thu, 29 Aug 2024 14:44:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chao.gao@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219210-28872-JRqGkxuHkD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219210-28872@https.bugzilla.kernel.org/>
References: <bug-219210-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219210

Chao Gao (chao.gao@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chao.gao@intel.com

--- Comment #1 from Chao Gao (chao.gao@intel.com) ---
There is a fix for this issue:
https://lore.kernel.org/kvm/20240720000138.3027780-1-seanjc@google.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

