Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8186F423E
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 13:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbjEBLEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 07:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjEBLEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 07:04:21 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8F64686
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 04:04:20 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-2f7db354092so2193565f8f.2
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 04:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683025459; x=1685617459;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+hjWpb0pMW2nCyTz3f9wKT0AcLqHoErfQAToeTh2JiY=;
        b=NQjRjFoCVoLyU2madL/Ci07RlLjFG6DjPrv3N3HxwGTt7TmwxKIC1ukihGdSg+vk+N
         VO8LQf/D2c9sVU2afhuQgGlCYIBEBTE6sq3s70bLZlJIbuxZGeREn1P1tlX6znfcGUoy
         bQDCCLWXuOJdYHvmZVBUjEIstsV+E0h8/nihqEggeo45z5VJcE5dn/YWfq6EZEteHnhj
         rkncKdw/LEs4gEbQRDd9QgPKz1CM4CAJfV22pze8GaupausnnnaLyMq6Ah9qQPK/Uof9
         i0gADxQhX+yKII+0VNHN/lBnguIv1FKdRls7Lbup+jMadynJXsveIy55G8rqX3sr571T
         whpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683025459; x=1685617459;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+hjWpb0pMW2nCyTz3f9wKT0AcLqHoErfQAToeTh2JiY=;
        b=QLWTOWeBqiTYQ/UjbcHtaIGAAMqGdvOelNhfGCwuvyZ7StD/zEVf34pgng62DytHe9
         lv5XtfqBcm1is5+BpGBeXdMpvp7mJRKSqWOJNCWZk1AnLan7zsat7SDkoZaza9A9Bmm8
         PoDRvmieLOUKk1wZrFLMnu9cPBqBpx5p4wXjh7NMzUDQNROaaLzuA6KAwDPE/+JH6HI2
         10DH0p4Tk47Yu5cbX02LouwcnyuvfR1cMCV4e2pLcVszpUPPSn+NqEaybgh/Z95me+EX
         NVFqxtUyPDFvryOxPYq8GEB3aRMzg+BqLOPDd0aJvY2LFJ7x1bAwMnZ3Y1W5hs+zXWGR
         lR/w==
X-Gm-Message-State: AC+VfDzMBAK5EEWT2imNwrOHrRxMvJMWgI6lTLjQXmgd0H0pxgc0wRcW
        SeA6k3Ip1Vbp3Se4aAMPa0i5Fg==
X-Google-Smtp-Source: ACHHUZ5LhFClrKCQb5kVRCBTX4aoJ4VRCEkJLsUzYo0foTrnW08haSIrJrrYsiBBTg1IcwNy//Qj9A==
X-Received: by 2002:a5d:4a50:0:b0:2fe:c8b5:b5d5 with SMTP id v16-20020a5d4a50000000b002fec8b5b5d5mr11280182wrs.2.1683025458915;
        Tue, 02 May 2023 04:04:18 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:ad29:f02c:48a2:269c? ([2a02:c7c:74db:8d00:ad29:f02c:48a2:269c])
        by smtp.gmail.com with ESMTPSA id b5-20020a056000054500b002e5ff05765esm31001750wrf.73.2023.05.02.04.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 04:04:18 -0700 (PDT)
Message-ID: <cccd2658-26fa-ca9f-68f7-9704eb095c99@linaro.org>
Date:   Tue, 2 May 2023 12:04:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v2 3/9] target/loongarch: Supplement vcpu env initial
 when vcpu reset
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        philmd@linaro.org, peter.maydell@linaro.org
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
 <20230427072645.3368102-4-zhaotianrui@loongson.cn>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230427072645.3368102-4-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/23 08:26, Tianrui Zhao wrote:
> Supplement vcpu env initial when vcpu reset, including
> init vcpu mp_state value to KVM_MP_STATE_RUNNABLE and
> init vcpu CSR_CPUID,CSR_TID to cpu->cpu_index.
> 
> Signed-off-by: Tianrui Zhao<zhaotianrui@loongson.cn>
> ---
>   target/loongarch/cpu.c | 3 +++
>   target/loongarch/cpu.h | 2 ++
>   2 files changed, 5 insertions(+)

Why do you need KVM_MP_STATE_RUNNABLE in loongarch/cpu.c, outside of kvm.c?
For Arm, we test the architectural power state of the cpu.


r~
