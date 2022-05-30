Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F045387EC
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 21:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbiE3T5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 15:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiE3T5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 15:57:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45955544E5
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 12:57:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5CF560F06
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 19:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EC74C3411C
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 19:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653940662;
        bh=CBMSLCwXf0f33osfz3U2KUl5x29pS+CIfUM4VFnermY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QWKfSeZeUt48UpWUsOI7gHoq4ZWD5D+nKEzOr8OqS7ShYyUK0GDpp+Yo7z4D1xmIh
         9wjXssldIvExbLzho6ivt1qNH/bjKCgCtk4nYVQel6jbXZ4CFGH3pAfzcpp0TCPOyL
         czhAClsZ2L3NHNJhnZX9Dv06zNUrPneWZ03XOAPR69w7/8Q8rSJDhR3LUg5V+/B3LB
         RGEaxqyqVuYnyLP+j35b4xeWPNsc3L83HOoGEnbwLHGoB1k/avOtSY4HdefE7TKN2q
         a7Xy9SM4q+K/s4JpL8ovk3l1ygYORV1SmKSzMvGr4rHxYCVkdijGOmhwPhTuWLOgyx
         nfaR6W4OwOz3g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2617DCC13B4; Mon, 30 May 2022 19:57:42 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 30 May 2022 19:57:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alexander.warth@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-OWGqqxpaJK@https.bugzilla.kernel.org/>
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

--- Comment #9 from Alexander Warth (alexander.warth@mailbox.org) ---
forgot to mention. Same circumstances GCC 12.1 Ubuntu 22.04 (PopOS)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
