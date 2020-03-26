Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCF1193FA1
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 14:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgCZNXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 09:23:02 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:57022 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbgCZNXC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 09:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585228980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3D6txT8FsGjiCL0WkA4M4TFIY+W1PhEo7/Tm5hHY34U=;
        b=a58ILgkBrw77jLrMc7h4zx9DLpSMlC7B5QlFoI1MHoVdgCNGKKQS7Y1FEc7zwxWCLfQo6W
        ZRDPUSFDqwyOEQrGLl8hs8teLNXxxxU5KXmt/udB3akjEzuiPQqTS2Wgqa33LHscg1RHYx
        O68DKoKvhtLSoJfVP2hXMpc0Z4WXHdM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-asYeuCwBM266oP_igR342g-1; Thu, 26 Mar 2020 09:22:56 -0400
X-MC-Unique: asYeuCwBM266oP_igR342g-1
Received: by mail-wm1-f69.google.com with SMTP id p18so2439572wmk.9
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 06:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3D6txT8FsGjiCL0WkA4M4TFIY+W1PhEo7/Tm5hHY34U=;
        b=bOq6B1twyz3j+PzKnX/TBw5YgPw4tmDnfJzukmXGJs9uVJnU8PVlj9OMvlbTKNDuCJ
         PopGrSnfKugLX3Ic9QcXUYkALr9OznOu7lAwk6YKGoolFLn2oPTA2zseSpckB4RA8XkN
         UY1WFey4SEFvjceXVFolkhlXSoGdevQYz1+lWEgAt2CWFSXr/pkX+XiRNhAF5YPy0yTU
         pnxf7hjd6m9YVOdFlPhOxDG8dxw+RgbkjWlf36TJssXLHGzU7ImmRAaD63RklVvkG3UQ
         l2RiPr5CLxnGdYnXVSOm9O3oBMUY2z54wFvShSGQXxzzPexGq3r2nGX3ZWmp7haAApob
         852A==
X-Gm-Message-State: ANhLgQ1S1GadWCRN4U/5jkUsy5iUsT5zaxjjifA6LC49H4rnTP+SqMtX
        xH3pm+YWZNocqgbIgJOGUih6mw5CoRkfCVFEOg289YuysjYAE92vFjm7QdewfPV1tzoH/0lo7lh
        ttbRUKjTUXDw9
X-Received: by 2002:a05:600c:54d:: with SMTP id k13mr3085534wmc.161.1585228975693;
        Thu, 26 Mar 2020 06:22:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvv6AgL3h/3IT7RwFTgMkWnM/cyySnuKTkNfF59iq3XGQCm+l4821ZVZ8Fyav2c/CafSCTZWg==
X-Received: by 2002:a05:600c:54d:: with SMTP id k13mr3085519wmc.161.1585228975490;
        Thu, 26 Mar 2020 06:22:55 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id j188sm3626230wmj.36.2020.03.26.06.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 06:22:54 -0700 (PDT)
Date:   Thu, 26 Mar 2020 09:22:50 -0400
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
Subject: Re: [PATCH v1 20/22] intel_iommu: propagate PASID-based iotlb
 invalidation to host
Message-ID: <20200326132250.GC422390@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-21-git-send-email-yi.l.liu@intel.com>
 <20200324183423.GE127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A2022C5@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A203E63@SHSMSX104.ccr.corp.intel.com>
 <20200326130248.GB422390@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200326130248.GB422390@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 09:02:48AM -0400, Peter Xu wrote:

[...]

> > > > > +static inline bool vtd_pasid_cache_valid(
> > > > > +                          VTDPASIDAddressSpace *vtd_pasid_as) {
> > > > > +    return vtd_pasid_as->iommu_state &&
>                     ^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> > > >
> > > > This check can be dropped because always true?
> > > >
> > > > If you agree with both the changes, please add:
> > > >
> > > > Reviewed-by: Peter Xu <peterx@redhat.com>
> > > 
> > > I think the code should ensure all the pasid_as in hash table is valid. And we can
> > > since all the operations are under protection of iommu_lock.
> > > 
> > Peter,
> > 
> > I think my reply was wrong. pasid_as in has table may be stale since
> > the per pasid_as cache_gen may be not identical with the cache_gen
> > in iommu_state. e.g. vtd_pasid_cache_reset() only increases the
> > cache_gen in iommu_state. So there will be pasid_as in hash table
> > which has cached pasid entry but its cache_gen is not equal to the
> > one in iommu_state. For such pasid_as, we should treat it as stale.
> > So I guess the vtd_pasid_cache_valid() is still necessary.
> 
> I guess you misread my comment. :)
> 
> I was saying the "vtd_pasid_as->iommu_state" check is not needed,
> because iommu_state was always set if the address space is created.
> vtd_pasid_cache_valid() is needed.
> 
> Also, please double confirm that vtd_pasid_cache_reset() should drop
> all the address spaces (as I think it should), not "only increase the
> cache_gen".  IMHO you should only increase the cache_gen in the PSI
> hook (vtd_pasid_cache_psi()) only.

Sorry, I mean GSI (vtd_pasid_cache_gsi), not PSI.

-- 
Peter Xu

