Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EE952EF20
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350860AbiETPZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 11:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350813AbiETPY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 11:24:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601041790B2;
        Fri, 20 May 2022 08:24:56 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id jx22so2789639ejb.12;
        Fri, 20 May 2022 08:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YELfX0pmeRUgrcCLL0vitmfjUp+FF2g5+k5k9fNku9Y=;
        b=pKR31M0v6C/YLf4xLrR/H2QGjVd5fR7zibIY7qMC7AxbzZUl02O+jEagoEsrP1OvYY
         U1ELKH8KmnXSOLc3zivWXuyW3h4xIvGD+6TYrS4zEHglmBz1E3MzfaGKFKqjb/0yKZd3
         8vlgaohBPH+/6epiKmYQynin1DPIAsuV1CDY7Id3hjAUGAu4HYQOtBC03sbXe6V7Winm
         5Q6uTatnhOjWjktyKdGMFt90zH1mq56n5/teSOHK2C2dXQjcRFtger6iUnky7GQEkK0P
         usM1DIPiRi8kSvMCpBPWlc5Dy2fjgHVkJjOHfIysA3N5UIt9xG+xrJADm/syXTI4tNB4
         j5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YELfX0pmeRUgrcCLL0vitmfjUp+FF2g5+k5k9fNku9Y=;
        b=lPTW4Vljpfm5WEBuoGmwcWI0MSYoIkBhh2oPalYh6E2dVxBYbyOThCE4FISdCB2i+t
         607srHr5z/5AjHriMcQ7HhJNiKgoj0FR3TgPnHiWX3Cr8nRvgxtpJgW9O7tY3n3tfMEz
         aHp0E8KqIJZyC30o8GxEcPFpK84bz+fGviCxYd2qV0jve1LLeT1j4iprVsgS4cZn1UbD
         7U/xK/I7ehBaONMe/OkFNS4Rex4aE27EXVBCf1R3FDoMicYZu0vQipv8kXLJMcA8Bm6Y
         QmZe8NX2TahI2ZSE82U+ghogwPbrgGVmaM2JwnF24zt54T8RbeFdNR8c9tQ/WywMQAeE
         BPLA==
X-Gm-Message-State: AOAM533qIQc3DN52h05k6PAhEc3a+ZihZZzaw8Mp/8+CfkMnMoaWvSg8
        +f7OYc3Mu6JxVBVOMOVbQtKTL8pKKMDKaQ==
X-Google-Smtp-Source: ABdhPJzFUg9+Nw69pvwrhOYP4aLoaeB6c3kLan/f7n6vyz0QQZqAxtBXlGmxunn6uOcH9Df/Ci0gzQ==
X-Received: by 2002:a17:907:7e91:b0:6f4:3b93:1f6e with SMTP id qb17-20020a1709077e9100b006f43b931f6emr4434383ejc.91.1653060294829;
        Fri, 20 May 2022 08:24:54 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id md17-20020a170906ae9100b006feaf472637sm759468ejb.53.2022.05.20.08.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 08:24:54 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d84d9853-d055-50b6-669f-de2f24304f15@redhat.com>
Date:   Fri, 20 May 2022 17:24:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 6/8] KVM: Fully serialize gfn=>pfn cache refresh via
 mutex
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>
References: <20220429210025.3293691-1-seanjc@google.com>
 <20220429210025.3293691-7-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220429210025.3293691-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 23:00, Sean Christopherson wrote:
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 05cb0bcbf662..eaef31462bbe 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -157,6 +157,13 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
>   	if (page_offset + len > PAGE_SIZE)
>   		return -EINVAL;
>   
> +	/*
> +	 * If another task is refreshing the cache, wait for it to complete.
> +	 * There is no guarantee that concurrent refreshes will see the same
> +	 * gpa, memslots generation, etc..., so they must be fully serialized.
> +	 */
> +	mutex_lock(&gpc->refresh_lock);
> +
>   	write_lock_irq(&gpc->lock);
>   
>   	old_pfn = gpc->pfn;
> @@ -248,6 +255,8 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
>    out:
>   	write_unlock_irq(&gpc->lock);
>   
> +	mutex_unlock(&gpc->refresh_lock);
> +
>   	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
>   
>   	return ret;

Does kvm_gfn_to_pfn_cache_unmap also need to take the mutex, to avoid 
the WARN_ON(gpc->valid)?

Paolo
