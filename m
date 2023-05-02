Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A49B6F42DA
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 13:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbjEBLcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 07:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbjEBLcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 07:32:16 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F3759F3
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 04:32:05 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2f55ffdbaedso2170712f8f.2
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 04:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683027123; x=1685619123;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2udM7iT2FK/xKY6scpis0aY8W3CKijk9hrNehfmY+b4=;
        b=L9a/845RNZ2P2uXDb8WOfz8tVd6yv5Dm30DdAUrJhu6BHhzKZwvCYG62LOmtItibWF
         RibVP8DTjxxr2aoY8B5atIXi1D0oPmU4DKuJSWlo31xlwYAkD8zPSs+QmVWFbqOyZ9lv
         PWCyPANioCDBO4ur1DWdeYy5Gd1vR2aD6Hu7/COf2H8JsCmo6f19bWbeRekEbpIj8GbI
         cSx3p3VT+XNBECm+4PwGcSNq3ifRze6UAQSYaG3aloHzGmjvb0o0HZz9+LetVQ9wvdhj
         kqIa5GBxMSuw2gW8TQCxhPjGgzMz8DeB1StwP0qrdly+K7TElLCsrBaZ57X/2JZlH77d
         cmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683027123; x=1685619123;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2udM7iT2FK/xKY6scpis0aY8W3CKijk9hrNehfmY+b4=;
        b=ZGjl5riP7VrS1tTeIIaHp9x4e/KQqbSBp8Tt+GQKpfHgc2aKoEz2aiLvNS0GGJHlUj
         vX4HxQlmqmjp4CFuKN2fCnG6WFoaxnGJ/wlPszIeWI8e4KjWn7LHR6yRnOmVFflUPChR
         0YxZvtNjDDsk7Q/3X1WPW3AaS2GsT8ZtdeKvV4Nyk/XvyF4g01sDpgK5OMGl9JSfuZ+P
         X1sIJVmUs0rHwysbe2SHAkCkSD6rM7pdhPCkqiFM0IZ/NkBkwLRZTSkiYk3QIKBjyxXB
         uv9jqDnhGKK1sCrzI/FC81XTWtKu2Kp/3yZHPtHUx7prSizlmQhdxpSImr/PzRjjJmvq
         Hfsw==
X-Gm-Message-State: AC+VfDzcO1NPtUKR/XUxsoh6KLjlgAZnxAI3lcREAqpFPFZXbyvJwnyt
        DBUvCaXjtpD/N+AEbrdHcoXo9J28z6Mus/kn0ept4w==
X-Google-Smtp-Source: ACHHUZ5pkhxlg/Qm4klnh5IieNsEmho/mBWndSGXjRzounKuhmZ0DSuLs/MARrcYAWz28eLgK7S+sg==
X-Received: by 2002:a05:6000:136f:b0:2f0:e287:1fbc with SMTP id q15-20020a056000136f00b002f0e2871fbcmr12300259wrz.11.1683027123438;
        Tue, 02 May 2023 04:32:03 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:ad29:f02c:48a2:269c? ([2a02:c7c:74db:8d00:ad29:f02c:48a2:269c])
        by smtp.gmail.com with ESMTPSA id b1-20020adfee81000000b002ca864b807csm31087589wro.0.2023.05.02.04.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 04:32:03 -0700 (PDT)
Message-ID: <b06d5e5f-468e-f923-2184-b3776d3892be@linaro.org>
Date:   Tue, 2 May 2023 12:32:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v2 6/9] target/loongarch: Implement kvm_arch_init_vcpu
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        philmd@linaro.org, peter.maydell@linaro.org
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
 <20230427072645.3368102-7-zhaotianrui@loongson.cn>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230427072645.3368102-7-zhaotianrui@loongson.cn>
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
> +static void kvm_loongarch_vm_stage_change(void *opaque, bool running,

Typo:                           state

> +    uint64_t counter_value;

I know naming is hard, but this is so generic it is difficult to determine what it does. 
Perhaps kvm_state_counter?  A comment would also be helpful, even with a renaming.


r~
