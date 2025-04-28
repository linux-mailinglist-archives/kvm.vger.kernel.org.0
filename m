Return-Path: <kvm+bounces-44607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54273A9FC2D
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 23:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF4AC463F7D
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90FA1FFC4F;
	Mon, 28 Apr 2025 21:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXRazl2t"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E090713D893
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745875587; cv=none; b=CQ05CVUNuHZImkO1f/zRWYJBMPh6LWZi8XmrGsBtUmf1q7r1n5953AIizF2KzKhYAx+no/1lZfCkZLVwdfL6t/E637hA0mF7ICee2ZEiI1GNovuCub0FndT9NyhxSzrEud6EiVmIiPihNcIZlmHuyFGOAiRoxoDT5DKkeNxioHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745875587; c=relaxed/simple;
	bh=GV/bk3H2l7uUUjTMHEtZfZj+mzpuyJXsgzqOqSA+Hh8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ALJv2GWABYN+bkvjIZM4tnAao9JSlE2UxnfHOSwlKDqAOnlTgdbH5/r4FX4Kec9d/kv5nRC/9kbHiA8fD9zNiMeFYKghoT6CYojEFuG961lkhR285w1rfvyOZGcFx9UcF0nPws1BliGI/13a+8vaz5xGXQkgweeJbitQFVtIbJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXRazl2t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51ADDC4CEF1
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 21:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745875586;
	bh=GV/bk3H2l7uUUjTMHEtZfZj+mzpuyJXsgzqOqSA+Hh8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=pXRazl2tNauZjM6FM3hSob1yGzUAPYSy+4ObfjUbmfilMR6oLbDn1ooqWdChph59P
	 2PWfINUUaRrXk8HTfcNX4WYc5q7+TcGXedwGpxYOx2xGGlR2vRvk9yJAFjf65MH9QZ
	 pjbTjXv7BTGJOLJWkEQW7RWgZjt14Ig1hCPm5DCLoGf8DcBipNUHMDUzIhB6Eo4VSK
	 cwkDaRJBwERWiXuMP2Pl3d+exLiejcLdD7U6x1Z2jp3O1A2M9WU+ZJXYhkcEY8yUpi
	 jsn+t+YTTQQ5nsllAjWrNEtWdLCWhnYMbipBF74B9G7+OzO3gD+6PObGuYjXOIoj5c
	 N8lX2V2JJXGqA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 49095C53BC5; Mon, 28 Apr 2025 21:26:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 21:26:26 +0000
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
Message-ID: <bug-220057-28872-sCqFs1OQZN@https.bugzilla.kernel.org/>
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

--- Comment #11 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308043
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308043&action=3Dedit
lspci -vvv

lspci -vvv

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

