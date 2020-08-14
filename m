Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE93244D2C
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 18:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHNQzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 12:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgHNQzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 12:55:49 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F64DC061385
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 09:55:48 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id i19so5154092lfj.8
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 09:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DO7S7QGLxBOAwNEZ/MF23QGUWMGoUkuNJhHiVVUZhao=;
        b=VqeFKEczB585wvUVi2mJLqYcZTyAZSgCFoV26oEYd4IMUAuYo6a1xqcZZZB8u0b9Q0
         9rpUuZ2d4G3xk6LcnzxULr3pNaol7pEKieuLNfKZxD3/mz/g1NWEGvAm9dsEIKKFoNPV
         XXhjajYMoVuj4iFgPfzRogYC21a8QE8JNnS8pqGDMCMnr2qNMCiKMhzXLcFkC60prFc8
         knwMFbB0A7cJp1J6AUO1BCDUnZsTNgbx6OWik46FGh97QizfcHqXOgUfWjXeIjM0ULV0
         PVWE0bEpuzuOYR7dARJ9Y9Q+sdD6iOQllAC3djqPjQICa7sPbVLqcJSjWaFxmhvFx2ui
         3jAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DO7S7QGLxBOAwNEZ/MF23QGUWMGoUkuNJhHiVVUZhao=;
        b=EmBlIRDxt31GyIRDd2Ky+0MTpv8iSAeHUG56LmbKMrvUKr6RnDWyO/lxdyC2DoEpgy
         NABAnm7WWGoWFf+VCCyEYSLuxk3gkTPhRXkgPdF/9gS5RnyeC1Bgd3RZaUs5ZyFZAheq
         DFV9+ZklN17tciNkxGFa3iwGnii33u+Ejr00nYw4If5R/yNkHb5H+Oh4v2gaAywLAz/Z
         5OB7ht7Cm7pNCTVj0NG3katBxwsFwiiSQyNlzvHAJNkJ7xWfZ0eJArnUxRbn/D/MMm/R
         34MXfkm1PFGMOcKjEWFbiLxWcvuCEP9chY1LmeNX+b00Ot6r8FvFbGcMYg26IV+ERF30
         +fPQ==
X-Gm-Message-State: AOAM533SA3uuDg76lldU0xLNNcQidRLSqQNNPxx8Mc8G/zN32ZnJIB4l
        DfMQmH+w24YyShE56mhlZluIqriNJ8FFnos2bYCzKw==
X-Google-Smtp-Source: ABdhPJwuGRQddYGcWX7cZaevOuB329smlRvil79VNLOrcpKQC9KdV2cdaljhK8+/M08D4whKVmuY5tqFk5cwu365BX8=
X-Received: by 2002:a19:7710:: with SMTP id s16mr1636019lfc.162.1597424144986;
 Fri, 14 Aug 2020 09:55:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com> <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
 <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
 <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com> <CAOQ_QsjsmVpbi92o_Dz0GzAmU_Oq=Z4KFjZ8BY5dLQr7YmbrFg@mail.gmail.com>
 <CALMp9eQ4zPoRfPQJ2c7H-hyqCWu+B6fjXk+7SsEOvK7aR49ZJg@mail.gmail.com> <7dce49db-9175-bfe0-8374-d433a7589de9@redhat.com>
In-Reply-To: <7dce49db-9175-bfe0-8374-d433a7589de9@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 14 Aug 2020 11:55:33 -0500
Message-ID: <CAOQ_Qsg9+a07bva3ZsEhx8-wAw8JPDm6Amss0XnWfMT2mNtqaw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 8:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/08/20 00:01, Jim Mattson wrote:
> >>> but perhaps I'm missing something obvious.
> >> Not necessarily obvious, but I can think of a rather contrived example
> >> where the sync heuristics break down. If we're running nested and get
> >> migrated in the middle of a VMM setting up TSCs, it's possible that
> >> enough time will pass that we believe subsequent writes to not be of
> >> the same TSC generation.
> >
> > An example that has been biting us frequently in self-tests: migrate a
> > VM with less than a second accumulated in its TSC. At the destination,
> > the TSCs are zeroed.
>
> Yeah, good point about selftests.  But this would be about the sync
> heuristics messing up, and I don't understand how these ioctls improve
> things.

The improvement would be that userspace has final say over the TSC.
The ioctl only participates in match tracking and isn't subject to
value overrides.

>
> >> My immediate reaction was that we should just migrate the heuristics
> >> state somehow
> >
> > Yeah, I completely agree. I believe this series fixes the
> > userspace-facing issues and your suggestion would address the
> > guest-facing issues.
>
> I still don't understand how these ioctls are any better for userspace
> than migrating MSR_IA32_TSC.  The host TSC is different between source
> and destination, so the TSC offset will be different.

Indeed. We do not migrate the TSC offsets, but guest TSC values
constructed from them. Otherwise, the values are complete nonsense on
the other end of the migration.

We allow our userspace to decide the host TSC / wall clock pair at
which the vCPUs were paused. From that host TSC value we reconstruct
the guest TSCs using the offsets and migrate that info. On the
destination we grab another host TSC / clock pair and recalculate
guest TSC offsets, which we then pass to KVM_SET_TSC_OFFSET. This is
desirable over a per-vCPU read of MSR_IA32_TSC because we've
effectively recorded all TSCs at the exact same moment in time.
Otherwise, we inadvertently add skew between guest TSCs by reading
each vCPU at different times. It seems that the sync heuristics
address this issue along with any guest TSC coordination.

Not only that, depending on the heuristics to detect a sync from
userspace gets a bit tricky if we (KVM) are running nested. Couldn't
more than a second of time elapse between successive KVM_SET_MSRS when
running in L1 if L0 decides to pause our vCPUs (suspend/resume,
migration)? It seems to me that in this case we will fail to detect a
sync condition and configure the L2 TSCs to be out-of-phase.

Setting the guest TSCs by offset doesn't have these complications.
Even if L0 were to pause L1 for some inordinate amount of time, the
relation of L1 -> L2 TSC is never disturbed.

>
> I am all for improving migration of TSC state, but I think we should do
> it right, so we should migrate a host clock / TSC pair: then the
> destination host can use TSC frequency and host clock to compute the new
> TSC value.  In fact, such a pair is exactly the data that the syncing
> heuristics track for each "generation" of syncing.
>
> To migrate the synchronization state, instead, we only need to migrate
> the "already_matched" (vcpu->arch.this_tsc_generation ==
> kvm->arch.cur_tsc_generation) state.
>
> Putting all of this together, it would be something like this:
>
> - a VM-wide KVM_CLOCK/KVM_SET_CLOCK needs to migrate
> vcpu->arch.cur_tsc_{nsec,write} in addition to the current kvmclock
> value (it's unrelated, but I don't think it's worth creating a new
> ioctl).  A new flag is set if these fields are set in the struct.  If
> the flag is set, KVM_SET_CLOCK copies the fields back, bumps the
> generation and clears kvm->arch.nr_vcpus_matched_tsc.
>
> - a VCPU-wide KVM_GET_TSC_INFO returns a host clock / guest TSC pair
> plus the "already matched" state.  KVM_SET_TSC_INFO will only use the
> host clock / TSC pair if "already matched" is false, to compute the
> destination-side TSC offset but not otherwise doing anything with it; or
> if "already matched" is true, it will ignore the pair, compute the TSC
> offset from the data in kvm->arch, and update
> kvm->arch.nr_vcpus_matched_tsc.
>

It seems to me that a per-vCPU ioctl (like you've suggested above) is
necessary to uphold the guest-facing side of our sync scheme,
regardless of what we do on the userspace-facing side.

> Paolo
>
