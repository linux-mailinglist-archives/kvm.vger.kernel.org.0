Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5427236D9
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 07:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbjFFFcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 01:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjFFFcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 01:32:06 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C0BE63
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 22:32:04 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30ae5f2ac94so5647602f8f.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 22:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686029523; x=1688621523;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4VfOOJinkjSh0l6gqLPyVdZ8e/+vLTEa7wa66JblaO8=;
        b=wfJmQ+zvrNbpk09oYfwAqwk9SS0iVDZEAWLyBiOOHlfnE/jQo6QrhdGayqYC4EamnA
         TyBfJJgBV2pBgcKU0fxdDcWtJVV9FjhJnN41c6gCct5d0EHO7X0R/55eN7N4gLKw5MTH
         Zur32UJArgDQEg4Uv8O7jwVBeB4JAjMlhoq3JM3zI9HpZIcP+1bj5VMPjn5FNJknkaBV
         1XsD9hhxvT8QmJrZdpvccHXwUInj/YSPZOMWCL7ELMKezBeYuIDOdl30pfvgEA1ko/zp
         mWWI1LolhPD8bFt0Md3Aclv6P8zxcH12UWHsqwbm1+rx7mS3UrjpeBOsr1oCborWTfwi
         J+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686029523; x=1688621523;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4VfOOJinkjSh0l6gqLPyVdZ8e/+vLTEa7wa66JblaO8=;
        b=OdejNnLjId0mlSwZGVuVqGAQ4TZSGhV9uOm0gPo/PqPzF6PAcpCN2v8djBPCxM55I7
         fW0AlqjBhdzcRSZpQdFekreERVo7ghxcVKvnvSZDQSZkAzChVhM9DEHdexaEyBc1qGzm
         F/X0M4xrmTK9mPupYxy8N+towM2QdyORaXkvEG3PtwVuiNJnsd865ws7mcBhbzlJOTeL
         Grr/ayhC7eXK+JgDjzXNuzWOiZHxC1f8DLN0fO0cWO6Or/5ntFccQov46bCu2Bmauhk5
         72ahe7r0bvKMYbSOY0VBj7yvMc+3QtoGHX0Gqj2Qr3jx4X+ZuiXDUc/w4N50N3BPwrW2
         bVBQ==
X-Gm-Message-State: AC+VfDz1Zjq+DPe+st6/qnkIikR4x9X52omK5Ampew6EzohVhGbUwukR
        gfS+z0dFQSsFr4XSiTh0OTXpSA==
X-Google-Smtp-Source: ACHHUZ7KW5f46Fu2TwW8RcBsG/OabhqdnHsanr6dWn081cYThqa/uEaRyr5Xt8LyYeDjG1Kl+Ie6Dw==
X-Received: by 2002:adf:e3c8:0:b0:306:2eab:fb8c with SMTP id k8-20020adfe3c8000000b003062eabfb8cmr885316wrm.42.1686029523455;
        Mon, 05 Jun 2023 22:32:03 -0700 (PDT)
Received: from [192.168.69.115] (vbo91-h01-176-184-50-104.dsl.sta.abo.bbox.fr. [176.184.50.104])
        by smtp.gmail.com with ESMTPSA id q12-20020a05600000cc00b003093a412310sm11412127wrx.92.2023.06.05.22.32.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 22:32:02 -0700 (PDT)
Message-ID: <98003cfe-742c-d932-5949-499750489663@linaro.org>
Date:   Tue, 6 Jun 2023 07:32:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH 01/10] sysemu/kvm: Remove unused headers
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-2-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230405160454.97436-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/23 18:04, Philippe Mathieu-Daudé wrote:
> All types used are forward-declared in "qemu/typedefs.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/sysemu/kvm.h | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index cc6c678ed8..7902acdfd9 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -16,9 +16,6 @@
>   #ifndef QEMU_KVM_H
>   #define QEMU_KVM_H
>   
> -#include "qemu/queue.h"
> -#include "hw/core/cpu.h"
> -#include "exec/memattrs.h"

Oops this is incorrect...

   MemTxAttrs kvm_arch_post_run(CPUState *cpu, struct kvm_run *run);

MemTxAttrs is not:
- forward-declared
- used as pointer

Since this is now merged as commit 1e05888ab5 I'll send a fix.

>   #include "qemu/accel.h"
>   #include "qom/object.h"
>   

