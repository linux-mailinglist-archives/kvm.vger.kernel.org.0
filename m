Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EE36C3685
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 17:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjCUQEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 12:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjCUQEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 12:04:01 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D49D5BA5
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 09:03:42 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5425c04765dso157205227b3.0
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 09:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679414621;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pYjBsqxFlPfy2OkA5/SypyMm9iSN5hAhbwnPSGTheM8=;
        b=HD6LQWQQ3npuI9b9d5JwrPqwrR8NKrSMARKY8/koMg2raq8m7qzqe7UjSg3qhe8DE2
         mcexmTG97/w7oDWXgur6AowTCzS65phvGXvJPEs60xGLaISQ+A9mGt1pSsu3brRZxlxC
         CoW3SfZc9eJYjcu05QCs614mdiYlyUIRoO/nQO8+WDtTkkvKOE+ZO/oIwMgXC87Pot/D
         RF9DuUNp1RyRhYGWgPLWYFIK6rhXySrOH7trltbc++4sYhfa6zKzpOEfiG+kdWMFPjPb
         dOkb/IEHU4Fm0qLO9snuCsTVZSS/tjiudFw3AI4mKYNR23Uqk67OXG+Vxgkn9Xvj0ahh
         5yxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679414621;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pYjBsqxFlPfy2OkA5/SypyMm9iSN5hAhbwnPSGTheM8=;
        b=RTyZINEAuZd4ARtjuR14Xi+7hqV2f/PBh+duV7pl3QaGSVjwe91NHz/q4pVN0NVQnt
         fabsReLP4UDuCSfeVAW/Pxa28fccOTteDm6gYoCpnqonWEcxdpZoTZvWQHQrls67fVRZ
         85q1E+QoSOQDWF7jn+fTjPKfEspjhjYKvdCciMqtuI2W76s5ADsQh75JHBvP8kaHTkyM
         8EBpzl3oMqlIJEIvWU2fcAOhkB84vgiQDGsCEWWLXGkj/DqTmTY/bSkkmbcyFDdrGixy
         mVoESzmp7/qwLuqrdf8k6d+Hx8aHHCUi0ihCOxLO32smsSoeM9yeDuEYtbLSBT8Yn+x0
         CLKQ==
X-Gm-Message-State: AAQBX9flYV0woIJpxmGrHRiCjtqUDQWUjySzmMcLOvxYbC5yju3STVS4
        hG5XQtGELVfjC5NO94M/7IXVqNZMAvo=
X-Google-Smtp-Source: AKy350ZQHy5lgSNEZQp18mSV+zlCqOMga2M5b6/q+MXgH5L2PwQSLnI6G6dmqo9OA2C1dpLzbYhj+cjGhoU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:703:b0:b6a:3632:12fd with SMTP id
 k3-20020a056902070300b00b6a363212fdmr1876420ybt.2.1679414621681; Tue, 21 Mar
 2023 09:03:41 -0700 (PDT)
Date:   Tue, 21 Mar 2023 09:03:40 -0700
In-Reply-To: <4ff37ff4-b89e-8683-f6ea-865211ae01d2@linux.intel.com>
Mime-Version: 1.0
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-3-robert.hu@linux.intel.com> <ZABPFII40v1nQ2EV@gao-cwp>
 <9db9bd3a2ade8c436a8b9ab6f61ee8dafa2e072a.camel@linux.intel.com>
 <ZAuRec2NkC3+4jvD@google.com> <75f628e3-9621-ac9e-a258-33efc7ce56af@linux.intel.com>
 <4ff37ff4-b89e-8683-f6ea-865211ae01d2@linux.intel.com>
Message-ID: <ZBnVXGE45GjmwLDw@google.com>
Subject: Re: [PATCH v5 2/5] [Trivial]KVM: x86: Explicitly cast ulong to bool
 in kvm_set_cr3()
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Chao Gao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023, Binbin Wu wrote:
>=20
> On 3/20/2023 8:05 PM, Binbin Wu wrote:
> >=20
> > On 3/11/2023 4:22 AM, Sean Christopherson wrote:
> > > As Chao pointed out, this does not belong in the LAM series.=EF=BF=BD=
 And
> > > FWIW, I highly
> > > recommend NOT tagging things as Trivial.=EF=BF=BD If you're wrong and=
 the
> > > patch _isn't_
> > > trivial, it only slows things down.=EF=BF=BD And if you're right, the=
n
> > > expediting the
> > > patch can't possibly be necessary.
> > >=20
> > > On Fri, Mar 03, 2023, Robert Hoo wrote:
> > > > On Thu, 2023-03-02 at 15:24 +0800, Chao Gao wrote:
> > > > > > -=EF=BF=BD=EF=BF=BD=EF=BF=BD bool pcid_enabled =3D kvm_read_cr4=
_bits(vcpu, X86_CR4_PCIDE);
> > > > > > +=EF=BF=BD=EF=BF=BD=EF=BF=BD bool pcid_enabled =3D !!kvm_read_c=
r4_bits(vcpu, X86_CR4_PCIDE);
> > > > > >=20
> > > > > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDif (pcid_enabled) {
> > > > > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
 skip_tlb_flush =3D cr3 & X86_CR3_PCID_NOFLUSH;
> > > > > pcid_enabled is used only once. You can drop it, i.e.,
> > > > >=20
> > > > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDif (kvm_read_cr4_bits(vcpu, X=
86_CR4_PCIDE)) {
> > > > >=20
> > > > Emm, that's actually another point.
> > > > Though I won't object so, wouldn't this be compiler optimized?
> > > >=20
> > > > And my point was: honor bool type, though in C implemention it's 0 =
and
> > > > !0, it has its own type value: true, false.
> > > > Implicit type casting always isn't good habit.
> > > I don't disagree, but I also don't particularly want to "fix" one
> > > case while
> > > ignoring the many others, e.g. kvm_handle_invpcid() has the exact
> > > same "buggy"
> > > pattern.
> > >=20
> > > I would be supportive of a patch that adds helpers and then converts
> > > all of the
> > > relevant CR0/CR4 checks though...
> >=20
> > Hi Sean, I can cook a patch by your suggesion and sent out the patch
> > seperately.
>=20
> Sean, besides the call of kvm_read_cr0_bits() and kvm_read_cr4_bits(), th=
ere
> are also a lot checks in if statement like
> if ( cr4 & X86_CR4_XXX )
> or
> if ( cr0 & X86_CR0_XXX )
> I suppose these usages are OK, right?

Generally speaking, yes.  Most flows of that nature use a local variable fo=
r very
good reasons.  The only one I would probably convert is this code in
svm_can_emulate_instruction(). =20

	cr4 =3D kvm_read_cr4(vcpu);
	smep =3D cr4 & X86_CR4_SMEP;
	smap =3D cr4 & X86_CR4_SMAP;
