Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57143543A41
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiFHRYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiFHRYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:24:25 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0251320F7B
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 10:18:24 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id n28so28008132edb.9
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 10:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EmmOifA39ddfj3f9gDa9mInclaPvipW5hKFXKyzUZCQ=;
        b=g7DDl8mJV7RxN1ferZZXa6aRiQPAiyCsmDH3rHp1Qpe2TqkYfOhI9TDw05QuVHUhQ4
         r17vee5rxn3gJiQpPhnEITaSoFkYLwIPtrWtglU3jvabOPJUmTPwuQAo9CB7ycT+9cwD
         Ccz0HxeHcCFKaZrm0KPJYQNbHd3KhRWtyfylsnLRzKssgo8yP3iJd9hGLR4P8U/FgC5P
         p8urNjlo1aAfvYr0DegmN2lbL7Z/DhlMkN45GMzgVzHB5TWL0EBL461Vdmj6ZlR1lb5B
         C4VQvg7wg44pQkHHW9fAjSpFIm3LuA5mPv4lHTUF5koRTFjiZEShYML30BNVXUf0c7/V
         O5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EmmOifA39ddfj3f9gDa9mInclaPvipW5hKFXKyzUZCQ=;
        b=5lijvKkkeViIndWLQE1/P7+4WSFQj0Mu2ZvRSEx5y6k0zG5+d00xjY+tmV04KZAIiy
         5UTuz2NT6cza/rk+A+tiIk66HsJhvq+gZZ9khKsk/hVRl4xIGKMn3UvjkrBfYi0Y6lRJ
         0bni525LjdOXDrkwGIdzillCRkbcQgjxsoB/7yL8sVEN2ZY4wlBAshwfzBSHP7ACR0kn
         BS9rxTw3nSNYZXIpOKhvcEpLvWyqmPH6gwm7ZiZ3KZ7ao2fnmgFz9uK8GJejQ4npdFp+
         084OUa12l0s5ATUy44Z/jrKLrFsfYZWAir3eg13unA9jCCdMeNrp77KpBRzKue/0O/mK
         p5zg==
X-Gm-Message-State: AOAM531UMRz6Zdeh5knq+OBnHF7LKVq3HOt1sCptp1igBYKKLhN0AAgf
        6nGRZCihGavak48b8ANWJW8=
X-Google-Smtp-Source: ABdhPJynAx+4zQbfMzEu0vj3W0Uo+hvSl5Cria4THrFUa9gealLjE++7uUK7o/gf0QoJc+5uymIFlg==
X-Received: by 2002:aa7:d8d8:0:b0:42d:dbb0:f05b with SMTP id k24-20020aa7d8d8000000b0042ddbb0f05bmr40399440eds.82.1654708702514;
        Wed, 08 Jun 2022 10:18:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l24-20020a17090612d800b006feb6438264sm9495555ejb.93.2022.06.08.10.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 10:18:21 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <12e3c408-6848-ad75-12ee-6110a3ba13c4@redhat.com>
Date:   Wed, 8 Jun 2022 19:18:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 00/11] KVM: selftests: Add nested support to
 dirty_log_perf_test
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
References: <20220520233249.3776001-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/22 01:32, David Matlack wrote:
> This series adds support for taking any perf_test_util-based test and
> configuring it to run vCPUs in L2 instead of L1, and adds an option to
> dirty_log_perf_test to enable it.
> 
> This series was used to collect the performance data for eager page
> spliting for nested MMUs [1].
> 
> [1] https://lore.kernel.org/kvm/20220422210546.458943-1-dmatlack@google.com/
> 
> v4:
>   - Add patch 11 to support for hosts with MAXPHYADDR > 48 [Sean]
> 
> v3: https://lore.kernel.org/kvm/20220520215723.3270205-1-dmatlack@google.com/
>   - Only identity map a subset of the nGPA space [Sean, Peter]
>   - Fail if nested_paddr contains more than 48 bits [me]
>   - Move patch to delete all rule earlier [Peter]
> 
> v2: https://lore.kernel.org/kvm/20220517190524.2202762-1-dmatlack@google.com/
>   - Collect R-b tags from Peter.
>   - Use level macros instead of raw numbers [Peter]
>   - Remove "upper" from function name [Peter]
>   - Bring back setting the A/D bits on EPT PTEs [Peter]
>   - Drop "all" rule from Makefile [Peter]
>   - Reserve memory for EPT pages [Peter]
>   - Fix off-by-one error in nested_map_all_1g() [me]
> 
> v1: https://lore.kernel.org/kvm/20220429183935.1094599-1-dmatlack@google.com/
> 
> 
> David Matlack (11):
>    KVM: selftests: Replace x86_page_size with PG_LEVEL_XX
>    KVM: selftests: Add option to create 2M and 1G EPT mappings
>    KVM: selftests: Drop stale function parameter comment for nested_map()
>    KVM: selftests: Refactor nested_map() to specify target level
>    KVM: selftests: Move VMX_EPT_VPID_CAP_AD_BITS to vmx.h
>    KVM: selftests: Add a helper to check EPT/VPID capabilities
>    KVM: selftests: Drop unnecessary rule for STATIC_LIBS
>    KVM: selftests: Link selftests directly with lib object files
>    KVM: selftests: Clean up LIBKVM files in Makefile
>    KVM: selftests: Add option to run dirty_log_perf_test vCPUs in L2
>    KVM: selftests: Restrict test region to 48-bit physical addresses when
>      using nested
> 
>   tools/testing/selftests/kvm/Makefile          |  49 ++++--
>   .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
>   .../selftests/kvm/include/perf_test_util.h    |   9 ++
>   .../selftests/kvm/include/x86_64/processor.h  |  25 +--
>   .../selftests/kvm/include/x86_64/vmx.h        |   6 +
>   .../selftests/kvm/lib/perf_test_util.c        |  53 ++++++-
>   .../selftests/kvm/lib/x86_64/perf_test_util.c | 112 +++++++++++++
>   .../selftests/kvm/lib/x86_64/processor.c      |  33 ++--
>   tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 149 +++++++++++-------
>   .../selftests/kvm/max_guest_memory_test.c     |   2 +-
>   .../selftests/kvm/x86_64/mmu_role_test.c      |   2 +-
>   11 files changed, 343 insertions(+), 107 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c
> 
> 
> base-commit: a3808d88461270c71d3fece5e51cc486ecdac7d0

Queued, thanks!  (It will be in either -rc2 or -rc3).

Paolo
