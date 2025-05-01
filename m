Return-Path: <kvm+bounces-45008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CAAAA591E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 02:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CE889E0B81
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 00:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67C51A38E4;
	Thu,  1 May 2025 00:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=michaellarabel.com header.i=@michaellarabel.com header.b="TBHZzxEk"
X-Original-To: kvm@vger.kernel.org
Received: from 190-102-104-130.static.hvvc.us (190-102-104-130.static.hvvc.us [190.102.104.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D432DC76A;
	Thu,  1 May 2025 00:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=190.102.104.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746060170; cv=none; b=tuscNq0B+yrrDOWwNCIbZa3slP8kGYncT4DzLMaKtNm8ymy+UU/5PHNsHJajjsAzoxofP8GJKGMBP8AOq8UI9g6mpmZ0XahNYqh4AovmDoB1UxIs9B1IQnw1UzmVdcRHnoo7RzJ98AUVZSu2KMyee2i9PEY7Uc0iadk2KBid3sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746060170; c=relaxed/simple;
	bh=u4vJQ4EZ7iai23ImD/isLw1H0LAlB+6YXgwnpaLZ3LI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cydih3+oYTt/2AbhZL2awCS7LZli9mV7NO5odWfZBGq9WpoR/68KmiEjjiteECTSUegmyu28zelevvFrrxvJK3k91TWhnLt/FRolIHttDelgHa0V/2tEy2oUaaw4WR1u2QQTaTfw1SSVYb5d6MD8Isxk2oB4rj4Wc1AuXlMEoik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=MichaelLarabel.com; spf=pass smtp.mailfrom=MichaelLarabel.com; dkim=pass (2048-bit key) header.d=michaellarabel.com header.i=@michaellarabel.com header.b=TBHZzxEk; arc=none smtp.client-ip=190.102.104.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=MichaelLarabel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=MichaelLarabel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=michaellarabel.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=i406TcAVK4oHfTBiQVuIG6fpRh1d2CwOIn57JcmD2t8=; b=TBHZzxEkzhP0kxBLNhqzJj03ov
	ofin/3HUYNC0r764L3oWWzLjEjna9XbsitXcDQQuCd/sA6t0pDek24UqNx84roZBS3Q/x4DD4Pth2
	i/Farhpq71L7+4x/U8soGE9mf8zFKuBSzNuluRmuMuEJoROqCUnM4uoKdhgX7lGcxDuW/wA6rONYA
	PnR+Swl73x7fEeCGfNC91FkenF723aTxXVVJIyGlVJ5b6jK1UXT6Iiz+boeApZnGYP78MNuy6qogY
	Rp5SfXCFWMzYR2dezj2uQRklWRGPfkM+BpsEg7dWOODz1leVME8fxyk0hT7cC1nFSh3CDH77FWMcB
	M/uN5g4g==;
Received: from c-24-15-38-32.hsd1.in.comcast.net ([24.15.38.32]:10274 helo=[192.168.1.194])
	by milan.phoronix.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <Michael@MichaelLarabel.com>)
	id 1uAI0e-00000007LE3-2Pmv;
	Wed, 30 Apr 2025 20:42:39 -0400
Message-ID: <cc95ac1d-b4ad-4c15-825d-aea09f605e21@MichaelLarabel.com>
Date: Wed, 30 Apr 2025 19:42:33 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
To: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Patrick Bellasi
 <derkling@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Patrick Bellasi <derkling@matbug.net>, Brendan Jackman
 <jackmanb@google.com>, David Kaplan <David.Kaplan@amd.com>
References: <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local> <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local> <Z7OUZhyPHNtZvwGJ@Asmaa.>
 <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev>
 <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local>
 <aBKzPyqNTwogNLln@google.com>
Content-Language: en-CA
From: Michael Larabel <Michael@MichaelLarabel.com>
In-Reply-To: <aBKzPyqNTwogNLln@google.com>
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


On 4/30/25 6:33 PM, Sean Christopherson wrote:
> On Tue, Apr 29, 2025, Borislav Petkov wrote:
>> On Tue, Feb 18, 2025 at 12:13:33PM +0100, Borislav Petkov wrote:
>>> So,
>>>
>>> in the interest of finally making some progress here I'd like to commit this
>>> below (will test it one more time just in case but it should work :-P). It is
>>> simple and straight-forward and doesn't need an IBPB when the bit gets
>>> cleared.
>>>
>>> A potential future improvement is David's suggestion that there could be a way
>>> for tracking when the first guest gets started, we set the bit then, we make
>>> sure the bit gets set on each logical CPU when the guests migrate across the
>>> machine and when the *last* guest exists, that bit gets cleared again.
>> Well, that "simplicity" was short-lived:
>>
>> https://www.phoronix.com/review/linux-615-amd-regression
> LOL.
>
>> Sean, how about this below?
> Eww.  That's quite painful, and completely disallowing enable_virt_on_load is
> undesirable, e.g. for use cases where the host is (almost) exclusively running
> VMs.
>
> Best idea I have is to throw in the towel on getting fancy, and just maintain a
> dedicated count in SVM.
>
> Alternatively, we could plumb an arch hook into kvm_create_vm() and kvm_destroy_vm()
> that's called when KVM adds/deletes a VM from vm_list, and key off vm_list being
> empty.  But that adds a lot of boilerplate just to avoid a mutex+count.
>
> I haven't tested on a system with X86_FEATURE_SRSO_BP_SPEC_REDUCE, but did verify
> the mechanics by inverting the flag.


Testing this patch on the same EPYC Turin server as my original tests, I 
can confirm that on a clean boot without any VMs running, the 
performance is back to where it was on v6.14. :)

Thanks,

Michael


>
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 30 Apr 2025 15:34:50 -0700
> Subject: [PATCH] KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM count
>   transitions
>
> Set the magic BP_SPEC_REDUCE bit to mitigate SRSO when running VMs if and
> only if KVM has at least one active VM.  Leaving the bit set at all times
> unfortunately degrades performance by a wee bit more than expected.
>
> Use a dedicated mutex and counter instead of hooking virtualization
> enablement, as changing the behavior of kvm.enable_virt_at_load based on
> SRSO_BP_SPEC_REDUCE is painful, and has its own drawbacks, e.g. could
> result in performance issues for flows that are sensity to VM creation
> latency.
>
> Fixes: 8442df2b49ed ("x86/bugs: KVM: Add support for SRSO_MSR_FIX")
> Reported-by: Michael Larabel <Michael@michaellarabel.com>
> Closes: https://www.phoronix.com/review/linux-615-amd-regression
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 39 +++++++++++++++++++++++++++++++++------
>   1 file changed, 33 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d5d0c5c3300b..fe8866572218 100644
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
> @@ -5032,10 +5026,42 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>   	sev_vcpu_deliver_sipi_vector(vcpu, vector);
>   }
>   
> +static DEFINE_MUTEX(srso_lock);
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
> +	guard(mutex)(&srso_lock);
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
> @@ -5061,6 +5087,7 @@ static int svm_vm_init(struct kvm *kvm)
>   			return ret;
>   	}
>   
> +	svm_srso_add_remove_vm(1);
>   	return 0;
>   }
>   
>
> base-commit: f158e1b145f73aae1d3b7e756eb129a15b2b7a90
> --

