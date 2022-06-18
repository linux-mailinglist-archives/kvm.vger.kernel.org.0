Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD0555065F
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 19:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiFRRe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jun 2022 13:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRRe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jun 2022 13:34:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF96E095
        for <kvm@vger.kernel.org>; Sat, 18 Jun 2022 10:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E27CFB80B34
        for <kvm@vger.kernel.org>; Sat, 18 Jun 2022 17:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 850F1C341C4
        for <kvm@vger.kernel.org>; Sat, 18 Jun 2022 17:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655573694;
        bh=W1uX2UAe1Z16QN6dcy0Sm/iOjGSgt4OKfcnEonfntjQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IQtIE2s9rSz7BT13vxKVMx0SwhKsHK0n8u4aG7tashZhSFyt2uXxxWI5K6RdmG+Uq
         pT2XQTp7hWonVJWyyKSkdsEWKjaQq6iRwlNsejWy5x4w/BwxL8IGWdmT4tfOpY3cwJ
         WNHc7Wfu9zZ1KEwkQDSZTGoYMBdQFue0h79V7K8UR3I3WUS6PajRi9g4vxQ7maZ4XS
         6LLwiDzsRDFgGxUwR1ERGVBYAbOdaOE8KklraxfUrB9FvOXmIoSLchR+X9Uc0UReyP
         uT5j/T4TdI+/j1vMt72itr7xMjvoNLFaKoCq8LinPKSNZTjE4Dllh8n4kDIhx98r4w
         5JTTnBpNXQmOg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6FBDDC05FF5; Sat, 18 Jun 2022 17:34:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Sat, 18 Jun 2022 17:34:54 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216026-28872-np5GXHl4h2@https.bugzilla.kernel.org/>
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

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |ANSWERED

--- Comment #24 from Artem S. Tashkinov (aros@gmx.com) ---
(In reply to Robert Dinse from comment #22)
> Tried to compile 5.18.5, STILL BROKEN.  Same Error.

Developers are well aware, there's no need to report the same issues over a=
nd
over again, if anything you're making them less willing to resolve these is=
sues
sooner rather than later.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
