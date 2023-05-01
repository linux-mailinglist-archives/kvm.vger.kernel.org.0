Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5547D6F2FEC
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 11:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbjEAJhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 05:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjEAJhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 05:37:07 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5624CDB
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 02:37:06 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2fc3f1d6f8cso1268318f8f.3
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 02:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682933825; x=1685525825;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Ulfu//JSlmd4ioDoRY8oEQyfdEQ+vz2PWQIyipab1c=;
        b=yEBwc2uGTktjSACyb4T4mb8fQDr6Y8u9PE9Zo6OruZw7o5BPBE588xDJYg/IgHVU9e
         qbNUi537t9o1aUHwYpwiPNFtQrNbIuQ0dsbXTiIelszCjpZwrN+tAIXm/qV8UggtPNaN
         FlGV6N5knWTRH5oVtuozbhwOTXmPsqxnwk1z/XarHv3SVKzn0ifhp0Hnm0R/Hbqk9mqX
         /aLE/x0DEpnpjFx5iNO+PirxxQjBr+gQCXi5ymjgHMQwoSi4UaeauBWB+/0ql51e5u5S
         0N+Fmeag56qD7pcYKB1qQtJrf8qturPydybLKMAdSkW1tHcP++/HQkvSr23oGURbwH7o
         bGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682933825; x=1685525825;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ulfu//JSlmd4ioDoRY8oEQyfdEQ+vz2PWQIyipab1c=;
        b=ENvdUz0TMm4OsCiwkjEEb3epSwS1L+k6kYCLMttZpVKWwBrytokYHKflVwG2AzqhPU
         MdBv3SqqTJB4njmlHltJ9aXGRp624n+WDJzlOyVT21dR8Ttt5uNkX85ZvA1Z5hrgl6Kj
         uW744RfxzVBOeabTFnnk2HT0Cb9XgR6fNRDdjRFB84wmyUhxCR5pqSt9ryfLzK748s+o
         jDILcwdPICWI5KTlrzxN6GEk17n/Qo2QBOhlqNU/gA8K/FCBPVdqg173Rkf1qJG/OqhG
         cwP+j45kstrqo20AvfMsjbzredPs9ESLqKTJEn0CQ56UCuhKZ87QlyooxxGx5jCQ0nyo
         Mn0g==
X-Gm-Message-State: AC+VfDy8Z0l1B3HThaYH64KAoaN8HAciaXIu3PvQ7IWZp4rASjSaFF+2
        18nnjHPxKNI7yWYYCz+Z10kc3Q==
X-Google-Smtp-Source: ACHHUZ5GNhz6WQRMF564ntncCOo25bwRq7XMtiVWPJBvDQm2K6Vo17sLKjKEzX3NucIdGZr943ALFg==
X-Received: by 2002:adf:ed12:0:b0:2ce:9d06:58c6 with SMTP id a18-20020adfed12000000b002ce9d0658c6mr9482991wro.53.1682933824721;
        Mon, 01 May 2023 02:37:04 -0700 (PDT)
Received: from [10.175.90.180] ([86.111.162.250])
        by smtp.gmail.com with ESMTPSA id p7-20020a5d48c7000000b00306315583ccsm831073wrs.41.2023.05.01.02.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 02:37:04 -0700 (PDT)
Message-ID: <64915da6-4276-1603-1454-9350a44561d8@linaro.org>
Date:   Mon, 1 May 2023 10:37:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 1/1] arm/kvm: add support for MTE
Content-Language: en-US
To:     quintela@redhat.com, Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>, Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>
References: <20230428095533.21747-1-cohuck@redhat.com>
 <20230428095533.21747-2-cohuck@redhat.com> <87sfcj99rn.fsf@secure.mitica>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <87sfcj99rn.fsf@secure.mitica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/23 18:50, Juan Quintela wrote:
> Pardon my ignorance here, but to try to help with migration.  How is
> this mte tag stored?
> - 1 array of 8bits per page of memory
> - 1 array of 64bits per page of memory
> - whatever
> 
> Lets asume that it is 1 byte per page. For the explanation it don't
> matter, only matters that it is an array of things that are one for each
> page.

Not that it matters, as you say, but for concreteness, 1 4-bit tag per 16 bytes, packed, 
so 128 bytes per 4k page.

> So my suggestion is just to send another array:
> 
> - 1 array of page addresses
> - 1 array of page tags that correspond to the previous one
> - 1 array of pages that correspond to the previous addresses
> 
> You put compatiblity marks here and there checking that you are using
> mte (and the same version) in both sides and you call that a day.

Sounds reasonable.

> Notice that this requires the series (still not upstream but already on
> the list) that move the zero page detection to the multifd thread,
> because I am assuming that zero pages also have tags (yes, it was not a
> very impressive guess).

Correct.  "Proper" zero detection would include checking the tags as well.
Zero tags are what you get from the kernel on a new allocation.

> Now you need to tell me if I should do this for each page, or use some
> kind of scatter-gather function that allows me to receive the mte tags
> from an array of pages.

That is going to depend on if KVM exposes an interface with which to bulk-set tags (STGM, 
"store tag multiple", is only available to kernel mode for some reason), a-la 
arch/arm64/mm/copypage.c (which copies the page data then the page tags separately).

For the moment, KVM believes that memcpy from userspace is sufficient, which means we'll 
want a custom memcpy using STGP to store 16 bytes along with its tag.

> You could pass this information when we are searching for dirty pages,
> but it is going to be complicated doing that (basically we only pass the
> dirty page id, nothing else).

A page can be dirtied by changing nothing but a tag.
So we cannot of course send tags "early", they must come with the data.
I'm not 100% sure I understood your question here.

> Another question, if you are using MTE, all pages have MTE, right?
> Or there are other exceptions?

No such systems are built yet, so we won't know what corner cases the host system will 
have to cope with, but I believe as written so far all pages must have tags when MTE is 
enabled by KVM.


r~
