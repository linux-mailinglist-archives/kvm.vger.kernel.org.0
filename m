Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C89164C70B
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 11:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbiLNKZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 05:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237788AbiLNKZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 05:25:04 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C522B1CB07
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:25:03 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so10374348wms.2
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=tgEnRI8WOVVtDEHloOzgopZghw9gtaVZ2Hs+Mphsg/I=;
        b=LFggslxkDVWC4QvLFBck4lr08tDvgFz2QZFBozLwmJrZJIjn2TBs1SiVK4FHyu9VYA
         662kT9xvItqJTNzP/qKuJxrt0c1/1GMYSZKX21BNJu8dTwwy0qxfGXalT0PDjkimnaJd
         sF3tg2xZ1xdVP3ttcm/figDnYjz1dh4bnehd5xfnFT4lZnjJcaVUbAHAwGDVk1vY/6rZ
         fpmeNzs1OKgaYWuqwaRko91MYLkD4gm5rmqd5BIzKrl/3Cf8hdmFykAr42TGGwYN1dp1
         BnRq7QXbMeRdvN5AwSbJ13Dt3f6lD7BzEoVbmBKXykSv39tf9wzn4Zvz7UAVQEQ7BI5x
         0sNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgEnRI8WOVVtDEHloOzgopZghw9gtaVZ2Hs+Mphsg/I=;
        b=cxsGJXU1WbyWpoi8elCIy8T/dnzlQx2Kdm+kvlFk8aOOMy/+TNZmlS0iXMvy7h2Iy7
         WNuSz052C3MtdibNbUbITfJWN0xRyBdVBQAhLoU8U5duhyNXSZcFRRfv2LS5qh/wTNEY
         oDyRQtxCRb6YpKyGIDt1l2lq45gkt775atC7CawpaqpZYovXNSJwh/RH5xwDoYDWLeQb
         BGxs+Mie9r6L99jsXf84s/c4+Lg5m0ZtHcASM6g3bUZJJHm8kt5Bl7WR1uGI+8pjcVpr
         MUPblpyV+WrongkYPO9cDCP3ZfrXzzG1wpwhy1tnWTSMEuqW9o9hnVLpvoy1GqzY1y9j
         mVEA==
X-Gm-Message-State: ANoB5plnEK6RNNBIFzMuwLtwoLlpAw1moWxXki6LG3473wabAJZFkKYU
        rxbw2TsS3C8thmjPhq8ZFMM=
X-Google-Smtp-Source: AA0mqf4Gs0HtxCuMGpwr+BYSY8vBUb+UgyQXO9p9OuGhGKgNgiweE/0PrPrAKK7JTJOoMSxs3xEV0Q==
X-Received: by 2002:a05:600c:3799:b0:3d1:f74d:4f60 with SMTP id o25-20020a05600c379900b003d1f74d4f60mr17939389wmr.22.1671013502155;
        Wed, 14 Dec 2022 02:25:02 -0800 (PST)
Received: from [10.95.114.11] (54-240-197-226.amazon.com. [54.240.197.226])
        by smtp.gmail.com with ESMTPSA id b47-20020a05600c4aaf00b003b4fe03c881sm1827535wmp.48.2022.12.14.02.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 02:25:01 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <e0b1d9cb-6252-7df0-7714-21ded04525d0@xen.org>
Date:   Wed, 14 Dec 2022 10:24:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] KVM: MMU: Make the definition of 'INVALID_GPA' common.
Content-Language: en-US
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org
References: <20221213090405.762350-1-yu.c.zhang@linux.intel.com>
Organization: Xen Project
In-Reply-To: <20221213090405.762350-1-yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/2022 09:04, Yu Zhang wrote:
> KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in
> kvm_types.h, and it is used by ARM and X86 xen code. We do
> not need a specific definition of 'INVALID_GPA' for X86.
> 
> Instead of using the common 'GPA_INVALID' for X86, replace
> the definition of 'GPA_INVALID' with 'INVALID_GPA', and
> change the users of 'GPA_INVALID', so that the diff can be
> smaller. Also because the name 'INVALID_GPA' tells the user
> we are using an invalid GPA, while the name 'GPA_INVALID'
> is emphasizing the GPA is an *invalid* one.
> 
> Tested by rebuilding KVM for x86 and for ARM64.
> 
> No functional change intended.
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
> v2:
> Followed Sean's comments to rename GPA_INVALID to INVALID_GPA
> and modify _those_ users. Also, changed the commit message.
> v1:
> https://lore.kernel.org/lkml/20221209023622.274715-1-yu.c.zhang@linux.intel.com/
> ---
>   arch/arm64/include/asm/kvm_host.h |  4 ++--
>   arch/arm64/kvm/hypercalls.c       |  2 +-
>   arch/arm64/kvm/pvtime.c           |  8 ++++----
>   arch/x86/include/asm/kvm_host.h   |  2 --
>   arch/x86/kvm/xen.c                | 14 +++++++-------
>   include/linux/kvm_types.h         |  2 +-
>   6 files changed, 15 insertions(+), 17 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

