Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B25222790
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 17:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgGPPkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 11:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbgGPPkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 11:40:15 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5603BC061755
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 08:40:14 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rk21so7039650ejb.2
        for <kvm@vger.kernel.org>; Thu, 16 Jul 2020 08:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R0hixZr2FmuyDxkOlsaDyB/rdEVS5zH7ZB3SMwB7SjA=;
        b=hD6l8n5tJJDWItbmnePOZqH87rq9e8eH4kwTJjei+YlKoq+eZA6TxVUrekVxY7d3Wr
         sq4TgU+k4PJIOwlPET6TC8b7a9T4l6guHNgOwJ7s8lXuIodZrVm/mBol4m6qXC6pQ0ke
         jeORpF49hRiPTmT1zhAXpBOAXLldbfNj5a9MlouXOr6XopKltk2mbMZsdGW9QZMY0gRu
         7xKMEt2jKEN1zJWRtNGVQkRz3m785A0bjhgt91N4O1BYoxq8DN37CVavlMU9yBvS2V4w
         YVfk76wli+I2fBBGwyHwxH+LsW0iXasq9FkxBsWT+Rgjw6oevIZko/T6J7+ORXQl53Yg
         SKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R0hixZr2FmuyDxkOlsaDyB/rdEVS5zH7ZB3SMwB7SjA=;
        b=uI5E+MP76dnXneeHL3nI8jDabq3WDLHafzALdqBmCv3QeInAkelkH+qqSpL4RG9CBY
         r5dD4OodCXuEF40GDZmUfkKr+cKRO/jXe06fslrc+iH6FL0uTmCHnSccb43sJO68WhsI
         vgSsSgCzS/KeIR18OuQZ98LehAOsHVmYEa0GOWxDmJBHL5QGdRFS4VsLzSHgUMttnAlU
         j5bdDR02E8VbsOZNVwwY5POX0NeAmo2ot0kbNJj39bC6zIj3c0nVTxOXM/FyF484F3OC
         JMSRlSHkNsZZ29Nh42TpzqNnbeoJC4ObpktMSWCzAYSIz79APVsRHoGPKiKihyox4syT
         VngQ==
X-Gm-Message-State: AOAM531i9+ke44oXL5mM2LVi0KSbvuJRMzkkG6/qofirDyEk/U22ASeM
        MmmcQ2eIoyVq1WjQexsjsjZdwQ==
X-Google-Smtp-Source: ABdhPJzjRmSUHB2zFZ7vBLZF6CzWlFP1LEz/kUgyBixSbyTvv5dKfO22jCQHN6IyVtoTtdqjdu9Rpg==
X-Received: by 2002:a17:906:3c42:: with SMTP id i2mr4628994ejg.14.1594914012974;
        Thu, 16 Jul 2020 08:40:12 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id gu15sm5285033ejb.111.2020.07.16.08.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 08:40:12 -0700 (PDT)
Date:   Thu, 16 Jul 2020 17:39:59 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Will Deacon <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Message-ID: <20200716153959.GA447208@myrica>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
 <20200713131454.GA2739@willie-the-truck>
 <CY4PR11MB1432226D0A52D099249E95A0C3610@CY4PR11MB1432.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR11MB1432226D0A52D099249E95A0C3610@CY4PR11MB1432.namprd11.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 10:12:49AM +0000, Liu, Yi L wrote:
> > Have you verified that this doesn't break the existing usage of
> > DOMAIN_ATTR_NESTING in drivers/vfio/vfio_iommu_type1.c?
> 
> I didn't have ARM machine on my hand. But I contacted with Jean
> Philippe, he confirmed no compiling issue. I didn't see any code
> getting DOMAIN_ATTR_NESTING attr in current drivers/vfio/vfio_iommu_type1.c.
> What I'm adding is to call iommu_domai_get_attr(, DOMAIN_ATTR_NESTIN)
> and won't fail if the iommu_domai_get_attr() returns 0. This patch
> returns an empty nesting info for DOMAIN_ATTR_NESTIN and return
> value is 0 if no error. So I guess it won't fail nesting for ARM.

I confirm that this series doesn't break the current support for
VFIO_IOMMU_TYPE1_NESTING with an SMMUv3. That said...

If the SMMU does not support stage-2 then there is a change in behavior
(untested): after the domain is silently switched to stage-1 by the SMMU
driver, VFIO will now query nesting info and obtain -ENODEV. Instead of
succeding as before, the VFIO ioctl will now fail. I believe that's a fix
rather than a regression, it should have been like this since the
beginning. No known userspace has been using VFIO_IOMMU_TYPE1_NESTING so
far, so I don't think it should be a concern.

And if userspace queries the nesting properties using the new ABI
introduced in this patchset, it will obtain an empty struct. I think
that's acceptable, but it may be better to avoid adding the nesting cap if
@format is 0?

Thanks,
Jean

> 
> @Eric, how about your opinion? your dual-stage vSMMU support may
> also share the vfio_iommu_type1.c code.
> 
> Regards,
> Yi Liu
> 
> > Will
