Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366596AD8E1
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 09:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCGINl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 03:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjCGINi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 03:13:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBE3279B5
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 00:13:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E0FCB81203
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 08:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DC3DC433A4
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 08:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678176809;
        bh=/jjjqfg1AK3DvjRBl3aVXytrTL0GnbuhCx20TG/CRy4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IQXt25sAgBMWm6I+/QXh/rVeC3YoDXB2WOzLhDTNyddKhLWkSxkEELcK8oqUJ0oH0
         9tGW/mOChL6W+wbEA28uDPYdFqzyiAdcFUmNKC7XtQEmUwGwQq2mcEgGYOmhoA/ri8
         7uKgiWqQgX9T9V0niIPNtRydYwRMnXK74bp8+1v3sAwgIncvh6q6+iDbkT4rQARd7L
         bXRURZ7aWTlPtWLi2IXmasFkWDQAyIi4n8vtT4/xJ3npFgJXVvCCvGGNqHiAn5LCEO
         kGzF+BN9zpNzi3/T4wyOIKbzY7FD0gWOyabkmv7GGKEVyFZTGYCg5HlWjf2E0FwtXy
         jQs2AwMikjFug==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2D9E4C43141; Tue,  7 Mar 2023 08:13:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203477] [AMD][KVM] Windows L1 guest becomes extremely slow and
 unusable after enabling Hyper-V
Date:   Tue, 07 Mar 2023 08:13:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hjc@hjc.im
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-203477-28872-U7Ps013nzS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203477-28872@https.bugzilla.kernel.org/>
References: <bug-203477-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D203477

hjc@hjc.im changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |OBSOLETE

--- Comment #10 from hjc@hjc.im ---
Confirmed that it is no longer an issue on 6.1.0 kernel.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
