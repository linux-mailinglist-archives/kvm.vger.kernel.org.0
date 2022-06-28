Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B19D55D9FE
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243232AbiF1Bsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 21:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241505AbiF1Bs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 21:48:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB47B12
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 18:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7724FB81B97
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FE4BC341CB
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656380905;
        bh=q4WSnpE75mB6Gg9qy7EXV+Gdy5TB2lhhfIluFUkUod4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Bgmt7SiKDwed5fxl6RcNEN2CUtoMrocrPFq4uvJ3JKknxSU9BMXjevbO626dxzIug
         RM1++jeuf7LImla0DrtnsVGAB4ZFMmOZHQ2g7RxUHjrha/weLhE/bo2YEZy4UVYx4w
         dHHmKYfPD77m2JxHJWhNz0fFRh99+R9Eblfn1g1TS2PYMgqKO+VrRoRyIUKyne0Yi5
         YoKwlQVzRauyFuvY1caqEUrGERNsUcBB44dQtmeBDYr6WAxaIcZ4mSWpBI/YxKlhX7
         SNZOVgbYCryo6ts0emFUfRpASAOb26p1+zuaRAf6gAR5GlDxJP12ByzbTaCyqKYneD
         630LMHavT+GHA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2352ECC13B1; Tue, 28 Jun 2022 01:48:25 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Tue, 28 Jun 2022 01:48:24 +0000
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
Message-ID: <bug-216177-28872-1qS31m0r8O@https.bugzilla.kernel.org/>
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

--- Comment #6 from Sean Christopherson (seanjc@google.com) ---
On Tue, Jun 28, 2022, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
>=20
> --- Comment #5 from Nadav Amit (nadav.amit@gmail.com) ---
> > On Jun 27, 2022, at 6:19 PM, bugzilla-daemon@kernel.org wrote:
> >=20
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> >=20
> > --- Comment #3 from Yang Lixiao (lixiao.yang@intel.com) ---
> > (In reply to Nadav Amit from comment #2)
> >>> On Jun 27, 2022, at 5:28 PM, bugzilla-daemon@kernel.org wrote:
> >>>=20
> >>> https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> >>>=20
> >>> Sean Christopherson (seanjc@google.com) changed:
> >>>=20
> >>>          What    |Removed                     |Added
> >>>=20
> >>
> -------------------------------------------------------------------------=
---
> >>>                CC|                            |seanjc@google.com
> >>>=20
> >>> --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> >>> It's vmx_preemption_timer_expiry_test, which is known to be flaky (th=
ough
> >>> IIRC
> >>> it's KVM that's at fault).
> >>>=20
> >>> Test suite: vmx_preemption_timer_expiry_test
> >>> FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)
> >>=20
> >> For the record:
> >>=20
> >>
> https://lore.kernel.org/kvm/D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.co=
m/
> >=20
> > Thanks for your reply. So this is a KVM bug, and you have sent a patch =
to
> kvm
> > to fix this bug, right?
>=20
> As I noted, at some point I did not manage to reproduce the failure.
>=20
> The failure on bare-metal that I experienced hints that this is either a =
test
> bug or (much less likely) a hardware bug. But I do not think it is likely=
 to
> be
> a KVM bug.

Oooh, your failure was on bare-metal.  I didn't grok that.  Though it could=
 be
both a hardware bug and a KVM bug :-)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
