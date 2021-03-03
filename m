Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BCE32C607
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238731AbhCDA1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343731AbhCCM3u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 07:29:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614774493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EOe4fqSyksQ+t6iqfEbs4KKusbmAebZtw4sO0NgAswg=;
        b=aiLHQ2pygfBtj6bR7ttR8IvK2SxSkpszNYQx4Ya4zWC3sy+DCHEBP6sFUEZOQxOTR+HNo0
        uJLvSX7z+GBZabrtIBsNFn4tAKbsv6arbbPV0dFDjoQuIt5kUlNPZSm0leB00D5bJheS1A
        Mn9rzCH0gUPO1kLu4+OntHwMeuPVFqk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-3SqiSfggOUOZii7upk1UzQ-1; Wed, 03 Mar 2021 07:24:10 -0500
X-MC-Unique: 3SqiSfggOUOZii7upk1UzQ-1
Received: by mail-wm1-f72.google.com with SMTP id q24so2875749wmc.1
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 04:24:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EOe4fqSyksQ+t6iqfEbs4KKusbmAebZtw4sO0NgAswg=;
        b=j+uKQmYgBPX9mjHdhBV8AZ79YzJntl9w99bXK7LDMYJGjRZyjeog9YF2nPpfG0YAq5
         X5CFG7fDSTJoWlW0FwEj36/G58DJA9sQ4nD1RajwyW+1vPyaTVCGcoddOnaekVz1in7D
         xdc4jvqB/LhzPi91mhPYCEqISk0CE3hwnT7mrkSWln0dVOqe0WvuuSJBOoTUDkfSvX9y
         g7LO8jLWKO6RGIBQT/9JZDXiVoDMuYGzZF1KxHegLRZl6QeU4Q0fJv3+FEIMqem/174w
         hxeiYfZDac+kAtCcauxleHMcwdO4xREOHZQrTxF079t6ExO7egkpBfL3bJoC0OcJJ2hb
         yr0g==
X-Gm-Message-State: AOAM530+xgCwTI4doNV93iZ0S+GH8Krrc2PW5ozceGAQlttHsrxOTQ7t
        /50L78//hW6bQmjiVQzeDRpQQ832wf6tcbHKZJNg8VDvw1DuTWeBqNwSUnk/T978b6QUVEKlF9G
        +kxlqqtd7f704
X-Received: by 2002:a1c:f702:: with SMTP id v2mr8695750wmh.131.1614774249521;
        Wed, 03 Mar 2021 04:24:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9/yjlUuKaPWmHfker1GqCi1i/CgJOHrb6s/ZNwHlFIiyYN9twj1rMIJahF8tf71Tg2E4/uQ==
X-Received: by 2002:a1c:f702:: with SMTP id v2mr8695738wmh.131.1614774249334;
        Wed, 03 Mar 2021 04:24:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m132sm5810002wmf.45.2021.03.03.04.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Mar 2021 04:24:08 -0800 (PST)
Subject: Re: [PATCH v3] KVM: nVMX: Sync L2 guest CET states between L1/L2
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210303060435.8158-1-weijiang.yang@intel.com>
 <20210303060435.8158-2-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <073a7e70-33a0-4ce4-9e15-77c4e13e2af3@redhat.com>
Date:   Wed, 3 Mar 2021 13:24:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210303060435.8158-2-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/21 07:04, Yang Weijiang wrote:
> These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
> read/write them and after they're changed. If CET guest entry-load bit is not
> set by L1 guest, migrate them to L2 manaully.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Hi Weijiang, can you post the complete series again?  Thanks!

Paolo

> ---
>   arch/x86/kvm/cpuid.c      |  1 -
>   arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.h    |  3 +++
>   3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d191de769093..8692f53b8cd0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -143,7 +143,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>   		}
>   		vcpu->arch.guest_supported_xss =
>   			(((u64)best->edx << 32) | best->ecx) & supported_xss;
> -
>   	} else {
>   		vcpu->arch.guest_supported_xss = 0;
>   	}
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9728efd529a1..24cace55e1f9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2516,6 +2516,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>   	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
>   
>   	set_cr4_guest_host_mask(vmx);
> +
> +	if (kvm_cet_supported() && vmx->nested.nested_run_pending &&
> +	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> +		vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
> +		vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, vmcs12->guest_ssp_tbl);
> +	}
>   }
>   
>   /*
> @@ -2556,6 +2563,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>   	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>   	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>   		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
> +
> +	if (kvm_cet_supported() && (!vmx->nested.nested_run_pending ||
> +	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))) {
> +		vmcs_writel(GUEST_SSP, vmx->nested.vmcs01_guest_ssp);
> +		vmcs_writel(GUEST_S_CET, vmx->nested.vmcs01_guest_s_cet);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE,
> +			    vmx->nested.vmcs01_guest_ssp_tbl);
> +	}
> +
>   	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
>   
>   	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
> @@ -3375,6 +3391,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>   	if (kvm_mpx_supported() &&
>   		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>   		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +	if (kvm_cet_supported() &&
> +		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> +		vmx->nested.vmcs01_guest_ssp = vmcs_readl(GUEST_SSP);
> +		vmx->nested.vmcs01_guest_s_cet = vmcs_readl(GUEST_S_CET);
> +		vmx->nested.vmcs01_guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +	}
>   
>   	/*
>   	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
> @@ -4001,6 +4023,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
>   	case GUEST_IDTR_BASE:
>   	case GUEST_PENDING_DBG_EXCEPTIONS:
>   	case GUEST_BNDCFGS:
> +	case GUEST_SSP:
> +	case GUEST_INTR_SSP_TABLE:
> +	case GUEST_S_CET:
>   		return true;
>   	default:
>   		break;
> @@ -4052,6 +4077,11 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>   		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>   	if (kvm_mpx_supported())
>   		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +	if (kvm_cet_supported()) {
> +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
> +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
> +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +	}
>   
>   	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
>   }
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 9d3a557949ac..36dc4fdb0909 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -155,6 +155,9 @@ struct nested_vmx {
>   	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
>   	u64 vmcs01_debugctl;
>   	u64 vmcs01_guest_bndcfgs;
> +	u64 vmcs01_guest_ssp;
> +	u64 vmcs01_guest_s_cet;
> +	u64 vmcs01_guest_ssp_tbl;
>   
>   	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
>   	int l1_tpr_threshold;
> 

