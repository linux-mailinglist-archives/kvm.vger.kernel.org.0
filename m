Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A00046D41E
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 14:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhLHNNQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 08:13:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230458AbhLHNNQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 08:13:16 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8CekEe008473;
        Wed, 8 Dec 2021 13:09:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JR+EdxlFVzSO4NftAVNX9Wg0id1e0eAgKaUYFzvIwJ0=;
 b=Sy6BXCU/Z/N19+IX+ihfMemQEK7cc58npondakc3/MwdbHQisbvc4BCtK1JaGIULDHLB
 X2GaIHXrIThVdW8Wpc8tSpzWhvrn5IsGyHZVNnXULDL2sqelj01I57/7p74p8wTaqR5D
 SglOF8mU7oA7+OvKPIzeOtzFwIVDWKxHisWIKqZsrBx4gUl2wwyYWa5bKLIOeUJHbc/B
 YWjOlsKL8fGYw3/JoXSJde/Wui0VnRW8FtWDl/j0DJvCf2KqjapMq8BiI0V59miY5Zvn
 /W0tLkbpm0xOD10a0iQjqb0UmQsLmtoQl2WMpd1bB43LOyhFjCyh0HCyw8DvEZpjem0c Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctuq1a8rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 13:09:43 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8D09Hl014923;
        Wed, 8 Dec 2021 13:09:43 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctuq1a8qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 13:09:43 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8D8tp7017114;
        Wed, 8 Dec 2021 13:09:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3cqyy9pe9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 13:09:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8D9coa32309738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 13:09:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0375DA405D;
        Wed,  8 Dec 2021 13:09:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5591A4065;
        Wed,  8 Dec 2021 13:09:36 +0000 (GMT)
Received: from [9.171.54.177] (unknown [9.171.54.177])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 13:09:36 +0000 (GMT)
Message-ID: <bc3b60f7-833d-6d50-dcd0-b102a190c69d@linux.ibm.com>
Date:   Wed, 8 Dec 2021 14:09:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 07/32] s390/pci: externalize the SIC operation controls
 and routine
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
 <20211207205743.150299-8-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211207205743.150299-8-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Reuq7_096GOUWmvzHyHJIg7LKIz2jz5n
X-Proofpoint-ORIG-GUID: pLRZ7FOSf_Q_N-HbfdSdCkbW_SLVepr_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112080083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> A subsequent patch will be issuing SIC from KVM -- export the necessary
> routine and make the operation control definitions available from a header.
> Because the routine will now be exported, let's swap the purpose of
> zpci_set_irq_ctrl and __zpci_set_irq_ctrl, leaving the latter as a static
> within pci_irq.c only for SIC calls that don't specify an iib.

Maybe it would be simpler to export the __ version instead of renaming everything.
Whatever Niklas prefers.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/pci_insn.h | 17 +++++++++--------
>   arch/s390/pci/pci_insn.c         |  3 ++-
>   arch/s390/pci/pci_irq.c          | 28 ++++++++++++++--------------
>   3 files changed, 25 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
> index 61cf9531f68f..5331082fa516 100644
> --- a/arch/s390/include/asm/pci_insn.h
> +++ b/arch/s390/include/asm/pci_insn.h
> @@ -98,6 +98,14 @@ struct zpci_fib {
>   	u32 gd;
>   } __packed __aligned(8);
>   
> +/* Set Interruption Controls Operation Controls  */
> +#define	SIC_IRQ_MODE_ALL		0
> +#define	SIC_IRQ_MODE_SINGLE		1
> +#define	SIC_IRQ_MODE_DIRECT		4
> +#define	SIC_IRQ_MODE_D_ALL		16
> +#define	SIC_IRQ_MODE_D_SINGLE		17
> +#define	SIC_IRQ_MODE_SET_CPU		18
> +
>   /* directed interruption information block */
>   struct zpci_diib {
>   	u32 : 1;
> @@ -134,13 +142,6 @@ int __zpci_store(u64 data, u64 req, u64 offset);
>   int zpci_store(const volatile void __iomem *addr, u64 data, unsigned long len);
>   int __zpci_store_block(const u64 *data, u64 req, u64 offset);
>   void zpci_barrier(void);
> -int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib);
> -
> -static inline int zpci_set_irq_ctrl(u16 ctl, u8 isc)
> -{
> -	union zpci_sic_iib iib = {{0}};
> -
> -	return __zpci_set_irq_ctrl(ctl, isc, &iib);
> -}
> +int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib);
>   
>   #endif
> diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
> index 28d863aaafea..d1a8bd43ce26 100644
> --- a/arch/s390/pci/pci_insn.c
> +++ b/arch/s390/pci/pci_insn.c
> @@ -97,7 +97,7 @@ int zpci_refresh_trans(u64 fn, u64 addr, u64 range)
>   }
>   
>   /* Set Interruption Controls */
> -int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
> +int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
>   {
>   	if (!test_facility(72))
>   		return -EIO;
> @@ -108,6 +108,7 @@ int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
>   
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(zpci_set_irq_ctrl);
>   
>   /* PCI Load */
>   static inline int ____pcilg(u64 *data, u64 req, u64 offset, u8 *status)
> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
> index dfd4f3276a6d..6b29e39496d1 100644
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
> @@ -15,13 +15,6 @@
>   
>   static enum {FLOATING, DIRECTED} irq_delivery;
>   
> -#define	SIC_IRQ_MODE_ALL		0
> -#define	SIC_IRQ_MODE_SINGLE		1
> -#define	SIC_IRQ_MODE_DIRECT		4
> -#define	SIC_IRQ_MODE_D_ALL		16
> -#define	SIC_IRQ_MODE_D_SINGLE		17
> -#define	SIC_IRQ_MODE_SET_CPU		18
> -
>   /*
>    * summary bit vector
>    * FLOATING - summary bit per function
> @@ -145,6 +138,13 @@ static int zpci_set_irq_affinity(struct irq_data *data, const struct cpumask *de
>   	return IRQ_SET_MASK_OK;
>   }
>   
> +static inline int __zpci_set_irq_ctrl(u16 ctl, u8 isc)
> +{
> +	union zpci_sic_iib iib = {{0}};
> +
> +	return zpci_set_irq_ctrl(ctl, isc, &iib);
> +}
> +
>   static struct irq_chip zpci_irq_chip = {
>   	.name = "PCI-MSI",
>   	.irq_unmask = pci_msi_unmask_irq,
> @@ -165,7 +165,7 @@ static void zpci_handle_cpu_local_irq(bool rescan)
>   				/* End of second scan with interrupts on. */
>   				break;
>   			/* First scan complete, reenable interrupts. */
> -			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC))
> +			if (__zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC))
>   				break;
>   			bit = 0;
>   			continue;
> @@ -203,7 +203,7 @@ static void zpci_handle_fallback_irq(void)
>   				/* End of second scan with interrupts on. */
>   				break;
>   			/* First scan complete, reenable interrupts. */
> -			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
> +			if (__zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
>   				break;
>   			cpu = 0;
>   			continue;
> @@ -247,7 +247,7 @@ static void zpci_floating_irq_handler(struct airq_struct *airq,
>   				/* End of second scan with interrupts on. */
>   				break;
>   			/* First scan complete, reenable interrupts. */
> -			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
> +			if (__zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
>   				break;
>   			si = 0;
>   			continue;
> @@ -412,8 +412,8 @@ static void __init cpu_enable_directed_irq(void *unused)
>   
>   	iib.cdiib.dibv_addr = (u64) zpci_ibv[smp_processor_id()]->vector;
>   
> -	__zpci_set_irq_ctrl(SIC_IRQ_MODE_SET_CPU, 0, &iib);
> -	zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_SET_CPU, 0, &iib);
> +	__zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC);
>   }
>   
>   static int __init zpci_directed_irq_init(void)
> @@ -428,7 +428,7 @@ static int __init zpci_directed_irq_init(void)
>   	iib.diib.isc = PCI_ISC;
>   	iib.diib.nr_cpus = num_possible_cpus();
>   	iib.diib.disb_addr = (u64) zpci_sbv->vector;
> -	__zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
>   
>   	zpci_ibv = kcalloc(num_possible_cpus(), sizeof(*zpci_ibv),
>   			   GFP_KERNEL);
> @@ -504,7 +504,7 @@ int __init zpci_irq_init(void)
>   	 * Enable floating IRQs (with suppression after one IRQ). When using
>   	 * directed IRQs this enables the fallback path.
>   	 */
> -	zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC);
> +	__zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC);
>   
>   	return 0;
>   out_airq:
> 
