Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B2F53702A
	for <lists+kvm@lfdr.de>; Sun, 29 May 2022 09:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiE2HYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 03:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiE2HYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 03:24:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA11666B3
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 00:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D7B2B80919
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 07:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C503C3411D
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 07:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653809076;
        bh=RavUiph3XFIvT7S4tgHvL4GHJ8fQ7+WGCmNjL7dHGyg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=j/9Co5wH2ccO59t5n+xehh5o4zpEaecs7CRCSKDwwU1raDYyFmuAjlxCJIS8cQZxE
         cYiPeBToWxuJL9+Jlzb9bhS0PHZb8oqp3zcmJ+cgyLzXOc+rag9EkxdPq3Z9aPDwKt
         9Xu3P5fYDxsBknjmsxZA/aOL8gapZx0CdHdVxlyafT8RZVzny9V50AMKALy31rhyRv
         toJ+wZldh1etJZHnK2Nj7uS9ZiZWN/eUsSSoKYhVxYtiLKLvaZq9hGFLbofnjeTBSj
         nElz1IMrivh2yqBa50Xv19DZxXF37qwjMaYfHxZ8FS+EEqLdm4fGb2UXUYVT0axeS0
         TUT85C2xV9LDQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1600FCC13B0; Sun, 29 May 2022 07:24:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216002] When a break point is set, nested virtualization sees
 "kvm_queue_exception: Assertion `!env->exception_has_payload' failed."
Date:   Sun, 29 May 2022 07:24:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ercli@ucdavis.edu
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: MOVED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216002-28872-vyl3eKC4bm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216002-28872@https.bugzilla.kernel.org/>
References: <bug-216002-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216002

Eric Li (ercli@ucdavis.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |MOVED

--- Comment #2 from Eric Li (ercli@ucdavis.edu) ---
Thanks Jim. I think this is more likely a QEMU bug. I have filed
https://gitlab.com/qemu-project/qemu/-/issues/1045 . I am marking this bug =
as
resolved now.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
