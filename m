Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4F364FBF
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 03:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfGKBEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 21:04:01 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36120 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfGKBEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 21:04:01 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so2097142plt.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 18:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fD6QrnL9oHHFPFtLusHVcNMqwsdqi93+7m3pWRWe2s8=;
        b=OmREyHE/vS8RACDp7nfPVFJxeMo6n+DhbQRwh/70hPM6ZhmkIsNdg6xYzjzLNcVmra
         7Io9wc9iD2ymuSg/I6kkwUpB/wgZGNtPc9SJ9xjbQV2aV72iZ6zNAhBQtnen9ryhQS7c
         b4Q4AihV7Pq18F3eHJZFnkCfnABIi724FZWb0XJ5KiatdQAeq13W3x2k4fVuG+fR0Ud1
         jO1NdbxIsC3g2Hqfl24YMT3b+0Ca5GnxM1m9rHVZLGpHdfKBi6TDTbHeEmxo4cTt+dpl
         fDwdazfazJt/NzEQGjSQNT9JRBjwqcuutdcFsK9em+6cOVHiAp5ssrRHw9cFDNqLuVFT
         ebqA==
X-Gm-Message-State: APjAAAW427WQjZZiOEMqTkHGHvF0W2Ssd95Ud3SghEUBo7BnebRGf2ae
        UKlvF6gEWrExoTxMxUhnWNx7pw==
X-Google-Smtp-Source: APXvYqyCzj3Ow36pVMoJgAeUfO45i99Sl9Gp3cv1U5/TSFiHBQCKnNYZufh1nW0FOEG9+pSu6ATocA==
X-Received: by 2002:a17:902:76c7:: with SMTP id j7mr886064plt.247.1562807040379;
        Wed, 10 Jul 2019 18:04:00 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 195sm4114394pfu.75.2019.07.10.18.03.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 18:03:58 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Thu, 11 Jul 2019 09:03:47 +0800
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Peter Xu <zhexu@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "tianyu.lan@intel.com" <tianyu.lan@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 04/18] intel_iommu: add "sm_model" option
Message-ID: <20190711010347.GI5178@xz-x1>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-5-git-send-email-yi.l.liu@intel.com>
 <20190709021554.GB5178@xz-x1>
 <A2975661238FB949B60364EF0F2C257439F2A6D3@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C257439F2A6D3@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 12:14:44PM +0000, Liu, Yi L wrote:
> > From: Peter Xu [mailto:zhexu@redhat.com]
> > Sent: Tuesday, July 9, 2019 10:16 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v1 04/18] intel_iommu: add "sm_model" option
> > 
> > On Fri, Jul 05, 2019 at 07:01:37PM +0800, Liu Yi L wrote:
> > > Intel VT-d 3.0 introduces scalable mode, and it has a bunch of
> > > capabilities related to scalable mode translation, thus there
> > > are multiple combinations. While this vIOMMU implementation
> > > wants simplify it for user by providing typical combinations.
> > > User could config it by "sm_model" option. The usage is as
> > > below:
> > >
> > > "-device intel-iommu,x-scalable-mode=on,sm_model=["legacy"|"scalable"]"
> > 
> > Is it a requirement to split into two parameters, instead of just
> > exposing everything about scalable mode when x-scalable-mode is set?
> 
> yes, it is. Scalable mode has multiple capabilities. And we want to support
> the most typical combinations to simplify software. e.g. current scalable mode
> vIOMMU exposes only 2nd level translation to guest, and guest IOVA support
> is via shadowing guest 2nd level page table. We have plan to move IOVA from
> 2nd level page table to 1st level page table, thus guest IOVA can be supported
> with nested translation. And this also addresses the co-existence issue of guest
> SVA and guest IOVA. So in future we will have scalable mode vIOMMU expose
> 1st level translation only. To differentiate this config with current vIOMMU,
> we need an extra option to control it. But yes, it is still scalable mode vIOMMU.
> just has different capability exposed to guest.

I see.  Thanks for explaining.

> 
> BTW. do you know if I can add sub-options under "x-scalable-mode"? I think
> that may demonstrate the dependency better.

I'm not an expert of that, but I think at least we can make it a
string parameter depends on what you prefer, then we can do
"x-scalable-mode=legacy|modern".  Or keep this would be fine too.

> 
> > >
> > >  - "legacy": gives support for SL page table
> > >  - "scalable": gives support for FL page table, pasid, virtual command
> > >  - default to be "legacy" if "x-scalable-mode=on while no sm_model is
> > >    configured
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > > ---
> > >  hw/i386/intel_iommu.c          | 28 +++++++++++++++++++++++++++-
> > >  hw/i386/intel_iommu_internal.h |  2 ++
> > >  include/hw/i386/intel_iommu.h  |  1 +
> > >  3 files changed, 30 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> > > index 44b1231..3160a05 100644
> > > --- a/hw/i386/intel_iommu.c
> > > +++ b/hw/i386/intel_iommu.c
> > > @@ -3014,6 +3014,7 @@ static Property vtd_properties[] = {
> > >      DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode,
> > FALSE),
> > >      DEFINE_PROP_BOOL("x-scalable-mode", IntelIOMMUState, scalable_mode,
> > FALSE),
> > >      DEFINE_PROP_BOOL("dma-drain", IntelIOMMUState, dma_drain, true),
> > > +    DEFINE_PROP_STRING("sm_model", IntelIOMMUState, sm_model),
> > 
> > Can do 's/-/_/' to follow the rest if we need it.
> 
> Do you mean sub-options after "x-scalable-mode"?

No, I only mean "sm-model". :)

Regards,

-- 
Peter Xu
