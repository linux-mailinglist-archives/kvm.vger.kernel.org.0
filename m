Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303BA36660C
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 09:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhDUHET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 03:04:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236301AbhDUHEJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 03:04:09 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L6YOrQ044023;
        Wed, 21 Apr 2021 03:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tLg5DX76NZwj7FRceDWBV4qvPy/Jbr1sqJp2kOTA/JY=;
 b=hUaKfxzZma5B5OVj1/ezISza2bhG2HpYt9kS6Fd1xSfbpDTTqMngielE5gKcm5zxGv9H
 /lrSuLbeNIVCEIKI1+f/MkmUcnfIPfwplH3W/Kdww+68wujGr3XyoBIE+mIV8GEzGkkk
 +FPGPF1MHRUORtVbKMqfqO/YeWlM6HLeLPOftXyNov1a2aZryFTiKxOS+ECVG+Hy12Z/
 3DsaY/zoFdTYNJxe5WTdrZDUkDVEBRqr2Ehedvduwfu4Bb0aMzjfU2Q4uToBmDxmQUy/
 Ma7rB1UV+ycabGOVoXVNw+GmGRtXxlOyF6NiZsIa1OSYF8S55I6WfTtk8V9ze394yVIL xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3829y3xv6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 03:02:47 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13L6Yfia044934;
        Wed, 21 Apr 2021 03:02:47 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3829y3xv5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 03:02:47 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13L6qrQQ026220;
        Wed, 21 Apr 2021 07:02:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 37yqa8960b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 07:02:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13L72gKe34013578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 07:02:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D4BB11C04A;
        Wed, 21 Apr 2021 07:02:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 081F411C050;
        Wed, 21 Apr 2021 07:02:42 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.39.90])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 21 Apr 2021 07:02:41 +0000 (GMT)
Subject: Re: [PATCH v3 4/9] sched/vtime: Move vtime accounting external
 declarations above inlines
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-5-seanjc@google.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <74cac066-e3e8-7bbf-fb9c-b3709fb7ee0b@de.ibm.com>
Date:   Wed, 21 Apr 2021 09:02:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210415222106.1643837-5-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OwUQ2hJzq0lBhnvGEjeUot3B6WWb09Nt
X-Proofpoint-ORIG-GUID: vko_u5Nh6RQFLonC9XaqHBjqxTdmkN8U
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-20,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16.04.21 00:21, Sean Christopherson wrote:
> Move the blob of external declarations (and their stubs) above the set of
> inline definitions (and their stubs) for vtime accounting.  This will
> allow a future patch to bring in more inline definitions without also
> having to shuffle large chunks of code.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson<seanjc@google.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   include/linux/vtime.h | 94 +++++++++++++++++++++----------------------
>   1 file changed, 47 insertions(+), 47 deletions(-)
> 
> diff --git a/include/linux/vtime.h b/include/linux/vtime.h
> index 041d6524d144..6a4317560539 100644
> --- a/include/linux/vtime.h
> +++ b/include/linux/vtime.h
> @@ -10,53 +10,6 @@
>   
>   struct task_struct;
>   
> -/*
> - * vtime_accounting_enabled_this_cpu() definitions/declarations
> - */
> -#if defined(CONFIG_VIRT_CPU_ACCOUNTING_NATIVE)
> -
> -static inline bool vtime_accounting_enabled_this_cpu(void) { return true; }
> -extern void vtime_task_switch(struct task_struct *prev);
> -
> -#elif defined(CONFIG_VIRT_CPU_ACCOUNTING_GEN)
> -
> -/*
> - * Checks if vtime is enabled on some CPU. Cputime readers want to be careful
> - * in that case and compute the tickless cputime.
> - * For now vtime state is tied to context tracking. We might want to decouple
> - * those later if necessary.
> - */
> -static inline bool vtime_accounting_enabled(void)
> -{
> -	return context_tracking_enabled();
> -}
> -
> -static inline bool vtime_accounting_enabled_cpu(int cpu)
> -{
> -	return context_tracking_enabled_cpu(cpu);
> -}
> -
> -static inline bool vtime_accounting_enabled_this_cpu(void)
> -{
> -	return context_tracking_enabled_this_cpu();
> -}
> -
> -extern void vtime_task_switch_generic(struct task_struct *prev);
> -
> -static inline void vtime_task_switch(struct task_struct *prev)
> -{
> -	if (vtime_accounting_enabled_this_cpu())
> -		vtime_task_switch_generic(prev);
> -}
> -
> -#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
> -
> -static inline bool vtime_accounting_enabled_cpu(int cpu) {return false; }
> -static inline bool vtime_accounting_enabled_this_cpu(void) { return false; }
> -static inline void vtime_task_switch(struct task_struct *prev) { }
> -
> -#endif
> -
>   /*
>    * Common vtime APIs
>    */
> @@ -94,6 +47,53 @@ static inline void vtime_account_hardirq(struct task_struct *tsk) { }
>   static inline void vtime_flush(struct task_struct *tsk) { }
>   #endif
>   
> +/*
> + * vtime_accounting_enabled_this_cpu() definitions/declarations
> + */
> +#if defined(CONFIG_VIRT_CPU_ACCOUNTING_NATIVE)
> +
> +static inline bool vtime_accounting_enabled_this_cpu(void) { return true; }
> +extern void vtime_task_switch(struct task_struct *prev);
> +
> +#elif defined(CONFIG_VIRT_CPU_ACCOUNTING_GEN)
> +
> +/*
> + * Checks if vtime is enabled on some CPU. Cputime readers want to be careful
> + * in that case and compute the tickless cputime.
> + * For now vtime state is tied to context tracking. We might want to decouple
> + * those later if necessary.
> + */
> +static inline bool vtime_accounting_enabled(void)
> +{
> +	return context_tracking_enabled();
> +}
> +
> +static inline bool vtime_accounting_enabled_cpu(int cpu)
> +{
> +	return context_tracking_enabled_cpu(cpu);
> +}
> +
> +static inline bool vtime_accounting_enabled_this_cpu(void)
> +{
> +	return context_tracking_enabled_this_cpu();
> +}
> +
> +extern void vtime_task_switch_generic(struct task_struct *prev);
> +
> +static inline void vtime_task_switch(struct task_struct *prev)
> +{
> +	if (vtime_accounting_enabled_this_cpu())
> +		vtime_task_switch_generic(prev);
> +}
> +
> +#else /* !CONFIG_VIRT_CPU_ACCOUNTING */
> +
> +static inline bool vtime_accounting_enabled_cpu(int cpu) {return false; }
> +static inline bool vtime_accounting_enabled_this_cpu(void) { return false; }
> +static inline void vtime_task_switch(struct task_struct *prev) { }
> +
> +#endif
> +
>   
>   #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>   extern void irqtime_account_irq(struct task_struct *tsk, unsigned int offset);
> -- 2.31.1.368.gbe11c130af-goog
> 
