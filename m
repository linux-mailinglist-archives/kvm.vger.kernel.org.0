Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585746FA359
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 11:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjEHJbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 05:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbjEHJbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 05:31:12 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A68B23483
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 02:31:02 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-50be0d835aaso7848840a12.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 02:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683538261; x=1686130261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xJsMaaib4S4YQf7cwjjwDzkruMi933rtsEbLahJA8Q0=;
        b=Zyo8t9FlL6nkopag+GXloHgl6s/8uIuNvr9YwkNVQB84in1g1ILOGM8eK3ltOxSVfr
         5/jQKuBq0MWGJdVkt1LWFeKmvuKbvR8WdaTDITHtUFrr1zyCvuZNyakYHZSEOvCPWf+Y
         DbpNbvGU+4Y9LCkS0KyEYzUw+i9CJX7VwiIQPmIMr4dAFaK/24I7ooMIizZxu+3O+nz9
         FpLUK6ZW8nxoXALR9MmEPggp8RMK5U9JCo1NqlU4rpzhNoL588kHApi1z4Xi82bZQx7h
         CkKP//RWXbteZxXhshxDACZl/CQlefLKaiHktrcf+zPxjSahSLB2uvsP6rCPXnE+9ggr
         gUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683538261; x=1686130261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xJsMaaib4S4YQf7cwjjwDzkruMi933rtsEbLahJA8Q0=;
        b=fPcyglDh8IJoOERv32NNAJUMxCf6wcboMaBx/aZI4JSP8nbUBicigGs/7ZBZ3O3tYm
         j60PjSM0RqbnJNEc1ROMcmRuyFW5jir5rnL0ixzASlDGfFAcMSjG2nuaB0sKywWGi+tK
         M7Z/3oEGisOdXlgrnk/E7jbcgDk8cDfoSVm52RdpqNTQAs+XQjRK3BO9tmDBkvdv4Jsl
         rahBWbSRSNv2NWzVFCUO4Zyd43o5/iQDi3rYNwEjGXdEtwRb5mpdC1CVZQ5zLwqGIwCh
         M2GCaWrw3TO15Ao/hvHRXl74f4pO5k6n8BsnW3sZgHOQcB8dBVVFAARviEJwjK9KL4Xd
         e4WQ==
X-Gm-Message-State: AC+VfDwGS7BIkix9X9Nux8l3wXMtiom+RA2G3DIDUAZqGmpbjwruOqkB
        UiHNEPYuTcRx6sJsahpVqprPWkZiO+NveD8zKmc=
X-Google-Smtp-Source: ACHHUZ6Et9kLsJpvwHPUWJ8xZuJ70HBhils+Fb+XcTIIrLHLMhBdVy7dPsX4MEHdNLMphOJLQEPMfQ==
X-Received: by 2002:a17:907:3e13:b0:948:b9ea:3302 with SMTP id hp19-20020a1709073e1300b00948b9ea3302mr11144575ejc.1.1683538260844;
        Mon, 08 May 2023 02:31:00 -0700 (PDT)
Received: from ?IPV6:2003:f6:af27:500:653d:9c74:8bdf:2820? (p200300f6af270500653d9c748bdf2820.dip0.t-ipconnect.de. [2003:f6:af27:500:653d:9c74:8bdf:2820])
        by smtp.gmail.com with ESMTPSA id n26-20020a17090673da00b0094eeea5c649sm4842304ejl.114.2023.05.08.02.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 02:31:00 -0700 (PDT)
Message-ID: <b0d4b430-afd2-979c-e7d2-b53e131412ad@grsecurity.net>
Date:   Mon, 8 May 2023 11:30:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 2/6] KVM: x86: Do not unload MMU roots when only
 toggling CR0.WP with TDP enabled
Content-Language: en-US, de-DE
To:     Robert Hoo <robert.hoo.linux@gmail.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-3-minipli@grsecurity.net>
 <e70af22a-f09f-aadb-8353-35b29d2def61@gmail.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <e70af22a-f09f-aadb-8353-35b29d2def61@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.05.23 09:32, Robert Hoo wrote:
> On 3/22/2023 9:37 AM, Mathias Krause wrote:
>> There is no need to unload the MMU roots with TDP enabled when only
>> CR0.WP has changed -- the paging structures are still valid, only the
>> permission bitmap needs to be updated.
>>
>> One heavy user of toggling CR0.WP is grsecurity's KERNEXEC feature to
>> implement kernel W^X.
>>
>> The optimization brings a huge performance gain for this case as the
>> following micro-benchmark running 'ssdd 10 50000' from rt-tests[1] on a
>> grsecurity L1 VM shows (runtime in seconds, lower is better):
>>
>>                         legacy     TDP    shadow
>> kvm-x86/next@d8708b     8.43s    9.45s    70.3s
>>               +patch     5.39s    5.63s    70.2s
>>
>> For legacy MMU this is ~36% faster, for TTP MMU even ~40% faster. 
> 
> TTP --> TDP

Thanks, Sean fixed it up in the final commit:
https://git.kernel.org/linus/01b31714bd90

> 
>>   void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0,
>> unsigned long cr0)
>>   {
>> +    /*
>> +     * CR0.WP is incorporated into the MMU role, but only for
>> non-nested,
>> +     * indirect shadow MMUs.  If TDP is enabled, the MMU's metadata
>> needs
>> +     * to be updated, e.g. so that emulating guest translations does the
>> +     * right thing, but there's no need to unload the root as CR0.WP
>> +     * doesn't affect SPTEs.
>> +     */
>> +    if (tdp_enabled && (cr0 ^ old_cr0) == X86_CR0_WP) {
> 
> Curiously, this patch only affects tdp_enabled, why does legacy MMU also
> see comparable performance gains?

Because 'tdp_enabled' just implies EPT / NPT and only 'tdp_mmu_enabled'
decides which MMU mode to use -- either legacy or TDP MMU (see
kvm_configure_mmu() and now gets invoked from vmx.c / svm.c).

Thanks,
Mathias
