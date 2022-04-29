Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DB0514116
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 05:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbiD2DR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 23:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbiD2DRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 23:17:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BB75AEEC
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 20:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F52A62256
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 03:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09AE4C385B2
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 03:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651202045;
        bh=cgMPXC3SlNfzkj6FU2PRmrp1Shc2sNTR1VjPBe9rWg8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UNS3ZYRCC01wSFxkPp/Ju2uVa2CcfY1sy6o+dsN0cIqbIsJvLaX9IbuQicKvAqDn6
         JyBxGGcB4e/ZPYyAeiU55vi+CuJuCXqOoHiHw1OFfzelPWPS3ZasUFXI3hEk/6Mj0B
         QUA33rnswsa2erZKpPh1MpWxNVmUltan/bJ9VsjNNORdw2X5hNplILaLpSa/qe4a6K
         gIbPaTRoxX1eI0jscvyx3ykyEh6LijpppQrPRuAlCYtEySx9eeSqcc39gVdqNoB2eR
         xj0iJtfLczld1mm6LC1Zq3O5ndOZE5YaCSAQaQIxbctcJNwK2ODEti+ey5yceqq5Nl
         aFj7dNri05bkQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E1A38CAC6E2; Fri, 29 Apr 2022 03:14:04 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 208767] kernel stack overflow due to Lazy update IOAPIC on an
 x86_64 *host*, when gpu is passthrough to macos guest vm
Date:   Fri, 29 Apr 2022 03:14:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: fivescarynightsgames@gmail.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-208767-28872-KxlDVcRfBN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208767-28872@https.bugzilla.kernel.org/>
References: <bug-208767-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D208767

Carey Dalton (fivescarynightsgames@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |fivescarynightsgames@gmail.
                   |                            |com

--- Comment #9 from Carey Dalton (fivescarynightsgames@gmail.com) ---
I see, thanks, I've created a new issue:
https://bugzilla.kernel.org/show_bug.cgi?id=3D211853
https://friday-nightfunkin.com
(In reply to Alex Williamson from comment #7)
> (In reply to Paolo Bonzini from comment #1)
> > This should have been fixed by commit
> > 8be8f932e3db5fe4ed178b8892eeffeab530273a in Linux 5.7.
>=20
> This is not fixed and it's not unique to a macos VM, a Linux guest can al=
so
> reproduce this.  I've seen this both during PXE boot and during shutdown
> with certain NIC combinations (see rhbz1867373).  The only workaround is =
to
> disable acpiv (kvm_intel.enable_apicv=3D0).  Any suggestions, Paolo?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
