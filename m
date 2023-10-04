Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96957B7822
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 08:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241442AbjJDGsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 02:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjJDGsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 02:48:30 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FF59E
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 23:48:26 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-307d20548adso1624322f8f.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 23:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696402105; x=1697006905; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rJxg0M3WdQV8DRsY/XpYTUYKJ5cnIxzPlIh2CYSgvzE=;
        b=oZAMd86WgjhzxOW0aQQRMlVaDQCjWoBPIOvmj6BR3CInLS39NX3GPhQhNR1eTYyI4S
         b/tTlGyYE1z7x23zL2mIzvJde8z/Qs2rmA8s/LhQn62QOJ4Yi1QbmvQVXSRPFvMc3kut
         N3x2brjleoBSLqDo7UneIyLgjnX7XJsUincjOYPeVb8cQpJdrqguwiNyYmBq2lT12drO
         Qu04GVXXLM9QrwnntSMU+TvYKXg1tsrDqub5D1wGUHTVu0DYcHxc3LawmVezKq4sCg95
         FWNpy+XNP77iygAENq7gqZHRLEqXdl71Q3zPvQYcUQT+sCXhQiNdXewaddBG6GgyFg+j
         IsNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696402105; x=1697006905;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rJxg0M3WdQV8DRsY/XpYTUYKJ5cnIxzPlIh2CYSgvzE=;
        b=r+FjJO0m5ajQSCo4YSG5g8L5chPuTfCTZTgqyaTL7Cs8jAy3pXJTdDYaplVy46Bxli
         9dt0aZWcclSLK620GFQEfgocezNULgtmWZjLiuOxS8rkmuQF1Eny6hh8C5awCWGkV2R/
         JVHEaD1x4GBCYWPfrW6RiloF0vpX+B72QMA4OrCbyDIasNB15mo81q1RTtCkrLrJNV26
         wdCIzGNBAUtMKKCWlvwofprlZfDorMxeTssg3qu28lAPY932cS2kbnuErtZxmyK14CZa
         56SIC2x+SiWBJ1fEKj06xnPfTBjf8tSD0Hxy29dIY34MAz3oMLCUGaaoPaZj9k5MWYEG
         Nz8A==
X-Gm-Message-State: AOJu0YyHO99/fDQneM9Uo7Dx1rxJMVNDIDcEA54wT14uBK7vG1HplFj2
        k7V+Ri2xA8uOUN0FnAsvBIJzItU3f2vpWsOs094=
X-Google-Smtp-Source: AGHT+IFUmt3HWnnTYOHABmKze1NdpfjpgP9hX5YANf/U6PnLFZWFCEBuSoYXEZ5Y7iaRfk7e5Q5YNw==
X-Received: by 2002:a05:6000:10c2:b0:321:68af:947 with SMTP id b2-20020a05600010c200b0032168af0947mr1245444wrx.8.1696402105249;
        Tue, 03 Oct 2023 23:48:25 -0700 (PDT)
Received: from [192.168.69.115] (5ep85-h01-176-173-163-52.dslam.bbox.fr. [176.173.163.52])
        by smtp.gmail.com with ESMTPSA id h14-20020adff18e000000b00323293bd023sm3253682wro.6.2023.10.03.23.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 23:48:24 -0700 (PDT)
Message-ID: <9e054aa1-c06d-7ec4-7ca4-c99b4f64e412@linaro.org>
Date:   Wed, 4 Oct 2023 08:48:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND expression
 and logical NOT
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     nipun.gupta@amd.com, nikhil.agarwal@amd.com,
        ndesaulniers@google.com, trix@redhat.com, shubham.rohila@amd.com,
        kvm@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
 <1fbe8877-aaa5-1b6f-e18c-1d231a31d2e7@linaro.org>
 <20231003152739.GB63187@dev-arch.thelio-3990X>
 <20231003112019.4b067e45.alex.williamson@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20231003112019.4b067e45.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/10/23 19:20, Alex Williamson wrote:
> On Tue, 3 Oct 2023 08:27:39 -0700
> Nathan Chancellor <nathan@kernel.org> wrote:
> 
>> On Tue, Oct 03, 2023 at 09:40:02AM +0200, Philippe Mathieu-Daudé wrote:
>>> Hi Nathan,
>>>
>>> On 2/10/23 19:53, Nathan Chancellor wrote:
>>>> When building with clang, there is a warning (or error with
>>>> CONFIG_WERROR=y) due to a bitwise AND and logical NOT in
>>>> vfio_cdx_bm_ctrl():
>>>>
>>>>     drivers/vfio/cdx/main.c:77:6: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
>>>>        77 |         if (!vdev->flags & BME_SUPPORT)
>>>>           |             ^            ~
>>>>     drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' to evaluate the bitwise operator first
>>>>        77 |         if (!vdev->flags & BME_SUPPORT)
>>>>           |             ^
>>>>           |              (                        )
>>>>     drivers/vfio/cdx/main.c:77:6: note: add parentheses around left hand side expression to silence this warning
>>>>        77 |         if (!vdev->flags & BME_SUPPORT)
>>>>           |             ^
>>>>           |             (           )
>>>>     1 error generated.
>>>>
>>>> Add the parentheses as suggested in the first note, which is clearly
>>>> what was intended here.
>>>>
>>>> Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
>>>> Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature support")
>>>
>>> My current /master points to commit ce36c8b14987 which doesn't include
>>> 8a97ab9b8b31, so maybe this can be squashed / reordered in the VFIO tree
>>> (where I assume this commit is). That said, the fix is correct, so:
>>
>> Yes, this is a -next only issue at the moment and I don't mind this
>> change being squashed into the original if Alex rebases his tree (some
>> maintainers don't).
> 
> Right, where practical we try not to change commit hashes once
> something has been included into linux-next, preferring to layer fixes
> or even reverts, but occasionally something will come up where it makes
> sense to rebase.  This is not such a case :)  Thanks,

Got it, thanks!

> 
> Alex
> 
>>> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>
>> Thanks a lot for taking a look!
>>
>> Cheers,
>> Nathan

