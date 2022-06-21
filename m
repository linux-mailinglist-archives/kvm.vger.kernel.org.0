Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EF2553E0E
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 23:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356575AbiFUVpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 17:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345358AbiFUVpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 17:45:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68170175B0
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 14:45:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 044B3616CE
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 21:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6207AC36AE2
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 21:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655847944;
        bh=aUcO6uXGgGv43AI8N7qSz97w5WqGmNwFo530+6T78WE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nBER1qvLlFYjKS/d4Op/bJkFSldTGgkLt0Sx2E+Oz1UyGtf+aTHhc+0JQvxm9Igwe
         4+CW754ZSzR31uk8noQ/boYo1S/qNoA3Ume9b19tohzgIxwDX6GfSW5rtOOdySbi7r
         TGI5xa2c3s6x+YOThq48PI1NsKa2eTCnqla9rK7CqgzlJEFLlr/LrG2b9/+sgVzKgD
         KokzEJXouX/IN4tHHxtsJM4kU6+L4pe/rkzFWHSXlhYiVR2R8xGhvNXh6ylLwkNGFw
         8xS3LPQckRxwbN7WK+zYum4rq1qyfOpIzBvXOgfVcpclGQyinbi6yJspyIiqKhlCJT
         lHdWjAIlm8abw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4A57FCC13B5; Tue, 21 Jun 2022 21:45:44 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Tue, 21 Jun 2022 21:45:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-jAJllNgLMU@https.bugzilla.kernel.org/>
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

--- Comment #38 from Robert Dinse (nanook@eskimo.com) ---
5.19-rc3 compiles good for me with gcc, still a problem with llvm using
multiple cores but that's a compiler race issue not a kernel issue.  Do wish
the patch were applied to mainstream as well, but am satisfied knowing this
will be fixed in a few weeks when 5.19 becomes mainstream.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
