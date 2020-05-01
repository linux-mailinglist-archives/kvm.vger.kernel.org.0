Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F99C1C1FA6
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 23:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEAVak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 17:30:40 -0400
Received: from mail-dm6nam10on2056.outbound.protection.outlook.com ([40.107.93.56]:33505
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbgEAVaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 17:30:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZL+UA3HiR99HYGP2Q9g2diSSZVTtOMyDw7PV1XCLuiDt+pxOAg0ASWNSLqx/gnSvMazE/t+kTtC6Cfdx0mqR++kdXxPUutS3QXFpS7ZKdVrT2vfbnMuFbvSbvYFTNPhejUEtP+n3ssQcAubik2hbnZNkdiYMB3RbC8dMHhPNcTgjbwbVVOd+Z0dy+p1qLlrs7pH02q1U96ccrDNanHTGVeicUQRJPCUsclG0oA0MtYh+5hJ2FZAs/Ttp06EBD6r1M++jTmE7cPJS/db1ajma9wUgLQmHyQ+gBXBMxPy7LHBF0CKpQty9T2RJafRLsKuD6fKEfB5q1lb1S/PdG7Y+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+BS7U69YI38WaIB1mGkpDcHz14Li59tHB9NHbcLegY=;
 b=DuILA3JTwOwLxncTfglsDFVaEYFijHNnRYSavqxh2owRx3HbT1eygPkeT2YQBp2buXE0vjCU2R+182ewfh4DX7UOTF8rBuT/IahnSgbvkPwCCNYdWsp1qu+PkmIocdN1gZOXaeGalZV1F2+0SZJK+lESgZLw4gPQmX3Ac1xcz1nhK9aaERb386UU0UomWWM079vaugm+Psm9LMf6NIep47wLO+aYa3G0NINhoM1bxWl64mzlBOUurNG1bMtVXzlhy5wZuNCuR6c8O0+rkhzc0mE7HFnTt6hGwtvFEj+bPmTRXFldo7sacRQHFYdKs5JjghSWCv/GrPKVG6xWZj/tMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+BS7U69YI38WaIB1mGkpDcHz14Li59tHB9NHbcLegY=;
 b=ulgqH0KwP0ipm2nKDo4VfITrZROTPaifbvboJ8T0B1cC36QtFUOLnDjx71oH6rWnSkeAne3gYUuIlzZ/Twuk9mFYOK1lDQwESYQVaDgsX0+8BvHhFJ6JjJo6huZnGGjF8FameyVAUyGQVZaBfDMbNuVY9IZP8MKTFCrepTPp9P8=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4560.namprd12.prod.outlook.com (2603:10b6:806:97::17)
 by SA0PR12MB4526.namprd12.prod.outlook.com (2603:10b6:806:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 21:30:34 +0000
Received: from SA0PR12MB4560.namprd12.prod.outlook.com
 ([fe80::c827:69cd:c298:da3d]) by SA0PR12MB4560.namprd12.prod.outlook.com
 ([fe80::c827:69cd:c298:da3d%9]) with mapi id 15.20.2958.027; Fri, 1 May 2020
 21:30:34 +0000
Date:   Fri, 1 May 2020 16:30:33 -0500
From:   Wei Huang <wei.huang2@amd.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        jmattson@google.com, wanpengli@tencent.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com
Subject: Re: [PATCH] [v3] kvm: x86: support APERF/MPERF registers
Message-ID: <20200501213033.GA1176754@weiserver.amd.com>
References: <1588243556-11477-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588243556-11477-1-git-send-email-lirongqing@baidu.com>
X-ClientProxiedBy: SN4PR0501CA0018.namprd05.prod.outlook.com
 (2603:10b6:803:40::31) To SA0PR12MB4560.namprd12.prod.outlook.com
 (2603:10b6:806:97::17)
Importance: high
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SN4PR0501CA0018.namprd05.prod.outlook.com (2603:10b6:803:40::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.18 via Frontend Transport; Fri, 1 May 2020 21:30:34 +0000
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d3242a02-7ffa-4783-54ea-08d7ee16e1f9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4526:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4526060715A614A345FB0EE8CFAB0@SA0PR12MB4526.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OfhofsrhYwl7KKQYNnGEarKJMzxRUsvk7vnb64k/a0c7g0LaxLYXIlAYvMTQZJ6Ck+0WwVPT8ArD/+hQQM+KE5ioZqgw8nKRvIew0AuEDMa02/96SC5uIdmKI+ar6+UJUAprNA5TMJR5GP3tiYbtnI2w88FvnDp6v5la5gEeQWwJrUSJfGuQ3RYO/izGD5hMZj53zSh54v5OwG9/obOZlk/NJdtixEx4+WZZVqYudB11jVSDaQ62u/qYCfLEaoVi4DMSgUU4FntyQLvY1BwWSEjqgJq27e6DtToWrXGKc5kj/LPHlqE8fJLWkXR/GIrbIr9mKsMGar+dOQc9wqCqhMoBNteOSFopWSw77cEliTviamHUWfKzCf+ZQ6qAx1V2uig4DddItWKDU4paH4eMzBmwUlDd99ajXJkbhbkcbeA89i3YIwowZR5MtGGi/0YG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(8936002)(7416002)(6486002)(956004)(8676002)(6916009)(478600001)(2906002)(5660300002)(30864003)(52116002)(33656002)(6496006)(1076003)(16526019)(316002)(186003)(66476007)(66556008)(66946007)(4326008)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 18Xu97k5LwL8ivMuCb+sAtnSC7ixmE5wzgSCHrsLqNiegVHRSqim1eDTeMUogr+egZ/5vR7v2h66jF1Ak4bCSzubLXdpBuvM+HVKzrVraQADbJPTlO60GTavLynskxBczG719QGORDKRH5wnlIKBULY79NM9mYykhUP5/C37SUxuGbDBN0W2igCUgc8VviJ7gNV1HUo4rm1XykcR98OIJdlX0vcCyN6IiMcP+0XxDleaJR9oe1RGY+4HnRYHrZ0RP5gHXt+URjcm99kV0rb/49KjRjZuWlEelZW6WVN+WsZwdHT1RBJipgcCsltbqV2I3Pp1sh126yzuX40jfA5bsh5vaPFBxs14GPv1b/K7x+BOoK/XZ8m+QFhDV3cPVgQ4klVhZvwgc11IblAsrYR3boZ3dakbVCktf1l/J3M6QMcgpcVXapFOYLIiq5rhZVmeZApe3GlT1YWeW14PnVSjz3ZpbTjom/q/vPN/u3duWAXUdjZcFKZF/skJF5qpyRCyPDDaYdoW9dYSqH1kHCJmSkNDfXFVAogDDNbNtsgBnqfAMj2R5hEPN0fzx7qBsMSWRIOxC64u3JpZCaUwSBua9KOYLeWebF6FhecmdYetpQpsw4r8ncL0ARgNHyXYiJ7vKSg+5MB01dVeiJn5Kt21zCk1EDJTCLPt9DUnTYByn04apllc0ws++nK1G5svnNq7Vs1xrtey6JTsnrQdEvu1/Hq/StZSOMIFn6IjS31c9oeqZVW+A1TDPpmfj5D/XebfSt3y2iJ7TTpiNl18WaikpN+YJayr31jUKpIOYcMQhgs=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3242a02-7ffa-4783-54ea-08d7ee16e1f9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 21:30:34.7514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZV/JfVvYKnszccT/5JPb/VuyQO1jhui4I/OV1yvRRA3LZEdRtvEknJRxBDie6+i6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4526
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/30 06:45, Li RongQing wrote:
> Guest kernel reports a fixed cpu frequency in /proc/cpuinfo,
> this is confused to user when turbo is enable, and aperf/mperf
> can be used to show current cpu frequency after 7d5905dc14a
> "(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
> so guest should support aperf/mperf capability
> 
> this patch implements aperf/mperf by three mode: none, software
  ^^^^
  This

> emulation, and pass-through
> 
> none: default mode, guest does not support aperf/mperf
> 
> software emulation: the period of aperf/mperf in guest mode are
> accumulated as emulated value
> 
> pass-though: it is only suitable for KVM_HINTS_REALTIME, Because
> that hint guarantees we have a 1:1 vCPU:CPU binding and guaranteed
> no over-commit.

If we save/restore the values of aperf/mperf properly during vcpu migration
among different cores, is pinning still required?

> 
> and a per-VM capability is added to configure aperfmperf mode
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Chai Wen <chaiwen@baidu.com>
> Signed-off-by: Jia Lina <jialina01@baidu.com>
> ---
> diff v2:
> support aperfmperf pass though
> move common codes to kvm_get_msr_common
> 
> diff v1:
> 1. support AMD, but not test

pt-mode doesn't work doesn't work on AMD. See below.

> 2. support per-vm capability to enable
>  Documentation/virt/kvm/api.rst  | 10 ++++++++++
>  arch/x86/include/asm/kvm_host.h | 11 +++++++++++
>  arch/x86/kvm/cpuid.c            | 13 ++++++++++++-
>  arch/x86/kvm/svm.c              |  8 ++++++++
>  arch/x86/kvm/vmx/vmx.c          |  6 ++++++
>  arch/x86/kvm/x86.c              | 42 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h              | 15 +++++++++++++++
>  include/uapi/linux/kvm.h        |  1 +
>  8 files changed, 105 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index efbbe570aa9b..c3be3b6a1717 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6109,3 +6109,13 @@ KVM can therefore start protected VMs.
>  This capability governs the KVM_S390_PV_COMMAND ioctl and the
>  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
>  guests when the state change is invalid.
> +
> +8.23 KVM_CAP_APERFMPERF
> +----------------------------
> +
> +:Architectures: x86
> +:Parameters: args[0] is aperfmperf mode;
> +             0 for not support, 1 for software emulation, 2 for pass-through
> +:Returns: 0 on success; -1 on error
> +
> +This capability indicates that KVM supports APERF and MPERF MSR registers
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d3984a..81477f676f60 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -820,6 +820,9 @@ struct kvm_vcpu_arch {
>  
>  	/* AMD MSRC001_0015 Hardware Configuration */
>  	u64 msr_hwcr;
> +
> +	u64 v_mperf;
> +	u64 v_aperf;
>  };
>  
>  struct kvm_lpage_info {
> @@ -885,6 +888,12 @@ enum kvm_irqchip_mode {
>  	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
>  };
>  
> +enum kvm_aperfmperf_mode {
> +	KVM_APERFMPERF_NONE,
> +	KVM_APERFMPERF_SOFT,      /* software emulate aperfmperf */
> +	KVM_APERFMPERF_PT,        /* pass-through aperfmperf to guest */
> +};
> +
>  #define APICV_INHIBIT_REASON_DISABLE    0
>  #define APICV_INHIBIT_REASON_HYPERV     1
>  #define APICV_INHIBIT_REASON_NESTED     2
> @@ -982,6 +991,8 @@ struct kvm_arch {
>  
>  	struct kvm_pmu_event_filter *pmu_event_filter;
>  	struct task_struct *nx_lpage_recovery_thread;
> +
> +	enum kvm_aperfmperf_mode aperfmperf_mode;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 901cd1fdecd9..7a64ea2c3eef 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -124,6 +124,14 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  					   MSR_IA32_MISC_ENABLE_MWAIT);
>  	}
>  
> +	best = kvm_find_cpuid_entry(vcpu, 6, 0);
> +	if (best) {
> +		if (guest_has_aperfmperf(vcpu->kvm) &&
> +			boot_cpu_has(X86_FEATURE_APERFMPERF))
> +			best->ecx |= 1;
> +		else
> +			best->ecx &= ~1;
> +	}
>  	/* Update physical-address width */
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>  	kvm_mmu_reset_context(vcpu);
> @@ -558,7 +566,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	case 6: /* Thermal management */
>  		entry->eax = 0x4; /* allow ARAT */
>  		entry->ebx = 0;
> -		entry->ecx = 0;
> +		if (boot_cpu_has(X86_FEATURE_APERFMPERF))
> +			entry->ecx = 0x1;
> +		else
> +			entry->ecx = 0x0;
>  		entry->edx = 0;
>  		break;
>  	/* function 7 has additional index. */
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 851e9cc79930..5646b6475049 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
                 ^^^^^^^^^
The latest kernel moves svm-related files to arch/x86/kvm/svm
directory. You need to update your patches.

> @@ -2292,6 +2292,14 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	svm->msrpm = page_address(msrpm_pages);
>  	svm_vcpu_init_msrpm(svm->msrpm);
>  
> +	if (guest_aperfmperf_soft(vcpu->kvm)) {
> +		set_msr_interception(svm->msrpm, MSR_IA32_MPERF, 1, 0);
> +		set_msr_interception(svm->msrpm, MSR_IA32_APERF, 1, 0);
> +	} else if (guest_aperfmperf_pt(vcpu->kvm)) {
> +		set_msr_interception(svm->msrpm, MSR_IA32_MPERF, 0, 0);
> +		set_msr_interception(svm->msrpm, MSR_IA32_APERF, 0, 0);
> +	}

The bit setting for KVM_APERFMPERF_SOFT and KVM_APERFMPERF_PT is
incorrect. set_msr_interception() takes read/write as parameters. When
they are 1, it means svm doesn't intercept this specific MSR. So, you
code should look like:

     if (guest_aperfmperf_soft(vcpu->kvm)) {
             set_msr_interception(svm->msrpm, MSR_IA32_MPERF, 0, 0);
             set_msr_interception(svm->msrpm, MSR_IA32_APERF, 0, 0);
     } else if (guest_aperfmperf_pt(vcpu->kvm)) {
             set_msr_interception(svm->msrpm, MSR_IA32_MPERF, 1, 0);
             set_msr_interception(svm->msrpm, MSR_IA32_APERF, 1, 0);
     }


> +
>  	svm->nested.msrpm = page_address(nested_msrpm_pages);
>  	svm_vcpu_init_msrpm(svm->nested.msrpm);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 91749f1254e8..023c411ce5ad 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6759,6 +6759,12 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
>  		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
>  	}
> +
> +	if (guest_aperfmperf_pt(vcpu->kvm)) {
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_MPERF, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_APERF, MSR_TYPE_R);
> +	}
> +
>  	vmx->msr_bitmap_mode = 0;
>  
>  	vmx->loaded_vmcs = &vmx->vmcs01;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b8124b562dea..a57f69a0eb6e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3227,6 +3227,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_K7_HWCR:
>  		msr_info->data = vcpu->arch.msr_hwcr;
>  		break;
> +	case MSR_IA32_MPERF:
> +		msr_info->data = vcpu->arch.v_mperf;
> +		break;
> +	case MSR_IA32_APERF:
> +		msr_info->data = vcpu->arch.v_aperf;
> +		break;
>  	default:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>  			return kvm_pmu_get_msr(vcpu, msr_info->index, &msr_info->data);
> @@ -3435,6 +3441,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>  		r = kvm_x86_ops.nested_enable_evmcs != NULL;
>  		break;
> +	case KVM_CAP_APERFMPERF:
> +		r = boot_cpu_has(X86_FEATURE_APERFMPERF) ? 1 : 0;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -4883,6 +4892,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		kvm->arch.exception_payload_enabled = cap->args[0];
>  		r = 0;
>  		break;
> +	case KVM_CAP_APERFMPERF:
> +		kvm->arch.aperfmperf_mode =
> +			boot_cpu_has(X86_FEATURE_APERFMPERF) ? cap->args[0] : 0;
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -8163,6 +8177,25 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
>  
> +
> +static void guest_enter_aperfmperf(u64 *mperf, u64 *aperf)
> +{
> +	rdmsrl(MSR_IA32_MPERF, *mperf);
> +	rdmsrl(MSR_IA32_APERF, *aperf);
> +}
> +
> +static void guest_exit_aperfmperf(struct kvm_vcpu *vcpu,
> +		u64 mperf, u64 aperf)
> +{
> +	u64 perf;
> +
> +	rdmsrl(MSR_IA32_MPERF, perf);
> +	vcpu->arch.v_mperf += perf - mperf;
> +
> +	rdmsrl(MSR_IA32_APERF, perf);
> +	vcpu->arch.v_aperf += perf - aperf;
> +}
> +
>  /*
>   * Returns 1 to let vcpu_run() continue the guest execution loop without
>   * exiting to the userspace.  Otherwise, the value will be returned to the
> @@ -8176,7 +8209,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		kvm_cpu_accept_dm_intr(vcpu);
>  	enum exit_fastpath_completion exit_fastpath = EXIT_FASTPATH_NONE;
>  
> +	bool enable_aperfmperf = guest_aperfmperf_soft(vcpu->kvm);
>  	bool req_immediate_exit = false;
> +	u64 mperf, aperf;
>  
>  	if (kvm_request_pending(vcpu)) {
>  		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
> @@ -8326,6 +8361,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	preempt_disable();
>  
> +	if (unlikely(enable_aperfmperf))
> +		guest_enter_aperfmperf(&mperf, &aperf);
> +
>  	kvm_x86_ops.prepare_guest_switch(vcpu);
>  
>  	/*
> @@ -8449,6 +8487,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	}
>  
>  	local_irq_enable();
> +
> +	if (unlikely(enable_aperfmperf))
> +		guest_exit_aperfmperf(vcpu, mperf, aperf);
> +
>  	preempt_enable();
>  
>  	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index b968acc0516f..d58dc4e4f96d 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -355,6 +355,21 @@ static inline bool kvm_dr7_valid(u64 data)
>  	return !(data >> 32);
>  }
>  
> +static inline bool guest_has_aperfmperf(struct kvm *kvm)
> +{
> +	return kvm->arch.aperfmperf_mode != KVM_APERFMPERF_NONE;
> +}
> +
> +static inline bool guest_aperfmperf_soft(struct kvm *kvm)
> +{
> +	return kvm->arch.aperfmperf_mode == KVM_APERFMPERF_SOFT;
> +}
> +
> +static inline bool guest_aperfmperf_pt(struct kvm *kvm)
> +{
> +	return kvm->arch.aperfmperf_mode == KVM_APERFMPERF_PT;
> +}
> +
>  void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>  u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 428c7dde6b4b..c67109a02a4d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_VCPU_RESETS 179
>  #define KVM_CAP_S390_PROTECTED 180
>  #define KVM_CAP_PPC_SECURE_GUEST 181
> +#define KVM_CAP_APERFMPERF 182
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
>
