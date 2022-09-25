Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AB65EB429
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 00:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiIZWHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 18:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbiIZWHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 18:07:08 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711D3248FD
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:07:07 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id lh5so16966446ejb.10
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=A2s8n5PYK3ZaMy6+MNcDLHsBXyfzYG3pJKOuijb9LrI=;
        b=Te7p+3vXxrj1oavgx6Qi0QSolUPVebkMMjX/sx6ijkFN2QUVEgdbNz09CPYhSlQqFG
         DtuDbGNsOkotXvdZSi4bFk+ctXOfrKiWZvbVma+fzSyW9+a0pLser4KOT38nVCgesL1o
         eY6UO3ttb6wapWd4WbSoeoE+OV3qN5nwLiv8a+Sa/Oqu83Pkp65a2vrx+E/6xaR2BVoH
         hicrllfmcK04EOVeiKiQR9h+x4x3DTfxK/9vn2478CmXuVRqkW9hgf6S09KBQcvaOSJG
         VOz1vBIJVKDxvI32AZC24p1TXUeaXfdxKJQNNNNvlHEfwgBTu2tc9htc50Jl2cZEZXYi
         iVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=A2s8n5PYK3ZaMy6+MNcDLHsBXyfzYG3pJKOuijb9LrI=;
        b=LLuzbdSHKGbnqf/Uz1xTZVyQtM6YMMdEOfjtDt3OAXrQT6RS/Pn56qsQ4rVc+WPLgJ
         32301KEEycY7bOlp0+/cfAbJVm5SbIqJvDhatdw41WGbDviQiQcjGudCmr6uKdQsx60Y
         o8UjxE64Cm+zcMzYdaK+Ea1BA1zIcpyQfeuFa9wU2hMWlBIvKCPX+P9cp0bYhSmjmr9b
         RSpAGE7uJKJQ2Db8gx4Bi/1ThKt4uBPMcZJQhwT2T0q3nKpvmGavbMAiEnenxu84VoAs
         cL2jRn6fgRZaxEdpUhJCwxgs4oMgDywo65jHat9IfhyPeio4X/Yzv0HVi+IzYNxYPaHn
         O+IQ==
X-Gm-Message-State: ACrzQf3sr8GAKnjjW8Gqq2dVU7Hn9a3im9hMLA4JWkkj1jrLEAeO46V2
        jwFHqE0jN+bDmyq3Dm+0/Znd7A==
X-Google-Smtp-Source: AMsMyM58jr1etzMyNQUmnzQOYdUw0OknZzi2KCSPlPDP+MUwOkuDM6AZAQk/q8e2cRlv2rlB1bl4tQ==
X-Received: by 2002:a17:907:8a15:b0:782:e6da:f13d with SMTP id sc21-20020a1709078a1500b00782e6daf13dmr12432003ejc.152.1664230025973;
        Mon, 26 Sep 2022 15:07:05 -0700 (PDT)
Received: from [192.168.190.227] ([31.209.146.210])
        by smtp.gmail.com with ESMTPSA id t4-20020a05640203c400b00456df1907a1sm6744798edw.0.2022.09.26.15.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 15:07:05 -0700 (PDT)
Message-ID: <2322dc37-ddb5-b712-92ff-3fbc6f5c914d@linaro.org>
Date:   Sun, 25 Sep 2022 10:18:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 9/9] gdbstub: move guest debug support check to ops
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, mads@ynddal.dk,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20220922145832.1934429-1-alex.bennee@linaro.org>
 <20220922145832.1934429-10-alex.bennee@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20220922145832.1934429-10-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/22 14:58, Alex Bennée wrote:
> This removes the final hard coding of kvm_enabled() in gdbstub and
> moves the check to an AccelOps.
> 
> Signed-off-by: Alex Bennée<alex.bennee@linaro.org>
> Cc: Mads Ynddal<mads@ynddal.dk>
> ---
>   accel/kvm/kvm-cpus.h       | 1 +
>   gdbstub/internals.h        | 1 +
>   include/sysemu/accel-ops.h | 1 +
>   include/sysemu/kvm.h       | 7 -------
>   accel/kvm/kvm-accel-ops.c  | 1 +
>   accel/kvm/kvm-all.c        | 6 ++++++
>   accel/tcg/tcg-accel-ops.c  | 6 ++++++
>   gdbstub/gdbstub.c          | 5 ++---
>   gdbstub/softmmu.c          | 9 +++++++++
>   gdbstub/user.c             | 6 ++++++
>   10 files changed, 33 insertions(+), 10 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
