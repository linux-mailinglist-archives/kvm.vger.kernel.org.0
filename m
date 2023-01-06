Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E3665FFC0
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 12:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjAFLpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 06:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbjAFLpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 06:45:19 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B77728B7;
        Fri,  6 Jan 2023 03:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673005511; x=1704541511;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=glF6Cj784lqp9oJmdDD82OwXsf2nIYemlwHCijSWpiU=;
  b=RfjZ4X2ojyxaO2X6vwDmbnfm11wE9+rcBDlNRKeHgpCS8VQUmC2CvoHL
   atMordgGbC+JM9CTjqmU/LpCrdipCyeIXzixSaF4Mogy2p+QVb2miRIJt
   lUlnQlvkGzPGdhqEcNy4bBR/ypLq3XpQ2fWlY8q1+QqKgSqZEgGod1iKB
   P68Dz5arXo76FCkOVb+3GS1ctiLVyWT9saTWm4KPu8DqOH7+K3pxAoJI2
   a3HYPeKkUP/IDpOqoP+HmdVf2irOygd2lCNsb284NWSu1UAaWK3yhnG9o
   evfN+JWGBFJCkz+z6XWHh8qUG7FYVLC39CY9ht+A8PEekeRINO8pFTENY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="310252721"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="310252721"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:45:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="649304149"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="649304149"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.211.214]) ([10.254.211.214])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:45:04 -0800
Message-ID: <ac5b724a-a495-0ef5-e709-c1c56a4f9047@linux.intel.com>
Date:   Fri, 6 Jan 2023 19:45:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH iommufd v3 9/9] iommu: Remove IOMMU_CAP_INTR_REMAP
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
References: <9-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <9-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/2023 3:33 AM, Jason Gunthorpe wrote:
> No iommu driver implements this any more, get rid of it.
> 
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 4 +---
>   include/linux/iommu.h | 1 -
>   2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 7f744904e02f4d..834e6ecf3e5197 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1915,9 +1915,7 @@ bool iommu_group_has_isolated_msi(struct iommu_group *group)
>   
>   	mutex_lock(&group->mutex);
>   	list_for_each_entry(group_dev, &group->devices, list)
> -		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
> -		       device_iommu_capable(group_dev->dev,
> -					    IOMMU_CAP_INTR_REMAP);
> +		ret &= msi_device_has_isolated_msi(group_dev->dev);
>   	mutex_unlock(&group->mutex);
>   	return ret;
>   }
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 9b7a9fa5ad28d3..933cc57bfc4818 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -120,7 +120,6 @@ static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
>   
>   enum iommu_cap {
>   	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU_CACHE is supported */
> -	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
>   	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
>   	IOMMU_CAP_PRE_BOOT_PROTECTION,	/* Firmware says it used the IOMMU for
>   					   DMA protection and we should too */

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

--
Best regards,
baolu
