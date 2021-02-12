Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1EA31A08E
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 15:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhBLOVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 09:21:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231805AbhBLOVC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 09:21:02 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CE3dxG063449;
        Fri, 12 Feb 2021 09:20:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3tJyymR8z0aK6+sxHOtajKmGo1iKOgNjWeD+qGjR+Ew=;
 b=C7yNy2AAm6gOHvNwr97CPLslmxhs6jQj8La/o2pPVSpNR4EGCwlQpVDQ27T4qkVBOQce
 Me9yGceXnHPgaWRKMJ+RxFxRRm8tAU8e/yWlWqX2i4N6Ph7qW0dY1eeAG/e8+XN1SofU
 tDgLTCiGncEsr9xEeph5lu91B8EHkkWRSrHPUI5jPsQZWg/XcdkEJSL9nLauDOsh38gn
 fwX4mKnVSSZ5MrcBWMzcQZ3ntlZOLnEVR6HpqVYYh6hWYPe494OAOfhWrjkZkgBVmX9p
 eF7rjVQj8CiOvEIwG4odSLX0z5NMTVZLr7FfQifGwRK2bMJxwaIilOVWOofkJojYIY6x hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nu3x8p2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 09:20:20 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11CE3uAM068239;
        Fri, 12 Feb 2021 09:20:20 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nu3x8p1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 09:20:19 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CEHVgR010880;
        Fri, 12 Feb 2021 14:20:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wp10h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 14:20:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CEKExN33227064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 14:20:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78C4342045;
        Fri, 12 Feb 2021 14:20:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30AB242056;
        Fri, 12 Feb 2021 14:20:13 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 14:20:13 +0000 (GMT)
Subject: Re: [PATCH v2 1/1] s390:kvm: diag9c forwarding
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com
References: <1613119176-20864-1-git-send-email-pmorel@linux.ibm.com>
 <1613119176-20864-2-git-send-email-pmorel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <daea45df-8a44-f2c3-1892-58ff4f85f5be@linux.ibm.com>
Date:   Fri, 12 Feb 2021 15:20:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1613119176-20864-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_04:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/12/21 9:39 AM, Pierre Morel wrote:
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
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   Documentation/virt/kvm/s390-diag.rst | 33 ++++++++++++++++++++++++++++
>   arch/s390/include/asm/kvm_host.h     |  1 +
>   arch/s390/include/asm/smp.h          |  1 +
>   arch/s390/kernel/smp.c               |  1 +
>   arch/s390/kvm/diag.c                 | 31 +++++++++++++++++++++++---
>   arch/s390/kvm/kvm-s390.c             |  6 +++++
>   arch/s390/kvm/kvm-s390.h             |  8 +++++++
>   7 files changed, 78 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/s390-diag.rst b/Documentation/virt/kvm/s390-diag.rst
> index eaac4864d3d6..a6371bc4ea90 100644
> --- a/Documentation/virt/kvm/s390-diag.rst
> +++ b/Documentation/virt/kvm/s390-diag.rst
> @@ -84,3 +84,36 @@ If the function code specifies 0x501, breakpoint functions may be performed.
>   This function code is handled by userspace.
>   
>   This diagnose function code has no subfunctions and uses no parameters.
> +
> +
> +DIAGNOSE function code 'X'9C - Voluntary Time Slice Yield
> +---------------------------------------------------------
> +
> +General register 1 contains the target CPU address.
> +
> +In a guest of a hypervisor like LPAR, KVM or z/VM using shared host CPUs,
> +DIAGNOSE with function code 'X'9C may improve system performance by
> +yielding the host CPU on which the guest CPU is running to be assigned
> +to another guest CPU, preferably the logical CPU containing the specified
> +target CPU.
> +
> +
> +DIAG 'X'9C forwarding
> ++++++++++++++++++++++
> +
> +Under KVM, the guest operating system may send a DIAGNOSE code 'X'9C to
> +the host when it fails to acquire a spinlock for a virtual CPU
> +and detects that the host CPU on which the virtual guest CPU owner is
> +assigned to is not running to try to get this host CPU running and
> +consequently the guest virtual CPU running and freeing the lock.
> +
> +However, on the logical partition the real CPU on which the previously
> +targeted host CPU is assign may itself not be running.
> +By forwarding the DIAGNOSE code 'X'9C, initially sent by the guest,
> +from the host to LPAR hypervisor, this one will hopefully schedule
> +the host CPU which will let KVM run the target guest CPU.
> +
> +diag9c_forwarding_hz
> +    KVM kernel parameter allowing to specify the maximum number of DIAGNOSE
> +    'X'9C forwarding per second in the purpose of avoiding a DIAGNOSE 'X'9C
> +    forwarding storm.
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 527776a1f076..cb19508c22fb 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -456,6 +456,7 @@ struct kvm_vcpu_stat {
>   	u64 diagnose_44;
>   	u64 diagnose_9c;
>   	u64 diagnose_9c_ignored;
> +	u64 diagnose_9c_forward;
>   	u64 diagnose_258;
>   	u64 diagnose_308;
>   	u64 diagnose_500;
> diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
> index 01e360004481..e317fd4866c1 100644
> --- a/arch/s390/include/asm/smp.h
> +++ b/arch/s390/include/asm/smp.h
> @@ -63,5 +63,6 @@ extern void __noreturn cpu_die(void);
>   extern void __cpu_die(unsigned int cpu);
>   extern int __cpu_disable(void);
>   extern void schedule_mcck_handler(void);
> +void notrace smp_yield_cpu(int cpu);
>   
>   #endif /* __ASM_SMP_H */
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index 27c763014114..15e207a671fd 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -422,6 +422,7 @@ void notrace smp_yield_cpu(int cpu)
>   	asm volatile("diag %0,0,0x9c"
>   		     : : "d" (pcpu_devices[cpu].address));
>   }
> +EXPORT_SYMBOL(smp_yield_cpu);
>   
>   /*
>    * Send cpus emergency shutdown signal. This gives the cpus the
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 5b8ec1c447e1..34cf41fa6fa2 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -150,6 +150,19 @@ static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +static unsigned int forward_cnt;
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

/o\

seems a "<= 0 " has been forgotten here

I send the update asap.

regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
