Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD82978B5D3
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 19:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbjH1RBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 13:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbjH1RBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 13:01:02 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC7BAC
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 10:00:59 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-31c7912416bso3081986f8f.1
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 10:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693242058; x=1693846858;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GokrXOWNEUqXD64nchMPQGzEDuFLKl5Dqa2/yFnbBww=;
        b=s8BtQF+lfMTEsJms1HXnf1Pdb+9+UIVGXtCZ0fx3/WGiZlAmMPKp13Os1jtulpK7Es
         vGOVaeQSHCJsjRuVO0P8EliqaiJtC+fL9vtZCpfe9XGceYl7AoX+WwCwHTeWd38bRJLJ
         71POrwPhvlIL5aYZ/cDc3U3e03OJn9QYMp+8rEINudYB73xEy9CgTtu1p2AviJKPa7i1
         /BS2SAu2QUYvgrrVOvgahykTvMSHIDwj1XgpJyMCVib87npI4SKD+thMnwT9ulytg4uC
         yxU91IiuVob4zejOmuulYiAJlQtH9WKcOKSSKkESGDqb6x3BpPuDg97h59RovFpW39t0
         aniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693242058; x=1693846858;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GokrXOWNEUqXD64nchMPQGzEDuFLKl5Dqa2/yFnbBww=;
        b=joTqjw+IB/wMdAZxXs/+Y3v5W4PUP0vRlzWWSFH/SZtDSw/B91GuWMt+fYjaVMNDbF
         RXr2Jie54DrqNaoI5ZrDp3fS+hbxtZx2Ge8uA6bf32dmXgrOw6RKKC/3RZrLIZPLtCFh
         we/5r/CxjlhXbr6iPe1i/fjL5NQLqiQN0Gl+Qwz3G1kTVMOmnDHtCNGxiobUd2wYPK/9
         EvGlJY4do7v9ZpmDjVnHQ5t8z97uhxD/0DTDV/Spnztraxon/AxbvgzRh69FK5473K/n
         KPvttW1fSWrfAGBKTgxmJUZtAKO1dEioO344uS06nld9UGPos64dIA/dl+ry9T1qt/oe
         MGWg==
X-Gm-Message-State: AOJu0YxSRwBKIkG6vEyCm9hd8MadI30WJMCpScbitaGRz355Xjzb4pV9
        YxWPs7xGY++b3NHxInmYklZsCudvrMgRzqqhAQY=
X-Google-Smtp-Source: AGHT+IHD555+gPDMJ9guL2r8d1VjtScpc+cB9KPnHKSUktF+ggy8S1ZDZW7qfNuGMVgrV7mBEVkdyQ==
X-Received: by 2002:a5d:4d02:0:b0:317:5a9b:fcec with SMTP id z2-20020a5d4d02000000b003175a9bfcecmr19432674wrt.14.1693242057737;
        Mon, 28 Aug 2023 10:00:57 -0700 (PDT)
Received: from [192.168.69.115] ([176.164.201.64])
        by smtp.gmail.com with ESMTPSA id y7-20020adff147000000b00317df42e91dsm11188859wro.4.2023.08.28.10.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Aug 2023 10:00:57 -0700 (PDT)
Message-ID: <e311ac4b-48e6-ea8f-3157-6f78bc5b9ad9@linaro.org>
Date:   Mon, 28 Aug 2023 19:00:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: arm64: Properly return allocated EL2 VA from
 hyp_alloc_private_va_range()
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <20230828153121.4179627-1-maz@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230828153121.4179627-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 28/8/23 17:31, Marc Zyngier wrote:
> Marek reports that his RPi4 spits out a warning at boot time,
> right at the point where the GICv2 virtual CPU interface gets
> mapped.
> 
> Upon investigation, it seems that we never return the allocated
> VA and use whatever was on the stack at this point. Yes, this
> is good stuff, and Marek was pretty lucky that he ended-up with
> a VA that intersected with something that was already mapped.
> 
> On my setup, this random value is plausible enough for the mapping
> to take place. Who knows what happens...
> 
> Cc: Vincent Donnefort <vdonnefort@google.com>
> Fixes: f156a7d13fc3 ("KVM: arm64: Remove size-order align in the nVHE hyp private VA range")

I don't see your kvmarm-6.6 merged by Paolo, is it too late to squash
and send a new PR? Anyhow:

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Regards,

Phil.

> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/79b0ad6e-0c2a-f777-d504-e40e8123d81d@samsung.com
> ---
>   arch/arm64/kvm/mmu.c | 3 +++
>   1 file changed, 3 insertions(+)
