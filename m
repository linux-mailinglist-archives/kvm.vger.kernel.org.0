Return-Path: <kvm+bounces-45280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 687DCAA81E0
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 19:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7B285A085F
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 17:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E0827A466;
	Sat,  3 May 2025 17:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=michaellarabel.com header.i=@michaellarabel.com header.b="LA07Vxab"
X-Original-To: kvm@vger.kernel.org
Received: from 190-102-104-130.static.hvvc.us (190-102-104-130.static.hvvc.us [190.102.104.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08A88F58;
	Sat,  3 May 2025 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=190.102.104.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746295153; cv=none; b=hSApOe+0qppFyDyOmeRUlzEH01JWiFBRSz0ofBowVw/Px6GyvOKag7SEUFfXUV5gvSyqXPUlGnSY9X7ETDLu/OlxcNDudN49YeMs50oSoE1/UH8zf/mfvJzC4uJXtjNPzCb7au2sM9KBpOVRgGw8G5CGyGU6EH6YUBVgc05g0ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746295153; c=relaxed/simple;
	bh=bCYEJYasft7mO5UXVByZt6FWWPs8yPW+I7ZXaGOWmyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U09mMmX6F95SEIykeH1yUaDUlrx+ibpJrL44BrFUGZJS+FI10ZlQIVoynpXHahO2am0ltIaFrnrD1dNlJCDRXKqnv17OfPIIg8Zqlgcbm6aQtWeIG1XgAzb25iKH7ICopaIqeWolbyAhm0TAkLkR/KN9eCmLMrUZKzZWweRlGgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=MichaelLarabel.com; spf=pass smtp.mailfrom=MichaelLarabel.com; dkim=pass (2048-bit key) header.d=michaellarabel.com header.i=@michaellarabel.com header.b=LA07Vxab; arc=none smtp.client-ip=190.102.104.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=MichaelLarabel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=MichaelLarabel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=michaellarabel.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uv/0MiJ1oDkQMuH3qE4kY+TiLMBt3lujQa/XExr5xos=; b=LA07VxabDoKmuEZP80o5PzsE/t
	CMCH0BYU8DjELheVtDWM2b0iXd5/PcATqZHnOSyzt+wSh43Wqm6FsMfR25QIPG45c8dQA93wWx7Hf
	lkxjWOQYIE2gh59FvEkrQGJaKofbvZeDAccY88C1WCIgFSsbqN7kLt5neV7vQwiM//L0LS6Sf8+3t
	2p+Gz6LBB1DquOIpF3cX10xvJNKi1eI1FdpgY8zmZr8KwT8W/iTtB+Eymmgf5NRnOg94bU8xz/4r7
	p7z1H92OFLS7+rSDQCWnhgHU6WMyIXk/htEDrNvIYXmDZ0uR4WcqsGHQyJlrFlyTX9G/EF9ht6REf
	mqo3IxcA==;
Received: from c-24-15-38-32.hsd1.in.comcast.net ([24.15.38.32]:1872 helo=[192.168.1.194])
	by milan.phoronix.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <Michael@MichaelLarabel.com>)
	id 1uBH8l-0000000Av9i-1Bi2;
	Sat, 03 May 2025 13:59:04 -0400
Message-ID: <ee6ad3c2-57f5-40a9-b655-006e65a80d3b@MichaelLarabel.com>
Date: Sat, 3 May 2025 12:59:02 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM
 count transitions
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>
References: <20250502223456.887618-1-seanjc@google.com>
Content-Language: en-CA
From: Michael Larabel <Michael@MichaelLarabel.com>
In-Reply-To: <20250502223456.887618-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - milan.phoronix.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - MichaelLarabel.com
X-Get-Message-Sender-Via: milan.phoronix.com: authenticated_id: michael@michaellarabel.com
X-Authenticated-Sender: milan.phoronix.com: michael@michaellarabel.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

 From my testing this patch is in good shape for returning the EPYC 
Turin server bare metal performance w/o VMs back to where it was on 
Linux 6.14.

Thanks,

Michael

On 5/2/25 5:34 PM, Sean Christopherson wrote:
> Set the magic BP_SPEC_REDUCE bit to mitigate SRSO when running VMs if and
> only if KVM has at least one active VM.  Leaving the bit set at all times
> unfortunately degrades performance by a wee bit more than expected.
>
> Use a dedicated spinlock and counter instead of hooking virtualization
> enablement, as changing the behavior of kvm.enable_virt_at_load based on
> SRSO_BP_SPEC_REDUCE is painful, and has its own drawbacks, e.g. could
> result in performance issues for flows that are sensitive to VM creation
> latency.
>
> Similarly, don't bother optimizing the 1=>N and N=>1 transitions, e.g. by
> using atomic_inc_return() to avoid taking the spinlock, as ensuring that
> BP_SPEC_REDUCE is guaranteed to be set before KVM_RUN is non-trivial.  KVM
> already serializes VM creation against kvm_lock (to add the VM to vm_list),
> and the spinlock will only be held for a handful of cycles for the 1<=>N
> cases.  I.e. the complexity needed to ensure correctness outweighs the
> marginal benefits of eliding the lock.  See the Link for details.
>
> Link: https://lore.kernel.org/all/aBOnzNCngyS_pQIW@google.com
> Fixes: 8442df2b49ed ("x86/bugs: KVM: Add support for SRSO_MSR_FIX")
> Reported-by: Michael Larabel <Michael@michaellarabel.com>
> Closes: https://www.phoronix.com/review/linux-615-amd-regression
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 43 ++++++++++++++++++++++++++++++++++++------
>   1 file changed, 37 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cc1c721ba067..364959fd1040 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -607,9 +607,6 @@ static void svm_disable_virtualization_cpu(void)
>   	kvm_cpu_svm_disable();
>   
>   	amd_pmu_disable_virt();
> -
> -	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> -		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
>   }
>   
>   static int svm_enable_virtualization_cpu(void)
> @@ -687,9 +684,6 @@ static int svm_enable_virtualization_cpu(void)
>   		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
>   	}
>   
> -	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> -		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> -
>   	return 0;
>   }
>   
> @@ -5032,10 +5026,46 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>   	sev_vcpu_deliver_sipi_vector(vcpu, vector);
>   }
>   
> +#ifdef CONFIG_CPU_MITIGATIONS
> +static DEFINE_SPINLOCK(srso_lock);
> +static int srso_nr_vms;
> +
> +static void svm_toggle_srso_spec_reduce(void *set)
> +{
> +	if (set)
> +		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> +	else
> +		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> +}
> +
> +static void svm_srso_add_remove_vm(int count)
> +{
> +	bool set;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> +		return;
> +
> +	guard(spinlock)(&srso_lock);
> +
> +	set = !srso_nr_vms;
> +	srso_nr_vms += count;
> +
> +	WARN_ON_ONCE(srso_nr_vms < 0);
> +	if (!set && srso_nr_vms)
> +		return;
> +
> +	on_each_cpu(svm_toggle_srso_spec_reduce, (void *)set, 1);
> +}
> +#else
> +static void svm_srso_add_remove_vm(int count) { }
> +#endif
> +
>   static void svm_vm_destroy(struct kvm *kvm)
>   {
>   	avic_vm_destroy(kvm);
>   	sev_vm_destroy(kvm);
> +
> +	svm_srso_add_remove_vm(-1);
>   }
>   
>   static int svm_vm_init(struct kvm *kvm)
> @@ -5061,6 +5091,7 @@ static int svm_vm_init(struct kvm *kvm)
>   			return ret;
>   	}
>   
> +	svm_srso_add_remove_vm(1);
>   	return 0;
>   }
>   
>
> base-commit: 45eb29140e68ffe8e93a5471006858a018480a45

