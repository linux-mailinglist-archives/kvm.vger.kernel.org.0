Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE0622419F
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 19:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgGQRSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 13:18:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33475 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726293AbgGQRSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 13:18:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595006311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gpEKoCVUb0H9sRGX33KH+Wdr5W7X+RwCM8FI3G3gcaI=;
        b=S7MrObvtboz9QHu2ADL2mNK5tduNg779jfII+QleG8vmKgV/TuYhk1QiiO1Iu4uDK2DrGY
        3QkojwTuiQVg2pgo2umtLGqPAu5G9oly7e5NpJ+ymI82XWAQ7Db0xchpfV2ZGXzK3SWYb4
        KpfnXTE4YdjrvWkmG3FzblmJlRVMc9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-gw8k3hR8OzK81GZ112l71Q-1; Fri, 17 Jul 2020 13:18:29 -0400
X-MC-Unique: gw8k3hR8OzK81GZ112l71Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39F2C8005B0;
        Fri, 17 Jul 2020 17:18:27 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 924B75C1D4;
        Fri, 17 Jul 2020 17:18:17 +0000 (UTC)
Subject: Re: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <5ee6b661-9c46-20ee-332a-1a449b6f3a43@redhat.com>
Date:   Fri, 17 Jul 2020 19:18:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 7/12/20 1:20 PM, Liu Yi L wrote:
> This patch is added as instead of returning a boolean for DOMAIN_ATTR_NESTING,
> iommu_domain_get_attr() should return an iommu_nesting_info handle.

you may add in the commit message you return an empty nesting info
struct for now as true nesting is not yet supported by the SMMUs.

Besides:
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> 
> Cc: Will Deacon <will@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> v4 -> v5:
> *) address comments from Eric Auger.
> ---
>  drivers/iommu/arm-smmu-v3.c | 29 +++++++++++++++++++++++++++--
>  drivers/iommu/arm-smmu.c    | 29 +++++++++++++++++++++++++++--
>  2 files changed, 54 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index f578677..ec815d7 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -3019,6 +3019,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>  	return group;
>  }
>  
> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
> +					void *data)
> +{
> +	struct iommu_nesting_info *info = (struct iommu_nesting_info *)data;
> +	unsigned int size;
> +
> +	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -ENODEV;
> +
> +	size = sizeof(struct iommu_nesting_info);
> +
> +	/*
> +	 * if provided buffer size is smaller than expected, should
> +	 * return 0 and also the expected buffer size to caller.
> +	 */
> +	if (info->size < size) {
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
> index 243bc4c..09e2f1b 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1506,6 +1506,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>  	return group;
>  }
>  
> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
> +					void *data)
> +{
> +	struct iommu_nesting_info *info = (struct iommu_nesting_info *)data;
> +	unsigned int size;
> +
> +	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -ENODEV;
> +
> +	size = sizeof(struct iommu_nesting_info);
> +
> +	/*
> +	 * if provided buffer size is smaller than expected, should
> +	 * return 0 and also the expected buffer size to caller.
> +	 */
> +	if (info->size < size) {
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
> 

