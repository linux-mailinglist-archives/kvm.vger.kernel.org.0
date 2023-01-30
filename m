Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DACD680A92
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 11:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbjA3KPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 05:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbjA3KPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 05:15:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAD31630A
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 02:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30B97CE12C9
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 803FAC4339E
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675073725;
        bh=iKtSYZdDIUNtLA5lFjd0IUX0G5wj+/rdSZIocNsNznU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BQeOTodRhCeXdC426CtWOwAVRWVr+gJPduZy4dly0I4elzEFCJCqfOOjZchqgpY2v
         R6iSvMzNwkGpDwoZ+PDsZuCdHAtSB82JWDQQ2k8Cr3LFf6nNvBcJgAAjk185Zdjypg
         HYQ9KsOzKfh9Mq84k/SzAZ0UG9Zak9s/sSwWjGuobgq0Rh2eXfSjQs0FrpL/IKx8W8
         VYNexk25gj4Yg6XV+BWUD+ZXG7x4r2demuqIa6JV5XUHr59IR9UkX4I4+dYJ2r3gV0
         T0VVK+yk9u/VkPrelis3ZiHAj7PGAghrvmvsjCUTrjADjvkwwrzZxUh/SpfAHF9U9y
         /Nbgw4DumxQPw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6D656C43142; Mon, 30 Jan 2023 10:15:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216923] kvm-unit-test pmu_pebs is skipped on SPR
Date:   Mon, 30 Jan 2023 10:15:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: like.xu.linux@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216923-28872-eK2wiwPVkn@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216923-28872@https.bugzilla.kernel.org/>
References: <bug-216923-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216923

Like Xu (like.xu.linux@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |like.xu.linux@gmail.com

--- Comment #1 from Like Xu (like.xu.linux@gmail.com) ---
The guest PEBS support for Intel SPR are not merged.
20221109082802.27543-1-likexu@tencent.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
