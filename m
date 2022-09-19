Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E13B5BC4D5
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 10:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiISI6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 04:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiISI6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 04:58:38 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDF410FFA;
        Mon, 19 Sep 2022 01:58:37 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 78so26134070pgb.13;
        Mon, 19 Sep 2022 01:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=fuEwROaEw4Wa/2VVF6v2tFbai0+IqYEOCWSQjYQQS5I=;
        b=mFA1STGhJXXTpHGktWvSsLGX4bvLplsDsJFp89QmBuFJ6WePnIUtpe1DUBjnDHHYqt
         RqLzG6hQssRUv4yd3hkPB2gv5GXEt1HRoO9vo/ThA5ZvbFrDz1iMJtr97vF8o5khSLeQ
         65AchASEQJZRhfkAc0hAePdI15xYXbES9df1kYRpWLIcd+edNmXfdoG0iy8uuJMXw48P
         RTLG9zYsAJCdHOeBWW7lMAcaw4v+9kNK7wT/s3WTQNALr9axuuVMh7pp5qCG+HLxjZVL
         G/Tm3b0IOVvAT3TF+pgFP7JH+DL3rLTn5LB+/MILW07oDSfcwtirtFXkmoPZauXwGkL9
         qU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=fuEwROaEw4Wa/2VVF6v2tFbai0+IqYEOCWSQjYQQS5I=;
        b=0gbcdprqP4wtws2Evfe3zmgUg4HKhTvAnKbRgM8a98tdgJD6gbM/O9ftzv4BywXjut
         TYdVCFjQ1mbmaomIM2Egpf5eBwj7Z/9umnyl1ri3wmg8tWuaNKVP8BGdMRmHfpuCoLKA
         SG5rvV7sARQ5xXzqeQFQ4ORwgtlzHFwaGHwWwXcrcius4OWWzlWn7OaQUyWcyTyzAP5Z
         8Cs4MVB47eoSQq0yaBvp/va8AfdxP548Kef2RRWTQW6mPPlM7H73Si4Wp3ywxVLLNfIU
         pvYbat+B/oVFE0ErNWLV12YGN/q+zesXYnO+kgfOxxtSgxPbPwydWnqaCCF8iX1UwLYD
         6EhQ==
X-Gm-Message-State: ACrzQf3EgX2X2/Ae7c27hgDfsOBhNY1BCjoFHoyzBEkZmav8lC9uuh4N
        qvrWiiMKOBmM7+L0kTP9W3s=
X-Google-Smtp-Source: AMsMyM7NQ4hhRdGEETRw8mEgESetlpdE7m6yP0PNoPVQ6qhJ0gyGKolmYaDIDw/TsHBbPOL6MZ8ITg==
X-Received: by 2002:a05:6a00:228c:b0:542:e65c:98 with SMTP id f12-20020a056a00228c00b00542e65c0098mr17017068pfe.79.1663577917255;
        Mon, 19 Sep 2022 01:58:37 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u1-20020a17090341c100b00176ba091cd3sm16574278ple.196.2022.09.19.01.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 01:58:36 -0700 (PDT)
Message-ID: <7b870e3a-e19a-0b05-68f7-db9eb852f061@gmail.com>
Date:   Mon, 19 Sep 2022 16:58:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v3 0/7] x86/pmu: Corner cases fixes and optimization
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <20220831085328.45489-1-likexu@tencent.com>
 <4a74d218-6266-cf6c-3ebb-4cbb49327440@gmail.com>
In-Reply-To: <4a74d218-6266-cf6c-3ebb-4cbb49327440@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ Jim for more comments if any.

On 7/9/2022 5:52 pm, Like Xu wrote:
> A review reminder for shepherds. Thanks!
> 
> On 31/8/2022 4:53 pm, Like Xu wrote:
>> Good well-designed tests can help us find more bugs, especially when
>> the test steps differ from the Linux kernel behaviour in terms of the
>> timing of access to virtualized hw resources.
>>
>> Please feel free to run tests, add more or share comments.
>>
>> Previous:
>> https://lore.kernel.org/kvm/20220823093221.38075-1-likexu@tencent.com/
>>
>> V2 RESEND -> V3 Changelog:
>> - Post perf change as a separate patch to the perf folks; (Sean)
>> - Rewrite the deferred logic using imperative mood; (Sean)
>> - Drop some useless comment; (Sean)
>> - Rename __reprogram_counter() to kvm_pmu_request_counter_reprogam(); (Sean)
>> - Replace a play-by-play of the code changes with a high level description; 
>> (); (Sean)
>> - Rename pmc->stale_counter to pmc->prev_counter; (Sean)
>> - Drop an unnecessary check about pmc->prev_counter; (Sean)
>> - Simply the code about "CTLn is even, CTRn is odd"; (Sean)
>> - Refine commit message to avoid pronouns; (Sean)
>>
>> Like Xu (7):
>>    KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
>>    KVM: x86/pmu: Don't generate PEBS records for emulated instructions
>>    KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
>>    KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
>>    KVM: x86/pmu: Defer counter emulated overflow via pmc->prev_counter
>>    KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement
>>      amd_*_to_pmc()
>>    KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters
>>      scalability
>>
>>   arch/x86/include/asm/kvm_host.h |   6 +-
>>   arch/x86/kvm/pmu.c              |  44 +++++++-----
>>   arch/x86/kvm/pmu.h              |   6 +-
>>   arch/x86/kvm/svm/pmu.c          | 121 ++++++--------------------------
>>   arch/x86/kvm/vmx/pmu_intel.c    |  36 +++++-----
>>   5 files changed, 75 insertions(+), 138 deletions(-)
>>
