Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8F04908B2
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 13:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbiAQM3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 07:29:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55668 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231537AbiAQM3c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 07:29:32 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20H9vg0c026569;
        Mon, 17 Jan 2022 12:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Jhw74Q0ZA1B5FRWJ7Ovl7UMYmHpd6o0tDAaLcyQwQ5g=;
 b=dwQpauLv4gH0NEVj99WfaryH+BQgdY1McCGKH3PW/I+Z5LMpiA1xQqMKl1A+D5xyZ1Q/
 ggra1JoRK4en/4eeyVUpJvQpVWFbOCCiN0T3R+iRMyyjcuj84yH6y8hp4WLATBcqCi0d
 qlclEeuRcMK6dPTAGMOv3DgOKVxrlsF64gimxUQ8GIxnxIJfFV8gvtr3sBBjZ9fiUNpj
 OYDgLY2oTcDVvqaOS7GW4s7WhC7MT5p4zRl7/xGbd27TfKBIlx7FBgseWY699nfzQQRM
 irIoEwMD4rBtpwMJUiuqFswsFRvtZY5qpqcq5IaTfPSKEA9UvvU07E06AT9M+igG8a/t sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dn69mkbqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 12:29:31 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HBlZR3027470;
        Mon, 17 Jan 2022 12:29:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dn69mkbpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 12:29:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HCD9bc016683;
        Mon, 17 Jan 2022 12:29:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3dknw8uumc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 12:29:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HCTNnq41484556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 12:29:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C2CEA404D;
        Mon, 17 Jan 2022 12:29:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54547A405D;
        Mon, 17 Jan 2022 12:29:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.16])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 12:29:22 +0000 (GMT)
Date:   Mon, 17 Jan 2022 13:29:20 +0100
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
Subject: Re: [PATCH v2 06/30] s390/airq: allow for airq structure that uses
 an input vector
Message-ID: <20220117132920.213bf0bd@p-imbrenda>
In-Reply-To: <20220114203145.242984-7-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
        <20220114203145.242984-7-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mi00v2XWW5_9dqNyHAnjWZeh11y65dSm
X-Proofpoint-GUID: BVN8kD0eghT5z4ARzxEUqbHF8mrbHwpG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_05,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201170077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 15:31:21 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> When doing device passthrough where interrupts are being forwarded
> from host to guest, we wish to use a pinned section of guest memory
> as the vector (the same memory used by the guest as the vector).

maybe expand the description of the patch to explain what exactly is
being done in this patch. Namely: you add a parameter to a function
(and some logic in the function to use the new parameter), but the
function is not being used yet. And pinning is also done somewhere else.

maybe you can add something like

	This patch adds a new parameter for airq_iv_create to pass the
	existing vector pinned in guest memory and to use it when
	needed instead of allocating a new one.

Apart from that, the patch looks good.

> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
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
> +struct airq_iv *airq_iv_create(unsigned long bits, unsigned long
> flags,
> +			       unsigned long *vec);
>  void airq_iv_release(struct airq_iv *iv);
>  unsigned long airq_iv_alloc(struct airq_iv *iv, unsigned long num);
>  void airq_iv_free(struct airq_iv *iv, unsigned long bit, unsigned
> long num); diff --git a/arch/s390/pci/pci_irq.c
> b/arch/s390/pci/pci_irq.c index cc4c8d7c8f5c..0d0a02a9fbbf 100644
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
> @@ -296,7 +296,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int
> nvec, int type) zdev->aisb = bit;
>  
>  		/* Create adapter interrupt vector */
> -		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
> AIRQ_IV_BITLOCK);
> +		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
> AIRQ_IV_BITLOCK, NULL); if (!zdev->aibv)
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
>  		zpci_ibv[cpu] = airq_iv_create(cache_line_size() *
> BITS_PER_BYTE, AIRQ_IV_DATA |
>  					       AIRQ_IV_CACHELINE |
> -					       (!cpu ? AIRQ_IV_ALLOC
> : 0));
> +					       (!cpu ? AIRQ_IV_ALLOC
> : 0), NULL); if (!zpci_ibv[cpu])
>  			return -ENOMEM;
>  	}
> @@ -458,7 +458,7 @@ static int __init zpci_floating_irq_init(void)
>  	if (!zpci_ibv)
>  		return -ENOMEM;
>  
> -	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC);
> +	zpci_sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC,
> NULL); if (!zpci_sbv)
>  		goto out_free;
>  
> diff --git a/drivers/s390/cio/airq.c b/drivers/s390/cio/airq.c
> index 2f2226786319..375a58b1c838 100644
> --- a/drivers/s390/cio/airq.c
> +++ b/drivers/s390/cio/airq.c
> @@ -122,10 +122,12 @@ static inline unsigned long iv_size(unsigned
> long bits)
>   * airq_iv_create - create an interrupt vector
>   * @bits: number of bits in the interrupt vector
>   * @flags: allocation flags
> + * @vec: pointer to pinned guest memory if AIRQ_IV_GUESTVEC
>   *
>   * Returns a pointer to an interrupt vector structure
>   */
> -struct airq_iv *airq_iv_create(unsigned long bits, unsigned long
> flags) +struct airq_iv *airq_iv_create(unsigned long bits, unsigned
> long flags,
> +			       unsigned long *vec)
>  {
>  	struct airq_iv *iv;
>  	unsigned long size;
> @@ -146,6 +148,8 @@ struct airq_iv *airq_iv_create(unsigned long
> bits, unsigned long flags) &iv->vector_dma);
>  		if (!iv->vector)
>  			goto out_free;
> +	} else if (flags & AIRQ_IV_GUESTVEC) {
> +		iv->vector = vec;
>  	} else {
>  		iv->vector = cio_dma_zalloc(size);
>  		if (!iv->vector)
> @@ -185,7 +189,7 @@ struct airq_iv *airq_iv_create(unsigned long
> bits, unsigned long flags) kfree(iv->avail);
>  	if (iv->flags & AIRQ_IV_CACHELINE && iv->vector)
>  		dma_pool_free(airq_iv_cache, iv->vector,
> iv->vector_dma);
> -	else
> +	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
>  		cio_dma_free(iv->vector, size);
>  	kfree(iv);
>  out:
> @@ -204,7 +208,7 @@ void airq_iv_release(struct airq_iv *iv)
>  	kfree(iv->bitlock);
>  	if (iv->flags & AIRQ_IV_CACHELINE)
>  		dma_pool_free(airq_iv_cache, iv->vector,
> iv->vector_dma);
> -	else
> +	else if (!(iv->flags & AIRQ_IV_GUESTVEC))
>  		cio_dma_free(iv->vector, iv_size(iv->bits));
>  	kfree(iv->avail);
>  	kfree(iv);
> diff --git a/drivers/s390/virtio/virtio_ccw.c
> b/drivers/s390/virtio/virtio_ccw.c index 52c376d15978..410498d693f8
> 100644 --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -241,7 +241,7 @@ static struct airq_info *new_airq_info(int index)
>  		return NULL;
>  	rwlock_init(&info->lock);
>  	info->aiv = airq_iv_create(VIRTIO_IV_BITS, AIRQ_IV_ALLOC |
> AIRQ_IV_PTR
> -				   | AIRQ_IV_CACHELINE);
> +				   | AIRQ_IV_CACHELINE, NULL);
>  	if (!info->aiv) {
>  		kfree(info);
>  		return NULL;

