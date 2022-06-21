Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927E2552A90
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 07:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344283AbiFUFqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 01:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiFUFqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 01:46:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6302121E2B
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 22:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E53D260AE7
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 05:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D9AAC341C6
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 05:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655790363;
        bh=kL+0seSPRswvV65JKIlLiuiWUsZ0Y1IGpZrxv7XpxiM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XGnZcsQUiD0yN/HAVzm2cTzole4AEU0Hacsj3wnN/RE8giorgmhDK4CqfO8mnQ0ap
         klvB5qGWPnVoNdq9yK+zfunjgiFwruDBsL2c5NRxDdzwsgOzdV7lb/cCew1tKux5+a
         fioCPkn6V9mcYEeR3UbZpN6oOIO4RJORtiMl66c0KEVPMCxuX+ER+pWG31jorW73QP
         JpSU6nXFsvGSrqufSD4fV87RpHFiHuydmUk3qevFTmfug9mEFASij1jpWGh0YXY9gD
         vy8BsyU472PjziuIwNNw2+8osgdspGvP6kO2KswZCdKeMtl3/y2/DRmbsKgbluTkPM
         gl4tgOJyYJqeA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3CBD3CAC6E2; Tue, 21 Jun 2022 05:46:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216026] Fails to compile using gcc 12.1 under Ubuntu 22.04
Date:   Tue, 21 Jun 2022 05:46:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nanook@eskimo.com
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216026-28872-erFiTXe83h@https.bugzilla.kernel.org/>
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

--- Comment #34 from Robert Dinse (nanook@eskimo.com) ---
I'm all for honesty, not so much for brutality, but I do realize that many
people who work with computers choose to do so because they're not so good =
with
humans.

That said, your position would be appropriate if Linux were still Linus's h=
obby
project.

The reality is that much of the real world computation depends upon it, the
vast majority of super computers run Linux, Android phones run Linux, most =
of
Googles, Amazons, and even Microsoft's services run Linux, so it has grown
beyond hobby status.  Self driving cars depend upon it, etc.  In short, it =
is
critical to the technological world and technology is critical to 8 billion
people surviving on this ball we call Earth.  So this requires a bit more
professionalism than a hobby project.

Isn't my intent to spam a mailing list, it is my intent to make the develop=
ers
aware of a SERIOUS bug, and when a kernel can't be compiled with the most
recent versions of EITHER compiler chains, that is serious, especially when
you've End-of-Life'd the previous version which means they are not getting
security fixes.

I've been involved in some development projects myself, back in the days of
8-bit computers I even wrote a very specialized programming language, but I=
've
never worked with a team of more than half a dozen individuals, so I can't =
even
imagine what it is like for Linus to coordinate several thousand developers.

That said, personality issues don't help, best to stick with technical issu=
es,
tackle them and move on.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
