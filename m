Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7336DB8D2
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 06:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjDHEZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 00:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjDHEZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 00:25:51 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FC7CA22
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 21:25:51 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id q2so5352787pll.7
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 21:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680927949;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PXCwDtr2uHzOCiDI6gx9ciDRk0+XSVPCl10fYBMrOZU=;
        b=ajc5KDjyqXmm3NUhwaTQfNt74Vh03C8A4QjJBsHhqpatOEHjIwrsnnsJeIV1mR4Q//
         IH0YOeZ/wRmreO2AyYzmeyJuhK4a6Ljm4vkvshnwFkSu++QDSSNkcr1mYou8eymOKNTK
         w786J7PWGGOOgTqhO2r20p26oOpmjkka4g434lWGOkcRHf0lWcSAZ4Ucf+lH5lPKTUC1
         6/h8tPD5w6rtPylQwXgYWq8OwBkeRZWmcZK8oSylz77qxoRqauLmZnakWNVN//mmkUBs
         PgAZXndCQqApDyeml0rj84fIz0mO/XpJ+yqvRosXHibT0pibUfgwKQSPUhd4KFp4CWUG
         uqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680927949;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXCwDtr2uHzOCiDI6gx9ciDRk0+XSVPCl10fYBMrOZU=;
        b=mR779hZ0x+dST/ggRHGgR0drB778IwQ9sCjUd72DcgG62lYEKIVBXptn/JqLqBqagY
         ell+Fc0N502nxDIRWyAo3Nu6L3K9P4N/wrTKV1In2KYk1Mp51YreML0aiaM7vYEF/dZ6
         vNEE6YUTw2DplAWDfgLIFjyilTw848C1uR8GNmCJgDvJ0p3P1Hl+dDWTN1sD+v6T3Rwx
         LfGpgKohlCJsYQubru0xTDGTMiKnhpcRrai/IrZOe9d8jZmv9iC8lt+kC3CuQ0N7h9Bl
         hsBpbhiOQVYO0+VCrDvS9+Jo34QSQODCYpqaxaJlUNPgH6Z8acX0zvNu8hUpasEcFBqJ
         6e3Q==
X-Gm-Message-State: AAQBX9fPfO6/unVr0KsvPQT+CMvkgqTtHmm5Qo26LkAeFGDL/j577wnV
        D8yGNDAIaTOpQo+/r2yrY12CWg==
X-Google-Smtp-Source: AKy350bDO0xahEhFC+PBYeLvGOB3qgL/GrI8UhnYhnHZrwNfuMLU6DzeTNpPUrbd5lsuyvBPxO8WQQ==
X-Received: by 2002:a17:903:2452:b0:19d:1fce:c9ec with SMTP id l18-20020a170903245200b0019d1fcec9ecmr6359202pls.37.1680927948795;
        Fri, 07 Apr 2023 21:25:48 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id a18-20020a170902b59200b0019f1264c7d7sm3631549pls.103.2023.04.07.21.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 21:25:48 -0700 (PDT)
Message-ID: <c7be234f-331f-0dfe-3fd4-04896c094680@linaro.org>
Date:   Fri, 7 Apr 2023 21:25:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 07/10] target/arm: Restrict KVM-specific fields from
 ArchCPU
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-8-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405160454.97436-8-philmd@linaro.org>
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

On 4/5/23 09:04, Philippe Mathieu-Daudé wrote:
> These fields shouldn't be accessed when KVM is not available.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   target/arm/cpu.h | 2 ++
>   1 file changed, 2 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
