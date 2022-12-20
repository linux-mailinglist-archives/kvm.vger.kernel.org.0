Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81740651F29
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 11:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiLTKpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 05:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiLTKpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 05:45:05 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4CF178AF
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 02:45:04 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id r130so10229289oih.2
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 02:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XlLK/9t77OaCz0UGM/J8urYM3bBBnlqtd9YmBawRQfs=;
        b=VZQVqUyfm+SzD4hUok+TQ3m/aULWBHMuCvEbySofZ7AlqnMdTsBLZaI07suorsSjtv
         fe/mnNdO+x5Nyh4McN2S1iP8uLWiehdanPgWngG0vsp7HAFmT+liWyQAyUAGnOfb/saC
         91ynBTrXxHn0zpiO5IoFBLtQGf9Xj7Eq+aVdBBlcPSEApaBll4n1O4cHv/D/CjgO3b69
         EyPb+x4jFkJynEhVkvQVyl1Ne75ux7sCCj6gflUlEIHDXp20EiV4vosXzP32utRaBg+u
         GlumX4I9cssgCKSVY0F31fNZbRNniYm44IhQ/bojX60FD7i3IRMxVhPxOyac884xBk1h
         4cDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XlLK/9t77OaCz0UGM/J8urYM3bBBnlqtd9YmBawRQfs=;
        b=AsEIOw1tE+FYn1FxVRodztwHSt226knNIkxK3wEx4/lWw/bQ0jNtEX6O695KswVXMl
         CA5SNONW7J7vvrR/786gyF6VbOSig4N6BJCs1LlTPHzHHDlRNOtx19GNoVyp+rYRTXpA
         jUSp15rneIOJZEUXbiz9bKDqr0IvKd+20DbaiBDsexu75BNiVF7xOry5aVqopPMMYYoR
         FlzZDf0aWv789GLWyDCa8Og/2gDbKGzsinzYm0lW/tQmeAQ8LIsm2/sYAxanvVR9j9ci
         CC6rz4xCw+jX3kozxHydFNDl7E5xD58auBuHwraM2EglocrBhsDP9oT0s9+2W77s47i6
         3zUw==
X-Gm-Message-State: ANoB5pmFbZpTp2h1bUPuoqywXm8W7zpYJIOuxbCpNs9Krf1J6ifCY55W
        nfTm29Lu5f2/6OlHW9D+QFY=
X-Google-Smtp-Source: AA0mqf5IhyhoFAFTIOpBSp8ETqrVHUgTAA+/7jM945BelQAHiivdjpQPQFharevJcEcrmsphwDZy5A==
X-Received: by 2002:a05:6808:30b:b0:35e:57ef:51f8 with SMTP id i11-20020a056808030b00b0035e57ef51f8mr17517142oie.52.1671533103732;
        Tue, 20 Dec 2022 02:45:03 -0800 (PST)
Received: from [192.168.68.106] (201-43-103-101.dsl.telesp.net.br. [201.43.103.101])
        by smtp.gmail.com with ESMTPSA id j2-20020a056808034200b0035e461d9b1bsm5291043oie.50.2022.12.20.02.44.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 02:45:03 -0800 (PST)
Message-ID: <5d727e59-fa21-ea08-112c-3b74db7e4577@gmail.com>
Date:   Tue, 20 Dec 2022 07:44:54 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 1/5] dump: Include missing "cpu.h" header for
 tswap32/tswap64() declarations
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Greg Kurz <groug@kaod.org>, qemu-ppc@nongnu.org,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marek Vasut <marex@denx.de>, Bin Meng <bin.meng@windriver.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-riscv@nongnu.org, kvm@vger.kernel.org,
        Stafford Horne <shorne@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Chris Wulff <crwulff@gmail.com>
References: <20221216215519.5522-1-philmd@linaro.org>
 <20221216215519.5522-2-philmd@linaro.org>
Content-Language: en-US
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20221216215519.5522-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/16/22 18:55, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---


Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>


>   dump/dump.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/dump/dump.c b/dump/dump.c
> index 279b07f09b..c62dc94213 100644
> --- a/dump/dump.c
> +++ b/dump/dump.c
> @@ -29,6 +29,7 @@
>   #include "qemu/main-loop.h"
>   #include "hw/misc/vmcoreinfo.h"
>   #include "migration/blocker.h"
> +#include "cpu.h"
>   
>   #ifdef TARGET_X86_64
>   #include "win_dump.h"
