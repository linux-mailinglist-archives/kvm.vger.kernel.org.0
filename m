Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3C265233B
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbiLTO6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLTO6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:58:46 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E641AF
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:58:45 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m19so8931339wms.5
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g9Hg2x5PuNsVa3BqqepfAccdKScNrKApGQjlopoPdvU=;
        b=TzAIeYe/csST69N43Q+zJ+69MV/EBTwQCJiMZmLaS46PieBncYKek2/f1yiYrpT2XZ
         nfuKQCWcbEywRpFoR/D3rJvaoI5tg+gy2IC4BsZ21hQGP65fzJGcCNfssGW5WACBjJ3C
         VYzBI9Z58e4x1G/IIPg+zenHQQfFZ7jGxVervS4GMB8c8E5pvRqDBzTEtOk8DLet80HQ
         5enmGuKVfqzLIwvYkOAvUvy+NgNZoL3BcjsW3m7fp//w1Rm0aHnX74j2QcnoJEnUU/mS
         Jf8ZgM88GitdU3wwwmPVfKLQGYTzmNpcUhkXHLuI8OBh6p194mkNBcU/Qfa5K/FDwktM
         XP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9Hg2x5PuNsVa3BqqepfAccdKScNrKApGQjlopoPdvU=;
        b=nRynMpZZryAKZx0RGq8YdghfAxehgDOLBNlF9doJVBKcgqTaWzNZn6iOz6YWeXYmJ2
         EeVshndSBdyOpirr3/GK+/zq5SHeLHExcKSobk8FjharN7TMnJ3MbhKIheqvWDGLVL0n
         sCviN2rxSiJW1fuv1IkyUthB3qQQVIK+l6DCAu0rlb7sGVojXppfZITnWkjq6L3tADqz
         aXYU0kKiaFYpn4/TYv2fjNZ9KK849PsEjdhCSAKxYndPGTX7Wet7+nS12FRuFIZl4ieH
         dvwMgB3SDdrB7hlgUZesimPrWpa8mU++LtR6/P2TlvUVSEZqPHzmXNI4pEx4i6yqlbcx
         0VUg==
X-Gm-Message-State: ANoB5pnwD3iJzFC50vdQ11j5iWN0ne372CXdPhPGODXpqNmQgRS2JfD4
        k4fprZtKMb33JhOBe9KLv1N8zGAqZwjGGW95Ywc=
X-Google-Smtp-Source: AA0mqf4pCjJ+ursY9y6vmpIaBSQWDo2gY0qrowym+XgacvS1Ga7qMwSnbn95NiuEEuVSOCnUiXg7Bw==
X-Received: by 2002:a05:600c:500a:b0:3d2:3ca2:2d4f with SMTP id n10-20020a05600c500a00b003d23ca22d4fmr18120087wmr.36.1671548323995;
        Tue, 20 Dec 2022 06:58:43 -0800 (PST)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c1d8d00b003d01b84e9b2sm16431279wms.27.2022.12.20.06.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 06:58:43 -0800 (PST)
Message-ID: <a87d9439-5ac3-aa95-4757-994d828df2a1@linaro.org>
Date:   Tue, 20 Dec 2022 15:58:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH 0/3] accel: Silent few -Wmissing-field-initializers
 warning
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20221220143532.24958-1-philmd@linaro.org>
 <Y6HJ21W6Q5h2UvrE@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <Y6HJ21W6Q5h2UvrE@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/12/22 15:42, Daniel P. Berrangé wrote:
> On Tue, Dec 20, 2022 at 03:35:29PM +0100, Philippe Mathieu-Daudé wrote:
>> Silent few -Wmissing-field-initializers warnings enabled by -Wextra.
>>
>> Philippe Mathieu-Daudé (3):
>>    tcg: Silent -Wmissing-field-initializers warning
>>    accel/kvm: Silent -Wmissing-field-initializers warning
>>    softmmu: Silent -Wmissing-field-initializers warning
>>
>>   accel/kvm/kvm-all.c | 4 ++--
>>   softmmu/vl.c        | 2 +-
>>   tcg/tcg-common.c    | 2 +-
>>   3 files changed, 4 insertions(+), 4 deletions(-)
> 
> If we're going to the trouble of fixing violations (which is
> good), then we shouuld also add  -Wmissing-field-initializers
> (or -Wextra) to warn_flags in configure, to prevent regressions
> again in future.

Yes, I plan to add it at the end. I choose to split in small
contained series to avoid spamming every maintainers, but this
is actually that trivial that I could have sent as a big one...

Thanks for the review!
