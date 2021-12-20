Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888FE47A3F8
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 04:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbhLTDmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Dec 2021 22:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhLTDmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Dec 2021 22:42:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0502DC061574
        for <kvm@vger.kernel.org>; Sun, 19 Dec 2021 19:42:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93C4E60EED
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 03:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEE46C36AEB
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 03:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639971719;
        bh=Zv53DB5vJJ6s93EM1ZA63S97URDk0urig727o6fp7wc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JeetQ/6AAUES34B4k2P9K8qtsaFCjF8DsNhHqjgsJ7y07ZP+b8EvYcnaGtqmEYGrq
         QO4UcPCkUtd2p6jDYHipaAc+2cZBvpW6gcEpOBEawttM+23eT4/deZkS14Okm9RyGh
         b/d3VS5jlpfRZTLz5+aKY7ZepPek8wEEsA72js/500eyGZjcpadr2OUSNAjezpml56
         w/wp0m7lLvxznu4iI+9abzXYvbAXJBC9bcVSy2wXlqGSMkk2xZ3QwXi/VBnNxknCt6
         Pclmz29T+T/ExUsRE70vHg3ay0LPf2O/8MetI2PgffG9+BgNYA9Nueolqr7gt+KeUx
         2cHsARrKk84AA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id CB24761100; Mon, 20 Dec 2021 03:41:58 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215317] Unable to launch QEMU Linux guest VM - "Guest has not
 initialized the display (yet)"
Date:   Mon, 20 Dec 2021 03:41:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: regressions@leemhuis.info
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215317-28872-kWW3zNmoKL@https.bugzilla.kernel.org/>
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

Thorsten Leemhuis (regressions@leemhuis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #4 from Thorsten Leemhuis (regressions@leemhuis.info) ---
(In reply to Sean Christopherson from comment #3)
> This is my goof.  We're bikeshedding over a minor detail, but the fix sho=
uld
> definitely be in rc6.
>=20
> https://lore.kernel.org/all/20211209060552.2956723-2-seanjc@google.com/

Thx, the fix landed now:

#regzbot fixed-by: 18c841e1f4112d3fb742aca3429e84117fcb1e1c

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
