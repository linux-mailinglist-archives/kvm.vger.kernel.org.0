Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2343CCEA71
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 19:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfJGRUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 13:20:30 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39302 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfJGRUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 13:20:30 -0400
Received: by mail-io1-f67.google.com with SMTP id a1so30349345ioc.6;
        Mon, 07 Oct 2019 10:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zItQYDcvuHTLB/BG0kFpgFOOl/Cp+I0Y+DHKlQs1lYU=;
        b=I0iPOmF+k+2yO4TMQjpDoZQfvAhNOQTqgIPUgeuyJvaThkfuPfzbim04FoSJXKogSP
         Jb0O4ZUlhQsFdpmMi4127L5WlT1Xd1U3IO+aKKHd70Dl67msenwA9xNctmhdugusomDz
         Gsb1SJrdmr429R7f8MPvt0DnmiyXO46k8B0Y4KeW7wxHlOF6bO/olmpicy2rJNKGQaSU
         RrKR7wOqJsLZAXnAY4BgZYjWMx9i5G5G2YGgUDFJFQItLKlLG3NZalUOgkuDR6skr/wK
         ST0fbqX+2duPJSjaWV1z2MHtkw7DTWLSGXvuk1UGEoNdBPjfs9MY2uVyW58ojqmGO3cl
         i9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zItQYDcvuHTLB/BG0kFpgFOOl/Cp+I0Y+DHKlQs1lYU=;
        b=cP0RVW48mcDR/4pwCWL71E2I/WUNXuWEd7oNR/MkNydyJ9mcun19PHKWVn3FzLDwiq
         6NHopbAiX/vi65ATKW6ixR4XgcrOcVS5B0raxwfVQN/9JDC2sTgoDpkwfsAapCSUvsDD
         M3YwFzkE5MrNzy23u1r5zxmTpNx0XJ3/k4spCnjCxiY5tXPGrD8ayCLf1VwBy4Cpnf3w
         ujN2waoMoJQdXfn3RYmysURNg3bvMAmfjzH10OAifYzdbeinta7IHf/skysa/eEHF044
         Sfa3Jpn0EqftuLTRFSaTITXCNE7Y6JM6BCK6ZiBiAsLL026aGHCQs6czOlVs3i5/kM++
         2xaA==
X-Gm-Message-State: APjAAAV3zS/k848v6zQhyZo9ZpQo8T64uBnm8v/BiJY95D+ZrtrEPrM9
        3jXL5fOgd4mydjUeuqF0ArKWU8hFvR7ylZLDqqs=
X-Google-Smtp-Source: APXvYqzVBCxbJEjsyVorehVQUCUTbGDBtTHgmBnWns/gS1UhilxPENaIY0/ENbnzBxwHI9LKPVOdtVMRBAxqzJChoiI=
X-Received: by 2002:a6b:720a:: with SMTP id n10mr24641643ioc.64.1570468828721;
 Mon, 07 Oct 2019 10:20:28 -0700 (PDT)
MIME-Version: 1.0
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
 <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com> <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
 <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com> <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
 <c06b68cb-5e94-ae3e-f84e-48087d675a8f@redhat.com> <CAKgT0Ud6TT=XxqFx6ePHzbUYqMp5FHVPozRvnNZK3tKV7j2xjg@mail.gmail.com>
 <0a16b11e-ec3b-7196-5b7f-e7395876cf28@redhat.com> <d96f744d2c48f5a96c6962c6a0a89d2429e5cab8.camel@linux.intel.com>
 <7fc13837-546c-9c4a-1456-753df199e171@redhat.com> <5b6e0b6df46c03bfac906313071ac0362d43c432.camel@linux.intel.com>
 <c2fd074b-1c86-cd93-41ea-ae1a6b2ca841@redhat.com>
In-Reply-To: <c2fd074b-1c86-cd93-41ea-ae1a6b2ca841@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 7 Oct 2019 10:20:17 -0700
Message-ID: <CAKgT0Uecy96y-bOj4TpXBxSwJhn3jaCtGjD2+Zswh9gN7i+Otg@mail.gmail.com>
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page reporting
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        David Hildenbrand <david@redhat.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 7, 2019 at 10:07 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 10/7/19 12:27 PM, Alexander Duyck wrote:
> > On Mon, 2019-10-07 at 12:19 -0400, Nitesh Narayan Lal wrote:
> >> On 10/7/19 11:33 AM, Alexander Duyck wrote:
> >>> On Mon, 2019-10-07 at 08:29 -0400, Nitesh Narayan Lal wrote:
> >>>> On 10/2/19 10:25 AM, Alexander Duyck wrote:

<snip>

> >>>> page_reporting.c change:
> >>>> @@ -101,8 +101,12 @@ static void scan_zone_bitmap(struct page_reporting_config
> >>>> *phconf,
> >>>>                 /* Process only if the page is still online */
> >>>>                 page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
> >>>>                                           zone->base_pfn);
> >>>> -               if (!page)
> >>>> +               if (!page || !PageBuddy(page)) {
> >>>> +                       clear_bit(setbit, zone->bitmap);
> >>>> +                       atomic_dec(&zone->free_pages);
> >>>>                         continue;
> >>>> +               }
> >>>>
> >>> I suspect the zone->free_pages is going to be expensive for you to deal
> >>> with. It is a global atomic value and is going to have the cacheline
> >>> bouncing that it is contained in. As a result thinks like setting the
> >>> bitmap with be more expensive as every tome a CPU increments free_pages it
> >>> will likely have to take the cache line containing the bitmap pointer as
> >>> well.
> >> I see I will have to explore this more. I am wondering if there is a way to
> >> measure this If its effect is not visible in will-it-scale/page_fault1. If
> >> there is a noticeable amount of degradation, I will have to address this.
> > If nothing else you might look at seeing if you can split up the
> > structures so that the bitmap and nr_bits is in a different region
> > somewhere since those are read-mostly values.
>
> ok, I will try to understand the issue and your suggestion.
> Thank you for bringing this up.
>
> > Also you are now updating the bitmap and free_pages both inside and
> > outside of the zone lock so that will likely have some impact.
>
> So as per your previous suggestion, I have made the bitmap structure
> object as a rcu protected pointer. So we are safe from that side.
> The other downside which I can think of is a race where one page
> trying to increment free_pages and other trying to decrements it.
> However, being an atomic variable that should not be a problem.
> Did I miss anything?

I'm not so much worried about a race as the cache line bouncing
effect. Basically your notifier combined within this hinting thread
will likely result in more time spent by the thread that holds the
lock since it will be trying to access the bitmap to set the bit and
the free_pages to report the bit, but at the same time you will have
this thread clearing bits and decrementing the free_pages values.

One thing you could consider in your worker thread would be to do
reallocate and replace the bitmap every time you plan to walk it. By
doing that you would avoid the cacheline bouncing on the bitmap since
you would only have to read it, and you would no longer have another
thread dirtying it. You could essentially reset the free_pages at the
same time you replace the bitmap. It would need to all happen with the
zone lock held though when you swap it out.

- Alex
