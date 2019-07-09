Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6260F63A14
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 19:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfGIRXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 13:23:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51714 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfGIRXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 13:23:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HIvev193944;
        Tue, 9 Jul 2019 17:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=XYj+GDRKK5JQOb0CJXIRlb2h76QXpcgtreKbx1Eu/s0=;
 b=RNGncph72i8TFUaChCyiRZlG2emlSbYe79UojdhL2SlCMcic2pvyZjhgVxMnnAxE2rYo
 UnKQ9uE2si15Tledq2TiJbqT1BNVxOCf6PiLRrLHa4fzykcQAR0a2cpFwa9WCiiHZA3Y
 Kw4ZJEnX+/j7EmgRHC9XL8g/K/VQqlTKZNQwhdaRc1VYWa1zFrxJ8VWPVR8VNPpFip2Q
 36ihqX2wvvHyZVyf3xxjHKF2PkTQMzGLC9fxmkZxEIgqqAV5e2Fp18Ac0liZGpfFjAl9
 yfpL0sO1TyPDUyt1qX1/5YDITdXWgR4DOp/mlwPYRGRtA3J2iNbUiSJV/3TXqi/BgUlE sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tjkkpnp28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:21:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HI19E086078;
        Tue, 9 Jul 2019 17:21:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tmwgx1wde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:21:47 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x69HLkmf013815;
        Tue, 9 Jul 2019 17:21:46 GMT
Received: from [10.159.233.89] (/10.159.233.89)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 10:21:46 -0700
Subject: Re: [Qemu-devel] [PATCH 4/4] target/i386: kvm: Demand nested
 migration kernel capabilities only when vCPU may have enabled VMX
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, Joao Martins <joao.m.martins@oracle.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-5-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <b5a8e30b-e5eb-9bd7-5ad7-8eba56da051f@oracle.com>
Date:   Tue, 9 Jul 2019 10:21:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705210636.3095-5-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090204
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just a bunch of grammar and style nits below. As for the actual code 
changes:

Reviewed-by: Maran Wilson <maran.wilson@oracle.com>
Tested-by: Maran Wilson <maran.wilson@oracle.com>

Thanks,
-Maran

On 7/5/2019 2:06 PM, Liran Alon wrote:
> Previous to this change, a vCPU exposed with VMX running on a kernel without KVM_CAP_NESTED_STATE
> or KVM_CAP_EXCEPTION_PAYLOAD resulted in adding a migration blocker. This was because when code

s/code/the code/

Also, note that you have commit message lines that are much longer than 
76 chars here.

> was written it was thought there is no way to reliabely know if a vCPU is utilising VMX or not
> at runtime. However, it turns out that this can be known to some extent:
>
> In order for a vCPU to enter VMX operation it must have CR4.VMXE set.
> Since it was set, CR4.VMXE must remain set as long as vCPU is in

s/vCPU/the vCPU/

> VMX operation. This is because CR4.VMXE is one of the bits set
> in MSR_IA32_VMX_CR4_FIXED1.
> There is one exception to above statement when vCPU enters SMM mode.

s/above/the above/

> When a vCPU enters SMM mode, it temporarily exit VMX operation and

s/exit/exits/

> may also reset CR4.VMXE during execution in SMM mode.
> When vCPU exits SMM mode, vCPU state is restored to be in VMX operation

s/vCPU exits SMM mode, vCPU/the vCPU exits SMM mode, its/

> and CR4.VMXE is restored to it's original value of being set.

s/it's/its/

> Therefore, when vCPU is not in SMM mode, we can infer whether

s/vCPU/the vCPU/

> VMX is being used by examining CR4.VMXE. Otherwise, we cannot
> know for certain but assume the worse that vCPU may utilise VMX.
>
> Summaring all the above, a vCPU may have enabled VMX in case
> CR4.VMXE is set or vCPU is in SMM mode.
>
> Therefore, remove migration blocker and check before migration (cpu_pre_save())
> if vCPU may have enabled VMX. If true, only then require relevant kernel capabilities.
>
> While at it, demand KVM_CAP_EXCEPTION_PAYLOAD only when vCPU is in guest-mode and

s/vCPU/the vCPU/

> there is a pending/injected exception. Otherwise, this kernel capability is
> not required for proper migration.
>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>   target/i386/cpu.h      | 22 ++++++++++++++++++++++
>   target/i386/kvm.c      | 26 ++++++--------------------
>   target/i386/kvm_i386.h |  1 +
>   target/i386/machine.c  | 24 ++++++++++++++++++++----
>   4 files changed, 49 insertions(+), 24 deletions(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index cdb0e43676a9..c752c4d936ee 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1872,6 +1872,28 @@ static inline bool cpu_has_svm(CPUX86State *env)
>       return env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM;
>   }
>   
> +/*
> + * In order for a vCPU to enter VMX operation it must have CR4.VMXE set.
> + * Since it was set, CR4.VMXE must remain set as long as vCPU is in

s/vCPU/the vCPU/

> + * VMX operation. This is because CR4.VMXE is one of the bits set
> + * in MSR_IA32_VMX_CR4_FIXED1.
> + *
> + * There is one exception to above statement when vCPU enters SMM mode.
> + * When a vCPU enters SMM mode, it temporarily exit VMX operation and

instead of:
    statement when vCPU enters SMM mode. When a vCPU enters SMM mode, it 
temporarily exit
use:
    statement: When a vCPU enters SMM mode, it temporarily exits

> + * may also reset CR4.VMXE during execution in SMM mode.
> + * When vCPU exits SMM mode, vCPU state is restored to be in VMX operation

s/vCPU exits SMM mode, vCPU/the vCPU exits SMM mode, its/


> + * and CR4.VMXE is restored to it's original value of being set.

s/it's/its/

> + *
> + * Therefore, when vCPU is not in SMM mode, we can infer whether

s/vCPU/the vCPU/

> + * VMX is being used by examining CR4.VMXE. Otherwise, we cannot
> + * know for certain.
> + */
> +static inline bool cpu_vmx_maybe_enabled(CPUX86State *env)
> +{
> +    return cpu_has_vmx(env) &&
> +           ((env->cr[4] & CR4_VMXE_MASK) || (env->hflags & HF_SMM_MASK));
> +}
> +
>   /* fpu_helper.c */
>   void update_fp_status(CPUX86State *env);
>   void update_mxcsr_status(CPUX86State *env);
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 4e2c8652168f..d3af445eeb5d 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -128,6 +128,11 @@ bool kvm_has_adjust_clock_stable(void)
>       return (ret == KVM_CLOCK_TSC_STABLE);
>   }
>   
> +bool kvm_has_exception_payload(void)
> +{
> +    return has_exception_payload;
> +}
> +
>   bool kvm_allows_irq0_override(void)
>   {
>       return !kvm_irqchip_in_kernel() || kvm_has_gsi_routing();
> @@ -1341,7 +1346,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
>   }
>   
>   static Error *invtsc_mig_blocker;
> -static Error *nested_virt_mig_blocker;
>   
>   #define KVM_MAX_CPUID_ENTRIES  100
>   
> @@ -1640,22 +1644,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
>                                     !!(c->ecx & CPUID_EXT_SMX);
>       }
>   
> -    if (cpu_has_vmx(env) && !nested_virt_mig_blocker &&
> -        ((kvm_max_nested_state_length() <= 0) || !has_exception_payload)) {
> -        error_setg(&nested_virt_mig_blocker,
> -                   "Kernel do not provide required capabilities for "
> -                   "nested virtualization migration. "
> -                   "(CAP_NESTED_STATE=%d, CAP_EXCEPTION_PAYLOAD=%d)",
> -                   kvm_max_nested_state_length() > 0,
> -                   has_exception_payload);
> -        r = migrate_add_blocker(nested_virt_mig_blocker, &local_err);
> -        if (local_err) {
> -            error_report_err(local_err);
> -            error_free(nested_virt_mig_blocker);
> -            return r;
> -        }
> -    }
> -
>       if (env->mcg_cap & MCG_LMCE_P) {
>           has_msr_mcg_ext_ctl = has_msr_feature_control = true;
>       }
> @@ -1670,7 +1658,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>               if (local_err) {
>                   error_report_err(local_err);
>                   error_free(invtsc_mig_blocker);
> -                goto fail2;
> +                return r;
>               }
>           }
>       }
> @@ -1741,8 +1729,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
>   
>    fail:
>       migrate_del_blocker(invtsc_mig_blocker);
> - fail2:
> -    migrate_del_blocker(nested_virt_mig_blocker);
>   
>       return r;
>   }
> diff --git a/target/i386/kvm_i386.h b/target/i386/kvm_i386.h
> index 3057ba4f7d19..06fe06bdb3d6 100644
> --- a/target/i386/kvm_i386.h
> +++ b/target/i386/kvm_i386.h
> @@ -35,6 +35,7 @@
>   bool kvm_allows_irq0_override(void);
>   bool kvm_has_smm(void);
>   bool kvm_has_adjust_clock_stable(void);
> +bool kvm_has_exception_payload(void);
>   void kvm_synchronize_all_tsc(void);
>   void kvm_arch_reset_vcpu(X86CPU *cs);
>   void kvm_arch_do_init_vcpu(X86CPU *cs);
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 20bda9f80154..c04021937722 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -7,6 +7,7 @@
>   #include "hw/isa/isa.h"
>   #include "migration/cpu.h"
>   #include "hyperv.h"
> +#include "kvm_i386.h"
>   
>   #include "sysemu/kvm.h"
>   #include "sysemu/tcg.h"
> @@ -232,10 +233,25 @@ static int cpu_pre_save(void *opaque)
>       }
>   
>   #ifdef CONFIG_KVM
> -    /* Verify we have nested virtualization state from kernel if required */
> -    if (kvm_enabled() && cpu_has_vmx(env) && !env->nested_state) {
> -        error_report("Guest enabled nested virtualization but kernel "
> -                "does not support saving of nested state");
> +    /*
> +     * In case vCPU may have enabled VMX, we need to make sure kernel have
> +     * required capabilities in order to perform migration correctly:
> +     *
> +     * 1) We must be able to extract vCPU nested-state from KVM.
> +     *
> +     * 2) In case vCPU is running in guest-mode and it has a pending exception,
> +     * we must be able to determine if it's in a pending or injected state.
> +     * Note that in case KVM don't have required capability to do so,
> +     * a pending/injected exception will always appear as an
> +     * injected exception.
> +     */
> +    if (kvm_enabled() && cpu_vmx_maybe_enabled(env) &&
> +        (!env->nested_state ||
> +         (!kvm_has_exception_payload() && (env->hflags & HF_GUEST_MASK) &&
> +          env->exception_injected))) {
> +        error_report("Guest maybe enabled nested virtualization but kernel "
> +                "does not support required capabilities to save vCPU "
> +                "nested state");
>           return -EINVAL;
>       }
>   #endif

