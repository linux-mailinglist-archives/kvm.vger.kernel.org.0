Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF79A55C790
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242811AbiF1BTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 21:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbiF1BTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 21:19:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9768E1CFE0
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 18:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53B70B819B6
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16F17C341CC
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 01:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656379169;
        bh=vbTv7VOboZulV0qqsMN7mE1PeQ92rn8fE5126HENNUo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WYca7Yt3CN1rJ2/CsokbzzkPyww9K2tQNgjJs6b0t5eEVoV543URc67UPOfWyy3rW
         E2IyWaDm4chM6ugdT1wQ8dJ+6mLbe4sjU+pqihI+XRtW5uEGN1rD5qJTM8OrqJk+VG
         c8dyjcakSm3KHgyQONpi9coeWk5wbNz8jduN57xFUpkSrSBEK5/en3todxj9KBt6SQ
         a3cGqeOHX8MW2sNUvqhbQIJoiTU6XQmJhG+A9o2RiSyPiZ2QbZsUB8ZtgfOo07aBhh
         Er32BC4+czXV0xSgGVAzrPkofq7bXSGbcFJA6Yzn2YB5iSDtZKdLiF0yWzacXolMep
         kK1FdrGmo1YUQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0275FCC13B0; Tue, 28 Jun 2022 01:19:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Tue, 28 Jun 2022 01:19:28 +0000
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
Message-ID: <bug-216177-28872-0HfdJRGX5a@https.bugzilla.kernel.org/>
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

--- Comment #3 from Yang Lixiao (lixiao.yang@intel.com) ---
(In reply to Nadav Amit from comment #2)
> > On Jun 27, 2022, at 5:28 PM, bugzilla-daemon@kernel.org wrote:
> >=20
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> >=20
> > Sean Christopherson (seanjc@google.com) changed:
> >=20
> >           What    |Removed                     |Added
> >
> -------------------------------------------------------------------------=
---
> >                 CC|                            |seanjc@google.com
> >=20
> > --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
> > It's vmx_preemption_timer_expiry_test, which is known to be flaky (thou=
gh
> > IIRC
> > it's KVM that's at fault).
> >=20
> > Test suite: vmx_preemption_timer_expiry_test
> > FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)
>=20
> For the record:
>=20
> https://lore.kernel.org/kvm/D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.co=
m/

Thanks for your reply. So this is a KVM bug, and you have sent a patch to k=
vm
to fix this bug, right?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
