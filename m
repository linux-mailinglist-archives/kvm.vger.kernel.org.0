Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C768A777470
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbjHJJ2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbjHJJ2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:28:20 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E6A3A97
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:19:29 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3fe5eb84d43so6098205e9.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691659165; x=1692263965;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wok+Pb9fiOkZwEwM1AKW0JzsbHPjqCpjF/vuHCX2Jds=;
        b=xCpHOCI9wSYk/oK5s2Gf07WLLu/MZ/7xbbGChV1cmi4d6A3Mbt7dD7d1XFeYZp0sI0
         EoTlVfzmidlBdU/NNaGCMkr+wI/hh2S+UeZ9pgcnd8sVuWaZfYseiH66lnbR72kxZ+x6
         vgQnEbVSlfhgDzLUpXemwKdvDQODnzvi+IxFkP5IExDDTBvWZNywAvoQTEu9hQSP16Zn
         QPE/onzWoU/9VsN+XGXdByMJQXb7ktgAs6kHz8xI/B3CmQxOh/pE5NltRsaQohWc8ImN
         spRTE4kFIRY1D+/8ELP8u+48TFGuewhcyMx1VF9w8fvLz8QIcugpNAFb+vc3BEIOGJ9e
         Pvmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691659165; x=1692263965;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wok+Pb9fiOkZwEwM1AKW0JzsbHPjqCpjF/vuHCX2Jds=;
        b=dvVGITgoFMUUXNj0lfSyILnyEDb5FoCoIsKYVm5r/QqApY5N/GxpRDlmqwcLCE2mXa
         LLec7bhedyPB8N+44gIQtJ5iCEFCiVj4UxAbvew/xvFLxDIRPNLxY0qRNygu7vAXNy9R
         EbI7x4YW4UTOqRKLklwCtbBJF5a+ANRYIrFTpT/CtkfDLzM3Oie/UFOtqnHVGX4NMY0y
         gM3vOoTkC1cbTVx3T6tVsB+Oau9xW8a5Sqr6NHCwywbVgrx68BGDwicw91RvRhtByAe0
         04BU2ScJNqTdgssVeFs0QlM4kOnr16n+QgqvplRJ0aJMvFqSqnVJjnZqEh8prlIForiv
         6lbw==
X-Gm-Message-State: AOJu0YxWyW4+va18z0YD5UsjBRA74LOSnxAomNaYgL9n2jbLnAdRj6j4
        HQSmh6Zvjzi2T2kDa4WOMnCG9Q3WTxwZWVmC1VI=
X-Google-Smtp-Source: AGHT+IE362b2UK8VE7RTczunKk4zqBdLbV31VFFDAuFXwcp8VaZT9hDI/K29iqBr27EqdeoAqP89Lg==
X-Received: by 2002:a5d:5150:0:b0:317:618a:c72 with SMTP id u16-20020a5d5150000000b00317618a0c72mr1748150wrt.64.1691659165318;
        Thu, 10 Aug 2023 02:19:25 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.158.65])
        by smtp.gmail.com with ESMTPSA id i8-20020a5d4388000000b0030647449730sm1499723wrq.74.2023.08.10.02.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 02:19:24 -0700 (PDT)
Message-ID: <509ea8c8-a9bd-ca90-ee07-832039a5bd25@linaro.org>
Date:   Thu, 10 Aug 2023 11:19:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v5 4/6] accel/kvm: Use negative KVM type for error
 propagation
Content-Language: en-US
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20230727073134.134102-1-akihiko.odaki@daynix.com>
 <20230727073134.134102-5-akihiko.odaki@daynix.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230727073134.134102-5-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/7/23 09:31, Akihiko Odaki wrote:
> On MIPS, kvm_arch_get_default_type() returns a negative value when an
> error occurred so handle the case. Also, let other machines return
> negative values when errors occur and declare returning a negative
> value as the correct way to propagate an error that happened when
> determining KVM type.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   accel/kvm/kvm-all.c | 5 +++++
>   hw/arm/virt.c       | 2 +-
>   hw/ppc/spapr.c      | 2 +-
>   3 files changed, 7 insertions(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

