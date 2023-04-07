Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7CE6DB6D8
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjDGXIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDGXIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:08:01 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F86AE054
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:07:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d22-20020a17090a111600b0023d1b009f52so2517028pja.2
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680908864;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wgiL/ifYNfwo++KDFPg/Dio8zORaAFAk5bB5YtGhmQk=;
        b=MEGGWwlxDpwujW+GajFwMICW/+ZkQuiv23sCYl3JUT/QGW1SCye8aT/VwuveZyUz00
         danOwxCDQO8rPdclT/eLT0VCKJMmNVgE8cYX5i7MRWsQ4coyPuqnScvQZwZTRvGxdYvC
         FhJkRJCGIWp5W6kFxgNUJaKiGOLx9njvZfXCvRgcLvuhm7FACslFqNbhm4hJWCgiDvo2
         7hWTApcGKjnMgABAvptKlm34znz02qQ8vUOi0oekStr3YQbTAa5sGe+i21fWdcw/Aq1j
         c4DzqVmZej5HD6YvnXJJwa+uihhiloPCbj7INDw5KTL3mAU/KBhEKOkI7ZdD4FMRBbcu
         Juyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680908864;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgiL/ifYNfwo++KDFPg/Dio8zORaAFAk5bB5YtGhmQk=;
        b=YzG+WHYqXI0mGJXY3cl3EYPPsS1hBaZwkNEQqymYChkBJqSF0Ol7iYywyVINKMZc5z
         Qy3CVVzypSby3zcUOPQLZRAQkE4ejBpnKgmAZFP3q2g0p/pE5Yx8Jd0l08R1wdH/EQHe
         /VQ8t9xMxg7BSPMEZgbt268PAGSuv2ZGi7rMDGpXWdz7u7QJ3BnmvTt36vlkO7jSZUhf
         oDshbJh1Ga2KMtUXf+0O6tVl+N+7Llkiq52K6078ec+lbWi1N/KwL0ieYHbzF1YbYRla
         fElqXKe7FoMS9WNs51PzTYDRTWbzw61wSLOeo8Q75QvOn2vA+I5nAJ1hy2zgeeJmOk2E
         8gCw==
X-Gm-Message-State: AAQBX9eYhMd6qwWG30u5YrZUlSDZH03+zWWdBYLaCYOXlo3j5JeDwfSg
        rn/oZtUcmgmkiBrv6IbAnnj/Fw==
X-Google-Smtp-Source: AKy350bXcZjgyQUuRpp6nyP3eJ+x1rlN/eQIhLU/UutS8vew5xsari6fdOQWku6HCBWiasGwTXkzQw==
X-Received: by 2002:a17:902:e5cb:b0:1a1:e112:461c with SMTP id u11-20020a170902e5cb00b001a1e112461cmr12302648plf.30.1680908864146;
        Fri, 07 Apr 2023 16:07:44 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id p2-20020a17090adf8200b002465e66256asm1238484pjv.11.2023.04.07.16.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 16:07:43 -0700 (PDT)
Message-ID: <a3c36603-6fd0-b093-0e8f-97e15b8e6bc9@linaro.org>
Date:   Fri, 7 Apr 2023 16:07:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 08/14] accel: Move HAX hThread to accelerator context
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>
References: <20230405101811.76663-1-philmd@linaro.org>
 <20230405101811.76663-9-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405101811.76663-9-philmd@linaro.org>
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
> hThread variable is only used by the HAX accelerator,
> so move it to the accelerator specific context.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/hw/core/cpu.h           | 1 -
>   target/i386/hax/hax-i386.h      | 3 +++
>   target/i386/hax/hax-accel-ops.c | 2 +-
>   target/i386/hax/hax-all.c       | 2 +-
>   target/i386/hax/hax-windows.c   | 2 +-
>   5 files changed, 6 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
