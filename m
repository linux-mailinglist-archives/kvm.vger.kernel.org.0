Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9045FFB12
	for <lists+kvm@lfdr.de>; Sat, 15 Oct 2022 17:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJOPnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Oct 2022 11:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiJOPng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Oct 2022 11:43:36 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A042CDE6
        for <kvm@vger.kernel.org>; Sat, 15 Oct 2022 08:43:35 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v130-20020a1cac88000000b003bcde03bd44so8146252wme.5
        for <kvm@vger.kernel.org>; Sat, 15 Oct 2022 08:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yDJAl6FmMFAOa9Iaaz5sD7JvJVpJ9zrth+Mr/pvXMmw=;
        b=NOKjizSRWbSkjQ/l25G7SF//IaK9wveBNhOcIHmPlsihVLsmfckVPZLhx6JUeV13Rc
         +jDiA0xJjOCzvQIBhOnqs9rPECEsou22RBmrX/IAga+MwtfLosF0qxEE2yJounZcUQw0
         z8EHHXcG98FRSVIS0cwIBYOf8I/0+yk+q9jA2W/xsceQit7SjCDGxWJrNwrocqyzhqiR
         eaTzYYnBhd48iAOSNmOOT0MwG+T5QENdwB4813PvEZC3GoR35Rld49dFedxt1jqruVxd
         +SJGWftKGfnzLe4yLmqF/Q+i3SM09oN/RrsNOAQEhkEpJQoOw3CqsC5l2S3yVIRg+T6A
         tz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yDJAl6FmMFAOa9Iaaz5sD7JvJVpJ9zrth+Mr/pvXMmw=;
        b=d/Sp/21A2GQB4DfncWXPCc6LZ5KRwT/w8w9SSl+wHMSGPpFywhfspJNApI0kpYHinZ
         AHo+8t7Dznm4io+ao5LPq60VSd9U0Y2dvHkFuW/09ssUgr7fMogjKlijywYv1OTsrOkl
         8+UyTcEtzIN4tIIPCHpb87gpgzwZWePqUZasHybi2jwnCgZ1t6xg2zdQLI/7ZAeN+7+U
         SW9MKm8XVUkEzRrvRmbNKQ3mz9wJVZzcXMHT+6A0N1YQv2IbdtgzH9k7JkOPooKD3Ka0
         ymy6N2jZcy2A2sRt2KX3gVBLfsoxi6NbwTUt7aq/W1cgrCAUxjf7BASYFjeNFbUY8D3G
         9Mpg==
X-Gm-Message-State: ACrzQf30qQRuh/bxcypeR5ogb2kX+ajKZGaD1/wJtgU7fltzoOda6ruh
        wYFtI8LpzfSqmeUyvV5YblBVVs5Nv7XgJIMDWQB09reK0tk+qA==
X-Google-Smtp-Source: AMsMyM79pf+Co9HFrL6yLLUBbKokT8GZgXS/84zEbOVKf5xDvy44eeQWlaElCpbO1cVBCEUcoWdKAYTzctkQlzk3vAk=
X-Received: by 2002:a05:600c:1e18:b0:3b3:b9f8:2186 with SMTP id
 ay24-20020a05600c1e1800b003b3b9f82186mr2144087wmb.151.1665848613826; Sat, 15
 Oct 2022 08:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-5-aaronlewis@google.com> <Y0Q9ZFGQf1On/Cus@google.com>
In-Reply-To: <Y0Q9ZFGQf1On/Cus@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Sat, 15 Oct 2022 08:43:22 -0700
Message-ID: <CAAAPnDGfPZ7k6mHkefhT2tvt6E4cWpEm_QE2Hz=zaVONoXO+xg@mail.gmail.com>
Subject: Re: [PATCH v5 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
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

On Mon, Oct 10, 2022 at 8:42 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Sep 20, 2022, Aaron Lewis wrote:
> >  static void convert_to_filter_events(struct kvm_pmu_event_filter *filter)
> > @@ -645,7 +719,34 @@ static void convert_to_filter_events(struct kvm_pmu_event_filter *filter)
> >       for (i = 0; i < filter->nevents; i++) {
> >               u64 e = filter->events[i];
> >
> > -             filter->events[i] = encode_filter_entry(e);
> > +             filter->events[i] = encode_filter_entry(e, filter->flags);
> > +     }
> > +}
> > +
> > +/*
> > + * Sort will order the list by exclude, then event select.  This function will
> > + * then index the sublists of event selects such that when a search is done on
> > + * the list, the head of the event select sublist is returned.  This simplifies
> > + * the logic in filter_contains_match() when walking the list.
>

Including previous comments so I can respond in one place:

> Unless I'm missing something, this is a complex way to solve a relatively simple
> problem.  You want a list of "includes" and a list of "excludes".  Just have two
> separate lists.
>
> Actually, if we're effectively changing the ABI, why not make everyone's lives
> simpler and expose that to userspace.  E.g. use one of the "pad" words to specify
> the number of "include" events and effectively do this:
>
> struct kvm_pmu_event_filter {
>         __u32 action;
>         __u32 nevents;
>         __u32 fixed_counter_bitmap;
>         __u32 flags;
>         __u32 nr_include_events;
>         __u64 include[nr_include_events];
>         __u64 exclude[nevents - nr_allowed_events];
> };
>
> Then we don't need to steal a bit for "exclude" in the uABI.  The kernel code
> gets a wee bit simpler.

<end of previous comments>

I'm not sure I understand the struct changes you're proposing.  Is
this what you mean?

struct kvm_pmu_event_filter {
        __u32 action;
        __u32 nevents;
        __u32 fixed_counter_bitmap;
        __u32 flags;
        __u32 nr_include_events;
        __u32 pad;
        __u64 *include; // length == nr_include_events
        __u64 exclude[]; // length == nevents - nr_include_events
};

I considered having an include list and exclude list on the filter,
but I thought that was too much detail to share with userspace.  I've
spent too much time lately trying to change ABI's or wishing they were
different. I'd prefer to share as little as possible with userspace at
this point in hopes of allowing us to change our minds or evolve this
in the future.

To that end, if we use a bit in the event to distinguish between an
include list and an exclude list the only thing we're locked into is
the type of event being introduced with masked events, which would be
easy to iterate on or change.  Then, if we sort the list like I do,
it's naturally split into an include list and an exclude list anyway,
so we essentially have the same thing in the end.  At that point if we
want to explicitly have an include list and an exclude list we could
make an internal struct for kvm_pmu_event_filter similar to what msr
filtering does, but I'm not sure that's necessary.

I think setting it up this way makes the data coming from userspace
less error prone and easier for them to work with because the lists
are being separated for them into include and exclude, and the order
they build it in doesn't matter.

Isn't having the include list pointer exposed to userspace a little
awkward?  As is I'm not sure why userspace would care about it, and
when we load the filter we'd essentially ignore it.  It feels like an
internal variable that's exposed to userspace.  Also, the naming is
confusing when working with non-masked events.  E.g. the "exclude"
list would be used in place of what was the "events" list.  That seems
less intuitive.

> I'm not so sure that this is simpler overall though.  If inclusive vs. exclusive
> are separate lists, then avoiding "index" would mean there's no need to convert
> entries.  And IIUC, the only thing this saves in filter_contains_match() is
> having to walk backwards, e.g. it's
>
>         for (i = index; i < filter->nevents; i++) {
>                 if (!<eventsel event match>)
>                         break;
>
>                 if (is_filter_match(...))
>                         return true;
>         }
>
>         return false;
>
> versus
>
>         for (i = index; i < filter->nevents; i++) {
>                 if (filter_event_cmp(eventsel, filter->events[i]))
>                         break;
>
>                 if (is_filter_match(eventsel, filter->events[i]))
>                         return true;
>         }
>
>         for (i = index - 1; i > 0; i--) {
>                 if (filter_event_cmp(eventsel, filter->events[i]))
>                         break;
>
>                 if (is_filter_match(eventsel, filter->events[i]))
>                         return true;
>         }
>
>         return false;
>
> It's definitely _more_ code in filter_contains_match(), and the duplicate code is
> unfortunate, but I wouldn't necessarily say it's simpler.  There's a fair bit of
> complexity in understanding the indexing scheme, it's just hidden.
>

I think indexing the data is nice to have.  The only additional cost
is walking the list when a filter is loaded, then we are able to
search the head of the list and not have to do this odd walk forward
then backward business.  I'm open to dropping it if it's causing more
confusion than it's worth.  And as you pointed out, I believe not
having it would allow for the use of filter_event_cmp() during
bounding walks.

> And I believe if the indexing is dropped, then the same filter_event_cmp() helper
> can be used for sort() and bsearch(), and for bounding the walks.
>
> And here's also no need to "encode" entries or use a second struct overly.
>

Encoding events solves a different problem than indexing.  It converts
the events that come from userspace into a common format we can use
internally.  That allows the kernel to have a common code path, no
matter what type of event it started out as.

> We might need separate logic for the existing non-masked mechanism, but again
> that's only more code, IMO it's not more complex.  E.g. I believe that the legacy
> case can be handled with a dedicated:
>
>         if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS))
>                 return find_filter_index(..., cmp_u64) > 0;
>

I'd rather not drop encoding, however, if we did, sorting and
searching would both have to be special cased.  Masked events and
non-masked events are not compatible with each other that way.  If the
list is sorted for masked events, you can't do a cmp_u64 search on it
and expect to find anything.  I suppose you could if using the struct
overlay and we included match (which doubles as the unit mask for
non-masked events) in the comparer and dropped indexing.  But that
only works because the struct overlay keeps the event select
contiguous.  The fact that the architectural format has the event
select straddle the unit mask prevents that from working.

> Oh, and as a bonus of splitting include vs. exclude, the legacy case effectively
> optimizes exclude since the length of the exclude array will be '0'.
>

This should apply to both implementations.  I didn't add an include
list and exclude list, but the data is laid out for it.  The main
reason I didn't do that is I didn't think there was enough of a win to
create an internal copy of kvm_pmu_event_filter (stated above), and
it'd be exposing too much of the implementation to userspace to add it
there.

> If we do keep the indexing, I think we should rename "index" to "head", e.g. like
> "head pages", to make it more obvious that the helper returns the head of a list.
>
> > + */
> > +static void index_filter_events(struct kvm_pmu_event_filter *filter)
> > +{
> > +     struct kvm_pmu_filter_entry *prev, *curr;
> > +     int i, index = 0;
> > +
> > +     if (filter->nevents)
> > +             prev = (struct kvm_pmu_filter_entry *)(filter->events);
> > +
> > +     for (i = 0; i < filter->nevents; i++) {
> > +             curr = (struct kvm_pmu_filter_entry *)(&filter->events[i]);
> > +
> > +             if (curr->event_select != prev->event_select ||
> > +                 curr->exclude != prev->exclude) {
> > +                     index = 0;
> > +                     prev = curr;
> > +             }
> > +
> > +             curr->event_index = index++;
> >       }
> >  }
> > + * When filter events are converted into this format then sorted, the
> > + * resulting list naturally ends up in two sublists.  One for the 'include
> > + * list' and one for the 'exclude list'.  These sublists are further broken
> > + * down into sublists ordered by their event select.  After that, the
> > + * event select sublists are indexed such that a search for: exclude = n,
> > + * event_select = n, and event_index = 0 will return the head of an event
> > + * select sublist that can be walked to see if a match exists.
> > + */
> >  struct kvm_pmu_filter_entry {
> >       union {
> >               u64 raw;
> >               struct {
> > +                     u64 mask:8;
> > +                     u64 match:8;
> > +                     u64 event_index:12;
>
> This is broken.  There are 2^12 possible event_select values, but event_index is
> the index into the full list of events, i.e. is bounded only by nevents, and so
> this needs to be stored as a 32-bit value.  E.g. if userspace creates a filter
> with 2^32-2 entries for eventsel==0, then the index for eventsel==1 will be
> 2^32-1 even though there are only two event_select values in the entire list.
>

nevents <= KVM_PMU_EVENT_FILTER_MAX_EVENTS (300), so there is plenty
of space in event_index to cover any valid index.  Though a moot point
if we cut it.

> >                       u64 event_select:12;
> > -                     u64 unit_mask:8;
> > -                     u64 rsvd:44;
> > +                     u64 exclude:1;
> > +                     u64 rsvd:23;
> >               };
> >       };
> >  };
