Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0547304A
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 16:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbhLMPSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 10:18:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhLMPSt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 10:18:49 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BDEvFZk027559;
        Mon, 13 Dec 2021 15:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1sBfXeQq+/rVXDXMcuN60VTtyIEtONtbGtjS1nIB9K8=;
 b=V5uuqwbxddSJcYKAXcWNw56KFyvHM6vhkheMKhVPRdBE2c27oF8sk7vH8v9fzcSQftnW
 YCx15jbZQJQS9J5mA1+HO0zWneW119S2c/sFKq8fw8tGg5KOzD6gyEXKCE55CuZROjlc
 L4qQRkJn3nHaXKRT1aldDcGI0e9f6AOmzGvGPFiyx7kEQVjereqmF/kVM70YhoZ49xK3
 oQ08H9Oqtm8gXColSIKfpcqtlCFDZHxw6il+XPNIekczYbhySUVCcgUMAAejnzPhZ9Qj
 SRH5ypeWwKxZ5ie8lB7G5MNDJonyPNhb1UmOI4UPCYSEj2CQvURKw4y7OCwC3wRkrji4 zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx8d28jun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 15:18:48 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BDEx3Vu004132;
        Mon, 13 Dec 2021 15:18:48 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx8d28jtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 15:18:48 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BDFGCAU027570;
        Mon, 13 Dec 2021 15:18:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3cvkm96a40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 15:18:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BDFIgI138928714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 15:18:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6622A11C058;
        Mon, 13 Dec 2021 15:18:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FE9911C054;
        Mon, 13 Dec 2021 15:18:41 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Dec 2021 15:18:41 +0000 (GMT)
Message-ID: <a55bbfcb-7ad8-0b93-67dc-d574cbaf638a@linux.ibm.com>
Date:   Mon, 13 Dec 2021 16:19:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 13/32] KVM: s390: pci: add basic kvm_zdev structure
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
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-14-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207205743.150299-14-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rSI15PzhNDuwU-qlx9iKgDoy34c4yj0-
X-Proofpoint-ORIG-GUID: _ipOZ6z_rw--l-QfZAxZGL3YvHZXoRms
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_06,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 21:57, Matthew Rosato wrote:
> This structure will be used to carry kvm passthrough information related to
> zPCI devices.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h | 29 +++++++++++++++++
>   arch/s390/include/asm/pci.h     |  3 ++
>   arch/s390/kvm/Makefile          |  2 +-
>   arch/s390/kvm/pci.c             | 57 +++++++++++++++++++++++++++++++++
>   4 files changed, 90 insertions(+), 1 deletion(-)
>   create mode 100644 arch/s390/include/asm/kvm_pci.h
>   create mode 100644 arch/s390/kvm/pci.c
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> new file mode 100644
> index 000000000000..3e491a39704c
> --- /dev/null
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * KVM PCI Passthrough for virtual machines on s390
> + *
> + * Copyright IBM Corp. 2021
> + *
> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + */
> +
> +
> +#ifndef ASM_KVM_PCI_H
> +#define ASM_KVM_PCI_H
> +
> +#include <linux/types.h>
> +#include <linux/kvm_types.h>
> +#include <linux/kvm_host.h>
> +#include <linux/kvm.h>
> +#include <linux/pci.h>
> +
> +struct kvm_zdev {
> +	struct zpci_dev *zdev;
> +	struct kvm *kvm;
> +};
> +
> +extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
> +extern void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
> +extern int kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
> +
> +#endif /* ASM_KVM_PCI_H */
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 86f43644756d..32810e1ed308 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -97,6 +97,7 @@ struct zpci_bar_struct {
>   };
>   
>   struct s390_domain;
> +struct kvm_zdev;
>   
>   #define ZPCI_FUNCTIONS_PER_BUS 256
>   struct zpci_bus {
> @@ -190,6 +191,8 @@ struct zpci_dev {
>   	struct dentry	*debugfs_dev;
>   
>   	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
> +
> +	struct kvm_zdev *kzdev; /* passthrough data */
>   };
>   
>   static inline bool zdev_enabled(struct zpci_dev *zdev)
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index b3aaadc60ead..95ea865e5d29 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -10,6 +10,6 @@ common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  $(KVM)/async_pf.o \
>   ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>   
>   kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
> -kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
> +kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o pci.o
>   
>   obj-$(CONFIG_KVM) += kvm.o
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> new file mode 100644
> index 000000000000..ecfc458a5b39
> --- /dev/null
> +++ b/arch/s390/kvm/pci.c
> @@ -0,0 +1,57 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * s390 kvm PCI passthrough support
> + *
> + * Copyright IBM Corp. 2021
> + *
> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <linux/pci.h>
> +#include <asm/kvm_pci.h>
> +
> +int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
> +{
> +	struct kvm_zdev *kzdev;
> +
> +	if (zdev == NULL)
> +		return -ENODEV;

This check is not needed, why should this function be called with a NULL 
argument and the only caller at the moment already check it.

> +
> +	kzdev = kzalloc(sizeof(struct kvm_zdev), GFP_KERNEL);
> +	if (!kzdev)
> +		return -ENOMEM;
> +
> +	kzdev->zdev = zdev;
> +	zdev->kzdev = kzdev;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_open);
> +
> +void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
> +{
> +	struct kvm_zdev *kzdev;
> +
> +	if (!zdev || !zdev->kzdev)
> +		return;

same here

> +
> +	kzdev = zdev->kzdev;
> +	WARN_ON(kzdev->zdev != zdev);
> +	zdev->kzdev = 0;
> +	kfree(kzdev);
> +
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
> +
> +int kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm)
> +{
> +	struct kvm_zdev *kzdev = zdev->kzdev;
> +
> +	if (!kzdev)
> +		return -ENODEV;

and here

> +
> +	kzdev->kvm = kvm;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
> 

-- 
Pierre Morel
IBM Lab Boeblingen
