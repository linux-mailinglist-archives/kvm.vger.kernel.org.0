Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914B562EE71
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 08:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240943AbiKRHc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 02:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbiKRHcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 02:32:39 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921407EC8F
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 23:32:10 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id bs21so7925364wrb.4
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 23:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8bLCpAOEeaJ/eFrFFUhxvhWsOOXuLPUrFWAh3K1PwNU=;
        b=Q8IVKjDdyp+kzQ94ux6/akduMBeTGFYpGKiE86h8IThnc752o/QcZq9YaBCg5Y/Ank
         uSRIwEpJsZ0zzmQr0YJ0TunWdVTudEwCO4IO80Go3akEJ5Sz9RAJg/hTqd72/ZxPLPb9
         R8flmPuE8L3yGO1NYf9TzJKmP2rC3+wewLMHhfte4MZEH4NdOjRPdMSBzyUheIKrm0rL
         MxOmY61UM6mkPEpEItRhBCryYyXUH+jx6v1KcuecKiFFRjXRwrHTmA04XSB3ozrFMk01
         rziRFI9PbLOKWE1QFpOw6wzLAne/N2dlY064DhidGXH47zr+Yl2/gqDqk5/YxKSC3skj
         dVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8bLCpAOEeaJ/eFrFFUhxvhWsOOXuLPUrFWAh3K1PwNU=;
        b=spBHqbQOIGkCXunBKOr2oq1TqejO5dLKG/0l/jMkkKepAT4RXtcSBMJBRZvgJ8j2U6
         ACrIL9GaZ6KYiv0NiUEif4KMpeniZpjOWdltOghu9u8vDpusAou03H3y5io1loNGyMKq
         GEIhHOai4hKqgfDbItg3PGZMP5cTQrU1KbfVaNlZX1aVU56R5lEffBD68DKeA14Jba6h
         USwvDZVfHhxsUfYRdzuYNOtBQvkd1MUBwD/jlrjVt6Xw0x+oVhmK+jhI7k+hFcYQN4Tj
         0BS5obRlrOgBGjz3C919YKqkRooZb5ArIg4ScXtVnkrMM+9NMcr5m3kB8fJS4P+VlpOB
         f9Cg==
X-Gm-Message-State: ANoB5pkXDYrpv5vEKmNT4ICZBra+RSf3baV3h+yi7s9aVly6guZ/nOsA
        GF9L8wAIXlL9tMp7J5dKUaHn9XUoywVHnQ==
X-Google-Smtp-Source: AA0mqf5CfgufJzxihB5k7dwfOdwceuc6wKQ+Rw7vbZyDUgA5a3rzRkoygZG2XBS5CTgdhypbY70Qwg==
X-Received: by 2002:adf:f54c:0:b0:236:ba68:7fc3 with SMTP id j12-20020adff54c000000b00236ba687fc3mr3473429wrp.223.1668756729115;
        Thu, 17 Nov 2022 23:32:09 -0800 (PST)
Received: from [192.168.230.175] (34.red-88-29-175.dynamicip.rima-tde.net. [88.29.175.34])
        by smtp.gmail.com with ESMTPSA id o3-20020a5d4083000000b002366e8eee11sm2748900wrp.101.2022.11.17.23.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 23:32:08 -0800 (PST)
Message-ID: <e8e6fce8-9912-7684-d4c3-c30d731bfcd7@linaro.org>
Date:   Fri, 18 Nov 2022 08:32:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v3 1/3] accel: introduce accelerator blocker API
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org
References: <20221111154758.1372674-1-eesposit@redhat.com>
 <20221111154758.1372674-2-eesposit@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221111154758.1372674-2-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/22 16:47, Emanuele Giuseppe Esposito wrote:
> This API allows the accelerators to prevent vcpus from issuing
> new ioctls while execting a critical section marked with the
> accel_ioctl_inhibit_begin/end functions.
> 
> Note that all functions submitting ioctls must mark where the
> ioctl is being called with accel_{cpu_}ioctl_begin/end().
> 
> This API requires the caller to always hold the BQL.
> API documentation is in sysemu/accel-blocker.h
> 
> Internally, it uses a QemuLockCnt together with a per-CPU QemuLockCnt
> (to minimize cache line bouncing) to keep avoid that new ioctls
> run when the critical section starts, and a QemuEvent to wait
> that all running ioctls finish.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>   accel/accel-blocker.c          | 154 +++++++++++++++++++++++++++++++++
>   accel/meson.build              |   2 +-
>   hw/core/cpu-common.c           |   2 +
>   include/hw/core/cpu.h          |   3 +
>   include/sysemu/accel-blocker.h |  56 ++++++++++++
>   5 files changed, 216 insertions(+), 1 deletion(-)
>   create mode 100644 accel/accel-blocker.c
>   create mode 100644 include/sysemu/accel-blocker.h

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

