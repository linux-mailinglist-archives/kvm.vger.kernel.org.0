Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D888651020
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 17:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiLSQRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 11:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiLSQRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 11:17:24 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CF2112D;
        Mon, 19 Dec 2022 08:17:23 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJGBWlQ001910;
        Mon, 19 Dec 2022 16:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RtsWhsVJvLGz1G5bUGjFJl7qw+Tu+K2zEzV90qBQFDU=;
 b=PcuJHY6lD0GVFAt1z+4FuKrLP7tlVE2ajsO8MDv2BEK+YCnOtVy1Z4tMh+GAq+vyR7Zs
 db8cvsYRFYI0OgjLfuhmtBaigPiG09aIvwXwnCYNYky8pIvwjHAo1t0OmzSMM36V3EFp
 uFc+W5UW6MB+thwtH0lPtlb52GhBCkC1s8ADVU9trLzm8hidYq+upnQQx4o1RiauiVRp
 drpEzz3ctAzPKkXpjw5UNFBS1NRgu+t/VScThUM7BdCe17slII6dtVZc5C1JpwXfXjxA
 G7LTbr4FH3A5j0dlAuQ5kgeag/WyS75Z44te8Zbp9qZivoGsmZ/FHNGj3ZCbSBgFLqtD ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mju8v88ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 16:16:43 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BJGBlH1005097;
        Mon, 19 Dec 2022 16:16:42 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mju8v8896-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 16:16:42 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJFKOIC022061;
        Mon, 19 Dec 2022 16:16:40 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yxedf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 16:16:40 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJGGdek35324618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 16:16:39 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24E475805B;
        Mon, 19 Dec 2022 16:16:39 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65B645805C;
        Mon, 19 Dec 2022 16:16:36 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 16:16:36 +0000 (GMT)
Message-ID: <8275f4e0-aa73-d4e1-5612-ccf6a369fa07@linux.ibm.com>
Date:   Mon, 19 Dec 2022 11:16:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH iommufd v2 8/9] irq/s390: Add arch_is_isolated_msi() for
 s390
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
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
        Marc Zyngier <marc.zyngier@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
References: <8-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <8-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0m-J6pGlXN0pvE8Z2zYy5ilSktGE0m3s
X-Proofpoint-ORIG-GUID: haiwmW7D8jw19evlCLssWmJKGuC9cwcG
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190142
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/22 1:46 PM, Jason Gunthorpe wrote:
> s390 doesn't use irq_domains, so it has no place to set
> IRQ_DOMAIN_FLAG_ISOLATED_MSI. Instead of continuing to abuse the iommu
> subsystem to convey this information add a simple define which s390 can
> make statically true. The define will cause msi_device_has_isolated() to
> return true.
> 
> Remove IOMMU_CAP_INTR_REMAP from the s390 iommu driver.
> 
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

Also sanity-tested on s390 (needed the previously-mentioned #include <linux/msi.h> added to drivers/iommu/iommu.c)

> ---
>  arch/s390/include/asm/msi.h | 17 +++++++++++++++++
>  drivers/iommu/s390-iommu.c  |  2 --
>  include/linux/msi.h         |  6 +++++-
>  kernel/irq/msi.c            |  2 +-
>  4 files changed, 23 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/include/asm/msi.h
> 
> diff --git a/arch/s390/include/asm/msi.h b/arch/s390/include/asm/msi.h
> new file mode 100644
> index 00000000000000..399343ed9ffbc6
> --- /dev/null
> +++ b/arch/s390/include/asm/msi.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_S390_MSI_H
> +#define _ASM_S390_MSI_H
> +#include <asm-generic/msi.h>
> +
> +/*
> + * Work around S390 not using irq_domain at all so we can't set
> + * IRQ_DOMAIN_FLAG_ISOLATED_MSI. See for an explanation how it works:
> + *
> + * https://lore.kernel.org/r/31af8174-35e9-ebeb-b9ef-74c90d4bfd93@linux.ibm.com/
> + *
> + * Note this is less isolated than the ARM/x86 versions as userspace can trigger
> + * MSI belonging to kernel devices within the same gisa.
> + */
> +#define arch_is_isolated_msi() true
> +
> +#endif
> diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
> index 3c071782f6f16d..c80f4728c0f307 100644
> --- a/drivers/iommu/s390-iommu.c
> +++ b/drivers/iommu/s390-iommu.c
> @@ -44,8 +44,6 @@ static bool s390_iommu_capable(struct device *dev, enum iommu_cap cap)
>  	switch (cap) {
>  	case IOMMU_CAP_CACHE_COHERENCY:
>  		return true;
> -	case IOMMU_CAP_INTR_REMAP:
> -		return true;
>  	default:
>  		return false;
>  	}
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index e8a3f3a8a7f427..5cbe6a9d27efd6 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -48,6 +48,10 @@ typedef struct arch_msi_msg_data {
>  } __attribute__ ((packed)) arch_msi_msg_data_t;
>  #endif
>  
> +#ifndef arch_is_isolated_msi
> +#define arch_is_isolated_msi() false
> +#endif
> +
>  /**
>   * msi_msg - Representation of a MSI message
>   * @address_lo:		Low 32 bits of msi message address
> @@ -660,7 +664,7 @@ static inline bool msi_device_has_isolated_msi(struct device *dev)
>  	 * is inherently isolated by our definition. As nobody seems to needs
>  	 * this be conservative and return false anyhow.
>  	 */
> -	return false;
> +	return arch_is_isolated_msi();
>  }
>  #endif /* CONFIG_GENERIC_MSI_IRQ */
>  
> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
> index 7c5579d3ea4f79..3e46420a4f1a9f 100644
> --- a/kernel/irq/msi.c
> +++ b/kernel/irq/msi.c
> @@ -1646,6 +1646,6 @@ bool msi_device_has_isolated_msi(struct device *dev)
>  	for (; domain; domain = domain->parent)
>  		if (domain->flags & IRQ_DOMAIN_FLAG_ISOLATED_MSI)
>  			return true;
> -	return false;
> +	return arch_is_isolated_msi();
>  }
>  EXPORT_SYMBOL_GPL(msi_device_has_isolated_msi);

