Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625C01A30DB
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 10:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgDII24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 04:28:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42550 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgDII24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 04:28:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id f10so1200244wrr.9
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 01:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WgrtA3z9gcCpvVtn+/QtJVLHi+wEpZ3q6REO1Dlhxjc=;
        b=EwT7A41KDLkk8jDmuwXWJhwVkRRmXWA9OX4bUYtDtbxYJW+BezFqEYR2LyeY8NYE1n
         qsISncWQMRghInp7uM9xVtUlfEZTQzsVHplk5XeWwX6PkZMXqZwF4UMtYgj3zaNm+RrD
         tLmAnD7ijZbtkbWHYzv5URL/0X1eKDlkHVJzC329EMt0/pbrkBtiSa/dy1S0jYkDDbZD
         8+g568tPwHC1C8QI/NhKp5kQqGO7edSzI4Gt3SfIt/ysuGcApiyrZMbxGdKzImTfyZZP
         G2Sh69tPb6Gm1lN6ndVUe9rhMwabrdl5f/Q41dh8Js0FocrCVYBIK0HVBzk1FugewyrL
         PNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WgrtA3z9gcCpvVtn+/QtJVLHi+wEpZ3q6REO1Dlhxjc=;
        b=uHSF4wrkiWprvgK49XIcVdBT8SehvWbcYDQCzcl2voa2iEAnTgZYAJOhs6oHk1bkgo
         /ujWD4+1mTV/SiiuIWRtkl8fO1IwtolVtT51mTmXlcgm7bdX4sZWNsUvTAcoyq+qksxT
         7fkIZQ/DcdOTjkqosO6/ZdGjNDXRsKf3RMLkqMrrley54XJL2zYv6WEpO+uQDHwbZwpH
         5RM3pkWcLKnYUsZgKCwhtkm2L2ZRzBlN5T4UYvlarpmtMdCSReFEGcCXLaFxm3j9D1Mh
         QaoyO8dz5w3LhZBMS5ewHPQmZsCDIXK0g1kVx/GRBRJIXq8Ft+pEZPJCBVCWJ3Jts1iV
         +QdA==
X-Gm-Message-State: AGi0Pub8Q6olikjONI51bniSXFQvZuUTFuh5X0Sxbpj/USaPkBWsJ/l6
        fJ6JIzdOnAH+G8M2qtSR1Ha/4A==
X-Google-Smtp-Source: APiQypJaUZjUm66IBuu3xDJVpLpWtuc3y+tz9J81OOkTIgI1piB2pLEQNhoBRvX1GGgS2ZUyboZgLw==
X-Received: by 2002:adf:e641:: with SMTP id b1mr12714165wrn.299.1586420934729;
        Thu, 09 Apr 2020 01:28:54 -0700 (PDT)
Received: from myrica ([2001:171b:226b:54a0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id p5sm14167665wrn.93.2020.04.09.01.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 01:28:54 -0700 (PDT)
Date:   Thu, 9 Apr 2020 10:28:46 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
Message-ID: <20200409082846.GE2435@myrica>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-7-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF98F@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21D8C6@SHSMSX104.ccr.corp.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D805F75@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21ED01@SHSMSX104.ccr.corp.intel.com>
 <20200403083407.GB1269501@myrica>
 <A2975661238FB949B60364EF0F2C25743A224C8F@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A224C8F@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 07, 2020 at 10:33:25AM +0000, Liu, Yi L wrote:
> Hi Jean,
> 
> > From: Jean-Philippe Brucker < jean-philippe@linaro.org >
> > Sent: Friday, April 3, 2020 4:35 PM
> > Subject: Re: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
> > 
> > On Thu, Apr 02, 2020 at 08:05:29AM +0000, Liu, Yi L wrote:
> > > > > > > static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > > > > >  		default:
> > > > > > >  			return -EINVAL;
> > > > > > >  		}
> > > > > > > +
> > > > > > > +	} else if (cmd == VFIO_IOMMU_BIND) {
> > > > > >
> > > > > > BIND what? VFIO_IOMMU_BIND_PASID sounds clearer to me.
> > > > >
> > > > > Emm, it's up to the flags to indicate bind what. It was proposed to
> > > > > cover the three cases below:
> > > > > a) BIND/UNBIND_GPASID
> > > > > b) BIND/UNBIND_GPASID_TABLE
> > > > > c) BIND/UNBIND_PROCESS
> > > > > <only a) is covered in this patch>
> > > > > So it's called VFIO_IOMMU_BIND.
> > > >
> > > > but aren't they all about PASID related binding?
> > >
> > > yeah, I can rename it. :-)
> > 
> > I don't know if anyone intends to implement it, but SMMUv2 supports
> > nesting translation without any PASID support. For that case the name
> > VFIO_IOMMU_BIND_GUEST_PGTBL without "PASID" anywhere makes more sense.
> > Ideally we'd also use a neutral name for the IOMMU API instead of
> > bind_gpasid(), but that's easier to change later.
> 
> I agree VFIO_IOMMU_BIND is somehow not straight-forward. Especially, it may
> cause confusion when thinking about VFIO_SET_IOMMU. How about using
> VFIO_NESTING_IOMMU_BIND_STAGE1 to cover a) and b)? And has another
> VFIO_BIND_PROCESS in future for the SVA bind case.

I think minimizing the number of ioctls is more important than finding the
ideal name. VFIO_IOMMU_BIND was fine to me, but if it's too vague then
rename it to VFIO_IOMMU_BIND_PASID and we'll just piggy-back on it for
non-PASID things (they should be rare enough).

Thanks,
Jean
