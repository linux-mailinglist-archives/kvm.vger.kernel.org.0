Return-Path: <kvm+bounces-68145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E46D7D22292
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 03:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 69C49300B9D9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AE227CB04;
	Thu, 15 Jan 2026 02:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vfb3gBTf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656C42517B9;
	Thu, 15 Jan 2026 02:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768444845; cv=none; b=Y+i20T8OTud1Vl2ASSzREVcy5PbTADO9b08a2b6Qdg0hGf9rp7R0ynelW7l0RT+qLIz8E/Z4WUX68uRAx93Q+b232zOwCPwDc1gDNshJtVAr+0e9OawTRSzXKom6PiIxYv8a45HGeuWUf74UgfF/z5SMXezpRZoe430sgcQ9GSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768444845; c=relaxed/simple;
	bh=kEIihbTO7hsA7HfHf64JRGq8WxboK1l9W0XcXEHbfeo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=lzkFdA9plvYoEasYe/DQyuO416tOvZQLacGiUpD1OsjNK6OO7SF7kdTStBf4LoJ0xxSw6Pma77gIVsCKmWE9mOZNlF8KCuyAmTIVYbI7vqerxAjs6PXxcxh8S28ZgjbR4BuZFA6QQrT+2jrL0mWN/elzhUFw2h59wPSxi6yKoG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vfb3gBTf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4C2C4CEF7;
	Thu, 15 Jan 2026 02:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768444844;
	bh=kEIihbTO7hsA7HfHf64JRGq8WxboK1l9W0XcXEHbfeo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Vfb3gBTf+rsrpPAPcJ/Dig6SSOOLelLK4b09yec6FTVrBjTNJT3KBH/W/IuyCOUUG
	 rWCMabju6IaOer0i0XS9FstGNEW6IG96OZlxk9eDNmuYljuhHuOo2Q6G5GIosWUK/o
	 TtHClSrBGTI6P5GEFzOrr+RjoUt0V7nWJ0JUctS8=
Date: Wed, 14 Jan 2026 18:40:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>,
 <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, Zi Yan
 <ziy@nvidia.com>, Alistair Popple <apopple@nvidia.com>, adhavan Srinivasan
 <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Michael
 Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
 <dakr@kernel.org>, "David Hildenbrand" <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Balbir Singh"
 <balbirs@nvidia.com>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <amd-gfx@lists.freedesktop.org>, <nouveau@lists.freedesktop.org>,
 <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v5 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-Id: <20260114184042.64fc3df3e43e6e62870bb705@linux-foundation.org>
In-Reply-To: <aWgr9Fp+0AeTu4zL@lstrano-desk.jf.intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
	<20260114192111.1267147-2-francois.dugast@intel.com>
	<20260114134825.8bf1cb3e897c8e41c73dc8ae@linux-foundation.org>
	<aWgn/THidvOQf9n2@lstrano-desk.jf.intel.com>
	<aWgr9Fp+0AeTu4zL@lstrano-desk.jf.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 14 Jan 2026 15:51:16 -0800 Matthew Brost <matthew.brost@intel.com> wrote:

> On Wed, Jan 14, 2026 at 03:34:21PM -0800, Matthew Brost wrote:
> > On Wed, Jan 14, 2026 at 01:48:25PM -0800, Andrew Morton wrote:
> > > On Wed, 14 Jan 2026 20:19:52 +0100 Francois Dugast <francois.dugast@intel.com> wrote:
> > > 
> > > > Reinitialize metadata for large zone device private folios in
> > > > zone_device_page_init prior to creating a higher-order zone device
> > > > private folio. This step is necessary when the folio’s order changes
> > > > dynamically between zone_device_page_init calls to avoid building a
> > > > corrupt folio. As part of the metadata reinitialization, the dev_pagemap
> > > > must be passed in from the caller because the pgmap stored in the folio
> > > > page may have been overwritten with a compound head.
> > > 
> > > Thanks.  What are the worst-case userspace-visible effects of the bug?
> > 
> > If you reallocate a subset of pages from what was originally a large
> > device folio, the pgmap mapping becomes invalid because it was
> > overwritten by the compound head, and this can crash the kernel.
> > 
> > Alternatively, consider the case where the original folio had an order
> > of 9 and _nr_pages was set. If you then reallocate the folio plus one as
> 
> s/_nr_pages/the order was encoded the page flags.
> 
> ...
>
> s/best to have kernel/best to not have kernels
> 

Great, thanks.  I pasted all the above into the changelog to help
explain our reasons.  I'll retain the patch in mm-hotfixes, targeting
6.19-rcX.  The remainder of the series is DRM stuff, NotMyProblem.  I
assume that getting this into 6.19-rcX is helpful to DRM - if not, and
if taking this via the DRM tree is preferable then let's discuss.

Can reviewers please take a look at this reasonably promptly?


btw, this patch uses

+		struct folio *new_folio = (struct folio *)new_page;

Was page_folio() unsuitable?


