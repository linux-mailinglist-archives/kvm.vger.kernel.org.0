Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3E8597315
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbiHQPhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237637AbiHQPhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:37:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D971198D01
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 08:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74AF3B81E0D
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 15:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 125ABC4347C
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660750660;
        bh=xy0JgFQSxiVgiAVvPjPv2xFEDRs2fCiNXZnbBQni6UE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Cazpsh9PhNrkd4n152XQ4nThtI1fGk3lXrsTd8TjGJ93A7aCL2DDK1I+a9p3Ic8E1
         Kexgszzomz0sqaD0opmRwe3YdEJ7wakUuPGhW4fJ1STEZ9OulCoKAfmf47i0/yk2lS
         SNNVVpXYT0mikXkvpGx3pfahiKIfA9a+bdHRPmoVGhrqPD/kbs1obY/+or9pUt2Cis
         UhW/5tiETJovmjiBmkSPdcMr3twAg/3Qg29Rg7S+KH0TpRvsxmBKWS+kFTPEpm75VT
         233zZe33yK8DZYzFw5HAB1UuHqYOwYMbjQSz4c9UaaQSOX8+7+NRTwIJ5yK5RKvLno
         qHKRodjJFCcpQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E830CC433E4; Wed, 17 Aug 2022 15:37:39 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Wed, 17 Aug 2022 15:37:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jdpark.au@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216349-28872-Ktdwirz4JD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #12 from John Park (jdpark.au@gmail.com) ---
(In reply to mlevitsk from comment #11)
> Could you try a new (5.19 for example) kernel and also try an older kernel
> to try and see if this is a regression.

We're attempting to move to the mainline kernel at the moment and we'll test
older and newer kernels and see what the results are.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
