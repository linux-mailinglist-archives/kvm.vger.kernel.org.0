Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154E664EF36
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiLPQeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiLPQdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:33:55 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6488E3B
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:33:54 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id s186so2382052oia.5
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4/3Vkn2xx3xz6e472kxIczxxtylkmd9wx638NPX1n+g=;
        b=PxDfk5NspAfiGuMgYRx9w72ARPiowJyWsDgy5aa1OxJquzS7M6TPGJy0JIb7BrdQzs
         sb5o5HqR9LX9d9isaynWtyGbdiGoBwLMfwjxHGXjNyJ06ddD2psvCOjUsWyaWM/BdRdW
         oQPDEwy2JVFZAJP8dt1DN5q2BPK7bZkgwkDE9toSX5fVb39C3XSu4Jwl0pgWdF6yMsWR
         PkenpDz/WH5stXitEX37TQqeCiYK+OzXX48lfZ9bPR4TNo+G3GCEScRwENofqnvYvS/x
         j5nzYUrCtaU2nv7h7Xaf/Ejl+4yMzwOMSICpCayL9Ela+qnCk/YHy8GvJUv0WyGCM6bD
         NQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/3Vkn2xx3xz6e472kxIczxxtylkmd9wx638NPX1n+g=;
        b=eJe/wV5PfUigyBZJuilLwrVjdxpxQwmjhMYERJ3pJPuJV2xcI5ZqY1jeutJS/J7ilK
         Ii6BjSQ0eVm5WqwA9Qb432slZdCxnLFVAGUFYVANZ5hTECfcVCIByNtW00x9g+bU15gv
         Q4WK3cZOsHU7OU1owesGLtyuItzubR8ovxvmlnl1AD23jA6zi/XkqMUCuGk3+VIL8WYF
         nLmRVoAdfjGplvbJQNyOggkmdsDDsP/n9iDzo6y9N6h3zzhVDU5/TiqL9CZvUDDd+sDH
         jo9PZBlgp9ZxIUp/yBzFwsPDDBJqX4idoD8aeAuJWin5xgT0SJ7nXT6KhH6EszrQw5bp
         luFA==
X-Gm-Message-State: ANoB5plLCB2diXZkAvbdN4zbMsWuhp73bVjlxIIlRe16dnCDLpjrV7yS
        4nHNouYRG7m9QpjWb5pBz1M=
X-Google-Smtp-Source: AA0mqf4yMl9H4qx/pBHxC77dBXB3/2+tsv9C4HEzb+rdwmFr/3ZmAoYZQQhAuASsANsvY/7CWd8lZw==
X-Received: by 2002:a05:6808:64c:b0:35e:8098:786a with SMTP id z12-20020a056808064c00b0035e8098786amr12326399oih.45.1671208434036;
        Fri, 16 Dec 2022 08:33:54 -0800 (PST)
Received: from [192.168.68.106] (201-43-103-101.dsl.telesp.net.br. [201.43.103.101])
        by smtp.gmail.com with ESMTPSA id ez6-20020a0568082a0600b0035e7ed5daa1sm896391oib.26.2022.12.16.08.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 08:33:53 -0800 (PST)
Message-ID: <4d03a8c7-a7ef-cac8-9ca3-f06757131aab@gmail.com>
Date:   Fri, 16 Dec 2022 13:33:48 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH-for-8.0 2/4] hw/ppc/vof: Do not include the full "cpu.h"
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
References: <20221213123550.39302-1-philmd@linaro.org>
 <20221213123550.39302-3-philmd@linaro.org>
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20221213123550.39302-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/22 09:35, Philippe Mathieu-Daudé wrote:
> "vof.h" doesn't need the full "cpu.h" to get the target_ulong
> definition, including "exec/cpu-defs.h" is enough.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>

>   include/hw/ppc/vof.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/hw/ppc/vof.h b/include/hw/ppc/vof.h
> index f8c0effcaf..d3f293da8b 100644
> --- a/include/hw/ppc/vof.h
> +++ b/include/hw/ppc/vof.h
> @@ -9,7 +9,7 @@
>   #include "qom/object.h"
>   #include "exec/address-spaces.h"
>   #include "exec/memory.h"
> -#include "cpu.h"
> +#include "exec/cpu-defs.h"
>   
>   typedef struct Vof {
>       uint64_t top_addr; /* copied from rma_size */
