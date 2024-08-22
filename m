Return-Path: <kvm+bounces-24817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA1D95B2C1
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 12:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA38C283665
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 10:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E006117DFE8;
	Thu, 22 Aug 2024 10:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUYA5Yq+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1999C14F9DA
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 10:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724321966; cv=none; b=LE0hmXGyfcXlzFUfmhmy8mTw8sAHHO3jkvOXU6shUryNjv355ncCeU8OhYUb4Cg3xN3813WArRryEmAeYp+dYIapncaQ/xo9PDlGqCI+NusCBj4nenmA6vhzj56z7sWd4wlsr0onHkYC8CVwcf0x8/cVs+WlhUTI3iQkymIjLlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724321966; c=relaxed/simple;
	bh=p9/hN7jqxFX81YbZ6dK104KttUvmW0EyToeOFhj4o9E=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bjjdZmxuSM/aK56oQNNbM6j/xxTsWp5Mgqujg223m/HiB5TiRqM+TmaZr5T5nhCccZbgLM/HSRJDSGi9QsWqRQ4Wk9+V43+Br1/WdEQFwIiGxS+eMPIEPFimJP2GI4p4bN5losEBxtAaxl2f3ZNGbbr0B/KsfjOUICHppbT3lZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUYA5Yq+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CB42C4AF09
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 10:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724321965;
	bh=p9/hN7jqxFX81YbZ6dK104KttUvmW0EyToeOFhj4o9E=;
	h=From:To:Subject:Date:From;
	b=iUYA5Yq+Hsx9HScY8LujJDZp8km2nUa6bC62ROwjJ6eYSEIdzfEyr8ZytWTwrivTM
	 BLH3QjPcusdIRvcVA/eiu+h0Z4m6PGFuhmzuuui1coVpbDGNqpQS47Mb1i9TbKZokO
	 5fXSaCmVyx97kSdeWV0oXBEQCRmbDpOPGFoA1/7J9qKogkp+uLwzjZLbEEbO+cAZdP
	 k5BHCtcfOcd3h3gIw0yu4sMBE0PmF50iL5XoVCm1G2Ps2F6W84aeToS2ZmpoCJp2VG
	 zEX8+lHV5O1fr+x1cVHPVDfxbib9nnWcAFDPCv3LuREgo4buj2TtC4yPfsSVyLAlVF
	 pXTK574hHhp3Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 90B1DC53B7E; Thu, 22 Aug 2024 10:19:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219190] New: Kernel USB device namespacing
Date: Thu, 22 Aug 2024 10:19:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: weiss_julian@outlook.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219190-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219190

            Bug ID: 219190
           Summary: Kernel USB device namespacing
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: weiss_julian@outlook.de
        Regression: No

When trying to bring a Rpi Compute Module 4 into flashable state. One has to
connect the CM4 via USB to e.g. another Linux PC and exeecute rpiboot. Rpib=
oot
will probe for the correct USB device, writes something to it, makes the de=
vice
reconnect the USB connection and writes to the device again.=20

When executing the rpiboot tool from within a podman container, which is
started in privileged mode, rpiboot will successful probe the device and
execute the first write. However, after resetting the device, strace shows
rpiboot is about to open an USB device, which does not exist inside the
container. When checking the hosts filesystem, the USB device exists at that
specific location.

How is it possible that my container knows the correct location of the outs=
ides
USB device, but is unable to find the filename of the USB device inside the
container?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

