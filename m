Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11DA6DA96D
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 09:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjDGH21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 03:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDGH2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 03:28:25 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FBD5FC8;
        Fri,  7 Apr 2023 00:28:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j14-20020a17090a7e8e00b002448c0a8813so3231794pjl.0;
        Fri, 07 Apr 2023 00:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680852503; x=1683444503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l2enqQvuEs1jYv2cwpWUDVKN/fRcPw2O9o6eoDaRdt0=;
        b=KhwFxcGG4g7RlR122IkmT1IlsVUesqVNVIODpiIRvDKuOhdDJhN4y7uKAqPb30ghZx
         e5+gjkREGAJfM4FqTRH2udw8h5qzmrEoxvmGSN9kc7Lq0Qxc+CwubJML5K7Ay/VD5gLa
         zMJ3Ky1X8u8M7mx/GWbltUonK5RbMno/GghQERVc5UNlf6zXMF+opx9dFLI0fngfIo1W
         zRjaAljNwuwE6jQY9r1Bz4fpifRpTFeI4/l/Bvs1Alkkgq+fcfwUPnB0RTrqtObJYLCL
         BuAtiuAKdYIkyQ9nILyxVG2jKhtNh8uE7ID6P54bbtTPGKBbNn3wsQMydHO4ZW0Tcy8L
         U1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680852503; x=1683444503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l2enqQvuEs1jYv2cwpWUDVKN/fRcPw2O9o6eoDaRdt0=;
        b=ZCvwaUCF/rEvt2ovvdLazyu8KswVXaV0B7U68zsqrM1Rc+zsMiT1L7zal95enGOSbB
         R2yNJCCGSYvTwqKKsrpO5NKjKnhwBj9lgeyI2hELzWkjzSvOZInc/54mKrNiHpuESrQK
         xivRTynNtB/XxGuP/mWXL6IV9j8TwzWZCUx8wX/mSSWoTz2TXJ3GveTAxjanytZH7CyD
         8UnATH/WJNi2JKyOX4ImkkuyJs0L9mnXGDbqE+iKhj5esVdCw5YkH3tn4ixPRunAcY6Z
         SSvjLRdElSn9SMMj2RpHcAYWPfTOoN/zhzs/FXfmEXktSC+H3LYJiFVPOAGEpi6BD7X5
         uX8w==
X-Gm-Message-State: AAQBX9ev/k/JfZUjUSlBoFk72BSkHYyi+Om0cai3SFi/CCLd/CEWC5ad
        3Cu2QfDcmJMwON24RSYxjIk=
X-Google-Smtp-Source: AKy350aB5h3K3mJFKmvyWVJCPTARcbItlhboNrx5bWEIZN334+N6iEC8aNb0GLNCROQxzCmBkVMZ0A==
X-Received: by 2002:a05:6a20:3b84:b0:db:b960:d319 with SMTP id b4-20020a056a203b8400b000dbb960d319mr2023093pzh.12.1680852502802;
        Fri, 07 Apr 2023 00:28:22 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 25-20020aa79119000000b005ac419804d3sm2380632pfh.186.2023.04.07.00.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 00:28:22 -0700 (PDT)
Message-ID: <9697a5b9-0396-c90e-1fbf-cc14d1af55ca@gmail.com>
Date:   Fri, 7 Apr 2023 15:28:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v4 00/12] KVM: x86: Add AMD Guest PerfMonV2 PMU support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214050757.9623-1-likexu@tencent.com>
 <168083228231.867070.5028004042976729728.b4-ty@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <168083228231.867070.5028004042976729728.b4-ty@google.com>
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

On 7/4/2023 10:02 am, Sean Christopherson wrote:
> On Tue, 14 Feb 2023 13:07:45 +0800, Like Xu wrote:
>> Starting with Zen4, core PMU on AMD platforms such as Genoa and
>> Ryzen-7000 will support PerfMonV2, and it is also compatible with
>> legacy PERFCTR_CORE behavior and msr addresses.
>>
>> If you don't have access to the hardware specification, the commits
>> d6d0c7f681fd..7685665c390d for host perf can also bring a quick
>> overview. Its main change is the addition of three msr's equivalent
>> to Intel V2, namely global_ctrl, global_status, global_status_clear.
>>
>> [...]
> 
> Applied 1-3 to kvm-x86 pmu.  Note, I grabbed my full version of patch 2 that
> also converts the "get" path.
> 
> My apologies for not reviewing this earlier in the cycle.  I need to pivot to
> TDX+SNP stuff "soon", so AMD v2 support will likely miss 6.4, but I'll prioritize
> reviewing and merging support in 6.5.

Thanks for your review time.

Since the biggest points of discussion so far is around
	[PATCH v4 11/12] KVM: x86/svm/pmu: Add AMD PerfMonV2 support,
so once the proposal on that part is confirmed by you, V5 is already in sight.

> 
> Thanks!
> 
> [01/12] KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
>          https://github.com/kvm-x86/linux/commit/cdd2fbf6360e
> [02/12] KVM: VMX: Refactor intel_pmu_{g,}set_msr() to align with other helpers
>          https://github.com/kvm-x86/linux/commit/8bca8c5ce40b
> [03/12] KVM: x86/pmu: Rewrite reprogram_counters() to improve performance
>          https://github.com/kvm-x86/linux/commit/649bccd7fac9
> 
> --
> https://github.com/kvm-x86/linux/tree/next
> https://github.com/kvm-x86/linux/tree/fixes
