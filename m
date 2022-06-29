Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7210255F37F
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 04:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiF2CuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 22:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiF2CuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 22:50:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5510621E3B
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 19:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11CB2B8216A
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 02:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1BA4C341CD
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 02:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656471003;
        bh=Kx9rxwNP2SGIbcsSG1cd0JkbtMCTAsNfGTI7wRyrYe0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cZT39Aofi0mLISpHckkTqnYXbUZ1FK4InBoiRRcSAgXPPvivkHVOtEZ+l6UiedfKi
         hMDZnHl41fvI0dHqUXIEkfPezKBRVfBkXNflQiKmyaPeBObxanbeNpgm8Fx0z33aDD
         ZBkPKCIdfLOWbr2e+7C9RsppPBRRCOxDCZtz2gz7vRk8OPfXCTPv7Skxe7bxcLDMuY
         YbyoJGK03fJSg7NXvB4BEzY847ZiH6scOCMU5USo2h8hQGQ3++tJcAbaO9gf0Y86Dc
         pTuNKasVWawtQw8Gx1Y70GgN63ODvw19s0JChvRJIfvDw+eyWhRgRSQMvMzZ1n+2pK
         oIY6mfuHC8UGQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9A8A6C05FD5; Wed, 29 Jun 2022 02:50:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Wed, 29 Jun 2022 02:50:03 +0000
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
Message-ID: <bug-216177-28872-Zn7nnOAAFq@https.bugzilla.kernel.org/>
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

--- Comment #13 from Yang Lixiao (lixiao.yang@intel.com) ---
(In reply to Jim Mattson from comment #12)
> On Tue, Jun 28, 2022 at 5:22 PM <bugzilla-daemon@kernel.org> wrote:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> >
> > --- Comment #11 from Yang Lixiao (lixiao.yang@intel.com) ---
> > (In reply to Jim Mattson from comment #10)
> > > On Mon, Jun 27, 2022 at 11:32 PM <bugzilla-daemon@kernel.org> wrote:
> > > >
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> > > >
> > > > --- Comment #9 from Yang Lixiao (lixiao.yang@intel.com) ---
> > > > (In reply to Jim Mattson from comment #8)
> > > > > On Mon, Jun 27, 2022 at 8:54 PM Nadav Amit <nadav.amit@gmail.com>
> > wrote:
> > > > >
> > > > > > The failure on bare-metal that I experienced hints that this is
> > either
> > > a
> > > > > test
> > > > > > bug or (much less likely) a hardware bug. But I do not think it=
 is
> > > likely
> > > > > to
> > > > > > be
> > > > > > a KVM bug.
> > > > >
> > > > > KVM does not use the VMX-preemption timer to virtualize L1's
> > > > > VMX-preemption timer (and that is why KVM is broken). The KVM bug=
 was
> > > > > introduced with commit f4124500c2c1 ("KVM: nVMX: Fully emulate
> > > > > preemption timer"), which uses an L0 CLOCK_MONOTONIC hrtimer to
> > > > > emulate L1's VMX-preemption timer. There are many reasons that th=
is
> > > > > cannot possibly work, not the least of which is that the
> > > > > CLOCK_MONOTONIC timer is subject to time slew.
> > > > >
> > > > > Currently, KVM reserves L0's VMX-preemption timer for emulating L=
1's
> > > > > APIC timer. Better would be to determine whether L1's APIC timer =
or
> > > > > L1's VMX-preemption timer is scheduled to fire first, and use L0's
> > > > > VMX-preemption timer to trigger a VM-exit on the nearest alarm.
> > > > > Alternatively, as Sean noted, one could perhaps arrange for the
> > > > > hrtimer to fire early enough that it won't fire late, but I don't
> > > > > really think that's a viable solution.
> > > > >
> > > > > I can't explain the bare-metal failures, but I will note that the
> test
> > > > > assumes the default treatment of SMIs and SMM. The test will like=
ly
> > > > > fail with the dual-monitor treatment of SMIs and SMM. Aside from =
the
> > > > > older CPUs with broken VMX-preemption timers, I don't know of any
> > > > > relevant errata.
> > > > >
> > > > > Of course, it is possible that the test itself is buggy. For the
> > > > > person who reported bare-metal failures on Ice Lake and Cooper La=
ke,
> > > > > how long was the test in VMX non-root mode past the VMX-preemption
> > > > > timer deadline?
> > > >
> > > > On the first Ice lake:
> > > > Test suite: vmx_preemption_timer_expiry_test
> > > > FAIL: Last stored guest TSC (28067103426) < TSC deadline (280670860=
48)
> > > >
> > > > On the second Ice lake:
> > > > Test suite: vmx_preemption_timer_expiry_test
> > > > FAIL: Last stored guest TSC (27014488614) < TSC deadline (270144691=
52)
> > > >
> > > > On Cooper lake:
> > > > Test suite: vmx_preemption_timer_expiry_test
> > > > FAIL: Last stored guest TSC (29030585690) < TSC deadline (290305650=
24)
> > >
> > > Wow! Those are *huge* overruns. What is the value of MSR 0x9B on these
> > hosts?
> >
> > All of the values of MSR 0x9B on the three hosts are 0.
> >
> > --
> > You may reply to this email to add a comment.
> >
> > You are receiving this mail because:
> > You are watching the assignee of the bug.
> Doh! There is a glaring bug in the test. I'll post a fix soon.

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
