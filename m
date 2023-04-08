Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0836DB8C9
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 06:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjDHEXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 00:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDHEXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 00:23:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8DECA0D
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 21:23:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id ik20so350701plb.3
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 21:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680927830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hiiQLOUpmXBWuKOn/UUWqBuRStVCeUARBOIRt8dw52c=;
        b=lkvzkcFYRPQ0/XRKi7u4dhC39xUYN7uK5T2yDMgb5v34yfuCuc82zpr62tb5Z+70Di
         4mQt4nvdDU4SXxu1Svl13qFdJ+FbMyvaOUwEWe0+QLyMy9jVY1upxIetr/DlUwJ02Fuo
         R4Q3DYpD7+CfNZoup1nyytlKQAPrD9g+WCNXUyd5F/z0rD9afMC9cRBlEewVFan4437N
         AS0YcMly8nschlUTyOtDZCejRtg1S5YnhS53wL8t3am51bp3Ekfdh6O5KUQ3ZhwTr8AM
         jvCmb1oMSWg/bGT+zWJx/uJrsJ44J6SQ4cauEDI4e3t3tZLxIU2zY5+aGAVjeJ3JyHWw
         WzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680927830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hiiQLOUpmXBWuKOn/UUWqBuRStVCeUARBOIRt8dw52c=;
        b=yqQVZySWsvkQwALxAg6rtlO3fF4s3gR6ThjE0NvRS49afM0rXRSDCVe/x8sv8rRlLu
         djeMDfbszS+y9MCPVp02C36VzHfW4eGRfog1CjU0EYE0lTyDMhWQdij188xqUnNirjfG
         du+CqZd0KvmMuS0snNs5scTkEfXQaINP/py28D6ZHdGmhTQkEURNasRMu7WPMd0/MGzT
         XzfqypSqHG1BT6cCF5Q9KUhovA6Ajraoh5yFcFs5Ly4Clk4kX1Jhg4/rDPzzYulRNngj
         GmQLPNaYGnTIV0fb/1LEjw4g1niofT938AbKdQ8nhvp7hwd1Tmq6MsnR7uZOvxprqOvv
         kzhQ==
X-Gm-Message-State: AAQBX9fev9S5c1FmJMEPnV3RYdc1p0IqLpvIlSjlocMG/mglgbGRcJ4a
        Hk97QuJBGbrZV9m49ofUrG5e4Q==
X-Google-Smtp-Source: AKy350bxSubZkDnaLAgaaFFf8QyqWAXH0GhCoxrxaORXlZzZG86iODTY6N0YjkS8zhiOSfi65CBBYg==
X-Received: by 2002:a17:903:2115:b0:1a1:b11d:6af5 with SMTP id o21-20020a170903211500b001a1b11d6af5mr611598ple.52.1680927830461;
        Fri, 07 Apr 2023 21:23:50 -0700 (PDT)
Received: from ?IPV6:2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8? ([2602:ae:1541:f901:8bb4:5a9d:7ab7:b4b8])
        by smtp.gmail.com with ESMTPSA id a13-20020a17090aa50d00b0023d16f05dd8sm2292970pjq.36.2023.04.07.21.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 21:23:50 -0700 (PDT)
Message-ID: <e6e1a695-1dde-4109-e0f7-cd1c9ff73af5@linaro.org>
Date:   Fri, 7 Apr 2023 21:23:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 04/10] hw/intc/arm_gic: Rename 'first_cpu' argument
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-5-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230405160454.97436-5-philmd@linaro.org>
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
> "hw/core/cpu.h" defines 'first_cpu' as QTAILQ_FIRST_RCU(&cpus).
> 
> arm_gic_common_reset_irq_state() calls its second argument
> 'first_cpu', producing a build failure when "hw/core/cpu.h"
> is included:
> 
>    hw/intc/arm_gic_common.c:238:68: warning: omitting the parameter name in a function definition is a C2x extension [-Wc2x-extensions]
>      static inline void arm_gic_common_reset_irq_state(GICState *s, int first_cpu,
>                                                                         ^
>    include/hw/core/cpu.h:451:26: note: expanded from macro 'first_cpu'
>      #define first_cpu        QTAILQ_FIRST_RCU(&cpus)
>                               ^
> 
> KISS, rename the function argument.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/intc/arm_gic_common.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

Wow, that's ugly.  But a reasonable work-around.


r~
