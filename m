Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEA874DE90
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 21:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjGJTvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 15:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjGJTvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 15:51:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB0DE6B
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 493ED611E8
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 19:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF72FC433C8
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 19:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689018658;
        bh=Uw4fEY4Fo4EbZsNsizj3mh6e3aqt6mz7TWj7dOnhlQI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EyVCoEMV0Dwg9V22DJ523ZsgWnruVi3/0Rvw42ahikTFqiJ+GYj7114tNENkLzbgQ
         vs3/I6369G7qu+K1WdrqBfqv38tCp63SmyCAqCBdvUo8EvUA8AETU3Dt8h1oKYko/k
         nlLPVtm7MRntmmbpDIhPrgydiUgYSnCIRrpItBC5IdIzI/yP/37abVqowikb6QwIcG
         /mmb1neQFtP4mXWd/86d60T0PCuPecO99hivbdvR6KDAurhjBEAFISzNEmCtwwsIRc
         mEsB2m9sgMyNGSMtLk5lW3Omof7WjT8QnBFnAhFyAudxsW+CQskjtLQ5Inl2iY5DQT
         aHuvp6DDesoHw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9DFBAC53BD0; Mon, 10 Jul 2023 19:50:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Mon, 10 Jul 2023 19:50:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: webczat@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-5kmj4iCPWz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #20 from Micha=C5=82 Zegan (webczat@outlook.com) ---
when i have a chance i might re-test, but for now it's a no.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
