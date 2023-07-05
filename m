Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2FE748769
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 17:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjGEPFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 11:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjGEPFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 11:05:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8000C1BE8
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 08:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB8C61597
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BAB7C433CD
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688569519;
        bh=ANAfJO3pWIJsThPmpTHuyKMV02k/98XQSmFjvWFRDeo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SGRd5R3Pin3kAtNNiL4WV0xDh3re9faQgGTm1XQuHyqgXOMOIi3LES9Ghjr7PQzch
         pMyEjT/oxc+ybGaltMgYFkpK0O0BFNDsh+ZSMKc3yBsDTOv4cbqM/sGuhMww2x9zSt
         WX1E7DV5RbJm9Wi6dD0MtnwoyIKIbG1h6TQMAc6zwDZIP3xEDbdTxFzFjKsH8hHgt7
         ZpPCbqtm3NRRlTzPElnzxUZePJBSzAOSQgW2z5tUrqxwfqxPnSAaHz1mCtih2sxBgX
         qx/PmNY53ExujVR7FOOsvInMla58oeGEnICgWRGg4RrP6wGFh/10cSa3+utJcslTY8
         /UEF3SNeKroig==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EC18FC53BD4; Wed,  5 Jul 2023 15:05:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Wed, 05 Jul 2023 15:05:18 +0000
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
Message-ID: <bug-217307-28872-NbTRz8IQiB@https.bugzilla.kernel.org/>
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

--- Comment #13 from Micha=C5=82 Zegan (webczat@outlook.com) ---
unfortunately that does not help. also, 12'th intel client cpus don't have =
sgx.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
