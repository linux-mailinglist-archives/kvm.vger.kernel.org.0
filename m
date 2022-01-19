Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8D0493FAE
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356660AbiASSMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:12:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235059AbiASSMU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 13:12:20 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JIBKeA015229;
        Wed, 19 Jan 2022 18:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DXVT90Ni812Qjvd09YSEGxAUmpaGEYjJrjGTrU5hi9U=;
 b=o8WmejOXNNn4vBWwnVshn5Ydx156Mkn3lr1wGBaxPVDFKBVFzeItMMia/O3Yv/gQ3Hyx
 yKs5rgNtEg1HqErQBRdSS/cSBgRJA95s76cq6PuGLKFdyAKE2hSUyrkVxUY0hv28GJaN
 ylyPCyduYi075GTO7NmYRpYCMu1GnPnrpcm7/DSb1pBbCyOQb3TP2QqMsoqYuuUN89iB
 RqmQymVpNfAKZW9Sukh8wTQhytjWD1KOJStpLtx0CcnAE5vUz8iPFcxop0lfd1ozGOEi
 Xbhwov7woUiTu924Us9XtPXVuaqG+ikjKlutNrL+kWex+F/L6SWuf1oM1S9l+n5ZzpE9 jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpnrpk38c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 18:12:19 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JIBK6N015267;
        Wed, 19 Jan 2022 18:12:19 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpnrpk37t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 18:12:19 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JHw2PT003186;
        Wed, 19 Jan 2022 18:12:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknwa18m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 18:12:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JI2q8234865542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 18:02:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 777D8A4055;
        Wed, 19 Jan 2022 18:12:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67FFAA4040;
        Wed, 19 Jan 2022 18:12:11 +0000 (GMT)
Received: from [9.171.7.240] (unknown [9.171.7.240])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 18:12:11 +0000 (GMT)
Message-ID: <2fad3da6-987a-ae62-9da2-f9184b0c91cb@linux.ibm.com>
Date:   Wed, 19 Jan 2022 19:13:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 13/30] s390/pci: return status from zpci_refresh_trans
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
 <20220114203145.242984-14-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-14-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LlpcPzjjuk3j3kKXF3UCoFJKg_cOtgg5
X-Proofpoint-ORIG-GUID: SJXz8Y_OBW2pyziola2mJPUXEKVJ2GkO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_10,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> Current callers of zpci_refresh_trans don't need to interrogate the status
> returned from the underlying instructions.  However, a subsequent patch
> will add a KVM caller that needs this information.  Add a new argument to
> zpci_refresh_trans to pass the address of a status byte and update
> existing call sites to provide it.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


> ---
>   arch/s390/include/asm/pci_insn.h |  2 +-
>   arch/s390/pci/pci_dma.c          |  6 ++++--
>   arch/s390/pci/pci_insn.c         | 10 +++++-----
>   drivers/iommu/s390-iommu.c       |  4 +++-
>   4 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
> index 5331082fa516..32759c407b8f 100644
> --- a/arch/s390/include/asm/pci_insn.h
> +++ b/arch/s390/include/asm/pci_insn.h
> @@ -135,7 +135,7 @@ union zpci_sic_iib {
>   DECLARE_STATIC_KEY_FALSE(have_mio);
>   
>   u8 zpci_mod_fc(u64 req, struct zpci_fib *fib, u8 *status);
> -int zpci_refresh_trans(u64 fn, u64 addr, u64 range);
> +int zpci_refresh_trans(u64 fn, u64 addr, u64 range, u8 *status);
>   int __zpci_load(u64 *data, u64 req, u64 offset);
>   int zpci_load(u64 *data, const volatile void __iomem *addr, unsigned long len);
>   int __zpci_store(u64 data, u64 req, u64 offset);
> diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
> index a81de48d5ea7..b0a2380bcad8 100644
> --- a/arch/s390/pci/pci_dma.c
> +++ b/arch/s390/pci/pci_dma.c
> @@ -23,8 +23,9 @@ static u32 s390_iommu_aperture_factor = 1;
>   
>   static int zpci_refresh_global(struct zpci_dev *zdev)
>   {
> +	u8 status;
>   	return zpci_refresh_trans((u64) zdev->fh << 32, zdev->start_dma,
> -				  zdev->iommu_pages * PAGE_SIZE);
> +				  zdev->iommu_pages * PAGE_SIZE, &status);
>   }
>   
>   unsigned long *dma_alloc_cpu_table(void)
> @@ -183,6 +184,7 @@ static int __dma_purge_tlb(struct zpci_dev *zdev, dma_addr_t dma_addr,
>   			   size_t size, int flags)
>   {
>   	unsigned long irqflags;
> +	u8 status;
>   	int ret;
>   
>   	/*
> @@ -201,7 +203,7 @@ static int __dma_purge_tlb(struct zpci_dev *zdev, dma_addr_t dma_addr,
>   	}
>   
>   	ret = zpci_refresh_trans((u64) zdev->fh << 32, dma_addr,
> -				 PAGE_ALIGN(size));
> +				 PAGE_ALIGN(size), &status);
>   	if (ret == -ENOMEM && !s390_iommu_strict) {
>   		/* enable the hypervisor to free some resources */
>   		if (zpci_refresh_global(zdev))
> diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
> index 0509554301c7..ca6399d52767 100644
> --- a/arch/s390/pci/pci_insn.c
> +++ b/arch/s390/pci/pci_insn.c
> @@ -77,20 +77,20 @@ static inline u8 __rpcit(u64 fn, u64 addr, u64 range, u8 *status)
>   	return cc;
>   }
>   
> -int zpci_refresh_trans(u64 fn, u64 addr, u64 range)
> +int zpci_refresh_trans(u64 fn, u64 addr, u64 range, u8 *status)
>   {
> -	u8 cc, status;
> +	u8 cc;
>   
>   	do {
> -		cc = __rpcit(fn, addr, range, &status);
> +		cc = __rpcit(fn, addr, range, status);
>   		if (cc == 2)
>   			udelay(ZPCI_INSN_BUSY_DELAY);
>   	} while (cc == 2);
>   
>   	if (cc)
> -		zpci_err_insn(cc, status, addr, range);
> +		zpci_err_insn(cc, *status, addr, range);
>   
> -	if (cc == 1 && (status == 4 || status == 16))
> +	if (cc == 1 && (*status == 4 || *status == 16))
>   		return -ENOMEM;
>   
>   	return (cc) ? -EIO : 0;
> diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
> index 50860ebdd087..845bb99c183e 100644
> --- a/drivers/iommu/s390-iommu.c
> +++ b/drivers/iommu/s390-iommu.c
> @@ -214,6 +214,7 @@ static int s390_iommu_update_trans(struct s390_domain *s390_domain,
>   	unsigned long irq_flags, nr_pages, i;
>   	unsigned long *entry;
>   	int rc = 0;
> +	u8 status;
>   
>   	if (dma_addr < s390_domain->domain.geometry.aperture_start ||
>   	    dma_addr + size > s390_domain->domain.geometry.aperture_end)
> @@ -238,7 +239,8 @@ static int s390_iommu_update_trans(struct s390_domain *s390_domain,
>   	spin_lock(&s390_domain->list_lock);
>   	list_for_each_entry(domain_device, &s390_domain->devices, list) {
>   		rc = zpci_refresh_trans((u64) domain_device->zdev->fh << 32,
> -					start_dma_addr, nr_pages * PAGE_SIZE);
> +					start_dma_addr, nr_pages * PAGE_SIZE,
> +					&status);
>   		if (rc)
>   			break;
>   	}
> 

-- 
Pierre Morel
IBM Lab Boeblingen
