Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE43B13FF
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 19:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfILRsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 13:48:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:19824 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbfILRsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 13:48:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 10:48:27 -0700
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="190061001"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 10:48:27 -0700
Message-ID: <641fc86a02201e514ccbfbf893b8abf190a701d8.camel@linux.intel.com>
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>
Date:   Thu, 12 Sep 2019 10:48:27 -0700
In-Reply-To: <20190912163525.GV2739@techsingularity.net>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
         <20190910124209.GY2063@dhcp22.suse.cz>
         <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
         <20190910144713.GF2063@dhcp22.suse.cz>
         <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
         <20190910175213.GD4023@dhcp22.suse.cz>
         <1d7de9f9f4074f67c567dbb4cc1497503d739e30.camel@linux.intel.com>
         <20190911113619.GP4023@dhcp22.suse.cz>
         <CAKgT0UfOp1c+ov=3pBD72EkSB9Vm7mG5G6zJj4=j=UH7zCgg2Q@mail.gmail.com>
         <20190912091925.GM4023@dhcp22.suse.cz>
         <20190912163525.GV2739@techsingularity.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-09-12 at 17:35 +0100, Mel Gorman wrote:
> On Thu, Sep 12, 2019 at 11:19:25AM +0200, Michal Hocko wrote:
> > On Wed 11-09-19 08:12:03, Alexander Duyck wrote:
> > > On Wed, Sep 11, 2019 at 4:36 AM Michal Hocko <mhocko@kernel.org> wrote:
> > > > On Tue 10-09-19 14:23:40, Alexander Duyck wrote:
> > > > [...]
> > > > > We don't put any limitations on the allocator other then that it needs to
> > > > > clean up the metadata on allocation, and that it cannot allocate a page
> > > > > that is in the process of being reported since we pulled it from the
> > > > > free_list. If the page is a "Reported" page then it decrements the
> > > > > reported_pages count for the free_area and makes sure the page doesn't
> > > > > exist in the "Boundary" array pointer value, if it does it moves the
> > > > > "Boundary" since it is pulling the page.
> > > > 
> > > > This is still a non-trivial limitation on the page allocation from an
> > > > external code IMHO. I cannot give any explicit reason why an ordering on
> > > > the free list might matter (well except for page shuffling which uses it
> > > > to make physical memory pattern allocation more random) but the
> > > > architecture seems hacky and dubious to be honest. It shoulds like the
> > > > whole interface has been developed around a very particular and single
> > > > purpose optimization.
> > > 
> > > How is this any different then the code that moves a page that will
> > > likely be merged to the tail though?
> > 
> > I guess you are referring to the page shuffling. If that is the case
> > then this is an integral part of the allocator for a reason and it is
> > very well obvious in the code including the consequences. I do not
> > really like an idea of hiding similar constrains behind a generic
> > looking feature which is completely detached from the allocator and so
> > any future change of the allocator might subtly break it.
> > 
> 
> It's not just that, compaction pokes into the free_area information as
> well and directly takes pages from the free list without going through
> the page allocator itself. It assumes that a free page is a free page
> and only takes the zone and migratetype into account.

Pulling pages out at random isn't an issue as long as the boundary pointer
gets pushed back. However the list tumbling with the
move_freelist_head/tail would be much more problematic for me since it is
essentially shuffling the list and will cause reported pages to be
shuffled in with non-reported ones.

> > > In our case the "Reported" page is likely going to be much more
> > > expensive to allocate and use then a standard page because it will be
> > > faulted back in. In such a case wouldn't it make sense for us to want
> > > to keep the pages that don't require faults ahead of those pages in
> > > the free_list so that they are more likely to be allocated?
> > 
> > OK, I was suspecting this would pop out. And this is exactly why I
> > didn't like an idea of an external code imposing a non obvious constrains
> > to the allocator. You simply cannot count with any ordering with the
> > page allocator.
> 
> Indeed not. It can be arbitrary and compaction can interfere with the
> ordering as well. While in theory that could be addressed by always
> going through an interface maintained by the page allocator, it would be
> tricky to test the virtio case in particular.
> 
> > We used to distinguish cache hot/cold pages in the past
> > and pushed pages to the specific end of the free list but that has been
> > removed.
> 
> That was always best effort too, not a hard guarantee. It was eventually
> removed as the cost of figuring out the ordering exceeded the benefit.
> 
> > There are other potential changes like that possible. Shuffling
> > is a good recent example.
> > 
> > Anyway I am not a maintainer of this code. I would really like to hear
> > opinions from Mel and Vlastimil here (now CCed - the thread starts
> > http://lkml.kernel.org/r/20190907172225.10910.34302.stgit@localhost.localdomain.
> 
> I worry that poking too much into the internal state of the allocator
> will be fragile long-term. There is the arch alloc/free hooks but they
> are typically about protections only and does not interfere with the
> internal state of the allocator. Compaction pokes in as well but once
> the page is off the free list, the page allocator no longer cares so
> again there is on interference with the internal state. If the state is
> interefered with externally, it becomes unclear what happens if things
> like page merging is deferred in a way the allocator cannot control as
> high-order allocation requests may fail for example. For THP, it would
> not matter but failed allocation reports when pages are on the freelist,
> but unsuitable for allocation because of the reported state, would be
> hard to debug. Similarly, latency issues due to a reported page being
> picked for allocation but requiring communication with the hypervisor
> will be difficult to debug and atomic allocations may fail entirely.
> Finally, if merging was broken for reported/unreported pages, it could
> be a long time before such bugs were fixed.

We weren't preventing allocations off of the list other then when the
pages were actually off the list and being reported. So a reported page
could still be allocated normally.

As far as state there were only two things that were really being tracked
with the Reported flag. Basically when we cleared it we needed to make
sure the boundary pointer for the freelist was checked so we could push it
back if needed, and the count for the reported pages was decremented. All
the page->index was providing was an index into the boundary array so we
could find the pointer for that specific free_list.

> That's a lot of caveats to optimise communication about unused free
> pages to the allocator. I didn't read the patches particularly carefully
> but it was not clear why a best effort was not made to track free pages
> and if the metadata maintenance for that fills then do exhaustive
> searches for remaining pages. It might be difficult to stabilise that as
> the metadata may overflow again while the exhaustive search takes place.
> Much would depend on the frequency that pages are entering/leaving
> reported state.

What I was trying to avoid is having to perform an exhaustive walk of the
free_list. I was using boundary as an iterator. Since we have to hold the
zone->lock while pulling pages I wanted to keep the critical section as
small and fast as possible.

It seems like you were somewhat accomplishing that in the compaction code
by using the move_freelist_head/tail calls to basically roll over the list
as you are working through it. Maybe I will look to see just how expensive
it would be to do something similar as that would at least partially
reduce the cost.


