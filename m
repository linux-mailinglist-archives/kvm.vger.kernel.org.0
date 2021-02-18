Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F124031F177
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 21:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBRU6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 15:58:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230380AbhBRU5i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 15:57:38 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IKWXkx148229;
        Thu, 18 Feb 2021 15:56:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=81IqNu1Zi1DbpbVFWWvsqaxth3EU563pyBqtxxg4bCc=;
 b=iPDlQH8QGinMqVuk5naEfsrNj7qnEG98i+4kILHXMhTCxj0fFX7JObKRbadAXPyEFlBp
 heiH4l1j+4SiJ8+oc4f5b/124SOB5jK4b4Z1fauqu0syyY0+TRhjeeWUnTQCvav7kQyE
 NrMjgatCRyEDTPIbeUCfiakDwSw/sH18FD/UnGnEXQo2LTPKoYijiFZUiox8WJUS0csL
 X/oZFgTm/Uk5o3Lz41fb0y6fSH0t6s7/ibVQ+0GHaWqmduJimmGnxyGxbgqZjNfB3any
 +ioyA3fXCrW7QmYpPzOizsdqtvqAb8LjE/WiWsEwiDFBZi27GEVLn8Er846NplRN/ZO4 Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36sy3vgwy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 15:56:52 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IKY1Ol152859;
        Thu, 18 Feb 2021 15:56:52 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36sy3vgwy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 15:56:52 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IKpjLB013265;
        Thu, 18 Feb 2021 20:56:51 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 36p6d9twrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 20:56:51 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IKunNP50463082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 20:56:50 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC636E04E;
        Thu, 18 Feb 2021 20:56:49 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32F6A6E04C;
        Thu, 18 Feb 2021 20:56:49 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.37.34])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 20:56:49 +0000 (GMT)
Subject: Re: [PATCH 1/1] vfio/pci: remove CONFIG_VFIO_PCI_ZDEV from Kconfig
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, alex.williamson@redhat.com
Cc:     oren@nvidia.com, jgg@nvidia.com
References: <20210218104435.464773-1-mgurtovoy@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <f2814341-c5e2-4dd4-19aa-0183acf734ed@linux.ibm.com>
Date:   Thu, 18 Feb 2021 15:56:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210218104435.464773-1-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_09:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 clxscore=1011 mlxscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180166
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/21 5:44 AM, Max Gurtovoy wrote:
> In case we're running on s390 system always expose the capabilities for
> configuration of zPCI devices. In case we're running on different
> platform, continue as usual.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>

Sanity-tested on s390 to verify that zdev caps are still available after 
CONFIG_VFIO_PCI_ZDEV is removed.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>   drivers/vfio/pci/Kconfig            | 12 ------------
>   drivers/vfio/pci/Makefile           |  2 +-
>   drivers/vfio/pci/vfio_pci.c         | 12 +++++-------
>   drivers/vfio/pci/vfio_pci_private.h |  2 +-
>   4 files changed, 7 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 40a223381ab6..ac3c1dd3edef 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -45,15 +45,3 @@ config VFIO_PCI_NVLINK2
>   	depends on VFIO_PCI && PPC_POWERNV
>   	help
>   	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
> -
> -config VFIO_PCI_ZDEV
> -	bool "VFIO PCI ZPCI device CLP support"
> -	depends on VFIO_PCI && S390
> -	default y
> -	help
> -	  Enabling this option exposes VFIO capabilities containing hardware
> -	  configuration for zPCI devices. This enables userspace (e.g. QEMU)
> -	  to supply proper configuration values instead of hard-coded defaults
> -	  for zPCI devices passed through via VFIO on s390.
> -
> -	  Say Y here.
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 781e0809d6ee..eff97a7cd9f1 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -3,6 +3,6 @@
>   vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
>   vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>   vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
> -vfio-pci-$(CONFIG_VFIO_PCI_ZDEV) += vfio_pci_zdev.o
> +vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
>   
>   obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 706de3ef94bb..65e7e6b44578 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -807,6 +807,7 @@ static long vfio_pci_ioctl(void *device_data,
>   		struct vfio_device_info info;
>   		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
>   		unsigned long capsz;
> +		int ret;
>   
>   		minsz = offsetofend(struct vfio_device_info, num_irqs);
>   
> @@ -832,13 +833,10 @@ static long vfio_pci_ioctl(void *device_data,
>   		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
>   		info.num_irqs = VFIO_PCI_NUM_IRQS;
>   
> -		if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV)) {
> -			int ret = vfio_pci_info_zdev_add_caps(vdev, &caps);
> -
> -			if (ret && ret != -ENODEV) {
> -				pci_warn(vdev->pdev, "Failed to setup zPCI info capabilities\n");
> -				return ret;
> -			}
> +		ret = vfio_pci_info_zdev_add_caps(vdev, &caps);
> +		if (ret && ret != -ENODEV) {
> +			pci_warn(vdev->pdev, "Failed to setup zPCI info capabilities\n");
> +			return ret;
>   		}
>   
>   		if (caps.size) {
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 5c90e560c5c7..9cd1882a05af 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -214,7 +214,7 @@ static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
>   }
>   #endif
>   
> -#ifdef CONFIG_VFIO_PCI_ZDEV
> +#ifdef CONFIG_S390
>   extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
>   				       struct vfio_info_cap *caps);
>   #else
> 

