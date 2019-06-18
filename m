Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A044ADC9
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbfFRWT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:19:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52200 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfFRWT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:19:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMIdTY086840;
        Tue, 18 Jun 2019 22:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=iPYOzaTLwXEpR/qgcDvMxt1yBcJnwPVfjy3j2h+akRo=;
 b=m2smozI8fMqJXYBPRmzMysuqFqzuLoTwem+e18YImvApWg5UlnVoru8HKF+tJWx/2q4t
 ZRGG9OXEhRU81tEoeV7kKC8X3QbKLFZhKd+oW1OaEcwhvzBeYdrnDc8GhGqsh3YtvtK3
 e/cGviYt0iFWEiuaRb5eA7EvGlovcemq0mplWgojVEa82tOwXZJ6SVl86Pkf5JXqYxpq
 SIJppCFprBBeSqBlr5T63yJyqdL6v61o6oAdmu4cPI3uULAmnZoMEH/1CzV3YSQLVHFS
 znaXM/roZRhi1sFLKGCWL/N5tsblU0NZxJTaSPJJ0F/kn/uK0F1R780deGKADCSbQ8cr yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t780983x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:18:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMFB1Z137142;
        Tue, 18 Jun 2019 22:16:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t77yn0eeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:16:50 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IMGoxT032112;
        Tue, 18 Jun 2019 22:16:50 GMT
Received: from [10.141.197.71] (/10.141.197.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 15:16:50 -0700
Subject: Re: [Qemu-devel] [QEMU PATCH v3 7/9] KVM: i386: Add support for save
 and restore nested state
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        dgilbert@redhat.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        pbonzini@redhat.com, rth@twiddle.net, jmattson@google.com
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-8-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <befc38dc-40ed-41e4-4261-f4a841bddb7a@oracle.com>
Date:   Tue, 18 Jun 2019 15:16:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617175658.135869-8-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/2019 10:56 AM, Liran Alon wrote:
> Kernel commit 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
> introduced new IOCTLs to extract and restore vCPU state related to
> Intel VMX & AMD SVM.
>
> Utilize these IOCTLs to add support for migration of VMs which are
> running nested hypervisors.
>
> Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>   accel/kvm/kvm-all.c   |   8 ++
>   include/sysemu/kvm.h  |   1 +
>   target/i386/cpu.h     |   3 +
>   target/i386/kvm.c     |  80 +++++++++++++++++
>   target/i386/machine.c | 196 ++++++++++++++++++++++++++++++++++++++++++
>   5 files changed, 288 insertions(+)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 59a3aa3a40da..4fdf5b04b131 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -88,6 +88,7 @@ struct KVMState
>   #ifdef KVM_CAP_SET_GUEST_DEBUG
>       QTAILQ_HEAD(, kvm_sw_breakpoint) kvm_sw_breakpoints;
>   #endif
> +    int max_nested_state_len;
>       int many_ioeventfds;
>       int intx_set_mask;
>       bool sync_mmu;
> @@ -1678,6 +1679,8 @@ static int kvm_init(MachineState *ms)
>       s->debugregs = kvm_check_extension(s, KVM_CAP_DEBUGREGS);
>   #endif
>   
> +    s->max_nested_state_len = kvm_check_extension(s, KVM_CAP_NESTED_STATE);
> +
>   #ifdef KVM_CAP_IRQ_ROUTING
>       kvm_direct_msi_allowed = (kvm_check_extension(s, KVM_CAP_SIGNAL_MSI) > 0);
>   #endif
> @@ -2245,6 +2248,11 @@ int kvm_has_debugregs(void)
>       return kvm_state->debugregs;
>   }
>   
> +int kvm_max_nested_state_length(void)
> +{
> +    return kvm_state->max_nested_state_len;
> +}
> +
>   int kvm_has_many_ioeventfds(void)
>   {
>       if (!kvm_enabled()) {
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 64f55e519df7..acd90aebb6c4 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -210,6 +210,7 @@ bool kvm_has_sync_mmu(void);
>   int kvm_has_vcpu_events(void);
>   int kvm_has_robust_singlestep(void);
>   int kvm_has_debugregs(void);
> +int kvm_max_nested_state_length(void);
>   int kvm_has_pit_state2(void);
>   int kvm_has_many_ioeventfds(void);
>   int kvm_has_gsi_routing(void);
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 79d9495ceb0c..a6bb71849869 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1350,6 +1350,9 @@ typedef struct CPUX86State {
>   #if defined(CONFIG_KVM) || defined(CONFIG_HVF)
>       void *xsave_buf;
>   #endif
> +#if defined(CONFIG_KVM)
> +    struct kvm_nested_state *nested_state;
> +#endif
>   #if defined(CONFIG_HVF)
>       HVFX86EmulatorState *hvf_emul;
>   #endif
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index f43e2d69859e..5950c3ed0d1c 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -931,6 +931,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       struct kvm_cpuid_entry2 *c;
>       uint32_t signature[3];
>       int kvm_base = KVM_CPUID_SIGNATURE;
> +    int max_nested_state_len;
>       int r;
>       Error *local_err = NULL;
>   
> @@ -1331,6 +1332,24 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       if (has_xsave) {
>           env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
>       }
> +
> +    max_nested_state_len = kvm_max_nested_state_length();
> +    if (max_nested_state_len > 0) {
> +        assert(max_nested_state_len >= offsetof(struct kvm_nested_state, data));
> +        env->nested_state = g_malloc0(max_nested_state_len);
> +
> +        env->nested_state->size = max_nested_state_len;
> +
> +        if (IS_INTEL_CPU(env)) {
> +            struct kvm_vmx_nested_state_hdr *vmx_hdr =
> +                &env->nested_state->hdr.vmx;
> +
> +            vmx_hdr->vmxon_pa = -1ull;
> +            vmx_hdr->vmcs12_pa = -1ull;
> +        }
> +
> +    }
> +
>       cpu->kvm_msr_buf = g_malloc0(MSR_BUF_SIZE);
>   
>       if (!(env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_RDTSCP)) {
> @@ -1352,12 +1371,18 @@ int kvm_arch_init_vcpu(CPUState *cs)
>   int kvm_arch_destroy_vcpu(CPUState *cs)
>   {
>       X86CPU *cpu = X86_CPU(cs);
> +    CPUX86State *env = &cpu->env;
>   
>       if (cpu->kvm_msr_buf) {
>           g_free(cpu->kvm_msr_buf);
>           cpu->kvm_msr_buf = NULL;
>       }
>   
> +    if (env->nested_state) {
> +        g_free(env->nested_state);
> +        env->nested_state = NULL;
> +    }
> +
>       return 0;
>   }
>   
> @@ -3072,6 +3097,52 @@ static int kvm_get_debugregs(X86CPU *cpu)
>       return 0;
>   }
>   
> +static int kvm_put_nested_state(X86CPU *cpu)
> +{
> +    CPUX86State *env = &cpu->env;
> +    int max_nested_state_len = kvm_max_nested_state_length();
> +
> +    if (max_nested_state_len <= 0) {
> +        return 0;
> +    }
> +
> +    assert(env->nested_state->size <= max_nested_state_len);
> +    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_NESTED_STATE, env->nested_state);
> +}
> +
> +static int kvm_get_nested_state(X86CPU *cpu)
> +{
> +    CPUX86State *env = &cpu->env;
> +    int max_nested_state_len = kvm_max_nested_state_length();
> +    int ret;
> +
> +    if (max_nested_state_len <= 0) {
> +        return 0;
> +    }
> +
> +    /*
> +     * It is possible that migration restored a smaller size into
> +     * nested_state->hdr.size than what our kernel support.
> +     * We preserve migration origin nested_state->hdr.size for
> +     * call to KVM_SET_NESTED_STATE but wish that our next call
> +     * to KVM_GET_NESTED_STATE will use max size our kernel support.
> +     */
> +    env->nested_state->size = max_nested_state_len;
> +
> +    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_NESTED_STATE, env->nested_state);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    if (env->nested_state->flags & KVM_STATE_NESTED_GUEST_MODE) {
> +        env->hflags |= HF_GUEST_MASK;
> +    } else {
> +        env->hflags &= ~HF_GUEST_MASK;
> +    }
> +
> +    return ret;
> +}
> +
>   int kvm_arch_put_registers(CPUState *cpu, int level)
>   {
>       X86CPU *x86_cpu = X86_CPU(cpu);
> @@ -3079,6 +3150,11 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
>   
>       assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
>   
> +    ret = kvm_put_nested_state(x86_cpu);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
>       if (level >= KVM_PUT_RESET_STATE) {
>           ret = kvm_put_msr_feature_control(x86_cpu);
>           if (ret < 0) {
> @@ -3194,6 +3270,10 @@ int kvm_arch_get_registers(CPUState *cs)
>       if (ret < 0) {
>           goto out;
>       }
> +    ret = kvm_get_nested_state(cpu);
> +    if (ret < 0) {
> +        goto out;
> +    }
>       ret = 0;
>    out:
>       cpu_sync_bndcs_hflags(&cpu->env);
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 225b5d433bc4..95299ebff44a 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -231,6 +231,15 @@ static int cpu_pre_save(void *opaque)
>           env->segs[R_SS].flags &= ~(env->segs[R_SS].flags & DESC_DPL_MASK);
>       }
>   
> +#ifdef CONFIG_KVM
> +    /* Verify we have nested virtualization state from kernel if required */
> +    if (cpu_has_nested_virt(env) && !env->nested_state) {
> +        error_report("Guest enabled nested virtualization but kernel "
> +                "does not support saving of nested state");
> +        return -EINVAL;
> +    }
> +#endif
> +
>       return 0;
>   }
>   
> @@ -278,6 +287,16 @@ static int cpu_post_load(void *opaque, int version_id)
>       env->hflags &= ~HF_CPL_MASK;
>       env->hflags |= (env->segs[R_SS].flags >> DESC_DPL_SHIFT) & HF_CPL_MASK;
>   
> +#ifdef CONFIG_KVM
> +    if ((env->hflags & HF_GUEST_MASK) &&
> +        (!env->nested_state ||
> +        !(env->nested_state->flags & KVM_STATE_NESTED_GUEST_MODE))) {
> +        error_report("vCPU set in guest-mode inconsistent with "
> +                     "migrated kernel nested state");
> +        return -EINVAL;
> +    }
> +#endif
> +
>       env->fpstt = (env->fpus_vmstate >> 11) & 7;
>       env->fpus = env->fpus_vmstate & ~0x3800;
>       env->fptag_vmstate ^= 0xff;
> @@ -851,6 +870,180 @@ static const VMStateDescription vmstate_tsc_khz = {
>       }
>   };
>   
> +#ifdef CONFIG_KVM
> +
> +static bool vmx_vmcs12_needed(void *opaque)
> +{
> +    struct kvm_nested_state *nested_state = opaque;
> +    return (nested_state->size >
> +            offsetof(struct kvm_nested_state, data.vmx[0].vmcs12));
> +}
> +
> +static const VMStateDescription vmstate_vmx_vmcs12 = {
> +	.name = "cpu/kvm_nested_state/vmx/vmcs12",
> +	.version_id = 1,
> +	.minimum_version_id = 1,
> +	.needed = vmx_vmcs12_needed,
> +	.fields = (VMStateField[]) {
> +	    VMSTATE_UINT8_ARRAY(data.vmx[0].vmcs12,
> +	                        struct kvm_nested_state, 0x1000),
> +	    VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static bool vmx_shadow_vmcs12_needed(void *opaque)
> +{
> +    struct kvm_nested_state *nested_state = opaque;
> +    return (nested_state->size >
> +            offsetof(struct kvm_nested_state, data.vmx[0].shadow_vmcs12));
> +}
> +
> +static const VMStateDescription vmstate_vmx_shadow_vmcs12 = {
> +	.name = "cpu/kvm_nested_state/vmx/shadow_vmcs12",
> +	.version_id = 1,
> +	.minimum_version_id = 1,
> +	.needed = vmx_shadow_vmcs12_needed,
> +	.fields = (VMStateField[]) {
> +	    VMSTATE_UINT8_ARRAY(data.vmx[0].shadow_vmcs12,
> +	                        struct kvm_nested_state, 0x1000),
> +	    VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static bool vmx_nested_state_needed(void *opaque)
> +{
> +    struct kvm_nested_state *nested_state = opaque;
> +
> +    return ((nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
> +            ((nested_state->hdr.vmx.vmxon_pa != -1ull) ||
> +             (nested_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON)));
> +}
> +
> +static const VMStateDescription vmstate_vmx_nested_state = {
> +	.name = "cpu/kvm_nested_state/vmx",
> +	.version_id = 1,
> +	.minimum_version_id = 1,
> +	.needed = vmx_nested_state_needed,
> +	.fields = (VMStateField[]) {
> +	    VMSTATE_U64(hdr.vmx.vmxon_pa, struct kvm_nested_state),
> +	    VMSTATE_U64(hdr.vmx.vmcs12_pa, struct kvm_nested_state),
> +	    VMSTATE_U16(hdr.vmx.smm.flags, struct kvm_nested_state),
> +	    VMSTATE_END_OF_LIST()
> +    },
> +    .subsections = (const VMStateDescription*[]) {
> +        &vmstate_vmx_vmcs12,
> +        &vmstate_vmx_shadow_vmcs12,
> +        NULL,
> +    }
> +};
> +
> +static bool svm_nested_state_needed(void *opaque)
> +{
> +    struct kvm_nested_state *nested_state = opaque;
> +
> +    return (nested_state->format == KVM_STATE_NESTED_FORMAT_SVM);
> +}
> +
> +static const VMStateDescription vmstate_svm_nested_state = {
> +	.name = "cpu/kvm_nested_state/svm",
> +	.version_id = 1,
> +	.minimum_version_id = 1,
> +	.needed = svm_nested_state_needed,
> +	.fields = (VMStateField[]) {
> +	    VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static bool nested_state_needed(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +
> +    return (env->nested_state &&
> +            (vmx_nested_state_needed(env->nested_state) ||
> +             svm_nested_state_needed(env->nested_state)));
> +}
> +
> +static int nested_state_post_load(void *opaque, int version_id)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +    struct kvm_nested_state *nested_state = env->nested_state;
> +    int min_nested_state_len = offsetof(struct kvm_nested_state, data);
> +    int max_nested_state_len = kvm_max_nested_state_length();
> +
> +    /*
> +     * If our kernel don't support setting nested state
> +     * and we have received nested state from migration stream,
> +     * we need to fail migration
> +     */
> +    if (max_nested_state_len <= 0) {
> +        error_report("Received nested state when kernel cannot restore it");
> +        return -EINVAL;
> +    }
> +
> +    /*
> +     * Verify that the size of received nested_state struct
> +     * at least cover required header and is not larger
> +     * than the max size that our kernel support
> +     */
> +    if (nested_state->size < min_nested_state_len) {
> +        error_report("Received nested state size less than min: "
> +                     "len=%d, min=%d",
> +                     nested_state->size, min_nested_state_len);
> +        return -EINVAL;
> +    }
> +    if (nested_state->size > max_nested_state_len) {
> +        error_report("Recieved unsupported nested state size: "
> +                     "nested_state->size=%d, max=%d",
> +                     nested_state->size, max_nested_state_len);
> +        return -EINVAL;
> +    }
> +
> +    /* Verify format is valid */
> +    if ((nested_state->format != KVM_STATE_NESTED_FORMAT_VMX) &&
> +        (nested_state->format != KVM_STATE_NESTED_FORMAT_SVM)) {
> +        error_report("Received invalid nested state format: %d",
> +                     nested_state->format);
> +        return -EINVAL;
> +    }
> +
> +    return 0;
> +}
> +
> +static const VMStateDescription vmstate_kvm_nested_state = {
> +    .name = "cpu/kvm_nested_state",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_U16(flags, struct kvm_nested_state),
> +        VMSTATE_U16(format, struct kvm_nested_state),
> +        VMSTATE_U32(size, struct kvm_nested_state),
> +        VMSTATE_END_OF_LIST()
> +    },
> +    .subsections = (const VMStateDescription*[]) {
> +        &vmstate_vmx_nested_state,
> +        &vmstate_svm_nested_state,
> +        NULL
> +    }
> +};
> +
> +static const VMStateDescription vmstate_nested_state = {
> +    .name = "cpu/nested_state",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = nested_state_needed,
> +    .post_load = nested_state_post_load,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_STRUCT_POINTER(env.nested_state, X86CPU,
> +                               vmstate_kvm_nested_state,
> +                               struct kvm_nested_state),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +#endif
> +
>   static bool mcg_ext_ctl_needed(void *opaque)
>   {
>       X86CPU *cpu = opaque;
> @@ -1089,6 +1282,9 @@ VMStateDescription vmstate_x86_cpu = {
>           &vmstate_msr_intel_pt,
>           &vmstate_msr_virt_ssbd,
>           &vmstate_svm_npt,
> +#ifdef CONFIG_KVM
> +        &vmstate_nested_state,
> +#endif
>           NULL
>       }
>   };

I'm not sure it's comprehensive enough to qualify for a "Tested-by" 
line, but I did run this latest patch series in my environment and 
confirm that I was able to save/restore L1 VMs that had created active 
L2 VMs of their own. Previously those tests would always result in a L1 
kernel failure upon restoration. I also verified that cpu_pre_save() was 
properly catching and preventing the save when the host kernel did not 
support KVM_CAP_NESTED_STATE.

And aside from the 0x1000 magic value, this latest version of the patch 
looks good.

Reviewed-by: Maran Wilson <maran.wilson@oracle.com>

Thanks,
-Maran
