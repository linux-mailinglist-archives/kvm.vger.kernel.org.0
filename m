Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6370C748700
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 16:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjGEO5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 10:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjGEO53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 10:57:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A344FF
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 07:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC98A615AA
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 14:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A9EAC433CD
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688569047;
        bh=j68Aky0Fg2YCPhB+Y0FXo+IYIu51I7qTrZcZiKqrc2s=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=T/dhCUrupWkODPqNM/NDatko9c2EXjuUnFdrCPTrybeT4onYoOgDufsD11X30A5zu
         Z/5O3hnBeo6OK11mrxI0un37MELl8YjBHx/CwunIKaG+IPIvxBRkWHSBFCLQMk50iH
         wCT6otefrGg1XhpfTMxKQSngaKRWJC+ZjWrQqUIPZix03O/DQTEhVGHRvkxUMOusWi
         pGlNO/5RuBwQsi8YBlHFid89mnjxmBbX5MVEKd7RMK/Q/6Z2n7EbKYcOz2alCPrLwN
         3rlKVPq+v7Op2447CGNew2zlT5XuHJeIGMcJx/fT7J9HcNrrakLWEd9FrMtG43sfPg
         L+y84sCDrJzZQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 480EEC53BD0; Wed,  5 Jul 2023 14:57:27 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Wed, 05 Jul 2023 14:57:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: 780553323@qq.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217307-28872-oFzpbL6Lmf@https.bugzilla.kernel.org/>
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

Prob1d (780553323@qq.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |780553323@qq.com

--- Comment #12 from Prob1d (780553323@qq.com) ---
Maybe just disable the sgx feature.
I use virt-manager by myself, so I just added <feature policy=3D"disable"
name=3D"sgx"/> to the cpu session.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
