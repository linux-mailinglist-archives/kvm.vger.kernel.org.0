Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A206971633E
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 16:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjE3OKP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 30 May 2023 10:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbjE3OKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 10:10:13 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF20118
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 07:10:09 -0700 (PDT)
Received: from lhrpeml100003.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QVvPC2ZFtz67blC;
        Tue, 30 May 2023 22:07:59 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100003.china.huawei.com (7.191.160.210) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 15:10:06 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Tue, 30 May 2023 15:10:06 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Joao Martins <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFCv2 24/24] iommu/arm-smmu-v3: Advertise
 IOMMU_DOMAIN_F_ENFORCE_DIRTY
Thread-Topic: [PATCH RFCv2 24/24] iommu/arm-smmu-v3: Advertise
 IOMMU_DOMAIN_F_ENFORCE_DIRTY
Thread-Index: AQHZicpBslUZ4SR8FEqbgFGqVge/dq9y6VZw
Date:   Tue, 30 May 2023 14:10:06 +0000
Message-ID: <244a1a22766e4b46b75a74d202254b0d@huawei.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-25-joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-25-joao.m.martins@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.175.64]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Joao Martins [mailto:joao.m.martins@oracle.com]
> Sent: 18 May 2023 21:47
> To: iommu@lists.linux.dev
> Cc: Jason Gunthorpe <jgg@nvidia.com>; Kevin Tian <kevin.tian@intel.com>;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; Lu
> Baolu <baolu.lu@linux.intel.com>; Yi Liu <yi.l.liu@intel.com>; Yi Y Sun
> <yi.y.sun@intel.com>; Eric Auger <eric.auger@redhat.com>; Nicolin Chen
> <nicolinc@nvidia.com>; Joerg Roedel <joro@8bytes.org>; Jean-Philippe
> Brucker <jean-philippe@linaro.org>; Suravee Suthikulpanit
> <suravee.suthikulpanit@amd.com>; Will Deacon <will@kernel.org>; Robin
> Murphy <robin.murphy@arm.com>; Alex Williamson
> <alex.williamson@redhat.com>; kvm@vger.kernel.org; Joao Martins
> <joao.m.martins@oracle.com>
> Subject: [PATCH RFCv2 24/24] iommu/arm-smmu-v3: Advertise
> IOMMU_DOMAIN_F_ENFORCE_DIRTY
> 
> Now that we probe, and handle the DBM bit modifier, unblock
> the kAPI usage by exposing the IOMMU_DOMAIN_F_ENFORCE_DIRTY
> and implement it's requirement of revoking device attachment
> in the iommu_capable. Finally expose the IOMMU_CAP_DIRTY to
> users (IOMMUFD_DEVICE_GET_CAPS).
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index bf0aac333725..71dd95a687fd 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2014,6 +2014,8 @@ static bool arm_smmu_capable(struct device *dev,
> enum iommu_cap cap)
>  		return master->smmu->features &
> ARM_SMMU_FEAT_COHERENCY;
>  	case IOMMU_CAP_NOEXEC:
>  		return true;
> +	case IOMMU_CAP_DIRTY:
> +		return arm_smmu_dbm_capable(master->smmu);
>  	default:
>  		return false;
>  	}
> @@ -2430,6 +2432,11 @@ static int arm_smmu_attach_dev(struct
> iommu_domain *domain, struct device *dev)
>  	master = dev_iommu_priv_get(dev);
>  	smmu = master->smmu;
> 
> +	if (domain->flags & IOMMU_DOMAIN_F_ENFORCE_DIRTY &&
> +	    !arm_smmu_dbm_capable(smmu))
> +		return -EINVAL;
> +
> +

Since we have the supported_flags always set to " IOMMU_DOMAIN_F_ENFORCE_DIRTY"
below, platforms that doesn't have DBM capability will fail here, right? Or the idea is to set
domain flag only if the capability is reported true? But the iommu_domain_set_flags() doesn't
seems to check the capability though. 

(This seems to be causing problem with a rebased Qemu branch for ARM I have while sanity
testing on a platform that doesn't have DBM. I need to double check though).

Thanks,
Shameer

   
>  	/*
>  	 * Checking that SVA is disabled ensures that this device isn't bound to
>  	 * any mm, and can be safely detached from its old domain. Bonds
> cannot
> @@ -2913,6 +2920,7 @@ static void arm_smmu_remove_dev_pasid(struct
> device *dev, ioasid_t pasid)
>  }
> 
>  static struct iommu_ops arm_smmu_ops = {
> +	.supported_flags	= IOMMU_DOMAIN_F_ENFORCE_DIRTY,
>  	.capable		= arm_smmu_capable,
>  	.domain_alloc		= arm_smmu_domain_alloc,
>  	.probe_device		= arm_smmu_probe_device,
> --
> 2.17.2

