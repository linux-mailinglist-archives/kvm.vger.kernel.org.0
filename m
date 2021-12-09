Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC0246EC51
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbhLIP5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:57:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236456AbhLIP5y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 10:57:54 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9FgGbV025865;
        Thu, 9 Dec 2021 15:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WjhqF8FvEjT0X5Z+sWXTyVJCUWJTm5srS7KWE5DdzrU=;
 b=mnVi5f1St6GMNO8150VoU/QHNoMhFjaUrcuwM3AJb+7+vtSvQecGcrCByKfPvrVgVLmx
 bz1VAtqdDQkMRNT4+l03603S6EsmUXDAVMtp12mCTnsc7E9zfgEIGQUXt0r2IQCXJ4gx
 J6DwjPFVJDAsGhfp2XXQNm25GgSiCE7DKk4kBqKpmNnQI8tesSQ9eAmR1j5X7mjn8qec
 BQN1Q+u6+tTP7J/4ySfF7uStFyqAsqKqyvjHg7ciTWElK6tqkYiUAH4cEAt1hwWbhpew
 zm60hrZyHfVkK7ohZgzLYEmf237COTRpOd7iA8zXEm/gZWU+ehuNFo1dk4QwkAe8630V HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cumnu09v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:54:20 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9FgVjo027048;
        Thu, 9 Dec 2021 15:54:20 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cumnu09uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:54:20 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9Fidhk013959;
        Thu, 9 Dec 2021 15:54:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3cqyya188n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 15:54:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9FsEOA30212454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 15:54:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5241E42049;
        Thu,  9 Dec 2021 15:54:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8480A4204F;
        Thu,  9 Dec 2021 15:54:13 +0000 (GMT)
Received: from [9.171.49.66] (unknown [9.171.49.66])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 15:54:13 +0000 (GMT)
Message-ID: <31c5cb5a-a027-a4a9-1dc1-c00664b871f9@linux.ibm.com>
Date:   Thu, 9 Dec 2021 16:54:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 13/32] KVM: s390: pci: add basic kvm_zdev structure
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
 <20211207205743.150299-14-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-14-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FBy1FrQ0iXIU-y6Q-9ickLgItv_xMVeO
X-Proofpoint-ORIG-GUID: A7L14lurIopJCp4R8nXOGJryFGH_ZN87
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_07,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> This structure will be used to carry kvm passthrough information related to
> zPCI devices.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Mostly a skeleton but looks ok

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

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
> +
> +	kzdev->kvm = kvm;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
> 
