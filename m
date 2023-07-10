Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB174DE82
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 21:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjGJTuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 15:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjGJTuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 15:50:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1521B8
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 469E7611BC
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 19:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABE23C433CD
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 19:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689018588;
        bh=I0J54nkW9r5PSjZwpab4F9NQIHQM2ClAiz9y8MwAvvM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cb5CU4Cumg7oLsK0dmNWp1FFPAFzzAgKpsS1r89xk3/63OrUE5j0XEgoquD5tJjd/
         Qfm2+88lh8MNRbwrH6hFz93wIDS03SvAMYzL8jR9ZiPSXvpvue4N/j/Tskh3bVDRv5
         3OWNGtQAitysrYtirPEkOpUuPdSGjEDkn1Uqg19/k5C9FCPko0y45vOwUcC87EBchn
         J7d8l5LhbuI00QHh56lR80teIFKilK2PjCQ97pzRNJ6FgD6DcxHxbchAN3z9eQEd5R
         g9CnqJaAUJIEFciUMLTLEK0+WWjH6pAS3AC7Vc4ohN1RGptGNoqaTN4B/Ng8czicfK
         V0tvQohcwiG4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9AF22C53BCD; Mon, 10 Jul 2023 19:49:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Mon, 10 Jul 2023 19:49:47 +0000
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
Message-ID: <bug-217307-28872-32D35T2sUW@https.bugzilla.kernel.org/>
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

--- Comment #19 from Micha=C5=82 Zegan (webczat@outlook.com) ---
to be honest, i have tried with no luck, even though someone suggested that
also works. it might be i've done it wrong, but i was checking virsh vcpuin=
fo
to confirm assignment. someone said using one core should work, it didn't.
tried pinning to cpu0 which is one of my p-core's threads, and no.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
