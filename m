Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0691A8FB9
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 02:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392386AbgDOAat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 20:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732629AbgDOAas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 20:30:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47F11206D9;
        Wed, 15 Apr 2020 00:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586910647;
        bh=jL66d2F3DmKs1s6SQQ+Gk7nBbbPMhZl6+fmVjYGZYK0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GPwWVfeCcSD4sp5mVFr9IDu41iwT/UEGE8CbjSF8HXKFDMv2LZp0R1EFTLZgTmfUY
         zrOhhvSS14vBZ2sye+oSCqGDhCp6DL1Qpf4iwi6WkQ2uEl5MsgOEAOo4LyS5RLvbLI
         RXpCxCZiweqq9m236ZzG6mYodR5MV59j5S5v24eU=
Date:   Tue, 14 Apr 2020 17:30:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.com>,
        Michal Hocko <mhocko@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH v2 07/10] mm/memory_hotplug: Introduce
 offline_and_remove_memory()
Message-Id: <20200414173046.dc097faf7062f76a8c68f580@linux-foundation.org>
In-Reply-To: <20200414123438-mutt-send-email-mst@kernel.org>
References: <20200311171422.10484-1-david@redhat.com>
        <20200311171422.10484-8-david@redhat.com>
        <156601a9-e919-b88f-2278-97ecee554d21@redhat.com>
        <20200414123438-mutt-send-email-mst@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Apr 2020 12:35:02 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Mar 11, 2020 at 06:19:04PM +0100, David Hildenbrand wrote:
> > On 11.03.20 18:14, David Hildenbrand wrote:
> > > virtio-mem wants to offline and remove a memory block once it unplugged
> > > all subblocks (e.g., using alloc_contig_range()). Let's provide
> > > an interface to do that from a driver. virtio-mem already supports to
> > > offline partially unplugged memory blocks. Offlining a fully unplugged
> > > memory block will not require to migrate any pages. All unplugged
> > > subblocks are PageOffline() and have a reference count of 0 - so
> > > offlining code will simply skip them.
> > > 
> > > All we need is an interface to offline and remove the memory from kernel
> > > module context, where we don't have access to the memory block devices
> > > (esp. find_memory_block() and device_offline()) and the device hotplug
> > > lock.
> > > 
> > > To keep things simple, allow to only work on a single memory block.
> > > 
> > 
> > Lost the ACK from Michael
> > 
> > Acked-by: Michal Hocko <mhocko@suse.com> [1]
> > 
> > [1] https://lkml.kernel.org/r/20200302142737.GP4380@dhcp22.suse.cz
> 
> 
> Andrew, could you pls ack merging this through the vhost tree,
> with the rest of the patchset?

I wish the device_offline() return value was documented :(

Yes, please go ahead and merge.

Acked-by: Andrew Morton <akpm@linux-foundation.org>

