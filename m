Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FADD6D7934
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbjDEKDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjDEKDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:03:38 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8667C90
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:03:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j24so35655687wrd.0
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qPGiYsKsF9XBHpZHSaehfUjdHj55ArKkkl5Mh728FTk=;
        b=qlk5EhXvVzCvvWSUiu3qmdkaf677tpVSe5Qcaq52Cu+aCIEZ5h8H6wmwb0rnz/yOzN
         r9Bdg2B4N/a/TpruwLlEvdWPdGNbqRuM1IVFsX+pD6W+314On/BtbLyui9NjneTzmhKn
         h4RcE/4rt1i7/9SGPst01Mwfy/m2y1yHEjwzemJfDVW2wnsOj+MAsf0mckTzQ+Fbwlpr
         9YyHbtIAZ6+othz0fZxTdBkqUneKS5D+qK6HuY3fw6TTUOjXU4xlf2t+SHitetq3g3Av
         0JEA0fMUcts0WCyy7pHRp2UBevGU1cAe7yzRh0nR75pu3ih4xNE3UfnWstbFZfF5XKEg
         ZXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qPGiYsKsF9XBHpZHSaehfUjdHj55ArKkkl5Mh728FTk=;
        b=6HVmGppe6TIF75bhi1oVlwbP70ivPTX+ZdDiZwZoRLUrD0FopmAbc1vmM+TN1BiDUU
         upCqAAAPM9+Qt8fgRbHfOGEe9OprBpxfaQQ4wZ4dug/bw/rs3cWaXiw4qz66ErKuRhXJ
         ziCkQGX/G9WzuUR84mWhxd2dpSwhcHwL458Jm7JTK+SrQuK50DRGzkjEv8nOszXrTFoh
         MMjsveB7Y6hDMaYwe+F38vDl/SUEbMlbR6WqTPfC9Xdk154KXGC9rOznjzsR/28tXsbt
         PVEoox+SjzmjGxj+VCarX6+vnHlQNb1JB14Fis51JV7pzJa0JM0bqCRPCNQX5jpUG8Lz
         u7lQ==
X-Gm-Message-State: AAQBX9e4QJ6evgoVPRkgfZK0rVNOLkFz1ClITpzoqIDPbrIQcDEX4xX5
        n2HnqAPip045Ic1j4GctzSbt0A==
X-Google-Smtp-Source: AKy350aQUBvC2M9NhCRTbZ9/Q3Osr+DnJ9BpAh2NuONzKX985+X7H163FOr+LZ6xo9Jq69rFyP4gQg==
X-Received: by 2002:a5d:4a04:0:b0:2ce:a93d:41a7 with SMTP id m4-20020a5d4a04000000b002cea93d41a7mr3736642wrq.40.1680689016046;
        Wed, 05 Apr 2023 03:03:36 -0700 (PDT)
Received: from [192.168.69.115] (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id x3-20020a5d4903000000b002cea8e3bd54sm14650863wrq.53.2023.04.05.03.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 03:03:35 -0700 (PDT)
Message-ID: <51212bc5-cbb7-4d24-f97f-8ad00dda42f2@linaro.org>
Date:   Wed, 5 Apr 2023 12:03:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH] target/arm: Check if debug is already initialized
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20230405070244.23464-1-akihiko.odaki@daynix.com>
Content-Language: en-US
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230405070244.23464-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/23 09:02, Akihiko Odaki wrote:
> When virtualizing SMP system, kvm_arm_init_debug() will be called
> multiple times. Check if the debug feature is already initialized when the
> function is called; otherwise it will overwrite pointers to memory
> allocated with the previous call and leak it.
> 
> Fixes: e4482ab7e3 ("target-arm: kvm - add support for HW assisted debug")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   target/arm/kvm64.c | 23 +++++++++++++++++------
>   1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 1197253d12..d2fce5e582 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -32,7 +32,11 @@
>   #include "hw/acpi/ghes.h"
>   #include "hw/arm/virt.h"
>   
> -static bool have_guest_debug;
> +static enum {
> +    GUEST_DEBUG_UNINITED,
> +    GUEST_DEBUG_INITED,
> +    GUEST_DEBUG_UNAVAILABLE,
> +} guest_debug;
>   
>   /*
>    * Although the ARM implementation of hardware assisted debugging
> @@ -84,8 +88,14 @@ GArray *hw_breakpoints, *hw_watchpoints;
>    */
>   static void kvm_arm_init_debug(CPUState *cs)
>   {
> -    have_guest_debug = kvm_check_extension(cs->kvm_state,
> -                                           KVM_CAP_SET_GUEST_DEBUG);

- Maybe we can merge kvm{,64}.c (see commit 82bf7ae84c
   "target/arm: Remove KVM support for 32-bit Arm hosts")

- Could kvm_arm_init_debug() belong to kvm_arch_init()?
   Then this patch / enum is not required.

- Why we keep a reference to the global kvm_state in CPUState is not
   clear to me.
