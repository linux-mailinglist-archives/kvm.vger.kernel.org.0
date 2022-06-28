Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458B155D30C
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243617AbiF1CVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 22:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243486AbiF1CU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 22:20:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB761E3F4
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 19:20:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC317B81C0A
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 02:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA37CC385A2
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 02:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382797;
        bh=G3wsdb/i2kk+Fevfj6RAONFM1eCrIsSx0lCzYfdCWOE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nXLpduhTjI6ulH8d8tImrflXFAtlXU9nymt/oaGDgU26wIu9kf10nj7BFVQV9Aw2d
         2I0TRQOW4KqDNtu1XrnxPXLtM11BdPWeJ9qMPkvrnjQsYvwtofYL3c6nazicj1ZbO9
         qRYwJl063Mhzsf8q7rVbMgm4RbVUHK42OHG0GTG8vcDtNkvF21nljLmCIN/vAf013K
         18dQpKPfJdM2iy2/LmxGWRTAC6OYwyTnjLVYAelM3NCabcc1JfgZgfTHc5uvNPkokS
         WlUl+SsCoz069nK+qIZLR3Wus7ybehWQZUh1zPHas/SfT0Fb8PfraW05I/AWdZc6Vy
         dTCJdtiOFStyA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 8C4B4CC13B0; Tue, 28 Jun 2022 02:19:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Tue, 28 Jun 2022 02:19:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216177-28872-vvOF5Q3MU8@https.bugzilla.kernel.org/>
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

--- Comment #7 from Yang Lixiao (lixiao.yang@intel.com) ---
(In reply to Sean Christopherson from comment #6)
> On Tue, Jun 28, 2022, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> >=20
> > --- Comment #5 from Nadav Amit (nadav.amit@gmail.com) ---
> > > On Jun 27, 2022, at 6:19 PM, bugzilla-daemon@kernel.org wrote:
> > >=20
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> > >=20
> > > --- Comment #3 from Yang Lixiao (lixiao.yang@intel.com) ---
> > > (In reply to Nadav Amit from comment #2)
> > >>> On Jun 27, 2022, at 5:28 PM, bugzilla-daemon@kernel.org wrote:
> > >>>=20
> > >>> https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> > >>>=20
> > >>> Sean Christopherson (seanjc@google.com) changed:
> > >>>=20
> > >>>          What    |Removed                     |Added
> > >>>=20
> > >>
> >
> -------------------------------------------------------------------------=
---
> > >>>                CC|                            |seanjc@google.com
> > >>>=20
> > >>> --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> > >>> It's vmx_preemption_timer_expiry_test, which is known to be flaky
> (though
> > >>> IIRC
> > >>> it's KVM that's at fault).
> > >>>=20
> > >>> Test suite: vmx_preemption_timer_expiry_test
> > >>> FAIL: Last stored guest TSC (28067103426) < TSC deadline (280670860=
48)
> > >>=20
> > >> For the record:
> > >>=20
> > >>
> > https://lore.kernel.org/kvm/D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.=
com/
> > >=20
> > > Thanks for your reply. So this is a KVM bug, and you have sent a patc=
h to
> > kvm
> > > to fix this bug, right?
> >=20
> > As I noted, at some point I did not manage to reproduce the failure.
> >=20
> > The failure on bare-metal that I experienced hints that this is either a
> test
> > bug or (much less likely) a hardware bug. But I do not think it is like=
ly
> to
> > be
> > a KVM bug.
>=20
> Oooh, your failure was on bare-metal.  I didn't grok that.  Though it cou=
ld
> be
> both a hardware bug and a KVM bug :-)

In my tests, I tested kvm-unit-tests vmx on bare-metal (not on VM) and this=
 bug
happened on two different Ice Lake machines and one Cooper Lake machine.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
