Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE16734D14
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjFSIH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjFSIHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:07:12 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167BFE61
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:06:45 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51a2c8e5a2cso4569948a12.2
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687162004; x=1689754004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AQWh0SeDVslmu7ceBeHCnmFpC713019xZJXrjmLHmmg=;
        b=bylCYLE5KhHSODhpWyhkTE7WdweovUfFN7HZUabaIW8zfwSFKXnQOSHnV3e0WRhSlq
         /3VyHiw7UF6dw+Z7k+eR2/7o+1vXFAx4r216RdBejPOQ9s78QaMDmrDGCBbToGzdSOPC
         WAhgvVBCZs0bQX30GvfRgcOqel74YWrws+pBv/5ZmEi692WuXig1VP+/DLDuCrJNfDE8
         7a9QFnoVQ0WW+2oqjA43JkI9Gj8u2/NfiovGfCSZ/K58xeiSLwB8SKQgGfcqC0r+yuSZ
         GA0QPwo8Zb7VaKTBXSDF1p44fXeq+3uy863sv+PorpBbBMYjHgOCnrUntHLSzErDUnHY
         QXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687162004; x=1689754004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AQWh0SeDVslmu7ceBeHCnmFpC713019xZJXrjmLHmmg=;
        b=MUhxTlBV8axBDanAQGd3gk9L5DhaqO3Yz+xYDGdzJWit2ZB0NxPZ0q1A8sD+YjBR0n
         kkmhZLAojymDyO0ugfF1+2bdPCFdAvAgbiFtdudq5AogGGHqBQtx3vyp/VXUiutzoclx
         5cjAjYspBw3M9GXNP3RuXI96o6RXMx0ZC3zxTjhDNaujcDHi9Mj+aXHCe1wymAZMozfU
         oo/4mS3okkufpjuShx6VIn37g25FM66Bo0ZQQQySRj/TXJrhPBAyXQhP4EaQx+VEZjdL
         JCR5noiYoez0Vry1+WcInxh/IYSxSas1JeURSWV7CvHjVqmxLLh/O2nU8/0sXq1NwsND
         Og/Q==
X-Gm-Message-State: AC+VfDzwWz2OnTxPcynvg+PBguK+A5YdL2HMaqJN4cIkaK18dILHzI8k
        FLeNYC+G2Ze6fBHGgLtKRFwQvw==
X-Google-Smtp-Source: ACHHUZ79hi1qAcDnYz+X2e8MXmhzRwV6Oq5meHZJrwNRkoxzHrbb5Mj/T0SY0oCQqhLfFlkP7OZtGw==
X-Received: by 2002:aa7:dad2:0:b0:51a:597e:c3f2 with SMTP id x18-20020aa7dad2000000b0051a597ec3f2mr1764796eds.5.1687162004394;
        Mon, 19 Jun 2023 01:06:44 -0700 (PDT)
Received: from [192.168.69.129] (sar95-h02-176-184-10-225.dsl.sta.abo.bbox.fr. [176.184.10.225])
        by smtp.gmail.com with ESMTPSA id n7-20020aa7d047000000b0051a5a6a04a8sm991650edo.68.2023.06.19.01.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 01:06:44 -0700 (PDT)
Message-ID: <c513a9dc-1586-cec6-4489-0109846d637c@linaro.org>
Date:   Mon, 19 Jun 2023 10:06:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 4/4] sysemu/kvm: Re-include "exec/memattrs.h" header
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20230619074153.44268-1-philmd@linaro.org>
 <20230619074153.44268-5-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230619074153.44268-5-philmd@linaro.org>
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
> Commit 1e05888ab5 ("sysemu/kvm: Remove unused headers") was
> a bit overzealous while cleaning "sysemu/kvm.h" headers:
> kvm_arch_post_run() returns a MemTxAttrs type, so depends on
> "exec/memattrs.h" for its definition.
> 
> Fixes: 1e05888ab5 ("sysemu/kvm: Remove unused headers")
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/sysemu/kvm.h | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
