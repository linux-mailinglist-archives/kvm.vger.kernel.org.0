Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7964B50D8
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 13:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351111AbiBNM5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 07:57:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236723AbiBNM5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 07:57:43 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDF94B873;
        Mon, 14 Feb 2022 04:57:35 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EBwJbv012473;
        Mon, 14 Feb 2022 12:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=id2abh3WmQzXvMFNXByz0iFAdS1n1wujjaD/McLnorA=;
 b=Bl8JTG7aehpY1fmpY2NSpyDugy4MeJevlOUPVfz6cc6UQ/r7p5rFvmnB2GhPrPDZUZcm
 0spZtl5N+FNBO5hKwV1m+zCNTU5j8i38ZJvFOq2FCeFb92lV4DjLliFiGuMopsbJT+/J
 tpElngGtExQUE4yPxVTVjFaU5QjQtAAWBydRpXzJAwcKOhq9/wF01qEGTL7aRLCj72Gy
 UTB+f76hblHedddp3kCL7ACtfshk2huv5hWBFaX6NCj9pkYXMDVhQSxgoaw59D0pDBF+
 aOwu6r6UjHCtDJnSt0td9BGSiNwyluyMB8LeKNae2AXpz2oqOsclZo5/EQTWCDud8L+y mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7c4dwpnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 12:57:34 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21ECT2aO035399;
        Mon, 14 Feb 2022 12:57:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7c4dwpnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 12:57:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21ECu737024641;
        Mon, 14 Feb 2022 12:57:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3e64h9nd45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 12:57:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21ECvQIB40567072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 12:57:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5BCAA4054;
        Mon, 14 Feb 2022 12:57:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07499A405C;
        Mon, 14 Feb 2022 12:57:25 +0000 (GMT)
Received: from [9.171.42.254] (unknown [9.171.42.254])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 12:57:24 +0000 (GMT)
Message-ID: <7ecb4a93-5a41-a9e2-0a01-9eccabfa85ad@linux.ibm.com>
Date:   Mon, 14 Feb 2022 13:59:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v3 17/30] KVM: s390: pci: enable host forwarding of
 Adapter Event Notifications
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
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-18-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220204211536.321475-18-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uB7gIWlhauDnt5kyHZjhgV0hYTjlvEx0
X-Proofpoint-ORIG-GUID: Vj0sal7BBnc96eMnWyH2mY3fkc5Wd6qn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_05,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/4/22 22:15, Matthew Rosato wrote:
> In cases where interrupts are not forwarded to the guest via firmware,
> KVM is responsible for ensuring delivery.  When an interrupt presents
> with the forwarding bit, we must process the forwarding tables until
> all interrupts are delivered.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  1 +
>   arch/s390/include/asm/tpi.h      | 13 ++++++
>   arch/s390/kvm/interrupt.c        | 77 +++++++++++++++++++++++++++++++-
>   arch/s390/kvm/kvm-s390.c         |  3 +-
>   arch/s390/kvm/pci.h              | 10 +++++
>   5 files changed, 102 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a22c9266ea05..b468d3a2215e 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -757,6 +757,7 @@ struct kvm_vm_stat {
>   	u64 inject_pfault_done;
>   	u64 inject_service_signal;
>   	u64 inject_virtio;
> +	u64 aen_forward;
>   };
>   
>   struct kvm_arch_memory_slot {
> diff --git a/arch/s390/include/asm/tpi.h b/arch/s390/include/asm/tpi.h
> index 1ac538b8cbf5..f76e5fdff23a 100644
> --- a/arch/s390/include/asm/tpi.h
> +++ b/arch/s390/include/asm/tpi.h
> @@ -19,6 +19,19 @@ struct tpi_info {
>   	u32 :12;
>   } __packed __aligned(4);
>   
> +/* I/O-Interruption Code as stored by TPI for an Adapter I/O */
> +struct tpi_adapter_info {
> +	u32 aism:8;
> +	u32 :22;
> +	u32 error:1;
> +	u32 forward:1;
> +	u32 reserved;
> +	u32 adapter_IO:1;
> +	u32 directed_irq:1;
> +	u32 isc:3;
> +	u32 :27;
> +} __packed __aligned(4);
> +
>   #endif /* __ASSEMBLY__ */
>   
>   #endif /* _ASM_S390_TPI_H */
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 5e638f7c86f8..74a549d3d1e4 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3271,11 +3271,86 @@ int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc)
>   }
>   EXPORT_SYMBOL_GPL(kvm_s390_gisc_unregister);
>   
> +static void aen_host_forward(unsigned long si)
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
> +		set_bit_inv(gaite->aisbo, (unsigned long *)gaite->aisb);
> +
> +	kvm = kvm_s390_pci_si_to_kvm(aift, si);
> +	if (kvm == 0)
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
> +
> +	spin_lock_irqsave(&aift->gait_lock, flags);
> +
> +	if (!aift->gait) {
> +		spin_unlock_irqrestore(&aift->gait_lock, flags);
> +		return;
> +	}
> +
> +	for (si = 0;;) {
> +		/* Scan adapter summary indicator bit vector */
> +		si = airq_iv_scan(aift->sbv, si, airq_iv_end(aift->sbv));
> +		if (si == -1UL) {
> +			if (first || found) {
> +				/* Reenable interrupts. */
> +				if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, isc,
> +						      &iib))
> +					break;

I thought we agreed that the test is not useful here.

> +				first = found = false;
> +			} else {
> +				/* Interrupts on and all bits processed */
> +				break;
> +			}
> +			found = false;
> +			si = 0;

and about a comment here.
"rescan after re-enabling interrupts"
would make things clear

> +			continue;
> +		}
> +		found = true;
> +		aen_host_forward(si);
> +	}
> +
> +	spin_unlock_irqrestore(&aift->gait_lock, flags);
> +}
> +
>   static void gib_alert_irq_handler(struct airq_struct *airq,
>   				  struct tpi_info *tpi_info)
>   {
> +	struct tpi_adapter_info *info = (struct tpi_adapter_info *)tpi_info;
> +
>   	inc_irq_stat(IRQIO_GAL);
> -	process_gib_alert_list();
> +
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV) &&
> +	    (info->forward || info->error)) {
> +		aen_process_gait(info->isc);
> +		if (info->aism != 0)
> +			process_gib_alert_list();
> +	} else
> +		process_gib_alert_list();

Here we need braces.

>   }
>   
>   static struct airq_struct gib_alert_irq = {
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index dd4f4bfb326b..24837d6050dc 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -65,7 +65,8 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>   	STATS_DESC_COUNTER(VM, inject_float_mchk),
>   	STATS_DESC_COUNTER(VM, inject_pfault_done),
>   	STATS_DESC_COUNTER(VM, inject_service_signal),
> -	STATS_DESC_COUNTER(VM, inject_virtio)
> +	STATS_DESC_COUNTER(VM, inject_virtio),
> +	STATS_DESC_COUNTER(VM, aen_forward)
>   };
>   
>   const struct kvm_stats_header kvm_vm_stats_header = {
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> index 53e9968707c8..4d3db58beb74 100644
> --- a/arch/s390/kvm/pci.h
> +++ b/arch/s390/kvm/pci.h
> @@ -12,6 +12,7 @@
>   
>   #include <linux/pci.h>
>   #include <linux/mutex.h>
> +#include <linux/kvm_host.h>
>   #include <asm/airq.h>
>   #include <asm/kvm_pci.h>
>   
> @@ -34,6 +35,15 @@ struct zpci_aift {
>   
>   extern struct zpci_aift *aift;
>   
> +static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
> +						 unsigned long si)
> +{
> +	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV) || aift->kzdev == 0 ||
> +	    aift->kzdev[si] == 0)
> +		return 0;
> +	return aift->kzdev[si]->kvm;
> +};
> +
>   int kvm_s390_pci_aen_init(u8 nisc);
>   void kvm_s390_pci_aen_exit(void);
>   
> 

-- 
Pierre Morel
IBM Lab Boeblingen
