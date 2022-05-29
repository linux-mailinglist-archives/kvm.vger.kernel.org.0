Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DE0537285
	for <lists+kvm@lfdr.de>; Sun, 29 May 2022 22:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiE2U2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 16:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiE2U2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 16:28:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFE366C8C
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 13:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7EBF60F18
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 20:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2818AC3411D
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 20:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653856086;
        bh=c4gsgB8gt4zqc+DMlJgfRMkp21PQuu7jcisB9IWBcb0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IkNUuUkcYBoEIyMd6ZSQOAOuhdV6tjxgHrbeL/ZqarZYkdyc+yCBmRFXC3ZfsHIMn
         8C0ZikGyzxF5AkZ97q/5C6kp6m5iWprefgAxnSNBzCwhOKJfRdHk9HEf/1gtYhFlXJ
         KPycYl2343UN6xezm+frGu2IgzUbcAUhszEn47SA9RlXTvewQ1XqZmlQlqtmzqKsGc
         FxuN0IciYch7lOdE+RAEVE36nKQq3xODYRAjUYw8u0CyRcppgGlsVcP8H6JfyFRtjA
         zLPBLZPp6u3W6/1JhI8JWLOc6ZR34pTimSstkNwfCAY7K+WCBlkDf4CtxLmY4O6MFe
         66EXbIoragtDA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0FFA6CC13B2; Sun, 29 May 2022 20:28:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216003] Single stepping Windows 7 bootloader results in
 Assertion `ret < cpu->num_ases && ret >= 0' failed.
Date:   Sun, 29 May 2022 20:28:05 +0000
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
Message-ID: <bug-216003-28872-hBRJt95u78@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216003-28872@https.bugzilla.kernel.org/>
References: <bug-216003-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216003

Eric Li (ercli@ucdavis.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |MOVED

--- Comment #1 from Eric Li (ercli@ucdavis.edu) ---
I think this is more likely a QEMU bug. I have filed
https://gitlab.com/qemu-project/qemu/-/issues/1047 . I am marking this bug =
as
resolved now.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
