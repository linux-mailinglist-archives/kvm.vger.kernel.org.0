Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA4173D32E
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 21:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjFYTMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 15:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjFYTMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 15:12:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4364710E0
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 12:12:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C1A60C09
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 19:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55625C433CB
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687720344;
        bh=+CnKCnzPrFjUW6r6BN5Ip7/Oo/ZaPnBbVDdwELjHMfg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bnc5YFmsesW3NIceFDA02TMwvOXS8nYx14x1atDjyLp7QIErJCZS6PsG54zCzMMdy
         ydgrvuaQBd2YOz6NY70mz5Rr0c0Fsa6KoaeJimgGxOFoF269eRjCIDDnYvnrrqqQQD
         QiTLlvgh9+qm/M7klvaPG2ZtDk8cqDM2XJC6y3gTN4TVtfuxWXL0WQkyw7febuawgt
         ey1ORrMj7hOTgF2Nyb2BhgM3AJdM7P5dYJklEb05wJWBj99Hsi5H3wFiCh7vtyO5ra
         Z7FkvroHZg5LrQ5pQ1auxPHIHNgQDMozoJSUWyDmK4mTmzuZ1rsgSYfX0ZcgYRF1Mb
         HMxgIGIvfp5Ow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 34A60C53BD2; Sun, 25 Jun 2023 19:12:24 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Sun, 25 Jun 2023 19:12:23 +0000
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
Message-ID: <bug-217307-28872-zPWRMYmTRA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #6 from Micha=C5=82 Zegan (webczat@outlook.com) ---
ping? can anyone help me to at least push this forward a little? this is re=
ally
an annoying bug and I would at least gather some info if I knew what to look
for.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
