Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB5B589F79
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 18:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiHDQlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 12:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiHDQlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 12:41:16 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A581539BBD
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 09:41:15 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-10ea30a098bso129724fac.8
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 09:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Q9OzyF/6PJuuFbciROPBpH4cNqi1Id1423IE29H4Nn4=;
        b=RtLyKMhIGCIi2InhAe/vou2zKC17fB2cwzFbkBLyk6d3BY8dAli2OVpYprJKswBNkh
         5qJ1BYj9s4MsSWY/V7Z0G42o1NASLfAIQqGx54QS++0FZuZcG8r1alQ1ScpQm0dG/Bx0
         M4FeW6YAxTEW0JJCsNq2nYuJJfWHKSrma1do4HYM2nJCBScluaADL2XI1vMEAVX30UPw
         tcYriZxKafAVYe1oV56j4qKUQhZbpUOTRGDVvycGOR49sPvxsPWhXO0iAH7GnvZMVIEW
         oNBvfOjr2xJDp1QQv0Ca+u923Vp88+11aHq7xJYPGDcbVRggR1F0WgRt4SrmLVaSkM9i
         HVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Q9OzyF/6PJuuFbciROPBpH4cNqi1Id1423IE29H4Nn4=;
        b=0SMBNkx1yuG1QbVJS7SYUA4TOVINrl3ui9TgN/hr1YAsK4PpmgDMvbq8MJwhi3zRMD
         ppMmWptZFg56f0R6LOIuN5+6dJ2R2eEyWQTuMSEPUsWILx1oy8jRv7LmTkphpJ3NE8Og
         XefVMeFdwdub4yKkif/PSBfQC71osH7Qw9UP9cLM9lWzGQphE69dINPSjbnDScPJJCAL
         xPP7GVO2ReaHcvhHyiZ6s0F3MzehF7v7moXNqjvtFHAwiove03V8mHUh+M0qONsRpGPy
         SJy1LYMT7vSOVzQQHAdKvH8iOWxIPVcxdUoeWnOL73QoEWfUo/5ye8UUhGhv5iq4s89O
         EIcA==
X-Gm-Message-State: ACgBeo0sgt5+DLtfVo0YoDgH5mMA11a5PLuQbwZDLoKKbcl5bcmZB5zs
        t9I+XrgFbLZ40Mg1N4oOUvjetXeCcEj0vJcbu4WUOQ==
X-Google-Smtp-Source: AA6agR73p27115D+UKNxXOvIuKBSdtGU8LIsHT6M6085YsFgCWLvou7Z08MaAmRRPCl5ukWNoZso+/jHbt4wfDwYc7E=
X-Received: by 2002:a05:6870:c88e:b0:10e:7703:7869 with SMTP id
 er14-20020a056870c88e00b0010e77037869mr1286522oab.181.1659631273936; Thu, 04
 Aug 2022 09:41:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220709011726.1006267-1-aaronlewis@google.com>
 <20220709011726.1006267-2-aaronlewis@google.com> <CALMp9eRxCyneOJqh+o=dibs7xCtUYr_ot6yju8Tm+pMo478gQw@mail.gmail.com>
 <CAAAPnDHxwWDJwbW02MW8oz2VBDfEskPC7PJ47Z2TOFJaQZmnVg@mail.gmail.com>
In-Reply-To: <CAAAPnDHxwWDJwbW02MW8oz2VBDfEskPC7PJ47Z2TOFJaQZmnVg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 4 Aug 2022 09:41:02 -0700
Message-ID: <CALMp9eRgpSZ3cN8-3pn5ujckn2gZ8G6_ogwW=Ymx9JW1YW=+kQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 3, 2022 at 6:36 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> On Tue, Aug 2, 2022 at 5:19 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Jul 8, 2022 at 6:17 PM Aaron Lewis <aaronlewis@google.com> wrote:
> > below. Maybe it's too late to avoid confusion, but I'd suggest
> > referring to the 64-bit object as a "PMU event filter entry," or
> > something like that.
> >
>
> What about "filtered event"?

Filter event?

> > >
> > > +static bool allowed_by_masked_events(struct kvm_pmu_event_filter *filter,
> > > +                                    u64 eventsel)
> > > +{
> > > +       if (is_filtered(filter, eventsel, /*invert=*/false))
> > > +               if (!is_filtered(filter, eventsel, /*invert=*/true))
> >
> > Perhaps you could eliminate the ugly parameter comments if you
> > maintained the "normal" and inverted entries in separate lists. It
> > might also speed things up for the common case, assuming that inverted
> > entries are uncommon.
>
> Is it really that ugly?  I thought it made it more clear, so you don't
> have to jump to the function to see what the bool does.
>
> I can see an argument for walking a shorter list for inverted entries
> in the common case.
>
> To do this I'll likely make an internal copy of the struct like
> 'struct kvm_x86_msr_filter' to avoid the flexible array at the end of
> the pmu event filter, and to not mess with the current ABI.  I'll just
> have two lists at the end: one for regular entries and one for
> inverted entries.  If there's a better approach I'm all ears.

Right. I'm not suggesting that you change the ABI. If you move the
'invert' bit to a higher bit position than any event select bit, then
by including the invert bit in your sort key, the sorted list will
naturally be partitioned into positive and negative entries.

> >
> > > +                       return filter->action == KVM_PMU_EVENT_ALLOW;
> > > +
> > > +       return filter->action == KVM_PMU_EVENT_DENY;
> > > +}
> > > +
> > > +static bool allowed_by_default_events(struct kvm_pmu_event_filter *filter,
> > > +                                   u64 eventsel)
> > > +{
> > > +       u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
> > > +
> > > +       if (bsearch(&key, filter->events, filter->nevents,
> > > +                   sizeof(u64), cmp_u64))
> > > +               return filter->action == KVM_PMU_EVENT_ALLOW;
> > > +
> > > +       return filter->action == KVM_PMU_EVENT_DENY;
> > > +}
> > > +
> > >  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
> > >  {
> > >         u64 config;
> > > @@ -226,14 +318,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
> > >
> > >         filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
> > >         if (filter) {
> > > -               __u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
> > > -
> > > -               if (bsearch(&key, filter->events, filter->nevents,
> > > -                           sizeof(__u64), cmp_u64))
> > > -                       allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
> > > -               else
> > > -                       allow_event = filter->action == KVM_PMU_EVENT_DENY;
> > > +               allow_event = (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) ?
> > > +                       allowed_by_masked_events(filter, eventsel) :
> > > +                       allowed_by_default_events(filter, eventsel);
> >
> > If you converted all of the legacy filters into masked filters by
> > simply setting the mask field to '0xff' when copying from userspace,
> > you wouldn't need the complexity of two different matching algorithms.
>
> Agreed that it will simplify the code, but it will make the legacy
> case slower because instead of being able to directly search for a
> filtered event, we will have to walk the list of matching eventsel's
> events looking for a match.

I think the simplicity of having one common abstraction outweighs the
performance penalty for legacy filter lists with a large number of
unit masks for a particular event select. However, I could be
convinced otherwise with a practical example.
