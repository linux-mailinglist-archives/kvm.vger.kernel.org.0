Return-Path: <kvm+bounces-44716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FD8AA0536
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 10:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 864C83B25C5
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E58279786;
	Tue, 29 Apr 2025 08:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3PY3l/4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DCC2741A7
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 08:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745914188; cv=none; b=WifiyKb7UmpaBK9sHShi2iU2RYeH3RiTZty/6pYm60eZiWC+WYSy6QU3f7Wl3TahPmp3i0SoveCBQ22vkEk9EYecQJtDqJWg1tNe4sRraL7WrFoyqlJZsRLBojVhIp5pM2eFCslFdgFOXdX+pu/LtbXEjlZA/GfWErKYBNqaT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745914188; c=relaxed/simple;
	bh=IjmpdTWn6XFw+zY8or/CzGj7xGSukuFZwzcK7gOK+Cc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M9utJvEzyhtIUqkzv1RxU9HN4GkvDtkFdrAG1ro40GU1/qbZswhVvQeddJ1iC3D+ldQsC4DImNwvuJDMSrdqBzQTE3H2D3SXbcUdQFIYv4fV2XxUYJNCy3rfxqQFhnqgOUC/NGvY7aAv+Ccl+rSEQHuR90SwZ0NFOSzLO+dlzEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3PY3l/4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAC43C4CEED
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 08:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745914188;
	bh=IjmpdTWn6XFw+zY8or/CzGj7xGSukuFZwzcK7gOK+Cc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=b3PY3l/4J3z8hlcHnYd+vyjWPcV8+0vRBoI4uH3JI3U1N7MxFTv+NefC056jhwYWY
	 1vo44ntfGvnjLXHAb02GLvBRsTmhRdVV6Eu47GsQdMsGitYiSPEyAYMOvmdeKH4ZtT
	 bYS1R/vr1j/m/oM7do9mIUNLs/DzuUVnhE+lWlhqrPEEDi41nlKJXdQAQeCqqe2VvF
	 SKlPmj/8z137ecVlwetsedpFFWYD24s+1oQedZTTB27b3sFAXA3cBufxsRNBV1Gakt
	 lGOMUu2gFul9tX8cUgYHKJ8y/2CFPlO+pMoCdbcGsC1GOoF5g1LeLERcBUJRA0xsjd
	 8P7Kq0iOoC3bw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E4E36C53BC7; Tue, 29 Apr 2025 08:09:47 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 08:09:47 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220057-28872-k0dhdSlFeV@https.bugzilla.kernel.org/>
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

--- Comment #23 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308050
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308050&action=3Dedit
qm showcmd 200 --pretty

qm showcmd 200 --pretty output with phys-bits=3Dhost

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

