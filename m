Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332694C41C2
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 10:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239212AbiBYJuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 04:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiBYJuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 04:50:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1578F247750
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 01:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7761B82DB8
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 09:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C588C340F4
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 09:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645782567;
        bh=1gZRQFEwZKqcEoiWXLItSA1ER/Qavpa+eZ1dSBL+1i8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Nz5lYASptlWjAMxvR6FaZSvsEYw/Sygf3yaqFb9Xc9RlUSwf4BnbR4FBnEXlIxbpB
         t7UJ88YnSldcYWym5O86eXFinmabqoJSIRO4Lqs38MX7qhA7IpS9jPrJVELUULJLx7
         HDPAUxYz7oLVJSb4mVnoH/ZIFBICG4JovIHoG6bnyUgEXGlgVi/zA6+lCRZdCMVV4Q
         FrBPtpPqcbeHyWpjf192ZPsuFFnSvlhmuNaNsOfsdWCrT7LxPDlkhooNNxfItat2Kq
         9T3J4lu073NwO7hY4awge9kMBkuEw4r3A5TwzKxwUIqXJh9y8dajTUFseNagOclbGY
         A7wGRFz1/yjyA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 311B3CC13B0; Fri, 25 Feb 2022 09:49:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Fri, 25 Feb 2022 09:49:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zimmer@bbaw.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-9H6dqAqgsU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #11 from Kai Zimmer (zimmer@bbaw.de) ---
Thanks for your research Roland Kietzing. I'm also a user of Proxmox.

We spent a lot of time for troubleshooting this problem and after years fin=
ally
invested into a decent full flash storage system - now the problem has
disappeared here. But this cannot be considered a solution for all affected
users of Proxmox.=20

I fear that the error description is a discouraging for any kvm developer:
"Proxmox is a Debian based virtualization distribution with an Ubuntu LTS b=
ased
kernel."

Maybe test a recent vanilla kernel version and add it to the bug metadata to
get more attention?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
