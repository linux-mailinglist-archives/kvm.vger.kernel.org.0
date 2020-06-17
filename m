Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B981FCFD9
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgFQOjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 10:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgFQOjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 10:39:22 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41451C061755
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 07:39:22 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id k11so2573009ejr.9
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 07:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hp21piGHsn7agUSyXFgTrryIp2qf2aW4dX8w1tTdFAQ=;
        b=K1P4icbmrpXAkcV9YDVqQ37pfEGBzuBW3Ramc+WC17uKN5rl13MHwBI51R3kWEeHD1
         RPShy1U/CpBqrsloZYaVylODq+KGw2xSOkKxF2agc/KVt1EKIval0NZumgyRJZELNTgO
         190/ZjceYSb3+Ip+Y8Y/5she3fLhpEoXh4j5/sC6EU6bI8B7i8haV1/yDLMRmuJeGppO
         yhS/D19DQVPGoOMCgXjXv8KXT+n9ApVTB1WI38fs1ObO2AGLTUvxNnFMIG7exIFmMw9V
         4nJz/h4/nl7PgVf2CCGEYD9TMF7cxq7cZqjg6tdphAwY2Rz9KSYHv4+s27XlDiuF3Do0
         LWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hp21piGHsn7agUSyXFgTrryIp2qf2aW4dX8w1tTdFAQ=;
        b=VyjgugvPsdXdaehMcHdixOtbf6SxA6FLObwz67OCV1tFZxU9xMRzqrTUvUFrhvV9kp
         kOvpbA1DYtupHJRWMiULxQ9R1pMOblF5RZvnhsEqoZfCASUcceOKJPu4VM1Tj/82t56x
         qSJVujtbIAh8Afi01Cskr49oPqxKJaBgIsQAv2fXfLZQLakCtKlnUbryV9azdNuwweK4
         sm5bBLCzr6dBD08Pan538yYEEx3UpC+rV6jITGyl2WPXoSzDGRHIYleiXnTK1j8V91Cm
         7XpA96GlR8nPwSaCRtn6GT4tZXXUxVQaXXlus8+crq1xv0VB5jK5jQwSd/4ddCkNDi5V
         gmtw==
X-Gm-Message-State: AOAM533BGQJkBYPZTki75Ecw7KlEB3Wu8GEz3DC0zZHmvQHNUYuWU5dZ
        7ZTGJJh8QOnzkX/f5yT08OB9hA==
X-Google-Smtp-Source: ABdhPJxLaOaRToMf9UF6SdNB0Ecr2eORyxp0pZiau38To63+9MZNptlFFfGl++IztCMMaBaouHNWgA==
X-Received: by 2002:a17:906:22d0:: with SMTP id q16mr7685367eja.455.1592404760889;
        Wed, 17 Jun 2020 07:39:20 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id dn17sm12374349edb.26.2020.06.17.07.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 07:39:20 -0700 (PDT)
Date:   Wed, 17 Jun 2020 16:39:09 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        robin.murphy@arm.com
Subject: Re: [PATCH v2 02/15] iommu: Report domain nesting info
Message-ID: <20200617143909.GA886590@myrica>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
 <1591877734-66527-3-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591877734-66527-3-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+ Will and Robin]

Hi Yi,

On Thu, Jun 11, 2020 at 05:15:21AM -0700, Liu Yi L wrote:
> IOMMUs that support nesting translation needs report the capability info
> to userspace, e.g. the format of first level/stage paging structures.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> @Jean, Eric: as nesting was introduced for ARM, but looks like no actual
> user of it. right? So I'm wondering if we can reuse DOMAIN_ATTR_NESTING
> to retrieve nesting info? how about your opinions?

Sure, I think we could rework the getters for DOMAIN_ATTR_NESTING since
they aren't used, but we do need to keep the setters as is.

Before attaching a domain, VFIO sets DOMAIN_ATTR_NESTING if userspace
requested a VFIO_TYPE1_NESTING_IOMMU container. This is necessary for the
SMMU driver to know how to attach later, but at that point we don't know
whether the SMMU does support nesting (since the domain isn't attached to
any endpoint). During attach, the SMMU driver adapts to the SMMU's
capabilities, and may well fallback to one stage if the SMMU doesn't
support nesting.

VFIO should check after attaching that the nesting attribute held, by
calling iommu_domain_get_attr(NESTING). At the moment it does not, and
since your 03/15 patch does that with additional info, I agree with
reusing DOMAIN_ATTR_NESTING instead of adding DOMAIN_ATTR_NESTING_INFO.

However it requires changing the get_attr(NESTING) implementations in both
SMMU drivers as a precursor of this series, to avoid breaking
VFIO_TYPE1_NESTING_IOMMU on Arm. Since we haven't yet defined the
nesting_info structs for SMMUv2 and v3, I suppose we could return an empty
struct iommu_nesting_info for now?

> 
>  include/linux/iommu.h      |  1 +
>  include/uapi/linux/iommu.h | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 78a26ae..f6e4b49 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -126,6 +126,7 @@ enum iommu_attr {
>  	DOMAIN_ATTR_FSL_PAMUV1,
>  	DOMAIN_ATTR_NESTING,	/* two stages of translation */
>  	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
> +	DOMAIN_ATTR_NESTING_INFO,
>  	DOMAIN_ATTR_MAX,
>  };
>  
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 303f148..02eac73 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -332,4 +332,38 @@ struct iommu_gpasid_bind_data {
>  	};
>  };
>  
> +struct iommu_nesting_info {
> +	__u32	size;
> +	__u32	format;

What goes into format? And flags? This structure needs some documentation.

Thanks,
Jean

> +	__u32	features;
> +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
> +	__u32	flags;
> +	__u8	data[];
> +};
> +
> +/*
> + * @flags:	VT-d specific flags. Currently reserved for future
> + *		extension.
> + * @addr_width:	The output addr width of first level/stage translation
> + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
> + *		support.
> + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
> + *		register.
> + * @cap_mask:	Mark valid capability bits in @cap_reg.
> + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
> + *		extended capability register.
> + * @ecap_mask:	Mark the valid capability bits in @ecap_reg.
> + */
> +struct iommu_nesting_info_vtd {
> +	__u32	flags;
> +	__u16	addr_width;
> +	__u16	pasid_bits;
> +	__u64	cap_reg;
> +	__u64	cap_mask;
> +	__u64	ecap_reg;
> +	__u64	ecap_mask;
> +};
> +
>  #endif /* _UAPI_IOMMU_H */
> -- 
> 2.7.4
> 
