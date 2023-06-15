Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F230B731922
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 14:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbjFOMpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 08:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239852AbjFOMpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 08:45:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF241FE4
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 05:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 592CC617BE
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 12:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3A7DC433CA
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 12:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686833111;
        bh=aQ3ia7lLznZ47eKYsTixWShRR1BUmKZEg3Yp244SZa0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=W+KpbepvTAeVabqT22j8Z4otes8z2fV0t2TqQl01yeyWWNBjJOdWM/HH9fshMI5rs
         hYupa8I+R8PO+mAPLRTPFl3uZcnw4+PfLSUHUNQmfohf80wAkFSe3I7Ivq/J+H76e6
         Ms4TA8HDQ1QCoLtxDAZhGY53SJhuv0zffVyZG/zfxCooaCunhq4IRha6iaNEdNTHCt
         l76yrVHVe99acwqJWNmrRjR2wkb7NY2Pt9U1RVFZiX3vrXLVlgYwGHN/VH8njnSYWf
         BEVvM0BdTpo4YtEq98oJiiySzKK9PUtRL2BfESVSphaRdPIq/6cgs54ORXL2AtvRWH
         xlDGbADCNMjUw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A3EDFC53BD2; Thu, 15 Jun 2023 12:45:11 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Thu, 15 Jun 2023 12:45:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bagasdotme@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217558-28872-u8fTvg6kJZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

Bagas Sanjaya (bagasdotme@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bagasdotme@gmail.com

--- Comment #2 from Bagas Sanjaya (bagasdotme@gmail.com) ---
(In reply to Chen, Fan from comment #1)
> This issue is not found from this commit, it has been going on for some
> days, we found kernel 6.0.0-rc7 is good, but not sure when it started fro=
m.

Can you please then perform bisection between 6.0-rc7 and 6.4-rc2?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
