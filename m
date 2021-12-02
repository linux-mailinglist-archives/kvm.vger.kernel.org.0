Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA971466A58
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 20:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348483AbhLBTXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 14:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbhLBTXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 14:23:08 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFBDC06174A;
        Thu,  2 Dec 2021 11:19:45 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z5so2227390edd.3;
        Thu, 02 Dec 2021 11:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4qUxqviDTHh9ZqdUoqsbMdepwbHFZ421wjUHBBfI/fA=;
        b=nFWZpROIs47v4BfM2Vq+0sABVA/9P+RAcm7YMfFrD4iv+RqWyqjFYOyNcYCnAuMIuk
         apFhe3t31tSuRebjeKuYTVqHfGbUQHhqJUjbPr5hSf/w3vGQgipS/Qin66Vm08DklEYl
         uYZV4/LpYI9GhMia0tFkpqLculZTNX6dLFWwTpCqfGUusSna771RKyeXsuSPzcR48nnQ
         XqaLJ415V7OrL1XaQR78v1suRE/MX0tNhlm+DMzCwdz3HL0bDzFrggsrpWwKBXQz2w99
         tISTJYinvZWoJJmhCTHTnHrunP0GEBXL7MXLBoTvi9mB8b4uwu+8/d8RXBN1dTxSrYhY
         /4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4qUxqviDTHh9ZqdUoqsbMdepwbHFZ421wjUHBBfI/fA=;
        b=pMko6WhvAWBiRwQDsetH7IePbZKn+FKrXi3SHYT4+pU8rI5+/H7zTpeJH4V7tJRzTe
         KgVd5ph+3YsS7yfhHXA/QGB6rJDKY+AXcU7g4f2bHYHjRoljiykU3HVsTgldc1zU/i1j
         ZD4nckTOLsn6gi772iv7SxcjiHvD6KE1eZduc0/Co5TCYgNHzDnpcoS0iYrhg4bGbBKF
         Fm4HjKV42A39ALEt4ZVO5O7i6X4M2PVb1GiDIjqomPVzTRNJADXEbzmnAp2BK9DFVwf7
         AJNzoX8FjTbpW3QQTMKmTMACiac4R7lZ+b8ON2Kmjiz4EC09KEL/9gaqWHA8wMDbChaq
         /ZYg==
X-Gm-Message-State: AOAM530mA5RtwDXaZTTqjQUV3+IOgHTL99LedlktDzHlCuzVrzLha7Z9
        xkLKelp3SS0o4D4gmCkBr88+yo16lwU=
X-Google-Smtp-Source: ABdhPJzGr7GWl23YkoBK/+1IqNu79afXMBj10GqIlXmZjkEFmm0S6XuUtpgO/WF67RZ9JvF4v6geEA==
X-Received: by 2002:a05:6402:26d4:: with SMTP id x20mr20228218edd.119.1638472784104;
        Thu, 02 Dec 2021 11:19:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id eg8sm369916edb.75.2021.12.02.11.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 11:19:43 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5ce26a04-8766-7472-0a15-fc91eab0a903@redhat.com>
Date:   Thu, 2 Dec 2021 20:19:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b57280b5562893e2616257ac9c2d4525a9aeeb42.1638471124.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/21 19:52, Tom Lendacky wrote:
> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
> exit code or exit parameters fails.
> 
> The VMGEXIT instruction can be issued from userspace, even though
> userspace (likely) can't update the GHCB. To prevent userspace from being
> able to kill the guest, return an error through the GHCB when validation
> fails rather than terminating the guest. For cases where the GHCB can't be
> updated (e.g. the GHCB can't be mapped, etc.), just return back to the
> guest.
> 
> The new error codes are documented in the lasest update to the GHCB
> specification.
> 
> Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   arch/x86/include/asm/sev-common.h |  11 ++++
>   arch/x86/kvm/svm/sev.c            | 106 +++++++++++++++++-------------
>   2 files changed, 71 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 2cef6c5a52c2..6acaf5af0a3d 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -73,4 +73,15 @@
>   
>   #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>   
> +/*
> + * Error codes related to GHCB input that can be communicated back to the guest
> + * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
> + */
> +#define GHCB_ERR_NOT_REGISTERED		1
> +#define GHCB_ERR_INVALID_USAGE		2
> +#define GHCB_ERR_INVALID_SCRATCH_AREA	3
> +#define GHCB_ERR_MISSING_INPUT		4
> +#define GHCB_ERR_INVALID_INPUT		5
> +#define GHCB_ERR_INVALID_EVENT		6
> +
>   #endif
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 713e3daa9574..322553322202 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2353,24 +2353,29 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
>   	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
>   }
>   
> -static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
> +static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu;
>   	struct ghcb *ghcb;
> -	u64 exit_code = 0;
> +	u64 exit_code;
> +	u64 reason;
>   
>   	ghcb = svm->sev_es.ghcb;
>   
> -	/* Only GHCB Usage code 0 is supported */
> -	if (ghcb->ghcb_usage)
> -		goto vmgexit_err;
> -
>   	/*
> -	 * Retrieve the exit code now even though is may not be marked valid
> +	 * Retrieve the exit code now even though it may not be marked valid
>   	 * as it could help with debugging.
>   	 */
>   	exit_code = ghcb_get_sw_exit_code(ghcb);
>   
> +	/* Only GHCB Usage code 0 is supported */
> +	if (ghcb->ghcb_usage) {
> +		reason = GHCB_ERR_INVALID_USAGE;
> +		goto vmgexit_err;
> +	}
> +
> +	reason = GHCB_ERR_MISSING_INPUT;
> +
>   	if (!ghcb_sw_exit_code_is_valid(ghcb) ||
>   	    !ghcb_sw_exit_info_1_is_valid(ghcb) ||
>   	    !ghcb_sw_exit_info_2_is_valid(ghcb))
> @@ -2449,30 +2454,34 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>   		break;
>   	default:
> +		reason = GHCB_ERR_INVALID_EVENT;
>   		goto vmgexit_err;
>   	}
>   
> -	return 0;
> +	return true;
>   
>   vmgexit_err:
>   	vcpu = &svm->vcpu;
>   
> -	if (ghcb->ghcb_usage) {
> +	if (reason == GHCB_ERR_INVALID_USAGE) {
>   		vcpu_unimpl(vcpu, "vmgexit: ghcb usage %#x is not valid\n",
>   			    ghcb->ghcb_usage);
> +	} else if (reason == GHCB_ERR_INVALID_EVENT) {
> +		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx is not valid\n",
> +			    exit_code);
>   	} else {
> -		vcpu_unimpl(vcpu, "vmgexit: exit reason %#llx is not valid\n",
> +		vcpu_unimpl(vcpu, "vmgexit: exit code %#llx input is not valid\n",
>   			    exit_code);
>   		dump_ghcb(svm);
>   	}
>   
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_code;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	/* Clear the valid entries fields */
> +	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
> +
> +	ghcb_set_sw_exit_info_1(ghcb, 2);
> +	ghcb_set_sw_exit_info_2(ghcb, reason);
>   
> -	return -EINVAL;
> +	return false;
>   }
>   
>   void sev_es_unmap_ghcb(struct vcpu_svm *svm)
> @@ -2531,7 +2540,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>   }
>   
>   #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
> -static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
> +static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   {
>   	struct vmcb_control_area *control = &svm->vmcb->control;
>   	struct ghcb *ghcb = svm->sev_es.ghcb;
> @@ -2542,14 +2551,14 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
>   	if (!scratch_gpa_beg) {
>   		pr_err("vmgexit: scratch gpa not provided\n");
> -		return -EINVAL;
> +		goto e_scratch;
>   	}
>   
>   	scratch_gpa_end = scratch_gpa_beg + len;
>   	if (scratch_gpa_end < scratch_gpa_beg) {
>   		pr_err("vmgexit: scratch length (%#llx) not valid for scratch address (%#llx)\n",
>   		       len, scratch_gpa_beg);
> -		return -EINVAL;
> +		goto e_scratch;
>   	}
>   
>   	if ((scratch_gpa_beg & PAGE_MASK) == control->ghcb_gpa) {
> @@ -2567,7 +2576,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   		    scratch_gpa_end > ghcb_scratch_end) {
>   			pr_err("vmgexit: scratch area is outside of GHCB shared buffer area (%#llx - %#llx)\n",
>   			       scratch_gpa_beg, scratch_gpa_end);
> -			return -EINVAL;
> +			goto e_scratch;
>   		}
>   
>   		scratch_va = (void *)svm->sev_es.ghcb;
> @@ -2580,18 +2589,18 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   		if (len > GHCB_SCRATCH_AREA_LIMIT) {
>   			pr_err("vmgexit: scratch area exceeds KVM limits (%#llx requested, %#llx limit)\n",
>   			       len, GHCB_SCRATCH_AREA_LIMIT);
> -			return -EINVAL;
> +			goto e_scratch;
>   		}
>   		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
>   		if (!scratch_va)
> -			return -ENOMEM;
> +			goto e_scratch;
>   
>   		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
>   			/* Unable to copy scratch area from guest */
>   			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
>   
>   			kvfree(scratch_va);
> -			return -EFAULT;
> +			goto e_scratch;
>   		}
>   
>   		/*
> @@ -2607,7 +2616,13 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>   	svm->sev_es.ghcb_sa = scratch_va;
>   	svm->sev_es.ghcb_sa_len = len;
>   
> -	return 0;
> +	return true;
> +
> +e_scratch:
> +	ghcb_set_sw_exit_info_1(ghcb, 2);
> +	ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
> +
> +	return false;
>   }
>   
>   static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
> @@ -2658,7 +2673,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>   
>   		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_CPUID);
>   		if (!ret) {
> -			ret = -EINVAL;
> +			/* Error, keep GHCB MSR value as-is */
>   			break;
>   		}
>   
> @@ -2694,10 +2709,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>   						GHCB_MSR_TERM_REASON_POS);
>   		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>   			reason_set, reason_code);
> -		fallthrough;
> +
> +		ret = -EINVAL;
> +		break;
>   	}
>   	default:
> -		ret = -EINVAL;
> +		/* Error, keep GHCB MSR value as-is */
> +		break;
>   	}
>   
>   	trace_kvm_vmgexit_msr_protocol_exit(svm->vcpu.vcpu_id,
> @@ -2721,14 +2739,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   
>   	if (!ghcb_gpa) {
>   		vcpu_unimpl(vcpu, "vmgexit: GHCB gpa is not set\n");
> -		return -EINVAL;
> +
> +		/* Without a GHCB, just return right back to the guest */
> +		return 1;
>   	}
>   
>   	if (kvm_vcpu_map(vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->sev_es.ghcb_map)) {
>   		/* Unable to map GHCB from guest */
>   		vcpu_unimpl(vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
>   			    ghcb_gpa);
> -		return -EINVAL;
> +
> +		/* Without a GHCB, just return right back to the guest */
> +		return 1;
>   	}
>   
>   	svm->sev_es.ghcb = svm->sev_es.ghcb_map.hva;
> @@ -2738,18 +2760,17 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   
>   	exit_code = ghcb_get_sw_exit_code(ghcb);
>   
> -	ret = sev_es_validate_vmgexit(svm);
> -	if (ret)
> -		return ret;
> +	if (!sev_es_validate_vmgexit(svm))
> +		return 1;
>   
>   	sev_es_sync_from_ghcb(svm);
>   	ghcb_set_sw_exit_info_1(ghcb, 0);
>   	ghcb_set_sw_exit_info_2(ghcb, 0);
>   
> +	ret = 1;
>   	switch (exit_code) {
>   	case SVM_VMGEXIT_MMIO_READ:
> -		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
> -		if (ret)
> +		if (!setup_vmgexit_scratch(svm, true, control->exit_info_2))
>   			break;
>   
>   		ret = kvm_sev_es_mmio_read(vcpu,
> @@ -2758,8 +2779,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   					   svm->sev_es.ghcb_sa);
>   		break;
>   	case SVM_VMGEXIT_MMIO_WRITE:
> -		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
> -		if (ret)
> +		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
>   			break;
>   
>   		ret = kvm_sev_es_mmio_write(vcpu,
> @@ -2788,14 +2808,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   		default:
>   			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
>   			       control->exit_info_1);
> -			ghcb_set_sw_exit_info_1(ghcb, 1);
> -			ghcb_set_sw_exit_info_2(ghcb,
> -						X86_TRAP_UD |
> -						SVM_EVTINJ_TYPE_EXEPT |
> -						SVM_EVTINJ_VALID);
> +			ghcb_set_sw_exit_info_1(ghcb, 2);
> +			ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_INPUT);
>   		}
>   
> -		ret = 1;
>   		break;
>   	}
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
> @@ -2815,7 +2831,6 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>   {
>   	int count;
>   	int bytes;
> -	int r;
>   
>   	if (svm->vmcb->control.exit_info_2 > INT_MAX)
>   		return -EINVAL;
> @@ -2824,9 +2839,8 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>   	if (unlikely(check_mul_overflow(count, size, &bytes)))
>   		return -EINVAL;
>   
> -	r = setup_vmgexit_scratch(svm, in, bytes);
> -	if (r)
> -		return r;
> +	if (!setup_vmgexit_scratch(svm, in, bytes))
> +		return 1;
>   
>   	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->sev_es.ghcb_sa,
>   				    count, in);
> 

Queued, thanks.  Though it would have been nicer to split the changes in 
the return values (e.g. for setup_vmgexit_scratch and 
sev_es_validate_vmgexit) from the introduction of the new GHCB exitinfo.

Paolo

Paolo
