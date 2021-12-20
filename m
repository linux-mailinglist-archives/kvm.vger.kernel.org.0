Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC93147A497
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 06:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhLTFcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 00:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhLTFcb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 00:32:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A9BC061574
        for <kvm@vger.kernel.org>; Sun, 19 Dec 2021 21:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABB8EB80DE7
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 05:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7414AC36AEB
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 05:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639978347;
        bh=hMnSdjP5Nrf6ZGO4GAFeDh1wgvngx9G/8tY9yGjhhuw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pQmWQTiJo/YsMRgz5onn9tfSpL+2LNXip28sre2NwQHahyK5q4iJAdWyHCZKfvqCN
         SEmnnMbh/CZtg9Q2kHy4dNa3PPjry6Oq3L/hibmvgu68yLr14yWhwcOxVdHGoCuu6N
         KEhkLHXCFWJyekbiyI62GlMAQLmY4raT0WCmcK42tSrK2N1ISk5Yy4OlysEkq82Krb
         hflnxBiwTyBuoSPuMVzBLpn1MPkm08FzVpr7M0LHqLU5/2brUuO9uOJfRDucSkwhaR
         h3fL3Nf3sE0S++CLXtalDAEnFtJgoCUvPAeS51ct31wVtdfwGxMDmD6L/U2laUHwXf
         76wCqXnCpExyA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 4D25F61106; Mon, 20 Dec 2021 05:32:27 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215317] Unable to launch QEMU Linux guest VM - "Guest has not
 initialized the display (yet)"
Date:   Mon, 20 Dec 2021 05:32:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rherbert@sympatico.ca
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-215317-28872-PILoahqSIW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215317-28872@https.bugzilla.kernel.org/>
References: <bug-215317-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215317

Richard Herbert (rherbert@sympatico.ca) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #5 from Richard Herbert (rherbert@sympatico.ca) ---
Perfect!  Thanks to all!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
