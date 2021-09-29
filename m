Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633A141CA1B
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345517AbhI2Qbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344370AbhI2Qbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 12:31:43 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F80C06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:30:01 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t18so5379473wrb.0
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZIL2fzsmyD973C3LK1fCqDkEUFPat/dEOaChN1UH7jk=;
        b=WolWiv42bMY/oHLejn4em0YDf8/c6hwLWre46b16soX2Oc3kXytF8SbAfqowDDgOF5
         ju7ucfWUUBpKx+1ircpHkIt9oAr95pTq5CRMv1ip1Ew+AYQIbNkQXVwr86XR9SKDCcgy
         0hzHcEFGX2R8U2JuXlMJUuJtbjSa582rXP4bnUtLeigHiU8kzl6TRZmECUkE9kosh4Wp
         wQeD4BS9PIKxbhMLxODJbU6FnKRok/AvVrneUDMW7o6KqPUj/7YPaJU7GpXEeos1aRY3
         Ff136iGJ+PtaPYLi218B2mYlM/AfrNA68jnsrDPnvYqu08qYlF5GwNhhHawE5HXFs9Zf
         vAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZIL2fzsmyD973C3LK1fCqDkEUFPat/dEOaChN1UH7jk=;
        b=oE0vs7bi/7iKcatvzJk4Pfe3HSZTEWryhkFEKrzQ5okC00YYg0QYoUAoYusyCBKYS2
         kApTqaK9vLjUmy72iQyF8zRiT1oOedauplEzrdVSmB2Lf4WkwzX0r/L+FTEBXQ2yMFbj
         jRszId6qV9cS7v5ywFE1Q5bO+01EXUmURGgqR9WOv1XfgkspUI5NOkvNhd2d8H+L2ks6
         FcBNqd2lh2ziy+2PW5bVuf6D1THlf6uNMCsMYSmBlB8qBS09IMWVWS3Y23qtxtz/7EHh
         zpH2PfBFcfvaa6Iw0g8th1mXlMOlDU6/p1if82oMhXVn9lAV33U8hdbR5F1pAsRS0Vtg
         w3Eg==
X-Gm-Message-State: AOAM530oc4Z9ogqIlQyAE54ZWYWttFOOC9AUPmuqN3cGy13ZWXv+WLkp
        tGkWEYVu2tIpz68E0t4d5aY=
X-Google-Smtp-Source: ABdhPJyr2JDd3KWc00tPxqANAMzR6P2py5oRDv9PVX0RQORnHl9S/wpl3amXphivDc6lWRKFMB8stw==
X-Received: by 2002:a5d:6d02:: with SMTP id e2mr994900wrq.198.1632933000633;
        Wed, 29 Sep 2021 09:30:00 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id d2sm360747wrc.32.2021.09.29.09.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 09:30:00 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <63229ef1-6f77-8aa4-89a7-7759140a60db@amsat.org>
Date:   Wed, 29 Sep 2021 18:29:58 +0200
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
        qemu-devel@nongnu.org, Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Paolo Bonzini <pbonzini@redhat.com>, haxm-team@intel.com,
        Colin Xu <colin.xu@intel.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210902152243.386118-1-f4bug@amsat.org>
 <a4cba848-e668-7cf1-fe93-b5da3a4ac6dc@redhat.com>
 <f3e89488-0d05-657a-34f7-060a7250517d@amsat.org>
 <f9e3c54f-a7cb-a043-f7fd-9d9d0dd61c16@vivier.eu>
 <6fa5f79c-8d3b-9534-26d6-ebe1ba937491@vivier.eu>
 <01ea5ea0-a61c-7bea-e1a6-639e3b9a2988@amsat.org>
 <93245807-dfa9-be11-ccda-4601b09b204e@vivier.eu>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <93245807-dfa9-be11-ccda-4601b09b204e@vivier.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/21 18:23, Laurent Vivier wrote:
> Le 29/09/2021 à 18:06, Philippe Mathieu-Daudé a écrit :
>> On 9/29/21 17:16, Laurent Vivier wrote:
>>> Le 29/09/2021 à 17:00, Laurent Vivier a écrit :
>>>> Le 29/09/2021 à 16:08, Philippe Mathieu-Daudé a écrit :
>>>>> On 9/16/21 00:05, Paolo Bonzini wrote:
>>>>>> On 02/09/21 17:22, Philippe Mathieu-Daudé wrote:
>>>>>>> Instead of including a sysemu-specific header in "cpu.h"
>>>>>>> (which is shared with user-mode emulations), include it
>>>>>>> locally when required.
>>>>>>>
>>>>>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>>>>>> ---
>>>>>>
>>>>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>>
>>>>> Thank you, Cc'ing qemu-trivial@ :)
>>>>>
>>>>
>>>> Applied to my trivial-patches branch.
>>>>
>>>
>>> We have a problem:
>>>
>>> .../target/i386/tcg/sysemu/seg_helper.c:145:9: error: implicit declaration of function
>>> 'apic_poll_irq' [-Werror=implicit-function-declaration]
>>>   145 |         apic_poll_irq(cpu->apic_state);
>>>       |         ^~~~~~~~~~~~~
>>> .../target/i386/tcg/sysemu/seg_helper.c:145:9: error: nested extern declaration of 'apic_poll_irq'
>>> [-Werror=nested-externs]
>>
>> Hmm I'll check what changed since I sent that. It was working the day
>> Paolo Acked, because have the patch rebased / tested on top of commit
>> c99e34e537f ("Merge remote-tracking branch
>> 'remotes/vivier2/tags/linux-user-for-6.2-pull-request' into staging").
>>
>> I should have rebased/retested today before Cc'ing you, sorry.
>>
> 
> On top of c99e34e537f I have the same error...

The problem is 0792e6c88d4 ("target/i386: Move
x86_cpu_exec_interrupt() under sysemu/ folder").
