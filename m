Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A98833EE57
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhCQKcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229644AbhCQKcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 06:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0889264F6E
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 10:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615977133;
        bh=KEdtcMYVlNitNKNhjBe4DkLK/qdt1nOIeJy4rT7a/gw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Gk1siXnPcyUyqjMmzQAVsUDadIPwE1E882u88dYWod3nJ2rWV+cEPBKjs/6cdcyZz
         1Ru6CfX6mGjupSpf9Nv8vCv9fMPa3RWau/JTj2WdKtu7NXuzHOQ6MEJG00HqNn6mdb
         X9kWkxNOktkd5BZsgWl0BMi/ijE9jHUcWpHKn6urt7kCEvO8S66cyf43OM34JiYxHD
         IgKXRh2MzHmUVDF3KLZ1UaMFWHPaFy8URg2DBcjPLRy2chMAGzAUEFpzkMNAbXsIP/
         a334h1fZeUt6bND+S3m2QaF39eKvbSt3Fch7pQYMoUkAG++RvKyCf7ZuY3R0b0O12U
         Nmkcwv/tgBaOw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 0621A653C5; Wed, 17 Mar 2021 10:32:13 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Wed, 17 Mar 2021 10:32:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david.coe@live.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-Zp3gNLcCnD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201753-28872@https.bugzilla.kernel.org/>
References: <bug-201753-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201753

--- Comment #24 from David Coe (david.coe@live.co.uk) ---
Just confirmed BubuXP's Ryzen 2500U result for Suravee's (logged) patch on =
my
2400G with the latest Ubuntu 5.8.0-45 kernel. Cold boot is marginally faste=
r,
needing 5 x 20 msec, rather than 6 x 20 msecs for warm boot.

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
