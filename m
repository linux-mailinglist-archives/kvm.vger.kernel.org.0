Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F29546FBD
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 00:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344017AbiFJWsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 18:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiFJWsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 18:48:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A33219761E
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 15:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96BE9CE371D
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 22:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D88D6C385A9
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 22:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654901299;
        bh=gYiUVCVEVz/0zg0ThY5bFukXzo0MR7RTM5fSyCDjkT8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jVl0grMc2VK7Bjy6MRYJIlrRZuxTUCg9hjLCmwfKpELVirWFTgmkeG9Etm9Z94F4U
         09hKP7KG/fOxFoO7bRNw8QO+fMe9Ts1jFlH+yZYaPhioBFmFGquTWYFfXJfx2TggVj
         4HH/SGRr8u9i/JUIedS/370/AMv4FosATq5neQ3dxPIkywNUhCiR4REJA1/Mw7sQbj
         mhbY6bzHusweCV3rkbY6oeLYsCxC2tqJbxZdsPduaqfOVE0+YfuzeqfCb2MC/WXkfs
         uLERVvBQDeaBqvnOpMhnlDvKo685sV/yXT17daL2tUsfEgl8fDtLgwJDIsDpPLY973
         t5oDnb+a4/HIw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C1529C05FF5; Fri, 10 Jun 2022 22:48:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Fri, 10 Jun 2022 22:48:19 +0000
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
Message-ID: <bug-216026-28872-2Dw3hKPhiH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #16 from Robert Dinse (nanook@eskimo.com) ---
5.18.3 still fails to compile with the same error.  Would be wonderful if t=
his
were fixed before you EOL 5.17

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
