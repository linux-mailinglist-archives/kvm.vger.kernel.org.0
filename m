Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F79C470CBD
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 22:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344517AbhLJVzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 16:55:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237557AbhLJVzY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 16:55:24 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAKVaU2031189;
        Fri, 10 Dec 2021 21:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=cRpYeaS9D+F+tkn8NSg5sgsX22lXzSr9MivzVPt1Vc8=;
 b=qUFs7P0/4Dyp3G6VKQZ+U7Jn3m7tYb170sVn6HcUkdHGtk3KDdxlQrjLRUqIn1ErREpw
 vKKhYfjp33EIaRn28LGTF+zLOfjLGgM3fwHAf/f1Z4vJA+20kbSQdzgoD4G2OZjYldOC
 EERrGmGDm0TKxRLTl2vxIQYj9Et/npadORWDOJNluIlH1NMEZI+KApmhHMyni8EBf1w7
 pWdswEYj+1aW/yiHifWNAXPLOx8L1Z2w4j0wt3qEXKPHgrWaFQY1Ftwzp7ns0A5qOKad
 3ARaPs+hL354t6ZDvHD9UOq4wHfl9VO/dFqq2Q3aWCZmhjlFxRBFokkBVmCra+/PmaHA Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cve0p9beb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 21:51:48 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BALV1Ke023728;
        Fri, 10 Dec 2021 21:51:47 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cve0p9bdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 21:51:47 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BALiO1w026584;
        Fri, 10 Dec 2021 21:51:47 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 3cqyyde850-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 21:51:46 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BALpja424379894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 21:51:45 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4B5CB206C;
        Fri, 10 Dec 2021 21:51:45 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F825B2064;
        Fri, 10 Dec 2021 21:51:40 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.80.105])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 10 Dec 2021 21:51:39 +0000 (GMT)
Message-ID: <0489ee94f1b7dd66ef146072b4c3be84c60c96ad.camel@linux.ibm.com>
Subject: Re: [PATCH 15/32] KVM: s390: pci: enable host forwarding of Adapter
 Event Notifications
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 10 Dec 2021 16:51:38 -0500
In-Reply-To: <20211207205743.150299-16-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-16-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cAXZvKXNoq4Bzl_2-J2AVDpTXw_f4Nxu
X-Proofpoint-GUID: HP0MKUDsDtuoe2_vuduqbPsdwDLB2Rx9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_08,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
> In cases where interrupts are not forwarded to the guest via
> firmware,
> KVM is responsible for ensuring delivery.  When an interrupt presents
> with the forwarding bit, we must process the forwarding tables until
> all interrupts are delivered.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Nits below regarding 0-vs-NULL, but otherwise:

Reviewed-by: Eric Farman <farman@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_host.h |  1 +
>  arch/s390/include/asm/tpi.h      | 14 ++++++
>  arch/s390/kvm/interrupt.c        | 76
> +++++++++++++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.c         |  3 +-
>  arch/s390/kvm/pci.h              |  9 ++++
>  5 files changed, 101 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h
> b/arch/s390/include/asm/kvm_host.h
> index a604d51acfc8..3f147b8d050b 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -757,6 +757,7 @@ struct kvm_vm_stat {
>  	u64 inject_pfault_done;
>  	u64 inject_service_signal;
>  	u64 inject_virtio;
> +	u64 aen_forward;
>  };
>  
>  struct kvm_arch_memory_slot {
> diff --git a/arch/s390/include/asm/tpi.h
> b/arch/s390/include/asm/tpi.h
> index 1ac538b8cbf5..47a531fdb15b 100644
> --- a/arch/s390/include/asm/tpi.h
> +++ b/arch/s390/include/asm/tpi.h
> @@ -19,6 +19,20 @@ struct tpi_info {
>  	u32 :12;
>  } __packed __aligned(4);
>  
> +/* I/O-Interruption Code as stored by TPI for an Adapter I/O */
> +struct tpi_adapter_info {
> +	u32 :1;
> +	u32 pci:1;
> +	u32 :28;
> +	u32 error:1;
> +	u32 forward:1;
> +	u32 reserved;
> +	u32 adapter_IO:1;
> +	u32 directed_irq:1;
> +	u32 isc:3;
> +	u32 :27;
> +} __packed __aligned(4);
> +
>  #endif /* __ASSEMBLY__ */
>  
>  #endif /* _ASM_S390_TPI_H */
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 4efe0e95a40f..c6ff871a6ed1 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3263,11 +3263,85 @@ int kvm_s390_gisc_unregister(struct kvm *kvm,
> u32 gisc)
>  }
>  EXPORT_SYMBOL_GPL(kvm_s390_gisc_unregister);
>  
> +static void aen_host_forward(struct zpci_aift *aift, unsigned long
> si)
> +{
> +	struct kvm_s390_gisa_interrupt *gi;
> +	struct zpci_gaite *gaite;
> +	struct kvm *kvm;
> +
> +	gaite = (struct zpci_gaite *)aift->gait +
> +		(si * sizeof(struct zpci_gaite));
> +	if (gaite->count == 0)
> +		return;
> +	if (gaite->aisb != 0)
> +		set_bit_inv(gaite->aisbo, (unsigned long *)gaite-
> >aisb);
> +
> +	kvm = kvm_s390_pci_si_to_kvm(aift, si);
> +	if (kvm == 0)

if (!kvm)

> +		return;
> +	gi = &kvm->arch.gisa_int;
> +
> +	if (!(gi->origin->g1.simm & AIS_MODE_MASK(gaite->gisc)) ||
> +	    !(gi->origin->g1.nimm & AIS_MODE_MASK(gaite->gisc))) {
> +		gisa_set_ipm_gisc(gi->origin, gaite->gisc);
> +		if (hrtimer_active(&gi->timer))
> +			hrtimer_cancel(&gi->timer);
> +		hrtimer_start(&gi->timer, 0, HRTIMER_MODE_REL);
> +		kvm->stat.aen_forward++;
> +	}
> +}
> +
> +static void aen_process_gait(u8 isc)
> +{
> +	bool found = false, first = true;
> +	union zpci_sic_iib iib = {{0}};
> +	unsigned long si, flags;
> +	struct zpci_aift *aift;
> +
> +	aift = kvm_s390_pci_get_aift();
> +	spin_lock_irqsave(&aift->gait_lock, flags);
> +
> +	if (!aift->gait) {
> +		spin_unlock_irqrestore(&aift->gait_lock, flags);
> +		return;
> +	}
> +
> +	for (si = 0;;) {
> +		/* Scan adapter summary indicator bit vector */
> +		si = airq_iv_scan(aift->sbv, si, airq_iv_end(aift-
> >sbv));
> +		if (si == -1UL) {
> +			if (first || found) {
> +				/* Reenable interrupts. */
> +				if
> (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, isc,
> +						      &iib))
> +					break;
> +				first = found = false;
> +			} else {
> +				/* Interrupts on and all bits processed
> */
> +				break;
> +			}
> +			found = false;
> +			si = 0;
> +			continue;
> +		}
> +		found = true;
> +		aen_host_forward(aift, si);
> +	}
> +
> +	spin_unlock_irqrestore(&aift->gait_lock, flags);
> +}
> +
>  static void gib_alert_irq_handler(struct airq_struct *airq,
>  				  struct tpi_info *tpi_info)
>  {
> +	struct tpi_adapter_info *info = (struct tpi_adapter_info
> *)tpi_info;
> +
>  	inc_irq_stat(IRQIO_GAL);
> -	process_gib_alert_list();
> +
> +	if (info->forward || info->error)
> +		aen_process_gait(info->isc);
> +	else
> +		process_gib_alert_list();
>  }
>  
>  static struct airq_struct gib_alert_irq = {
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 9cd3c8eb59e8..c8fe9b7c2395 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -65,7 +65,8 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] =
> {
>  	STATS_DESC_COUNTER(VM, inject_float_mchk),
>  	STATS_DESC_COUNTER(VM, inject_pfault_done),
>  	STATS_DESC_COUNTER(VM, inject_service_signal),
> -	STATS_DESC_COUNTER(VM, inject_virtio)
> +	STATS_DESC_COUNTER(VM, inject_virtio),
> +	STATS_DESC_COUNTER(VM, aen_forward)
>  };
>  
>  const struct kvm_stats_header kvm_vm_stats_header = {
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> index 74b06d39be3b..776b2745c675 100644
> --- a/arch/s390/kvm/pci.h
> +++ b/arch/s390/kvm/pci.h
> @@ -12,6 +12,7 @@
>  
>  #include <linux/pci.h>
>  #include <linux/mutex.h>
> +#include <linux/kvm_host.h>
>  #include <asm/airq.h>
>  #include <asm/kvm_pci.h>
>  
> @@ -32,6 +33,14 @@ struct zpci_aift {
>  	struct mutex lock; /* Protects the other structures in aift */
>  };
>  
> +static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift
> *aift,
> +						 unsigned long si)
> +{
> +	if (aift->kzdev == 0 || aift->kzdev[si] == 0)
> +		return 0;

Check/return NULL

> +	return aift->kzdev[si]->kvm;
> +};
> +
>  struct zpci_aift *kvm_s390_pci_get_aift(void);
>  
>  int kvm_s390_pci_aen_init(u8 nisc);

