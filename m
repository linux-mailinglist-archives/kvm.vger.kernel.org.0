Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D4F192BF1
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgCYPMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:12:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:41212 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbgCYPM3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 11:12:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585149148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BF8rpSmfd7uy+0GUmrMmaYfuGnMqUZoMQRMQpXoo6Oc=;
        b=Z0q/ZIywGvvqLaH+Leb9NNs7WD2PD1gxEry7n9hh8eDl90PurRd3G1RK2g8xct7kCMMYSL
        FqrFp/hL3dk1pU25YrO8wc2LUi5WUqAsbtZhXmYgMVKlNyRdOauPuErpCtJUb8VuB0eb4/
        z66tvVSa7uGqvZg7obQumdyzdrHMtPo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-7E13GZBFOGOnGI1r4WVdig-1; Wed, 25 Mar 2020 11:12:11 -0400
X-MC-Unique: 7E13GZBFOGOnGI1r4WVdig-1
Received: by mail-wr1-f71.google.com with SMTP id o18so1289313wrx.9
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 08:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BF8rpSmfd7uy+0GUmrMmaYfuGnMqUZoMQRMQpXoo6Oc=;
        b=b7QivK43XuL/VhFpPJUUMunfqdhLHk0HOcQY3pM+u7JiIFIE312CtHS9UhUsH98ISg
         yOqkaPyi8GrpIs0Mh7UmSb7OlR+te2ES/E/XvCsqGnOA0NVF4XazW8Ey+7785SJweEuv
         z7EqVR5Po/L3Lon39zdJUcc1XhpVzJ+Fft4GSzBkJbL+eKZldP3fKUqK6vfMxQwJpzZ0
         gDgTLobR8fTtPWRK7thaxZXXgoDzifm1ocM8mc8on/7R5QiOOddg1VvYe9nUulV48pr9
         qHTh3xf2WO92l2KKGDisEyhuCmlgYbOofpNC7NoPDwuDN6SjwLc5UdddmgVUpJOpREHJ
         RGwg==
X-Gm-Message-State: ANhLgQ0Vt+B0JbgfZMLC4AMEZlXA949GAvOLkIdl3Lt2LmbbIKl3sCoC
        5RaaHaxw4ezYJ0Krz8wyf3U3Y7eY2K+gPMgi690IOiuIBcsxrHQivQQGd6VWQo6tyE2M5HamJ6T
        3n5I+hXVFU9Ys
X-Received: by 2002:adf:82a6:: with SMTP id 35mr3958056wrc.307.1585149130644;
        Wed, 25 Mar 2020 08:12:10 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvJSAeAijCToDir/jXjYps+m1+WT66rSqwQyM4y5jMfMZPwTvoFMa55jDZ/hXUUp/cd520hqw==
X-Received: by 2002:adf:82a6:: with SMTP id 35mr3958028wrc.307.1585149130322;
        Wed, 25 Mar 2020 08:12:10 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id k126sm9743577wme.4.2020.03.25.08.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:12:09 -0700 (PDT)
Date:   Wed, 25 Mar 2020 11:12:05 -0400
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
Subject: Re: [PATCH v1 17/22] intel_iommu: do not pass down pasid bind for
 PASID #0
Message-ID: <20200325151205.GD354390@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-18-git-send-email-yi.l.liu@intel.com>
 <20200324181326.GB127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A201FC7@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A201FC7@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 25, 2020 at 10:42:25AM +0000, Liu, Yi L wrote:
> > From: Peter Xu < peterx@redhat.com>
> > Sent: Wednesday, March 25, 2020 2:13 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 17/22] intel_iommu: do not pass down pasid bind for PASID
> > #0
> > 
> > On Sun, Mar 22, 2020 at 05:36:14AM -0700, Liu Yi L wrote:
> > > RID_PASID field was introduced in VT-d 3.0 spec, it is used for DMA
> > > requests w/o PASID in scalable mode VT-d. It is also known as IOVA.
> > > And in VT-d 3.1 spec, there is definition on it:
> > >
> > > "Implementations not supporting RID_PASID capability (ECAP_REG.RPS is
> > > 0b), use a PASID value of 0 to perform address translation for
> > > requests without PASID."
> > >
> > > This patch adds a check against the PASIDs which are going to be bound
> > > to device. For PASID #0, it is not necessary to pass down pasid bind
> > > request for it since PASID #0 is used as RID_PASID for DMA requests
> > > without pasid. Further reason is current Intel vIOMMU supports gIOVA
> > > by shadowing guest 2nd level page table. However, in future, if guest
> > > IOMMU driver uses 1st level page table to store IOVA mappings, then
> > > guest IOVA support will also be done via nested translation. When
> > > gIOVA is over FLPT, then vIOMMU should pass down the pasid bind
> > > request for PASID #0 to host, host needs to bind the guest IOVA page
> > > table to a proper PASID. e.g PASID value in RID_PASID field for PF/VF
> > > if ECAP_REG.RPS is clear or default PASID for ADI (Assignable Device
> > > Interface in Scalable IOV solution).
> > >
> > > IOVA over FLPT support on Intel VT-d:
> > > https://lkml.org/lkml/2019/9/23/297
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
> > >  hw/i386/intel_iommu.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c index
> > > 1e0ccde..b007715 100644
> > > --- a/hw/i386/intel_iommu.c
> > > +++ b/hw/i386/intel_iommu.c
> > > @@ -1886,6 +1886,16 @@ static int vtd_bind_guest_pasid(IntelIOMMUState *s,
> > VTDBus *vtd_bus,
> > >      struct iommu_gpasid_bind_data *g_bind_data;
> > >      int ret = -1;
> > >
> > > +    if (pasid < VTD_MIN_HPASID) {
> > > +        /*
> > > +         * If pasid < VTD_HPASID_MIN, this pasid is not allocated
> > 
> > s/VTD_HPASID_MIN/VTD_MIN_HPASID/.
> 
> Got it.
> 
> > 
> > > +         * from host. No need to pass down the changes on it to host.
> > > +         * TODO: when IOVA over FLPT is ready, this switch should be
> > > +         * refined.
> > 
> > What will happen if without this patch?  Is it a must?
> 
> Before gIOVA is supported by nested translation, it is a must. This requires
> IOVA over 1st level page table is ready in guest kernel, also requires the
> QEMU/VFIO supports to bind the guest IOVA page table to host.
> Currently, guest kernel side is ready. However, QEMU and VFIO side is
> not.

OK:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

