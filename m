Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84060551DBC
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbiFTOYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350456AbiFTOXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:23:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C0F1F2FE
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4204B614B5
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 13:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7E1EC341C5
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655732392;
        bh=T0UDOm72gY7beOjxt3rxkHBboQpmK/MbrQPaf2l54BA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bN6HGAIV/iJhdkJFPwLfr0u/oLjrTujuG9N0qRCikBylzlWQZjPJwJ9yl1UzJiiaf
         oF3LxnVcNrzruw0XxXHPLP43l68HsOOmDvgyb3CunYheIWI63afMUCYfwsDmqbzg3R
         dCdL7/Asfcfx0AsSeHwVXps94ymzE/Urdk38eCDeSzd5mA+ubxQ7B+3gyIIZ8mhOTS
         sUHhqfoYI8rxzQttUy78RSy6cVKvd2LyD4fKFLLqM+6YB9ert6hU1/go0XLQtiyIaN
         a/6DNa/f54D4vvh7At1VaNrEpaOZu9hPOl7P9oh05sQfXVxfuTJ1eIoinganc92/si
         vPsgChoVminKw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 92FD3CC13B5; Mon, 20 Jun 2022 13:39:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Mon, 20 Jun 2022 13:39:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: ANSWERED
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216026-28872-fixNQkYHiC@https.bugzilla.kernel.org/>
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

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |ANSWERED

--- Comment #30 from Artem S. Tashkinov (aros@gmx.com) ---
1. End users are not meant to compile the kernel. You have a distro kernel =
for
that.
2. If you are willing to compile the kernel you must have the means and
experience to resolve issues.
3. The status of the bug doesn't affect how fast it's gonna get resolved or
whether Google finds it.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
