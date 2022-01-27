Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CB949DE8C
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 10:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiA0Jz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 04:55:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34638 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232024AbiA0Jz5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 04:55:57 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20R9fFmi005515;
        Thu, 27 Jan 2022 09:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=v7vgdFMmlLjZ//7aqE8miSDxEZzVBEmKPW6Ytz7CoCA=;
 b=CkpaBU0nF1n6CcaTGsYEGLnPWEq2SaMOJKspqQWXrwpU9+j9pV1t4frd1lkaKKqUrPRf
 DDcHBN7E8KFKo+MEf6GjvKvLNFDOtdSm1ZcgvVddnjdU55hu+A+2tejiXXLVkO4rsjnM
 3LejFkC4i+1byf2/4XrnfNmHJPZGUJKzKTypAfrqkse1cLHEqG94Lj2J36xi6/2X45TC
 4TrPbI8gWBHcX3FM1ZtyZiEVUVgIPxs7kPkpIJET598tqRguBYhcgODrJtlDttzx9ivl
 QwzAM1Aeod6DftB8QU0smCfFfRrdIGqTl5WfhKB23SOCnkCuWG5KEoJEU6h1siKVIAx6 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dupt030cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 09:55:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20R9j2Wq017096;
        Thu, 27 Jan 2022 09:55:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dupt030ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 09:55:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20R9q24c019496;
        Thu, 27 Jan 2022 09:55:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3dr9j9nwnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 09:55:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20R9tlCX42008882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 09:55:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CDE1AE04D;
        Thu, 27 Jan 2022 09:55:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2497EAE055;
        Thu, 27 Jan 2022 09:55:46 +0000 (GMT)
Received: from [9.171.44.35] (unknown [9.171.44.35])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jan 2022 09:55:46 +0000 (GMT)
Message-ID: <88d68802-56d5-849c-ae91-57c795d37250@linux.ibm.com>
Date:   Thu, 27 Jan 2022 10:57:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 07/30] s390/pci: externalize the SIC operation controls
 and routine
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
 <20220114203145.242984-8-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-8-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZFedqtx1C1NkDizt388mrvEXgpMwDMsN
X-Proofpoint-ORIG-GUID: dqmFXFBGJwR-yL6zj2kWYrsVIvygMCIO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_02,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> A subsequent patch will be issuing SIC from KVM -- export the necessary
> routine and make the operation control definitions available from a header.
> Because the routine will now be exported, let's rename __zpci_set_irq_ctrl
> to zpci_set_irq_ctrl and get rid of the zero'd iib wrapper function of
> the same name.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


> ---
>   arch/s390/include/asm/pci_insn.h | 17 +++++++++--------
>   arch/s390/pci/pci_insn.c         |  3 ++-
>   arch/s390/pci/pci_irq.c          | 26 ++++++++++++--------------
>   3 files changed, 23 insertions(+), 23 deletions(-)
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
> index 4dd58b196cea..2a47b3936e44 100644
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
> index 0d0a02a9fbbf..2f675355fd0c 100644
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
> @@ -154,6 +147,7 @@ static struct irq_chip zpci_irq_chip = {
>   static void zpci_handle_cpu_local_irq(bool rescan)
>   {
>   	struct airq_iv *dibv = zpci_ibv[smp_processor_id()];
> +	union zpci_sic_iib iib = {{0}};



>   	unsigned long bit;
>   	int irqs_on = 0;
>   
> @@ -165,7 +159,7 @@ static void zpci_handle_cpu_local_irq(bool rescan)
>   				/* End of second scan with interrupts on. */
>   				break;
>   			/* First scan complete, reenable interrupts. */
> -			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC))
> +			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC, &iib))
>   				break;
>   			bit = 0;
>   			continue;
> @@ -193,6 +187,7 @@ static void zpci_handle_remote_irq(void *data)
>   static void zpci_handle_fallback_irq(void)
>   {
>   	struct cpu_irq_data *cpu_data;
> +	union zpci_sic_iib iib = {{0}};
>   	unsigned long cpu;
>   	int irqs_on = 0;
>   
> @@ -203,7 +198,7 @@ static void zpci_handle_fallback_irq(void)
>   				/* End of second scan with interrupts on. */
>   				break;
>   			/* First scan complete, reenable interrupts. */
> -			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
> +			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC, &iib))
>   				break;
>   			cpu = 0;
>   			continue;
> @@ -234,6 +229,7 @@ static void zpci_directed_irq_handler(struct airq_struct *airq,
>   static void zpci_floating_irq_handler(struct airq_struct *airq,
>   				      struct tpi_info *tpi_info)
>   {
> +	union zpci_sic_iib iib = {{0}};
>   	unsigned long si, ai;
>   	struct airq_iv *aibv;
>   	int irqs_on = 0;
> @@ -247,7 +243,7 @@ static void zpci_floating_irq_handler(struct airq_struct *airq,
>   				/* End of second scan with interrupts on. */
>   				break;
>   			/* First scan complete, reenable interrupts. */
> -			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
> +			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC, &iib))
>   				break;
>   			si = 0;
>   			continue;
> @@ -407,11 +403,12 @@ static struct airq_struct zpci_airq = {
>   static void __init cpu_enable_directed_irq(void *unused)
>   {
>   	union zpci_sic_iib iib = {{0}};
> +	union zpci_sic_iib ziib = {{0}};
>   
>   	iib.cdiib.dibv_addr = (u64) zpci_ibv[smp_processor_id()]->vector;
>   
> -	__zpci_set_irq_ctrl(SIC_IRQ_MODE_SET_CPU, 0, &iib);
> -	zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_SET_CPU, 0, &iib);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC, &ziib);
>   }
>   
>   static int __init zpci_directed_irq_init(void)
> @@ -426,7 +423,7 @@ static int __init zpci_directed_irq_init(void)
>   	iib.diib.isc = PCI_ISC;
>   	iib.diib.nr_cpus = num_possible_cpus();
>   	iib.diib.disb_addr = virt_to_phys(zpci_sbv->vector);
> -	__zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
>   
>   	zpci_ibv = kcalloc(num_possible_cpus(), sizeof(*zpci_ibv),
>   			   GFP_KERNEL);
> @@ -471,6 +468,7 @@ static int __init zpci_floating_irq_init(void)
>   
>   int __init zpci_irq_init(void)
>   {
> +	union zpci_sic_iib iib = {{0}};
>   	int rc;
>   
>   	irq_delivery = sclp.has_dirq ? DIRECTED : FLOATING;
> @@ -502,7 +500,7 @@ int __init zpci_irq_init(void)
>   	 * Enable floating IRQs (with suppression after one IRQ). When using
>   	 * directed IRQs this enables the fallback path.
>   	 */
> -	zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC, &iib);
>   
>   	return 0;
>   out_airq:
> 

-- 
Pierre Morel
IBM Lab Boeblingen
