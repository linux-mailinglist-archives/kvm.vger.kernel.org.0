Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BE464F265
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 21:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiLPUcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 15:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiLPUcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 15:32:23 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E13F196
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 12:32:22 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id vv4so8859305ejc.2
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 12:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zsJU7+qv99Qf7IDkCcA3nxZ5EeWP7uv6mPU0NhXKpFU=;
        b=t/sfPk7luqfZU60Zm6fc6I49cvcAgXoR4ipXoRtg5qgiQT9E8upMxxoq6nIjkdfIPY
         RPubvkjZmXwr6XAxWkYzzvF08dywyJS/iSmkKYwTEZ+bV3ZwaCeGNoaqy5sKXFRvyN7C
         dT1Zdr5SDLgh4l8b3XC9GUwEoBZCGtGlzHYUbI/jJgLgyU9RMqR2poN8NNGIPxGLI64b
         8KkIJxPkx2WIzgkoEu924YPXSEwYaHC4UUeAi6x25aCkeXsO+9bkJL+8kYNY8Q78DTw8
         z4NhqYHhJ4ozVBxcqUajMt/reve9P1PwKOciocyrchU6ZxwcZAWBrnauFtd7UbAoB+uU
         hV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zsJU7+qv99Qf7IDkCcA3nxZ5EeWP7uv6mPU0NhXKpFU=;
        b=44SITzZGHwP9sTfvcZRw3UJ7m8flxfQWWjSF0kuZ9s+sZ3CEmQumfmkVPu70P8Cj/v
         Nt6l5Cuh7T2EiPtIt7iq+IOqL764cgt6nnWyYvW4DquHTW1dFLnca1PotiycHYE3sNd1
         y51jf4Uk/aCQDf/u5fNvezcD85dS8QyXkhoUY2xSU5rlyNUy3F2TSMcb/HTcpoGFKoDJ
         yp+cXDjWBTIoumlh2hf7SdJO2FEH313fYqMllOXX6bQ7KuvfBbQvkQkSCT03+PYQbu6b
         kGvUcJI+ZqrIkyJ/6bdtyvzkA0BZzHuKfLnmwP6GYVPT3ntMuIeSyYC69LyxmjNs1H6x
         IF2A==
X-Gm-Message-State: ANoB5pmdD2nmHZXbibVcR+Re21KsTJllum/PhkTLfS/1+IrYkWXP3xYT
        /fUq+r/ZdJcNZievBiKc2v353A==
X-Google-Smtp-Source: AA0mqf6XPgoSukG/2yuoViSwNPzbE4LP8vSeGtOmiMO4y1j39HP3iLSAAUO3duOZOQS8ARJlsIDfgQ==
X-Received: by 2002:a17:906:1e42:b0:7ad:e52c:12e6 with SMTP id i2-20020a1709061e4200b007ade52c12e6mr27420953ejj.41.1671222740770;
        Fri, 16 Dec 2022 12:32:20 -0800 (PST)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id c15-20020a17090654cf00b00741a251d9e8sm1233027ejp.171.2022.12.16.12.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 12:32:20 -0800 (PST)
Message-ID: <6aef3061-cb81-bcb7-cad5-294e4cc88651@linaro.org>
Date:   Fri, 16 Dec 2022 21:32:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH-for-8.0 0/4] ppc: Clean up few headers to make them target
 agnostic
Content-Language: en-US
To:     Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
References: <20221213123550.39302-1-philmd@linaro.org>
 <b5e03afa-0ab0-8b8c-e803-76848dce9034@gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <b5e03afa-0ab0-8b8c-e803-76848dce9034@gmail.com>
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

On 16/12/22 17:54, Daniel Henrique Barboza wrote:
> 
> 
> On 12/13/22 09:35, Philippe Mathieu-Daudé wrote:
>> Few changes in hw/ & target/ to reduce the target specificity
>> of some sPAPR headers.
>>
>> Philippe Mathieu-Daudé (4):
>>    target/ppc/kvm: Add missing "cpu.h" and "exec/hwaddr.h"
>>    hw/ppc/vof: Do not include the full "cpu.h"
>>    hw/ppc/spapr: Reduce "vof.h" inclusion
>>    hw/ppc/spapr_ovec: Avoid target_ulong spapr_ovec_parse_vector()
> 
> Patches 1-3 queued in https://gitlab.com/danielhb/qemu/tree/ppc-next.

Thanks!

> Patch 4 can use a few more comments.

Yes, I'm not sure yet how to improve it, but I'll work on it.

Regards,

Phil.
