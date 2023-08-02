Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6140676C59A
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 08:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjHBGtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 02:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjHBGt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 02:49:28 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC8230D5
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 23:49:04 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-3159d5e409dso333169f8f.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 23:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690958943; x=1691563743;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HB4LMRnKjLUVIuZ5oaRSbvvqwDvW69WwOvTNkZtzmUw=;
        b=LBX6ZWtPdcIPQjygFVg79ZJiCHojaZBqy6eFaNIcotHmuubg0txtGD0FaWnRJMJPOD
         Jtdxs3D9zi11mTqh7e2wseMVlWdX7clJZRNGaoPF5VA99ajNIKVSfoJj8nSdAUzsMHkB
         5deEdSuxU9MQAuNalFCl7zG71yy2uarC8tTIG4kwZ/0egMYHv7WpvUqB+jQpvtH9EXbL
         F89nBSoaY26z1QC4KijCI7FDuxUfy5lCCgq+bSzCI/F2T7/EqLDfR3OsRzNyaWMfsdxx
         GltV+HaUX7Gns1Oz+KvazEoTPsPMp6dXvtWd12+CuNaRl15eFWAavDtWYg1SuBc2AepU
         QuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690958943; x=1691563743;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HB4LMRnKjLUVIuZ5oaRSbvvqwDvW69WwOvTNkZtzmUw=;
        b=PA4hN+JIOYmOK3L5nB7LNIkbUPporso5dBait7P7LhT50xjNchdKxJdESWD3EqFp0Q
         R8ztnhfzFHphaGj20Xlsfr8aRyv07haNjn7dwdeM1NbxKbRTU2bSETAEbozcwhxsLk7F
         CXG+5N0Eww82o1E7BzuufELiuA4VzVwwW5ZdpqnGJ67aZngIHoPGQVa4mOZ6GARIt53L
         P+cEcNXVJNKP3b2Icqn7sre2D9NvWOy9RwQIheTvAt0csCYuh3DR157vg+jIo3H9BtKV
         QWzLJKJifyqjIr5BukVDfCPi3sdBON7zHy+Pz/QkgGUW2MpJlMsRxlwUXIUa3epBCgAI
         T0kQ==
X-Gm-Message-State: ABy/qLaT7QEM+9QNGZCgr/li1wjdMVITT50MXkEK3ctIWUujGrfzGhNE
        okRvFBvXUvEq82Qotzua4vn5jg==
X-Google-Smtp-Source: APBJJlH2quBX4MR6LyRjY6Lqo6Ha+WR2qvJyYNYfWiKULR1xiBxOrUw8YVmK/Z4enjzY0LreAgSPHg==
X-Received: by 2002:a5d:4986:0:b0:317:417e:a467 with SMTP id r6-20020a5d4986000000b00317417ea467mr4327416wrq.6.1690958942945;
        Tue, 01 Aug 2023 23:49:02 -0700 (PDT)
Received: from [192.168.69.115] (bd137-h02-176-184-46-98.dsl.sta.abo.bbox.fr. [176.184.46.98])
        by smtp.gmail.com with ESMTPSA id l6-20020adfe586000000b0031416362e23sm18173701wrm.3.2023.08.01.23.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 23:49:02 -0700 (PDT)
Message-ID: <7219877c-119d-713f-6302-eabe98df9929@linaro.org>
Date:   Wed, 2 Aug 2023 08:49:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v3 10/12] KVM: x86/mmu: Use BUILD_BUG_ON_INVALID() for
 KVM_MMU_WARN_ON() stub
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20230729004722.1056172-1-seanjc@google.com>
 <20230729004722.1056172-11-seanjc@google.com>
 <8f2c1cf6-ae4d-f5fb-624f-16a1295612d7@linaro.org>
 <ZMmYHQwWMpT8s9Vi@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <ZMmYHQwWMpT8s9Vi@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/23 01:41, Sean Christopherson wrote:
> On Tue, Aug 01, 2023, Philippe Mathieu-Daudé wrote:
>> Hi Sean,
>>
>> On 29/7/23 02:47, Sean Christopherson wrote:
>>> Use BUILD_BUG_ON_INVALID() instead of an empty do-while loop to stub out
>>> KVM_MMU_WARN_ON() when CONFIG_KVM_PROVE_MMU=n, that way _some_ build
>>> issues with the usage of KVM_MMU_WARN_ON() will be dected even if the
>>> kernel is using the stubs, e.g. basic syntax errors will be detected.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu_internal.h | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
>>> index 40e74db6a7d5..f1ef670058e5 100644
>>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>>> @@ -9,7 +9,7 @@
>>>    #ifdef CONFIG_KVM_PROVE_MMU
>>>    #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
>>>    #else
>>> -#define KVM_MMU_WARN_ON(x) do { } while (0)
>>> +#define KVM_MMU_WARN_ON(x) BUILD_BUG_ON_INVALID(x)
>>
>> No need to include <linux/build_bug.h> ?
> 
> It's indirectly included via
> 
>    linux/kvm_host.h => linux/bug.h => linux/build_bug.h
> 
> Depending on the day, I might argue for explicitly including all dependencies, but
> in this case build_bug.h is a "core" header, and IMO there's no value added by
> including it directly.

OK, fine then, thanks!
