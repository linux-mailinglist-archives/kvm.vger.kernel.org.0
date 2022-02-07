Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121254AB826
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 11:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245639AbiBGKAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 05:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbiBGJqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 04:46:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EBBC043181;
        Mon,  7 Feb 2022 01:46:17 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2177eTee005294;
        Mon, 7 Feb 2022 08:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mXUS5E31xMgMyy2harsK5/v2WyJt3NthIDs8hYT0qZk=;
 b=sEfVWAD+6g2KFMMjiJ2tgAPBR4V888cKD19NcfvHnTTZU58suHA3nzuOZ5MHNKpeejBU
 Gy7Isb2ve1Wxb+c3Potd8ygqVfaaLNWPPb82LrXt5A6jK/H4yVRN2+GbzHM7c2Fz+k5e
 SPEdMun/TyhVYp14EaZ80q60oe32p93OMpmCe4+HguGrIYtf7EEwB6Rjr5uXNDGjPBww
 X/WNEoElXRZ1V8ASdhycSYGaL80zdr/BcDa19YswT4oa+S9UgQSGnLV7FII/tpumlJDK
 10U7hXCpy4RNyxVBmknmnzRK7EOmXybsVmYwmoHt43xhqL80pDZUsVHIx2JhrNkw9cBn xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22m5pfkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 08:45:06 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2178Ruaf005936;
        Mon, 7 Feb 2022 08:45:05 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22m5pfjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 08:45:05 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2178itBW008839;
        Mon, 7 Feb 2022 08:45:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3e1gv9sd1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 08:45:03 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2178iuhT48627992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 08:44:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 490F811C052;
        Mon,  7 Feb 2022 08:44:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 364E011C069;
        Mon,  7 Feb 2022 08:44:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.12])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 08:44:55 +0000 (GMT)
Date:   Mon, 7 Feb 2022 09:42:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/30] s390/airq: allow for airq structure that uses
 an input vector
Message-ID: <20220207094239.3676937d@p-imbrenda>
In-Reply-To: <20220204211536.321475-7-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
        <20220204211536.321475-7-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nBmplog2dwNP5WkW8_h-pm3Ow6POOsUb
X-Proofpoint-ORIG-GUID: HwWIRaW3eNmpC-iUa_eyDpfzNUXDbB8h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_03,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Feb 2022 16:15:12 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> When doing device passthrough where interrupts are being forwarded from
> host to guest, we wish to use a pinned section of guest memory as the
> vector (the same memory used by the guest as the vector). To accomplish
> this, add a new parameter for airq_iv_create which allows passing an
> existing vector to be used instead of allocating a new one. The caller
> is responsible for ensuring the vector is pinned in memory as well as for
> unpinning the memory when the vector is no longer needed.
> 
> A subsequent patch will use this new parameter for zPCI interpretation.
> 
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/airq.h     |  4 +++-
>  arch/s390/pci/pci_irq.c          |  8 ++++----
>  drivers/s390/cio/airq.c          | 10 +++++++---
>  drivers/s390/virtio/virtio_ccw.c |  2 +-
>  4 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/include/asm/airq.h b/arch/s390/include/asm/airq.h
> index 7918a7d09028..e82e5626e139 100644
> --- a/arch/s390/include/asm/airq.h
> +++ b/arch/s390/include/asm/airq.h
> @@ -47,8 +47,10 @@ struct airq_iv {
>  #define AIRQ_IV_PTR		4	/* Allocate the ptr array */
>  #define AIRQ_IV_DATA		8	/* Allocate the data array */
>  #define AIRQ_IV_CACHELINE	16	/* Cacheline alignment for the vector */
> +#define AIRQ_IV_GUESTVEC	32	/* Vector is a pinned guest page */
>  
> -struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags);
> +struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags,
> +			       unsigned long *vec);
>  void airq_iv_release(struct airq_iv *iv);
>  unsigned long airq_iv_alloc(struct airq_iv *iv, unsigned long num);
>  void airq_iv_free(struct airq_iv *iv, unsigned long bit, unsigned long num);
> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
> index cc4c8d7c8f5c..0d0a02a9fbbf 100644
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
> @@ -296,7 +296,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
>  		zdev->aisb = bit;
>  
>  		/* Create adapter interrupt vector */
> -		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK);
> +		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK, NULL);
>  		if (!zdev->aibv)
>  			return -ENOMEM;
>  
> @@ -419,7 +419,7 @@ static int __init zpci_directed_irq_init(void)
>  	union zpci_sic_iib iib = {{0}};
>  	unsigned int cpu;
>  
> -	zpci_sbv = airq_iv_create(num_possible_cpus(), 0);
> +	zpci_sbv = airq_iv_create(num_possible_cpus(), 0, NULL);
>  	if (!zpci_sbv)
>  		return -ENOMEM;
>  
> @@ -441,7 +441,7 @@ static int __init zpci_directed_irq_init(void)
>  		zpci_ibv[cpu] = airq_iv_create(cache_line_size() * BITS_PER_BYTE,
>  					       AIRQ_IV_DATA |
>  					       AIRQ_IV_CACHELINE |
> -					       (!cpu ? AIRQ_IV_ALLOC : 0));
> +					       (!cpu ? AIRQ_IV_ALLOC : 0), NULL);
>  		if (!zpci_ibv[cpu])
>  			return -ENOMEM;
>  	}
> @@ -458,7 +458,7 @@ static int __init zpci_floating_irq_init(void)
>  	if (!zpci_ibv)
>  		return -ENOMEM;
>  
> -	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC);
> +	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, NULL);
>  	if (!zpci_sbv)
>  		goto out_free;
>  
> diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
> index 2f2226786319..375a58b1c838 100644
> --- a/drivers/s390/cio/airq.c
> +++ b/drivers/s390/cio/airq.c
> @@ -122,10 +122,12 @@ static inline unsigned long iv_size(unsigned long bits)
>   * airq_iv_create - create an interrupt vector
>   * @bits: number of bits in the interrupt vector
>   * @flags: allocation flags
> + * @vec: pointer to pinned guest memory if AIRQ_IV_GUESTVEC
>   *
>   * Returns a pointer to an interrupt vector structure
>   */
> -struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
> +struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags,
> +			       unsigned long *vec)
>  {
>  	struct airq_iv *iv;
>  	unsigned long size;
> @@ -146,6 +148,8 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
>  					     &iv->vector_dma);
>  		if (!iv->vector)
>  			goto out_free;
> +	} else if (flags & AIRQ_IV_GUESTVEC) {
> +		iv->vector = vec;
>  	} else {
>  		iv->vector = cio_dma_zalloc(size);
>  		if (!iv->vector)
> @@ -185,7 +189,7 @@ struct airq_iv *airq_iv_create(unsigned long bits, unsigned long flags)
>  	kfree(iv->avail);
>  	if (iv->flags & AIRQ_IV_CACHELINE && iv->vector)
>  		dma_pool_free(airq_iv_cache, iv->vector, iv->vector_dma);
> -	else
> +	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
>  		cio_dma_free(iv->vector, size);
>  	kfree(iv);
>  out:
> @@ -204,7 +208,7 @@ void airq_iv_release(struct airq_iv *iv)
>  	kfree(iv->bitlock);
>  	if (iv->flags & AIRQ_IV_CACHELINE)
>  		dma_pool_free(airq_iv_cache, iv->vector, iv->vector_dma);
> -	else
> +	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
>  		cio_dma_free(iv->vector, iv_size(iv->bits));
>  	kfree(iv->avail);
>  	kfree(iv);
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 52c376d15978..410498d693f8 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -241,7 +241,7 @@ static struct airq_info *new_airq_info(int index)
>  		return NULL;
>  	rwlock_init(&info->lock);
>  	info->aiv = airq_iv_create(VIRTIO_IV_BITS, AIRQ_IV_ALLOC | AIRQ_IV_PTR
> -				   | AIRQ_IV_CACHELINE);
> +				   | AIRQ_IV_CACHELINE, NULL);
>  	if (!info->aiv) {
>  		kfree(info);
>  		return NULL;

