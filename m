Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5627374ABDD
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 09:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjGGHZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 03:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjGGHZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 03:25:09 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218AE2122
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 00:24:39 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1b06ea7e7beso1594138fac.0
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 00:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688714674; x=1691306674;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+v0c7jqXEaSQ8/CKVRHuIXi+OHiePF56yDcM+f6NjZM=;
        b=E1NVjUDE64Ygtts87T9i3RTHMYDqbMyGpllu1wNHIkXaPUPz6q+GJmUGircGAE2R76
         0og8tT5c77NmqhB7Pzb+xESN3oVar2S4kBnwM/hLKJLHsh6KS5k5moX8TcITs7Rz/5/S
         gl41CRfjFvYYPL7FdnZi2UMg1ehYn3/h9zIb0jbSd3qRWWdj5i5yD9cu85eO4twaunJW
         l7HTYAeXo34LhuZ9Z9Tr4/QLTAJL9/rnppE2/7khUrW6o23Xj2Nh4sGQGnTyEU/02tFu
         56GECAPS7UwZO9EoQwSqhH+wK+SV8xU/PxQioQx0Z+Qth+ItP3r6NcoKh7DCVlkuEnRU
         OH5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688714674; x=1691306674;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+v0c7jqXEaSQ8/CKVRHuIXi+OHiePF56yDcM+f6NjZM=;
        b=iW4J7IfhnTVVY0uXhpTT7LKnfsr7V7TLbZZ7Fa4u6nMPZ9Mi/29iQrkk+ifAuZ3r8c
         zpuP23lyG9d2ZAVHNomTwTYnYf0rL5Z58cI8tQPS4PvlQ5oO2RK+DtMX5lYMOw1jcM/l
         dBzB6wcKaT1XFx3+rjH/dY30rH/QPnkF3vWz/MgQpwzxrhYngTzeHF9T4BSGCtIEh46X
         z2Vnh110nijvJafIYVDIXHHGCmvoiIDZiVY1qfLH06zUFO8I7y8cXm46QmwO1WgvzVpH
         2f60SZxAGJJxvmJTabZDoX6zxutclgyHFAB4F0uaazLI+T+CRT9KrLzrNOkXIQ/wOXod
         4fug==
X-Gm-Message-State: ABy/qLbSq6g0BjkM6k+iDwebhYoWy87nvxoKTWrIwYUF6LREBsOdqJ4W
        +OXKTarTJ3qXu8ppmj+VKS4=
X-Google-Smtp-Source: APBJJlG21NBgnNX/iX/+YLsmS5eeUnw49hto47HXkhql9DP+A1alLI5t6H51qpFjQyekrU7bu/H2jw==
X-Received: by 2002:a05:6870:c89d:b0:19f:aee0:e169 with SMTP id er29-20020a056870c89d00b0019faee0e169mr5470904oab.30.1688714674188;
        Fri, 07 Jul 2023 00:24:34 -0700 (PDT)
Received: from [192.168.68.107] (201-69-66-19.dial-up.telesp.net.br. [201.69.66.19])
        by smtp.gmail.com with ESMTPSA id c6-20020a056870b28600b001aa02b7bfabsm1527682oao.33.2023.07.07.00.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jul 2023 00:24:33 -0700 (PDT)
Message-ID: <bf8cc98d-662b-c4ce-2837-a70c79b0e5e6@gmail.com>
Date:   Fri, 7 Jul 2023 04:24:30 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 0/6] target/ppc: Few cleanups in kvm_ppc.h
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
References: <20230627115124.19632-1-philmd@linaro.org>
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20230627115124.19632-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Phil,

I queued all patches to ppc-next. I fixed up patch 3 to not move the cpu_list
macro as Greg suggested. If you're strongly attached to it let me know and
I'll remove it from the queue.

Greg, feel free to send your R-b in patch 3 if patch 3 with this change pleases
you.


Daniel

On 6/27/23 08:51, Philippe Mathieu-Daudé wrote:
> PPC specific changes of a bigger KVM cleanup, remove "kvm_ppc.h"
> from user emulation. Mostly trivial IMO.
> 
> Philippe Mathieu-Daudé (6):
>    target/ppc: Have 'kvm_ppc.h' include 'sysemu/kvm.h'
>    target/ppc: Reorder #ifdef'ry in kvm_ppc.h
>    target/ppc: Move CPU QOM definitions to cpu-qom.h
>    target/ppc: Define TYPE_HOST_POWERPC_CPU in cpu-qom.h
>    target/ppc: Restrict 'kvm_ppc.h' to sysemu in cpu_init.c
>    target/ppc: Remove pointless checks of CONFIG_USER_ONLY in 'kvm_ppc.h'
> 
>   target/ppc/cpu-qom.h  |  7 +++++
>   target/ppc/cpu.h      |  6 ----
>   target/ppc/kvm_ppc.h  | 70 ++++++++++++++++++-------------------------
>   target/ppc/cpu_init.c |  2 +-
>   4 files changed, 37 insertions(+), 48 deletions(-)
> 
