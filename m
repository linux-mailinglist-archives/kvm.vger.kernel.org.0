Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A6A538F2A
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 12:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343533AbiEaKnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 06:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239301AbiEaKm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 06:42:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44D622BD8
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 03:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A5BB6102A
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C7EEC3411F
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653993777;
        bh=sBJgGv9Ld0YncRvoPmXeYUiej9QD26r827s8cdrjp40=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=s+if4DIAzWTGOnPnJBcrvRHbHfSPrJnYNIAyHjXBt+Wf9cqKpCs+YMs/3Cjun4xcO
         5lMuFqeccz/JMEtITx0aBOiUwBcFPJb3583yTeO+tl+mOjFUG4L/Xy7p5O2QYdoz+7
         phDWUvAL129TX/iKrLnIU+PGufwPA5MbaPQBMg3DZOkUlouioYyA8bEFZnJIaBa2uk
         god7J6opl5mQMPCCENskxtznGpR1nulLRWbbgFQk6MHEbUN5rF04knEQe5z+i6QF87
         Xap959mvc+IJ692fqgWQStq4L9wYRlqeKHORHzopA/XUddmL8+Pa3jnVScgbJzqwW8
         hU6c/lQzrkHJw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5E993CC13B4; Tue, 31 May 2022 10:42:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Tue, 31 May 2022 10:42:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alexander.warth@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-h1yK5lS8oT@https.bugzilla.kernel.org/>
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

--- Comment #11 from Alexander Warth (alexander.warth@mailbox.org) ---
Thx for replying. We already have 5.18.1 and AFAIK there is no patch fort t=
his.
The build error appears for 5.18.1 too.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
