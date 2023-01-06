Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5E165FF9F
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 12:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbjAFLgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 06:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjAFLgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 06:36:22 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43131B1DF;
        Fri,  6 Jan 2023 03:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673004981; x=1704540981;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N8dj8T1YobkP4eKm3isHKa9XtPFEy0/PWvgm+xzMhWk=;
  b=maQkD3Dq9xL8SSl0F9I/a8Bu73BEdcJkDB/Q2V3uO3dpTP2UqbCFe5mL
   F3cDwWbyaTQnHa7rCe5evfklFCur91Pbpa03AOA6cDIS/qiCwEqawiDJO
   lrFitw3d27Nbjxp1Y51XAGnLR3Q4Om7mSWKJJltpf0F9VY/ZJglEEi03F
   GEWDang2NAIjW04ORmXTb2TjYs/be43Mw6JSE9+0DK59OyDhGX8In2A2f
   g0TFJLxi+JhBbvVfvSx04GObNPrD/Utp3y3r2YUO0wBs6fir7MXRh+PsG
   5hS6CTD+6WIR35JzVLIoICSxooUGvCL9zeYsSQc7GxIpejfnLENAGkl8K
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="321166692"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="321166692"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:36:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="633475138"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="633475138"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.211.214]) ([10.254.211.214])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:36:14 -0800
Message-ID: <0ec6205e-94a0-3c85-4513-51e4338d3284@linux.intel.com>
Date:   Fri, 6 Jan 2023 19:36:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH iommufd v3 4/9] iommufd: Convert to
 msi_device_has_isolated_msi()
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
References: <4-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <4-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
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
> Trivially use the new API.
>
> Tested-by: Matthew Rosato<mjrosato@linux.ibm.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/iommufd/device.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index d81f93a321afcb..9f3b9674d72e81 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -4,7 +4,6 @@
>   #include <linux/iommufd.h>
>   #include <linux/slab.h>
>   #include <linux/iommu.h>
> -#include <linux/irqdomain.h>
>   
>   #include "io_pagetable.h"
>   #include "iommufd_private.h"
> @@ -169,8 +168,7 @@ static int iommufd_device_setup_msi(struct iommufd_device *idev,
>   	 * operation from the device (eg a simple DMA) cannot trigger an
>   	 * interrupt outside this iommufd context.
>   	 */
> -	if (!device_iommu_capable(idev->dev, IOMMU_CAP_INTR_REMAP) &&
> -	    !irq_domain_check_msi_remap()) {
> +	if (!iommu_group_has_isolated_msi(idev->group)) {
>   		if (!allow_unsafe_interrupts)
>   			return -EPERM;

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

--

Best regards,

baolu

