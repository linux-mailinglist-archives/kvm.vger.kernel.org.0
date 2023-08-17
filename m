Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB291780112
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 00:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355762AbjHQWdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 18:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355823AbjHQWc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 18:32:58 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920CA3595
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 15:32:57 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26b4e3a83a9so360551a91.2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 15:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692311577; x=1692916377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sNIbxUcGg6J9d8CeGBO43xM/ey2EpW8RS/UNhpycU8A=;
        b=FW1HnFbpodV9SrFAElATLvaAs9XFyYni0AS98MiiHGEQaFp7WB0KSCO0zSONzd+vid
         5OCWIdBKaJ5wcZ6VtBZpi+h4aqQ7XDRAgsmigu3eEno+G6jBQ0LsrpSN9kx8fYV6B/nJ
         yovZ8VVv51WUAxFWr2TJMe80bTCqPduryIAmeo1Sa33jTbZBCdWXFupUNkfrwZpWIoVW
         Kqj5w87DDf4M6gzyf/M8WDURbLzd+xnz+hox8llkgNOzBe0d1ZW/PndWe3DKTOPRI97/
         CFGpWdYxtVOjTv/rRVU967GF67wSf969PcspoUPN/gfExLUOE/9FivU30ZxQ+HopGT6a
         Sn0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692311577; x=1692916377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sNIbxUcGg6J9d8CeGBO43xM/ey2EpW8RS/UNhpycU8A=;
        b=Wq3tsuwfNgRvphHR35PYkgFb7PT6y7TfQdtDmOV0CWit8+TlAt35IXfIk9NZZR+ZTw
         x0pcEoqXpGXGeJjFfNjIVCTyz+O7o8F0pD2pTpQJOgdj7TDHuBjvxeWlC5uCIjzZmHfv
         gn739sy+w6EIfeKVRDm/RmiYPbyYmj79wKqKqO/W3127DKTy2uEXB+qntaKlG73czJtU
         noDJ8BXDQpAqO7F4uJcbWT+2ta08fusuJBApskR1uMOVs0cvdxWdZmwCPHpnbo6H5GoK
         sI8tBrOTAM+D2eRJUeIjZGWCmN8CFYFN1ImkVmD0fjNpa9voZ0wdH1zNxW0pSuD6Tn0p
         AO0A==
X-Gm-Message-State: AOJu0YytFt/CucgNn46T3GgcomuyzslN/6h1LCawieT8++QCqMhpHcUZ
        YbSOUiCANQP1+rolrXhB4DWz419i4dM=
X-Google-Smtp-Source: AGHT+IGFd3sKFSJ6qfipUfOC367sCb3qFOl7V3QXCbDhScnKPAYa4Anbe69GnPq3ZB+428zARdUfvEhH3wE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1f42:b0:26d:1201:a8cb with SMTP id
 y2-20020a17090a1f4200b0026d1201a8cbmr192557pjy.2.1692311577038; Thu, 17 Aug
 2023 15:32:57 -0700 (PDT)
Date:   Thu, 17 Aug 2023 15:32:55 -0700
In-Reply-To: <20230814115108.45741-3-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230814115108.45741-1-cloudliang@tencent.com> <20230814115108.45741-3-cloudliang@tencent.com>
Message-ID: <ZN6gFxl9L36mdblV@google.com>
Subject: Re: [PATCH v3 02/11] KVM: selftests: Add pmu.h for PMU events and
 common masks
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023, Jinrong Liang wrote:
> +static const uint64_t intel_arch_events[] = {

Hmm, rather than have a bunch of static arrays, I think it makes sense to go ahead
and add lib/pmu.c.  Hmm, and this should probably be further namespaced, e.g.
intel_pmu_arch_events

> +	[INTEL_ARCH_CPU_CYCLES]			= ARCH_EVENT(0x3c, 0x0),
> +	[INTEL_ARCH_INSTRUCTIONS_RETIRED]	= ARCH_EVENT(0xc0, 0x0),
> +	[INTEL_ARCH_REFERENCE_CYCLES]		= ARCH_EVENT(0x3c, 0x1),
> +	[INTEL_ARCH_LLC_REFERENCES]		= ARCH_EVENT(0x2e, 0x4f),
> +	[INTEL_ARCH_LLC_MISSES]			= ARCH_EVENT(0x2e, 0x41),
> +	[INTEL_ARCH_BRANCHES_RETIRED]		= ARCH_EVENT(0xc4, 0x0),
> +	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= ARCH_EVENT(0xc5, 0x0),
> +	[PSEUDO_ARCH_REFERENCE_CYCLES]		= ARCH_EVENT(0xa4, 0x1),
> +};
> +
> +/* mapping between fixed pmc index and intel_arch_events array */
> +static const int fixed_pmc_events[] = {

Please be consistent with names (even if KVM itself may be anything but).  KVM
gets away with sloppiness because the arrays are only visible to pmu_intel.c,
but that's not the case here.

intel_pmu_fixed_pmc_events?

> +	[0] = INTEL_ARCH_INSTRUCTIONS_RETIRED,
> +	[1] = INTEL_ARCH_CPU_CYCLES,
> +	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
> +};
> +
> +enum amd_pmu_k7_events {
> +	AMD_ZEN_CORE_CYCLES,
> +	AMD_ZEN_INSTRUCTIONS,
> +	AMD_ZEN_BRANCHES,
> +	AMD_ZEN_BRANCH_MISSES,
> +};
> +
> +static const uint64_t amd_arch_events[] = {

And then amd_pmu_arch_events.

> +	[AMD_ZEN_CORE_CYCLES]			= ARCH_EVENT(0x76, 0x00),
> +	[AMD_ZEN_INSTRUCTIONS]			= ARCH_EVENT(0xc0, 0x00),
> +	[AMD_ZEN_BRANCHES]			= ARCH_EVENT(0xc2, 0x00),
> +	[AMD_ZEN_BRANCH_MISSES]			= ARCH_EVENT(0xc3, 0x00),
> +};
> +
> +static inline bool arch_event_is_supported(struct kvm_vcpu *vcpu,
> +					   uint8_t arch_event)

Same namespace problem.  And I'd put the "is" earlier so that it's clearly a
question and not a command, e.g. "is this arch event supported?" versus "this
arch event is supported".

So pmu_is_arch_event_supported()?  Actually, no, you're reinventing the wheel.
You can query all of the Intel arch events from within the guest via this_pmu_has(),
e.g. see X86_PMU_FEATURE_BRANCH_INSNS_RETIRED.  You just need a helper (or array)
to get from an arbitrary index to its associated feature.

And now that GUEST_ASSERT_EQ() prints values, you can just do

			counter = _rdpmc(i);
			GUEST_ASSERT_EQ(this_pmu_has(...), !!counter);

in guest_measure_loop() instead of funneling the counter into ucall and back to
the host.

> +{
> +	struct kvm_cpuid_entry2 *entry;
> +
> +	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
> +
> +	return !(entry->ebx & BIT_ULL(arch_event)) &&
> +		(kvm_cpuid_property(vcpu->cpuid,
> +		 X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH) > arch_event);
> +}
> +
> +static inline bool fixed_counter_is_supported(struct kvm_vcpu *vcpu,

More namespace problems.  I don't love pmu_is_fixed_counter_supported(), because
that glosses over this operating on the vCPU, e.g. not KVM and not guest CPUID
(from within the guest).

And with a bit of massaging to the "anti-feature" framework, this_pmu_has() and
kvm_pmu_has() can be extended (unless I'm missing something).

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 07b980b8bec2..21f0c45c2ac6 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -287,12 +287,12 @@ struct kvm_x86_cpu_property {
  * architectural event is supported.
  */
 struct kvm_x86_pmu_feature {
-       struct kvm_x86_cpu_feature anti_feature;
+       struct kvm_x86_cpu_feature pmu_feature;
 };
 #define        KVM_X86_PMU_FEATURE(name, __bit)                                        \
 ({                                                                             \
        struct kvm_x86_pmu_feature feature = {                                  \
-               .anti_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),        \
+               .pmu_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit), \
        };                                                                      \
                                                                                \
        feature;                                                                \
@@ -690,10 +690,19 @@ static __always_inline bool this_cpu_has_p(struct kvm_x86_cpu_property property)
 
 static inline bool this_pmu_has(struct kvm_x86_pmu_feature feature)
 {
-       uint32_t nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+       uint32_t nr_bits;
 
-       return nr_bits > feature.anti_feature.bit &&
-              !this_cpu_has(feature.anti_feature);
+       if (feature.pmu_feature.reg == KVM_CPUID_EBX) {
+               nr_bits = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+               return nr_bits > feature.pmu_feature.bit &&
+                      !this_cpu_has(feature.pmu_feature);
+       } else if (feature.pmu_feature.reg == KVM_CPUID_ECX) {
+               nr_bits = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
+               return nr_bits > feature.pmu_feature.bit ||
+                      this_cpu_has(feature.pmu_feature);
+       } else {
+               TEST_FAIL(...);
+       }
 }
 
 static __always_inline uint64_t this_cpu_supported_xcr0(void)


That doesn't give you a direct path to replacing fixed_counter_is_supported(),
but the usage in intel_test_oob_fixed_ctr() is bizarre and looks wrong, e.g. if
it's not supported, the test does nothing.
