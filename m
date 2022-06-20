Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38001551FAD
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 17:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbiFTPDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 11:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241489AbiFTPC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 11:02:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1801B2B1B2
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 07:33:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5C7BB811CC
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 14:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 371A3C341CA
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 14:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655735592;
        bh=6NPHzmdIAmUG7P+it1phygERnh97sOiGFMzrpgtqq98=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rVnVVTFd10IYsdlkmC95DdsVpvqc4KGRYLYoLv42+7o6RFvOp3RmI0tdNJWwvI/7c
         MIm8B3kzVxRM+P+nKi9At47DRlnf6hB217lf5lKZjxnO7VKJwtsJ3OmlN4RoQHwEq1
         kBXupwDis7KX80e5ovA3tgXMtgo4Hj+fnFLIL2ID5ETDGf0g2JPZtqKf9U0kNonUCf
         sPQKlxu9C1vMfR9yHc7TlvuKqFXXymJwnJV+C23/Sval6BKt/qPRFr0WEj/avAgInl
         jSVlnn8G4sRFsOLXmIhC+kp579MhhwEKfKJ+jXrA34XyoEU8eGk4p+HNWI7Tb05pk9
         pTrHvtJhkdung==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 24A20CC13B5; Mon, 20 Jun 2022 14:33:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 20 Jun 2022 14:33:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216026-28872-vevwQEGT5N@https.bugzilla.kernel.org/>
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

Robert Dinse (nanook@eskimo.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|ANSWERED                    |---

--- Comment #32 from Robert Dinse (nanook@eskimo.com) ---
(In reply to Artem S. Tashkinov from comment #30)
> 1. End users are not meant to compile the kernel. You have a distro kernel
> for that.
> 2. If you are willing to compile the kernel you must have the means and
> experience to resolve issues.
> 3. The status of the bug doesn't affect how fast it's gonna get resolved =
or
> whether Google finds it.

Might as well just get rid of Bugzilla then huh?
What a putz.

There is no good reason on God's green earth that end users should not be a=
ble
to compile their own kernels, I've been doing so since before there WAS a
distribution.  Distros often do not configure kernels the way end users need
them, nor do they often maintain them anywhere near close to current.  Both=
 of
these are the reason I compile kernels rather than use the distros.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
