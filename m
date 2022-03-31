Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4414EDA88
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 15:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiCaNa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 09:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbiCaNaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 09:30:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79634BBB7;
        Thu, 31 Mar 2022 06:29:08 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VC9Msk019624;
        Thu, 31 Mar 2022 13:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=D/cz0dZelzolEMieLpLdwIQj12dJBo8pf0yU32YnT94=;
 b=DdCLUeaGKeqxaL4nWScfoacmKsyEthpEQwJcTjJ/gqNXK3NTqyKKehew4W7VXPqx+3NB
 Hov8h34CL8KPgTs4Bn2LF5fYwVbM3STqPCHBVVFIPJeK4pzhlVeJWMrYCTyIUGQUELDd
 sJCGpcoEtLUXIKvixTzIVqfeUj1CMMJVoXd4Bx713sYgnpoBy2PdHuCHpIQUNBGjHF2j
 vuKM/ZeGtcm+4KCul2Ka9R2Kte81ax7b8heSmNa3G4lBcuS2PiILseqWdeInCkxA8UX6
 Mg7GW9XBunQz0uUTCb7141lRv9TtT3nzMtLxI6DaEVWIJpY/3lKv03bERAjGVyxHdVTY LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5972nnvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 13:29:07 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VDMZED018074;
        Thu, 31 Mar 2022 13:29:07 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5972nnus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 13:29:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VDHUwe017141;
        Thu, 31 Mar 2022 13:29:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3f3rs3nv3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 13:29:05 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VDT20s10813822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 13:29:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2606D11C058;
        Thu, 31 Mar 2022 13:29:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A195111C04C;
        Thu, 31 Mar 2022 13:29:01 +0000 (GMT)
Received: from [9.145.159.108] (unknown [9.145.159.108])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 13:29:01 +0000 (GMT)
Message-ID: <a927609a-d19a-7ac8-95bd-764e8d52ef34@linux.ibm.com>
Date:   Thu, 31 Mar 2022 15:29:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v9 10/18] KVM: s390: pv: add mmu_notifier
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
 <20220330122605.247613-11-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220330122605.247613-11-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ilE7Me97X4zrsw58cHoxwHwgFYcZCyQ9
X-Proofpoint-GUID: A8b2e3zOFbHtocakk7k0sQ_EeOUsOfhf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/22 14:25, Claudio Imbrenda wrote:
> Add an mmu_notifier for protected VMs. The callback function is
> triggered when the mm is torn down, and will attempt to convert all
> protected vCPUs to non-protected. This allows the mm teardown to use
> the destroy page UVC instead of export.
> 
> Also make KVM select CONFIG_MMU_NOTIFIER, needed to use mmu_notifiers.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/include/asm/kvm_host.h |  2 ++
>   arch/s390/kvm/Kconfig            |  1 +
>   arch/s390/kvm/kvm-s390.c         |  5 ++++-
>   arch/s390/kvm/pv.c               | 26 ++++++++++++++++++++++++++
>   4 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a22c9266ea05..1bccb8561ba9 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -19,6 +19,7 @@
>   #include <linux/kvm.h>
>   #include <linux/seqlock.h>
>   #include <linux/module.h>
> +#include <linux/mmu_notifier.h>
>   #include <asm/debug.h>
>   #include <asm/cpu.h>
>   #include <asm/fpu/api.h>
> @@ -921,6 +922,7 @@ struct kvm_s390_pv {
>   	u64 guest_len;
>   	unsigned long stor_base;
>   	void *stor_var;
> +	struct mmu_notifier mmu_notifier;
>   };
>   
>   struct kvm_arch{
> diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
> index 2e84d3922f7c..33f4ff909476 100644
> --- a/arch/s390/kvm/Kconfig
> +++ b/arch/s390/kvm/Kconfig
> @@ -34,6 +34,7 @@ config KVM
>   	select SRCU
>   	select KVM_VFIO
>   	select INTERVAL_TREE
> +	select MMU_NOTIFIER
>   	help
>   	  Support hosting paravirtualized guest machines using the SIE
>   	  virtualization capability on the mainframe. This should work
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 21fcca09e9bf..446f89db93a1 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -32,6 +32,7 @@
>   #include <linux/sched/signal.h>
>   #include <linux/string.h>
>   #include <linux/pgtable.h>
> +#include <linux/mmu_notifier.h>
>   
>   #include <asm/asm-offsets.h>
>   #include <asm/lowcore.h>
> @@ -2833,8 +2834,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	 * can mess with the pv state. To avoid lockdep_assert_held from
>   	 * complaining we do not use kvm_s390_pv_is_protected.
>   	 */
> -	if (kvm_s390_pv_get_handle(kvm))
> +	if (kvm_s390_pv_get_handle(kvm)) {
>   		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
> +		mmu_notifier_unregister(&kvm->arch.pv.mmu_notifier, kvm->mm);
> +	}
>   	debug_unregister(kvm->arch.dbf);
>   	free_page((unsigned long)kvm->arch.sie_page2);
>   	if (!kvm_is_ucontrol(kvm))
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 76ef33a277d3..788b96b36931 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -14,6 +14,7 @@
>   #include <asm/mman.h>
>   #include <linux/pagewalk.h>
>   #include <linux/sched/mm.h>
> +#include <linux/mmu_notifier.h>
>   #include "kvm-s390.h"
>   
>   static void kvm_s390_clear_pv_state(struct kvm *kvm)
> @@ -192,6 +193,26 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	return -EIO;
>   }
>   
> +static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
> +					     struct mm_struct *mm)
> +{
> +	struct kvm *kvm = container_of(subscription, struct kvm, arch.pv.mmu_notifier);
> +	u16 dummy;
> +
> +	/*
> +	 * No locking is needed since this is the last thread of the last user of this
> +	 * struct mm.
> +	 * When the struct kvm gets deinitialized, this notifier is also
> +	 * unregistered. This means that if this notifier runs, then the
> +	 * struct kvm is still valid.
> +	 */
> +	kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
> +}
> +
> +static const struct mmu_notifier_ops kvm_s390_pv_mmu_notifier_ops = {
> +	.release = kvm_s390_pv_mmu_notifier_release,
> +};
> +
>   int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   {
>   	struct uv_cb_cgc uvcb = {
> @@ -233,6 +254,11 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   		return -EIO;
>   	}
>   	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
> +	/* Add the notifier only once. No races because we hold kvm->lock */
> +	if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
> +		kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
> +		mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
> +	}
>   	return 0;
>   }
>   

