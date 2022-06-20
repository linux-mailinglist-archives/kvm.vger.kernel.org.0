Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8984551F1F
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245099AbiFTOmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245042AbiFTOls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:41:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D022181C
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 07:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6A3F61554
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 14:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54110C36AF4
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655733690;
        bh=+ZMFQbcDRfI2o5seTPeitM15Z/+Gc3gwmgpmOhiVkvs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XHSiNqVdwnhv6/ugUy1S9toVXKBWGK4aTcobWWPa/0c3PiIy2hKrHomg8UKadiru8
         yH6HPgzHW6YDwLotcL0aGg1q7uLEG1w2MevCGXrKI2ehTUgZCK2H6ubcKeH0RB7JD7
         WkcIxoZ6oz2sncUUhnjRIAu0PfU4qUvvfkWx5dX5YAjrETwausRmkLc5mAOjOC8BYb
         oyGK9qrw1D4wQy95aLAIevup+NNXiVSPNuvbYjlEtVt86FvoSj2MD5iU1fBYtof8zE
         cj2DYEoRMPTqEDeQMnq92DoGXp/U2mIwEkl9Bl2We6Lc6hrjt2TwxkOITs7kyBDvLe
         U6ev0kMJWS9Mw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3DB78CC13B4; Mon, 20 Jun 2022 14:01:30 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 20 Jun 2022 14:01:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: alexander.warth@mailbox.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-UxG3fjoT9n@https.bugzilla.kernel.org/>
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

--- Comment #31 from Alexander Warth (alexander.warth@mailbox.org) ---
1. You are OT  but - Any user who is able to compile the Kernel is an endus=
er.
There is no exclusive contract between the Linux Kernel and the Distro
Maintainers. Thats opensource. Any code user is an end user.=20

2. I'm compiling the kernel and I'm able to solve it by applying the patch
given earlier in the thers.=20

What we are asking is to mainline this very patch. Such that other people
without knowing of this thread in the nerd corners of the web are able to
benefit from the patch. I guess thats why patches are used to solve bugs.

If the patch is working but not stable it would also be nice to be mentioned
here.=20=20

3. I don't care when it is resolved or not. Its a bug ..there is already a
patch why is it not mainlined thats the only question.=20=20

Instead of writing all the 1-3 and putting it to resolved it would be more
fruitfuly to any one if you/or anyone else briefly write a oneliner like th=
is:

Hey guys patch works but is not fully tested yet...could take a few weeks
Or hey guys patch seems to work but breaks xy thats why its not mainlined
or hey guys patch works but problem is not really solved yet
or hey guys patch seems to work but only masks a compiler error.
...=20

This is how a goal oriented user <-> dev <-> maintainer relation works.
At the end we all want a well working kernel.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
