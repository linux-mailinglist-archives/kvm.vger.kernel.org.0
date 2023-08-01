Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D9276B69F
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 16:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbjHAOCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 10:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbjHAOC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 10:02:29 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358E5268D
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 07:02:21 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3177163aa97so5875971f8f.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 07:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690898539; x=1691503339;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k7Jzzi9NbvOsA7/fth/YWyvk/IGZtZyCz5gHiU98gNo=;
        b=Pn/UxlHV8RfOfxyDhm8ih/vCve/PfafBvqUqLTK9caP3WuL/ORBsleCl37w7qsv2Tl
         wMZSKklOvwMSqJPEiAZI8lh/WZcZ0Zhk8kwfYZnzmDBcGF4YbWyZmb9eAEwUyEkkZyo/
         MY9u6rr1qJeRZ3rf7IVB2Uc0THPvVLkqaNABHv/8PKp6hGmdb8XeXUPSfVgKOgERztSH
         J6bm7BW4QG00k2V5lI4mp6EcSCLfVpRWQTRvCrL/YPjlXJG4Ubrem2JKI78zW6ekIv2V
         xfRZTv3zbDkzNEbfo6j7v2qwX7ojimRu5iCOoVuYIIswn/tZqn7YZdZukvI52oYFrt0Y
         Tr4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690898539; x=1691503339;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7Jzzi9NbvOsA7/fth/YWyvk/IGZtZyCz5gHiU98gNo=;
        b=WY3o/TYBS0EzSDBVX0BZ6tqsaRrWRhDhfZoFFwOLvAtwhrNanIl/oZ5cZscO1FZxen
         Lu59CuFoHUJHEAFJARm1W9+pO8Zt8erQCGA6lXCRczuG2knBezWwCqLBo2ZoMbnhOQky
         +o8A4WbTHv08y4HgzUXXp1vwg2m8saMUaJDkx1aI/iaQT1LPSWI8DZwRHm4W/75YWtmI
         qkitwZD1qdWhBRyDzB7pIkDddVGStLhLszzhqK1IuJTey02LXWbzmprsa7rNBfmHuK4q
         rhSeaSTMIQr+Eh1kzUbddp1UO1QDpSBVFWZOyGrU/wg8s7yUfxN5u5glf0cX1E473OI2
         C+tQ==
X-Gm-Message-State: ABy/qLZEw4ZbJ/JzoicU6Z5MIBH0E7/S8EBuVagWV3EutIKXBkBoELrI
        vdRLgoWReHS/8mRezpfai/d+sg==
X-Google-Smtp-Source: APBJJlGl0W8lcaw5hjKhFWcW+BkJphnERAaycDDK74mqwbtt3RXEfSPPoZss0gztD+5I/wqpvm4Mpg==
X-Received: by 2002:a5d:50d0:0:b0:317:5722:a41b with SMTP id f16-20020a5d50d0000000b003175722a41bmr2547672wrt.7.1690898539698;
        Tue, 01 Aug 2023 07:02:19 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.174.59])
        by smtp.gmail.com with ESMTPSA id x2-20020adfdd82000000b0030e56a9ff25sm16231019wrl.31.2023.08.01.07.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 07:02:19 -0700 (PDT)
Message-ID: <d347cc51-cddd-199a-d9e5-ff340172938e@linaro.org>
Date:   Tue, 1 Aug 2023 16:02:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v3 06/12] KVM: x86/mmu: Rename MMU_WARN_ON() to
 KVM_MMU_WARN_ON()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20230729004722.1056172-1-seanjc@google.com>
 <20230729004722.1056172-7-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230729004722.1056172-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/7/23 02:47, Sean Christopherson wrote:
> Rename MMU_WARN_ON() to make it super obvious that the assertions are
> all about KVM's MMU, not the primary MMU.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          | 4 ++--
>   arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
>   arch/x86/kvm/mmu/spte.h         | 8 ++++----
>   arch/x86/kvm/mmu/tdp_mmu.c      | 8 ++++----
>   4 files changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

