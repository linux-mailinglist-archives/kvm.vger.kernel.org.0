Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17114530CBC
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiEWJFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiEWJFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F111044A2B
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:05:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EEB560F7F
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF76EC34116
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653296747;
        bh=m0yQ6F7wSXYOIXNqBPRanSONOT17U8M9CLKp+JSvAhM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=V4Z+TrhyJCj1g6UQw8aoEF6fI/HF50tLv7kszLR/RxvdOLHwiHEGm8bTBBzQ0M95U
         JdMOng+efMuEH542SL2VPU4f2LAtgXhMH2bC4gSAroHY/QH2Pt4W0wTo14eeST7Aep
         c189lAP1BIfHNMnuBEpRTikwiynpTqC6IKVZWinSI1tn1dcsVFdnsSs6NIKIYsWefG
         5nElAuw/h83hx5AQ5i+wnK9V6uMOn5GeFswmD73PsU7EmeIxL9uCnUL7hIaozyF8Qs
         1EaNINqA+dhsktzB6GYYHnzMTsd66xHR8WkcsrzLWPfVAO0I14hVyTNy8Y7XM4MaLv
         lwfCEbMLvBREA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D4F08CC13B4; Mon, 23 May 2022 09:05:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216017] KVM: problem virtualization from kernel 5.17.9
Date:   Mon, 23 May 2022 09:05:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: opw
X-Bugzilla-Severity: high
X-Bugzilla-Who: nutodafozo@freeweb.email
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216017-28872-yfy0PCpVqG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216017-28872@https.bugzilla.kernel.org/>
References: <bug-216017-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216017

nutodafozo@freeweb.email changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nutodafozo@freeweb.email

--- Comment #1 from nutodafozo@freeweb.email ---
KVM: x86: nSVM: disallow userspace setting of MSR_AMD64_TSC_RATIO to non
default value when tsc scaling disabled

might have to do something with this commit

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
