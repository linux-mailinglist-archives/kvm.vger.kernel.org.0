Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45026983FA
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 19:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjBOS6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 13:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBOS6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 13:58:52 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC703A8D
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:58:51 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id fu4-20020a17090ad18400b002341fadc370so3233539pjb.1
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 10:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DIzl73kWeau48qZetvSUfvzRavavSKB2PkPmR3lHSR0=;
        b=gpS0+bAlt07kUA2ZJu3EHfEZiqEdL9GHj0G9nj/1k1H2FVSkJRZuvluWkOHtDfgWXA
         pNNVPj8mxHb8NpaeVrELFBp/qKD2d7Fz/1DEiIHW33VmiISjORmVUHLtJ5bJyZdee9w+
         nZOreT7pchwSFN8y5wfbyELYwifBE7yHRV+gyjR/beTQGY2Kz/SsfPGazOOYtuM/CYu3
         d0zGx0ciXqOpSIU3xR6g1XgAdor8XFciIYsGqVublirp2CXuXn9zSPhkuiXrQwdprwCY
         evJSdExQFhlGtT2Ezbf6NeUYHXb/r0GMP8436XQIkb39Qj9g/Z2aDLDr57h6N3d//RUx
         cRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DIzl73kWeau48qZetvSUfvzRavavSKB2PkPmR3lHSR0=;
        b=OzF3+K3SxMXmLgSJ25Ks8c0iyZtQz7W0Sd1p7VEz+A8MlEy/CKWMe6A3ddhtqxHxiX
         kzLXdkGhtWEYQy8VlkDClq0a2Np18OaYZboi4k8I7A1Yjht2bnItDDZr7VrYr27BRgpu
         EEoXYb2hQiU1d6wuSmG4kZnXF7eiE24y+kBdDXT11C7NjWAQ0jYKdg2kwiFXC/yNuqgR
         SFHPC2vEwlpdj1Mlh4TCaAf7ZmFP+UUrFxv7OH4e//Ow/L3VNAMr50o/OEa67cj3k0v5
         lWC2/jm4rVFaKlSxwwY8J/rLvrBuGr9lR+34PZw659MKq0Nrqsjgl48AuoGW/45ZmwHe
         MXZQ==
X-Gm-Message-State: AO0yUKWXR7srO3rJlsXjRxrHzlobDSLwzCKZpkd1Q52ybaJDhmj2Aigy
        cEdPqJNK0DtIA/X0a/n76X003g==
X-Google-Smtp-Source: AK7set9DgLZTB7rl27KwrKxYRsqpYkeWHSRsybyUUeUy1CMe0Y3BPYePiN+A4A69zLPw8zMJAGsXiA==
X-Received: by 2002:a17:902:e803:b0:19a:9890:eac6 with SMTP id u3-20020a170902e80300b0019a9890eac6mr3545315plg.24.1676487530903;
        Wed, 15 Feb 2023 10:58:50 -0800 (PST)
Received: from [192.168.192.227] (rrcs-74-87-59-234.west.biz.rr.com. [74.87.59.234])
        by smtp.gmail.com with ESMTPSA id y23-20020a1709029b9700b001991d6c6c64sm12457017plp.185.2023.02.15.10.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 10:58:50 -0800 (PST)
Message-ID: <24dae4b6-3af4-de73-7ffd-cc6613e3f2c7@linaro.org>
Date:   Wed, 15 Feb 2023 08:58:45 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 3/5] hw/i386/pc: Un-inline i8254_pit_init()
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20230215174353.37097-1-philmd@linaro.org>
 <20230215174353.37097-4-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230215174353.37097-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/23 07:43, Philippe Mathieu-Daudé wrote:
> pc_basic_device_init() is the single caller of i8254_pit_init()
> with a non-NULL 'alt_irq' argument. Open-code i8254_pit_init()
> by direclty calling i8254_pit_create().
> 
> To confirm all other callers pass a NULL 'alt_irq', add an
> assertion in i8254_pit_init().
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/i386/pc.c             | 10 +++++-----
>   include/hw/timer/i8254.h |  5 ++---
>   2 files changed, 7 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
