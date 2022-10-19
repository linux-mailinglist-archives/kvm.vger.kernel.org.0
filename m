Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897D6604332
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 13:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiJSLaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 07:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiJSL37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 07:29:59 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EED1F2F3
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 04:04:12 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id b18so21636488ljr.13
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 04:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qtER+pnoU+/7ikP3NPM81Ooz5nTRUPZQTbvTnPDFZPw=;
        b=QXWL5wvTyP3hG88xdRQ6Wyo91av8GmdemxaD/Hjr1dxF5RAgTtgF4vGEMtsiFohP2R
         aRQaQ6DqwO5+vKAf9PFg5Rd65bZP1J9D0FrFjq9Zag6B8SwzcyoD6Mzw00vjL/SnxT6N
         cOaVpGzj6mKC5C3drkwUcQRkbGQUO4FZlUn0ggBWz3ACef32Y8z1V+Y1lxuwLaAOX27G
         /+XYiU4/tURALKOZgT7scugKx3OTC+9aBSqB7EG2SCi8JV7Rt9h9QXLRGXfBL3joQxC6
         7jhJxbvep3IEblyysDAxpywS4U9tEUo/6EPSu1eUfRu99e7IwzjvGDpRr05mWJmKTmY3
         8qYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qtER+pnoU+/7ikP3NPM81Ooz5nTRUPZQTbvTnPDFZPw=;
        b=1mnsTQO5XVvyoi3/xGDBesCLWN/HFPYIOWS8eygpkC39EJVRaeUgbV20D2O3XI1ZnI
         nALOG1WzTohGZSVJwfAvPHHXrdLzU9EkGI3iW7pUhont2+23bpMefab9CHdENvLrpOvG
         C2OM2TwmLJMp1f7rSQDiOWbBOxeKrj8J2U4lPUqWkncYKq+R403FJsetGaId9ufA6oC8
         e7Etd+db/6E6MKOm9DyQHjvzDMTkOtCbCWc3sxY7Sm/B8pk/VOxzi+HE3yqiYgap0vcQ
         fPDUrYVJhJ8edV3qC0uwzVNO2hf5gYicQek2HXmdjr1PtlXLgRSsoFqLUsecwfcklbNe
         jOSA==
X-Gm-Message-State: ACrzQf0PEQnTlx0xzVcgdGfOHkz7R7BinnTaaXt1kbir3SXzwuS6QKyD
        5Mc/ZyEJVbzNC8Bv2fm8wcqN1ou9oB7sn0Pi
X-Google-Smtp-Source: AMsMyM7nW9AuFTrgsViYtc3kz/pbS3FgqQ0/o3Ypjmb+rLWeBTdIExy76JlOpM8/JodCAG+NGZBmDA==
X-Received: by 2002:a5d:43ce:0:b0:22e:4acd:2153 with SMTP id v14-20020a5d43ce000000b0022e4acd2153mr4392713wrr.189.1666176813753;
        Wed, 19 Oct 2022 03:53:33 -0700 (PDT)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id c25-20020a7bc019000000b003c6b874a0dfsm19715175wmb.14.2022.10.19.03.53.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 03:53:33 -0700 (PDT)
Message-ID: <2b2eb94f-c534-464d-0f60-bc8a88e41af7@linaro.org>
Date:   Wed, 19 Oct 2022 12:53:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH v3 15/15] accel/kvm: move kvm_update_guest_debug to inline
 stub
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20220927141504.3886314-1-alex.bennee@linaro.org>
 <20220927141504.3886314-16-alex.bennee@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20220927141504.3886314-16-alex.bennee@linaro.org>
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

On 27/9/22 16:15, Alex Bennée wrote:
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   include/sysemu/kvm.h   | 16 ++++++++++++++++
>   accel/kvm/kvm-all.c    |  6 ------
>   accel/stubs/kvm-stub.c |  5 -----
>   3 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 6e1bd01725..790d35ef78 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -247,7 +247,23 @@ int kvm_on_sigbus(int code, void *addr);
>   
>   void kvm_flush_coalesced_mmio_buffer(void);
>   
> +/**
> + * kvm_update_guest_debug(): ensure KVM debug structures updated
> + * @cs: the CPUState for this cpu
> + * @reinject_trap: KVM trap injection control
> + *
> + * There are usually per-arch specifics which will be handled by
> + * calling down to kvm_arch_update_guest_debug after the generic
> + * fields have been set.
> + */
> +#ifdef KVM_CAP_SET_GUEST_DEBUG
>   int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap);
> +#else
> +static inline int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
> +{
> +    return -EINVAL;

Wouldn't -ENOSYS make more sense in this case?

> +}
> +#endif
>   
>   /* internal API */
>   
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 6ebff6e5a6..423fb1936f 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3395,12 +3395,6 @@ void kvm_remove_all_breakpoints(CPUState *cpu)
>       }
>   }
>   
> -#else /* !KVM_CAP_SET_GUEST_DEBUG */
> -
> -static int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
> -{
> -    return -EINVAL;
> -}
>   #endif /* !KVM_CAP_SET_GUEST_DEBUG */
>   
>   static int kvm_set_signal_mask(CPUState *cpu, const sigset_t *sigset)
> diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
> index 2d79333143..5d2dd8f351 100644
> --- a/accel/stubs/kvm-stub.c
> +++ b/accel/stubs/kvm-stub.c
> @@ -46,11 +46,6 @@ int kvm_has_many_ioeventfds(void)
>       return 0;
>   }
>   
> -int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap)
> -{
> -    return -ENOSYS;
> -}
> -
>   int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
>   {
>       return 1;

