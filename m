Return-Path: <kvm+bounces-68347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA61D37A15
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C38B13065E3E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3D83939BA;
	Fri, 16 Jan 2026 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="QuKoDwqp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2163348479
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768584056; cv=none; b=hGs8VQNCBY/hjaWdqxhN9qDtJ5mreJjEf3FTgLKmQevKYFJ3n3A8/SDLSXpcxTJA+nIQ8SN4ox6hl2tilCRDLN/ZQ8S487HAHMZ1vK7L5yChRkXddMZyeNqCdoldSWbcGp3XxSLmG4Mwg682lkv8E3dxRkI4fkEx6eRDvZH5yfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768584056; c=relaxed/simple;
	bh=490zkhRPTEVvWMTEcFUO0h1sLOGSaZthz/LSBKvRa+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ps8JeO7z6MJLaxOKdj0bwEffWpTQZjf6l7UefcZ/5A/IBtqFypZSUczNN5UZjS4eZXh6hnIZxT+99Ws0zrbgEmOfosnOi58eb64UZjCAv7dkN6zakY2s6APh2oASz8RLh89ktyvPsGgdVTR7jd0LrJpduOt9zoWsY11zbNbp1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=QuKoDwqp; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88a2f2e5445so27748776d6.1
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 09:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768584053; x=1769188853; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ke97Rr0JZ7eY7fCVBJ0MTKU0b1sPJJtx1nolStxn4zc=;
        b=QuKoDwqpq7rfVDLL63U7gs+6o6cUuw73iKJHUbroOh8zC+vPgWAaZtQI5/NlRs24Mw
         8dydbp/XwFplbaabTNWQZxg6yO/0rhWpWRvXvBtURfMn2kqj1Hxj0NIsDhusEE0AtOyv
         aixQBVVsO0HPa+z8eMZnQvsuFmEU5dtdnihlzNOHPXqNTJhR52WCkxRBZtWD+paHsKGr
         Wd0jSHgppclaWB3DuRJ2wpEuMmY8dwlkphThA1yVWf2337W0Eksq3FNCKzX3xbvw5IWd
         /6LwoTTe0p1oMq3PteX7uduxjRJtMGtx6RTBuTvNdYMUwycYov9MgerFrc5AI0Pr8BY/
         vEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768584053; x=1769188853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ke97Rr0JZ7eY7fCVBJ0MTKU0b1sPJJtx1nolStxn4zc=;
        b=W2HPJM2emhotBlU5nWj0cpHpMh1lRSuHDe0ZHtiw5NPlVvAqHl/oR8stE53CYNyJVr
         w+RvAfqPMS9ZDlZFYk/JFmfdkfayHvg+x1FnOrHVcpRuhZALS59FM12vYUi9+HCXaDbw
         bgEsnkjy6caqD2HCxOBtoYI8iwpM/UABN9JISWDFN1zLdgop/WicDnkbA4KMA1AHIGU+
         AdxgM3y+bHAsy8Ikx6DaXrCEfEMo9MSjZQ7SN4I3kPNJIFAbDCAEhvYnx0/wUEqd/EkX
         crmX11bIUAZEUsO8TNxl9COjgfBaTYRcKrpC/JgyS53KI5RJkuVNap+3cK6sU/hfOa08
         IV3w==
X-Forwarded-Encrypted: i=1; AJvYcCVY2hz/OvyBlfrszc8VlnK4TLOFhQMnZJU7aCVVlz9MqJa4X0jbhuoYcRhKNJdDOEHwqT4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTUiGtkZy5rv4m6MxRlnP79xAIEQoNic7C0YI6Ixeh6/5YuPuj
	2n3Jvm4WsqcaYup7TWNqrigJFRPWNliBetSz5lbNQDmlWpzSUCvpyBYANpLgOQ864mM=
X-Gm-Gg: AY/fxX6JXHDG6E/xKFdaZI2xOFh7YlhV4qtiYl4xV1YV6F28rKk4WvMzqtNGLDx+oDk
	gdDnYXoxwH41VzU9zMdCRLbLQ3s+i5I2zJZ3fmDgrrR9CHP59hVEEiP95ARJxXamiM0i5BPHiOp
	k9d1W8uT7K6ywQsq6nt9VLYlZoSn4GTd5G8Ve8/d67IobXUywoljcC2Vmeuep7ITObMJ9hRRUoe
	/J4kNTUsEvtsUiC9pf2oIZ9scnapSry4Pdis/fwkh7Iv1o0uJSGvvXhlqi7MQcuifYmpkeDrq/c
	8jVZvoLvnEg7rHOH4fkkxbBKRQiIe9Ps5neqTNwk7nz2sCQBq+3Vt0MwrcEEeuqREKMhC53MNV6
	pXTHdpGnerg4BHPqhqIZJDkrvPYiL4HngD1HCXDmlXrKtwc91OnGCtQrSBZ5bsxhWXVyAm+AWf+
	XcLfBpZju5e4CFMCkqs/EGVwM5USHh6Bv2XZC25hpf5xSSAQc9sxS7PSrktEoYFjnMx2E=
X-Received: by 2002:a05:6214:d08:b0:88a:529a:a543 with SMTP id 6a1803df08f44-8942e543175mr46699756d6.69.1768584053510;
        Fri, 16 Jan 2026 09:20:53 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6ad606sm26895826d6.33.2026.01.16.09.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 09:20:52 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vgnVE-00000004kb4-0KMs;
	Fri, 16 Jan 2026 13:20:52 -0400
Date: Fri, 16 Jan 2026 13:20:52 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	adhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Balbir Singh <balbirs@nvidia.com>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	nouveau@lists.freedesktop.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-ID: <20260116172052.GC961572@ziepe.ca>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
 <20260116111325.1736137-2-francois.dugast@intel.com>
 <ed6ca250-67ee-4f7a-bc3b-66169494549a@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed6ca250-67ee-4f7a-bc3b-66169494549a@suse.cz>

On Fri, Jan 16, 2026 at 05:07:09PM +0100, Vlastimil Babka wrote:
> On 1/16/26 12:10, Francois Dugast wrote:
> > From: Matthew Brost <matthew.brost@intel.com>
> > diff --git a/mm/memremap.c b/mm/memremap.c
> > index 63c6ab4fdf08..ac7be07e3361 100644
> > --- a/mm/memremap.c
> > +++ b/mm/memremap.c
> > @@ -477,10 +477,43 @@ void free_zone_device_folio(struct folio *folio)
> >  	}
> >  }
> >  
> > -void zone_device_page_init(struct page *page, unsigned int order)
> > +void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
> > +			   unsigned int order)
> >  {
> > +	struct page *new_page = page;
> > +	unsigned int i;
> > +
> >  	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
> >  
> > +	for (i = 0; i < (1UL << order); ++i, ++new_page) {
> > +		struct folio *new_folio = (struct folio *)new_page;
> > +
> > +		/*
> > +		 * new_page could have been part of previous higher order folio
> > +		 * which encodes the order, in page + 1, in the flags bits. We
> > +		 * blindly clear bits which could have set my order field here,
> > +		 * including page head.
> > +		 */
> > +		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
> > +
> > +#ifdef NR_PAGES_IN_LARGE_FOLIO
> > +		/*
> > +		 * This pointer math looks odd, but new_page could have been
> > +		 * part of a previous higher order folio, which sets _nr_pages
> > +		 * in page + 1 (new_page). Therefore, we use pointer casting to
> > +		 * correctly locate the _nr_pages bits within new_page which
> > +		 * could have modified by previous higher order folio.
> > +		 */
> > +		((struct folio *)(new_page - 1))->_nr_pages = 0;
> > +#endif
> > +
> > +		new_folio->mapping = NULL;
> > +		new_folio->pgmap = pgmap;	/* Also clear compound head */
> > +		new_folio->share = 0;   /* fsdax only, unused for device private */
> > +		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
> > +		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
> > +	}
> > +
> >  	/*
> >  	 * Drivers shouldn't be allocating pages after calling
> >  	 * memunmap_pages().
> 
> Can't say I'm a fan of this. It probably works now (so I'm not nacking) but
> seems rather fragile. It seems likely to me somebody will try to change some
> implementation detail in the page allocator and not notice it breaks this,
> for example. I hope we can eventually get to something more robust.

These pages shouldn't be in the buddy allocator at all? The driver
using the ZONE_DEVICE pages is responsible to provide its own
allocator.

Did you mean something else?

Jason
 

