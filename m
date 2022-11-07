Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370DE61FBFE
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiKGRwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiKGRwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:52:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D730920F4C
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667843461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nqlw1fQONsG7gh7yoH26sTpozPArsOOnlhbl+ewnTqE=;
        b=fyjZK6ouRFhDJw162Zs+XK0cLq0QuX99zDDC//sp3WqExGkx5XdNe/KaMSgCUJsiOuvJ/C
        IaLPmI6j1rtZ+jUflpU17MNURVdMwSFxE/OUG+CLwxSlQcVsIZHw66RuzqTpUgyLfO+jbf
        GV3L7MVueMStFmXWzUyq4HIS1bKmEgM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-647-eUs5CJ-tOdupF08R0sVX4g-1; Mon, 07 Nov 2022 12:51:00 -0500
X-MC-Unique: eUs5CJ-tOdupF08R0sVX4g-1
Received: by mail-wm1-f72.google.com with SMTP id i82-20020a1c3b55000000b003cf9bd60855so1881396wma.6
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 09:50:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nqlw1fQONsG7gh7yoH26sTpozPArsOOnlhbl+ewnTqE=;
        b=imcqt6Y+1ZlOYv/FXOJHWXxY5xQWWfdySQ4BQSBZlYc9HXNHNEQWs6rASd0cZ4cPy6
         x0BkaiQn81dTDl7FnBjpvhqewfA7FuOtsthmvS7n/ycAV5+dFj+ulCF6/1ehLbrNkOcG
         WhCizRxhi4PDMw4jZW4mr+MLUuY0EUHxkrja+rJiyU64ONFISLPdHRUD4g+v8PY4mSok
         tkN8zqKlKwttakneHnKgdEoAiMDofr04Ur1LqrkoqWHVLhpQsZzCvJ81gaF+lvAqjTfX
         +FdOp2/fe2WbgYZ94k6rQi4uIE8tbJZKoSoXdcsU6gfPJ06wGk3aoVqjvdo+5NaesP62
         jInw==
X-Gm-Message-State: ACrzQf2Vd0dslHX7XOtruhSRNt4iMxtCGYjZ2uO0npturRuro2wVPGQl
        9jwvvJ7ZSDAwJMUDqVfgmYH+oKoF5NL+VQ26B0PjkSWOv/Vl8uDdaEeDpiYZNnZkjrWGUrPAKHQ
        MrI2Qpe+DfKY2
X-Received: by 2002:a05:600c:818:b0:3cf:7385:7609 with SMTP id k24-20020a05600c081800b003cf73857609mr28237734wmp.186.1667843457923;
        Mon, 07 Nov 2022 09:50:57 -0800 (PST)
X-Google-Smtp-Source: AMsMyM64zgq49TR+Lhc7fc9a+HbkT21Vn1CODNNPyt8xn1o1xtg2WMr//W3hqvgbR9RFTg29vv/r6w==
X-Received: by 2002:a05:600c:818:b0:3cf:7385:7609 with SMTP id k24-20020a05600c081800b003cf73857609mr28237717wmp.186.1667843457686;
        Mon, 07 Nov 2022 09:50:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bw14-20020a0560001f8e00b00240dcd4d1cesm3611283wrb.105.2022.11.07.09.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 09:50:57 -0800 (PST)
Message-ID: <90c4b9b0-98ed-7ee9-f123-ed3290e0b591@redhat.com>
Date:   Mon, 7 Nov 2022 18:50:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [kvm-unit-tests PATCH v5 00/27] x86/pmu: Test case optimization,
 fixes and additions
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
References: <20221102225110.3023543-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/22 23:50, Sean Christopherson wrote:
> This series is a big pile of PMU cleanups and enhancements from Like.
> 
> The changes are roughly divided into three parts: (1) fixes (2) cleanups,
> and (3) new test cases.  The changes are bundled in a mega-series as the
> original, separate series was difficult to review/manage due to a number
> of dependencies.
> 
> There are no major changes in the test logic. The big cleanups are to add
> lib/x86/pmu.[c,h] and a global PMU capabilities struct to improve
> readability of the code and to hide some AMD vs. Intel details.
> 
> Like's v4 was tested on AMD Zen3/4 and Intel ICX/SPR machines, but this
> version has only been tested on AMD Zen3 (Milan) and Intel ICX and HSW,
> i.e. I haven't tested AMD PMU v2 or anything new in SPR (if there is
> anything in SPR?).
> 
> Like Xu (22):
>    x86/pmu: Add PDCM check before accessing PERF_CAP register
>    x86/pmu: Test emulation instructions on full-width counters
>    x86/pmu: Pop up FW prefix to avoid out-of-context propagation
>    x86/pmu: Report SKIP when testing Intel LBR on AMD platforms
>    x86/pmu: Fix printed messages for emulated instruction test
>    x86/pmu: Introduce __start_event() to drop all of the manual zeroing
>    x86/pmu: Introduce multiple_{one, many}() to improve readability
>    x86/pmu: Reset the expected count of the fixed counter 0 when i386
>    x86: create pmu group for quick pmu-scope testing
>    x86/pmu: Refine info to clarify the current support
>    x86/pmu: Update rdpmc testcase to cover #GP path
>    x86/pmu: Rename PC_VECTOR to PMI_VECTOR for better readability
>    x86/pmu: Add lib/x86/pmu.[c.h] and move common code to header files
>    x86/pmu: Snapshot PMU perf_capabilities during BSP initialization
>    x86/pmu: Track GP counter and event select base MSRs in pmu_caps
>    x86/pmu: Add helper to get fixed counter MSR index
>    x86/pmu: Track global status/control/clear MSRs in pmu_caps
>    x86: Add tests for Guest Processor Event Based Sampling (PEBS)
>    x86/pmu: Add global helpers to cover Intel Arch PMU Version 1
>    x86/pmu: Add gp_events pointer to route different event tables
>    x86/pmu: Update testcases to cover AMD PMU
>    x86/pmu: Add AMD Guest PerfMonV2 testcases
> 
> Sean Christopherson (5):
>    x86: Add a helper for the BSP's final init sequence common to all
>      flavors
>    x86/pmu: Snapshot CPUID.0xA PMU capabilities during BSP initialization
>    x86/pmu: Drop wrappers that just passthrough pmu_caps fields
>    x86/pmu: Reset GP and Fixed counters during pmu_init().
>    x86/pmu: Add pmu_caps flag to track if CPU is Intel (versus AMD)
> 
>   lib/x86/asm/setup.h |   1 +
>   lib/x86/msr.h       |  30 +++
>   lib/x86/pmu.c       |  67 +++++++
>   lib/x86/pmu.h       | 187 +++++++++++++++++++
>   lib/x86/processor.h |  80 ++------
>   lib/x86/setup.c     |  13 +-
>   x86/Makefile.common |   1 +
>   x86/Makefile.x86_64 |   1 +
>   x86/cstart.S        |   4 +-
>   x86/cstart64.S      |   4 +-
>   x86/pmu.c           | 360 ++++++++++++++++++++----------------
>   x86/pmu_lbr.c       |  24 +--
>   x86/pmu_pebs.c      | 433 ++++++++++++++++++++++++++++++++++++++++++++
>   x86/unittests.cfg   |  10 +
>   x86/vmx_tests.c     |   1 +
>   15 files changed, 975 insertions(+), 241 deletions(-)
>   create mode 100644 lib/x86/pmu.c
>   create mode 100644 lib/x86/pmu.h
>   create mode 100644 x86/pmu_pebs.c

Applied, thanks.

Paolo

