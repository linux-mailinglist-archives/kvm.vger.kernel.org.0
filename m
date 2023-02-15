Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90D569840D
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 20:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBOTCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 14:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjBOTCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 14:02:46 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26EA44AD
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 11:02:45 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id d8-20020a17090ad98800b002344fa17c8bso2792663pjv.5
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 11:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iXaWM8DJcFHim1yG1ikSQtIEw2W7l/Ucp08i3El8aCk=;
        b=T2KOwvaGqKSC5aCa0s2PQbqAh1bQ6eGDYwXhXPnLQs7cUenJw7AXO35PPS8cFI7LBL
         KNUwAQw1+JZYIMXkD5c9ZoSEVJ4CpKSPWTDC1aawIA92YasVTtTPuWj1q3NSEMttXG1P
         CDHZJxi+Wa2Un7E1zQ2rmcybZQ9AxdiRvHuoPVNVIal22t9oFaBEKPxm6KU/iOb2cZAY
         lGDr4cLH6gomAbkQV55eSI2UIireQ3ZqHJPg+MvNBtzU8KHx/rD18p3OzFau13OuE6g+
         xVTqRa846wYU/N2FiU2k0fsI2FQaDI4het53UJFC9YSNRlnbTI5Jndb5V7+PZBKEMhz6
         hdXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iXaWM8DJcFHim1yG1ikSQtIEw2W7l/Ucp08i3El8aCk=;
        b=h3n2V2haAfgYwHIjZocOuBL7z3OctQkm19XBNIDmvpo4Qunkdb0QwfY75SzzHpWO0d
         NVRh08eH0WolCsejCFDk0eyTZ0v0AnC6VWgoQOKrpDGQA3yjzeNDcFsvdNI+j8OpbIXN
         hR7m8ciqYAtfGM1xGOZRUac2SPyDo7k94ERUx/FeTMXL6i8JgWNka7/X3mr23zTlId6C
         GxBzGKb8kwTeUypTnnxGDzAoRkTs/N1+HjdPThR/6gWfH1+HoLqG9CEuoAnEC6x+71xZ
         wf+21XkDZs/hoznFIVDFo5DUrjuOWoSCzKSJfExHIgN3kQaUFdqY4wkmQbpHmloHHNti
         iCgQ==
X-Gm-Message-State: AO0yUKX5F3ovma3Bec9ojGprZl07L2P7mJqYX5234NjGKVmpbx1GsD9u
        YYBzQasa96R9PN3um1afCJiFsw==
X-Google-Smtp-Source: AK7set9syO3Nzsrpna9QRid/5mmRssO7WmpfV9jueQLcZGKIMod+PHJiY1Mj2Fh9B+QEONsYkRs7KQ==
X-Received: by 2002:a17:90b:390d:b0:22c:5241:b8e with SMTP id ob13-20020a17090b390d00b0022c52410b8emr4184040pjb.25.1676487765453;
        Wed, 15 Feb 2023 11:02:45 -0800 (PST)
Received: from [192.168.192.227] (rrcs-74-87-59-234.west.biz.rr.com. [74.87.59.234])
        by smtp.gmail.com with ESMTPSA id rj3-20020a17090b3e8300b002262dd8a39bsm1793864pjb.49.2023.02.15.11.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 11:02:44 -0800 (PST)
Message-ID: <6dc9714f-767c-d69c-5126-875355eeb539@linaro.org>
Date:   Wed, 15 Feb 2023 09:02:35 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5/5] hw/i386/kvm: Factor i8254_pit_create_try_kvm() out
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
 <20230215174353.37097-6-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230215174353.37097-6-philmd@linaro.org>
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
> Factor a new i8254_pit_create_try_kvm() helper out of the
> following patter:

pattern

> 
>    if (kvm_pit_in_kernel()) {
>        kvm_pit_init(...);
>    } else }
>      i8254_pit_create(...);
>    }
> 
> (adding a stub for non-KVM builds).
> 
> Since kvm_pit_init() is only used once, un-inline it and
> remove the now unused headers from "hw/timer/i8254.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/i386/kvm/i8254.c        | 18 ++++++++++++++++++
>   hw/i386/microvm.c          |  6 +-----
>   hw/i386/pc.c               |  7 ++-----
>   include/hw/timer/i8254.h   | 22 ++++++----------------
>   target/i386/kvm/kvm-stub.c |  6 ++++++
>   5 files changed, 33 insertions(+), 26 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
