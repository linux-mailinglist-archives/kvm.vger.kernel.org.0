Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B93255F361
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 04:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiF2Cc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 22:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiF2Ccz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 22:32:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BDF248EF
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 19:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EFFDB8215B
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 02:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2D8CC341CD
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 02:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656469972;
        bh=VTLyq24LxAbfqltlOrYNIlAkmL9fQGIUjM5oareNRbE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JnLiKgMkYKFnpb8d9LR/9ALsrh5croJ83vnnfmLGBV78lY6d0/RQ0lxIys6RkrWQF
         oQ0U5429mCPwCoQa8Q+G34A/iCiMWKsvcXCTIgim1hMWriqPfV6dzZVB7cvjdxb0QI
         HXrMGbNHyugUZa1f9zcdlQn4fMurCX+koD1RcdpG6JEgqFxr3tlE7k/keUbGY0qlYS
         nxWD2E3+huMCjwyFK6lR7j49bkpsPMUoCDPLwUfcvixyc3ZuNzKt89u00cWwgNAmkM
         2mDaTzhe/zcbr5zC8Uu5lweK0J+9rQnUf4m+dvEMYvdWpIVvBtDIVJ4n4s2XWIhnPI
         aLBxbdmwZuFSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id DCB0AC05FD6; Wed, 29 Jun 2022 02:32:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
Date:   Wed, 29 Jun 2022 02:32:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jmattson@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216177-28872-tq9sqA8ljr@https.bugzilla.kernel.org/>
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

--- Comment #12 from Jim Mattson (jmattson@google.com) ---
On Tue, Jun 28, 2022 at 5:22 PM <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
>
> --- Comment #11 from Yang Lixiao (lixiao.yang@intel.com) ---
> (In reply to Jim Mattson from comment #10)
> > On Mon, Jun 27, 2022 at 11:32 PM <bugzilla-daemon@kernel.org> wrote:
> > >
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
> > >
> > > --- Comment #9 from Yang Lixiao (lixiao.yang@intel.com) ---
> > > (In reply to Jim Mattson from comment #8)
> > > > On Mon, Jun 27, 2022 at 8:54 PM Nadav Amit <nadav.amit@gmail.com>
> wrote:
> > > >
> > > > > The failure on bare-metal that I experienced hints that this is
> either
> > a
> > > > test
> > > > > bug or (much less likely) a hardware bug. But I do not think it is
> > likely
> > > > to
> > > > > be
> > > > > a KVM bug.
> > > >
> > > > KVM does not use the VMX-preemption timer to virtualize L1's
> > > > VMX-preemption timer (and that is why KVM is broken). The KVM bug w=
as
> > > > introduced with commit f4124500c2c1 ("KVM: nVMX: Fully emulate
> > > > preemption timer"), which uses an L0 CLOCK_MONOTONIC hrtimer to
> > > > emulate L1's VMX-preemption timer. There are many reasons that this
> > > > cannot possibly work, not the least of which is that the
> > > > CLOCK_MONOTONIC timer is subject to time slew.
> > > >
> > > > Currently, KVM reserves L0's VMX-preemption timer for emulating L1's
> > > > APIC timer. Better would be to determine whether L1's APIC timer or
> > > > L1's VMX-preemption timer is scheduled to fire first, and use L0's
> > > > VMX-preemption timer to trigger a VM-exit on the nearest alarm.
> > > > Alternatively, as Sean noted, one could perhaps arrange for the
> > > > hrtimer to fire early enough that it won't fire late, but I don't
> > > > really think that's a viable solution.
> > > >
> > > > I can't explain the bare-metal failures, but I will note that the t=
est
> > > > assumes the default treatment of SMIs and SMM. The test will likely
> > > > fail with the dual-monitor treatment of SMIs and SMM. Aside from the
> > > > older CPUs with broken VMX-preemption timers, I don't know of any
> > > > relevant errata.
> > > >
> > > > Of course, it is possible that the test itself is buggy. For the
> > > > person who reported bare-metal failures on Ice Lake and Cooper Lake,
> > > > how long was the test in VMX non-root mode past the VMX-preemption
> > > > timer deadline?
> > >
> > > On the first Ice lake:
> > > Test suite: vmx_preemption_timer_expiry_test
> > > FAIL: Last stored guest TSC (28067103426) < TSC deadline (28067086048)
> > >
> > > On the second Ice lake:
> > > Test suite: vmx_preemption_timer_expiry_test
> > > FAIL: Last stored guest TSC (27014488614) < TSC deadline (27014469152)
> > >
> > > On Cooper lake:
> > > Test suite: vmx_preemption_timer_expiry_test
> > > FAIL: Last stored guest TSC (29030585690) < TSC deadline (29030565024)
> >
> > Wow! Those are *huge* overruns. What is the value of MSR 0x9B on these
> hosts?
>
> All of the values of MSR 0x9B on the three hosts are 0.
>
> --
> You may reply to this email to add a comment.
>
> You are receiving this mail because:
> You are watching the assignee of the bug.
Doh! There is a glaring bug in the test. I'll post a fix soon.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
