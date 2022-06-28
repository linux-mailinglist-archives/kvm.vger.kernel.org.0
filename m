Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0AA955C68D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242561AbiF1Ahu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 20:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241838AbiF1Ahk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 20:37:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B0013D21
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 17:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 395F26167F
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 00:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 894B9C341CB
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 00:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656376658;
        bh=gxljIcSe8pPlqca3AJXaTO3ycWa1tjokMcqpG54Ir18=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LzEHN/SkH0RpN7MYeDboXZ6lQVQ56DSiQnDxn5jAiClpcx+7xVrDP9YjgxGCOWV3s
         Z3E5q6y2SjYfRXQ/SajEkZcM5UpJ1hySGh5ZeV46+DZAynKbktyRQBHdslbMJ7cIyB
         owjZFEPZiTDkdmRIf3C6rPpt+K4Buskat81mrUoqR3Nz0Ao4lA/jmX74z/g3HgvSTg
         dU3lHDkQZSsQ20yUJbSLpsltNIDTQLrBV8Z+LXHb0laACNI8QDv7/h11icY/UlL+cI
         /gpGw0+hXZBIUWy7lqI1MyYWfNFkV419VojG/7tiJ+ACJ/fwgt1gaHfKvwUmz9uRJJ
         KFdAfXTDf3Djg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 651E2CC13B1; Tue, 28 Jun 2022 00:37:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Tue, 28 Jun 2022 00:37:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: nadav.amit@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216177-28872-0YxWIFzQZY@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216177-28872@https.bugzilla.kernel.org/>
References: <bug-216177-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216177

--- Comment #2 from Nadav Amit (nadav.amit@gmail.com) ---
> On Jun 27, 2022, at 5:28 PM, bugzilla-daemon@kernel.org wrote:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
>=20
> Sean Christopherson (seanjc@google.com) changed:
>=20
>           What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                 CC|                            |seanjc@google.com
>=20
> --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> It's vmx_preemption_timer_expiry_test, which is known to be flaky (though
> IIRC
> it's KVM that's at fault).
>=20
> Test suite: vmx_preemption_timer_expiry_test
> FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)

For the record:

https://lore.kernel.org/kvm/D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
