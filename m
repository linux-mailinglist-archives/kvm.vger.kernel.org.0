Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6219C6F422A
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 13:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjEBLB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 07:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbjEBLB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 07:01:26 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A3D3C19
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 04:01:25 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f3331f928cso20765625e9.2
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 04:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683025284; x=1685617284;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tDK988EtJlhDmjNL6UBbDMauFcsTOZAKNQmY6wY6/TM=;
        b=qRLo0G62aBnaFbwANKkUx7PHz69353krYSmXX04CHhEnBJTmEVs1dy3LmJgPd5vvyp
         40ITFp5GwqlZirDIMPSMbEcD9/6wuwI+/BfY1tTfyuuiaClNpgWfUdzdVT9xt3jpOLS1
         3cV4uSh9xj70toCTPivDkaVwPd4Y/M/5E2gZnUWims4cUFbbjHeAHCkb4xBasXRdTxBL
         az4KOZIA2LRtVMl+OfwVaMfzjK3e6TKVF2yZ9VQXid/kSy9yXPCNwCid/7L9a+76A2Lk
         1mf+2mnu0JUZdis5zmuJ/5oOjiYMCURwRCi2oBF3X9fnt7lp0gSxnWaeqd/B7rWWIzfJ
         HAmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683025284; x=1685617284;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tDK988EtJlhDmjNL6UBbDMauFcsTOZAKNQmY6wY6/TM=;
        b=SLqLC0FxxiKZFrs7FpAZbw19WZ9vw5k2HrPotuietLJNLq09Z/y5GbzsKEr90azyIA
         Y5SiFW4CHIGk+zxD/gwdrpH7Q9l7jJseeWMTjEG4wQjZxUJa19rsOHlrk7SjMS58wAOd
         ZuFFk+U1RPAtdNr4QByczD83PjzemVsLJiK+cihiPEWLuTxfQimdaYkwsmB+gpmXaQ4T
         +GPms0Y88piM+o2FNRa/CruCBTPnYBYCJxqEldZSN/Az40/Jfl9sBdKEw2cZerg3aWNg
         J8SLJsAEDfv4+aHx56l1ho79e+mls1GXV7NUO/nZlASupFZJ9/nVvlDfPaQUvN2tw7Zn
         PIBQ==
X-Gm-Message-State: AC+VfDy6HfstPWw0+8qjYaEqgXcNmT3o7dywfUa/YbTa/RDqySUgXbnJ
        yuDlSx1FJ69IJ0oNh48MxIe5JA==
X-Google-Smtp-Source: ACHHUZ6gesEZPoPVuCPki3ssQZ2gGq8cUlysVxt4PpLE3b4nGS/aNYEqdkSPjL9Wk2HgQcZUTxj2Jg==
X-Received: by 2002:a05:600c:b49:b0:3f1:82d8:8fde with SMTP id k9-20020a05600c0b4900b003f182d88fdemr12593915wmr.24.1683025283999;
        Tue, 02 May 2023 04:01:23 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:ad29:f02c:48a2:269c? ([2a02:c7c:74db:8d00:ad29:f02c:48a2:269c])
        by smtp.gmail.com with ESMTPSA id l18-20020a05600c4f1200b003f07ef4e3e0sm49592872wmq.0.2023.05.02.04.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 04:01:23 -0700 (PDT)
Message-ID: <56514099-ff90-c035-dc8f-5fcd4d153ffc@linaro.org>
Date:   Tue, 2 May 2023 12:01:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v2 2/9] target/loongarch: Define some kvm_arch
 interfaces
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        philmd@linaro.org, peter.maydell@linaro.org
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
 <20230427072645.3368102-3-zhaotianrui@loongson.cn>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230427072645.3368102-3-zhaotianrui@loongson.cn>
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
> Define some functions in target/loongarch/kvm.c, such as
> kvm_arch_put_registers, kvm_arch_get_registers and
> kvm_arch_handle_exit, etc. which are needed by kvm/kvm-all.c.
> Now the most functions has no content and they will be
> implemented in the next patches.
> 
> Signed-off-by: Tianrui Zhao<zhaotianrui@loongson.cn>
> ---
>   target/loongarch/kvm.c | 126 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 126 insertions(+)
>   create mode 100644 target/loongarch/kvm.c

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
