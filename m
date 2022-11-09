Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E1B622A79
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 12:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiKIL2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 06:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiKIL22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 06:28:28 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9A5B63
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 03:28:26 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z5-20020a17090a8b8500b00210a3a2364fso3548180pjn.0
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 03:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oYDyxAVCF96gDSk3CQE7ST0OMA0W0FeY9E6NrbVRts0=;
        b=U17jSpm8rzV893LECS6/8Q9UBh0Ujm6Hh2erqsvFPcSKHoz4kQ29fn1+fwm5mGpIhs
         y1n47plSMOuR1s4IvRRhoy++R2pi61BNgQkeoHQ9Pwwx1p4UF32qzLPy87YLMnjjhkr6
         EXLMo87i56/Ug2BbHxexiJhxydrA6iVBUY7WLRhVvPwTxAS5VRfuSbtZ72u/dImrUpsX
         LJxLBzl8oUOSmwzwSWbBN1+SavW54i1q3+/PUVZoql4wjEon0/q1O6xsB5xUuzVC0U1P
         3GT5JmhVUcJbI7hlg7A1oJ2/Qydypt0fTNmGbAb4D7bGE3YVPd7hrZpoHNNcBfG4jx5Q
         oymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oYDyxAVCF96gDSk3CQE7ST0OMA0W0FeY9E6NrbVRts0=;
        b=09NKfWi4Y32AWPaZ8Bg6u0/85EOccyfM08+pba8hee6jwooD8kn0eEFWzvIkUK0Xm6
         TMy93ilnquOLKQFaDiDNAOo5EIxc5Eg1PQWMfly9exiwg8hc+l5Zv7/obn8PGclQdXD4
         bxfK1ayS/up85M6bZMHxjRxHXBOBgxdJyeH0K3ivFWb6fSdh3zrpv03IG6mmq7D78bqF
         FC3Z43YYEYfoTDphrqzmBhh37RWAtyLwYrgoZDBgqnW4CdEnQIjLnggsa/tCThlDLBkB
         cuj7Y4bXFRUjbZbMjkj5ECcs+WYBpDYO6TdlplImdihcoeZIFxC9Ngjwypu67FOyd+9u
         F6Yg==
X-Gm-Message-State: ACrzQf2i5/dW6wxlOLMz7i3cQ9NnejPFv/PU8U30Rl7f8Op9DVZtux79
        uyb6oM0z/8fwiy5LbTUoTF4=
X-Google-Smtp-Source: AMsMyM6Vd0L3ZEx1uimdDFAIaX2lJ9QrnPKZnfxPP7Grrr+Ikate2pRkVof9yVXwctEEYPCEQY4smw==
X-Received: by 2002:a17:902:c745:b0:186:b287:7d02 with SMTP id q5-20020a170902c74500b00186b2877d02mr61563782plq.87.1667993305639;
        Wed, 09 Nov 2022 03:28:25 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c27-20020aa7953b000000b0053e38ac0ff4sm8114631pfp.115.2022.11.09.03.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 03:28:25 -0800 (PST)
Message-ID: <ed069cc3-bd0b-8d21-50b3-202e6e823ad2@gmail.com>
Date:   Wed, 9 Nov 2022 19:28:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v6 0/7] Introduce and test masked events
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        Sean Christopherson <seanjc@google.com>
References: <20221021205105.1621014-1-aaronlewis@google.com>
 <Y1sAB0LlTPwnWjZp@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y1sAB0LlTPwnWjZp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/2022 6:02 am, Sean Christopherson wrote:
>> Aaron Lewis (7):
>>    kvm: x86/pmu: Correct the mask used in a pmu event filter lookup
>>    kvm: x86/pmu: Remove impossible events from the pmu event filter
>>    kvm: x86/pmu: prepare the pmu event filter for masked events
>>    kvm: x86/pmu: Introduce masked events to the pmu event filter
>>    selftests: kvm/x86: Add flags when creating a pmu event filter
>>    selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
>>    selftests: kvm/x86: Test masked events
> One comment request in the last patch, but it's not the end of the world if it
> doesn't get added right away.
> 
> An extra set of eyeballs from Paolo, Jim, and/or Like would be welcome as I don't
> consider myself trustworthy when it comes to PMU code...
> 
> Reviewed-by: Sean Christopherson<seanjc@google.com>
> 

I'm not going to block these changes just because I don't use the 
pmu-event-filter feature very heavily.
One of my concern is the relatively lower test coverage of pmu-event-filter 
involved code, despite its predictable performance optimizations.

Maybe a rebase version would attract more attention (or at least mine).

Thanks,
Like Xu
