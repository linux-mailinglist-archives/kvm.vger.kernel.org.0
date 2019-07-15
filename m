Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B895B69572
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 16:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391514AbfGOO57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 10:57:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:65131 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391468AbfGOO55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 10:57:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 07:57:56 -0700
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="342406193"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 07:57:56 -0700
Message-ID: <5efe30658033c1b22a36438758236d4f4aa8c345.camel@linux.intel.com>
Subject: Re: [PATCH v1 0/6] mm / virtio: Provide support for paravirtual
 waste page treatment
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com
Date:   Mon, 15 Jul 2019 07:57:56 -0700
In-Reply-To: <91a0d964-7fb7-f25e-bf2b-6a7531b96afd@redhat.com>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
         <ff133df4-6291-bece-3d8d-dc3f12f398cf@redhat.com>
         <8fea71ba-2464-ead8-3802-2241805283cc@intel.com>
         <CAKgT0UdAj4Kq8qHKkaiB3z08gCQh-jovNpos45VcGHa_v5aFGg@mail.gmail.com>
         <bc4bb663-585b-bee0-1310-b149382047d0@intel.com>
         <91a0d964-7fb7-f25e-bf2b-6a7531b96afd@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2019-07-15 at 11:41 +0200, David Hildenbrand wrote:
> On 25.06.19 20:22, Dave Hansen wrote:
> > On 6/25/19 10:00 AM, Alexander Duyck wrote:
> > > Basically what we are doing is inflating the memory size we can report
> > > by inserting voids into the free memory areas. In my mind that matches
> > > up very well with what "aeration" is. It is similar to balloon in
> > > functionality, however instead of inflating the balloon we are
> > > inflating the free_list for higher order free areas by creating voids
> > > where the madvised pages were.
> > 
> > OK, then call it "free page auto ballooning" or "auto ballooning" or
> > "allocator ballooning".  s390 calls them "unused pages".
> > 
> > Any of those things are clearer and more meaningful than "page aeration"
> > to me.
> > 
> 
> Alex, if you want to generalize the approach, and not call it "hinting",
> what about something similar to "page recycling".
> 
> Would also fit the "waste" example and would be clearer - at least to
> me. Well, "bubble" does not apply anymore ...
> 

I am fine with "page hinting". I have already gone through and started the
rename. The problem with "page recycling" is that is actually pretty
similar to the name we had in the networking space for how the NICs will
recycle the Rx buffers.

For now I am going through and replacing instances of Aerated with Hinted,
and aeration with page_hinting. I should have a new patch set ready in a
couple days assuming no unforeseen issues.

Thanks.

- Alex

