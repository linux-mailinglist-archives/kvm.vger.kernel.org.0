Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96E3606D0D
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 03:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJUBeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 21:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJUBeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 21:34:07 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD89E22D5BB
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 18:34:04 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j7so2474691wrr.3
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 18:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o0H0lq85ZDubPTWEvcIPrSn1+3kTP1iepFskJzLv9No=;
        b=iyHarhhFYcYODiL5qtvVnl6kzK8XyWDTo1FMUVtEpt/GCtUdHSDBYIGUZqGMVhsg8F
         QA78E5MYAlOY362MRMGwQvxDR1VDJZZqgJIemtxjdbV8ROJZhXKTklbH85Z1aUMt/7v8
         Uc1U8hWYIg8l/AbiUmzTjcvfqTN0Fm1SAgcFAVkHnZjr/206yR2RQxnuYjEieh8+bAjm
         mi9CGd/VhWstPzJm4PPmW51P2Mnd+YhkP/t0Ivn+OFqr3OEHDEbPcBg3uomFFfJb+m6N
         D3T7fjxtDlguMQK9QrChLMR2GzgcwX/otEE485wyGcDB1oNeUCzvY5ll7JzEl9Tfl4mK
         tROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o0H0lq85ZDubPTWEvcIPrSn1+3kTP1iepFskJzLv9No=;
        b=lmAtgP9qZOAjmFi+2pvXJvH1BUFvGylSB01nvm6SsTn9BOuTqfGAJ7t878J7nQqE3D
         eJXf31r2DHy3tb9pHkO1hy0iJZVfF6NeD2dY02BdaFCeAmKHhqG0jwVHetZMwQ5SlWJp
         0SZ1ImgO/KieNM/RUnuNq3ZpdoNHJ9dx/GSYxlyfs9pVglrAWxXr4lPPZbdr4SQzhdgd
         wnOF3DXGdxMoZWXlGDdaweI4PmRJFM2Kka//oLqIZh8Y9JKEkxIQ+uhd+U5HOJKzEyXJ
         lalCvQHtomOIaJa3DTJ4NfpUGuJRwrlVQhmcdiS1Z1Y3WuBNBxmFFk+f6+o91zKRt7i0
         7fQA==
X-Gm-Message-State: ACrzQf1M4E6VvgqmrCcPsXNdDzKVBs/5+Ubk7A1MGcW2Rr+tQDRp8Ui9
        OpqQV3F2SK3olq4oPjbiQGVsSDIM9IdF4AHW2835tA==
X-Google-Smtp-Source: AMsMyM6NIO6+jVK4zhV9g/vwdq8JbaMN6z7IsbcBxN4etLc2hvTpILnsFwiHL8aYL+83FzZZ0YES3Z0rvC5fNYCjVwg=
X-Received: by 2002:adf:e3cc:0:b0:235:95b1:2124 with SMTP id
 k12-20020adfe3cc000000b0023595b12124mr4461653wrm.693.1666316042769; Thu, 20
 Oct 2022 18:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-5-aaronlewis@google.com> <Y0Q9ZFGQf1On/Cus@google.com>
 <CAAAPnDGfPZ7k6mHkefhT2tvt6E4cWpEm_QE2Hz=zaVONoXO+xg@mail.gmail.com>
 <Y02VRyrVu2Fh3ipS@google.com> <CAAAPnDFqkkEzixJGn39CqrZoAUBo8MbK7j1VorWT0U4cTSwSCQ@mail.gmail.com>
In-Reply-To: <CAAAPnDFqkkEzixJGn39CqrZoAUBo8MbK7j1VorWT0U4cTSwSCQ@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 21 Oct 2022 01:33:51 +0000
Message-ID: <CAAAPnDGvnC4uP5Q_yio+m8Q-cu+5anZTLwYRpro9E+W=U5gcTA@mail.gmail.com>
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

On Wed, Oct 19, 2022 at 1:06 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> > > I think setting it up this way makes the data coming from userspace
> > > less error prone and easier for them to work with because the lists
> > > are being separated for them into include and exclude, and the order
> > > they build it in doesn't matter.
> >
> > The above said, I agree that building the separate lists would be obnoxious for
> > userspace.  Userspace would either need to know the length of the "includes" list
> > up front, or would have to build the "excludes" list separately and then fold it
> > in at the end.  Unless we might run out of bits, lets keep the flag approach for
> > the uAPI.
> >
> > > Isn't having the include list pointer exposed to userspace a little
> > > awkward?  As is I'm not sure why userspace would care about it, and
> > > when we load the filter we'd essentially ignore it.
> >
> > I don't follow.  I assume userspace cares about specifying "includes", otherwise
> > why provide that functionality?
>
> Yes, userspace cares about includes, but I'm not sure they will care
> about the "include" pointer because we would ignore it when loading a
> filter (there's no information it provides we can get from the other
> fields) and it would be cumbersome for them to use as you pointed out.
> So, I was just guessing that they wouldn't use it.
>
> >
> > I'm not concerned about the setup cost to create the sub-lists, my thoughts are
> > purely from a "how easy is it to understand" perspective, closely followed by
> > "how performant is the runtime code".  IIUC, the runtime performance is basically
> > equivalent since the comparison function will need to mask off bits either way.
> >
> > For the forward+backward, IMO it's easy to understand with a single comment above
> > the forward+backward walks:
> >
> >         /*
> >          * Entries are sorted by eventsel, walk the list in both directions to
> >          * process all entries with the target eventsel.
> >          */
> >
> > Sorting should probably have a comment too, but critically, understanding how the
> > list is sorted doesn't require full understanding of how lookups are processed.
> > E.g. a comment like this would suffice for sorting:
> >
> >         /*
> >          * Sort entries by eventsel so that all entries for a given eventsel can
> >          * be processed efficiently during filter.
> >          */
> >
> > The sub-list on the other hand requires comments to explain the sub-list concept,
> > document the indexing code (and its comparator?), the #define for the head bits
> > (and/or struct field), and the walk code code that processes the sublist.
> >
> > In addition to having more things to document, the comments will be spread out,
> > and IMO it's difficult to understand each individual piece without having a good
> > grasp of the overall implementation.  Using "head" instead of "index" would help
> > quite a bit for the lookup+walk, but I think the extra pieces will still leave
> > readers wondering "why?.  E.g. Why is there a separate comparator for sorting
> > vs. lookup?  Why is there a "head" field?  What problem do sub-lists solve?
> >
>
> I'll drop indexing.
>
> >
> > I don't see why encoding is necessary to achieve a common internal implementation
> > though.  To make sure we're talking about the same thing, by "encoding" I mean
> > having different layouts for the same data in the uAPI struct than the in-kernel
> > struct.  I'm perfectly ok having bits in the uAPI struct that are dropped when
> > building the in-kernel lists, e.g. the EXCLUDE bit.  Ditto for having bits in the
> > in-kernel struct that don't exist in the uAPI struct, e.g. the "head" (index) of
> > the sublist if we go that route.
> >
> > My objection to "encoding" is moving the eventsel bits around.  AFAICT, it's not
> > strictly necessary, and similar to the sub-list approach, that raises that question
> > of "why?".  In all cases, aren't the "eventsel" bits always contained in bits 35:32
> > and 7:0?  The comparator can simply mask off all other bits in order to find a
> > filter with the specified eventsel, no?
>
> Strictly speaking, yes... as long as you are aware of some boundaries
> and work within them.
>
> Problem:
> --------
>
> Given the event select + unit mask pairs: {0x101, 0x1}, {0x101, 0x2},
> {0x102, 0x1}
>
> If we use the architectural layout we get: 0x10011, 0x10021, 0x10012.
>
> Sorted by filter_event_cmp(), i.e. event select, it's possible to get:
> 0x10012, 0x10011, 0x10021.
>
> Then if a search for {0x101, 0x2} with cmp_u64() is done it wouldn't
> find anything because 0x10021 is deemed less than 0x10011 in this
> list.  That's why adding find_filter_index(..., cmp_u64) > 0 doesn't
> work to special case legacy events.
>
> Similarly, if sorted by cmp_u64() we get: 0x10021, 0x10012, 0x10011.
>
> Then a search with filter_event_cmp() for 0x10021 would fail as well.
>
> Possible workaround #1:
> -----------------------
>
> If we use the internal layout (removed index).
>
> struct kvm_pmu_filter_entry {
>         union {
>                 u64 raw;
>                 struct {
>                         u64 mask:8;
>                         u64 match:8; // doubles as umask, i.e.
> encode_filter_entry()
>                         u64 event_select:12;
>                         u64 exclude:1;
>                         u64 rsvd:35;
>                 };
>         };
> };
>
> Because the event_select is contiguous, all of its bits are above
> match, and the fields in kvm_pmu_filter_entry are ordered from most
> important to least important from a sort perspective, a sort with
> cmp_u64() gives us: 0x10210, 0x10120, 0x10110.
>
> This order will work for both legacy events and masked events.  So, as
> you suggested, if we wanted to add the following to
> is_gp_event_allowed() we can special case legacy events and early out:
>
>         if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS))
>                 return find_filter_index(..., cmp_u64) > 0;
>
> Or we can leave it as is and the mask events path will come up with
> the same result.
>
> Possible workaround #2:
> -----------------------
>
> If we use the architectural layout for masked events, e.g.:
>
> struct kvm_pmu_event_filter_entry {
>         union {
>                 __u64 raw;
>                 struct {
>                         __u64 select_lo:8;
>                         __u64 match:8;
>                         __u64 rsvd1:16;
>                         __u64 select_hi:4;
>                         __u64 rsvd2:19;
>                         __u64 mask:8;
>                         __u64 exclude:1;
>                 };
>         }
> }
>
> This becomes more restrictive, but for our use case I believe it will
> work.  The problem with this layout in general is where the event
> select ends up.  You can't put anything below 'select_lo', and
> 'select_lo' and 'select_hi' straddle the unit mask, so you just have
> less control over the order things end up.  That said, if our goal is
> to just sort by exclude + event select for masked events we can do
> that with filter_event_cmp() on the layout above.  If we want to find
> a legacy event we can use cmp_u64() on the layout above as well.  The
> only caveat is you can't mix and match during lookup like you can in
> workaround #1.  You have to sort and search with the same comparer.
>
> If we convert legacy events to masked events I'm pretty sure we can
> still have a common code path.
>
> >
> > > > We might need separate logic for the existing non-masked mechanism, but again
> > > > that's only more code, IMO it's not more complex.  E.g. I believe that the legacy
> > > > case can be handled with a dedicated:
> > > >
> > > >         if (!(filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS))
> > > >                 return find_filter_index(..., cmp_u64) > 0;
> > > >
> > >
> > > I'd rather not drop encoding, however, if we did, sorting and
> > > searching would both have to be special cased.  Masked events and
> > > non-masked events are not compatible with each other that way. If the
> > > list is sorted for masked events, you can't do a cmp_u64 search on it
> > > and expect to find anything.
> >
> > I'm not sure I follow.  As above, doesn't the search for masked vs. non-masked only
> > differ on the comparator?
> >
> > > I suppose you could if using the struct overlay and we included match (which
> > > doubles as the unit mask for non-masked events) in the comparer and dropped
> > > indexing.
> >
> > Why does "match" need to be in the comparer?  I thought the sub-lists are created
> > for each "eventsel"?
> >
> > > But that only works because the struct overlay keeps the event select
> > > contiguous.  The fact that the architectural format has the event select
> > > straddle the unit mask prevents that from working.
> > >
> > > > Oh, and as a bonus of splitting include vs. exclude, the legacy case effectively
> > > > optimizes exclude since the length of the exclude array will be '0'.
> > >
> > > This should apply to both implementations.
> >
> > If everything is in a single list, doesn't the exclude lookup need to search the
> > entire thing to determine that there are no entries?
>
> Yes.  To do what I'm suggesting would require creating an internal
> representation of the struct kvm_pmu_event_filter to track the include
> and exclude portions of the list.  But that should be fairly
> straightforward to set up when loading the filter, then we would be
> able to search the individual lists rather than the whole thing.
> Having said that, I'm not saying this is necessary, all I'm saying is
> that it wouldn't be hard to do.
>
> > ...
> >
> > > > >  struct kvm_pmu_filter_entry {
> > > > >       union {
> > > > >               u64 raw;
> > > > >               struct {
> > > > > +                     u64 mask:8;
> > > > > +                     u64 match:8;
> > > > > +                     u64 event_index:12;
> > > >
> > > > This is broken.  There are 2^12 possible event_select values, but event_index is
> > > > the index into the full list of events, i.e. is bounded only by nevents, and so
> > > > this needs to be stored as a 32-bit value.  E.g. if userspace creates a filter
> > > > with 2^32-2 entries for eventsel==0, then the index for eventsel==1 will be
> > > > 2^32-1 even though there are only two event_select values in the entire list.
> > > >
> > >
> > > nevents <= KVM_PMU_EVENT_FILTER_MAX_EVENTS (300), so there is plenty
> > > of space in event_index to cover any valid index.  Though a moot point
> > > if we cut it.
> >
> > Oooh.  In that case, won't 9 bits suffice?  Using 12 implies there's a connection
> > to eventsel, which is misleading and confusing.
>
> Yes, 9 would suffice.  I gave some buffer because I liked the idea of
> round numbers and I had a lot of space in the struct.  I didn't see it
> implying a connection to event_select, but in hindsight I can see why
> you may have thought that.
>
> >
> > Regardless, if we keep the indexing, there should be a BUILD_BUG_ON() to assert
> > that the "head" (event_index) field is larger enough to hold the max number of
> > events.  Not sure if there's a way to get the number of bits, i.e. might require
> > a separate #define to get the compile-time assert. :-/

Here's what I came up with.  Let me know if this is what you were thinking:

arch/x86/include/uapi/asm/kvm.h

#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
#define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)

/*
 * Masked event layout.
 * Bits   Description
 * ----   -----------
 * 7:0    event select (low bits)
 * 15:8   umask match
 * 31:16  unused
 * 35:32  event select (high bits)
 * 36:54  unused
 * 55     exclude bit
 * 63:56  umask mask
 */

#define KVM_PMU_ENCODE_MASKED_ENTRY(event_select, mask, match, exclude) \
        (((event_select) & 0xFFULL) | (((event_select) & 0XF00ULL) << 24) | \
        (((mask) & 0xFFULL) << 56) | \
        (((match) & 0xFFULL) << 8) | \
        ((__u64)(!!(exclude)) << 55))

#define KVM_PMU_MASKED_ENTRY_EVENT_SELECT \
        (GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
#define KVM_PMU_MASKED_ENTRY_UMASK_MASK         (GENMASK_ULL(63, 56))
#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH        (GENMASK_ULL(15, 8))
#define KVM_PMU_MASKED_ENTRY_EXCLUDE            (BIT_ULL(55))
#define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT   (56)


arch/x86/include/asm/kvm_host.h

struct kvm_x86_pmu_event_filter {
        __u32 action;
        __u32 nevents;
        __u32 fixed_counter_bitmap;
        __u32 flags;
        __u32 nr_includes;
        __u32 nr_excludes;
        __u64 *includes;
        __u64 *excludes;
        __u64 events[];
};

- struct kvm_pmu_event_filter __rcu *pmu_event_filter;
+ struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;


arch/x86/kvm/pmu.c

static int filter_sort_cmp(const void *pa, const void *pb)
{
        u64 a = *(u64 *)pa & (KVM_PMU_MASKED_ENTRY_EVENT_SELECT |
                              KVM_PMU_MASKED_ENTRY_EXCLUDE);
        u64 b = *(u64 *)pb & (KVM_PMU_MASKED_ENTRY_EVENT_SELECT |
                              KVM_PMU_MASKED_ENTRY_EXCLUDE);

        return (a > b) - (a < b);
}

/*
 * For the event filter, searching is done on the 'includes' list and
 * 'excludes' list separately rather than on the 'events' list (which
 * has both).  As a result the exclude bit can be ignored.
 */
static int filter_event_cmp(const void *pa, const void *pb)
{
        u64 a = *(u64 *)pa & KVM_PMU_MASKED_ENTRY_EVENT_SELECT;
        u64 b = *(u64 *)pb & KVM_PMU_MASKED_ENTRY_EVENT_SELECT;

        return (a > b) - (a < b);
}

static int find_filter_index(u64 *events, u64 nevents, u64 key)
{
        u64 *fe = bsearch(&key, events, nevents, sizeof(events[0]),
                          filter_event_cmp);

        if (!fe)
                return -1;

        return fe - events;
}

static bool is_filter_entry_match(u64 filter_event, u64 umask)
{
        u64 mask = filter_event >> (KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT - 8);
        u64 match = filter_event & KVM_PMU_MASKED_ENTRY_UMASK_MATCH;

        BUILD_BUG_ON((KVM_PMU_ENCODE_MASKED_ENTRY(0, 0xff, 0, false) >>
                     (KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT - 8)) !=
                     ARCH_PERFMON_EVENTSEL_UMASK);

        return (umask & mask) == match;
}

static bool filter_contains_match(u64 *events, u64 nevents, u64 eventsel)
{
        u64 event_select = eventsel & kvm_pmu_ops.EVENTSEL_EVENT;
        u64 umask = eventsel & ARCH_PERFMON_EVENTSEL_UMASK;
        int i, index;

        index = find_filter_index(events, nevents, event_select);
        if (index < 0)
                return false;

        /*
         * Entries are sorted by the event select.  Walk the list in both
         * directions to process all entries with the targeted event select.
         */
        for (i = index; i < nevents; i++) {
                if (filter_event_cmp(&events[i], &event_select) != 0)
                        break;

                if (is_filter_entry_match(events[i], umask))
                        return true;
        }

        for (i = index - 1; i >= 0; i--) {
                if (filter_event_cmp(&events[i], &event_select) != 0)
                        break;

                if (is_filter_entry_match(events[i], umask))
                        return true;
        }

        return false;
}

static bool is_gp_event_allowed(struct kvm_x86_pmu_event_filter *filter,
                                u64 eventsel)
{
        if (filter_contains_match(filter->includes,
filter->nr_includes, eventsel) &&
            !filter_contains_match(filter->excludes,
filter->nr_excludes, eventsel))
                return filter->action == KVM_PMU_EVENT_ALLOW;

        return filter->action == KVM_PMU_EVENT_DENY;
}

< All the code above here is for filtering the guest eventsel. >
< All the code below here is for validating and loading the filter. >

static bool is_filter_valid(struct kvm_x86_pmu_event_filter *filter)
{
        u64 mask;
        int i;

        /* To maintain backwards compatibility only validate masked events. */
        if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS) {
                mask = kvm_pmu_ops.EVENTSEL_EVENT |
                       KVM_PMU_MASKED_ENTRY_UMASK_MASK |
                       KVM_PMU_MASKED_ENTRY_UMASK_MATCH |
                       KVM_PMU_MASKED_ENTRY_EXCLUDE;

                for (i = 0; i < filter->nevents; i++) {
                        if (filter->events[i] & ~mask)
                                return false;
                }
        }

        return true;
}

static void prepare_filter_events(struct kvm_x86_pmu_event_filter *filter)
{
        int i, j;

        if (filter->flags & KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
                return;

        for (i = 0, j = 0; i < filter->nevents; i++) {
                /*
                 * Skip events that are impossible to match against a guest
                 * event.  When filtering, only the event select + unit mask
                 * of the guest event is used.
                 */
                if (filter->events[i] & ~(kvm_pmu_ops.EVENTSEL_EVENT |
                                          ARCH_PERFMON_EVENTSEL_UMASK))
                        continue;

                /*
                 * Convert userspace events to a common in-kernel event so
                 * only one code path is needed to support both events.  For
                 * the in-kernel events use masked events because they are
                 * flexible enough to handle both cases.  To convert to masked
                 * events all that's needed is to add the umask_mask.
                 */
                filter->events[j++] =
                        filter->events[i] |
                        (0xFFULL << KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT);
        }

        filter->nevents = j;
}

static void setup_filter_lists(struct kvm_x86_pmu_event_filter *filter)
{
        int i;

        for (i = 0; i < filter->nevents; i++) {
                if(filter->events[i] & KVM_PMU_MASKED_ENTRY_EXCLUDE)
                        break;
        }

        filter->nr_includes = i;
        filter->nr_excludes = filter->nevents - filter->nr_includes;
        filter->includes = filter->events;
        filter->excludes = filter->events + filter->nr_includes;
}

 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
-       struct kvm_pmu_event_filter tmp, *filter;
+       struct kvm_pmu_event_filter __user *user_filter = argp;
+       struct kvm_x86_pmu_event_filter *filter;
+       struct kvm_pmu_event_filter tmp;
        size_t size;
        int r;

-       if (copy_from_user(&tmp, argp, sizeof(tmp)))
+       if (copy_from_user(&tmp, user_filter, sizeof(tmp)))
                return -EFAULT;

        if (tmp.action != KVM_PMU_EVENT_ALLOW &&
            tmp.action != KVM_PMU_EVENT_DENY)
                return -EINVAL;

-       if (tmp.flags != 0)
+       if (tmp.flags & ~KVM_PMU_EVENT_FLAGS_VALID_MASK)
                return -EINVAL;

        if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
                return -E2BIG;

        size = struct_size(filter, events, tmp.nevents);
-       filter = kmalloc(size, GFP_KERNEL_ACCOUNT);
+       filter = kzalloc(size, GFP_KERNEL_ACCOUNT);
        if (!filter)
                return -ENOMEM;

+       filter->action = tmp.action;
+       filter->nevents = tmp.nevents;
+       filter->fixed_counter_bitmap = tmp.fixed_counter_bitmap;
+       filter->flags = tmp.flags;
+
        r = -EFAULT;
-       if (copy_from_user(filter, argp, size))
+       if (copy_from_user(filter->events, user_filter->events,
+                          sizeof(filter->events[0]) * filter->nevents))
                goto cleanup;

-       /* Restore the verified state to guard against TOCTOU attacks. */
-       *filter = tmp;
+       r = -EINVAL;
+       if (!is_filter_valid(filter))
+               goto cleanup;

-       remove_impossible_events(filter);
+       prepare_filter_events(filter);

        /*
-        * Sort the in-kernel list so that we can search it with bsearch.
+        * Sort entries by event select so that all entries for a given
+        * event select can be processed efficiently during filtering.
         */
-       sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);
+       sort(&filter->events, filter->nevents, sizeof(filter->events[0]),
+            filter_sort_cmp, NULL);
+
+       setup_filter_lists(filter);
