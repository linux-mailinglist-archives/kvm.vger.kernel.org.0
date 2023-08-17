Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6887801A9
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356075AbjHQX0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356082AbjHQX03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:26:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A838C3590
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:26:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-565ea69bb0cso557392a12.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692314788; x=1692919588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hDZW3R0H/4ADJBjtvHRU7bYTbbz/6QqtnvUUvhXD+zA=;
        b=D/xagzwHfCdh/y1+efOTTRlxhsklSsR3iezZSF2X+MSDyaUWjeuBXCK7lMc/b74grT
         UES6eoo7pFnzRIBHHl2tpczbdPKPP9jTFfd27COkl6/VVDsu8WiX/KoJY8g/ZflshSh+
         EpqppKQh2aXUMnCwuUroCr2+nqF+1fHU2AdgiFYBEAPM68i745psodwL7LGURGjXat71
         RJjmuWmPD3cu3Ps4qMgU7oOonusIoUJkfXS9AA5yN0Q8iT3pT6OXLf2ewG/yHVdAESTX
         K2aSNYtaSWZEK2UqH5S9oUbZBN6c8e5gXpaRW0cpakU5uisPB4Ia/qWXkqS6Atrf5A5M
         pdtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692314788; x=1692919588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hDZW3R0H/4ADJBjtvHRU7bYTbbz/6QqtnvUUvhXD+zA=;
        b=BYJNFpeuzyHfm+DFyoeojYqndNo4jUYKKKfqAcorx9X/swBtrYQHTal0d2kBjuSm6o
         riAGGPjwuKhgXgoUWUmPwdaUlRMnE6abi8rlmRHsKsgbKAEaB+K4vWsWN/JMe8hSn6YN
         zQzAjuwSD9VUTS7gIwcFSXkmGwsxDkBDREL/7tKYDB7TvZcqxcE+cD1eueh+vnfjphes
         nW7EPoUV3cz3QxOcEMpPwT18WollWZ7lg3NgPS/LZ0j3GtvaQmmFDkHOcTNds/GSmjfJ
         w/FZ/H1jrNr2j9VinLFwhkoUUk5KtdQZT5UVGNyx/IxFAl29a0g9wsFdXkKFb6X/+Ofz
         j10w==
X-Gm-Message-State: AOJu0YywSDcmKwZ1TbDorOFKeyKI8hLGa7flAMv+irc0PSoAj0AhszXs
        +Y3fw1wMwIKUZKxv3k8HE0n4983/u+U=
X-Google-Smtp-Source: AGHT+IHKUufNbs5z0eyLvSQG77gbEgzH5f4Tu6QpCA+O6AuXl9w5Z6w6H0Qh15PEKFN4mSpiqZEiVvdzCAw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6d83:0:b0:565:dc04:c915 with SMTP id
 i125-20020a636d83000000b00565dc04c915mr116028pgc.9.1692314788169; Thu, 17 Aug
 2023 16:26:28 -0700 (PDT)
Date:   Thu, 17 Aug 2023 16:26:26 -0700
In-Reply-To: <20230814115108.45741-10-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230814115108.45741-1-cloudliang@tencent.com> <20230814115108.45741-10-cloudliang@tencent.com>
Message-ID: <ZN6sopXa8aw8DG3w@google.com>
Subject: Re: [PATCH v3 09/11] KVM: selftests: Add x86 feature and properties
 for AMD PMU in processor.h
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
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Add x86 feature and properties for AMD PMU so that tests don't have
> to manually retrieve the correct CPUID leaf+register, and so that the
> resulting code is self-documenting.
> 
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/processor.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 6b146e1c6736..07b980b8bec2 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -167,6 +167,7 @@ struct kvm_x86_cpu_feature {
>   */
>  #define	X86_FEATURE_SVM			KVM_X86_CPU_FEATURE(0x80000001, 0, ECX, 2)
>  #define	X86_FEATURE_NX			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 20)
> +#define	X86_FEATURE_AMD_PMU_EXT_CORE	KVM_X86_CPU_FEATURE(0x80000001, 0, ECX, 23)

I think it makes sense to follow the kernel, even though I find the kernel name
a bit funky in this case.  I.e. X86_FEATURE_PERFCTR_CORE

>  #define	X86_FEATURE_GBPAGES		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 26)
>  #define	X86_FEATURE_RDTSCP		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 27)
>  #define	X86_FEATURE_LM			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
> @@ -182,6 +183,9 @@ struct kvm_x86_cpu_feature {
>  #define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
>  #define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
>  #define X86_FEATURE_SEV_ES		KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 3)
> +#define X86_FEATURE_AMD_PERFMON_V2	KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 0)

X86_FEATURE_PERFMON_V2

> +#define X86_FEATURE_AMD_LBR_STACK	KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 1)

Eh, I'd drop the "AMD".

> +#define X86_FEATURE_AMD_LBR_PMC_FREEZE	KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 2)

Same here.

>  /*
>   * KVM defined paravirt features.
> @@ -267,6 +271,9 @@ struct kvm_x86_cpu_property {
>  #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
>  #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
>  
> +#define X86_PROPERTY_AMD_PMU_NR_CORE_COUNTERS	KVM_X86_CPU_PROPERTY(0x80000022, 0, EBX, 0, 3)
> +#define X86_PROPERTY_AMD_PMU_LBR_STACK_SIZE	KVM_X86_CPU_PROPERTY(0x80000022, 0, EBX, 4, 9)

And here.  I think we can get away with "GP and fixed counters means Intel, core
counters means AMD", at least as far as X86_FEATURES go.  LBRs might be a different
story, but so long as there's no conflict....

Splattering AMD everywhere but not Intel everywhere bugs me :-)

> +
>  #define X86_PROPERTY_MAX_CENTAUR_LEAF		KVM_X86_CPU_PROPERTY(0xC0000000, 0, EAX, 0, 31)
>  
>  /*
> -- 
> 2.39.3
> 
