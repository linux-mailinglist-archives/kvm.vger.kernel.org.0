Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4732F492316
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbiARJse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:48:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232585AbiARJse (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:48:34 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I6QqHq016393;
        Tue, 18 Jan 2022 09:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EdPwNuQrqAvTuWVT0ODa8mxO+y2WE/frrmMVg5Z8hIA=;
 b=Z2PMnoz0cg90e4GtGlC9Ptm2XKQkQfh7+MH00WhAJ96Y863vK1FJnyNMa8HBb2UFUlA7
 rInuz2IovZoF0VNJ+zX+pC7JDCCffyhVYZFFh6A5wkKuPsdy2DDERuZG4adhACrYLFsf
 vw6vUquFWGvhwElSBAHIqfcRPExWL9vVyfVvG8ljJFCyR+nxAo6WTQpnOgoLp+v0aEbn
 aULm34S1v1SwWkO+DICDxsEzR4HhXxmarYfuddWWmkVxZ1+iuWB91UIcGOkuKhVzJFWd
 XX8JXPWW2LbVZUvPMOHxpT99MXTkZMJqmTPKPC31xmU11rGKi5OXMd4DoaU4znNrPFlS OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnr9sm7xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:48:33 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9bM83014697;
        Tue, 18 Jan 2022 09:48:33 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnr9sm7wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:48:32 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9m4qS005709;
        Tue, 18 Jan 2022 09:48:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3dknw99ej8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:48:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9mPfY28180822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:48:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCFFDAE045;
        Tue, 18 Jan 2022 09:48:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE9FDAE04D;
        Tue, 18 Jan 2022 09:48:24 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:48:24 +0000 (GMT)
Message-ID: <8a1ca4cf-a51a-9d45-0ed4-b48f6d8fb4a2@linux.ibm.com>
Date:   Tue, 18 Jan 2022 10:50:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 06/30] s390/airq: allow for airq structure that uses an
 input vector
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
 <20220114203145.242984-7-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-7-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qB1WlVRsqgjGOTP_b6IfGDHdJ_gKI3S7
X-Proofpoint-ORIG-GUID: rCzn2GvFPO6DyN4L_G_K8di86xPVJirz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> When doing device passthrough where interrupts are being forwarded
> from host to guest, we wish to use a pinned section of guest memory
> as the vector (the same memory used by the guest as the vector).
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>


Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


> ---
>   arch/s390/include/asm/airq.h     |  4 +++-
>   arch/s390/pci/pci_irq.c          |  8 ++++----
>   drivers/s390/cio/airq.c          | 10 +++++++---
>   drivers/s390/virtio/virtio_ccw.c |  2 +-
>   4 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/include/asm/airq.h b/arch/s390/include/asm/airq.h
> index 7918a7d09028..e82e5626e139 100644
> --- a/arch/s390/include/asm/airq.h
> +++ b/arch/s390/include/asm/airq.h
> @@ -47,8 +47,10 @@ struct airq_iv {
>   #define AIRQ_IV_PTR		4	/* Allocate the ptr array */
>   #define AIRQ_IV_DATA		8	/* Allocate the data array */
>   #define AIRQ_IV_CACHELINE	16	/* Cacheline alignment for the vector */
> +#define AIRQ_IV_GUESTVEC	32	/* Vector is a pinned guest page */
>   
> -struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags);
> +struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags,
> +			       unsigned long *vec);
>   void airq_iv_release(struct airq_iv *iv);
>   unsigned long airq_iv_alloc(struct airq_iv *iv, unsigned long num);
>   void airq_iv_free(struct airq_iv *iv, unsigned long bit, unsigned long num);
> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
> index cc4c8d7c8f5c..0d0a02a9fbbf 100644
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
> @@ -296,7 +296,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
>   		zdev->aisb = bit;
>   
>   		/* Create adapter interrupt vector */
> -		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK);
> +		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK, NULL);
>   		if (!zdev->aibv)
>   			return -ENOMEM;
>   
> @@ -419,7 +419,7 @@ static int __init zpci_directed_irq_init(void)
>   	union zpci_sic_iib iib = {{0}};
>   	unsigned int cpu;
>   
> -	zpci_sbv = airq_iv_create(num_possible_cpus(), 0);
> +	zpci_sbv = airq_iv_create(num_possible_cpus(), 0, NULL);
>   	if (!zpci_sbv)
>   		return -ENOMEM;
>   
> @@ -441,7 +441,7 @@ static int __init zpci_directed_irq_init(void)
>   		zpci_ibv[cpu] = airq_iv_create(cache_line_size() * BITS_PER_BYTE,
>   					       AIRQ_IV_DATA |
>   					       AIRQ_IV_CACHELINE |
> -					       (!cpu ? AIRQ_IV_ALLOC : 0));
> +					       (!cpu ? AIRQ_IV_ALLOC : 0), NULL);
>   		if (!zpci_ibv[cpu])
>   			return -ENOMEM;
>   	}
> @@ -458,7 +458,7 @@ static int __init zpci_floating_irq_init(void)
>   	if (!zpci_ibv)
>   		return -ENOMEM;
>   
> -	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC);
> +	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, NULL);
>   	if (!zpci_sbv)
>   		goto out_free;
>   
> diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
> index 2f2226786319..375a58b1c838 100644
> --- a/drivers/s390/cio/airq.c
> +++ b/drivers/s390/cio/airq.c
> @@ -122,10 +122,12 @@ static inline unsigned long iv_size(unsigned long bits)
>    * airq_iv_create - create an interrupt vector
>    * @bits: number of bits in the interrupt vector
>    * @flags: allocation flags
> + * @vec: pointer to pinned guest memory if AIRQ_IV_GUESTVEC
>    *
>    * Returns a pointer to an interrupt vector structure
>    */
> -struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
> +struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags,
> +			       unsigned long *vec)
>   {
>   	struct airq_iv *iv;
>   	unsigned long size;
> @@ -146,6 +148,8 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
>   					     &iv->vector_dma);
>   		if (!iv->vector)
>   			goto out_free;
> +	} else if (flags & AIRQ_IV_GUESTVEC) {
> +		iv->vector = vec;
>   	} else {
>   		iv->vector = cio_dma_zalloc(size);
>   		if (!iv->vector)
> @@ -185,7 +189,7 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
>   	kfree(iv->avail);
>   	if (iv->flags & AIRQ_IV_CACHELINE && iv->vector)
>   		dma_pool_free(airq_iv_cache, iv->vector, iv->vector_dma);
> -	else
> +	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
>   		cio_dma_free(iv->vector, size);
>   	kfree(iv);
>   out:
> @@ -204,7 +208,7 @@ void airq_iv_release(struct airq_iv *iv)
>   	kfree(iv->bitlock);
>   	if (iv->flags & AIRQ_IV_CACHELINE)
>   		dma_pool_free(airq_iv_cache, iv->vector, iv->vector_dma);
> -	else
> +	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
>   		cio_dma_free(iv->vector, iv_size(iv->bits));
>   	kfree(iv->avail);
>   	kfree(iv);
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 52c376d15978..410498d693f8 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -241,7 +241,7 @@ static struct airq_info *new_airq_info(int index)
>   		return NULL;
>   	rwlock_init(&info->lock);
>   	info->aiv = airq_iv_create(VIRTIO_IV_BITS, AIRQ_IV_ALLOC | AIRQ_IV_PTR
> -				   | AIRQ_IV_CACHELINE);
> +				   | AIRQ_IV_CACHELINE, NULL);
>   	if (!info->aiv) {
>   		kfree(info);
>   		return NULL;
> 

-- 
Pierre Morel
IBM Lab Boeblingen
