Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6941E53712B
	for <lists+kvm@lfdr.de>; Sun, 29 May 2022 15:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiE2Nsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 09:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiE2Nsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 09:48:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0DC939F9
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 06:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D685B80B12
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 13:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D42D9C3411A
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653832111;
        bh=cqdlliq7IS8x3fEv8apGqgVRDg9EiwvnuQM8AgplcY0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=g0qiicE2EpBgGv+DjaK6IRswSQKp9ocLKG+Vbiz1+LYDQK2IAyRb43yAjZOf1KfJV
         55AedGAhIBHxyjDxA3H77UKtLzJW97iRMeXTYTfK6TapcIDr1mxZrDMsyZ2PrbriZG
         FsV6ZqK58A42ziu+7a/+NXx4snqIM31DWc0WTiiOyaPn6m8qZlY5/nHDlb4KngoOZ7
         YS7J1y7ydUsjtTMdKkw8uO7VfYQEYZXBpAHm5gJQV+ornBLKl//sSWF6K4fI2IFquo
         2kNvrB2g1V10qy34vJVfsEGCD53lRoZK7NCcDIbGtJbcw7ZBtlrXsrQ6o+hsuM+n+W
         lArrTipE4YDsQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BF5C2C05FD2; Sun, 29 May 2022 13:48:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216017] KVM: problem virtualization from kernel 5.17.9
Date:   Sun, 29 May 2022 13:48:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: opw
X-Bugzilla-Severity: high
X-Bugzilla-Who: ne-vlezay80@yandex.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-216017-28872-qW0u1SihXp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216017-28872@https.bugzilla.kernel.org/>
References: <bug-216017-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216017

Alexey Boldyrev (ne-vlezay80@yandex.ru) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.17.9-arch1-1              |5.17.9-arch1-1,
                   |                            |5.18.0-arch1-1

--- Comment #4 from Alexey Boldyrev (ne-vlezay80@yandex.ru) ---
The situation with the bug on 5.18 has not changed. As before, the system g=
oes
into the panic kernel...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
