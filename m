Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A60055E22A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243059AbiF1BbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 21:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243056AbiF1BbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 21:31:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4B5766D
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 18:31:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4FB4CE1CDB
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1138C341CC
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656379857;
        bh=J3NyVsXC/wDGW4IERWtgtJjZ93bxWNsSaguvayXWg54=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=doPHAsdefaGiySBO9afzaXAgfRZ2pOXRPM7VsFcnq0zsoQDFbgrWatUCsbk8PaGOd
         x6+4PyWn5Y6m9CXNEcDUufpNGc5+fIN6lyTF4f/dn/+q+lBmP7Fnozy32MY8d2mZJC
         KIbbzTPkFfbF6ncP44wFW4oQ9jBadyB0qMRI1kGL7N17VJWTY68rJb2JLVA0pauXoB
         4ubKLnHf0EKvDWPzRYfIxmQd43w2VpNIhDgx63DJWs0IqlCpFCTtmouTP0yAsriat5
         pajSi6xIm/j4o/S24d4KGVmsBW/TSrWAUOO6ZH9ZjtJxMw2l6vLpab2EiTEfpCHaHP
         mhJuLqZBUfhuQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 86CC3C05FD5; Tue, 28 Jun 2022 01:30:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Tue, 28 Jun 2022 01:30:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216177-28872-b3N2AnMzxI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216177-28872@https.bugzilla.kernel.org/>
References: <bug-216177-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216177

--- Comment #4 from Sean Christopherson (seanjc@google.com) ---
On Tue, Jun 28, 2022, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
>=20
> --- Comment #3 from Yang Lixiao (lixiao.yang@intel.com) ---
> (In reply to Nadav Amit from comment #2)
> > > On Jun 27, 2022, at 5:28 PM, bugzilla-daemon@kernel.org wrote:
> > >=20
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> > >=20
> > > Sean Christopherson (seanjc@google.com) changed:
> > >=20
> > >           What    |Removed                     |Added
> > >
> >
> -------------------------------------------------------------------------=
---
> > >                 CC|                            |seanjc@google.com
> > >=20
> > > --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> > > It's vmx_preemption_timer_expiry_test, which is known to be flaky (th=
ough
> > > IIRC
> > > it's KVM that's at fault).
> > >=20
> > > Test suite: vmx_preemption_timer_expiry_test
> > > FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)
> >=20
> > For the record:
> >=20
> > https://lore.kernel.org/kvm/D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.=
com/
>=20
> Thanks for your reply. So this is a KVM bug, and you have sent a patch to=
 kvm
> to fix this bug, right?

No, AFAIK no one has posted a fix.  If it's the KVM issue I'm thinking of, =
the
fix is non-trivial.  It'd require scheduling a timer in L0 with a deadline
shorter
than what L1 requests when emulating the VMX timer, and then busy waiting i=
n L0
if
the host timer fires early.  KVM already does this for e.g. L1's TSC deadli=
ne
timer.
That code would need to be adapated for the nested VMX preemption timer.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
