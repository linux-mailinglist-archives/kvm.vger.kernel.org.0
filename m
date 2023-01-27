Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879E267E623
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 14:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbjA0NJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 08:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbjA0NJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 08:09:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B685C474E4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 05:08:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 071B8B820C6
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7359C433EF
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674824920;
        bh=3l7hzfSxWjIqP4WUEDGAxUjN8c1PLLawgrOerMiUEvg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JCMGh0Erm7Jj+87zLzOp+io4N7mzC4gBEEElv3Y8EvfKD6aR5tROT+ycLYNLh3+OA
         k7bacWSdOodE6wCTJp2TA8CwXv3mfuPJz0IHO/WFABH1yNM+Zml2zpRju3mIFs7OQE
         /A00ypG0HC78pUtAjl99eHDW7qopC9vWtAKW+XPDJxZ6MWSw65DL4epBTXKg7J7cU1
         5r22dmMBFoFem9kgMBibeBTdW5EYR/aM/VGzkBgoaTDINUInSLdUkOtlz/GoVyzeQw
         qHRcj1g653HR0kzspxvaAWeOgCxg+NPi9kaF+ceDu/uhCdNP1AmRjHlnOCuMD2esnv
         /rhNp+IRWJb/Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A758BC43144; Fri, 27 Jan 2023 13:08:40 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 202415] soft lockup while running windows vm
Date:   Fri, 27 Jan 2023 13:08:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202415-28872-hoOn75tepr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202415-28872@https.bugzilla.kernel.org/>
References: <bug-202415-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D202415

Roland Kletzing (devzero@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de

--- Comment #6 from Roland Kletzing (devzero@web.de) ---
this may be caused by intense IO on the host if your VM is not using virtio
dataplance.

i have seen such when copying data or live migrating virtual machines

have a look at=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D199727 and
https://gitlab.com/qemu-project/qemu/-/issues/819

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
