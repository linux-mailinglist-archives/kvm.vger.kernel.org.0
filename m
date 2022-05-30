Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC785387DB
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 21:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbiE3Trg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 15:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243082AbiE3Tre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 15:47:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF28951E5F
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 12:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 653FBB80E91
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 19:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 345C2C3411C
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 19:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653940051;
        bh=w1Kc3K9tc07+hIHuJe/MXZcQhI75Ca7lFWRxjOKetn0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fDJ86c4zIalYQVVRiHnqIdL+zPhFSMz9v3vVJHeN+JdDpgdJx9nJo0DvXhKmGRN7t
         cL/RNfBClMJd0dljU7DbMvAeKDYtvaolnwX8eImyDqmRENwsRNY7XveMcQMOmsD6VW
         B3kp8tN/XteAGFJ2Mr6TVAaJR8yLnLsLutKWN4gMCMyhREyUamJa5EqEF0DFetHTSb
         j756sORq1sbWv8+mrMWq4GRAM6iFTueBnsk3o/0hJyrFt1ZCITA3OBk3fvLqSa/OBV
         pEAfLp3N7mB7ukLUURsKeKQfKdimAaRt5d7OEmEQt2NORggOurw5yOr33PKEr/CeEJ
         mUeA/2XY4E4Kw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1CC9CC05FD4; Mon, 30 May 2022 19:47:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 30 May 2022 19:47:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alexander.warth@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216026-28872-q64PeYpDgM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

Alexander Warth (alexander.warth@mailbox.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alexander.warth@mailbox.org

--- Comment #8 from Alexander Warth (alexander.warth@mailbox.org) ---
Got the same error. Is the patch somewhere downloadable?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
