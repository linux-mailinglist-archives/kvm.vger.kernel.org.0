Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC28493739
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 10:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353071AbiASJ1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 04:27:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1352766AbiASJ12 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 04:27:28 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20J8Rq63014373;
        Wed, 19 Jan 2022 09:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9W0ifsnFqqA1O4RNHpUc+NyrcJ9s6shJm0TwViRtohc=;
 b=M8rOlqOMVclrdWfLHBDv+yeWXX/uFTJRstfMtGD+ddMmQPzxcp/9Pn8PSfBS+W34ZCh6
 fMh1HsDLf2Ps4FHrb/2H/49qkjz9EuGY+kDis64QhxGo8Ry+EhKPQcb87xTwRiYCBufl
 9NqSpJlRG9N4Yzjl/AKr/VziJ9WSu4tr6o36Ptek5b68EdRqk2tX5fVlGExxvGzWCrci
 kPxlgNTaj3/RIY4FQW6Pxs/kENpuyP5gzV2L9iLlAD2HVtUcoPxdm1128+BsrDkoDV6k
 71+e9wt3eXVl6zIGR9dmICJlt8iyT+z0nW/39GypBOtkekEttmr9L3lcUAbDOMTXc3H2 CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpf5h14xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 09:27:27 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20J8gQc3002328;
        Wed, 19 Jan 2022 09:27:26 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpf5h14xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 09:27:26 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20J9BxNM004010;
        Wed, 19 Jan 2022 09:27:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9uq72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 09:27:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20J9I0GG14352660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 09:18:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6EF7A4059;
        Wed, 19 Jan 2022 09:27:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F2B8A4051;
        Wed, 19 Jan 2022 09:27:18 +0000 (GMT)
Received: from [9.171.7.240] (unknown [9.171.7.240])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 09:27:18 +0000 (GMT)
Message-ID: <265e3448-2e8e-c38b-e625-1546ae3d408b@linux.ibm.com>
Date:   Wed, 19 Jan 2022 10:29:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 21/30] KVM: s390: pci: handle refresh of PCI
 translations
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
 <20220114203145.242984-22-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-22-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6WhABobjSFm26SEWLViY8CmpSRwVVrsc
X-Proofpoint-ORIG-GUID: Y3UPRGUPpAyRqclYPeei0QMdl_O-2v6w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_06,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201190049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> Add a routine that will perform a shadow operation between a guest
> and host IOAT.  A subsequent patch will invoke this in response to
> an 04 RPCIT instruction intercept.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h |   1 +
>   arch/s390/include/asm/pci_dma.h |   1 +
>   arch/s390/kvm/pci.c             | 208 +++++++++++++++++++++++++++++++-
>   arch/s390/kvm/pci.h             |   8 +-
>   4 files changed, 216 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 770849f13a70..fa90729a35cf 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -30,6 +30,7 @@ struct kvm_zdev_ioat {
>   struct kvm_zdev {
>   	struct zpci_dev *zdev;
>   	struct kvm *kvm;
> +	u64 rpcit_count;
>   	struct kvm_zdev_ioat ioat;
>   	struct zpci_fib fib;
>   };
> diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
> index 69e616d0712c..38004e0a4383 100644
> --- a/arch/s390/include/asm/pci_dma.h
> +++ b/arch/s390/include/asm/pci_dma.h
> @@ -52,6 +52,7 @@ enum zpci_ioat_dtype {
>   #define ZPCI_TABLE_ENTRIES		(ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
>   #define ZPCI_TABLE_PAGES		(ZPCI_TABLE_SIZE >> PAGE_SHIFT)
>   #define ZPCI_TABLE_ENTRIES_PAGES	(ZPCI_TABLE_ENTRIES * ZPCI_TABLE_PAGES)
> +#define ZPCI_TABLE_ENTRIES_PER_PAGE	(ZPCI_TABLE_ENTRIES / ZPCI_TABLE_PAGES)
>   
>   #define ZPCI_TABLE_BITS			11
>   #define ZPCI_PT_BITS			8
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 39c13c25a700..38d2b77ec565 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -149,6 +149,208 @@ int kvm_s390_pci_aen_init(u8 nisc)
>   	return rc;
>   }
>   
> +static int dma_shadow_cpu_trans(struct kvm_vcpu *vcpu, unsigned long *entry,
> +				unsigned long *gentry)
> +{
> +	phys_addr_t gaddr = 0;
> +	unsigned long idx;
> +	struct page *page;
> +	kvm_pfn_t pfn;
> +	gpa_t addr;
> +	int rc = 0;
> +
> +	if (pt_entry_isvalid(*gentry)) {
> +		/* pin and validate */
> +		addr = *gentry & ZPCI_PTE_ADDR_MASK;
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
> +		page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +		if (is_error_page(page))
> +			return -EIO;
> +		gaddr = page_to_phys(page) + (addr & ~PAGE_MASK);
> +	}
> +
> +	if (pt_entry_isvalid(*entry)) {
> +		/* Either we are invalidating, replacing or no-op */
> +		if (gaddr != 0) {
> +			if ((*entry & ZPCI_PTE_ADDR_MASK) == gaddr) {
> +				/* Duplicate */
> +				kvm_release_pfn_dirty(*entry >> PAGE_SHIFT);
> +			} else {
> +				/* Replace */
> +				pfn = (*entry >> PAGE_SHIFT);
> +				invalidate_pt_entry(entry);
> +				set_pt_pfaa(entry, gaddr);
> +				validate_pt_entry(entry);
> +				kvm_release_pfn_dirty(pfn);
> +				rc = 1;
> +			}
> +		} else {
> +			/* Invalidate */
> +			pfn = (*entry >> PAGE_SHIFT);
> +			invalidate_pt_entry(entry);
> +			kvm_release_pfn_dirty(pfn);
> +			rc = 1;
> +		}
> +	} else if (gaddr != 0) {
> +		/* New Entry */
> +		set_pt_pfaa(entry, gaddr);
> +		validate_pt_entry(entry);
> +	}
> +
> +	return rc;
> +}
> +
> +static unsigned long *dma_walk_guest_cpu_trans(struct kvm_vcpu *vcpu,
> +					       struct kvm_zdev_ioat *ioat,
> +					       dma_addr_t dma_addr)
> +{
> +	unsigned long *rto, *sto, *pto;
> +	unsigned int rtx, rts, sx, px, idx;
> +	struct page *page;
> +	gpa_t addr;
> +	int i;
> +
> +	/* Pin guest segment table if needed */
> +	rtx = calc_rtx(dma_addr);
> +	rto = ioat->head[(rtx / ZPCI_TABLE_ENTRIES_PER_PAGE)];
> +	rts = rtx * ZPCI_TABLE_PAGES;
> +	if (!ioat->seg[rts]) {
> +		if (!reg_entry_isvalid(rto[rtx % ZPCI_TABLE_ENTRIES_PER_PAGE]))
> +			return NULL;
> +		sto = get_rt_sto(rto[rtx % ZPCI_TABLE_ENTRIES_PER_PAGE]);
> +		addr = ((u64)sto & ZPCI_RTE_ADDR_MASK);
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
> +		for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
> +			page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
> +			if (is_error_page(page)) {
> +				srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +				return NULL;
> +			}
> +			ioat->seg[rts + i] = page_to_virt(page) +
> +					     (addr & ~PAGE_MASK);
> +			addr += PAGE_SIZE;
> +		}
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +	}
> +
> +	/* Allocate pin pointers for another segment table if needed */
> +	if (!ioat->pt[rtx]) {
> +		ioat->pt[rtx] = kcalloc(ZPCI_TABLE_ENTRIES,
> +					(sizeof(unsigned long *)), GFP_KERNEL);
> +		if (!ioat->pt[rtx])
> +			return NULL;
> +	}
> +	/* Pin guest page table if needed */
> +	sx = calc_sx(dma_addr);
> +	sto = ioat->seg[(rts + (sx / ZPCI_TABLE_ENTRIES_PER_PAGE))];
> +	if (!ioat->pt[rtx][sx]) {
> +		if (!reg_entry_isvalid(sto[sx % ZPCI_TABLE_ENTRIES_PER_PAGE]))
> +			return NULL;
> +		pto = get_st_pto(sto[sx % ZPCI_TABLE_ENTRIES_PER_PAGE]);
> +		if (!pto)
> +			return NULL;
> +		addr = ((u64)pto & ZPCI_STE_ADDR_MASK);
> +		idx = srcu_read_lock(&vcpu->kvm->srcu);
> +		page = gfn_to_page(vcpu->kvm, gpa_to_gfn(addr));
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +		if (is_error_page(page))
> +			return NULL;
> +		ioat->pt[rtx][sx] = page_to_virt(page) + (addr & ~PAGE_MASK);
> +	}
> +	pto = ioat->pt[rtx][sx];
> +
> +	/* Return guest PTE */
> +	px = calc_px(dma_addr);
> +	return &pto[px];
> +}
> +
> +
> +static int dma_table_shadow(struct kvm_vcpu *vcpu, struct zpci_dev *zdev,
> +			    dma_addr_t dma_addr, size_t size)
> +{
> +	unsigned int nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +	struct kvm_zdev *kzdev = zdev->kzdev;
> +	unsigned long *entry, *gentry;
> +	int i, rc = 0, rc2;
> +
> +	if (!nr_pages || !kzdev)
> +		return -EINVAL;
> +
> +	mutex_lock(&kzdev->ioat.lock);
> +	if (!zdev->dma_table || !kzdev->ioat.head[0]) {
> +		rc = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		gentry = dma_walk_guest_cpu_trans(vcpu, &kzdev->ioat, dma_addr);
> +		if (!gentry)
> +			continue;
> +		entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr);
> +
> +		if (!entry) {
> +			rc = -ENOMEM;
> +			goto out_unlock;
> +		}
> +
> +		rc2 = dma_shadow_cpu_trans(vcpu, entry, gentry);
> +		if (rc2 < 0) {
> +			rc = -EIO;
> +			goto out_unlock;
> +		}
> +		dma_addr += PAGE_SIZE;
> +		rc += rc2;
> +	}
> +

In case of error, shouldn't we invalidate the shadow tables entries we 
did validate until the error?

> +out_unlock:
> +	mutex_unlock(&kzdev->ioat.lock);
> +	return rc;
> +}
> +
> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
> +			       unsigned long start, unsigned long size,
> +			       u8 *status)
> +{
> +	struct zpci_dev *zdev;
> +	u32 fh = req >> 32;
> +	int rc;
> +
> +	/* Make sure this is a valid device associated with this guest */
> +	zdev = get_zdev_by_fh(fh);
> +	if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm) {
> +		*status = 0;

Wouldn't it be interesting to add some debug information here.
When would this appear?

Also if we have this error this looks like we have a VM problem, 
shouldn't we treat this in QEMU and return -EOPNOTSUPP ?

> +		return -EINVAL;
> +	}
> +
> +	/* Only proceed if the device is using the assist */
> +	if (zdev->kzdev->ioat.head[0] == 0)
> +		return -EOPNOTSUPP;
> +
> +	rc = dma_table_shadow(vcpu, zdev, start, size);
> +	if (rc < 0) {
> +		/*
> +		 * If errors encountered during shadow operations, we must
> +		 * fabricate status to present to the guest
> +		 */
> +		switch (rc) {
> +		case -ENOMEM:
> +			*status = KVM_S390_RPCIT_INS_RES;
> +			break;
> +		default:
> +			*status = KVM_S390_RPCIT_ERR;
> +			break;
> +		}
> +	} else if (rc > 0) {
> +		/* Host RPCIT must be issued */
> +		rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size,
> +					status);
> +	}
> +	zdev->kzdev->rpcit_count++;
> +
> +	return rc;
> +}
> +
>   /* Modify PCI: Register floating adapter interruption forwarding */
>   static int kvm_zpci_set_airq(struct zpci_dev *zdev)
>   {
> @@ -620,6 +822,8 @@ EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
>   
>   int kvm_s390_pci_init(void)
>   {
> +	int rc;
> +
>   	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
>   	if (!aift)
>   		return -ENOMEM;
> @@ -627,5 +831,7 @@ int kvm_s390_pci_init(void)
>   	spin_lock_init(&aift->gait_lock);
>   	mutex_init(&aift->lock);
>   
> -	return 0;
> +	rc = zpci_get_mdd(&aift->mdd);
> +
> +	return rc;
>   }
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> index 54355634df82..bb2be7fc3934 100644
> --- a/arch/s390/kvm/pci.h
> +++ b/arch/s390/kvm/pci.h
> @@ -18,6 +18,9 @@
>   
>   #define KVM_S390_PCI_DTSM_MASK 0x40
>   
> +#define KVM_S390_RPCIT_INS_RES 0x10
> +#define KVM_S390_RPCIT_ERR 0x28
> +
>   struct zpci_gaite {
>   	u32 gisa;
>   	u8 gisc;
> @@ -33,6 +36,7 @@ struct zpci_aift {
>   	struct kvm_zdev **kzdev;
>   	spinlock_t gait_lock; /* Protects the gait, used during AEN forward */
>   	struct mutex lock; /* Protects the other structures in aift */
> +	u32 mdd;
>   };
>   
>   extern struct zpci_aift *aift;
> @@ -47,7 +51,9 @@ static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
>   
>   int kvm_s390_pci_aen_init(u8 nisc);
>   void kvm_s390_pci_aen_exit(void);
> -
> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
> +			       unsigned long start, unsigned long end,
> +			       u8 *status);
>   int kvm_s390_pci_init(void);
>   
>   #endif /* __KVM_S390_PCI_H */
> 

-- 
Pierre Morel
IBM Lab Boeblingen
