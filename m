Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A875F4791D9
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 17:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239332AbhLQQtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 11:49:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235967AbhLQQtR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 11:49:17 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHGeqGt016438;
        Fri, 17 Dec 2021 16:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k09d+GGnx5zwaMlBATH76XnriCr9KMVpFUw6EzYvU+0=;
 b=H6Pgyh5RFoMBGchwYLvyD/32j/Mqj8nbn7UNkDN7zbNo85nPeZH24XSdLrHCF2xe/7NN
 ymGrTJgiVY6ZfH8Ehvy5J4JHxuqstbVPsB901XhwqLWfPzv/AqpZ3ewKi/8t8NJyyV7c
 hyJSGMbO93zeIb9o9DziOh9QtyBG8fA5QJ3QUtv1hqeSoV7Sw3c2QlCKXdysEqxHgvKf
 SqnoRaD7j+LibAMrOtfJKoKXwM0r1HT7ku65wIPTKqcukninu+4L8EnqwxMGllSUOfe1
 w76xbpJE+zqMqKAEj2gq20b7fFyXgq/rwCysTZPQ+6GR9Z79QTFHZjoq4D3RpVlhidAn 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d0v68bcrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 16:49:12 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHGUNr1017364;
        Fri, 17 Dec 2021 16:49:12 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d0v68bcqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 16:49:12 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHGOYWi006552;
        Fri, 17 Dec 2021 16:49:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3cy7k9t9bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 16:49:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHGn7sd42598910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 16:49:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0964411C058;
        Fri, 17 Dec 2021 16:49:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CF2811C04C;
        Fri, 17 Dec 2021 16:49:06 +0000 (GMT)
Received: from [9.171.54.231] (unknown [9.171.54.231])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 16:49:06 +0000 (GMT)
Message-ID: <01530507-184c-782d-0ae3-632df0308d56@linux.ibm.com>
Date:   Fri, 17 Dec 2021 17:49:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 25/32] vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-26-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-26-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tBUQpTeDvmphaPRVLfZB_mhTL0Yu_Izk
X-Proofpoint-GUID: 2ZJ3pyQlADeZbsWjn6FIHIYfN-RFBW11
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_06,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112170095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
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

does this also depend on vfio-pci?

> +	default y
> +	help
> +	  Support s390x-specific extensions to enable support for enhancements
> +	  to KVM passthrough capabilities, such as interpretive execution of
> +	  zPCI instructions.
> +
> +	  To enable s390x KVM vfio-pci extensions, say Y.
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
