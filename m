Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A663A7D0567
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 01:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346716AbjJSXbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 19:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbjJSXbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 19:31:50 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C93A4
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 16:31:47 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9e0b9b96cso1745575ad.2
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 16:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697758307; x=1698363107; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C7+Elkl44+KhMKOCIVv0dZ9zYCtH1iO9gSzmzJrjL9s=;
        b=Wkam4lj8L0hDAyZfHTC/5VSRjPrwiYhKRnP/5j4gyRzNkkb6RsoQDzXga3Zw0cdHCn
         TBBjKQ0Y5j8gFQO0BICsPn0so+uO+aMkvi8EOvW6+qX4i7vc9ntTQVrS8R45mK4cgMEf
         GNt4J4zC8ftuVXs2I90mM5aTyxMfCJaxZhtYCkvyh8hGf0njz0fIRBP9gCxzWtbZ0ANl
         ePDoMRbD8oTQd4m1XTAz21OVCEXSd6mK9VzMi6pl4p9C4LT/Dx6vLLsOJFJfib8bl+0y
         KqcnMmezYPm74vqqnkbe5opKVa+kzGQnAclHQFvZkySe569IMi8q+cAARf8jNVeHHWK8
         JP2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697758307; x=1698363107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C7+Elkl44+KhMKOCIVv0dZ9zYCtH1iO9gSzmzJrjL9s=;
        b=mVJPRkEzFvgWz97VQgPUcN/h9OVXkbRQYXeqmhXqMcNtx6MzaflGcXbYcbyaxHR3tO
         lOIqbhMNFOHzqqeB1Cv4q72xQNk8Ag5rin9c1+8V8zc49e6laZh1/JKzrwRQKD9sccFU
         6DjqDvpxUI5bPhOiJLaCJvjXo8PFtFfX30+i43DL3NOi0K2lG3dK8g5L1Nb4XfejyqfG
         cxmKnzIgKSsOxUQ4m52ktJU/HkDFefgYZ/ZcfRCHYKCshHik99WVefIms7buDGgSpKhg
         hMF8R0rjtUlo8wmP8mUt5KoK+bf8jgDF2HSGAwfH9X1YaHqkQcm1294UlBSAaOlnneLW
         ZMvA==
X-Gm-Message-State: AOJu0YyIF4G+FzdgluABIqovyggmk28Mam4fdwk05nDBdWIYaOo4Plrh
        F+EPz8PkdNuJu/IHqK+YTpne0Rwr2+g=
X-Google-Smtp-Source: AGHT+IGfiik4T0pp2bAdi7fl/A2Ybf8rd5afRqonRoYRiLzA+F/Cxqz4LErg87j5nc4RDJlYbACsBUVnxq8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:23cc:b0:1ca:4d35:b2f9 with SMTP id
 o12-20020a17090323cc00b001ca4d35b2f9mr6729plh.8.1697758307328; Thu, 19 Oct
 2023 16:31:47 -0700 (PDT)
Date:   Thu, 19 Oct 2023 16:31:45 -0700
In-Reply-To: <20230911114347.85882-3-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com> <20230911114347.85882-3-cloudliang@tencent.com>
Message-ID: <ZTG8YdrL98MEYo-p@google.com>
Subject: Re: [PATCH v4 2/9] KVM: selftests: Extend this_pmu_has() and
 kvm_pmu_has() to check arch events
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> The kvm_x86_pmu_feature struct has been updated to use the more
> descriptive name "pmu_feature" instead of "anti_feature".
> 
> Extend this_pmu_has() and kvm_pmu_has() functions to better support
> checking for Intel architectural events. Rename this_pmu_has() and
> kvm_pmu_has() to this_pmu_has_arch_event() and kvm_pmu_has_arch_event().
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  | 38 ++++++++++++++-----
>  .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
>  2 files changed, 29 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 6b146e1c6736..ede433eb6541 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -280,12 +280,12 @@ struct kvm_x86_cpu_property {
>   * architectural event is supported.
>   */
>  struct kvm_x86_pmu_feature {
> -	struct kvm_x86_cpu_feature anti_feature;
> +	struct kvm_x86_cpu_feature pmu_feature;

Eh, looking at this with fresh eyes, let's just use a single character to keep
the line lengths as short as possible.  There was value in the anti_feature name,
but pmu_feature doesn't add anything IMO.

>  };
>  #define	KVM_X86_PMU_FEATURE(name, __bit)					\
>  ({										\
>  	struct kvm_x86_pmu_feature feature = {					\
> -		.anti_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),	\
> +		.pmu_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),		\

This needs to take in the register (EBX vs. ECX) for this helper to be useful.

>  	};									\
>  										\
>  	feature;								\
> @@ -681,12 +681,21 @@ static __always_inline bool this_cpu_has_p(struct kvm_x86_cpu_property property)
>  	return max_leaf >= property.function;
>  }
>  
> -static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
> +static inline bool this_pmu_has_arch_event(struct kvm_x86_pmu_feature feature)

Why?  I don't see the point.  And it's confusing for fixed counters.  Yeah, fixed
counters count architectural events, but the code is asking if a _counter_ is
supported, not if the associated event is supported.  And the darn name gets too
long, too.

>  {
> -	uint32_t nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
> +	uint32_t nr_bits;
>  
> -	return nr_bits > feature.anti_feature.bit &&
> -	       !this_cpu_has(feature.anti_feature);
> +	if (feature.pmu_feature.reg == KVM_CPUID_EBX) {
> +		nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
> +		return nr_bits > feature.pmu_feature.bit &&
> +			!this_cpu_has(feature.pmu_feature);
> +	} else if (feature.pmu_feature.reg == KVM_CPUID_ECX) {
> +		nr_bits = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
> +		return nr_bits > feature.pmu_feature.bit ||
> +			this_cpu_has(feature.pmu_feature);
> +	} else {
> +		TEST_FAIL("Invalid register in kvm_x86_pmu_feature");

This needs to be a GUEST_ASSERT(), as the primary usage is in the guest.

And again looking at this with fresh eyes, I'd rather do

	uint32_t nr_bits;

	if (feature.f.reg == KVM_CPUID_EBX) {
		nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
		return nr_bits > feature.f.bit && !this_cpu_has(feature.f);
	}

	GUEST_ASSERT(feature.f.reg == KVM_CPUID_ECX);
	nr_bits = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
	return nr_bits > feature.f.bit || this_cpu_has(feature.f);

so that the bogus register is printed out on failure.

> +	}
>  }
>  
>  static __always_inline uint64_t this_cpu_supported_xcr0(void)
> @@ -900,12 +909,21 @@ static __always_inline bool kvm_cpu_has_p(struct kvm_x86_cpu_property property)
>  	return max_leaf >= property.function;
>  }
>  
> -static inline bool kvm_pmu_has(struct kvm_x86_pmu_feature feature)
> +static inline bool kvm_pmu_has_arch_event(struct kvm_x86_pmu_feature feature)
>  {
> -	uint32_t nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
> +	uint32_t nr_bits;
>  
> -	return nr_bits > feature.anti_feature.bit &&
> -	       !kvm_cpu_has(feature.anti_feature);
> +	if (feature.pmu_feature.reg == KVM_CPUID_EBX) {
> +		nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
> +		return nr_bits > feature.pmu_feature.bit &&
> +			!kvm_cpu_has(feature.pmu_feature);
> +	} else if (feature.pmu_feature.reg == KVM_CPUID_ECX) {
> +		nr_bits = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
> +		return nr_bits > feature.pmu_feature.bit ||
> +			kvm_cpu_has(feature.pmu_feature);
> +	} else {
> +		TEST_FAIL("Invalid register in kvm_x86_pmu_feature");

Same thing here.

> +	}
