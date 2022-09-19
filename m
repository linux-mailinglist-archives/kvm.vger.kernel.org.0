Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4045BCA34
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiISLEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 07:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiISLEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 07:04:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E582AC2
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 04:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A26E4B811D3
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 11:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D21CC43470
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 11:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663585477;
        bh=HM935FArdOaEXEuUgrKYGZ02LXGRwd+t6bwhIExoFpU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rOK7gmyhxR81jDWQgaZvN9RvG8g2UzG2YV9Q6eb9r4PxbeMx7px6uxkXbeNqKa154
         nxGu6Z4RNRG4UZkmGHPbKs7ig7BguGtfk0hkp1TkJolV+EU9HWjp+sJ4U46C8/eVQo
         nCjanNVaXCEEmReg2GnPth3Ay9uXnlBcOV3d3rrGlHFUyY+dIupMsZQbSbnutDCh7f
         TA+guzEFTrqXqaXbe0DhsCICal6NmN5DHNKSvHQLI0zUs+z38GMyi3a4UETFhZzBHH
         s7M6YBwm9sxCc9ARRhcybOcT6TVaexKOrQYJMVHBFW4DcBABAys44+1pZ5Ss2u+dOp
         2b4Z7kRrLlBJQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2837BC433EA; Mon, 19 Sep 2022 11:04:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216498] Can't load kvmgt anymore (works with 5.18)
Date:   Mon, 19 Sep 2022 11:04:36 +0000
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
Message-ID: <bug-216498-28872-jgPELWIxVV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216498-28872@https.bugzilla.kernel.org/>
References: <bug-216498-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216498

The Linux kernel's regression tracker (Thorsten Leemhuis) (regressions@leem=
huis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #3 from The Linux kernel's regression tracker (Thorsten Leemhui=
s) (regressions@leemhuis.info) ---
Does this still happen with the latest 5.19.y version? There was a fix rece=
ntly
that might help:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-5.19.y&id=3D2914e46f5b0399279ad56e3c0247a2da72fa0f21

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
