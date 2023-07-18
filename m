Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BC0757499
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 08:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjGRGqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 02:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjGRGqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 02:46:48 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3089E186
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 23:46:46 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-3143ccb0f75so5337195f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 23:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689662804; x=1692254804;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9MzpjYGu8uAXuw8m2JeqLMYOotZpBjXKkWslMNpPfQY=;
        b=dM4w6aU0rxo+mykLBhf6VgvAgnA3PZpH+EIFcFVaNVCOh/AhIIDLfWrGGipHl66yEM
         +1dCZKsF3WEj69NG3G+bpkfxH2o5w7pxRUzgAt8KvM993ogHrZnjDZwNmA3I4EWMyAJ6
         RApAqc3Hb+Th2mdLMv9HU8NQuyL+rWq9NKcxt3/cqLHtfAHyTrilAHla2LqxaCX3PHBo
         tiBeDlvx8lviywZ96lrHxzTzbXLpaANhARYgkdwjzwV6nMNCvG8gJD11HAMxf3YK3U5f
         yg8XNtXubXx4ctTXMEZ0bwWp9r2dpo7R5ndVnTtV0JjEG9doiFczRXd/PxV+KI6hybX6
         A5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689662804; x=1692254804;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9MzpjYGu8uAXuw8m2JeqLMYOotZpBjXKkWslMNpPfQY=;
        b=cPsX/oNSVPRXrbJnWBumWEKLuD3omV9/Y47jhN3ZoYqZCm5Id+Fdw/iiUwU15sorBf
         YT0MgK7g8L7QUS6rvn6TJnFVMxunE3OUphJWRS4kfXRHo4YtqodM8o0PeFDi+cz1vMK3
         1JPRY8rrvuUoInp40En9LhXmUqhNRe6W53AEez89taMr3VySNAn1EvWe6iNkAv4xVy9n
         K4dc+6fTBGm/lfSSjmL9S5Pj/8662xXD4JpmBvoQsaWaQNhhY4qMigF/8n4TSfH373ZX
         Z215+inNpELJ2KaeulPOx410kVTOrMT3Psu/lq3vHgHmcrVuZF7PDH1DKTGpsOs9DNJb
         gvPw==
X-Gm-Message-State: ABy/qLZF7y1CWBHVZUw4BY07rx/X4Z/87ID46Xmj6S3jWYWQbDw4tA2N
        LJDKR4y0bSFSLL+TmYyezNYEDQ==
X-Google-Smtp-Source: APBJJlEMe2AWmmooDbTnb7UfuwafhIPjsltMOto2MO1y8QkVyhRmtsAr5Jo0Hvds0ickXOTjAbHVpg==
X-Received: by 2002:adf:e483:0:b0:314:77a:c2b9 with SMTP id i3-20020adfe483000000b00314077ac2b9mr13966880wrm.39.1689662804690;
        Mon, 17 Jul 2023 23:46:44 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.222.251])
        by smtp.gmail.com with ESMTPSA id s3-20020a5d6a83000000b003143801f8d8sm1395032wru.103.2023.07.17.23.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 23:46:44 -0700 (PDT)
Message-ID: <34c52f9b-df4c-1b02-8419-b9b4fb18dd70@linaro.org>
Date:   Tue, 18 Jul 2023 08:46:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: x86: Fix errors & warnings in irq_comm.c
Content-Language: en-US
To:     shijie001@208suo.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_63276CF92B7FBBDB6AACD9CB27A3C9B0ED07@qq.com>
 <1b85fe6bf831ffd0b994a9703e8b06f7@208suo.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <1b85fe6bf831ffd0b994a9703e8b06f7@208suo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/23 08:21, shijie001@208suo.com wrote:

> ERROR: Macros with complex values should be enclosed in parentheses
> 
> Signed-off-by: Jie Shi <shijie001@208suo.com>
> ---
>   arch/x86/kvm/irq_comm.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)


> @@ -365,7 +367,7 @@ EXPORT_SYMBOL_GPL(kvm_intr_is_single_vcpu);
> 
>   #define PIC_ROUTING_ENTRY(irq) \
>       { .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,    \
> -      .u.irqchip = { .irqchip = SELECT_PIC(irq), .pin = (irq) % 8 } }

The value is already enclosed in parentheses... False positive?

> +      .u.irqchip = { .irqchip = SELECT_PIC(irq), .pin = ((irq) % 8) } }
>   #define ROUTING_ENTRY2(irq) \
>       IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)

