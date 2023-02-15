Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3586F6983E1
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 19:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjBOSzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 13:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBOSzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 13:55:49 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F393BD84
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:55:47 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id r17so13380426pff.9
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DC2afEabX9ChDBXxsZPP3PTNUaUOdDflYrzEtp9BYEA=;
        b=J3KHbKq51ABP6W8f34Iyqx0l7GXtLnsKjTd7/Y03IGnqI5wc6aE/gr6GfvPoxQX34f
         VzuTcdW+9EpLHNxRbo6TvHdIE6/UrseGxa2bRUr1FMlcnp+G5yWKOY8npJq1bSb14pgD
         5+q1OKtJfFui/IhIwPmu+qaXv+YnKOdzVdGx3C+Wv78cD3L2dLXlSzt7Ve/H4YLmPnMk
         Poe+Qp44ezFlZ+ODXHZ/MCTcEPBmYS0xKLP236MS+GvCDOTkLdNRIcHrpywEZdngzuYs
         hfU7Bwi0gRwPQMjMWvZuqL1vJAg6aAo7Z9f/ErVTIPt/I+wtsd/frNVRXdw160h7EVO4
         pC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DC2afEabX9ChDBXxsZPP3PTNUaUOdDflYrzEtp9BYEA=;
        b=X3D6SWHGItrG3fyGAXIxGorK05M4w88fKdxClih1jHuhgKcX9Pjx5xeELn6+TvQsGA
         kR/v3G2h1yeZOYu66rixNr4n2G0prJyQJFCxthLfoMv8/sQfsfihaFam0Mch7ZcSc0Hj
         wYh/eTXG6jAQbRHamrFJQQ46bZzcNx8SMRiGRQechFbqXvSji3D/VdicIBGdIYKUtIH+
         GBYGBnfO/DwRBSTF075z4WPdsYnvI6eiPezK1I36+cO2eonMUnicGPNCcHYEZwWT37hf
         25hRHWGsuvNXdxg8fFTMKu9PDIzIAJtOXKlARKRl88h8UMbC+eQLCpPdsPHu3UcXEJoG
         u/JQ==
X-Gm-Message-State: AO0yUKWTZQKQmt1njzCnl6mL10Te9ESu8d/p/zbgaYpdtAQ4j0gJm/31
        eUk+0VajFMtA4CMnUy240JsQZA==
X-Google-Smtp-Source: AK7set8gO0VmUQfx84hyD5ePnXnK8QU+jpjykYBrNvmI6TId3beE6c1E61QlRDyP+JqIPfKYKCxEmg==
X-Received: by 2002:a62:1c51:0:b0:5a8:b4a5:bf98 with SMTP id c78-20020a621c51000000b005a8b4a5bf98mr2793435pfc.3.1676487346832;
        Wed, 15 Feb 2023 10:55:46 -0800 (PST)
Received: from [192.168.192.227] (rrcs-74-87-59-234.west.biz.rr.com. [74.87.59.234])
        by smtp.gmail.com with ESMTPSA id k14-20020aa790ce000000b0058bacd6c4e8sm12001732pfk.207.2023.02.15.10.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 10:55:46 -0800 (PST)
Message-ID: <8665b6e1-d962-c9d6-76e1-0967974c370e@linaro.org>
Date:   Wed, 15 Feb 2023 08:55:40 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/5] hw/timer/hpet: Include missing 'hw/qdev-properties.h'
 header
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230215174353.37097-1-philmd@linaro.org>
 <20230215174353.37097-2-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230215174353.37097-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/23 07:43, Philippe Mathieu-Daudé wrote:
> Avoid when refactoring unrelated headers:
> 
>    hw/timer/hpet.c:776:39: error: array has incomplete element type 'Property' (aka 'struct Property')
>    static Property hpet_device_properties[] = {
>                                          ^
>    hw/timer/hpet.c:777:5: error: implicit declaration of function 'DEFINE_PROP_UINT8' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>        DEFINE_PROP_UINT8("timers", HPETState, num_timers, HPET_MIN_TIMERS),
>        ^
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/timer/hpet.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/hw/timer/hpet.c b/hw/timer/hpet.c
> index 9520471be2..214d6a0501 100644
> --- a/hw/timer/hpet.c
> +++ b/hw/timer/hpet.c
> @@ -30,6 +30,7 @@
>   #include "qapi/error.h"
>   #include "qemu/error-report.h"
>   #include "qemu/timer.h"
> +#include "hw/qdev-properties.h"
>   #include "hw/timer/hpet.h"
>   #include "hw/sysbus.h"
>   #include "hw/rtc/mc146818rtc.h"

Acked-by: Richard Henderson <richard.henderson@linaro.org>

r~
