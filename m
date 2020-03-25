Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E85192BD8
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgCYPGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:06:45 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:48170 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727642AbgCYPGo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 11:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585148803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FAab9/HeMr7kMt5AjMuUFNn2lljVsGjPi5izW+gN+7c=;
        b=DxOxkkkWi3GQT79jwnTxKSbRWM/9fYYmKwVIlOJB8E71ANBCWTICwf4fLKmfdLUcIQfwFy
        vkCuoQ6dCO22b3FrORqMByMoYtI55o3mcNRRNocjKasuICjCK+gtlJkrzFntZAQMabbJj2
        n2LN6w0oCZM7ItWzGDI7+tEn2i39YSI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-da23c1xbMN-3j7W5msRqBw-1; Wed, 25 Mar 2020 11:06:42 -0400
X-MC-Unique: da23c1xbMN-3j7W5msRqBw-1
Received: by mail-wr1-f71.google.com with SMTP id f15so1293100wrt.4
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 08:06:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FAab9/HeMr7kMt5AjMuUFNn2lljVsGjPi5izW+gN+7c=;
        b=AH6knuOlA3wFWH2SBTGWS4Yc8d413tnbxqQBcBC18u5U+KxtM2jasUEheCEBFe8uQA
         l2NttSUxyuYfx+HVXbzbLBI5jf/A77oxNUX0idrBI1lmjhI3ZeHNDDFo2HovDBqwmxr2
         iLm1yZL89lqFIyoGrgd0oLQVgj3wwe6tKWWUnr0sLk8m9i5QOG8PWXpJGkLv93IWWDi+
         bz6ndBIz4Fwh+L7BajcVmUbK5P3GpqtVjiTSOHk1BURJxejH6TGA3msDSfjxnpuXoLJS
         xiAiR8IOKWT7ZIioPGGk35Jgumi0lrpF0b4Skx37OI3sc/Vv8eqX0wucCgpdIlV30FeS
         y4Hg==
X-Gm-Message-State: ANhLgQ3fSs/GPxGGNiZSiDy1NASTaZ0y9AxfydwG1o2jyfd3vGY8COQK
        tLjvUZ01HQFij+Bnpw/ses/hPP3vBC8W1fpc8SXppQnRF0pab+JOTuNQLocE0tNVPL36jcHEpkt
        XeQJEKCOGXecY
X-Received: by 2002:adf:b641:: with SMTP id i1mr3983429wre.18.1585148799873;
        Wed, 25 Mar 2020 08:06:39 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt5ETVSo8dR+R+7i8SSLf/LUWWs9NXlkdrJEmQOHyPVXPwdmfg86Sy0hcGgWkpOc6gB33aZuA==
X-Received: by 2002:adf:b641:: with SMTP id i1mr3983412wre.18.1585148799682;
        Wed, 25 Mar 2020 08:06:39 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w204sm9654772wma.1.2020.03.25.08.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:06:39 -0700 (PDT)
Date:   Wed, 25 Mar 2020 11:06:34 -0400
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
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v1 15/22] intel_iommu: replay guest pasid bindings to host
Message-ID: <20200325150634.GC354390@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-16-git-send-email-yi.l.liu@intel.com>
 <20200324180013.GZ127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A202251@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A202251@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 25, 2020 at 01:14:26PM +0000, Liu, Yi L wrote:

[...]

> > > +/**
> > > + * Caller of this function should hold iommu_lock.
> > > + */
> > > +static bool vtd_sm_pasid_table_walk_one(IntelIOMMUState *s,
> > > +                                        dma_addr_t pt_base,
> > > +                                        int start,
> > > +                                        int end,
> > > +                                        vtd_pasid_table_walk_info *info)
> > > +{
> > > +    VTDPASIDEntry pe;
> > > +    int pasid = start;
> > > +    int pasid_next;
> > > +    VTDPASIDAddressSpace *vtd_pasid_as;
> > > +    VTDPASIDCacheEntry *pc_entry;
> > > +
> > > +    while (pasid < end) {
> > > +        pasid_next = pasid + 1;
> > > +
> > > +        if (!vtd_get_pe_in_pasid_leaf_table(s, pasid, pt_base, &pe)
> > > +            && vtd_pe_present(&pe)) {
> > > +            vtd_pasid_as = vtd_add_find_pasid_as(s,
> > > +                                       info->vtd_bus, info->devfn, pasid);
> > 
> > For this chunk:
> > 
> > > +            pc_entry = &vtd_pasid_as->pasid_cache_entry;
> > > +            if (s->pasid_cache_gen == pc_entry->pasid_cache_gen) {
> > > +                vtd_update_pe_in_cache(s, vtd_pasid_as, &pe);
> > > +            } else {
> > > +                vtd_fill_in_pe_in_cache(s, vtd_pasid_as, &pe);
> > > +            }
> > 
> > We already got &pe, then would it be easier to simply call:
> > 
> >                vtd_update_pe_in_cache(s, vtd_pasid_as, &pe);
> > 
> > ?
> 
> If the pasid_cache_gen is equal to iommu_state's, then it means there is
> a chance that the cached pasid entry is equal to pe here. While for the
> else case, it is surely there is no valid pasid entry in the pasid_as. And
> the difference between vtd_update_pe_in_cache() and
> vtd_fill_in_pe_in_cache() is whether do a compare between the new pasid entry
> and cached pasid entry.
> 
> > Since IIUC the cache_gen is only helpful to avoid looking up the &pe.
> > And the vtd_pasid_entry_compare() check should be even more solid than
> > the cache_gen.
> 
> But if the cache_gen is not equal the one in iommu_state, then the cached
> pasid entry is not valid at all. The compare is only needed after the cache_gen
> is checked.

Wait... If "the pasid entry context" is already exactly the same as
the "cached pasid entry context", why we still care the generation
number?  I'd just update the generation to latest and cache it again.
Maybe there's a tricky point when &pe==cache but generation number is
old, then IIUC what we can do better is simply update the generation
number to latest.

But OK - let's keep that.  I don't see anything incorrect with current
code either.

-- 
Peter Xu

