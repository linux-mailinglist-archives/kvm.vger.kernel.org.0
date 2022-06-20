Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC93B551137
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 09:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbiFTHQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 03:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239132AbiFTHQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 03:16:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E88E0B5
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 00:16:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A76A3CE0F6D
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 07:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E43CEC341C6
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 07:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655709368;
        bh=7daJo55JFxG764GbFNJtFGJaw5ecIB/KarX6jEK1LKE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tOBZFxK/kdZP+dO6AlKO1FolC88MQOm05YmawCZ1/CpEWNhBbBHBagJ/MgpvHs3Ef
         sCtojYcz8ZvHEZXiHm32jBLvHo5y0yVZZcKFD7DM7apyn4NlEIMF8Q8yT15hqO+dsf
         FhITLO9oQiVwZ+g8vYiwFONLrIZNz5OU/W/ybKdhkenh+SwxusKKwUOMZRfxqMhIGr
         /hmIG6AiNcoQ4HV/FKybfJqiynS3jtVEwqNFb7BYI1Xg1L2ABSwvaLue7i6cyUK9Q0
         q2p/Nv/vYSUp5PV3e38WIYCtNVdAWD6nLYsRr8N5mLAfulsdDiP/36X4GpkjgIYCxd
         UNBxNfCJR51NA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CF7C1CC13B4; Mon, 20 Jun 2022 07:16:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 20 Jun 2022 07:16:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: alexander.warth@mailbox.org
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-kAIT1vwH30@https.bugzilla.kernel.org/>
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

--- Comment #29 from Alexander Warth (alexander.warth@mailbox.org) ---
(In reply to Artem S. Tashkinov from comment #24)
> (In reply to Robert Dinse from comment #22)
> > Tried to compile 5.18.5, STILL BROKEN.  Same Error.
>=20
> Developers are well aware, there's no need to report the same issues over
> and over again, if anything you're making them less willing to resolve th=
ese
> issues sooner rather than later.

Its less about Devs also about reporting to people having this bug. Thats a=
lso
the reason why I have posted it and I'm glad Robert did inform me. It might
annoy the devs. But it helps the community on the web searching for the same
bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
