Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C30149C719
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 11:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239623AbiAZKHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 05:07:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43058 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239608AbiAZKHi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 05:07:38 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20Q95x4g027210;
        Wed, 26 Jan 2022 10:07:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7xG75LcE9Ks0ZkNvS6nRW94Nc3ze5K3G57nE+5v9aUE=;
 b=JFEjRD0NA1vfo+/qklHX201l/kDwqrBM1Vg4et2BYg4Y4iFvqDzBrT9cjGMZQh5X2/Oi
 1BungELsHaXTfdK0JPKgIwhMciHCMoUa3o4cfPYgHPn1NqJ/q14ACA62GPIvcCUgT0Gg
 PCMNBnQ6K/8zaBDOLlI9WP7AqWOSq5Qnp/wMwKt475kqNt/Rn4hvEgHj8YIZvsZ7SfxV
 309eZKTLVeDLgvZP9N7TNIGKWaYnB3pvbZKeqQiptoVTOdQX/YWub9y30yn+Z5OjVoZQ
 r+dq69Bd7+vCWxM8uwYqp0pPPTP3nA4/SbwPGoeH22ymG6Tc98Iw5B/a52y16fVPnl3B yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtwa9y30w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 10:07:36 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20Q9wRkk000476;
        Wed, 26 Jan 2022 10:07:36 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtwa9y308-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 10:07:36 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20QA5qGx022795;
        Wed, 26 Jan 2022 10:07:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3dr9j9b7kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 10:07:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20QA7Tl147448342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 10:07:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6F12A4057;
        Wed, 26 Jan 2022 10:07:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E60EA4040;
        Wed, 26 Jan 2022 10:07:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.7.24])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 10:07:28 +0000 (GMT)
Date:   Wed, 26 Jan 2022 11:07:26 +0100
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
Subject: Re: [PATCH v2 07/30] s390/pci: externalize the SIC operation
 controls and routine
Message-ID: <20220126110726.5f7e82f6@p-imbrenda>
In-Reply-To: <20220114203145.242984-8-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
        <20220114203145.242984-8-mjrosato@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5TpX50WdhIJPiYeS_nXVcIWhlb80byH7
X-Proofpoint-ORIG-GUID: xTzByrmI5DgtODn8VVqMD8PZ_dKx5yY4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_02,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 adultscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201260059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 15:31:22 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> A subsequent patch will be issuing SIC from KVM -- export the necessary
> routine and make the operation control definitions available from a header.
> Because the routine will now be exported, let's rename __zpci_set_irq_ctrl
> to zpci_set_irq_ctrl and get rid of the zero'd iib wrapper function of
> the same name.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/pci_insn.h | 17 +++++++++--------
>  arch/s390/pci/pci_insn.c         |  3 ++-
>  arch/s390/pci/pci_irq.c          | 26 ++++++++++++--------------
>  3 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
> index 61cf9531f68f..5331082fa516 100644
> --- a/arch/s390/include/asm/pci_insn.h
> +++ b/arch/s390/include/asm/pci_insn.h
> @@ -98,6 +98,14 @@ struct zpci_fib {
>  	u32 gd;
>  } __packed __aligned(8);
>  
> +/* Set Interruption Controls Operation Controls  */
> +#define	SIC_IRQ_MODE_ALL		0
> +#define	SIC_IRQ_MODE_SINGLE		1
> +#define	SIC_IRQ_MODE_DIRECT		4
> +#define	SIC_IRQ_MODE_D_ALL		16
> +#define	SIC_IRQ_MODE_D_SINGLE		17
> +#define	SIC_IRQ_MODE_SET_CPU		18
> +
>  /* directed interruption information block */
>  struct zpci_diib {
>  	u32 : 1;
> @@ -134,13 +142,6 @@ int __zpci_store(u64 data, u64 req, u64 offset);
>  int zpci_store(const volatile void __iomem *addr, u64 data, unsigned long len);
>  int __zpci_store_block(const u64 *data, u64 req, u64 offset);
>  void zpci_barrier(void);
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
>  #endif
> diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
> index 4dd58b196cea..2a47b3936e44 100644
> --- a/arch/s390/pci/pci_insn.c
> +++ b/arch/s390/pci/pci_insn.c
> @@ -97,7 +97,7 @@ int zpci_refresh_trans(u64 fn, u64 addr, u64 range)
>  }
>  
>  /* Set Interruption Controls */
> -int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
> +int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
>  {
>  	if (!test_facility(72))
>  		return -EIO;
> @@ -108,6 +108,7 @@ int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(zpci_set_irq_ctrl);
>  
>  /* PCI Load */
>  static inline int ____pcilg(u64 *data, u64 req, u64 offset, u8 *status)
> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
> index 0d0a02a9fbbf..2f675355fd0c 100644
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
> @@ -15,13 +15,6 @@
>  
>  static enum {FLOATING, DIRECTED} irq_delivery;
>  
> -#define	SIC_IRQ_MODE_ALL		0
> -#define	SIC_IRQ_MODE_SINGLE		1
> -#define	SIC_IRQ_MODE_DIRECT		4
> -#define	SIC_IRQ_MODE_D_ALL		16
> -#define	SIC_IRQ_MODE_D_SINGLE		17
> -#define	SIC_IRQ_MODE_SET_CPU		18
> -
>  /*
>   * summary bit vector
>   * FLOATING - summary bit per function
> @@ -154,6 +147,7 @@ static struct irq_chip zpci_irq_chip = {
>  static void zpci_handle_cpu_local_irq(bool rescan)
>  {
>  	struct airq_iv *dibv = zpci_ibv[smp_processor_id()];
> +	union zpci_sic_iib iib = {{0}};
>  	unsigned long bit;
>  	int irqs_on = 0;
>  
> @@ -165,7 +159,7 @@ static void zpci_handle_cpu_local_irq(bool rescan)
>  				/* End of second scan with interrupts on. */
>  				break;
>  			/* First scan complete, reenable interrupts. */
> -			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC))
> +			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC, &iib))
>  				break;
>  			bit = 0;
>  			continue;
> @@ -193,6 +187,7 @@ static void zpci_handle_remote_irq(void *data)
>  static void zpci_handle_fallback_irq(void)
>  {
>  	struct cpu_irq_data *cpu_data;
> +	union zpci_sic_iib iib = {{0}};
>  	unsigned long cpu;
>  	int irqs_on = 0;
>  
> @@ -203,7 +198,7 @@ static void zpci_handle_fallback_irq(void)
>  				/* End of second scan with interrupts on. */
>  				break;
>  			/* First scan complete, reenable interrupts. */
> -			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
> +			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC, &iib))
>  				break;
>  			cpu = 0;
>  			continue;
> @@ -234,6 +229,7 @@ static void zpci_directed_irq_handler(struct airq_struct *airq,
>  static void zpci_floating_irq_handler(struct airq_struct *airq,
>  				      struct tpi_info *tpi_info)
>  {
> +	union zpci_sic_iib iib = {{0}};
>  	unsigned long si, ai;
>  	struct airq_iv *aibv;
>  	int irqs_on = 0;
> @@ -247,7 +243,7 @@ static void zpci_floating_irq_handler(struct airq_struct *airq,
>  				/* End of second scan with interrupts on. */
>  				break;
>  			/* First scan complete, reenable interrupts. */
> -			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC))
> +			if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC, &iib))
>  				break;
>  			si = 0;
>  			continue;
> @@ -407,11 +403,12 @@ static struct airq_struct zpci_airq = {
>  static void __init cpu_enable_directed_irq(void *unused)
>  {
>  	union zpci_sic_iib iib = {{0}};
> +	union zpci_sic_iib ziib = {{0}};
>  
>  	iib.cdiib.dibv_addr = (u64) zpci_ibv[smp_processor_id()]->vector;
>  
> -	__zpci_set_irq_ctrl(SIC_IRQ_MODE_SET_CPU, 0, &iib);
> -	zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_SET_CPU, 0, &iib);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_D_SINGLE, PCI_ISC, &ziib);
>  }
>  
>  static int __init zpci_directed_irq_init(void)
> @@ -426,7 +423,7 @@ static int __init zpci_directed_irq_init(void)
>  	iib.diib.isc = PCI_ISC;
>  	iib.diib.nr_cpus = num_possible_cpus();
>  	iib.diib.disb_addr = virt_to_phys(zpci_sbv->vector);
> -	__zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
>  
>  	zpci_ibv = kcalloc(num_possible_cpus(), sizeof(*zpci_ibv),
>  			   GFP_KERNEL);
> @@ -471,6 +468,7 @@ static int __init zpci_floating_irq_init(void)
>  
>  int __init zpci_irq_init(void)
>  {
> +	union zpci_sic_iib iib = {{0}};
>  	int rc;
>  
>  	irq_delivery = sclp.has_dirq ? DIRECTED : FLOATING;
> @@ -502,7 +500,7 @@ int __init zpci_irq_init(void)
>  	 * Enable floating IRQs (with suppression after one IRQ). When using
>  	 * directed IRQs this enables the fallback path.
>  	 */
> -	zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC);
> +	zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, PCI_ISC, &iib);
>  
>  	return 0;
>  out_airq:

