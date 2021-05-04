Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D3437324A
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 00:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhEDWZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 18:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbhEDWZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 18:25:13 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702B2C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 15:24:16 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id i8-20020a4aa1080000b0290201edd785e7so57280ool.1
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 15:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G/mynJyVd6OqUtlJeADQl+MoXNb+9GbiDjZ8MMglkq0=;
        b=ZzZ3kUkX93v63Jb3vme8k9OXJxDVZy2d4Qc3VpSVGzi0IxBMOWHLm2TYMxFI0esBWD
         T35MJNUTB1WP34XtEKngIQ25gkZvtXppq/TpEP8vVy20dd0y3yPLwrZ8ky1JpQdp9gBw
         6MdWseZzEbo1Q1OEfHl3kJgQNaUwubelotgMRyfIEmsIJhbb2+6qHUe6sO+YCtfomzcX
         pNN+o/vIUNia2nxYuc59jkTt0wUs32NPVlscVUQzImJsbAIQrRct9CIpwZmx6w9jZZpp
         gKq8XKbXx1EN2kfVUmXfD+qjEzPsVvdUmez2s4W3AkJnSJf+I94xyeyWP9cjWiJObCjA
         REaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/mynJyVd6OqUtlJeADQl+MoXNb+9GbiDjZ8MMglkq0=;
        b=rh6xAe+UkgNjEIqGm5mXik5WzInl7c9/FXMTnl16Tqf/cotajaMwaHFrBkA9ULbo21
         r1qF6GrGFM8yfgV2KCByw7DYbrPSA/3WCN2U4gCHByHuXkPSD26LtbAq+zQRMeeU+ku9
         +rVPbbQC7tQM3g1clU5e6VuW1xKQOix4JfqxMPYU4QjEq3d4Pk7XRIsWF5gX77CuzZhW
         dntr+8SkhB3NMMwKFByps9Z5nJgNdfuy5OjFC0dNxoZn3yd4ooYyRykeBZacfqt4d8ik
         Bpwgf32TpjQgEU5bJmXIRL9R1DZsbkchdfF5zzRhwP6EVSflJKH+G0T/I1ibiA9O3w+V
         I+ig==
X-Gm-Message-State: AOAM5316ToHMPpZuEzoniqAmVsckde7SEmV0EdARmDmHTTCVq9nApZq6
        d+QFM+qnv54PSudC85bNXe2FgzbDKMnj2JvNA5LCJA==
X-Google-Smtp-Source: ABdhPJxo1sYC258Xmtlr84Guf3FGfzlmaAS4Bfv2FWjEz/7XUJt0x/Hw0EWXImD8YubRD/UmQPLLXeL5grngKF8MWhs=
X-Received: by 2002:a4a:ea94:: with SMTP id r20mr7794217ooh.81.1620167055541;
 Tue, 04 May 2021 15:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-4-seanjc@google.com>
 <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
 <YJHCadSIQ/cK/RAw@google.com> <CALMp9eSeeuXUXz+0J17b7Dk8pyy3XPgqUXKC5-V8Q7SRd7ykgA@mail.gmail.com>
 <YJHGQgEE3mqUhbAc@google.com>
In-Reply-To: <YJHGQgEE3mqUhbAc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 May 2021 15:24:04 -0700
Message-ID: <CALMp9eT9HMKs_JcQHLsyc9MxFLFaAt9Ve8ev=inH-+8NeHtayw@mail.gmail.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 3:10 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, May 04, 2021, Jim Mattson wrote:
> > On Tue, May 4, 2021 at 2:53 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, May 04, 2021, Jim Mattson wrote:
> > > > On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > Intercept RDTSCP to inject #UD if RDTSC is disabled in the guest.
> > > > >
> > > > > Note, SVM does not support intercepting RDPID.  Unlike VMX's
> > > > > ENABLE_RDTSCP control, RDTSCP interception does not apply to RDPID.  This
> > > > > is a benign virtualization hole as the host kernel (incorrectly) sets
> > > > > MSR_TSC_AUX if RDTSCP is supported, and KVM loads the guest's MSR_TSC_AUX
> > > > > into hardware if RDTSCP is supported in the host, i.e. KVM will not leak
> > > > > the host's MSR_TSC_AUX to the guest.
> > > > >
> > > > > But, when the kernel bug is fixed, KVM will start leaking the host's
> > > > > MSR_TSC_AUX if RDPID is supported in hardware, but RDTSCP isn't available
> > > > > for whatever reason.  This leak will be remedied in a future commit.
> > > > >
> > > > > Fixes: 46896c73c1a4 ("KVM: svm: add support for RDTSCP")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > > ---
> > > > ...
> > > > > @@ -4007,8 +4017,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > > >         svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> > > > >                              guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
> > > > >
> > > > > -       /* Check again if INVPCID interception if required */
> > > > > -       svm_check_invpcid(svm);
> > > > > +       svm_recalc_instruction_intercepts(vcpu, svm);
> > > >
> > > > Does the right thing happen here if the vCPU is in guest mode when
> > > > userspace decides to toggle the CPUID.80000001H:EDX.RDTSCP bit on or
> > > > off?
> > >
> > > I hate our terminology.  By "guest mode", do you mean running the vCPU, or do
> > > you specifically mean running in L2?
> >
> > I mean is_guest_mode(vcpu) is true (i.e. running L2).
>
> No, it will not do the right thing, whatever "right thing" even means in this
> context.  That's a pre-existing issue, e.g. INVCPID handling is also wrong.
> I highly doubt VMX does, or even can, do the right thing either.
>
> I'm pretty sure I lobbied in the past to disallow KVM_SET_CPUID* if the vCPU is
> in guest mode since it's impossible to do the right thing without forcing an
> exit to L1, e.g. changing MAXPHYSADDR will allow running L2 with an illegal
> CR3, ditto for various CR4 bits.

With that caveat understood,

Reviewed-by: Jim Mattson <jmattson@google.com>
