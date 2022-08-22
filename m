Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3675C59B89D
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 07:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiHVFBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 01:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiHVFBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 01:01:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A6F24F2F
        for <kvm@vger.kernel.org>; Sun, 21 Aug 2022 22:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B70AFB80E7B
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 05:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 385C7C433B5
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 05:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661144491;
        bh=1PKZrMPeRrDHRC8zlEYpFLEf5i0ADe667pAdlmwmU88=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LBxX1nceVtv5Nagc3hDOy96qplSXr+PTSgbjVfBY1AtJB6IXTlnQOXwuUlOMbKic+
         9lKNwe01soA1Inr9/QWZpShZ7f20NsBZEVsyTyPBmwvTwCd3hFo+eo+N0jFr3PxrKD
         6j5kEWT8fTGL/DB0/QpKvFgj0c7onSFHuU5W+r2Y9BUL238dIyPLdJjOHSec54EBUa
         2+FgHbHlWSxKyYVazAzU4P8TqO8f9RnscJMzhe1QtA5oe67J8WvwmdhDYSgPUBR4TK
         i52WyrNHXaLc2wiBFv99gXlhaEpBV/dEn8fDDxG3COoMtakDyyYS5AkBGFzjNv8qOu
         FB9vMEyyONhfw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 21905C433EA; Mon, 22 Aug 2022 05:01:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panics in VMs running on an Intel N5105 on
 Proxmox
Date:   Mon, 22 Aug 2022 05:01:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jdpark.au@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: short_desc
Message-ID: <bug-216349-28872-pATPHClXwr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

John Park (jdpark.au@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Kernel panic in a Ubuntu VM |Kernel panics in VMs
                   |running on Proxmox          |running on an Intel N5105
                   |                            |on Proxmox

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
