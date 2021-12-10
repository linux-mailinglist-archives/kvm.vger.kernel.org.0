Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C1046FE32
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239616AbhLJJ46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:56:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239636AbhLJJ45 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 04:56:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BA8SVcs021074;
        Fri, 10 Dec 2021 09:53:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zPssZ9GDkEOpP7MShCL6uuKgJfAH6lKe/BzSxKL6F7A=;
 b=S58JTKL6+mO7+bjMIu8QTnif4vlv3eAFQUe/pVlYRzCX7hOcsQc52K+S2j2V1LQ0IsKr
 Lv53IVTHXfBE7XP5lDv68+dv8eJuI9AtZcE2rl4VU7gXy0KXJxo0zOhP+vSyW62slXPV
 JY5Sud6p5z+B2/0fuS1FkPjPCbo/4fpF7O4mph4GM/u0+yLDC7TuOOJMqaeOQXscon4f
 cnAvc4mINXsTgPkMa+WFjBU+dhhTBondisRHiDQEhxbQo9NrX6X20gfkE3eIhV0X4g6e
 GjDgeKzQ38Utzqy3ltoHr7Aw5dRM2X26WOlrMfu8Nd3mRSpBGPGJYPmJjCqcJzD9kin3 uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cv3dt9g89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 09:53:22 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BA9HdIG004189;
        Fri, 10 Dec 2021 09:53:21 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cv3dt9g7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 09:53:21 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BA9r8ra003348;
        Fri, 10 Dec 2021 09:53:19 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3cqyya7dj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 09:53:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BA9rFHk28442972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 09:53:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA887AE057;
        Fri, 10 Dec 2021 09:53:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFEA9AE053;
        Fri, 10 Dec 2021 09:53:13 +0000 (GMT)
Received: from [9.171.35.34] (unknown [9.171.35.34])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Dec 2021 09:53:13 +0000 (GMT)
Message-ID: <1816b176-0866-5f68-d3ea-813fab13d3e3@linux.ibm.com>
Date:   Fri, 10 Dec 2021 10:54:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 14/32] KVM: s390: pci: do initial setup for AEN
 interpretation
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
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-15-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207205743.150299-15-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aC9v4s4c0ZWlvike3bRXz0J2d0c2i7S5
X-Proofpoint-GUID: WUUDp6lgxqP66heNEL6cbcQvSRaQsMQa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 impostorscore=0 spamscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112100051
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 21:57, Matthew Rosato wrote:
> Initial setup for Adapter Event Notification Interpretation for zPCI
> passthrough devices.  Specifically, allocate a structure for forwarding of
> adapter events and pass the address of this structure to firmware.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/pci_insn.h |  12 ++++
>   arch/s390/kvm/interrupt.c        |  17 +++++
>   arch/s390/kvm/kvm-s390.c         |   3 +
>   arch/s390/kvm/pci.c              | 113 +++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h              |  42 ++++++++++++
>   5 files changed, 187 insertions(+)
>   create mode 100644 arch/s390/kvm/pci.h
> 
> diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
> index 5331082fa516..e5f57cfe1d45 100644
> --- a/arch/s390/include/asm/pci_insn.h
> +++ b/arch/s390/include/asm/pci_insn.h
> @@ -101,6 +101,7 @@ struct zpci_fib {
>   /* Set Interruption Controls Operation Controls  */
>   #define	SIC_IRQ_MODE_ALL		0
>   #define	SIC_IRQ_MODE_SINGLE		1
> +#define	SIC_SET_AENI_CONTROLS		2
>   #define	SIC_IRQ_MODE_DIRECT		4
>   #define	SIC_IRQ_MODE_D_ALL		16
>   #define	SIC_IRQ_MODE_D_SINGLE		17
> @@ -127,9 +128,20 @@ struct zpci_cdiib {
>   	u64 : 64;
>   } __packed __aligned(8);
>   
> +/* adapter interruption parameters block */
> +struct zpci_aipb {
> +	u64 faisb;
> +	u64 gait;
> +	u16 : 13;
> +	u16 afi : 3;
> +	u32 : 32;
> +	u16 faal;
> +} __packed __aligned(8);
> +
>   union zpci_sic_iib {
>   	struct zpci_diib diib;
>   	struct zpci_cdiib cdiib;
> +	struct zpci_aipb aipb;
>   };
>   
>   DECLARE_STATIC_KEY_FALSE(have_mio);
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index f9b872e358c6..4efe0e95a40f 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -32,6 +32,7 @@
>   #include "kvm-s390.h"
>   #include "gaccess.h"
>   #include "trace-s390.h"
> +#include "pci.h"
>   
>   #define PFAULT_INIT 0x0600
>   #define PFAULT_DONE 0x0680
> @@ -3276,8 +3277,16 @@ static struct airq_struct gib_alert_irq = {
>   
>   void kvm_s390_gib_destroy(void)
>   {
> +	struct zpci_aift *aift;
> +
>   	if (!gib)
>   		return;
> +	aift = kvm_s390_pci_get_aift();
> +	if (aift) {
> +		mutex_lock(&aift->lock);
> +		kvm_s390_pci_aen_exit();

Shouldn't we check for CONFIG_PCI and sclp.gas_aeni here as in gib_init ?

> +		mutex_unlock(&aift->lock);
> +	}
>   	chsc_sgib(0);
>   	unregister_adapter_interrupt(&gib_alert_irq);
>   	free_page((unsigned long)gib);
> @@ -3315,6 +3324,14 @@ int kvm_s390_gib_init(u8 nisc)
>   		goto out_unreg_gal;
>   	}
>   
> +	if (IS_ENABLED(CONFIG_PCI) && sclp.has_aeni) {
> +		if (kvm_s390_pci_aen_init(nisc)) {
> +			pr_err("Initializing AEN for PCI failed\n");
> +			rc = -EIO;
> +			goto out_unreg_gal;
> +		}
> +	}
> +
>   	KVM_EVENT(3, "gib 0x%pK (nisc=%d) initialized", gib, gib->nisc);
>   	goto out;
>   
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 14a18ba5ff2c..9cd3c8eb59e8 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -48,6 +48,7 @@
>   #include <asm/fpu/api.h>
>   #include "kvm-s390.h"
>   #include "gaccess.h"
> +#include "pci.h"
>   
>   #define CREATE_TRACE_POINTS
>   #include "trace.h"
> @@ -503,6 +504,8 @@ int kvm_arch_init(void *opaque)
>   		goto out;
>   	}
>   
> +	kvm_s390_pci_init();
> +
>   	rc = kvm_s390_gib_init(GAL_ISC);
>   	if (rc)
>   		goto out;
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index ecfc458a5b39..f0e5386ff943 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -10,6 +10,113 @@
>   #include <linux/kvm_host.h>
>   #include <linux/pci.h>
>   #include <asm/kvm_pci.h>
> +#include "pci.h"
> +
> +static struct zpci_aift aift;
> +
> +static inline int __set_irq_noiib(u16 ctl, u8 isc)
> +{
> +	union zpci_sic_iib iib = {{0}};
> +
> +	return zpci_set_irq_ctrl(ctl, isc, &iib);
> +}
> +
> +struct zpci_aift *kvm_s390_pci_get_aift(void)
> +{
> +	return &aift;
> +}
> +
> +/* Caller must hold the aift lock before calling this function */
> +void kvm_s390_pci_aen_exit(void)
> +{
> +	struct zpci_gaite *gait;
> +	unsigned long flags;
> +	struct airq_iv *sbv;
> +	struct kvm_zdev **gait_kzdev;
> +	int size;
> +
> +	/* Clear the GAIT and forwarding summary vector */
> +	__set_irq_noiib(SIC_SET_AENI_CONTROLS, 0);

Why don't we use the PCI ISC here?

...snip...

-- 
Pierre Morel
IBM Lab Boeblingen
