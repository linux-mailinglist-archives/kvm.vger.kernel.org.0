Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED71643EAD
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbiLFIcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiLFIce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:32:34 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD6E1A3B5;
        Tue,  6 Dec 2022 00:32:28 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id a9so13238156pld.7;
        Tue, 06 Dec 2022 00:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xzDeAn3T9on2rhW/eu6X6jP1Lx7aE5A0px8AsSjmKbY=;
        b=HzG+bpiecMEfO22N7lBkxACnq/O+0V3QU5FuXQr0lwwVxE66GaQaaboH2Wc1EnhwVO
         YgpdxC1GizKaRkV2Z397wVRgNC+/AecDzbPkJw0sJ7gRVwY646PhhUp5JSOIp/lgrePJ
         98FZxjeuxMSeKdRY89V2aAd4hcGpj4x4rv/G7lFZAISZ78J+WzcnZna7XzzvIjXllube
         YVhFEUxQVAstvUjIb6LlJPmEllCozwJCVy/VbXBWNGhLS6ZCNhdkW+m3Jz/HYLFbSIJC
         aDj6188h5Ll3bDIe+X/xzKhgPJ/lvJf0Eg5xO52l/df0P2DGHMsEBnsIMzLQwNwyAPZ8
         AEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xzDeAn3T9on2rhW/eu6X6jP1Lx7aE5A0px8AsSjmKbY=;
        b=h/SqTFBsRP74P3z/opuqYfE2LxuCc8OJCkTyfJPwrmh3rosEnCp/8r9oMpsoA+3U10
         qIjfknZLRtiZsFR1j7jQh544GOQtvtaW2o39nkxK6Gi882J69TnOzWd/YGL9e7R7hVp7
         fesDBQH2xtM2XDnwEybeNSQ+AXL1Qh+uNFp3Ltjc7xbyZuJ30S9RxhdlmQ0bn4Wu4sKP
         c6OH/qO9mIFOZZnAOWPnpg6UvxrrGnWUPOodLBpfqqqeZmWGXp2BPnMIurNIaE4CV3Jy
         qWKvPLg+QYewzT95jSRQfQTkjBE5U4nKIsesGjqLyUaPojDt5/i9kNz9wiLinxKjYTxh
         NkIg==
X-Gm-Message-State: ANoB5pkWzzrvF+dd94Suugx24CBftFb35UXxg8NBi6HVzk8PV6A876se
        r1HNRBlUHSF2wZ+HER90v8Q=
X-Google-Smtp-Source: AA0mqf6DvcCXn3iVDE2s9K85jsCCgN05pBdQr0TGEas3K7Vp9r/QOIYykhZc6m5foIuDj+xVRuGpFg==
X-Received: by 2002:a17:902:b48f:b0:189:8b6:95f6 with SMTP id y15-20020a170902b48f00b0018908b695f6mr69709447plr.71.1670315547707;
        Tue, 06 Dec 2022 00:32:27 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id bv5-20020a17090af18500b00219e38b42f5sm1709904pjb.26.2022.12.06.00.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 00:32:27 -0800 (PST)
Message-ID: <8d49bc2c-796b-f122-225f-bdb4ca815ee6@gmail.com>
Date:   Tue, 6 Dec 2022 16:32:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
In-Reply-To: <20221111102645.82001-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Any comments to move it forward ?

On 11/11/2022 6:26 pm, Like Xu wrote:
> Starting with Zen4, core PMU on AMD platforms such as Genoa and
> Ryzen-7000 will support PerfMonV2, and it is also compatible with
> legacy PERFCTR_CORE behavior and msr addresses.
> 
> If you don't have access to the hardware specification, the commits
> d6d0c7f681fd..7685665c390d for host perf can also bring a quick
> overview. Its main change is the addition of three msr's equivalent
> to Intel V2, namely global_ctrl, global_status, global_status_clear.
> 
> It is worth noting that this feature is very attractive for reducing the
> overhead of PMU virtualization, since multiple msr accesses to multiple
> counters will be replaced by a single access to the global register,
> plus more accuracy gain when multiple guest counters are used.
> 
> All related testcases are passed on a Genoa box.
> Please feel free to run more tests, add more or share comments.
> 
> Previous:
> https://lore.kernel.org/kvm/20220919093453.71737-1-likexu@tencent.com/
> 
> V2 -> V3 Changelog:
> - Renme pmc_is_enabled(); (Jim)
> - Move the reprogram_counters() changes as a separate patch; (Jim)
> - Refactoring to align with other set_msr() helper; (Sean)
> - Fix the issue if userspace wants to expose v1 for whatever reason; (Sean)
> - Add the feature flag X86_FEATURE_AMD_PMU_V2; (Sean)
> - Check enable_pmu for intel 0xa as well; (Sean)
> - Limit AMD pmu's KVM support to version 2 as well;
> - Other nit changes around C code taste; (Sean)
> 
> Like Xu (7):
>    KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
>    KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
>    KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
>    KVM: x86/cpuid: Add X86_FEATURE_AMD_PMU_V2 as a KVM-only leaf entry
>    KVM: x86/svm/pmu: Add AMD PerfMonV2 support
>    KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
>    KVM: x86/cpuid: Use fast return for cpuid "0xa" leaf when !enable_pmu
> 
> Sean Christopherson (1):
>    KVM: VMX: Refactor intel_pmu_set_msr() to align with other set_msr()
>      helpers
> 
>   arch/x86/include/asm/kvm-x86-pmu-ops.h |   1 -
>   arch/x86/include/asm/kvm_host.h        |   1 +
>   arch/x86/kvm/cpuid.c                   |  32 ++++++-
>   arch/x86/kvm/pmu.c                     |  65 +++++++++++++--
>   arch/x86/kvm/pmu.h                     |  28 ++++++-
>   arch/x86/kvm/reverse_cpuid.h           |  10 +++
>   arch/x86/kvm/svm/pmu.c                 |  73 +++++++++++-----
>   arch/x86/kvm/svm/svm.c                 |  11 ++-
>   arch/x86/kvm/vmx/pmu_intel.c           | 111 +++++++------------------
>   arch/x86/kvm/x86.c                     |  14 +++-
>   10 files changed, 228 insertions(+), 118 deletions(-)
> 
