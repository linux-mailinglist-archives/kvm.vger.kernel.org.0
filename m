Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C769740314
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 20:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjF0SU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 14:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjF0SUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 14:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9E297
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 11:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EEBC611FE
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 18:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3691C433CC
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687890023;
        bh=MlxoJxzuMwXHlrboEIsXGP4D08QGAGAm6jNOETRwjmY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gcrpx5NOMG0vV8cOVOaFGhXBimeqEvtaK86fw+D0IGfbwd8Lo3ma4kfZi+jNXIAYS
         l0x1mUUADhxE/1lFcFU/KyrCp12GJgCJuw8IO1yhRry3PaW5A8GNrwTMfAaRKxYR3X
         zrqFdcadwYWUJPGIl7M+dmNUtNVDyjyc46AxqDDUXMFheSGi3uuct7RETh/lfd81id
         M/sj8mZwUPS/X/I8J6UBrk+TKZ66r25Tlbk51cwp+r3bTmVsrLEKnXopfo0dJ0CegH
         PVH61vYDGGrBytD7tJeleEQLwSUnXh7twiSykbeqdm8x6xzdEDaUidCRhGVtAH5o0m
         7dnj4zdlOcVag==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C1AFCC53BC6; Tue, 27 Jun 2023 18:20:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Tue, 27 Jun 2023 18:20:23 +0000
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
Message-ID: <bug-217307-28872-jKMnRyyl5I@https.bugzilla.kernel.org/>
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

--- Comment #9 from Micha=C5=82 Zegan (webczat@outlook.com) ---
correction: it was kvm64 which didn't work at all.
qemu64 worked when disabling svm, but actually despite the feature being
enabled it insists on having virtualization disabled. investigating further.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
