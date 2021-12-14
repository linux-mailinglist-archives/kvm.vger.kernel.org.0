Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582544749F3
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 18:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbhLNRpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 12:45:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229593AbhLNRpy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 12:45:54 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEGroRe039985;
        Tue, 14 Dec 2021 17:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cQL974FWxJ8GeGIYdBY1quzzHN3qGVlLLB+fGlZEPS0=;
 b=SUUfuhSc5Tj7s16LM8wjHl9VkFPO3g9xgf4ZPR+1rrWgH2wQGdo9PE1j0GNoUUvHEnAQ
 oroUHaIvBRlcawTjrZJwFr2zYSiiifJxkAZogmCfAXVUadkrXtT8f9XQSU9669ABDiDy
 L0uOeNoB48P4/AJPeFkh4myZ81PoAqPaZk5Mu4gcCdD/zGX0qBGNqZJUdm757yZStPZC
 Bh+uB01iafX3HcGDP+bj4c3fXa1do5vwvUdMRJFRTs+TiKRpq30hVjw3ZZzJzq6EsaGO
 gc35jnWQnMBYLqDklnQve0CkmsPxxox8BlEtQlaYfU681EpyLkMRX/gJyiCJXq9D4meK zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r95tb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 17:45:53 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BEFCMLC018596;
        Tue, 14 Dec 2021 17:45:53 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r95taa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 17:45:52 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BEHMJ2a024935;
        Tue, 14 Dec 2021 17:45:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3cvkm98f9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 17:45:50 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BEHbnou46793134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 17:37:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E5BBA4040;
        Tue, 14 Dec 2021 17:45:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B98DA4051;
        Tue, 14 Dec 2021 17:45:46 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 17:45:45 +0000 (GMT)
Message-ID: <c1f1ca6b-916d-418a-5bc3-8debe53bfa5e@linux.ibm.com>
Date:   Tue, 14 Dec 2021 18:46:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 22/32] KVM: s390: pci: provide routines for
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
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-23-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207205743.150299-23-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: L8tKdtZwRmEz7ZQiC-TuPZFqky6QhJUl
X-Proofpoint-ORIG-GUID: QlgHwbTQkcs8YqhgsuUhXuVCIcxMjYls
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_07,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 21:57, Matthew Rosato wrote:
> These routines will be wired into the vfio_pci_zdev ioctl handlers to
> respond to requests to enable / disable a device for PCI I/O Address
> Translation assistance.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h |  15 ++++
>   arch/s390/include/asm/pci_dma.h |   2 +
>   arch/s390/kvm/pci.c             | 133 ++++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h             |   2 +
>   4 files changed, 152 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 54a0afdbe7d0..254275399f21 100644
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
> +};
>   
>   struct kvm_zdev {
>   	struct zpci_dev *zdev;
>   	struct kvm *kvm;
> +	struct kvm_zdev_ioat ioat;
>   	struct zpci_fib fib;
>   };
>   
> @@ -33,6 +43,11 @@ extern int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
>   				   bool assist);
>   extern int kvm_s390_pci_aif_disable(struct zpci_dev *zdev);
>   
> +extern int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev);
> +extern int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota);
> +extern int kvm_s390_pci_ioat_disable(struct zpci_dev *zdev);
> +extern u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev);
> +
>   extern int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
>   extern int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
>   extern int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
> diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
> index 3b8e89d4578a..e1d3c1d3fc8a 100644
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
> index 3a29398dd53b..a1c0c0881332 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -12,6 +12,7 @@
>   #include <asm/kvm_pci.h>
>   #include <asm/pci.h>
>   #include <asm/pci_insn.h>
> +#include <asm/pci_dma.h>
>   #include <asm/sclp.h>
>   #include "pci.h"
>   #include "kvm-s390.h"
> @@ -315,6 +316,131 @@ int kvm_s390_pci_aif_disable(struct zpci_dev *zdev)
>   }
>   EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
>   
> +int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev)
> +{
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
> +
> +	if (!zdev->kzdev || !zdev->kzdev->kvm || zdev->kzdev->ioat.head[0])
> +		return -EINVAL;

The only caller already checked zdev->kzdev.
Could we use a macro to replace zdev->kzdev->ioat.head[0] ?
like
#define shadow_pgtbl_initialized zdev->kzdev->ioat.head[0]

Would be clearer for me.

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
> +		}
> +		iaddr = page_to_virt(page) + (gpa & ~PAGE_MASK);
> +		ioat->head[i] = (unsigned long *)iaddr;
> +		gpa += PAGE_SIZE;
> +	}
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	zdev->kzdev->ioat.seg = kcalloc(ZPCI_TABLE_ENTRIES_PAGES,
> +					sizeof(unsigned long *), GFP_KERNEL);
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
> +
> +free_seg:
> +	kfree(zdev->kzdev->ioat.seg);
> +unpin:
> +	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
> +		kvm_release_pfn_dirty((u64)ioat->head[i] >> PAGE_SHIFT);

I did not find when the pages are pinned.

> +		ioat->head[i] = 0;
> +	}
> +	mutex_unlock(&ioat->lock);
> +	return -ENOMEM;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_ioat_enable);
> +

...snip...
> 

-- 
Pierre Morel
IBM Lab Boeblingen
