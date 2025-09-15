Return-Path: <kvm+bounces-57607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C3D0B583EB
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A469B1AA6279
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F20528B407;
	Mon, 15 Sep 2025 17:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Wa71D/gg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037E101F2;
	Mon, 15 Sep 2025 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757958378; cv=none; b=Fv3gV0JF6lbJ7MLmtlPuoG9sqxL0kmwJYfekNDoxRp/EST54X1vibm5/Ba8nHQ3cx6+VlEak92DllidoMloeaayOcMm+Zt067hcl8l4QpCJgzVKiBqA+PvfSDKvp+4Ur3xHWCBld6F76JVnQZA+zUpv8Vq9XVzwzieOvL/tx+yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757958378; c=relaxed/simple;
	bh=3epPdnANQv7fz6EaSn/biBvqoVUJuIEawr3Lj6bTY3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B9iZLWLvCQe+IKWgxsEji8Etty+81P+h72czikTDuUH6M1Xky8+Cz9kT+0UmYqX92lrGQaIe4Fds+WanGEFsFk/TQ/aosQG4akDYxWa+CqSC5IKZOGncHUOqxFQcIHxqkLHkIhnz4J9QGG9mtvGfNWZkT5E5cDCH5cl/gMpwAOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Wa71D/gg; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [0.0.0.0] ([134.134.137.72])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 58FHk45h2831435
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 15 Sep 2025 10:46:05 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 58FHk45h2831435
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757958366;
	bh=u58/nmqUuG+LnbtBgpVgICgzTVmlfywgwQRs9xbltlM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Wa71D/ggOHHYbjiIXLGdwQp6rTJfAUKnG7EwGaLcQRbdLnfdXI4CXARhuqiKD3lZz
	 19PU9BNoJ0r0wqW+vy8AAW7sv4BRGCYtjvs3mLDm5O1ZmqRDo2k2UX6Pf+D+SEeAOa
	 8e9+fiPnYeHgmdoF2VoflpvjKN5C5WBdKZbQCFEIXBqqYd3waLYiteIRKi4bCGFBbn
	 6nSoTGOYdawDzuuFsEpYeYpMoQIh3QQzpJT1QmbQPckk/B7k1vSebGPc9rW2yq96Rx
	 +3fmhGbRvtNY7ziKyjVjkS06/3Vir5L3Are762+kYHBXCjJcS65brMBeEIQBE4ck6N
	 P7E0LtvUhu24w==
Message-ID: <dcab546d-8a9a-42c5-ad7c-3484e505ffba@zytor.com>
Date: Mon, 15 Sep 2025 10:45:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 21/41] KVM: nVMX: Prepare for enabling CET support for
 nested guest
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mathias Krause <minipli@grsecurity.net>,
        John Allen <john.allen@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-22-seanjc@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250912232319.429659-22-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/2025 4:22 PM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
> to enable CET for nested VM.
> 
> vmcs12 and vmcs02 needs to be synced when L2 exits to L1 or when L1 wants
> to resume L2, that way correct CET states can be observed by one another.
> 
> Please note that consistency checks regarding CET state during VM-Entry
> will be added later to prevent this patch from becoming too large.
> Advertising the new CET VM_ENTRY/EXIT control bits are also be deferred
> until after the consistency checks are added.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>


Reviewed-by: Xin Li (Intel) <xin@zytor.com>


> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 14f9822b611d..51d69f368689 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4760,6 +4825,18 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>   	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
>   		vmcs_write64(GUEST_BNDCFGS, 0);
>   
> +	/*
> +	 * Load CET state from host state if VM_EXIT_LOAD_CET_STATE is set.
> +	 * otherwise CET state should be retained across VM-exit, i.e.,
> +	 * guest values should be propagated from vmcs12 to vmcs01.
> +	 */
> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE)
> +		vmcs_write_cet_state(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
> +				     vmcs12->host_ssp_tbl);
> +	else
> +		vmcs_write_cet_state(vcpu, vmcs12->guest_s_cet, vmcs12->guest_ssp,
> +				     vmcs12->guest_ssp_tbl);
> +
>   	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
>   		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
>   		vcpu->arch.pat = vmcs12->host_ia32_pat;

Also tested with VM exit load CET bit set and cleared, both passed, so

Tested-by: Xin Li (Intel) <xin@zytor.com>

