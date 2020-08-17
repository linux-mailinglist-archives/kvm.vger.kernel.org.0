Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558502476B5
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 21:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404249AbgHQTkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 15:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729599AbgHQTkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 15:40:45 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE32DC061389
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 12:40:44 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f26so18787932ljc.8
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 12:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kM+FY1jVxt6hYWbgUw+qOHYhiRU2mMaVXiNZj3kaUI0=;
        b=s9eHPlcybjWL7cgkC+clAzF70Mp+97kV1hAjrfDE8zF6cjkNtA3zlQsgtuqt2AqFNi
         YaSK46RdYF8y8W5wPgy6QomJO1FCom/NXyDafjYE2hOAeqqNyEuFoLDnjIMigAvQvl5h
         DycnLhTgYyzPt4lkn2HldsAusMKYgINpBDB10Isd0xd6Dommz6MfeOv3Y4cyP2hOjgYj
         gFTOkmY7oA2+oDIfZFqejLfEcoRNadPillen3Nxa8VlgGWErGikaUI6uSfrMJso80UZe
         KjKa6fC00Pd9P/zIu6yYFKEWAeezE/9xl6Gc7Bc954J756XN0RqQzw5wJzdfkG2sZwuD
         87hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kM+FY1jVxt6hYWbgUw+qOHYhiRU2mMaVXiNZj3kaUI0=;
        b=JGnKqXM279e9eKbZ2nNqbwPj1u9+vQNEk3XSW7OvPW5GQOJUi4IyRnWipov3F/J6Xp
         UQdIt8T/UkSm4LzArDDrVjGLPBb0HGLbg+0E5fLHdPOL6A9iFyNm80POxEwRMcCyFQ98
         exXzFIV3DUo955ceXIgZ6M2dRAAMf63aDbx7NXwYKaqj0CYYc+iBPfGMoSki41AGo97m
         0ZcB+vS4GqwVHPV97YH+Wkme+0/Q7JgYW2o8LF5Zr7hAcW4KkG5DdaWjwhdWNMP4rucC
         8nXHaVo/AQSV5ZAAt4Abp4/dGHx+3Kefz4sDKmA0pNcfR+Wrq8yBJZhZnZPEM/+uNWXa
         /eKg==
X-Gm-Message-State: AOAM532M7KSrcoqALedPUH6edsbrvlBMLjopEXj6bf820gQ6MqAJ2agr
        x8Ty8DHjk70t6JlCXhT3Sr4Wzodz6lkFrwq1SLEnCN2WHTs=
X-Google-Smtp-Source: ABdhPJx5jJ8aaPq7jNpfiZ206FMlLNo1uziCruXQoTmSf8dC8US1DzYc/155po+hVqyX/CcBbbmmwVVN1DaVLcQxRS4=
X-Received: by 2002:a2e:99cc:: with SMTP id l12mr7581973ljj.235.1597693242177;
 Mon, 17 Aug 2020 12:40:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com> <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
 <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
 <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com> <CAOQ_QsjsmVpbi92o_Dz0GzAmU_Oq=Z4KFjZ8BY5dLQr7YmbrFg@mail.gmail.com>
 <CALMp9eQ4zPoRfPQJ2c7H-hyqCWu+B6fjXk+7SsEOvK7aR49ZJg@mail.gmail.com>
 <7dce49db-9175-bfe0-8374-d433a7589de9@redhat.com> <CAOQ_Qsg9+a07bva3ZsEhx8-wAw8JPDm6Amss0XnWfMT2mNtqaw@mail.gmail.com>
 <7775b2a5-37b0-38f6-f106-d8960cb5310c@redhat.com>
In-Reply-To: <7775b2a5-37b0-38f6-f106-d8960cb5310c@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 17 Aug 2020 14:40:30 -0500
Message-ID: <CAOQ_Qsipib1qvTw_o3pAp-t9jjf9kWm8M238zxN+Q=3yAMA9oA@mail.gmail.com>
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

On Mon, Aug 17, 2020 at 11:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/08/20 18:55, Oliver Upton wrote:
> > We allow our userspace to decide the host TSC / wall clock pair at
> > which the vCPUs were paused. From that host TSC value we reconstruct
> > the guest TSCs using the offsets and migrate that info. On the
> > destination we grab another host TSC / clock pair and recalculate
> > guest TSC offsets, which we then pass to KVM_SET_TSC_OFFSET. This is
> > desirable over a per-vCPU read of MSR_IA32_TSC because we've
> > effectively recorded all TSCs at the exact same moment in time.
>
> Yes, this should work very well.  But in the end KVM ends up with the
> vcpu->arch.cur_tsc_{nsec,write} of the source (only shifted in time),
> while losing the notion that the pair is per-VM rather than per-VCPU for
> the "already matched" vCPUs.  So that is why I'm thinking of retrieving
> that pair from the kernel directly.
>
> If you don't have time to work on it I can try to find some for 5.10,
> but I'm not sure exactly when.

Shouldn't be an issue, I'll futz around with some changes to the
series and send them out in the coming weeks.

>
> Paolo
>
> > Otherwise, we inadvertently add skew between guest TSCs by reading
> > each vCPU at different times. It seems that the sync heuristics
> > address this issue along with any guest TSC coordination.
> >
> > Not only that, depending on the heuristics to detect a sync from
> > userspace gets a bit tricky if we (KVM) are running nested. Couldn't
> > more than a second of time elapse between successive KVM_SET_MSRS when
> > running in L1 if L0 decides to pause our vCPUs (suspend/resume,
> > migration)? It seems to me that in this case we will fail to detect a
> > sync condition and configure the L2 TSCs to be out-of-phase.
> >
> > Setting the guest TSCs by offset doesn't have these complications.
> > Even if L0 were to pause L1 for some inordinate amount of time, the
> > relation of L1 -> L2 TSC is never disturbed.
> >
> >>
> >> I am all for improving migration of TSC state, but I think we should do
> >> it right, so we should migrate a host clock / TSC pair: then the
> >> destination host can use TSC frequency and host clock to compute the new
> >> TSC value.  In fact, such a pair is exactly the data that the syncing
> >> heuristics track for each "generation" of syncing.
> >>
> >> To migrate the synchronization state, instead, we only need to migrate
> >> the "already_matched" (vcpu->arch.this_tsc_generation ==
> >> kvm->arch.cur_tsc_generation) state.
> >>
> >> Putting all of this together, it would be something like this:
> >>
> >> - a VM-wide KVM_CLOCK/KVM_SET_CLOCK needs to migrate
> >> vcpu->arch.cur_tsc_{nsec,write} in addition to the current kvmclock
> >> value (it's unrelated, but I don't think it's worth creating a new
> >> ioctl).  A new flag is set if these fields are set in the struct.  If
> >> the flag is set, KVM_SET_CLOCK copies the fields back, bumps the
> >> generation and clears kvm->arch.nr_vcpus_matched_tsc.
> >>
> >> - a VCPU-wide KVM_GET_TSC_INFO returns a host clock / guest TSC pair
> >> plus the "already matched" state.  KVM_SET_TSC_INFO will only use the
> >> host clock / TSC pair if "already matched" is false, to compute the
> >> destination-side TSC offset but not otherwise doing anything with it; or
> >> if "already matched" is true, it will ignore the pair, compute the TSC
> >> offset from the data in kvm->arch, and update
> >> kvm->arch.nr_vcpus_matched_tsc.
> >>
> >
> > It seems to me that a per-vCPU ioctl (like you've suggested above) is
> > necessary to uphold the guest-facing side of our sync scheme,
> > regardless of what we do on the userspace-facing side.
> >
> >> Paolo
> >>
> >
>
