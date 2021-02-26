Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E995326347
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 14:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhBZN2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 08:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhBZN2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 08:28:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5856664F17
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 13:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614346085;
        bh=HFrr7m5ycOFvUQQJnbHQwBdtx605BD6sdGpS279SR2c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=M3aGwmJUcyuAqymTbQr5Ikl3vvk1AFnGOfxseEEgJwuinA1FjRSFQxMZnOh9fPWtw
         msH15ZSvJQhB7EAocS5+bAiXdrIspK8YmVJOUmn6vdo93VInGnXzYIaOhKynKO7Jid
         7f6P2t6sNRU/xS0BA+DccpUZDpebzmp5YGW7coDH8SInY1x/+bzPvgH7M2XovRRZQK
         uUxMNFVzj9DATCFjOXb51KvSHkFxX8KUp5iQrtpGHD/0LB5xgAj34Z7w7BqnLg9QHF
         fFspdCTxVu8K7oahNgMqsFI9zLGXCKLJ1HPF5XbcDiGpHHU//R3slI1NVCvYtOON2H
         tiKhji0mwvg7A==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 51D98652FC; Fri, 26 Feb 2021 13:28:05 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 26 Feb 2021 13:28:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pmenzel+bugzilla.kernel.org@molgen.mpg.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-EC8I08viMp@https.bugzilla.kernel.org/>
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

--- Comment #12 from Paul Menzel (pmenzel+bugzilla.kernel.org@molgen.mpg.de=
) ---
@David, please increase the number of retries instead of increasing the del=
ay.
Please also print out the number of retries.

Looking at the patch, delaying the boot by up to 100 ms, and no proper logg=
ing,
it leaves a lot to be desired.

@David, you can also test Alex=E2=80=99 patch *iommu/amd: Fix event counter
availability check* [1].


[1]:
https://lore.kernel.org/linux-iommu/20200529200738.1923-1-amonakov@ispras.r=
u/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
