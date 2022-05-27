Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3B535737
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 02:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiE0Awm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 20:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiE0Awl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 20:52:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7F7E64D7
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 17:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B748161C77
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 00:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC426C385A9
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 00:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653612759;
        bh=F5/E9lxTxpqrx2qrmeB9mQg4Clx9hL8i73rfy1OF1cA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LkaBBYpXY13NhaYmQ1esU0xLblLk7gBy38nkwCTnQabkHClZbdrI7KyIAgK9Z5gsT
         hwC9Zneq5H9cAKt05AYMsG3vvdZWo1G0nFj19jvIUk+rReJQvxFENTlmrvMvv9SxwM
         xZiEF3Vg56lqcyIwHOtlV7J9ZQAR0XcxBkwKQNicDQhUzliFbOBX95JWBoq/eGfLWq
         KLCMdvB+FAT/FUv8Eicks1a9fYVaeHJVpVR5fo+BRs3MHUNnYKmpgDSCdW4DxC443E
         T+RjcyGwD/r7Q+7uhlfNcK8Mua8gts2eNa3pLM9I4XCmlXV8PxBh0cwnA4uQRUBmWj
         c9EPOWw97b30A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C5DCBCC13B0; Fri, 27 May 2022 00:52:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Fri, 27 May 2022 00:52:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-7i4peoBggG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #7 from Robert Dinse (nanook@eskimo.com) ---
I erroneously in an e-mail among Sean Christopherson and other developers i=
n a
conversation about these patches stated that networking wasn't working in
guests, well, that was a mistake on my part, networking broke because of
installing some Unifi software for a new router that broke routing for my
virtual machines because it was competing for the same local non-routable
subnet.  So that was NOT a kernel issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
