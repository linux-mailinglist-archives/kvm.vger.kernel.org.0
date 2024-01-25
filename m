Return-Path: <kvm+bounces-6974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EAD683B916
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 06:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 31765B2151C
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 05:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351EFD2E8;
	Thu, 25 Jan 2024 05:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8h8Sara"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF347489
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 05:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706160662; cv=none; b=l2ohGDBXLTO2OfOecGTJ+dTKdEWvu2KvcsN+4Yc9LHSdZU4Y7nhRD9tIbJHDCksotEXEOTvZfYEDGWcPYll9GN4AanSJqK1zN/5TeJA1GP/RE700z1YRzsP3r3FtgJUNJLuSSjPzDqnKIG4cnZL5Z13pEQrMgiDxExIMWmNscKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706160662; c=relaxed/simple;
	bh=uSJ8fa2l6pQmEZZUNMsG0eRAhg8lLG9VT0VIZVXi+Zk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BJCKL+C3duPIHnI4FYPKz2W3xqSyUaRTqJiQqMkCFkm4Vt0MwdMEhz4fOxH1WLl63sxSFTyUcVk0c0jTd7jVqkmQG2h2I6oH5J4WDJoCrHIVLVCbGzkH7WMMpMxAJjJPBuU+ayf7C4DGxAN4f1xMjyFR165B70LoHNnIk69k+dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8h8Sara; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4FC7C433F1
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 05:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706160661;
	bh=uSJ8fa2l6pQmEZZUNMsG0eRAhg8lLG9VT0VIZVXi+Zk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=F8h8SaraiwK8paCBE8FkyodXrniGT/yjV6wGSrEjVNV7qpkAkE0mauuIf6Spr0b9v
	 aOpgek3DVourgYeOavo10Ccf9EMd/pYP/cXTeqBevmjOQUhGHVGgBcG6z8p2kXi1yg
	 2/i1bN8PhX/CEdrPpL9VcK/1vewzUtjhtP3A+dO1lOT+atqtLNnPM+IkYlPGeQ2Rmj
	 b+gxuh90oLkDj/GzqDr5z2CsMwaXH+paBrAEnR57UoGBwT57pT5g6P2r6luLAr0uox
	 SC36p6TG3TJhdqTyUOz1PbUKjUcbgAczjteZs6modaMEXlKob6BF/uZG1pIuylro5Q
	 sVOZN2LYZ6WWQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C1FC8C53BD1; Thu, 25 Jan 2024 05:31:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218419] kvm-unit-tests asyncpf is skipped with no reason
Date: Thu, 25 Jan 2024 05:31:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dan1.wu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218419-28872-kOUDVx9tfL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218419-28872@https.bugzilla.kernel.org/>
References: <bug-218419-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218419

dan1.wu@intel.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dan1.wu@intel.com

--- Comment #1 from dan1.wu@intel.com ---
The fix patch link:
https://lore.kernel.org/all/20240108063014.41117-1-dan1.wu@intel.com/

thanks,
Dan

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

