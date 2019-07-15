Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084286862D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 11:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfGOJUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 05:20:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36622 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729426AbfGOJUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 05:20:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6F9J9xt091826;
        Mon, 15 Jul 2019 09:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=WPXUtUycrSFHvFoP18JTSSBusQQ0yVB9F0kKeYk4fGw=;
 b=PqXlndpL84ZCUAqV967W5ySrgCgAS9GiReOqj9l+XBpakUHC80FxIJHQutbQkGYMVXnD
 JEnvog+CgMiasJ+3MleQDCYyfIrtBz80L96HVG9dXC8U5smEmdjuYx/z9LjLJyFqn5xC
 LMvLTlmvvPMjHj7opOgTF54fBngVUrbxdsLzWTCtYiOkHyjeDMM70m5JhR7mO0Z6aa+H
 X4MlS4CpNNnwqjkJX7R2xDxwCBYXiMekdKKDubjCtnARYb6Kn31SxbTpuH2vZOb+s9lv
 qcUPULd0StmoAJkQbFX7B6D+LlXNMXshfTowlZiKf3oGm2GdJOjJNMRoL1Mrdqu34Szh Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tq7xqn91w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 09:20:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6F9HYdK023251;
        Mon, 15 Jul 2019 09:20:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tq742dq9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 09:20:30 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6F9KOuA026769;
        Mon, 15 Jul 2019 09:20:25 GMT
Received: from [192.168.14.112] (/109.64.210.142)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 02:20:24 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 4/4] target/i386: kvm: Demand nested migration kernel
 capabilities only when vCPU may have enabled VMX
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190705210636.3095-5-liran.alon@oracle.com>
Date:   Mon, 15 Jul 2019 12:20:21 +0300
Cc:     pbonzini@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8423C5FD-2F44-48B8-8E1F-A2E8D62E8F2B@oracle.com>
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-5-liran.alon@oracle.com>
To:     qemu-devel@nongnu.org
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9318 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9318 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gentle ping.

Should this be considered to be merged into QEMU even though QEMU is now =
in hard freeze?
As it touches a mechanism which is already merged but too restricted.

Anyway, I would like this to be reviewed even if it=E2=80=99s merged is =
delayed for early feedback.

Thanks,
-Liran

> On 6 Jul 2019, at 0:06, Liran Alon <liran.alon@oracle.com> wrote:
>=20
> Previous to this change, a vCPU exposed with VMX running on a kernel =
without KVM_CAP_NESTED_STATE
> or KVM_CAP_EXCEPTION_PAYLOAD resulted in adding a migration blocker. =
This was because when code
> was written it was thought there is no way to reliabely know if a vCPU =
is utilising VMX or not
> at runtime. However, it turns out that this can be known to some =
extent:
>=20
> In order for a vCPU to enter VMX operation it must have CR4.VMXE set.
> Since it was set, CR4.VMXE must remain set as long as vCPU is in
> VMX operation. This is because CR4.VMXE is one of the bits set
> in MSR_IA32_VMX_CR4_FIXED1.
> There is one exception to above statement when vCPU enters SMM mode.
> When a vCPU enters SMM mode, it temporarily exit VMX operation and
> may also reset CR4.VMXE during execution in SMM mode.
> When vCPU exits SMM mode, vCPU state is restored to be in VMX =
operation
> and CR4.VMXE is restored to it's original value of being set.
> Therefore, when vCPU is not in SMM mode, we can infer whether
> VMX is being used by examining CR4.VMXE. Otherwise, we cannot
> know for certain but assume the worse that vCPU may utilise VMX.
>=20
> Summaring all the above, a vCPU may have enabled VMX in case
> CR4.VMXE is set or vCPU is in SMM mode.
>=20
> Therefore, remove migration blocker and check before migration =
(cpu_pre_save())
> if vCPU may have enabled VMX. If true, only then require relevant =
kernel capabilities.
>=20
> While at it, demand KVM_CAP_EXCEPTION_PAYLOAD only when vCPU is in =
guest-mode and
> there is a pending/injected exception. Otherwise, this kernel =
capability is
> not required for proper migration.
>=20
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
> target/i386/cpu.h      | 22 ++++++++++++++++++++++
> target/i386/kvm.c      | 26 ++++++--------------------
> target/i386/kvm_i386.h |  1 +
> target/i386/machine.c  | 24 ++++++++++++++++++++----
> 4 files changed, 49 insertions(+), 24 deletions(-)
>=20
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index cdb0e43676a9..c752c4d936ee 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1872,6 +1872,28 @@ static inline bool cpu_has_svm(CPUX86State =
*env)
>     return env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM;
> }
>=20
> +/*
> + * In order for a vCPU to enter VMX operation it must have CR4.VMXE =
set.
> + * Since it was set, CR4.VMXE must remain set as long as vCPU is in
> + * VMX operation. This is because CR4.VMXE is one of the bits set
> + * in MSR_IA32_VMX_CR4_FIXED1.
> + *
> + * There is one exception to above statement when vCPU enters SMM =
mode.
> + * When a vCPU enters SMM mode, it temporarily exit VMX operation and
> + * may also reset CR4.VMXE during execution in SMM mode.
> + * When vCPU exits SMM mode, vCPU state is restored to be in VMX =
operation
> + * and CR4.VMXE is restored to it's original value of being set.
> + *
> + * Therefore, when vCPU is not in SMM mode, we can infer whether
> + * VMX is being used by examining CR4.VMXE. Otherwise, we cannot
> + * know for certain.
> + */
> +static inline bool cpu_vmx_maybe_enabled(CPUX86State *env)
> +{
> +    return cpu_has_vmx(env) &&
> +           ((env->cr[4] & CR4_VMXE_MASK) || (env->hflags & =
HF_SMM_MASK));
> +}
> +
> /* fpu_helper.c */
> void update_fp_status(CPUX86State *env);
> void update_mxcsr_status(CPUX86State *env);
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 4e2c8652168f..d3af445eeb5d 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -128,6 +128,11 @@ bool kvm_has_adjust_clock_stable(void)
>     return (ret =3D=3D KVM_CLOCK_TSC_STABLE);
> }
>=20
> +bool kvm_has_exception_payload(void)
> +{
> +    return has_exception_payload;
> +}
> +
> bool kvm_allows_irq0_override(void)
> {
>     return !kvm_irqchip_in_kernel() || kvm_has_gsi_routing();
> @@ -1341,7 +1346,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
> }
>=20
> static Error *invtsc_mig_blocker;
> -static Error *nested_virt_mig_blocker;
>=20
> #define KVM_MAX_CPUID_ENTRIES  100
>=20
> @@ -1640,22 +1644,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
>                                   !!(c->ecx & CPUID_EXT_SMX);
>     }
>=20
> -    if (cpu_has_vmx(env) && !nested_virt_mig_blocker &&
> -        ((kvm_max_nested_state_length() <=3D 0) || =
!has_exception_payload)) {
> -        error_setg(&nested_virt_mig_blocker,
> -                   "Kernel do not provide required capabilities for "
> -                   "nested virtualization migration. "
> -                   "(CAP_NESTED_STATE=3D%d, =
CAP_EXCEPTION_PAYLOAD=3D%d)",
> -                   kvm_max_nested_state_length() > 0,
> -                   has_exception_payload);
> -        r =3D migrate_add_blocker(nested_virt_mig_blocker, =
&local_err);
> -        if (local_err) {
> -            error_report_err(local_err);
> -            error_free(nested_virt_mig_blocker);
> -            return r;
> -        }
> -    }
> -
>     if (env->mcg_cap & MCG_LMCE_P) {
>         has_msr_mcg_ext_ctl =3D has_msr_feature_control =3D true;
>     }
> @@ -1670,7 +1658,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>             if (local_err) {
>                 error_report_err(local_err);
>                 error_free(invtsc_mig_blocker);
> -                goto fail2;
> +                return r;
>             }
>         }
>     }
> @@ -1741,8 +1729,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
>=20
>  fail:
>     migrate_del_blocker(invtsc_mig_blocker);
> - fail2:
> -    migrate_del_blocker(nested_virt_mig_blocker);
>=20
>     return r;
> }
> diff --git a/target/i386/kvm_i386.h b/target/i386/kvm_i386.h
> index 3057ba4f7d19..06fe06bdb3d6 100644
> --- a/target/i386/kvm_i386.h
> +++ b/target/i386/kvm_i386.h
> @@ -35,6 +35,7 @@
> bool kvm_allows_irq0_override(void);
> bool kvm_has_smm(void);
> bool kvm_has_adjust_clock_stable(void);
> +bool kvm_has_exception_payload(void);
> void kvm_synchronize_all_tsc(void);
> void kvm_arch_reset_vcpu(X86CPU *cs);
> void kvm_arch_do_init_vcpu(X86CPU *cs);
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 20bda9f80154..c04021937722 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -7,6 +7,7 @@
> #include "hw/isa/isa.h"
> #include "migration/cpu.h"
> #include "hyperv.h"
> +#include "kvm_i386.h"
>=20
> #include "sysemu/kvm.h"
> #include "sysemu/tcg.h"
> @@ -232,10 +233,25 @@ static int cpu_pre_save(void *opaque)
>     }
>=20
> #ifdef CONFIG_KVM
> -    /* Verify we have nested virtualization state from kernel if =
required */
> -    if (kvm_enabled() && cpu_has_vmx(env) && !env->nested_state) {
> -        error_report("Guest enabled nested virtualization but kernel =
"
> -                "does not support saving of nested state");
> +    /*
> +     * In case vCPU may have enabled VMX, we need to make sure kernel =
have
> +     * required capabilities in order to perform migration correctly:
> +     *
> +     * 1) We must be able to extract vCPU nested-state from KVM.
> +     *
> +     * 2) In case vCPU is running in guest-mode and it has a pending =
exception,
> +     * we must be able to determine if it's in a pending or injected =
state.
> +     * Note that in case KVM don't have required capability to do so,
> +     * a pending/injected exception will always appear as an
> +     * injected exception.
> +     */
> +    if (kvm_enabled() && cpu_vmx_maybe_enabled(env) &&
> +        (!env->nested_state ||
> +         (!kvm_has_exception_payload() && (env->hflags & =
HF_GUEST_MASK) &&
> +          env->exception_injected))) {
> +        error_report("Guest maybe enabled nested virtualization but =
kernel "
> +                "does not support required capabilities to save vCPU =
"
> +                "nested state");
>         return -EINVAL;
>     }
> #endif
> --=20
> 2.20.1
>=20

