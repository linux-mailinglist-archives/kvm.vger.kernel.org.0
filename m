Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C936DB70A
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDGXOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjDGXOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:14:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F2BE070
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:14:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 20so1941828plk.10
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680909246;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZEtxxHTBPYDx1m8Q5UryyRdPATKO4VY3g+smnvxOwf4=;
        b=con+E+nBuUuL8bc6aBTNFmZw3A88rUFZYxGTFhDreXq5RHJZKuVoYlJBjJANRic/qc
         d5s0aIniIw0RL+malEGtEBMEHpe94GQp29//JHjND3LOTt2Qz6neACI5ima/6Bs8ADdA
         yo/JWYahYMsh7ErPLucmzyNckoeMuF0c9x1qrf9zMQmx6Bnh5MEN+0uiyAhmVmsWPJFI
         pWVaQ9k2ZnUgguA6EPAKVUUEzJY96hKZT4/VabPIIz8klAbW+JC3mY3jjRBuLk3fSGy5
         mfIp7D/2faI4Ti1BgkVfeheIv0888nglBVVCpOLVsdTkwhfsjv/mG9K919FmrAqv8UV4
         NPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680909246;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEtxxHTBPYDx1m8Q5UryyRdPATKO4VY3g+smnvxOwf4=;
        b=STLZZc0KLYXDLbzgYL6vgq3LUvq9xTNx3ZGQvRN0xHUSVhqeEXxz/Y/nwCpkk6FAtO
         CswHjbLLaG7/ffI8EykT7eolXnt7frXwk1F9zhREqt5GK2TjDvSKDkPcbqP166QXh4GS
         aHo8nkkqdJMmO4oDKTq0+SuKZDFI1Q2+pJt8gv7lEfUuyWt/A9zuyNsrAgPfX1fW0SbF
         nKQDEUzN4Cjygwi7QMtCq4uQ8XSOWBq/AbWunLP0aIrA9T2mKyvQpeYSKRYlk8osdD2U
         4xHaMMzhzV+tqKr7h2nxGuoroiak8tEFaXjUIY1hgYnBqgyYCp9zyaH2fIW4LGVEl0TM
         6rEg==
X-Gm-Message-State: AAQBX9fN/32XID1oMa9P67vjGpglvUk0n4hn0/4Vm5yq7WGe9KM8YYRb
        M4rx+v4f5GZYhmW94Bwqh/Cp3A==
X-Google-Smtp-Source: AKy350aI+71oWAmO3OSiaf8U410Jg/WRlz+R9/yR6IazGZ/MKyDHhEtyo9+noerB1d8Pc0Zo6Qu0ww==
X-Received: by 2002:a17:903:183:b0:1a1:e33f:d567 with SMTP id z3-20020a170903018300b001a1e33fd567mr5603426plg.52.1680909245863;
        Fri, 07 Apr 2023 16:14:05 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id jh3-20020a170903328300b001963a178dfcsm1477074plb.244.2023.04.07.16.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:14:05 -0700 (PDT)
Message-ID: <e2687d91-85d8-d11f-4cea-c7363927cb9b@linaro.org>
Date:   Fri, 7 Apr 2023 16:14:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 14/14] accel: Rename HVF struct hvf_vcpu_state -> struct
 AccelvCPUState
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Alexander Graf <agraf@csgraf.de>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-15-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-15-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/23 03:18, Philippe Mathieu-Daudé wrote:
> We want all accelerators to share the same opaque pointer in
> CPUState.
> 
> Rename the 'hvf_vcpu_state' structure as 'AccelvCPUState'.
> 
> Use the generic 'accel' field of CPUState instead of 'hvf'.
> 
> Replace g_malloc0() by g_new0() for readability.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/hw/core/cpu.h     |  3 --
>   include/sysemu/hvf_int.h  |  2 +-
>   accel/hvf/hvf-accel-ops.c | 16 ++++-----
>   target/arm/hvf/hvf.c      | 70 +++++++++++++++++++--------------------
>   4 files changed, 44 insertions(+), 47 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
