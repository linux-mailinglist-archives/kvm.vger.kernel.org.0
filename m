Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CBF4F6E82
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiDFX16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiDFX15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:27:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E21A2AC4A
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 16:25:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE71061D0F
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 23:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3738BC385AC
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 23:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649287558;
        bh=Pfhf0qnqrUmxWSVwBtvbxFvhHKJdl25u00POv0x6jlg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DrFI9YsYS1UiTRtAxvEPPo0xWzSjdzJKqSYGxhHQ1Z+DqrmEncTidnUz+kOB7bmof
         wzIeNpOEKLNOjdU4mjcQlNr/t02mxEgCRSYcSH4MI/e+iftDC1PwOqcDt/gDsSIpf1
         IthDfF6WB0ujnlW5zpwT6M3AdK+rHWum7lFa7e7X7P5zvesSa7dLTEjf+sTnTq4gsK
         MVCq2zHOptmfDayuUO1AFSERfcljyCOfKygvMwhyiLO0HxYqNVtnp9VMBtWrkj1bxx
         Qv/zz1GVETBBLnoEce6K3z85Of0YEHyLMSs0zJ52kLc8VI9KDTVLn+b0RuEwlwKW0b
         nbYdyeJZUbMpA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 222EECC13B1; Wed,  6 Apr 2022 23:25:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Wed, 06 Apr 2022 23:25:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: gkovacs@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-199727-28872-81krIrlK2Z@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

Gergely Kovacs (gkovacs@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|3.x, 4.2, 4.4, 4.10         |3.x, 4.x, 5.x

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
