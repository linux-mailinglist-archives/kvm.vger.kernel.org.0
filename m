Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1A6191387
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 15:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgCXOqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 10:46:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:34093 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbgCXOqE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 10:46:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585061163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HJt9mIvAgLVdLWEY0GDl93Plvr0uiaSZhoPdCdZCYdw=;
        b=K4Z+NEpmisi+iynUPDFtRJCCaAh80HX34drmy/RIx53PZejz0AXRA9Yfz8zzMDjznt/XND
        ODEYEFSHdEDN1QiOmehZMJL4hYBLPuGnBH3EEiRN/b6R9VMV6amm19hlg30ra99g/OmVPV
        NAZg+d1u5xhhpktUeWrxJsdXst+S0/8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-MJFEIMSAOgOUa_YJTKIhdQ-1; Tue, 24 Mar 2020 10:45:59 -0400
X-MC-Unique: MJFEIMSAOgOUa_YJTKIhdQ-1
Received: by mail-wr1-f72.google.com with SMTP id e10so6580394wrm.2
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 07:45:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HJt9mIvAgLVdLWEY0GDl93Plvr0uiaSZhoPdCdZCYdw=;
        b=UrNVGV2yT4vR2LO/GWMDon5kGrngCU0YgAWkcZ4wMx8DHA2emChM53VqcAGwp7j7EZ
         cdgiRM6QUHU9BN+WtFBYzaLAc0zycLaoEtBSvpKzzPaw4hHR+Tk6zzPfWx2CR8wEKctF
         mezdaShomY8eXa5iv5omrL3rxl3MKgHYCR6+GAtlv0Fn4W8jYzjhLTUx4CSw5hKRMrr+
         3MVZQVoDSIQfTKmtRczbRC4T7GOKJbVoWC5nbVDezLiSZ7OXdEgYKzenoH5OBZ+nm0cx
         IIeemnEZu7mCWvzBX/rZW7LiM4wlVVeVkm/9LbZsIE5tFajkXIhjzn5vgWo6gSpoWfa1
         oCCA==
X-Gm-Message-State: ANhLgQ24bY19VqOkLuVbUeiFglw2nejXEDytFbF8teTUyPF0JMkndx0e
        l+vNkMDsd03e/coSw0zhchdcL5AiXAEhHp0ZNAbZoxXrYqV2yLcntXg9q5W/emrQEC2qyDBnVFo
        WNCV0Ef8vvFCx
X-Received: by 2002:a7b:c189:: with SMTP id y9mr5703987wmi.47.1585061158241;
        Tue, 24 Mar 2020 07:45:58 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu3gn+H/ovKrBwuieprSiD/Bt+3YN3Wqy5eSJ0ZzLpDcEbr5d4ayWoIJreCQgp2R23siVAHqg==
X-Received: by 2002:a7b:c189:: with SMTP id y9mr5703971wmi.47.1585061158024;
        Tue, 24 Mar 2020 07:45:58 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id k9sm30312702wrd.74.2020.03.24.07.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 07:45:57 -0700 (PDT)
Date:   Tue, 24 Mar 2020 10:45:53 -0400
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
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v1 08/22] vfio: init HostIOMMUContext per-container
Message-ID: <20200324144553.GU127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-9-git-send-email-yi.l.liu@intel.com>
 <20200323213943.GR127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A2006A9@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A2006A9@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 01:03:28PM +0000, Liu, Yi L wrote:
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Tuesday, March 24, 2020 5:40 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 08/22] vfio: init HostIOMMUContext per-container
> > 
> > On Sun, Mar 22, 2020 at 05:36:05AM -0700, Liu Yi L wrote:
> > > After confirming dual stage DMA translation support with kernel by
> > > checking VFIO_TYPE1_NESTING_IOMMU, VFIO inits HostIOMMUContet instance
> > > and exposes it to PCI layer. Thus vIOMMU emualtors may make use of
> > > such capability by leveraging the methods provided by HostIOMMUContext.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > Cc: David Gibson <david@gibson.dropbear.id.au>
> > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  hw/vfio/common.c                      | 80 +++++++++++++++++++++++++++++++++++
> > >  hw/vfio/pci.c                         | 13 ++++++
> > >  include/hw/iommu/host_iommu_context.h |  3 ++
> > >  include/hw/vfio/vfio-common.h         |  4 ++
> > >  4 files changed, 100 insertions(+)
> > >
> > > diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> > > index c276732..e4f5f10 100644
> > > --- a/hw/vfio/common.c
> > > +++ b/hw/vfio/common.c
> > > @@ -1179,10 +1179,55 @@ static int vfio_get_iommu_type(VFIOContainer
> > *container,
> > >      return -EINVAL;
> > >  }
> > >
> > > +static int vfio_host_icx_pasid_alloc(HostIOMMUContext *host_icx,
> > 
> > I'm not sure about Alex, but ... icx is confusing to me.  Maybe "ctx"
> > as you always used?
> 
> At first I used vfio_host_iommu_ctx_pasid_alloc(), found it is long, so I
> switched to "icx" which means iommu_context. Maybe the former one
> looks better as it gives more precise info.

vfio_host_iommu_ctx_pasid_alloc() isn't that bad imho.  I'll omit the
"ctx" if I want to make it even shorter, but "icx" might be ambiguous.

Thanks,

-- 
Peter Xu

