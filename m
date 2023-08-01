Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BD476B697
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 16:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbjHAOCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 10:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbjHAOCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 10:02:07 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A9AC3
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 07:02:05 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3175f17a7baso5121293f8f.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 07:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690898524; x=1691503324;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BrksOpqUjAUEy32MmJaMJMaflmISBOfcCLnD5EwZNQs=;
        b=N9gHHLPjM6IBcosZN6lsCZQB0PC3Qg+0I5sgBo8lc354YLYXjn/OVVOLLNL+ftOW9F
         hQHRgh2W5rn/4ogvkrA9hwv/XUB+d2QjtnktFa+CKBEoxk8aBTPqLplBs+gXVZdR2jSJ
         teJPPZSAr2RjGsvaO6bdNfrAbkGxRiP3ciCXFObJlgW30pAK9395ra5kWOIg6xNZg9aw
         polBTKn6lv/Z0XIY/MgPM7z0SVq0HjiBJfngNPV+38Y7WJZmkb5lsTz3hJs945zkb7Z9
         ITrbGATJa5wJJ3eDiJ2fTnpwCEwCmzMzdwHYKojmlrQLQVAr09HXoBoe29+6EDJHF+hz
         fACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690898524; x=1691503324;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrksOpqUjAUEy32MmJaMJMaflmISBOfcCLnD5EwZNQs=;
        b=iisZu/jFd3SajPix9DV7VvePHdIqIPcr+KZm35d7Z7iIySQVUVW9z5eBlkBFz2q2rO
         nXWNfM04DdumGhPcY6EJiaB2ChPY/Tfv4nr49+W9K4DqFP1jAdi/MFqvik4hYDX6qOYR
         cdrVPJq3yF58/jOF6Tg5UMF+ZclB1DPLrLufSSbesyzs0FGi1LB9pOe94qWr+lZ80A8p
         qhoNeJc1Q2mlebomkC/fDo+TRf4fzJG/HSLB9CY1PEMapHu/OUcWmMSISjmXj+UJReRz
         WmmAuB28m2YPPT70mpR6l3bHY0r81Y5yxijgECpqMJjDhmlCHIL4d4C5goanrEdCDlqs
         pk1g==
X-Gm-Message-State: ABy/qLZAz3hHsIIvDV+K5prVgLJSMIr7Li5vpu47eni0XDm0oJdsNilq
        0xc4jqDNgubJ0eNv3Y397C/b0g==
X-Google-Smtp-Source: APBJJlFGUJ6jKzWwPl5BWHR+yLvQlr2LJvZNj0hJ5Ewi60F1aSJcHQJyjja2O/DLLARvHjfEwo9ahA==
X-Received: by 2002:adf:f5c2:0:b0:317:7068:4997 with SMTP id k2-20020adff5c2000000b0031770684997mr2414146wrp.60.1690898524261;
        Tue, 01 Aug 2023 07:02:04 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.174.59])
        by smtp.gmail.com with ESMTPSA id f3-20020a5d50c3000000b00317909f9985sm11851806wrt.113.2023.08.01.07.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 07:02:03 -0700 (PDT)
Message-ID: <e3343df1-4ff6-1cbf-2d31-56535bb70858@linaro.org>
Date:   Tue, 1 Aug 2023 16:02:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v3 09/12] KVM: x86/mmu: Replace MMU_DEBUG with proper
 KVM_PROVE_MMU Kconfig
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20230729004722.1056172-1-seanjc@google.com>
 <20230729004722.1056172-10-seanjc@google.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230729004722.1056172-10-seanjc@google.com>
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
> Replace MMU_DEBUG, which requires manually modifying KVM to enable the
> macro, with a proper Kconfig, KVM_PROVE_MMU.  Now that pgprintk() and
> rmap_printk() are gone, i.e. the macro guards only KVM_MMU_WARN_ON() and
> won't flood the kernel logs, enabling the option for debug kernels is both
> desirable and feasible.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/Kconfig            | 13 +++++++++++++
>   arch/x86/kvm/mmu/mmu.c          |  2 +-
>   arch/x86/kvm/mmu/mmu_internal.h |  4 +---
>   3 files changed, 15 insertions(+), 4 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

