Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66B863EEA4
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 12:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiLALBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 06:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiLALAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 06:00:41 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC24A321D
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 03:00:25 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p24so1313029plw.1
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 03:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3m5F5SZmhCySHaq4Kl+nNPgZPVM9ttm1TTYlw+maT9E=;
        b=BkcdZqbFeePP7PhgiNGQZiQ1/IrHQjmPITDEJdkxgFaPv7QkOL49k7MbmbtcMWit7j
         ziUuIw/Rq95yF8hjpc7DirP8lrB/AP9iPYKQkePxfGawn12jQr3gWEIbxCYZEfH52HIn
         ivtzqFiNBO4d/qxGtGCrRZBhgU6k+lNqPc/SElKFM9K8iiTGd6d4edx1e2x8f7itVwDl
         3j/MC4rYxBD/wUGjtqVjwe/yGhpMFnlIM+lmbBwTDlQmEul39ZXTaGnm5thuriQ9H+0a
         LlqleLvdN7CJOMBYdAZ915Jyph3Bul8ErQmRxhlJaL/ixydmMQs2qbEMi6h/iioNmh9b
         wCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3m5F5SZmhCySHaq4Kl+nNPgZPVM9ttm1TTYlw+maT9E=;
        b=51wtH7aQgKKSE2fQRCFZag9e6pHA5riWnKMAGCUKVvt/OqmRVV1NuBrzSiqbXiZE6M
         W0mmMP5FUW1PK6rMApG9JPv6vi88OylQHF6oDvAmJoOmAOJ7t5HxHZq3OvRXrhbRaDI2
         9gEdW4CglhuKAlepG0mrWySY0dHzmmTbC1EEvA2xIMcLxcwOH4zUhJIbqhWkmYa9OZfK
         xmrfBdFR/b25hIB46Oniqf7Qo7Gc0560HYo9UrcCqbq3/5S9vEeM2D2nVGkrEVjAK1Gk
         ZbbO8aS8L1Vvf61VGQvclz/wzpcBCp1wUagndSywIaEgAAliSIVxv0ZLGsOYxfdJUDw3
         Mjtw==
X-Gm-Message-State: ANoB5pnv3CVGZmqFt9Hq6NF+QWBCJamreNKYuLeWnEgpMKdqhkeQ1OEP
        5rsoG81DHtTzzPtKfpB/cRxbcA==
X-Google-Smtp-Source: AA0mqf5tmeQONwE26vLCpkyddTpVvkN7A/tfrv/HQaUC8nVZjAqUywmWqMwYQ8ENrzKcMCsDq8fIGA==
X-Received: by 2002:a17:90a:fa46:b0:200:1df3:a7a9 with SMTP id dt6-20020a17090afa4600b002001df3a7a9mr74111196pjb.202.1669892424814;
        Thu, 01 Dec 2022 03:00:24 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:7b99:f7c3:d084:f1e2? ([2400:4050:c360:8200:7b99:f7c3:d084:f1e2])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902ec8800b001895d87225csm3324805plg.182.2022.12.01.03.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 03:00:24 -0800 (PST)
Message-ID: <a3cc1116-272d-a8e5-a131-7becf98115e0@daynix.com>
Date:   Thu, 1 Dec 2022 20:00:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] accel/kvm/kvm-all: Handle register access errors
Content-Language: en-US
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221201102728.69751-1-akihiko.odaki@daynix.com>
 <CAFEAcA_ORM9CpDCvPMs1XcZVhh_4fKE2wnaS_tp1s4DzZCHsXQ@mail.gmail.com>
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAFEAcA_ORM9CpDCvPMs1XcZVhh_4fKE2wnaS_tp1s4DzZCHsXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/01 19:40, Peter Maydell wrote:
> On Thu, 1 Dec 2022 at 10:27, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> A register access error typically means something seriously wrong
>> happened so that anything bad can happen after that and recovery is
>> impossible.
>> Even failing one register access is catastorophic as
>> architecture-specific code are not written so that it torelates such
>> failures.
>>
>> Make sure the VM stop and nothing worse happens if such an error occurs.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> 
> In a similar vein there was also
> https://lore.kernel.org/all/20220617144857.34189-1-peterx@redhat.com/
> back in June, which on the one hand was less comprehensive but on
> the other does the plumbing to pass the error upwards rather than
> reporting it immediately at point of failure.
> 
> I'm in principle in favour but suspect we'll run into some corner
> cases where we were happily ignoring not-very-important failures
> (eg if you're running Linux as the host OS on a Mac M1 and your
> host kernel doesn't have this fix:
> https://lore.kernel.org/all/YnHz6Cw5ONR2e+KA@google.com/T/
> then QEMU will go from "works by sheer luck" to "consistently
> hits this error check"). So we should aim to land this extra
> error checking early in the release cycle so we have plenty of
> time to deal with any bug reports we get about it.
> 
> thanks
> -- PMM

Actually I found this problem when I tried to run QEMU with KVM on M2 
MacBook Air and encountered a failure described and fixed at:
https://lore.kernel.org/all/20221201104914.28944-2-akihiko.odaki@daynix.com/

Although the affected register was not really important, QEMU couldn't 
run the guest well enough because kvm_arch_put_registers for ARM64 is 
written in a way that it fails early. I guess the situation is not so 
different for other architectures as well.

I still agree that this should be postponed until a new release cycle 
starts as register saving/restoring is too important to fail.

Regards,
Akihiko Odaki
