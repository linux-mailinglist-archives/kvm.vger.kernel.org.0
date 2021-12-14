Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E3E473F1A
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhLNJPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:15:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhLNJP3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:15:29 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7JPxi019197;
        Tue, 14 Dec 2021 09:15:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eeWEuyoncgIPsMTlJsla1Eekh+vR3vqvBNkSJKTtJvs=;
 b=EHscHb4D1rFpeFVHXC7rK8lBwcR02qMB6E0aZZ4Njs0VpouFvdcNbI4OuiLiA4KchlNo
 Q0XOVD6QyeSQhCkU3K1NVpwTST8G9vUXNob6VM8Fa0Cx4TH3+M3KslAJ63bd8Xq5lY1F
 W3G2JoUIsKXEIhn6ldSxYN3nJVh7XvSeY7SqJXYt5Qd7908lkeBS72Esfpc06DRdh4gr
 BjdGxBs6LfAcQ3SyQ2A3kvunAW7C7GdYVxE+cHsg45cICOEYgYVSx3ko0fFtvQhX7QlH
 vqmtJDDLObyXNZA1a2sg8gAWNS0F+OqsbAmpdgpHk7gNomApx5NYuox7AjKO0NeGxmjO jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r85j80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:15:28 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BE9EBHE004055;
        Tue, 14 Dec 2021 09:15:28 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r85j6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:15:28 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE9FD9T018419;
        Tue, 14 Dec 2021 09:15:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3cvkm93hfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:15:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE9Eipt29491546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 09:14:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4ED2A404D;
        Tue, 14 Dec 2021 09:14:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89C44A405F;
        Tue, 14 Dec 2021 09:14:43 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 09:14:43 +0000 (GMT)
Message-ID: <6a46c9a4-af43-74c8-bba9-93dbd6c6c68d@linux.ibm.com>
Date:   Tue, 14 Dec 2021 10:15:47 +0100
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
X-Proofpoint-GUID: W4FUqTp32COd92TdrdondKDUblGGAayC
X-Proofpoint-ORIG-GUID: yNOeHvv_064Cc7qE1Kb3Z5YnJiGoKzlb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_05,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112140052
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

No need for "extern" in the prototype definition.


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

No need for a blanc line before the end of the function


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

-- 
Pierre Morel
IBM Lab Boeblingen
