Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB77620AD85
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgFZHrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbgFZHrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:47:52 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1971AC08C5DB
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 00:47:52 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dp18so8423656ejc.8
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 00:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uilk6pA4v6KKUsLLMKY6bcWg9QtWqaF5/DWx18U/CC0=;
        b=wNRHexa5s1zJiUOQyWtpLRXSG5ABe3ivQzpVwdwmn8o/tEZ3m+fyj4FO67sPTR7iGi
         DpNfp1sF5xQI6z+w34Q0nCrcdbvULmc0+e1I8AwkbPv/n7tBvK9hQWB5afKP87qjKW06
         AKTO4Ic3DR6pc55MzBsi6SUhapT0eVSocXd+lW+19x5PYMm8xySVNbEGipLDiYUeTeVV
         cK+kzpFrFU3vZ6pjqQRkZj4aeFNbOMZ6nFAAh/Mr4AEKLD+UxIHEOX3PSGfZ1VYrpPSl
         C+jhxyMXPeiK8p3tM4y8nLAf39PmbenImLBlqlgNyJa2RI/2nWh4gggsgzCCsz1g3Flx
         Wr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uilk6pA4v6KKUsLLMKY6bcWg9QtWqaF5/DWx18U/CC0=;
        b=GCJpaJEgOez0wIw9V3YfkWDzjuCeIy+ARcSa7Zj0yywA85+d/8xCQYwcVixzfAxA68
         ZG/XVM5UC3kVoI40y51K5whrOw4nhGz6+i/yep0TNIfIwThJjgsa1ximo8k7CoRyc530
         NIqwsacSzrcgaphXXv7JEcvN9L1UOz2VbX7R9OFrZl3t0evGWiAvaNyckOyLuDxMNnmz
         CeDwQaDXI/vNyW0X2gMauhz6xo0151XRvrgQGwEFOe0X9fqHEPqrhbTeMOhr+26M00sN
         7buI1qh4O3otq+5j3GKTmzqVwSMwGDlH3TcuTCP/7chm0l1VmZZsDFLZ5ORbfzW9Xg2i
         jccA==
X-Gm-Message-State: AOAM532QnjNMOpLXLiHBkxFTsTjyZMPo5IjssRfO4TiqkKSC/m4N62QY
        JMcKc3F/Y5yI50FN75zP1Rq60w==
X-Google-Smtp-Source: ABdhPJz95Ad9tZXwAAZZfpGTo9871UG/cCB3/qufTsd1aPfFz2/WXFO57hB5+K4dVtoXfNQLW+GeCg==
X-Received: by 2002:a17:906:c14f:: with SMTP id dp15mr1444508ejc.454.1593157670667;
        Fri, 26 Jun 2020 00:47:50 -0700 (PDT)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id be2sm8717486edb.92.2020.06.26.00.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 00:47:50 -0700 (PDT)
Date:   Fri, 26 Jun 2020 09:47:38 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 02/14] iommu: Report domain nesting info
Message-ID: <20200626074738.GA2107508@myrica>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
 <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 24, 2020 at 01:55:15AM -0700, Liu Yi L wrote:
> IOMMUs that support nesting translation needs report the capability info
> to userspace, e.g. the format of first level/stage paging structures.
> 
> This patch reports nesting info by DOMAIN_ATTR_NESTING. Caller can get
> nesting info after setting DOMAIN_ATTR_NESTING.
> 
> v2 -> v3:
> *) remvoe cap/ecap_mask in iommu_nesting_info.
> *) reuse DOMAIN_ATTR_NESTING to get nesting info.
> *) return an empty iommu_nesting_info for SMMU drivers per Jean'
>    suggestion.
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
>  drivers/iommu/arm-smmu-v3.c | 29 ++++++++++++++++++++--
>  drivers/iommu/arm-smmu.c    | 29 ++++++++++++++++++++--

Looks reasonable to me. Please move the SMMU changes to a separate patch
and Cc the SMMU maintainers:

Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>

Thanks,
Jean

>  include/uapi/linux/iommu.h  | 59 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 113 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index f578677..0c45d4d 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -3019,6 +3019,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>  	return group;
>  }
>  
> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
> +					void *data)
> +{
> +	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
> +	u32 size;
> +
> +	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -ENODEV;
> +
> +	size = sizeof(struct iommu_nesting_info);
> +
> +	/*
> +	 * if provided buffer size is not equal to the size, should
> +	 * return 0 and also the expected buffer size to caller.
> +	 */
> +	if (info->size != size) {
> +		info->size = size;
> +		return 0;
> +	}
> +
> +	/* report an empty iommu_nesting_info for now */
> +	memset(info, 0x0, size);
> +	info->size = size;
> +	return 0;
> +}
> +
>  static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  				    enum iommu_attr attr, void *data)
>  {
> @@ -3028,8 +3054,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  	case IOMMU_DOMAIN_UNMANAGED:
>  		switch (attr) {
>  		case DOMAIN_ATTR_NESTING:
> -			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
> -			return 0;
> +			return arm_smmu_domain_nesting_info(smmu_domain, data);
>  		default:
>  			return -ENODEV;
>  		}
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index 243bc4c..908607d 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1506,6 +1506,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>  	return group;
>  }
>  
> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
> +					void *data)
> +{
> +	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
> +	u32 size;
> +
> +	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -ENODEV;
> +
> +	size = sizeof(struct iommu_nesting_info);
> +
> +	/*
> +	 * if provided buffer size is not equal to the size, should
> +	 * return 0 and also the expected buffer size to caller.
> +	 */
> +	if (info->size != size) {
> +		info->size = size;
> +		return 0;
> +	}
> +
> +	/* report an empty iommu_nesting_info for now */
> +	memset(info, 0x0, size);
> +	info->size = size;
> +	return 0;
> +}
> +
>  static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  				    enum iommu_attr attr, void *data)
>  {
> @@ -1515,8 +1541,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  	case IOMMU_DOMAIN_UNMANAGED:
>  		switch (attr) {
>  		case DOMAIN_ATTR_NESTING:
> -			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
> -			return 0;
> +			return arm_smmu_domain_nesting_info(smmu_domain, data);
>  		default:
>  			return -ENODEV;
>  		}
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 1afc661..898c99a 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -332,4 +332,63 @@ struct iommu_gpasid_bind_data {
>  	} vendor;
>  };
>  
> +/*
> + * struct iommu_nesting_info - Information for nesting-capable IOMMU.
> + *				user space should check it before using
> + *				nesting capability.
> + *
> + * @size:	size of the whole structure
> + * @format:	PASID table entry format, the same definition with
> + *		@format of struct iommu_gpasid_bind_data.
> + * @features:	supported nesting features.
> + * @flags:	currently reserved for future extension.
> + * @data:	vendor specific cap info.
> + *
> + * +---------------+----------------------------------------------------+
> + * | feature       |  Notes                                             |
> + * +===============+====================================================+
> + * | SYSWIDE_PASID |  Kernel manages PASID in system wide, PASIDs used  |
> + * |               |  in the system should be allocated by host kernel  |
> + * +---------------+----------------------------------------------------+
> + * | BIND_PGTBL    |  bind page tables to host PASID, the PASID could   |
> + * |               |  either be a host PASID passed in bind request or  |
> + * |               |  default PASIDs (e.g. default PASID of aux-domain) |
> + * +---------------+----------------------------------------------------+
> + * | CACHE_INVLD   |  mandatory feature for nesting capable IOMMU       |
> + * +---------------+----------------------------------------------------+
> + *
> + */
> +struct iommu_nesting_info {
> +	__u32	size;
> +	__u32	format;
> +	__u32	features;
> +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
> +	__u32	flags;
> +	__u8	data[];
> +};
> +
> +/*
> + * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info
> + *
> + *
> + * @flags:	VT-d specific flags. Currently reserved for future
> + *		extension.
> + * @addr_width:	The output addr width of first level/stage translation
> + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
> + *		support.
> + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
> + *		register.
> + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
> + *		extended capability register.
> + */
> +struct iommu_nesting_info_vtd {
> +	__u32	flags;
> +	__u16	addr_width;
> +	__u16	pasid_bits;
> +	__u64	cap_reg;
> +	__u64	ecap_reg;
> +};
> +
>  #endif /* _UAPI_IOMMU_H */
> -- 
> 2.7.4
> 
