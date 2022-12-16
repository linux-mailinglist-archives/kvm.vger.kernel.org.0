Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE1E64EFD0
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiLPQyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiLPQyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:54:08 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3225FBBF
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:54:07 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1433ef3b61fso3937219fac.10
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ALASrqaA+0vtW+7Qu7yYlsMXewk1xO5ZXCiyRkfNZg=;
        b=h0RvfnCdg1ZLKMk3kvG1rAJ/mRcHePC1Y7PcG7/p955zonBq43U/9oRnqIOr8DtQKx
         6v+NcSy2m3RzByrkKz8LGpDlda7zcSzwrum8Kcn9jNvuRb6f1FkVyuuJoZQ2xLuoWdH7
         h3cbUBeXZTr/XTJinB7C24bRKzMFHFI3DGwyG4pTaRdsQfMGkirrZbW/yAWFyabSAfuC
         r2zpAjOGhpDL32jzf1OgLko9qSdZhenGAe0fdi/E34Lftw+gpH3eIKP6AvwWuT3XkB9o
         efxNWFRTGn+TibQOEF+L3fz9wDFoOf+19ex/kjFtT2sNLIGtEush1HHJ7tXUamU0UnHq
         pQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ALASrqaA+0vtW+7Qu7yYlsMXewk1xO5ZXCiyRkfNZg=;
        b=IVJ6ROMpdoDJSgHNNVna+U4THwyKI7t6Se8KK+ItNs7DUSkpa5z9hampxnsU06MDpC
         I1ECIXGzC5Bn+31uJlHc3iNWhY7OogjEflYDUlwKJUikDsZLg+2CsR8ETXEUxfK6FDOb
         rNf6x7OkBnveqEBEQ7S88UTzNlyNsazc0AVmnUS/f2UUjYT2r+cu9LY+t/Pzh89aqNXf
         +HzcRmcxr1D/zYcUYuM+awOEJGQjvACRl1BTof0geNtKJK42CHaFipdWfkOGrG0GhilE
         igYfuaz+/0nyp56reZplAyUxqDj4eg1OLVkLAXO7HMZz14SVeJaoDUVB9CojhOVuMrSs
         +t1w==
X-Gm-Message-State: ANoB5plMsCEIVDRHyydf+YAXOkTZxT/U5j2m6OBqFaBPMBTmkm8wokQQ
        aTlNiaUyPVUC66M+kCDOgAjcrERKL+0=
X-Google-Smtp-Source: AA0mqf7jxwaPGik7b4x79+qvSE+o/I8eXGU53qiyH9ijDZatVEvRTxjQJF4F4owVo/7tk957YIEx5w==
X-Received: by 2002:a05:6870:e8a:b0:144:87fc:f4b2 with SMTP id mm10-20020a0568700e8a00b0014487fcf4b2mr17785900oab.24.1671209646794;
        Fri, 16 Dec 2022 08:54:06 -0800 (PST)
Received: from [192.168.68.106] (201-43-103-101.dsl.telesp.net.br. [201.43.103.101])
        by smtp.gmail.com with ESMTPSA id m29-20020a056870059d00b001438fb3b0a0sm1104761oap.44.2022.12.16.08.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 08:54:06 -0800 (PST)
Message-ID: <b5e03afa-0ab0-8b8c-e803-76848dce9034@gmail.com>
Date:   Fri, 16 Dec 2022 13:54:02 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH-for-8.0 0/4] ppc: Clean up few headers to make them target
 agnostic
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
References: <20221213123550.39302-1-philmd@linaro.org>
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20221213123550.39302-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/22 09:35, Philippe Mathieu-Daudé wrote:
> Few changes in hw/ & target/ to reduce the target specificity
> of some sPAPR headers.
> 
> Philippe Mathieu-Daudé (4):
>    target/ppc/kvm: Add missing "cpu.h" and "exec/hwaddr.h"
>    hw/ppc/vof: Do not include the full "cpu.h"
>    hw/ppc/spapr: Reduce "vof.h" inclusion
>    hw/ppc/spapr_ovec: Avoid target_ulong spapr_ovec_parse_vector()

Patches 1-3 queued in https://gitlab.com/danielhb/qemu/tree/ppc-next. Patch
4 can use a few more comments.


Thanks,


Daniel

> 
>   hw/ppc/spapr.c              | 1 +
>   hw/ppc/spapr_ovec.c         | 3 ++-
>   include/hw/ppc/spapr.h      | 3 ++-
>   include/hw/ppc/spapr_ovec.h | 4 ++--
>   include/hw/ppc/vof.h        | 2 +-
>   target/ppc/kvm_ppc.h        | 3 +++
>   6 files changed, 11 insertions(+), 5 deletions(-)
> 
