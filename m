Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCB15E5B40
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 08:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiIVGUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 02:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiIVGUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 02:20:48 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFAC13CCD;
        Wed, 21 Sep 2022 23:20:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so1161911pjq.3;
        Wed, 21 Sep 2022 23:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=kgoTZx261wCGXFCEPuaG0VSZSi543M+I3QC3uXhqVog=;
        b=khaI+6u3BZsquYKVqv2eoNoyobNVlDjoVeynFB/MZh7AzwyOyNkrQNsyIyE2jCoiPh
         TwrDlkqg8y6bUZPKK5Ej0MrV68esDNKm+CA7Wku5dljERmnnaUus1GmfRLMyoId5F/k/
         SsZcNw7Gr38CwFyuQHmBBbqIYTqEcXTSAU2WOfUrZD0H9H6tqQIm3I9qy6Gh4vjCVlBP
         nsiOjvpJaHs9TNIhRQDGm7Uq2OIQJ+CXp0WiJkV2hxQW1sfEZ54EuSF/WW5Qa/SFAvGs
         Kvpr2KncXz8vPiPDgLhJpEknM09k7KNVgJk8C1qdFKlzPoaG/9zXa8QZYXKRxWbVdNBp
         yrNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=kgoTZx261wCGXFCEPuaG0VSZSi543M+I3QC3uXhqVog=;
        b=MnVqGbcAs4Ovd0SeWjn/7Hg5w+fBJLFivDC77fTzwp4DozYDsFRTmp1uuEAE7vIx59
         a5eAd6CykpgDMzKS8O6bJSaIGR0hKkGuKNLEVtGVWjDK/QjxLrHdYs/xNS4PWLMbEcPY
         InhsOa8sGEpsLSXTzB9E/f36LGeJHGKiBUvMvXX2LqkURDd3B9tK8JuKIy/YMBvFLYox
         NzHfDk9RSdDvs8WJvAIRWyJ19jCkxAHcu09+7NyywcZhWnxO51IiHUtAx6sHgsb/3lbf
         fowM+edyspNqs3mV7X6PF/WrQONt8F0pGkDW3N6p9Nf5KIqvISqwS2Td0pZzehTrY4uW
         BKdQ==
X-Gm-Message-State: ACrzQf3kvCO0O4UBpkvwuQVluh/Ql8uyOrjh2J0FUNd3LxdaAGDwzmhy
        WL1Zdq5ZaxhSO+C+IR6q73eFuiYo2KaaeA==
X-Google-Smtp-Source: AMsMyM6wLrwdJDW/GSRfYAdHCGnwQFZjNGRn93RC9K993LnD8QJqgjG+ouzBawhDATJDq6SblpW8hw==
X-Received: by 2002:a17:902:d4ce:b0:177:fe49:19eb with SMTP id o14-20020a170902d4ce00b00177fe4919ebmr1731044plg.170.1663827644878;
        Wed, 21 Sep 2022 23:20:44 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14-20020aa79e4e000000b005375a574846sm3379899pfq.125.2022.09.21.23.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 23:20:42 -0700 (PDT)
Message-ID: <6525670b-eb27-d0a5-2d03-cfa2006d0579@gmail.com>
Date:   Thu, 22 Sep 2022 14:20:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 1/3] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs
 handling x86 generic
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220919093453.71737-1-likexu@tencent.com>
 <20220919093453.71737-2-likexu@tencent.com>
 <CALMp9eRPEFHFfW+MnMkcTBFB+vjcEe3ekg8JMrKJaRQuq7=-8Q@mail.gmail.com>
 <856e3332-9f6b-a5f7-c3ec-afe89003cb84@gmail.com>
In-Reply-To: <856e3332-9f6b-a5f7-c3ec-afe89003cb84@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/9/2022 1:47 pm, Like Xu wrote:
>> Why this new request? It's not in the Intel-specific version of these
>> function that you elide below.
>>
>> Perhaps you could split up the semantic changes from the simple renamings?
> 
> The creation of perf_event is delayed to the last step,
> https://lore.kernel.org/kvm/20220831085328.45489-5-likexu@tencent.com/
> 
> Based on the new code base, no semantic changes I assume.

Sorry, I think we do need one more clear commit like this:

---

 From e08b2d03a652e5ec226d8907c7648bff57f31d3b Mon Sep 17 00:00:00 2001
From: Like Xu <likexu@tencent.com>
Date: Thu, 22 Sep 2022 14:15:18 +0800
Subject: [PATCH] KVM: x86/pmu: Rewrite reprogram_counters() to improve
  performance

Before using pmu->reprogram_pmi, the test for a valid pmc is always
applied. This part of the redundancy could be removed by setting the
counters' bitmask directly, and furthermore triggering KVM_REQ_PMU
only once to save more cycles.

Signed-off-by: Like Xu <likexu@tencent.com>
---
  arch/x86/kvm/pmu.h | 12 ++++--------
  1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index fb8040854f4d..9b8e74ccd18a 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -204,15 +204,11 @@ static inline bool pmc_is_enabled_globally(struct kvm_pmc 
*pmc)
  	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
  }

-static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
+static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
  {
-	int bit;
-	struct kvm_pmc *pmc;
-
-	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
-		pmc = intel_pmc_idx_to_pmc(pmu, bit);
-		if (pmc)
-			kvm_pmu_request_counter_reprogam(pmc);
+	if (diff) {
+		pmu->reprogram_pmi |= diff;
+		kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
  	}
  }

-- 
2.37.3

