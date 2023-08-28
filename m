Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940CE78BAF5
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 00:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbjH1WRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 18:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbjH1WQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 18:16:57 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A97C1BF
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 15:16:50 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3fef56f7222so36084595e9.2
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 15:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693261008; x=1693865808;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ytFP9O6tB4A/pEi2JNvwk+BEX0m6ppsIdLn/qA6xonU=;
        b=QZnS9rkd5daxIL2BGO1ZoS4Mn4sA5iXxJD2tOusgIbak4rs+X4thSw5FGS8A4nglSm
         AdHE9vZKzVRDjy+e1woDTsL3gGck7sZeMCbMnUaOILCNdhCYcMzyO8cVEedLmxKdJisV
         K8fi2thO0IAfTJStwoIOyIYKBOr87L8bWbmQ43zJ5tPlhQCnZGK8sHN2Le/0XfF9fcx/
         Xqh3kZ2vtFTsgW7t0K1cVA5o4bcrNHYLaRvdGWTjr2o9glCM3MU8qU1brShYCC79B3xr
         FVQbFJwIfcHq1wFeaVROQyulJ4lZr8R8c8uI48AinFpvnho5hrW9cScvv/Hpdnaixe35
         x1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693261008; x=1693865808;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ytFP9O6tB4A/pEi2JNvwk+BEX0m6ppsIdLn/qA6xonU=;
        b=Si7eI3cCw7PLqtuOdYDENAta4ixK4QK4XozRKZTQXLj+N0b1RkNKbJUgVThoBKlLbr
         Qqt6tVb9ASRaKF2S/tTKrjfAgthLpS2i7IXybo4b5lKG9biBrKZg16ArQ3PdYDSMoeDa
         GsIaKgvLkZGb+7cUcGLGuuSSbXh392esiWNuh06EKSIrZgWAkRpjx4Up9Ohu8WKhftaq
         qlGzMfVUfVgQFbXYLUwne2vugfA/Fb3/7MnptRSjQ4Sokr7HdOJwWoc8Nex1dDTMJx27
         9vKaPJfsjsEx4aCAXBKwM8IsGIzUKD12afcVc3sQbASUACbr0TRKp8dGyDafiQZj+3vl
         K/3Q==
X-Gm-Message-State: AOJu0YxFpqs9+3pfPrciPDgtZ+js4ADZ63XQ+t13sfj21pXxHKNV4CYj
        n78FTPTsDj2hWsqb+SxHWtnAcg==
X-Google-Smtp-Source: AGHT+IGQjeESzT9Pv+KglhVLGQprC12AmiRPu+V0NlK1m4SsbC41PQCF6ev9khMIyUzI4TxrqBxZEQ==
X-Received: by 2002:a1c:7210:0:b0:400:2dc5:1fed with SMTP id n16-20020a1c7210000000b004002dc51fedmr12104210wmc.33.1693261008619;
        Mon, 28 Aug 2023 15:16:48 -0700 (PDT)
Received: from [192.168.69.115] ([176.164.201.64])
        by smtp.gmail.com with ESMTPSA id l5-20020a1ced05000000b003fc01495383sm15177318wmh.6.2023.08.28.15.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Aug 2023 15:16:48 -0700 (PDT)
Message-ID: <9279ccbf-f1db-17c5-a129-4a91a9703cdd@linaro.org>
Date:   Tue, 29 Aug 2023 00:16:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: arm64: Properly return allocated EL2 VA from
 hyp_alloc_private_va_range()
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <20230828153121.4179627-1-maz@kernel.org>
 <e311ac4b-48e6-ea8f-3157-6f78bc5b9ad9@linaro.org>
 <875y4zozo6.wl-maz@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <875y4zozo6.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/8/23 19:16, Marc Zyngier wrote:
> Hi Philippe,
> 
> On Mon, 28 Aug 2023 18:00:54 +0100,
> Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> Hi Marc,
>>
>> On 28/8/23 17:31, Marc Zyngier wrote:
>>> Marek reports that his RPi4 spits out a warning at boot time,
>>> right at the point where the GICv2 virtual CPU interface gets
>>> mapped.
>>>
>>> Upon investigation, it seems that we never return the allocated
>>> VA and use whatever was on the stack at this point. Yes, this
>>> is good stuff, and Marek was pretty lucky that he ended-up with
>>> a VA that intersected with something that was already mapped.
>>>
>>> On my setup, this random value is plausible enough for the mapping
>>> to take place. Who knows what happens...
>>>
>>> Cc: Vincent Donnefort <vdonnefort@google.com>
>>> Fixes: f156a7d13fc3 ("KVM: arm64: Remove size-order align in the nVHE hyp private VA range")
>>
>> I don't see your kvmarm-6.6 merged by Paolo, is it too late to squash
>> and send a new PR?
> 
> In general, I keep the commits that are in -next stable (no squashing,
> no rebasing), and only the merge commits that drag these commits onto
> -next are throw-away (this allows me to rebuild the whole branch
> without changing any of the commit SHAs).
> 
> So no, I won't send a new PR right now. However, I'll stick the patch
> in -next and will aim to send Paolo another PR later this week or
> early next week.

Ah, I didn't know. Thanks for explaining :)

Phil.

