Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86338492C26
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiARRTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:19:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25316 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243781AbiARRTQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:19:16 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IGvdQt015193;
        Tue, 18 Jan 2022 17:19:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MN7dELDCR2LBLFj2bEiMIb871iFxD1MD0Nq5roM1t+U=;
 b=hcAkZruNKcyf6lsNOlbb5lF5yIXUgn1K5k/IrhcsaEn/7+sYIssJkGP3uAUIRQrEFycC
 2FwPTcALNpLGY0dw5H3Nh9Z1mUModew3seqdsB68eNL0AQCnNA+AkIWiD76ocfy4j0O+
 y5Q1BkG/oFywwZYM0yV3EZy9GwV516+Fm9rbflvm3TjaEFkYKspeEO88mRMfqq09hrC5
 H7THxt471UlE79tG/jrt/BqDnYdgPRspyxZNRuhEhXJFDGmKO8BzoNxiFj2Vcjul02JU
 eGsnIClwkBiARDkZ+Qr/b6Fo4px3wBbVvALKbD8bN8MFaRMTiEpM5+8sY1+b2rpqbk/y qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1hfrfmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:19:16 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IGvwW9015843;
        Tue, 18 Jan 2022 17:19:15 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dp1hfrfm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:19:15 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IHHa12006908;
        Tue, 18 Jan 2022 17:19:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw9db9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:19:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IHJ9hT38338932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:19:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E50EAE04D;
        Tue, 18 Jan 2022 17:19:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 819BFAE053;
        Tue, 18 Jan 2022 17:19:08 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 17:19:08 +0000 (GMT)
Message-ID: <1ea61cf3-65b2-87ec-55b4-7dfa5f623d15@linux.ibm.com>
Date:   Tue, 18 Jan 2022 18:20:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 23/30] vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-24-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-24-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -0Hz7wpMr9ou707iK3FpxApm11DExpoL
X-Proofpoint-ORIG-GUID: dPVtb47df067lrQmMwQikGwH1NkvbY6h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> This was previously removed as unnecessary; while that was true, subsequent
> changes will make KVM an additional required component for vfio-pci-zdev.
> Let's re-introduce CONFIG_VFIO_PCI_ZDEV as now there is actually a reason
> to say 'n' for it (when not planning to CONFIG_KVM).
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   drivers/vfio/pci/Kconfig      | 11 +++++++++++
>   drivers/vfio/pci/Makefile     |  2 +-
>   include/linux/vfio_pci_core.h |  2 +-
>   3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 860424ccda1b..fedd1d4cb592 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -42,5 +42,16 @@ config VFIO_PCI_IGD
>   	  and LPC bridge config space.
>   
>   	  To enable Intel IGD assignment through vfio-pci, say Y.
> +
> +config VFIO_PCI_ZDEV
> +	bool "VFIO PCI extensions for s390x KVM passthrough"
> +	depends on S390 && KVM
> +	default y
> +	help
> +	  Support s390x-specific extensions to enable support for enhancements
> +	  to KVM passthrough capabilities, such as interpretive execution of
> +	  zPCI instructions.
> +
> +	  To enable s390x KVM vfio-pci extensions, say Y.

In several patches we check on CONFIG_PCI (14,15,16,17 and 22) but we 
may have PCI without VFIO_PCI, wouldn't it be a problem?

Here we define a new CONFIG entry and I have two questions:

1- there is no dependency on VFIO_PCI while the functionality is 
obviously based on VFIO_PCI

2- Wouldn't it be possible to use this item and the single condition for 
the different checks we need through the new VFIO interpretation 
functionality.




>   endif
>   endif
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 349d68d242b4..01b1f83d83d7 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -1,7 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   
>   vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
> -vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
> +vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV) += vfio_pci_zdev.o
>   obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>   
>   vfio-pci-y := vfio_pci.o
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index ef9a44b6cf5d..5e2bca3b89db 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -195,7 +195,7 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
>   }
>   #endif
>   
> -#ifdef CONFIG_S390
> +#ifdef CONFIG_VFIO_PCI_ZDEV
>   extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   				       struct vfio_info_cap *caps);
>   #else
> 

-- 
Pierre Morel
IBM Lab Boeblingen
