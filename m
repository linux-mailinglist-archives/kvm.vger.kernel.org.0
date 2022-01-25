Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCFA49B522
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577296AbiAYNay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:30:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59768 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1577065AbiAYN2T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 08:28:19 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PDC68N013984;
        Tue, 25 Jan 2022 13:28:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y8AQAx7pdo5NCiqYDsxe/2JWdeVRlx9pu21d8bMBJws=;
 b=SF9S6u1m5soRO80JbcCwrgWYj+PcbPNrQPX0CFyQb+Ifn6zp065Utq0cGNntntExd5le
 PqFnsjStZTnREZRb42Y3Js0OtdcmUChcrG8dEaY6kocZGEUXP02ns/tQUb4qsT7ol8/l
 1sowCTYxxs6ufKJMtJsYJBhrS0cBapRSNa1QQOI4JJY/I8dBfe05CcltWPCAd9hUq3IB
 s5kqBSem0WGjUv8yVxEbTaAmdlUXNXIvSQYXcFCWWQk5rB8IqBctWbAnOpx3gZMFgSSz
 uxXAaStBq2qhz/DARI0VJzvUw+FO44tPRNc8FqzEFOj5NwS6XkEv8XLg6hb/prn4R9l7 jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dthvh8a0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 13:28:13 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PDJCYX005651;
        Tue, 25 Jan 2022 13:28:13 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dthvh8a09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 13:28:13 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PDRPNR015144;
        Tue, 25 Jan 2022 13:28:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3dr9j9d48h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 13:28:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PDS8hT27591118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 13:28:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FE70AE045;
        Tue, 25 Jan 2022 13:28:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB597AE057;
        Tue, 25 Jan 2022 13:28:06 +0000 (GMT)
Received: from [9.171.58.95] (unknown [9.171.58.95])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 13:28:06 +0000 (GMT)
Message-ID: <12b9fba1-38b4-057d-49f4-969f2e7e1be3@linux.ibm.com>
Date:   Tue, 25 Jan 2022 14:29:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 20/30] KVM: s390: pci: provide routines for
 enabling/disabling IOAT assist
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
 <20220114203145.242984-21-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-21-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X8kfcrxN8VCzGWKZdicZwnHJcGAKAyZ9
X-Proofpoint-ORIG-GUID: 1hXTUuoSq8xFdx-m3Q3Uz5R2aEGJfYqM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> These routines will be wired into the vfio_pci_zdev ioctl handlers to
> respond to requests to enable / disable a device for PCI I/O Address
> Translation assistance.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h |  15 ++++
>   arch/s390/include/asm/pci_dma.h |   2 +
>   arch/s390/kvm/pci.c             | 139 ++++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h             |   2 +
>   4 files changed, 158 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 01fe14fffd7a..770849f13a70 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -16,11 +16,21 @@
>   #include <linux/kvm_host.h>
>   #include <linux/kvm.h>
>   #include <linux/pci.h>
> +#include <linux/mutex.h>
>   #include <asm/pci_insn.h>
> +#include <asm/pci_dma.h>
> +
> +struct kvm_zdev_ioat {
> +	unsigned long *head[ZPCI_TABLE_PAGES];
> +	unsigned long **seg;
> +	unsigned long ***pt;
> +	struct mutex lock;

Can we please rename the mutex ioat_lock to have a unique name easy to 
follow for maintenance.
Can you please add a description about when the lock should be used?

> +};
>   
>   struct kvm_zdev {
>   	struct zpci_dev *zdev;
>   	struct kvm *kvm;
> +	struct kvm_zdev_ioat ioat;
>   	struct zpci_fib fib;
>   };
>   
> @@ -33,6 +43,11 @@ int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
>   			    bool assist);
>   int kvm_s390_pci_aif_disable(struct zpci_dev *zdev);
>   
> +int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev);
> +int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota);
> +int kvm_s390_pci_ioat_disable(struct zpci_dev *zdev);
> +u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev);
> +
>   int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
>   int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
>   int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
> diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
> index 91e63426bdc5..69e616d0712c 100644
> --- a/arch/s390/include/asm/pci_dma.h
> +++ b/arch/s390/include/asm/pci_dma.h
> @@ -50,6 +50,8 @@ enum zpci_ioat_dtype {
>   #define ZPCI_TABLE_ALIGN		ZPCI_TABLE_SIZE
>   #define ZPCI_TABLE_ENTRY_SIZE		(sizeof(unsigned long))
>   #define ZPCI_TABLE_ENTRIES		(ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
> +#define ZPCI_TABLE_PAGES		(ZPCI_TABLE_SIZE >> PAGE_SHIFT)
> +#define ZPCI_TABLE_ENTRIES_PAGES	(ZPCI_TABLE_ENTRIES * ZPCI_TABLE_PAGES)
>   
>   #define ZPCI_TABLE_BITS			11
>   #define ZPCI_PT_BITS			8
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 7ed9abc476b6..39c13c25a700 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -13,12 +13,15 @@
>   #include <asm/pci.h>
>   #include <asm/pci_insn.h>
>   #include <asm/pci_io.h>
> +#include <asm/pci_dma.h>
>   #include <asm/sclp.h>
>   #include "pci.h"
>   #include "kvm-s390.h"
>   
>   struct zpci_aift *aift;
>   
> +#define shadow_ioat_init zdev->kzdev->ioat.head[0]
> +
>   static inline int __set_irq_noiib(u16 ctl, u8 isc)
>   {
>   	union zpci_sic_iib iib = {{0}};
> @@ -344,6 +347,135 @@ int kvm_s390_pci_aif_disable(struct zpci_dev *zdev)
>   }
>   EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
>   
> +int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev)
> +{
> +	/* Must have a KVM association registered */

may be add something like : "The ioat structure is embeded in kzdev"

> +	if (!zdev->kzdev || !zdev->kzdev->kvm)

Why do we need to check for kvm ?
Having kzdev is already tested by the unique caller.

> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_ioat_probe);
> +
> +int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota)
> +{
> +	gpa_t gpa = (gpa_t)(iota & ZPCI_RTE_ADDR_MASK);
> +	struct kvm_zdev_ioat *ioat;
> +	struct page *page;
> +	struct kvm *kvm;
> +	unsigned int idx;
> +	void *iaddr;
> +	int i, rc = 0;

no need to initialize rc

> +
> +	if (shadow_ioat_init)
> +		return -EINVAL;
> +
> +	/* Ensure supported type specified */
> +	if ((iota & ZPCI_IOTA_RTTO_FLAG) != ZPCI_IOTA_RTTO_FLAG)
> +		return -EINVAL;
> +
> +	kvm = zdev->kzdev->kvm;
> +	ioat = &zdev->kzdev->ioat;
> +	mutex_lock(&ioat->lock);
> +	idx = srcu_read_lock(&kvm->srcu);
> +	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
> +		page = gfn_to_page(kvm, gpa_to_gfn(gpa));
> +		if (is_error_page(page)) {
> +			srcu_read_unlock(&kvm->srcu, idx);
> +			rc = -EIO;
> +			goto out;

			goto unpin ?

> +		}
> +		iaddr = page_to_virt(page) + (gpa & ~PAGE_MASK);
> +		ioat->head[i] = (unsigned long *)iaddr;
> +		gpa += PAGE_SIZE;
> +	}
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	zdev->kzdev->ioat.seg = kcalloc(ZPCI_TABLE_ENTRIES_PAGES,
> +					sizeof(unsigned long *), GFP_KERNEL);

What about:

         ioat->seg = kcalloc(ZPCI_TABLE_ENTRIES_PAGES,
                             sizeof(*ioat->seg), GFP_KERNEL);
	if (!ioat->seg)
...
	ioat->pt = ...
?

> +	if (!zdev->kzdev->ioat.seg)
> +		goto unpin;
> +	zdev->kzdev->ioat.pt = kcalloc(ZPCI_TABLE_ENTRIES,
> +				       sizeof(unsigned long **), GFP_KERNEL);
> +	if (!zdev->kzdev->ioat.pt)
> +		goto free_seg;
> +
> +out:
> +	mutex_unlock(&ioat->lock);
> +	return rc;

	return 0 ?

> +
> +free_seg:
> +	kfree(zdev->kzdev->ioat.seg);

kfree(ioat->seg) ?
rc = -ENOMEM;

> +unpin:
> +	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
> +		kvm_release_pfn_dirty((u64)ioat->head[i] >> PAGE_SHIFT);
> +		ioat->head[i] = 0;
> +	}
> +	mutex_unlock(&ioat->lock);
> +	return -ENOMEM;

	return rc;

> +}
...snip...

-- 
Pierre Morel
IBM Lab Boeblingen
