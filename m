Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011845530CA
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 13:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349215AbiFULXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 07:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349805AbiFULXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 07:23:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5517B2A972
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 04:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E35DF616FB
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 11:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 534EBC341CC
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 11:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655810590;
        bh=uzDTkuacsNA8+pdPiCafsk2jwmzEF0YEuFVqnUiKXeo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HF7Fr8yjSwwmUP91pO0euX+VYjxaJb9N1dJMPluBruhzSD7pigONogAIc004zQbXm
         NsqVON3UAQcworbvhRXPONgL1EQuWsZNkqqQqYyoqS0/e5E39XKat8bjVei6CFji1f
         tGc0I3EDGGfbsyxoqdKcY4XzQvcw6Jpg++pfCfBgkIz4bY9T7r2QGjZhr3CLKjyjcP
         SF4VFsYofofh5TWvtuAr126D6Vg+sMJuHICLqs9uvvZG4fwbZTQ5UpN7Z8Lf+bB5pg
         HZlAcRWmOQevVVfWRJ/6SMiGPkyZbffwGxz5DnbGWKtbqBqJWHZT044nB8Ok+i2Gxc
         ECHEV7mFEAd9g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 376DEC05FD2; Tue, 21 Jun 2022 11:23:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Tue, 21 Jun 2022 11:23:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216026-28872-CqMHKSq2f1@https.bugzilla.kernel.org/>
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

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #35 from Artem S. Tashkinov (aros@gmx.com) ---
This is fixed in 5.19-rc3.

The fix is trivial:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arc=
h/x86/kvm/Makefile

ccflags-y +=3D -I $(srctree)/arch/x86/kvm
ccflags-$(CONFIG_KVM_WERROR) +=3D -Werror

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
