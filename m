Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778F765FF8C
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 12:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjAFL26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 06:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjAFL24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 06:28:56 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5093260D0;
        Fri,  6 Jan 2023 03:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673004536; x=1704540536;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gtPxb1hUG19sdZyr90eZiXbtQnVpYQmHDV48nV4t68A=;
  b=RFmAN/QzTo/y3p4RCcU7lSOe7KSes2IPOLeYyaxe+DewQeTSRHumi4Pz
   UgJwMXJTeonGD+P+SehgdB+6MdsQEM1ved1rXmI+12qSteRMEPJwGCWek
   3YZRZCjKDVje9Cj4W+qcOWSiIr4ZY/mWWTgZcJ11koDFyWaTPeavxhzfS
   IVzE+MeO7iLg2nQesxWPMT7cQ/q0aXPJ8OgYpRfBaL7wqoy+n17Qf9fw6
   aB7pRJRSyyO40jw2z3byAwNseX4Yq98tXj2TkNWK4Eo1Nngi8DrD/Prys
   AqobJZWvSXNlxTBRP6oeFcV6giJrARCP2J2Epm3X6ybPSb45XjCl55g7+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="321165607"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="321165607"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:28:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="798258834"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="798258834"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.211.214]) ([10.254.211.214])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:28:49 -0800
Message-ID: <2c12143b-eaa9-2f6b-d367-e55d6f1e180d@linux.intel.com>
Date:   Fri, 6 Jan 2023 19:28:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH iommufd v3 2/9] iommu: Add iommu_group_has_isolated_msi()
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
References: <2-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/2023 3:33 AM, Jason Gunthorpe wrote:
> Compute the isolated_msi over all the devices in the IOMMU group because
> iommufd and vfio both need to know that the entire group is isolated
> before granting access to it.
>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 26 ++++++++++++++++++++++++++
>   include/linux/iommu.h |  1 +
>   2 files changed, 27 insertions(+)
>
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index de91dd88705bd3..7f744904e02f4d 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -30,6 +30,7 @@
>   #include <linux/cc_platform.h>
>   #include <trace/events/iommu.h>
>   #include <linux/sched/mm.h>
> +#include <linux/msi.h>
>   
>   #include "dma-iommu.h"
>   
> @@ -1897,6 +1898,31 @@ bool device_iommu_capable(struct device *dev, enum iommu_cap cap)
>   }
>   EXPORT_SYMBOL_GPL(device_iommu_capable);
>   
> +/**
> + * iommu_group_has_isolated_msi() - Compute msi_device_has_isolated_msi()
> + *       for a group
> + * @group: Group to query
> + *
> + * IOMMU groups should not have differing values of
> + * msi_device_has_isolated_msi() for devices in a group. However nothing
> + * directly prevents this, so ensure mistakes don't result in isolation failures
> + * by checking that all the devices are the same.
> + */
> +bool iommu_group_has_isolated_msi(struct iommu_group *group)
> +{
> +	struct group_device *group_dev;
> +	bool ret = true;
> +
> +	mutex_lock(&group->mutex);
> +	list_for_each_entry(group_dev, &group->devices, list)
> +		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
> +		       device_iommu_capable(group_dev->dev,
> +					    IOMMU_CAP_INTR_REMAP);
> +	mutex_unlock(&group->mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_has_isolated_msi);
> +
>   /**
>    * iommu_set_fault_handler() - set a fault handler for an iommu domain
>    * @domain: iommu domain
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 46e1347bfa2286..9b7a9fa5ad28d3 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -455,6 +455,7 @@ static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
>   extern int bus_iommu_probe(struct bus_type *bus);
>   extern bool iommu_present(struct bus_type *bus);
>   extern bool device_iommu_capable(struct device *dev, enum iommu_cap cap);
> +extern bool iommu_group_has_isolated_msi(struct iommu_group *group);

This lacks a static inline definition when CONFIG_IOMMU_API is false?

>   extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
>   extern struct iommu_group *iommu_group_get_by_id(int id);
>   extern void iommu_domain_free(struct iommu_domain *domain);

Others look good to me. With above addressed,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

--

Best regards,

baolu

