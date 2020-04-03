Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EBF19DAF3
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 18:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403948AbgDCQLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 12:11:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26720 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403824AbgDCQL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 12:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585930288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=euLe8LsYBnPZG0Qe2AS2hMfw70OeheAVO3ddIA8WGx8=;
        b=FE/OOmpwuasptY9T5QYciY7y0roFKZ9bWfrkAATcvVYfcgmqEPdbKY4yg1nOsYvPmn2/27
        d1YDix6wAlE5LaZEBNBoMjRSWSbifjzbd+FMwOvVTOdKqTDV4Io5t3W0KL7VEW5t+DZm+z
        /9DybPMMtNPQCYzT3fDmxLjFY1jEcb8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-8tKIjvfiPsaBuSDXLhPDHw-1; Fri, 03 Apr 2020 12:11:27 -0400
X-MC-Unique: 8tKIjvfiPsaBuSDXLhPDHw-1
Received: by mail-wm1-f71.google.com with SMTP id e16so2246413wmh.5
        for <kvm@vger.kernel.org>; Fri, 03 Apr 2020 09:11:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=euLe8LsYBnPZG0Qe2AS2hMfw70OeheAVO3ddIA8WGx8=;
        b=GFiAtrj5ncMMdV24fqQb07Ke8Zhbamy3W56d5kawrttNL4r5VEGU/CsURTbq/9BJ1E
         oAsbuR0XrOOFuA2Zm7DcFygnfHpjL7lcD4eO6oTUV1StC3ixF0IDwO4yzXfH1N1fQV5S
         qAAIMFM7eL4JpsIyhllW/u7EZl/R7ggdm7pEZiXDg8SfqcthjGwNZhSTHmrGS3CgfaDn
         OTgtTX2p/0egH/M8c018N0D+BLD7O/Z6sqbJmN852xqYrF7u0pW43mVF3rWzI99nJB0M
         e14WK02GIt5I9PyB8VtVjyqabjxNcznAHY0bMLU0vNX8RW7aU6K4fWSWr1NjWoa7+P5+
         MPJw==
X-Gm-Message-State: AGi0PuYLJkgdWjs/me8IlOg9X0/E7miC+RDcxdbJN+F9I15CwgIKZOhY
        ubp6yHhD/Rt9zuD2CgzoSWroD3aMd4axriYqQR2ji73zGBhiWA0oWboWSbbWZUmKCZKcxnGIm7o
        rB61Uhl8adq01
X-Received: by 2002:a7b:cdf7:: with SMTP id p23mr1014969wmj.111.1585930286221;
        Fri, 03 Apr 2020 09:11:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypJIUgCEYS2IEjZ1+hA2TwQEfFKKDwrwFQdA4Bv7H2g7I9Ahi8qXO9yqjEYcPz3lj/W3lFFSfg==
X-Received: by 2002:a7b:cdf7:: with SMTP id p23mr1014938wmj.111.1585930285955;
        Fri, 03 Apr 2020 09:11:25 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::3])
        by smtp.gmail.com with ESMTPSA id s131sm12259015wmf.35.2020.04.03.09.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 09:11:25 -0700 (PDT)
Date:   Fri, 3 Apr 2020 12:11:20 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v2 16/22] intel_iommu: replay pasid binds after context
 cache invalidation
Message-ID: <20200403161120.GN103677@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-17-git-send-email-yi.l.liu@intel.com>
 <20200403144548.GK103677@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A220E44@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A220E44@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 03, 2020 at 03:21:10PM +0000, Liu, Yi L wrote:
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Friday, April 3, 2020 10:46 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v2 16/22] intel_iommu: replay pasid binds after context cache
> > invalidation
> > 
> > On Sun, Mar 29, 2020 at 09:24:55PM -0700, Liu Yi L wrote:
> > > This patch replays guest pasid bindings after context cache
> > > invalidation. This is a behavior to ensure safety. Actually,
> > > programmer should issue pasid cache invalidation with proper
> > > granularity after issuing a context cache invalidation.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Richard Henderson <rth@twiddle.net>
> > > Cc: Eduardo Habkost <ehabkost@redhat.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  hw/i386/intel_iommu.c          | 51
> > ++++++++++++++++++++++++++++++++++++++++++
> > >  hw/i386/intel_iommu_internal.h |  6 ++++-
> > >  hw/i386/trace-events           |  1 +
> > >  3 files changed, 57 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> > > index d87f608..883aeac 100644
> > > --- a/hw/i386/intel_iommu.c
> > > +++ b/hw/i386/intel_iommu.c
> > > @@ -68,6 +68,10 @@ static void
> > vtd_address_space_refresh_all(IntelIOMMUState *s);
> > >  static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n);
> > >
> > >  static void vtd_pasid_cache_reset(IntelIOMMUState *s);
> > > +static void vtd_pasid_cache_sync(IntelIOMMUState *s,
> > > +                                 VTDPASIDCacheInfo *pc_info);
> > > +static void vtd_pasid_cache_devsi(IntelIOMMUState *s,
> > > +                                  VTDBus *vtd_bus, uint16_t devfn);
> > >
> > >  static void vtd_panic_require_caching_mode(void)
> > >  {
> > > @@ -1853,7 +1857,10 @@ static void vtd_iommu_replay_all(IntelIOMMUState
> > *s)
> > >
> > >  static void vtd_context_global_invalidate(IntelIOMMUState *s)
> > >  {
> > > +    VTDPASIDCacheInfo pc_info;
> > > +
> > >      trace_vtd_inv_desc_cc_global();
> > > +
> > >      /* Protects context cache */
> > >      vtd_iommu_lock(s);
> > >      s->context_cache_gen++;
> > > @@ -1870,6 +1877,9 @@ static void
> > vtd_context_global_invalidate(IntelIOMMUState *s)
> > >       * VT-d emulation codes.
> > >       */
> > >      vtd_iommu_replay_all(s);
> > > +
> > > +    pc_info.flags = VTD_PASID_CACHE_GLOBAL;
> > > +    vtd_pasid_cache_sync(s, &pc_info);
> > >  }
> > >
> > >  /**
> > > @@ -2005,6 +2015,22 @@ static void
> > vtd_context_device_invalidate(IntelIOMMUState *s,
> > >                   * happened.
> > >                   */
> > >                  vtd_sync_shadow_page_table(vtd_as);
> > > +                /*
> > > +                 * Per spec, context flush should also followed with PASID
> > > +                 * cache and iotlb flush. Regards to a device selective
> > > +                 * context cache invalidation:
> > 
> > If context entry flush should also follow another pasid cache flush,
> > then this is still needed?  Shouldn't the pasid flush do the same
> > thing again?
> 
> yes, but how about guest software failed to follow it? It will do
> the same thing when pasid cache flush comes. But this only happens
> for the rid2pasid case (the IOVA page table).

Do you mean it will not happen when nested page table is used (so it's
required for nested tables)?

Yeah we can keep them for safe no matter what; at least I'm fine with
it (I believe most of the code we're discussing is not fast path).
Just want to be sure of it since if it's definitely duplicated then we
can instead drop it.

Thanks,

-- 
Peter Xu

