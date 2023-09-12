Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF6679D14B
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 14:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbjILMoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 08:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbjILMoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 08:44:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04169F
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 05:44:28 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-99c136ee106so695654266b.1
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 05:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694522667; x=1695127467; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bacZ1tfzNsWsQvHZfCR/sOc1FErmJbppB6WFLqVEIBA=;
        b=HpL96kEqu/t/wreV6/GHIirknpVBg9Dp7uzXslMmaLTc/6OYx7S3OvDcw6ocxRBFtL
         kJSDU5J6JQD16tFmoqjD+/zmJqvlJnUANehCgc42Gh9Z0FHUWBOMADU6sl0wZbbNo+0+
         fcQ82bs9qQivg7eXAx6wvqLbuqUaP/cD82Gyes3DiRfuKkCWc2v2L0q2229D8IgQfdJ3
         5NYlVROtCOZ3iluvwVX8FuvHEbHt0+2Vmypti1Hf3qaKWamvrLADqj383YGAaAXsNez0
         cU4twlwRGdZFTi2AVfCkwe0QjBbk8mLrzht9iWOpm9fmZLCUs6aXhJY8Xgg+zVVT4s7r
         WX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694522667; x=1695127467;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bacZ1tfzNsWsQvHZfCR/sOc1FErmJbppB6WFLqVEIBA=;
        b=MqrAUhmLKGOEL/+VpOUWW5pngZR+BdMcZb6uhd2bJ2CrLzKiafRe85msgaPIVXOEx0
         xw9pjHmT1CqalZp/ylLROxWvV1wbst5NKkM0ZaQT+Gt8Dwvbh1m7NTiEjuVjh5FQvgP1
         nCsIxPU4YTu60L5n33kqIEpkjt1Hcr+IbDE3jECbo7nUHStl6tnoCSwU2+Yd8eivG7gK
         GoZD4QFiKtlJbUUakqTXsp8SxQjtF2IzVEwoEaK2ipJhbw8VhXkhd1DYw0HEi3iWBqOR
         2kjvaIFoGgNhX5EuePYrag8AXtiNwQ5fcjKoy/PuXOTzSTiq2os/hSbjXJrSXhknIiAA
         bwcg==
X-Gm-Message-State: AOJu0Yx89OSvtwIsmUVYFOg3R5v4K7HfB5MmWmE0vkHn3KM2KTtIag8S
        dBCzXSWLoSEZE5Bpjyv6rCdTUQ==
X-Google-Smtp-Source: AGHT+IGzhDiawzKLYqVl6CtibhX95DR55HpftyVT2AEpC+6ebW85/pSFdf7oAPt7n4PrKJOb+cLSvg==
X-Received: by 2002:a17:906:1041:b0:9ad:8d45:6883 with SMTP id j1-20020a170906104100b009ad8d456883mr1001460ejj.76.1694522667033;
        Tue, 12 Sep 2023 05:44:27 -0700 (PDT)
Received: from [192.168.69.115] (cou50-h01-176-172-50-150.dsl.sta.abo.bbox.fr. [176.172.50.150])
        by smtp.gmail.com with ESMTPSA id q26-20020a17090676da00b009ad8338aafasm1058723ejn.13.2023.09.12.05.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 05:44:26 -0700 (PDT)
Message-ID: <df59a661-b05e-f947-7ac9-1f738c6cdf97@linaro.org>
Date:   Tue, 12 Sep 2023 14:44:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 1/4] sysemu/kvm: Restrict kvmppc_get_radix_page_info() to
 ppc targets
Content-Language: en-US
To:     Michael Tokarev <mjt@tls.msk.ru>, qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>
References: <20230912113027.63941-1-philmd@linaro.org>
 <20230912113027.63941-2-philmd@linaro.org>
 <b49e350d-089d-62f7-3e5b-dcc885547912@tls.msk.ru>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <b49e350d-089d-62f7-3e5b-dcc885547912@tls.msk.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/23 14:32, Michael Tokarev wrote:
> 12.09.2023 14:30, Philippe Mathieu-Daudé:
>> kvm_get_radix_page_info() is only defined for ppc targets (in
>> target/ppc/kvm.c). The declaration is not useful in other targets.
>> Rename using the 'kvmppc_' prefix following other declarations
>> from target/ppc/kvm_ppc.h.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   include/sysemu/kvm.h | 1 -
>>   target/ppc/kvm_ppc.h | 2 ++
>>   target/ppc/kvm.c     | 4 ++--
>>   3 files changed, 4 insertions(+), 3 deletions(-)


> I wonder, if it's defined and used in target/ppc/kvm.c only,
> why it needs to be in an .h file to begin with, instead of being static?

Good point, I didn't noticed.
It is this way since it's introduction in commit c64abd1f9c
("spapr: Add ibm,processor-radix-AP-encodings to the device tree").

I'll respin after waiting for more review, thanks!

Phil.
