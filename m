Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6850D159CB6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBKW5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:57:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:7940 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727199AbgBKW5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:57:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 14:57:47 -0800
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="251710669"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 14:57:47 -0800
Message-ID: <17f2a84522bbbf920b0a34344829df10b89b249e.camel@linux.intel.com>
Subject: Re: Should I repost? (was: Re: [PATCH v16.1 0/9] mm / virtio:
 Provide support for free page reporting)
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     akpm@linux-foundation.org, david@redhat.com,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de,
        vbabka@suse.cz, AlexanderDuyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org
Date:   Tue, 11 Feb 2020 14:57:47 -0800
In-Reply-To: <20200211104041.GK3466@techsingularity.net>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
         <6758b1e3373fc06b37af1c87901237974d52322f.camel@linux.intel.com>
         <d943ada56babfbebf408ad0f94988a5b09d2b472.camel@linux.intel.com>
         <20200211104041.GK3466@techsingularity.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-02-11 at 10:40 +0000, Mel Gorman wrote:
> On Mon, Feb 10, 2020 at 11:18:59AM -0800, Alexander Duyck wrote:
> > > So I thought I would put out a gentle nudge since it has been about 4
> > > weeks since v16 was submitted, a little over a week and a half for v16.1,
> > > and I have yet to get any feedback on the code contained in the patchset.
> > > Codewise nothing has changed from the v16 patchset other than rebasing it
> > > off of the linux-next tree to resolve some merge conflicts that I saw
> > > recently, and discussion around v16.1 was mostly about next steps and how
> > > to deal with the page cache instead of discussing the code itself.
> > > 
> > > The full patchset can be found at:
> > > https://lore.kernel.org/lkml/20200122173040.6142.39116.stgit@localhost.localdomain/
> > > 
> > > I believe I still need review feedback for patches 3, 4, 7, 8, and 9.
> > > 
> > > Thanks.
> > > 
> > > - Alex
> > 
> > So I had posted this patch set a few days before Linus's merge window
> > opened. When I posted it the discussion was about what the follow-up on
> > this patch set will be in terms of putting pressure on the page cache to
> > force it to shrink. However I didn't get any review comments on the code
> > itself.
> > 
> > My last understanding on this patch set is that I am waiting on patch
> > feedback from Mel Gorman as he had the remaining requests that led to most
> > of the changes in v15 and v16. I believe I have addressed them, but I
> > don't believe he has had a chance to review them.
> > 
> > I am wondering now if it is still possible to either get it reviewed
> > and/or applied without reposting, or do I need to repost it since it has
> > been several weeks since I submitted it? The patch set still applies to
> > the linux-next tree without any issues.
> > 
> 
> Please repost to take into account that this is confirmed to be working
> as expected after the merge window and has not conflicted with anything
> else that got merged in the meantime. This fell off my radar because of the
> timing when it was posted and the volume of mail I was receiving. I simply
> noted a large amount of traffic in response to the series and assumed
> others had issues that would get resolved without looking closely. Now
> I see that it was all comments on future work instead of the series itself.
> 
> Sorry.
> 

No problem.

I have reposted as v17. I made a slight tweak to the cover page, rebased
on today's linux-next and QEMU, rebuilt and reran some of the tests to
verify the functionality and performance are still running about the same.

The full patch set with QEMU patches can be found here:
https://lore.kernel.org/lkml/20200211224416.29318.44077.stgit@localhost.localdomain/

Thanks.

- Alex

