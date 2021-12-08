Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FC046D3E9
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 13:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhLHNC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 08:02:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61134 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232257AbhLHNC5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 08:02:57 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8CrIHI020548;
        Wed, 8 Dec 2021 12:59:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2R23eaCrrVtdZBHHaFMGUQMsilAYzl2387ZDrVoF20Q=;
 b=oIMMaX4HfOwTx9zkYLVRL+qBqAUgUy+ukVDIqRZ8K6uCWlRXuBjRSRDDBIC1WvRHJ3Kx
 /8FjfO2jjeRlTxXT5y9ksRK678W05Wj4IQSkJ2MKyhNnC0WkXZ33LNM4e02fXVyIQ4c0
 QBSlTMmyq+KCMylneS81td8UDUZ1NxbUcg524pEvlEVVYauX8woyOGwk3AHUTHs+E8jN
 JzTlrH4uVTQp1/l7NE02wpX9fUShHHjsFQtjOiLc0Y5umIOWBv5RGzutn76EY/i/QwU6
 WSSYeLvPaeNqH8KQNqTkQCqd/r28RRJGR880ZTfp/Z4OJ3lA8+cJNMT66JXjIguzvD8H uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctw3w83e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:59:26 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8Cv3wB031807;
        Wed, 8 Dec 2021 12:59:25 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctw3w83d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:59:25 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8CsBta018166;
        Wed, 8 Dec 2021 12:59:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3cqyy9p9qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:59:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8CxJqF25624894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 12:59:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8B2EA404D;
        Wed,  8 Dec 2021 12:59:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEE58A4040;
        Wed,  8 Dec 2021 12:59:17 +0000 (GMT)
Received: from [9.171.54.177] (unknown [9.171.54.177])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 12:59:17 +0000 (GMT)
Message-ID: <2a5ec1f1-a0f4-9c55-38df-c48dfe9234f7@linux.ibm.com>
Date:   Wed, 8 Dec 2021 13:59:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 06/32] s390/airq: allow for airq structure that uses an
 input vector
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
 <20211207205743.150299-7-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-7-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: O0E25g8EFfYFOGfwJlLLldFUlYMRmlk-
X-Proofpoint-GUID: YHMG5Sn74x3c_OLc-6WQ-9EgbMV5m5Xp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> When doing device passthrough where interrupts are being forwarded
> from host to guest, we wish to use a pinned section of guest memory
> as the vector (the same memory used by the guest as the vector).
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
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
> index 880bcd73f11a..dfd4f3276a6d 100644
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
> @@ -296,7 +296,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
>   		zdev->aisb = bit;
>   
>   		/* Create adapter interrupt vector */
> -		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK);
> +		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK, 0);
>   		if (!zdev->aibv)
>   			return -ENOMEM;
>   
> @@ -421,7 +421,7 @@ static int __init zpci_directed_irq_init(void)
>   	union zpci_sic_iib iib = {{0}};
>   	unsigned int cpu;
>   
> -	zpci_sbv = airq_iv_create(num_possible_cpus(), 0);
> +	zpci_sbv = airq_iv_create(num_possible_cpus(), 0, 0);

For a pointer use NULL? Also in other places. With the indentation fix this looks sane.
