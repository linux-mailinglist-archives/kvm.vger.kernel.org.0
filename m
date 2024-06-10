Return-Path: <kvm+bounces-19241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BCA3902671
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 18:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E746FB2943D
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFE0142E9F;
	Mon, 10 Jun 2024 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QSroMZ/Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF5B1DFF7
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718036263; cv=none; b=hHbGTsDqf7V8joknxdhHfn6rEWCOWSV42DQHQgsfU35WTUnmiFGvgIuLmhzfpD0moaJEmPe9GSMe6nT6eRmVqrZRNMNFkC5UdZ6J+VfUUyjFAOT+Kp6tHiN9Fid2g1zkH4QJpdtjAbLfgkcnFVkqwrrR0UbRcka2EIBxfi0vHZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718036263; c=relaxed/simple;
	bh=5ZwY3hICG4tjhdbDj5CnMG/Xe/Gddx3aXzHbmUVc/jo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uyhQ2oox+BEf5sPOhfPhxyM1ATflp5lv6UQxfnAI6K8tJSC9/FymxZ+OsWIbmf8ADTaKavrFRib00oLnQgoeYfPK8AY8dSCVS1B4nTuEdYZaGgZkIli6wsYiQ0PddV0LoqYKrD/2P4+jE3z72LVOpgyKHexBRKyns8r3gCd5xCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QSroMZ/Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2699EC2BBFC
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 16:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718036263;
	bh=5ZwY3hICG4tjhdbDj5CnMG/Xe/Gddx3aXzHbmUVc/jo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QSroMZ/Q3bjtpIJWETYiCAjG+RW1cAj44Lot7wdQJ0zvWp1VS3Y3N/wPnnJdUcTf0
	 oKhK8uNTVhqpOzdQ8Z2bO6a5Tvj9RPDxMLXfLGQdzwBQcTJY8w1qV8GAVcx8ZV7Sjk
	 barbI/SP5mQeAzD0srfswQ2ZfJeFHixnvpzdGmSXeyU6jN/uQ66cCXlWukhCdK7nL9
	 c4GfQRIBaivf9zZm59MheCNONTMW8BX0nBqAxBnbQIXoEh6+IGj7y3zklbKYiULxua
	 v08OM8Cs9S7lK1sjnd7q4thqL9iKVVGVb2dIXdCiZIVGsalI3sQNqNLSLejBj4QFYz
	 b94jpLgnMV4eA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 12DA6C53BB8; Mon, 10 Jun 2024 16:17:43 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218949] Kernel panic after upgrading to 6.10-rc2
Date: Mon, 10 Jun 2024 16:17:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: badouri.g@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218949-28872-8yuhoyGcH9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218949-28872@https.bugzilla.kernel.org/>
References: <bug-218949-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218949

--- Comment #4 from Gino Badouri (badouri.g@gmail.com) ---
Hi Sean!

It always amazes me how fast you guys can find the patches/reports for cert=
ain
bug reports :)

The WARNING happened on 6.9.0-rc1 (so before the final release).

For the pfn warnings I've applied the patchset from
https://lore.kernel.org/all/20240530045236.1005864-1-alex.williamson@redhat=
.com
on top of 6.10-rc3 and it's completely fixed, they're gone now.

I've tested Call of Duty MW3 in Windows 11 with the NVIDIA GPU passed throu=
gh
the VM and I didn't notice any performance or stability difference with or
without the patch.

Thanks a lot!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

