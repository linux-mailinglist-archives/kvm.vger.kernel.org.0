Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5EA2FA217
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392151AbhARNtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 08:49:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392417AbhARNq2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 08:46:28 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10IDVjXH118987;
        Mon, 18 Jan 2021 08:45:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4Ldc+7OLBW8qG1T0v6PWkporL/9Y+EOj/D4yFjmRNlU=;
 b=jr2YeftQ70NKPopPlAS9pbL42PC5am36IWN/V8uu4hYpmaSVwImuhWqUWelalnfLnGPy
 Xc226YqrmMc4OOQ3fpzJmD9pxB27xKkS9Vl4vvNRt5zpBqbSlmt8qPMMF2W1V2vMYkZY
 vKsCgPBKVB9BPcQdPrRi+I1Duu2Zva4xO1kY5+GZhMIS2EkVO7+ZfXZWVecu0Tr2a1wK
 op6LzB2z7f8tuOfuJuXnKSlQ1nST1+pH/9Dlz7CiAi1y5e+Mvt57ZjXoMIjmA+0xviaX
 jmkV47cftE/xdROpjoZBrcXTL/Dup0Dsapn1jBAIr4jE8XuZMTUJ599wNvsELSE6E7G1 dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365at7s8n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 08:45:47 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10IDVnoc119305;
        Mon, 18 Jan 2021 08:45:46 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365at7s8m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 08:45:46 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10IDbSxR019309;
        Mon, 18 Jan 2021 13:45:44 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 36454vrtep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 13:45:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10IDjf2n28377588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 13:45:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 153EFAE057;
        Mon, 18 Jan 2021 13:45:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F7B1AE04D;
        Mon, 18 Jan 2021 13:45:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.77.2])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 Jan 2021 13:45:40 +0000 (GMT)
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
References: <20210118131739.7272-1-borntraeger@de.ibm.com>
 <20210118131739.7272-2-borntraeger@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: diag9c forwarding
Message-ID: <db1d2a6e-1947-321b-bdc2-019eee5780f4@linux.ibm.com>
Date:   Mon, 18 Jan 2021 14:45:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118131739.7272-2-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_11:2021-01-18,2021-01-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/21 2:17 PM, Christian Borntraeger wrote:
> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> When we receive intercept a DIAG_9C from the guest we verify
> that the target real CPU associated with the virtual CPU
> designated by the guest is running and if not we forward the
> DIAG_9C to the target real CPU.
> 
> To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.
> 
> The rate is calculated as a count per second defined as a
> new parameter of the s390 kvm module: diag9c_forwarding_hz .
> 
> The default value is to not forward diag9c.

Before Conny starts yelling I'll do it myself:
Documentation

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  1 +
>  arch/s390/include/asm/smp.h      |  1 +
>  arch/s390/kernel/smp.c           |  1 +
>  arch/s390/kvm/diag.c             | 31 ++++++++++++++++++++++++++++---
>  arch/s390/kvm/kvm-s390.c         |  6 ++++++
>  arch/s390/kvm/kvm-s390.h         |  8 ++++++++
>  6 files changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 74f9a036bab2..98ae55f79620 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -455,6 +455,7 @@ struct kvm_vcpu_stat {
>  	u64 diagnose_44;
>  	u64 diagnose_9c;
>  	u64 diagnose_9c_ignored;
> +	u64 diagnose_9c_forward;
>  	u64 diagnose_258;
>  	u64 diagnose_308;
>  	u64 diagnose_500;
> diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
> index 01e360004481..e317fd4866c1 100644
> --- a/arch/s390/include/asm/smp.h
> +++ b/arch/s390/include/asm/smp.h
> @@ -63,5 +63,6 @@ extern void __noreturn cpu_die(void);
>  extern void __cpu_die(unsigned int cpu);
>  extern int __cpu_disable(void);
>  extern void schedule_mcck_handler(void);
> +void notrace smp_yield_cpu(int cpu);
>  
>  #endif /* __ASM_SMP_H */
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index c5abbb94ac6e..32622e9c15f0 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -422,6 +422,7 @@ void notrace smp_yield_cpu(int cpu)
>  	asm volatile("diag %0,0,0x9c"
>  		     : : "d" (pcpu_devices[cpu].address));
>  }
> +EXPORT_SYMBOL(smp_yield_cpu);
>  
>  /*
>   * Send cpus emergency shutdown signal. This gives the cpus the
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 5b8ec1c447e1..fc1ec4aa81ed 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -150,6 +150,19 @@ static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static unsigned int forward_cnt;

This is not per CPU, so we could have one CPU making forwards impossible
for all others, right? Would this be a possible improvement or doesn't
that happen in real world workloads?

The code looks ok to me but smp is absolutely not my field of expertise.

> +static unsigned long cur_slice;
> +
> +static int diag9c_forwarding_overrun(void)
> +{
> +	/* Reset the count on a new slice */
> +	if (time_after(jiffies, cur_slice)) {
> +		cur_slice = jiffies;
> +		forward_cnt = diag9c_forwarding_hz / HZ;
> +	}
> +	return forward_cnt-- ? 1 : 0;
> +}
> +
>  static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu *tcpu;
> @@ -167,9 +180,21 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>  	if (!tcpu)
>  		goto no_yield;
>  
> -	/* target already running */
> -	if (READ_ONCE(tcpu->cpu) >= 0)
> -		goto no_yield;
> +	/* target VCPU already running */
> +	if (READ_ONCE(tcpu->cpu) >= 0) {
> +		if (!diag9c_forwarding_hz || diag9c_forwarding_overrun())
> +			goto no_yield;
> +
> +		/* target CPU already running */
> +		if (!vcpu_is_preempted(tcpu->cpu))
> +			goto no_yield;
> +		smp_yield_cpu(tcpu->cpu);

This is a pure cpu yield while before we yielded to the process of the
vcpu. Do we also want to prod the task of the VCPU we want to yield to
before waking up the host cpu? Or do we expect the VCPU task to be the
first thing that's picked up by the host cpu?


> +		VCPU_EVENT(vcpu, 5,
> +			   "diag time slice end directed to %d: yield forwarded",
> +			   tid);
> +		vcpu->stat.diagnose_9c_forward++;
> +		return 0;
> +	}
>  
>  	if (kvm_vcpu_yield_to(tcpu) <= 0)
>  		goto no_yield;
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 759bbc012b6c..9b98db81db31 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -158,6 +158,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	VCPU_STAT("instruction_diag_44", diagnose_44),
>  	VCPU_STAT("instruction_diag_9c", diagnose_9c),
>  	VCPU_STAT("diag_9c_ignored", diagnose_9c_ignored),
> +	VCPU_STAT("diag_9c_forward", diagnose_9c_forward),
>  	VCPU_STAT("instruction_diag_258", diagnose_258),
>  	VCPU_STAT("instruction_diag_308", diagnose_308),
>  	VCPU_STAT("instruction_diag_500", diagnose_500),
> @@ -191,6 +192,11 @@ static bool use_gisa  = true;
>  module_param(use_gisa, bool, 0644);
>  MODULE_PARM_DESC(use_gisa, "Use the GISA if the host supports it.");
>  
> +/* maximum diag9c forwarding per second */
> +unsigned int diag9c_forwarding_hz;
> +module_param(diag9c_forwarding_hz, uint, 0644);
> +MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second");
> +
>  /*
>   * For now we handle at most 16 double words as this is what the s390 base
>   * kernel handles and stores in the prefix page. If we ever need to go beyond
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 79dcd647b378..9fad25109b0d 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -471,4 +471,12 @@ void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
>   * @kvm: the KVM guest
>   */
>  void kvm_s390_vcpu_crypto_reset_all(struct kvm *kvm);
> +
> +/**
> + * diag9c_forwarding_hz
> + *
> + * Set the maximum number of diag9c forwarding per second
> + */
> +extern unsigned int diag9c_forwarding_hz;
> +
>  #endif
> 

