Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D125507B2
	for <lists+kvm@lfdr.de>; Sun, 19 Jun 2022 02:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiFSAaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jun 2022 20:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiFSAaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jun 2022 20:30:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCB7B1C0
        for <kvm@vger.kernel.org>; Sat, 18 Jun 2022 17:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBFA560AE7
        for <kvm@vger.kernel.org>; Sun, 19 Jun 2022 00:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43D1FC3411F
        for <kvm@vger.kernel.org>; Sun, 19 Jun 2022 00:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655598599;
        bh=RXNWdpB72sL2xSOuPnjMY2tC+Ftl7egNuvNfoTzet1s=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=r2t8K2Su2i5GuCgGwrpt7j+ZcFE/G4XAN5eItHYtf0C34Nrsj/BDeUjlMcuE/wK7r
         aJFge+omXWPRjjjV2qcZbmHxgbtV89k96TWVrXCHyMEdvVwhbFNIB1lRPjmZFJweOs
         Ay/90krpiIHpNjdDxyWHRKc1Jj3nWPLFeMQKaixJVVi72C21E85XKscR8ELg3+FZ+o
         lkcmfYHNg7VVii24JIXRm88fecFZZDHcpfnHObbMCyMAqew3vwvW6CHOk2+Fu3c9x7
         OTFJGsFXJWLIEGFJ/8Z5z/h3Hcb06Xsnje4neMeVyTaSTTFYmc0Az4Z48SIYG3U5sa
         jb43MtVjlDVqA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2DB37CC13B4; Sun, 19 Jun 2022 00:29:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Sun, 19 Jun 2022 00:29:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-TQUmgnGCLf@https.bugzilla.kernel.org/>
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

--- Comment #25 from Robert Dinse (nanook@eskimo.com) ---
I am sorry you feel this way but this was a new version of Linux Kernel, so=
 I
added a comment for the new version to make sure people were appraised, if
someone else had posted this first I would not have.

I'm sorry the development folks get in pissing wars, if for example Linus a=
nd
Nvidia hadn't had their unfriendly stances perhaps I wouldn't have had to
switch to Intel graphics.

There is unfortunately no viable alternative to Linux for me so I am doing =
what
I can and this seems to be the only avenue available to me, to make issues =
that
are significant impairments, and I don't know what can be more significant =
than
being unable to compile, known.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
