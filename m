Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D8C5895AD
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 03:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbiHDBgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 21:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiHDBgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 21:36:46 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C998D22B27
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 18:36:44 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id bk11so13678462wrb.10
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 18:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9RuCDA+INl34oJD/W+EPuam1+8E6DH21uoRnJj9a9WY=;
        b=QONRPYMQ6w78/JipPhnXTUEL1narrgVyWzYucO6P8wP9tuZYqKTXukIkQxqOiW9/wB
         zonMdrDz7WkAFQlenAGCPWdEFReccnffdcvG3OAsx1esT/OoljSm6smFqovSDbk2cSCo
         m8kEKEni77EDz0dDsWHfy2czTWf33MU8Q7wvIMy9kjsaRlWQkQNLPVOp6ig4b58S9to5
         iUQQ2aVk4S1o4TDHlSAS7i+N3UlQ5ueklJgzuI5DYAONUW+PSEFa7xndYI+E8kOdIt+l
         /4FFE3jHoGVjSW8Hq5+g87hrReHif37GNPWZQRCmwBjeQ6WmnvFOmXaMqJ6/8y1m7ZFz
         mjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9RuCDA+INl34oJD/W+EPuam1+8E6DH21uoRnJj9a9WY=;
        b=20yDHMDLi7G2XR6bPDhQZEG+g+rjAWdTptentmDh0EGO49oaohSIG/eRYwAmU97h9O
         r0IgnkuDZqZVv5m0k5iaCk/SXRXcDGBnh2dmorM6OAVp1mUJb4QnUo1AoePAf9ot76Tm
         7mftXywnvqEWKoF8pCT3GvJP0+JbksPTyG0v2QlSf/eoqqxG46M/ymWAOrW4TQQGijrz
         P/y54ucIvHjEB4AHozYo2ie6Kwfcmc2Ar5zPbbFz+e2vgkXjYmtdwtVU2r/B6ieOQ2P7
         D7gSr0Gj5QVHeZ9G1YLUTyxcJO98/TA7k6vB9ymAhmw2j923Pz6nKLC5leRMcwyZbRfE
         TQwQ==
X-Gm-Message-State: ACgBeo3Hv04RX3n2RqaAzNDSpeo4fHXU2cwb4pMqajJj2x84ybInKuUZ
        dA18P7DjFH+MI2DGfR4u5jaigkW6lW7wu9Xl92GQ6w==
X-Google-Smtp-Source: AA6agR7bEW6PQMnUtZPYhyD9J/TfI4S+nXU25vVVP0jSt/YdTED12c1D3PmOyLU1rN6W4ccvzR3FxTo7RPsZo1zyL5s=
X-Received: by 2002:a05:6000:10c3:b0:21f:15aa:1b68 with SMTP id
 b3-20020a05600010c300b0021f15aa1b68mr16401506wrx.693.1659577003160; Wed, 03
 Aug 2022 18:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220709011726.1006267-1-aaronlewis@google.com>
 <20220709011726.1006267-2-aaronlewis@google.com> <CALMp9eRxCyneOJqh+o=dibs7xCtUYr_ot6yju8Tm+pMo478gQw@mail.gmail.com>
In-Reply-To: <CALMp9eRxCyneOJqh+o=dibs7xCtUYr_ot6yju8Tm+pMo478gQw@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 4 Aug 2022 01:36:31 +0000
Message-ID: <CAAAPnDHxwWDJwbW02MW8oz2VBDfEskPC7PJ47Z2TOFJaQZmnVg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Jim Mattson <jmattson@google.com>
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

On Tue, Aug 2, 2022 at 5:19 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Jul 8, 2022 at 6:17 PM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > This feature is enabled by setting the flags field to
> > KVM_PMU_EVENT_FLAG_MASKED_EVENTS.
> >
> > Events can be encoded by using KVM_PMU_EVENT_ENCODE_MASKED_EVENT().
> >
> > It is an error to have a bit set outside valid encoded bits, and calls
> > to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in such cases,
> > including bits that are set in the high nybble[1] for AMD if called on
> > Intel.
> >
> > [1] bits 35:32 in the event and bits 11:8 in the eventsel.
>
> I think there is some confusion in the documentation and the code
> regarding what an 'eventsel' is. Yes, Intel started it, with
> "performance event select registers" that contain an "event select"
> field, but the 64-bit object you refer to as an 'event' here in the
> commit message is typically referred to as an 'eventsel' in the code

Yeah, it does look like 'eventsel' is more commonly used in the kernel
to refer to the "performance event select register".  I do see a few
locations where 'eventsel' refers to an eventsel's event.  Maybe I can
rename those in a separate series to avoid future confusion, though
another reason I named it that way is because the SDM and APM both
refer to the eventsel's event as an "event select" which naturally
makes sense to call it eventsel.  I figured we'd want to be consistent
with the docs.

If we prefer to call the 64-bit object 'eventsel', then what do we
call the eventsel's event?  Maybe 'eventsel's event' is good enough,
however, it's unfortunate "event select" is overloaded like it is
because I don't feel the need to say "eventsel's unit mask".

I'm open to other suggestions as well.  There's got to be something
better than that.

> below. Maybe it's too late to avoid confusion, but I'd suggest
> referring to the 64-bit object as a "PMU event filter entry," or
> something like that.
>

What about "filtered event"?

> > +}
> >
> > +static bool allowed_by_masked_events(struct kvm_pmu_event_filter *filter,
> > +                                    u64 eventsel)
> > +{
> > +       if (is_filtered(filter, eventsel, /*invert=*/false))
> > +               if (!is_filtered(filter, eventsel, /*invert=*/true))
>
> Perhaps you could eliminate the ugly parameter comments if you
> maintained the "normal" and inverted entries in separate lists. It
> might also speed things up for the common case, assuming that inverted
> entries are uncommon.

Is it really that ugly?  I thought it made it more clear, so you don't
have to jump to the function to see what the bool does.

I can see an argument for walking a shorter list for inverted entries
in the common case.

To do this I'll likely make an internal copy of the struct like
'struct kvm_x86_msr_filter' to avoid the flexible array at the end of
the pmu event filter, and to not mess with the current ABI.  I'll just
have two lists at the end: one for regular entries and one for
inverted entries.  If there's a better approach I'm all ears.

>
> > +                       return filter->action == KVM_PMU_EVENT_ALLOW;
> > +
> > +       return filter->action == KVM_PMU_EVENT_DENY;
> > +}
> > +
> > +static bool allowed_by_default_events(struct kvm_pmu_event_filter *filter,
> > +                                   u64 eventsel)
> > +{
> > +       u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
> > +
> > +       if (bsearch(&key, filter->events, filter->nevents,
> > +                   sizeof(u64), cmp_u64))
> > +               return filter->action == KVM_PMU_EVENT_ALLOW;
> > +
> > +       return filter->action == KVM_PMU_EVENT_DENY;
> > +}
> > +
> >  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
> >  {
> >         u64 config;
> > @@ -226,14 +318,11 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
> >
> >         filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
> >         if (filter) {
> > -               __u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
> > -
> > -               if (bsearch(&key, filter->events, filter->nevents,
> > -                           sizeof(__u64), cmp_u64))
> > -                       allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
> > -               else
> > -                       allow_event = filter->action == KVM_PMU_EVENT_DENY;
> > +               allow_event = (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) ?
> > +                       allowed_by_masked_events(filter, eventsel) :
> > +                       allowed_by_default_events(filter, eventsel);
>
> If you converted all of the legacy filters into masked filters by
> simply setting the mask field to '0xff' when copying from userspace,
> you wouldn't need the complexity of two different matching algorithms.

Agreed that it will simplify the code, but it will make the legacy
case slower because instead of being able to directly search for a
filtered event, we will have to walk the list of matching eventsel's
events looking for a match.


> > @@ -603,10 +706,18 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
> >         /* Ensure nevents can't be changed between the user copies. */
> >         *filter = tmp;
> >
> > +       r = -EINVAL;
> > +       /* To maintain backwards compatibility don't validate flags == 0. */
> > +       if (filter->flags != 0 && has_invalid_event(filter))
> > +               goto cleanup;
> > +
> > +       if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
> > +               cmp = cmp_eventsel_event;
> > +
> >         /*
> >          * Sort the in-kernel list so that we can search it with bsearch.
> >          */
> > -       sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
> > +       sort(&filter->events, filter->nevents, sizeof(u64), cmp, NULL);
>
> I don't believe two different comparison functions are necessary. In
> the legacy case, when setting up the filter, you should be able to
> simply discard any filter entries that have extraneous bits set,
> because they will never match.

For masked events we need the list ordered by eventsel's event, to
ensure they are contiguous.  For the legacy case we just need the list
sorted in a way that allows us to quickly find a matching eventsel's
event + unit mask.  This lends itself well to a generic u64 sort, but
by doing this the eventsel's events will not be contiguous, which
doesn't lend itself to searching for a masked event.  To get this to
work for both cases I think we'd have to rearrange the sort to put the
bits for the eventsel's event above the unit mask when doing the
compare, which would slow the sort and compare down with all the bit
twiddling going on.

Or if the legacy case adopted how masked events work and ate the extra
cost for a walk rather than a direct search we could join them.

>
> >         mutex_lock(&kvm->lock);
> >         filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
