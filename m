Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB58720142
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 14:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbjFBMNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 08:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbjFBMNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 08:13:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425D31B4
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 05:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C333764F9F
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 12:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D19FC433D2
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 12:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685708011;
        bh=zqZ30rwA8KlDQ3TjQDAlf2Ztoo8jO40arCyHNhRL/fA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CswzTGCTgX2HuSdzzJg3aHt7QN1NNrPE2o4JGEcQCKZAya9tm37JLbd5iEH0wy7Ml
         KN6++gR9j1CvZz/oQqoP7sdvBVJlPY5Pb6bdbE3C5Z0mPeV2YH0mO5YqabBWDX/yel
         trR8aCGZrcknhS612qQg47+QxE03KzyJJg+asPhFu+ooDRIJT7T+aoU1yf7tADUu3l
         ET2N+8Ock72sg9fDlS7/ojMuFio+JLhCFe4crvqLU568Tak7a6SZbltUNUV6m0C5t2
         NhV/eKyDHqKvnpxBdlYGfVxfzdtkb3pqrfRIzm/0sxoy3OIj9uUxevaRr/3ggX4PXW
         m3AN2GD5UWb0Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 13AF0C43144; Fri,  2 Jun 2023 12:13:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217516] FAIL: TSC reference precision test when do hyperv_clock
 test of kvm unit test
Date:   Fri, 02 Jun 2023 12:13:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: bagasdotme@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217516-28872-RrXA8OOkCM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217516-28872@https.bugzilla.kernel.org/>
References: <bug-217516-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217516

Bagas Sanjaya (bagasdotme@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bagasdotme@gmail.com

--- Comment #2 from Bagas Sanjaya (bagasdotme@gmail.com) ---
(In reply to Ethan Xie from comment #0)
> # cat /etc/redhat-release
> CentOS Linux release 8.5.2111
>=20
> # uname -r
> 4.18.0-348.7.1.el8_5.x86_64
>=20

CentOS 8 has been EOLed in 2021. Can you test with Rocky Linux 9 instead
(and preferably latest mainline kernel)?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
