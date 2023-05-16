Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD8B7058E3
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 22:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjEPUbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 16:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjEPUbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 16:31:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9C5902C
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 13:31:32 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-643ac91c51fso9597331b3a.1
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 13:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684269092; x=1686861092;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/HYphPqsQCx/mNqQgAGncflo4HLMvbGDxz2/uuT5K4M=;
        b=qD1KUvAg6109bSI+noOTiDSsowYyo+TrgzHk1Y508Zpqs3aRYKJSkQH+i6ilRA9w++
         SV9o74uqr+V18EexdQK1qTk5rhGfiFUOuTHH1oh9f1UIfTb586A8M15GoEj9U8Bv816A
         ATK759h0TNvNoTQECL6iIddtUUIQRcwbfU1e/shDEnWK8hMPrsfaVstr+V8CESTZuHei
         a7/0BhqgMedhxIg/lwwUFA4nXuLcWhtIBL1CoR1v+HtwX8QTfMaU7al5ivABBUB+0Co9
         0lEXoM1LIPn/7CJTrpkmhgmAbyyH/39F1VCemA21wjRuCGdVYZA77A/f59FmKUe2OnpB
         vaGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684269092; x=1686861092;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/HYphPqsQCx/mNqQgAGncflo4HLMvbGDxz2/uuT5K4M=;
        b=V4YmMkcH/AhI9NmhQaNOjaLvwrS4968SlVtVmaR3J+qUJ5MmtxcaxOyZrLlaW5GUb+
         8PL8LtxNfZEw0ICePNigxFjRMoz+xR6TNLxqIFxHxgq/33rk+808iST0LLtZImHryLrd
         LLsvZkOtmQt4BY/JjZ/0o1oj3UbLc/7cNqm0Yum3pFLlXigArmc5VorEi5PSN87xPGIj
         TD3J5I9iG8G4Z4EC92n5aKyU7F3IDg5JibSeAypYozmIIxFxDsp+JrQH7Ge2ORwLp6hz
         rNlImz2kObb1y0nauzFkfqo9As+/68EbqFIPMej59kKCWQyrsuMcxtdrQ65ketWzCtoD
         VqNg==
X-Gm-Message-State: AC+VfDzdR6FHWYHYzKFd8gAIBlFHdDXnk2juJyj6pn/ixmHkJTs+iK1Z
        iPO+fa0CffCM7qGFlhg5OQfUTA==
X-Google-Smtp-Source: ACHHUZ4/Ow/38dzsjcAtR38/bP2w4DLQ7kvf/12MZ162RiG+VdH0tcDbn1Wni1z6cprdwkK97jGaCQ==
X-Received: by 2002:a05:6a20:3d87:b0:101:e680:d423 with SMTP id s7-20020a056a203d8700b00101e680d423mr30678831pzi.28.1684269092286;
        Tue, 16 May 2023 13:31:32 -0700 (PDT)
Received: from ?IPV6:2602:ae:1598:4c01:ec81:440e:33a4:40b9? ([2602:ae:1598:4c01:ec81:440e:33a4:40b9])
        by smtp.gmail.com with ESMTPSA id c20-20020a62e814000000b0063b8ddf77f7sm13581301pfi.211.2023.05.16.13.31.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 13:31:31 -0700 (PDT)
Message-ID: <db06ccfc-fcf7-3ab9-d114-8f4285f58e73@linaro.org>
Date:   Tue, 16 May 2023 13:31:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 1/1] arm/kvm: add support for MTE
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>
References: <20230428095533.21747-1-cohuck@redhat.com>
 <20230428095533.21747-2-cohuck@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230428095533.21747-2-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/23 02:55, Cornelia Huck wrote:
> Extend the 'mte' property for the virt machine to cover KVM as
> well. For KVM, we don't allocate tag memory, but instead enable the
> capability.
> 
> If MTE has been enabled, we need to disable migration, as we do not
> yet have a way to migrate the tags as well. Therefore, MTE will stay
> off with KVM unless requested explicitly.
> 
> Signed-off-by: Cornelia Huck<cohuck@redhat.com>
> ---
>   hw/arm/virt.c        | 69 +++++++++++++++++++++++++-------------------
>   target/arm/cpu.c     |  9 +++---
>   target/arm/cpu.h     |  4 +++
>   target/arm/kvm.c     | 35 ++++++++++++++++++++++
>   target/arm/kvm64.c   |  5 ++++
>   target/arm/kvm_arm.h | 19 ++++++++++++
>   6 files changed, 107 insertions(+), 34 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
