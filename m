Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0006C734D08
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjFSIGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjFSIFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:05:37 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3FFC3
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:05:36 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9889952ed18so152573366b.3
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687161935; x=1689753935;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pkuyy9Qu55P6NOyPQmGtz0+oG22qvc0HNbqokeNrZNg=;
        b=nyHVpnefgOD5WWUdiP7CwN9VtJziD0KZGfpc1fbLbhv3LPxpgABgehY1G+2OjuPZPd
         LEKMEUk4MM0AQHzJAHVBHX6mSlghAQf5OQ1VkjVeGKvcfpudSD8TgzR4bcCHWIJzw6OK
         iN6crXqrsGRiYkBRt0geWLcqRVhPMf0JuG1mPqAKUjBPxnw34xRLFJNArGtWcaEbSrgT
         QufYOHJxXsHDQ7yjWxsYU8eChGLmZRWq/qgsjypMgIECJZ0FreNLjV9XbZ1Ilmzxqi04
         pt8fghYbxfmEWDs/9i1v9eiiy4eR/VqDMkIsGhM3dhdxGOh3F/LCSgVMnDkvMmZwXCtx
         VCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687161935; x=1689753935;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pkuyy9Qu55P6NOyPQmGtz0+oG22qvc0HNbqokeNrZNg=;
        b=UbAwWip41yZEw3AMaFYfcLc7p4HVyecsB/jQLI4Dp6V3Zkv5KpndyoIptsgqKtrKtA
         9qp1T0EU3xLFvwzmlG7B4uXWCOj9lzQYv7GfXmf/K7KRtRQ+itSOGV1gc8mL5rFpBNZu
         rHSznFDuaDxijW8K2Pgfaq6H3sGnvvsH7dEaBSofd7xMOihoxSobMWEczqjZ6kP/I2BQ
         RMfqGvUFGitFE0J4nWo0U568PpN60eH1o3iCJXsttQVKCsmBNnLVHE7Q6mG2dLHooRqy
         kVJ7ws6ez8HsLP3OpCQ0aI4XmwwFKyDTCe5WCVZ4pfMIoe+KYLupEeRaByVYWmAwcIGf
         +4IQ==
X-Gm-Message-State: AC+VfDxk4lFR6vLJEZzRlQV4eLSX4gGLzlZFroJ4MuTjYFGImTa0ofyA
        aBrhe09Zy4lEC81N7K2GYq/Z/w==
X-Google-Smtp-Source: ACHHUZ5t4qYonxd0izt5cd45PC+spp5Z2UupLaYQNRCYkX1hLwqWNPaaHdPkzG9hGa19M9USGRnSJw==
X-Received: by 2002:a17:906:9b88:b0:988:9641:fe38 with SMTP id dd8-20020a1709069b8800b009889641fe38mr2275959ejc.32.1687161934788;
        Mon, 19 Jun 2023 01:05:34 -0700 (PDT)
Received: from [192.168.69.129] (sar95-h02-176-184-10-225.dsl.sta.abo.bbox.fr. [176.184.10.225])
        by smtp.gmail.com with ESMTPSA id gz17-20020a170906f2d100b00988936b142bsm1476186ejb.147.2023.06.19.01.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 01:05:34 -0700 (PDT)
Message-ID: <2920d8da-4298-82e9-7d41-f00892a03e29@linaro.org>
Date:   Mon, 19 Jun 2023 10:05:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/4] hw/net/i82596: Include missing
 'exec/address-spaces.h' header
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20230619074153.44268-1-philmd@linaro.org>
 <20230619074153.44268-2-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230619074153.44268-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/23 09:41, Philippe Mathieu-Daudé wrote:
> hw/net/i82596.c access the global 'address_space_memory'
> calling the ld/st_phys() API. address_space_memory is
> declared in "exec/address-spaces.h". Currently this header
> is indirectly pulled in via another header. Explicitly include
> it to avoid when refactoring unrelated headers:
> 
>    hw/net/i82596.c:91:23: error: use of undeclared identifier 'address_space_memory'; did you mean 'address_space_destroy'?
>      return ldub_phys(&address_space_memory, addr);
>                        ^~~~~~~~~~~~~~~~~~~~
>                        address_space_destroy
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/net/i82596.c | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
