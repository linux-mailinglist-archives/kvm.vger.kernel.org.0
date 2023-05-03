Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4AF6F500E
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 08:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjECGYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 02:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjECGYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 02:24:36 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF75F124
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 23:24:34 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f3331f928cso28951915e9.2
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 23:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683095073; x=1685687073;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YfFildxBMpyq5zcylzz//tcc/bmJbaXiOpvSUc58CgA=;
        b=mqL5LZH+CuMQeIuK0FoCjG+y+qmXd+h2sXBjoPTPrFant/sy+vjN+/IA/zyM3McZq2
         v/3VCrpNCxcSztl5SPp7KWJ24ob7O226stsps57p5IHr6c/Dp45VPQiNcILyBBcIu6V1
         ANdANKDii0lqOJigjFbWb9arNSTUC4rFCLdKDgCGses8wAiHLd5kLLPfLNYvHb4AupQO
         cCIapGItCUW1o+zI7NaXnY15vIijlzx7Et+39tdzaiAfH3BeE/CxRbWU3NcnPe8fesMX
         gNS/e7pT/QRLpMDLH9z7AXyqvWwn7rlWiT29+Ioh8aZxbUARqqFks/0+klyhzDXTQGWQ
         o9QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683095073; x=1685687073;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YfFildxBMpyq5zcylzz//tcc/bmJbaXiOpvSUc58CgA=;
        b=k4CXeKdf1dipcwFPoOzmiTqfsSmtEq4ewYr2TeEL45N1JnvjTaP0O+aGc+2B27C75W
         UDUPyu4fmkiBF590vVN4fyY2DYjOq29IWgHkojNax8ziOBUoGHQVTDSABmcss38c3qeC
         7KaB9AmIPSAfZzg/YWS/5APO7cGckNLYFxOaZq7x9qnVsc9wH1cxrQ79Kyc20F7dX0bX
         Q9ij1wnq9XnviLmrMXDemeLFlUGT3e2OHjVWhV/w3jvOolaX1p7fcG1n5r0ph6UqgHCX
         +F786bppR3B+R+Gbb1/79Y8ZGH/Yfg0MEOmmUSWuJxzM9UB5g1aKE3j7j+IcL4ca9n3O
         IFVQ==
X-Gm-Message-State: AC+VfDxjkVmGyXEgA2bX2iWvmDTZARLshGpuaaJVMwevx3l5hv/8XSYu
        PBX+ZA2VQFxDc6X9xfNg4TsowQ==
X-Google-Smtp-Source: ACHHUZ7hNRvG41CVHftzmhl0RAqNI7tpiFjPTlCngAl4duPbpNo6fvH65JwNaPEia6A5DSbrZ7ciXg==
X-Received: by 2002:adf:f68c:0:b0:2f5:6430:35c with SMTP id v12-20020adff68c000000b002f56430035cmr13449366wrp.26.1683095073446;
        Tue, 02 May 2023 23:24:33 -0700 (PDT)
Received: from ?IPV6:2a02:c7c:74db:8d00:c01d:9d74:b630:9087? ([2a02:c7c:74db:8d00:c01d:9d74:b630:9087])
        by smtp.gmail.com with ESMTPSA id x9-20020a5d60c9000000b002fbdb797483sm32476315wrt.49.2023.05.02.23.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 23:24:33 -0700 (PDT)
Message-ID: <f0195c0a-af05-a78e-6158-635804be82c1@linaro.org>
Date:   Wed, 3 May 2023 07:24:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v2 9/9] target/loongarch: Add loongarch kvm into meson
 build
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        philmd@linaro.org, peter.maydell@linaro.org
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
 <20230427072645.3368102-10-zhaotianrui@loongson.cn>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230427072645.3368102-10-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/23 08:26, Tianrui Zhao wrote:
> Add kvm.c and kvm-stub.c into meson.build to compile
> it when kvm is configed. Meanwhile in meson.build,
> we set the kvm_targets to loongarch64-softmmu when
> the cpu is loongarch.
> 
> Signed-off-by: Tianrui Zhao<zhaotianrui@loongson.cn>
> ---
>   meson.build                  | 2 ++
>   target/loongarch/meson.build | 1 +
>   2 files changed, 3 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
