Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C76B1A31ED
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 11:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgDIJiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 05:38:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38914 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgDIJiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 05:38:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id p10so11122927wrt.6
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 02:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TUDoLKMMdHMR1rZNFcHOOtCZYFU9bh9JO/aemHvhjFk=;
        b=jYpPR8OTb2GGh/MMhOBz3qkV5a8N2A6Gz3Of3JWdBmSlWODObZq+oeuRnxnFnyrov1
         TALT9vbCUEF14fW9cphDRYFxAFq4fWeB/IBODCAdEBKDh1i80RzE3AkmZiKSk+aIrFQm
         3AARvtT5Kb0HTFBjcA4VwdDfk1x0QFZmiWIizxLG18zsQDj31PwUpJhjs9dfPzp+X4La
         /AmaK5dH9ZSPvQueveNNFLTAOapbu+XgTg/y0LNqXd9T7Vub0E5dmLiYcLLDefOeqmaj
         NaU5ezsjDcIgctN7UpNnTD7r/Sn/F2KpybWn7ajy+B7uS5/Ojud58INLA7awb4/CPxNg
         w33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TUDoLKMMdHMR1rZNFcHOOtCZYFU9bh9JO/aemHvhjFk=;
        b=LY4YtDvo2E4x8P9eg4xXv/MzHN7QR+YozSmNRCdBtWjf2c/UPkquaTJfl4ilCVThw0
         6+NLt2Tp8CIWy7qHa8Yj/8Yqick2guY8XBbT7PdUDkbxdua7qa0fxKl+zcov3HKr1UrX
         pqxZq91p24wGnPHDsbea2NegrlblXPRdhZ4uUWy3R9IFJ8b+qYQvlvLG4xZi4DDrhIen
         vzNSqZQNn9YKuXrfDUu6f69czUilX2Td30YcYr4PRKv4t7euj2iUvNJqE7FCv9dc2RCw
         ypwl1dQWTuv7X05kgwMXTpTpHKxXY1SbI8EqfvA+4j75LhSFd04K9bcYfKWj2SLJ/1Je
         ep/w==
X-Gm-Message-State: AGi0PuYCnUALOk42KkkKDeEuQL6dZo5gGgoBcuUDoslr3UrVD1Xp9nV/
        ELhq3B1ODo02zeYGB66M3v1ITQp6YrI=
X-Google-Smtp-Source: APiQypJ/bOyornodYdSyYMQSu94F2GYB/q88uLGGOOtbI4H/O4Jr8LdPoj7N2VqvqFNCove+bm0Wfw==
X-Received: by 2002:a5d:5143:: with SMTP id u3mr13924339wrt.64.1586425127458;
        Thu, 09 Apr 2020 02:38:47 -0700 (PDT)
Received: from myrica ([2001:171b:226b:54a0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id m8sm2922990wmc.28.2020.04.09.02.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 02:38:46 -0700 (PDT)
Date:   Thu, 9 Apr 2020 11:38:39 +0200
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
Message-ID: <20200409093839.GH2435@myrica>
References: <1584880325-10561-1-git-send-email-yi.l.liu@intel.com>
 <1584880325-10561-7-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D7FF98F@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21D8C6@SHSMSX104.ccr.corp.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D805F75@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A21ED01@SHSMSX104.ccr.corp.intel.com>
 <20200403083407.GB1269501@myrica>
 <A2975661238FB949B60364EF0F2C25743A224C8F@SHSMSX104.ccr.corp.intel.com>
 <20200409082846.GE2435@myrica>
 <A2975661238FB949B60364EF0F2C25743A228CCA@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A228CCA@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 09, 2020 at 09:15:29AM +0000, Liu, Yi L wrote:
> > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Sent: Thursday, April 9, 2020 4:29 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > 
> > On Tue, Apr 07, 2020 at 10:33:25AM +0000, Liu, Yi L wrote:
> > > Hi Jean,
> > >
> > > > From: Jean-Philippe Brucker < jean-philippe@linaro.org >
> > > > Sent: Friday, April 3, 2020 4:35 PM
> > > > Subject: Re: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
> > > >
> > > > On Thu, Apr 02, 2020 at 08:05:29AM +0000, Liu, Yi L wrote:
> > > > > > > > > static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > > > > > > >  		default:
> > > > > > > > >  			return -EINVAL;
> > > > > > > > >  		}
> > > > > > > > > +
> > > > > > > > > +	} else if (cmd == VFIO_IOMMU_BIND) {
> > > > > > > >
> > > > > > > > BIND what? VFIO_IOMMU_BIND_PASID sounds clearer to me.
> > > > > > >
> > > > > > > Emm, it's up to the flags to indicate bind what. It was proposed to
> > > > > > > cover the three cases below:
> > > > > > > a) BIND/UNBIND_GPASID
> > > > > > > b) BIND/UNBIND_GPASID_TABLE
> > > > > > > c) BIND/UNBIND_PROCESS
> > > > > > > <only a) is covered in this patch>
> > > > > > > So it's called VFIO_IOMMU_BIND.
> > > > > >
> > > > > > but aren't they all about PASID related binding?
> > > > >
> > > > > yeah, I can rename it. :-)
> > > >
> > > > I don't know if anyone intends to implement it, but SMMUv2 supports
> > > > nesting translation without any PASID support. For that case the name
> > > > VFIO_IOMMU_BIND_GUEST_PGTBL without "PASID" anywhere makes more
> > sense.
> > > > Ideally we'd also use a neutral name for the IOMMU API instead of
> > > > bind_gpasid(), but that's easier to change later.
> > >
> > > I agree VFIO_IOMMU_BIND is somehow not straight-forward. Especially, it may
> > > cause confusion when thinking about VFIO_SET_IOMMU. How about using
> > > VFIO_NESTING_IOMMU_BIND_STAGE1 to cover a) and b)? And has another
> > > VFIO_BIND_PROCESS in future for the SVA bind case.
> > 
> > I think minimizing the number of ioctls is more important than finding the
> > ideal name. VFIO_IOMMU_BIND was fine to me, but if it's too vague then
> > rename it to VFIO_IOMMU_BIND_PASID and we'll just piggy-back on it for
> > non-PASID things (they should be rare enough).
> maybe we can start with VFIO_IOMMU_BIND_PASID. Actually, there is
> also a discussion on reusing the same ioctl and vfio structure for
> pasid_alloc/free, bind/unbind_gpasid. and cache_inv. how about your
> opinion?

Merging bind with unbind and alloc with free makes sense. I'd leave at
least invalidate a separate ioctl, because alloc/bind/unbind/free are
setup functions while invalidate is a runtime thing and performance
sensitive. But I can't see a good reason not to merge them all together,
so either way is fine by me.

Thanks,
Jean
