Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE7341C9D4
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345694AbhI2QML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345858AbhI2QMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 12:12:00 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFE5C0612A6
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:06:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t18so5258239wrb.0
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JtPiNffr5LLfB1JPSLnSwHr2XB9mX5OjG0f1ZoGKeSo=;
        b=hti1DvLTSzR7BKBJHTzKqrkb19MzeeSb1eyoXyAdktV8yXOWD7uSsKuJQf3C9o9Xvy
         woH4mh6lgZD9zJv17GXbFpoMb5BHoKC5IaQPfibasF25Hn709w2c+EvyXWeywPKdvzFo
         HAzFILoKH9I2M4rb7C1xB/bym33zr8NTQ48QTYysCjVuiYdr1Oqp1EEsKLI3+1NZeLQz
         N/PNTzV9RqPObMxF9DogPnRcX5gZSoKbMOPuIBwxihaDlfoOZZPf3jTewXH5TBt70RhL
         tMXa4P/Rl213vCVWYVYtpdiXaVKmI1sODk6sHbuPdwvw7hMP29oHAe4H539YkNO3Cnlx
         b7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JtPiNffr5LLfB1JPSLnSwHr2XB9mX5OjG0f1ZoGKeSo=;
        b=gPNZ8Y7QdcRhlCpACJKeHMMx25g4ekxAYHo5dGiMw3ct6REBXYu/mv6E36pL/8pSKB
         ZYQ/XziJbILeOOgki28Ib7iku0lItggyhounHxYIt7Af2k3jjEZlaMwIsOIn3aahX7AH
         4tp8RgvkzTRtWzbk/K+/OYAekjYsISGocX3O+W/uxQKij1Q1pEePylwqs3nMRhNky66a
         zcCntxc4rUyDEaAZOG4of/1jU7vEauN5Y9SCgumhEH3tj3zKcPilQvNnwS5k277sLrQM
         g6QOqB8GlxIZm+934WeNQBvfvD773nkJDi1ywJu2xc1LsMFL1i+26vX0J8gPcD3DDpQU
         rFfA==
X-Gm-Message-State: AOAM5337LSSsmV80vaO7HmW2ikjPH0qBdQbheBySYGfqkfw+TEq7oorN
        yOkYVbfrd9K2ahCI4Gv3QAM=
X-Google-Smtp-Source: ABdhPJzQzjjqI/Bu/ESl0/InfvaLPNE4qvxfgRycWRxkCYFJKEMyJsYagB5fB9tn53yGpNvgPFUNgg==
X-Received: by 2002:a5d:5281:: with SMTP id c1mr834351wrv.92.1632931580257;
        Wed, 29 Sep 2021 09:06:20 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id d5sm323763wra.38.2021.09.29.09.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 09:06:19 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <01ea5ea0-a61c-7bea-e1a6-639e3b9a2988@amsat.org>
Date:   Wed, 29 Sep 2021 18:06:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] target/i386: Include 'hw/i386/apic.h' locally
Content-Language: en-US
To:     Laurent Vivier <laurent@vivier.eu>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        QEMU Trivial <qemu-trivial@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Cameron Esfahani <dirty@apple.com>, qemu-devel@nongnu.org,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, haxm-team@intel.com,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210902152243.386118-1-f4bug@amsat.org>
 <a4cba848-e668-7cf1-fe93-b5da3a4ac6dc@redhat.com>
 <f3e89488-0d05-657a-34f7-060a7250517d@amsat.org>
 <f9e3c54f-a7cb-a043-f7fd-9d9d0dd61c16@vivier.eu>
 <6fa5f79c-8d3b-9534-26d6-ebe1ba937491@vivier.eu>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <6fa5f79c-8d3b-9534-26d6-ebe1ba937491@vivier.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/21 17:16, Laurent Vivier wrote:
> Le 29/09/2021 à 17:00, Laurent Vivier a écrit :
>> Le 29/09/2021 à 16:08, Philippe Mathieu-Daudé a écrit :
>>> On 9/16/21 00:05, Paolo Bonzini wrote:
>>>> On 02/09/21 17:22, Philippe Mathieu-Daudé wrote:
>>>>> Instead of including a sysemu-specific header in "cpu.h"
>>>>> (which is shared with user-mode emulations), include it
>>>>> locally when required.
>>>>>
>>>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>>>> ---
>>>>
>>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>>
>>> Thank you, Cc'ing qemu-trivial@ :)
>>>
>>
>> Applied to my trivial-patches branch.
>>
> 
> We have a problem:
> 
> .../target/i386/tcg/sysemu/seg_helper.c:145:9: error: implicit declaration of function
> 'apic_poll_irq' [-Werror=implicit-function-declaration]
>   145 |         apic_poll_irq(cpu->apic_state);
>       |         ^~~~~~~~~~~~~
> .../target/i386/tcg/sysemu/seg_helper.c:145:9: error: nested extern declaration of 'apic_poll_irq'
> [-Werror=nested-externs]

Hmm I'll check what changed since I sent that. It was working the day
Paolo Acked, because have the patch rebased / tested on top of commit
c99e34e537f ("Merge remote-tracking branch
'remotes/vivier2/tags/linux-user-for-6.2-pull-request' into staging").

I should have rebased/retested today before Cc'ing you, sorry.
