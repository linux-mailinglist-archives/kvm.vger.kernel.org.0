Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CFF693967
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 19:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjBLSic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 13:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBLSib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 13:38:31 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58FCCDD3;
        Sun, 12 Feb 2023 10:38:30 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id cz14so8556589oib.12;
        Sun, 12 Feb 2023 10:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HnZTM4aCncFxs1pAbM5ySS/dMSWJRqjHRewc8smV+6s=;
        b=RaIxDjv+9itnwY0BWpVFW2NNiprhUZbyJPqmqDDUTo8E7DAs022bgJN2634MbdYmNm
         i5AzsvLo6R40GBt2zMkC+rc2ZYqehTpK11eTM//PtykS5++V0lelmL8yugR1Abxe61se
         D5NQXe17/pOJ+oRZEuafx5BcwfdhPtGq/U23Qs+JYJkOI2aOqHo04Q1WJD1YMX5z3bn1
         PXr2o0ak15xBnQssi5061CELOaIi8ejUcQuKOWdbyeZVjHnheXEZDvNGwfLlzJYJLzVM
         3fFWSBe80YO5tcfQSm1k8gxR9UssOZz91uLh4cDX6rwuKGzQsGUfZDM9i/hrB7q4qKCJ
         dcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HnZTM4aCncFxs1pAbM5ySS/dMSWJRqjHRewc8smV+6s=;
        b=rxXE3jjfs59lv1m6ThuOR+WP5z6M8gM39skdvr++1aPXrnGRQqUud3rVg2moTdY7Mk
         +LjditoZInIgft+ycfHnl0t+pOi1F71Qo3UEPzBmKcjxJE9rHN2V+jYcQUpUiZTWbY7v
         Z/r/WOciqJVM00pRcDFCBMOXlnIG7/Si7e4UoJhiz2j1xS0EzXV0+riKTMOHrCv/hYd2
         FRZey4dtAka8Uu6AOp0j++KfvXh32hhdvRyoiseZwGo3jg2V1TASszY5FsMsf4uPAywl
         xQoM48M0sYqTYiclAloKSm1kWqp++JBL44Z0HQEBIOa0V9za7pORRxeuUT+o631B6UCn
         MN6g==
X-Gm-Message-State: AO0yUKWRENnldwDBfj9Lq40Hf/CFFfToZPd2Z5iAIQX4yZppzB7q+ZRD
        jOzGEpnqBgF+RV3CEbMt3+Q=
X-Google-Smtp-Source: AK7set/KP9lAHf+iHmY/lcIV+05r1h1S1yTa/ED7OMXagnfbf8i4LW5WMdvneV+hrq3qeTTWpVbHpg==
X-Received: by 2002:a05:6808:2802:b0:378:5f75:bf27 with SMTP id et2-20020a056808280200b003785f75bf27mr10005359oib.50.1676227110035;
        Sun, 12 Feb 2023 10:38:30 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j20-20020aca1714000000b0037d8c938d62sm893861oii.50.2023.02.12.10.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Feb 2023 10:38:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <48d2ac96-abdd-23bc-b167-08dc2c1a1dbe@roeck-us.net>
Date:   Sun, 12 Feb 2023 10:38:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20230128172856.3814-1-jszhang@kernel.org>
 <20230212154333.GA3760469@roeck-us.net> <Y+kM//nuDv29Z9qJ@spud>
 <Y+kU9nDBTttZRLLq@spud> <Y+kcgcncQO/2DNLo@spud> <Y+kqi8bQE+8hLfOF@spud>
 <a059a815-dcb0-c575-b5a4-f9433e268e9b@roeck-us.net> <Y+kt04c1iRlzUNLA@spud>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
In-Reply-To: <Y+kt04c1iRlzUNLA@spud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/12/23 10:20, Conor Dooley wrote:
> On Sun, Feb 12, 2023 at 10:14:13AM -0800, Guenter Roeck wrote:
>> On 2/12/23 10:06, Conor Dooley wrote:
>>> On Sun, Feb 12, 2023 at 05:06:09PM +0000, Conor Dooley wrote:
>>>> On Sun, Feb 12, 2023 at 04:33:58PM +0000, Conor Dooley wrote:
>>>>> On Sun, Feb 12, 2023 at 03:59:59PM +0000, Conor Dooley wrote:
>>>>
>>>> So as not to lead anyone up the garden path, let me correct myself:
>>>>
>>>>> Hmm, so this appears to be us attempting to patch in alternatives where
>>>>> none actually exists - seemingly F & D.
>>>>
>>>> And of course that's not true, riscv_has_extension_likely() now uses
>>>> alternatives as of:
>>>> bdda5d554e43 ("riscv: introduce riscv_has_extension_[un]likely()")
>>>>
>>>>   From a quick look, it just happens that the only users are F & D.
>>>>
>>>
>>> Samuel pointed out that this is a lockdep splat on irc.
>>> There's a patch on the list that removes the lockdep annotation
>>> entirely:
>>> https://patchwork.kernel.org/project/linux-riscv/patch/20230202114116.3695793-1-changbin.du@huawei.com/
>>>
>>> So ye, no surprises that it was config based!
>>>
>>> Palmer posted a "better" fix for that lockdep warning a while ago:
>>> https://lore.kernel.org/all/20220322022331.32136-1-palmer@rivosinc.com/
>>>
>>> So we'd have to duplicate/reuse that for cpufeature/errata patching.
>>>
>>>
>>
>> This does not (only) happen in stop_machine().
> 
> Yah, sorry I meant that it's the same lockdep splat as is being
> addressed there.
> The first patch deletes the lockdep stuff entirely, so removes the
> splat. I was thinking that we'd need to take Palmer's (IMO better)
> patch and do the same thing for patching alternatives, but I figure we
> can just take the text_mutex itself for alternatives & not have to
> dance around the lock.
> 
> I'll go do that I suppose!

Thanks a lot for the clarification. That sounds like the backtrace
can be largely ignored. However, I still see that the patch series
results in boot hangs with the sifive_u qemu emulation, where
the log ends with "Oops - illegal instruction". Is that problem
being addressed as well ?

Thanks,
Guenter

