Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036A34709B6
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 20:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343516AbhLJTIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 14:08:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244771AbhLJTIk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 14:08:40 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAIvX3U028646;
        Fri, 10 Dec 2021 19:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=mTc6O31oy03pyueB0ZzmE2BTEFYfLWzisz8ir47qnPE=;
 b=eG6sd8Iw97iOO+94KvU8ID3hjBT/BUp+nL48K/6J/5/mnwa70a1MTDdI/U+keRcnlq9H
 3idmFgIyzSjCjx3SLqHSxl5SQ8WDDKW9tpfjuYen42GHtvsqDEmNB22L3skIqiFBm0aB
 apb9/fwyMa+RmNBj/VMxEMXpIw5PBNs8i1MpZUevo5K0mrk4pJ3uLAmt7tMNFprKTQlo
 gfx24RDB3S/3eAOJvURhQvyDalqL/nsNu5fxcoQepZiD9RGxY2cJAjWy3YjQ0apbovjt
 jWS9/kvSAjTj+nGfAQvKmyTffHrvu8mrH8TKYTLpIr6scLjJf/f+4mPB3gtxpCppf7RC zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cvcmn842d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 19:05:04 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BAJ2qVM018055;
        Fri, 10 Dec 2021 19:05:04 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cvcmn8421-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 19:05:03 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BAIcRfS009598;
        Fri, 10 Dec 2021 19:05:03 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 3cqyy9w30n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 19:05:03 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BAJ52kA47055216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 19:05:02 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CF0D2806A;
        Fri, 10 Dec 2021 19:05:02 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 604522805E;
        Fri, 10 Dec 2021 19:04:57 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.80.105])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 10 Dec 2021 19:04:57 +0000 (GMT)
Message-ID: <8c5a0eadb764cfd7769fdbcd4b060eee40c6a43d.camel@linux.ibm.com>
Subject: Re: [PATCH 13/32] KVM: s390: pci: add basic kvm_zdev structure
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 10 Dec 2021 14:04:55 -0500
In-Reply-To: <20211207205743.150299-14-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-14-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MJwru0hY28u-mzsAofYsjX8e18mBUNlI
X-Proofpoint-GUID: N1NmPQxi88FQTUAArtvypkzHZEnl1d8Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_07,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
> This structure will be used to carry kvm passthrough information
> related to
> zPCI devices.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_pci.h | 29 +++++++++++++++++
>  arch/s390/include/asm/pci.h     |  3 ++
>  arch/s390/kvm/Makefile          |  2 +-
>  arch/s390/kvm/pci.c             | 57
> +++++++++++++++++++++++++++++++++
>  4 files changed, 90 insertions(+), 1 deletion(-)
>  create mode 100644 arch/s390/include/asm/kvm_pci.h
>  create mode 100644 arch/s390/kvm/pci.c
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h
> b/arch/s390/include/asm/kvm_pci.h
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
> +extern int kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm
> *kvm);
> +
> +#endif /* ASM_KVM_PCI_H */
> diff --git a/arch/s390/include/asm/pci.h
> b/arch/s390/include/asm/pci.h
> index 86f43644756d..32810e1ed308 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -97,6 +97,7 @@ struct zpci_bar_struct {
>  };
>  
>  struct s390_domain;
> +struct kvm_zdev;
>  
>  #define ZPCI_FUNCTIONS_PER_BUS 256
>  struct zpci_bus {
> @@ -190,6 +191,8 @@ struct zpci_dev {
>  	struct dentry	*debugfs_dev;
>  
>  	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
> +
> +	struct kvm_zdev *kzdev; /* passthrough data */
>  };
>  
>  static inline bool zdev_enabled(struct zpci_dev *zdev)
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index b3aaadc60ead..95ea865e5d29 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -10,6 +10,6 @@ common-objs = $(KVM)/kvm_main.o
> $(KVM)/eventfd.o  $(KVM)/async_pf.o \
>  ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>  
>  kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o
> sigp.o
> -kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
> +kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o pci.o
>  
>  obj-$(CONFIG_KVM) += kvm.o
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

