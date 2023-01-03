Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0F465C9B9
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 23:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbjACWju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 17:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjACWjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 17:39:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614CDFD37
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 14:39:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA83DB8111B
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 22:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C672C433F2
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 22:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672785581;
        bh=CNDa+G5nkCRWUAnNMQV1TxqAokjFBWvSL3Zf9dJhUaY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LukZktUcnZRxwdsnnOKGE1BzkCkcXwKdGtP4tS1xvlt3kNImRgUk1qjXRXDbs+d//
         GvAxHfmlseYzMr6ClHMuVAN61IHaZ1fFLc25aGhevgkQp9PSiLaDB74kWtlENhOT0Y
         ZZr5gnv/vo2xfD2h+Evj0moTkZTSzVu06ixdeCZ4VK9vY9dK58ft06SJbFgA9/7QXz
         7xBAHo1mTc/myiD6dPGntC9retCtlYUB0hCXLOh7P4Ch8V/FV5MRmTLyVy3E224Vgz
         2Ummfz4JE4Lky7dQAHOrdHQAYHtcSHZ3CP1L4A2tZqKq18wy+aNwKU4cPlPLEKfUsN
         iaDzSkOLn2jeg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7D8CCC43144; Tue,  3 Jan 2023 22:39:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216867] KVM instruction emulation breaks LOCK instruction
 atomicity when CMPXCHG fails
Date:   Tue, 03 Jan 2023 22:39:41 +0000
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
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216867-28872-vzQ4S4KyFI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216867-28872@https.bugzilla.kernel.org/>
References: <bug-216867-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216867

Eric Li (ercli@ucdavis.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |WILL_NOT_FIX

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
