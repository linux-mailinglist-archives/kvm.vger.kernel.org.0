Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE73873CC7D
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 20:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbjFXS6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 14:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjFXS6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 14:58:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1541110F5
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 11:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 979F360A2C
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 18:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1430C433CB
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 18:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687633129;
        bh=xOpYtX/6IZR2mO0Yp2/qT4950NB9SspIUKtm0ueVxHA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GQ+W12L8y1HWLiPkcj1rNkcLUdrxkNKDakVcsvNaxRK3sknDk/NLj7G1iBroxQJsD
         EjqXjHH9CN3RADg2zymjEbZhyC7L+fTVY9tZxS9duIyFRfITILTabYlS2iMlkm1ubC
         PMtz2WnGNDEiYGwDKCB7yg+1uAGf6KrIXXf6iMDqtD4e/wKbM5vpzssFdTmeVQUAT5
         +iGVCxTh49wdBqsglCYxtn1wBEz42GKFUGWnBsDW0+GMQZC6sG9dzYXCQ816jSzBUE
         eufgpRSA9uCIrYfevcVlypuSKVFLFxjb14LeTPuoBVhvNyqYlxzP3HA2n3Jv7IpH1Y
         hgbBh4zYLNJfA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D2CD4C53BD3; Sat, 24 Jun 2023 18:58:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217574] kvm_intel loads only after suspend
Date:   Sat, 24 Jun 2023 18:58:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: drigoslkx@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217574-28872-31AOMnhnTv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217574-28872@https.bugzilla.kernel.org/>
References: <bug-217574-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217574

--- Comment #5 from drigohighlander (drigoslkx@gmail.com) ---
Hi folks, sorry for my misunderstood.
I ran the command for all MSRs in the range 0x480-0x491 after bootup and af=
ter
a suspend and I didn't find any inconsistencies.

How can I share the file of the outputs?

Thank you

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
