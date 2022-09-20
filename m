Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41585BE97E
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 17:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiITPA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 11:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiITPA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 11:00:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA390193FD
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 08:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12B96CE193D
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 15:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54A52C433B5
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663686019;
        bh=C5yYbUouY5Ma+jWeSaPIXoq+TW3kwKkaMnYYnKwXCNA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WOZWBPLud/arBRSvKvm2iwzs2qs0WoBhvzef8z8Mz5gniRRE0uAqvMHPIZ1rKPnC6
         w6rcQK2HRDfSPhHFI9BLWT8HtbABiajKWXDrAulTA/zAC4obtoSye7zLouH93yk5uo
         UZxvZNGJ0/rB7hbDXXO6hohD+gaOklZd75CPil4/vN7ALlvMa3trRkyQiWqPVpVr3O
         CBxRdr8C7AY/akqiuKKOtGtzRq58NbeU4JxYP7TbdSHMc/FOyKbkQJ5qmRghADRo04
         iT5QcIaeEyFtghu8bsHj3APz7I4UyEJseQnYJvf1rt3gsjwxviqrClXcSmqVcuthqg
         dNLCqlfXq28IA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3DDDCC433EA; Tue, 20 Sep 2022 15:00:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216498] Can't load kvmgt anymore (works with 5.18)
Date:   Tue, 20 Sep 2022 15:00:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dion@inhex.net
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216498-28872-xM8r83YWm7@https.bugzilla.kernel.org/>
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

Dmitry Nezhevenko (dion@inhex.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #4 from Dmitry Nezhevenko (dion@inhex.net) ---
This patch fixes it for me. Sorry for not checking latest 5.19.y before
reporting.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
