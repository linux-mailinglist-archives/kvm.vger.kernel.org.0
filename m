Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBB75532B0
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 14:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350951AbiFUM7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 08:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbiFUM66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 08:58:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DCE2A2;
        Tue, 21 Jun 2022 05:58:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id eq6so11915905edb.6;
        Tue, 21 Jun 2022 05:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PN1gz29FFWaPhyNAiNXSx3lrGEyj3A20CvuOZ9ZGnOA=;
        b=aj2GC+C3rG9sFJPCCeRcQmRqTzKpjP+9EaeQeq8htWK6s5WkeSZS2FUhyzpYLS/yWD
         eq4p2mTvR7HbHuvGAJosDtHN4KM5H95ir3ddri2elgdc4k6Gmyv69+ne/Gs4dy6g4edS
         tMs/Kv9F8vSQXmO0lBlaHC5XXUjjY7BW7XYSMDAhMwJ38Fe2ciQX/RKWwcV1O6QFHKpK
         gLKgh08pExpiVikg8tIFKWfE1+0a5YqwldDHjfvzQ/rUl6V4eozPb5yABx0xzKA0bCLu
         w25P6Lwi58PBHCzNvYlRMGf02nHlTOWhkRTUUXSUZ0/rAtb3jZ++5NOJQMxcUP06/jBo
         z25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PN1gz29FFWaPhyNAiNXSx3lrGEyj3A20CvuOZ9ZGnOA=;
        b=PuHdseKo2OAvoTxiOg1nXDHYcWsIoLMzQ+l7mlRNGprTlZvfBJsepx5tAGCyJwrAyE
         hQ0XUBdeuBs+JGCsUEO6/ZQg9QNw5V8jZwB/UNrl7JZ4Eyw+BWr+fa7UdvPc+U8rx6fP
         dOuyWTjOEXKbE2eBvKDV+6zLttFpRvBs1WL5MFQJ1XNCcmJbYcCTQE4a5Vm39D2cNAiO
         YGKpfxBgPvOhsPnX7aYXI6Lt8OA8GcYmGGeRt+YLJZ3d0smLw9KMRXZVnwaBECjtU9TH
         RatAr+ps+KRS3u1R+1btsa8ymMeHO9DIC/gg8tsGVxAhvu9epDJxUywwZmajlLsG/1Bl
         6H+A==
X-Gm-Message-State: AJIora+pVkIkGjx2kJIszJpDmWMw077FrfUCfeqGFJkQQlCeFr5+LhFY
        zGjsdZI0Q/e0h15qpGYnt4hn3bhH5nk=
X-Google-Smtp-Source: AGRyM1uHjiwz+YFBo6alPO/8jYq69f3aXQdVTR6nGy8rAH64GA1wbGkq3sCGafwVxTGmE5k/OeSF5A==
X-Received: by 2002:aa7:c681:0:b0:42f:b180:bb3d with SMTP id n1-20020aa7c681000000b0042fb180bb3dmr34623722edq.191.1655816335265;
        Tue, 21 Jun 2022 05:58:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h12-20020a05640250cc00b004358cec9ce1sm3620502edb.65.2022.06.21.05.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 05:58:54 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <17a2e85a-a1f2-99e1-fc69-1baed2275bd5@redhat.com>
Date:   Tue, 21 Jun 2022 14:58:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 10/39] KVM: x86: hyper-v: Don't use
 sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220613133922.2875594-1-vkuznets@redhat.com>
 <20220613133922.2875594-11-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220613133922.2875594-11-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/13/22 15:38, Vitaly Kuznetsov wrote:
> Get rid of on-stack allocation of vcpu_mask and optimize kvm_hv_send_ipi()
> for a smaller number of vCPUs in the request. When Hyper-V TLB flush
> is in  use, HvSendSyntheticClusterIpi{,Ex} calls are not commonly used to
> send IPIs to a large number of vCPUs (and are rarely used in general).
> 
> Introduce hv_is_vp_in_sparse_set() to directly check if the specified
> VP_ID is present in sparse vCPU set.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/hyperv.c | 37 ++++++++++++++++++++++++++-----------
>   1 file changed, 26 insertions(+), 11 deletions(-)

I'm a bit confused by this patch being in this series.

Just to be clear, PV IPI does *not* support the VP_ID, right?  And since 
patch 12 only affects the sparse banks, the patch does not have any 
other dependency.  Is this correct?

Paolo

> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index f41153c71beb..269a5fcca31b 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1747,6 +1747,25 @@ static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
>   	}
>   }
>   
> +static bool hv_is_vp_in_sparse_set(u32 vp_id, u64 valid_bank_mask, u64 sparse_banks[])
> +{
> +	int bank, sbank = 0;
> +
> +	if (!test_bit(vp_id / HV_VCPUS_PER_SPARSE_BANK,
> +		      (unsigned long *)&valid_bank_mask))
> +		return false;
> +
> +	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
> +			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS) {
> +		if (bank == vp_id / HV_VCPUS_PER_SPARSE_BANK)
> +			break;
> +		sbank++;
> +	}
> +
> +	return test_bit(vp_id % HV_VCPUS_PER_SPARSE_BANK,
> +			(unsigned long *)&sparse_banks[sbank]);
> +}
> +
>   struct kvm_hv_hcall {
>   	u64 param;
>   	u64 ingpa;
> @@ -2029,8 +2048,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>   		((u64)hc->rep_cnt << HV_HYPERCALL_REP_COMP_OFFSET);
>   }
>   
> -static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
> -				 unsigned long *vcpu_bitmap)
> +static void kvm_hv_send_ipi_to_many(struct kvm *kvm, u32 vector,
> +				    u64 *sparse_banks, u64 valid_bank_mask)
>   {
>   	struct kvm_lapic_irq irq = {
>   		.delivery_mode = APIC_DM_FIXED,
> @@ -2040,7 +2059,10 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
>   	unsigned long i;
>   
>   	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
> +		if (sparse_banks &&
> +		    !hv_is_vp_in_sparse_set(kvm_hv_get_vpindex(vcpu),
> +					    valid_bank_mask,
> +					    sparse_banks))
>   			continue;
>   
>   		/* We fail only when APIC is disabled */
> @@ -2053,7 +2075,6 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>   	struct kvm *kvm = vcpu->kvm;
>   	struct hv_send_ipi_ex send_ipi_ex;
>   	struct hv_send_ipi send_ipi;
> -	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
>   	u64 valid_bank_mask;
>   	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>   	u32 vector;
> @@ -2115,13 +2136,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>   	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
>   		return HV_STATUS_INVALID_HYPERCALL_INPUT;
>   
> -	if (all_cpus) {
> -		kvm_send_ipi_to_many(kvm, vector, NULL);
> -	} else {
> -		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
> -
> -		kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
> -	}
> +	kvm_hv_send_ipi_to_many(kvm, vector, all_cpus ? NULL : sparse_banks, valid_bank_mask);
>   
>   ret_success:
>   	return HV_STATUS_SUCCESS;

