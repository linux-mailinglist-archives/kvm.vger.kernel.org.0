Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633EE55D202
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiF0OVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 10:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbiF0OVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 10:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B6D12D18
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 07:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90A36614B2
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 14:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0954C36AE5
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656339678;
        bh=6HTMbiqXJDXyc3Sj94d8xj1JmGUfMA47Nw/XEZvjaWY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Guj8i8JXUNKReQUxC/DueuinQuWBjeVhWL27H6izHGo7eazGZ7LcywNy05P7TjWuJ
         vJL2d4PTg00wm3RgpSx7iacPXIt250FFf+Aohxh8jESMa5HqDbhBoq2MNEe8RT5yhR
         /w+jijMWF67OyLM9h+MeFZtzvjNlP7o1Tq7dx2vMSVyQ7UPM20wPXS6wUlkHTW0ktU
         sf3Kab6G0k0/ScFfmxJefmfQkUgLuhND3gkJigJImXjIvOz6vQ3PkJnDfnfzokhP6h
         Cor3HIXPD3azNeZRcYNjo65n3dZ1Il7m0y7ftdiVenCuQVI7crjybNZdy40fyxvGuK
         NfclEzHnhROVQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D9FAFCC13B5; Mon, 27 Jun 2022 14:21:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 27 Jun 2022 14:21:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-e01NFUlPub@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216026-28872@https.bugzilla.kernel.org/>
References: <bug-216026-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216026

--- Comment #42 from Sean Christopherson (seanjc@google.com) ---
Please open a new bug, there is essentially zero chance this is related to =
the
issues you are seeing.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
