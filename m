Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0AF6DAA9C
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 11:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjDGJHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 05:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240136AbjDGJHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 05:07:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A349039
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 02:07:07 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 60-20020a17090a09c200b0023fcc8ce113so848977pjo.4
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 02:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680858427; x=1683450427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fuU1GOhfFqEu9fr2GUTYU92iqTBEkWnn/6trmftCB3U=;
        b=c5331ZYhlAf9NHeQRvbgLNwiED4MEO0yjSDuDDRJm1slKE53JxZZNhhqtFN1NcSpyO
         0R6VgAQmGAdux5an4zR62DCyJoYb1nPtmeXQ++Ai5YmNwQmPmSQYE7nqlU6G7ksPr0zx
         L6qAnn0VrwGM2jkW/I64ccJM0i1bJFD1tWBIX+YgMVV4ejz6bzHRSb9hhpT0CaLH2z1r
         d9Xs3I+IJ28oKH3D7BaVc6sKND14b96STdwDyFI4uVgVdRGzr/H8HxDat5k3qtUf8Evm
         +evFU78U6vGi3aZb+74rNGFJf1LIHOrtoIvEwWfY5+M8lqzpRZ69xkJQngwjgo2KVOgw
         oe9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680858427; x=1683450427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fuU1GOhfFqEu9fr2GUTYU92iqTBEkWnn/6trmftCB3U=;
        b=xb5uSD9DPkqKVCUhCWLotwLYd2zRCPGIDfzRsYZPEQMVK93z+IJwWZH5cUcsDIRpfx
         9NqiQ9PH3Rh2EDcuzpITXAIJVGEVGMs0l3oAUD8NtvDe4ua/S26gC8lHUE5lXK3HQH2p
         48yT4P2q0dXKyYHvBOnOYQ0O6Wa5RnjYhTBB/dDZoyhRKXymXpMzhFArjfnwDwHAY9Rc
         +spcpJ3RgM+8uQyqmMdA1LPoca/If+LoNcABPhZgp3qxEhCcEIJsswNSDm8bwiNMWH27
         u+mwPmBLGN/nACA56TUFcyarkPOmXgL6OL9dR2zd0E9EboJEkd8grZuGopROlcM76M31
         +5oA==
X-Gm-Message-State: AAQBX9d3+QZ2CI5ED8N3YxQwymRlTj+z3LMpeCJ/OaaWkIHePuE5FnvS
        SIolRM9txvuSmvSlD1hUmcE=
X-Google-Smtp-Source: AKy350Z4BiCgDj9xxE4kQycnG29Q23k3G5Y+x5MCltKyRz51o7RwRLnGdFuWHZYOsWOzjohPharrUw==
X-Received: by 2002:a17:903:41cd:b0:19a:9833:6f8 with SMTP id u13-20020a17090341cd00b0019a983306f8mr2547086ple.35.1680858427071;
        Fri, 07 Apr 2023 02:07:07 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q9-20020a635049000000b0050336b0b08csm2275370pgl.19.2023.04.07.02.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 02:07:06 -0700 (PDT)
Message-ID: <fa000dc8-22e6-bafe-01c8-a18242fd1055@gmail.com>
Date:   Fri, 7 Apr 2023 17:06:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v3 0/5] Fix "Instructions Retired" from incorrectly
 counting
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <20230307141400.1486314-1-aaronlewis@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230307141400.1486314-1-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean, would you pick this series up ?

On 7/3/2023 10:13 pm, Aaron Lewis wrote:
> This series fixes an issue with the PMU event "Instructions Retired"
> (0xc0), then tests the fix to verify it works.  Running the test
> updates without the fix will result in a failed test.
> 
> v2 -> v3:
>   - s/pmc_is_allowed/event_is_allowed/ [Like]
> 
> v1 -> v2:
>   - Add pmc_is_allowed() as common helper [Sean]
>   - Split test into multiple commits [Sean]
>   - Add macros for counting and not counting [Sean]
>   - Removed un-needed pr_info [Sean]
> 
> 
> Aaron Lewis (5):
>    KVM: x86/pmu: Prevent the PMU from counting disallowed events
>    KVM: selftests: Add a common helper to the guest
>    KVM: selftests: Add helpers for PMC asserts
>    KVM: selftests: Fixup test asserts
>    KVM: selftests: Test the PMU event "Instructions retired"
> 
>   arch/x86/kvm/pmu.c                            |  13 +-
>   .../kvm/x86_64/pmu_event_filter_test.c        | 146 ++++++++++++------
>   2 files changed, 108 insertions(+), 51 deletions(-)
> 
