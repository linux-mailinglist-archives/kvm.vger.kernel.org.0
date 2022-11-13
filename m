Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A0662725B
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 20:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiKMTwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 14:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiKMTws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 14:52:48 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B158F02A
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 11:52:47 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id cl5so13894108wrb.9
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 11:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qWO23xnS3wIXo4WLaXT4GHJCm28qhVBHEppB+5gRgPM=;
        b=crIuF+eLXNjMNS8XQGjabMSQib9Hj2HW0+RyIz26h+stRJx0/3J+22qcL9fuhw3ZIM
         lLEljZNXPYGXo3nGwjlCpqtponpVkq4OJ+u7jljBFaQxHHFt58SClxDsPh7RhPj4cr7g
         iLiGYkJCnVOYeVJfnIcyYiZddK0onlu5e+2CUifh1Wvj/UWNdBGOT8zUXBOi4McJLIpB
         Lt92DfOjPi4Ic8i7NnYMbCeePUCbJKfsDRXk6L0YVimhQGN6gSeWZMWDJjlpH9fSdaXa
         Ak39k1vsAt0Ac7NjAQsr7CW8vgjBkLvkYt4M1naAiPiUo7l3zPkh1rPUMKvw4oLI8vdk
         ELiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qWO23xnS3wIXo4WLaXT4GHJCm28qhVBHEppB+5gRgPM=;
        b=UwooqqDv9IS+434eD+d8HOg3KYV2VREH0JnBTErofFr0plAk5Tb6m25eJurDEX1Cj4
         dzI9YRaocy4BXKEBIVX07nnETEgoejFzpCgjOFVoLyOAMynpXoJaZIt4N+IY8f8DRoVU
         48Vk9J3rYtra1d36oOSWGnUZcQ5UUn+R2mq1py9D61PB0Yeh1eqytKx+ytKbRKbMSv+q
         GnwKZCgd++Yb9sxBuMxMzxhYRhsVGhY2ZkK41douiZZhxD35REXJy65ap8s4ONjMN52A
         TKehzR/kCsHhIDXYuzP3OLOQzRY9+3JgG0ipJ/hBePwcyItbK+5ccXN8dj0b3g3FeGI7
         IjAQ==
X-Gm-Message-State: ANoB5plPsYq8rreSVR9DjHd7KKm9YuPcH8Yu+S5FhO1aD3NzbATg/8yi
        /IjPsY+gwASFWAkK7DPeZ4MlSw==
X-Google-Smtp-Source: AA0mqf7sMq0OyUcSL21mAlDJhflDL8mb7VyNfAnXPSRQAIO6vZQ0Fb2fzbkHniELTUx43mfDTdojFg==
X-Received: by 2002:adf:e852:0:b0:236:8d39:6f84 with SMTP id d18-20020adfe852000000b002368d396f84mr5511705wrn.152.1668369166155;
        Sun, 13 Nov 2022 11:52:46 -0800 (PST)
Received: from [192.168.1.115] ([185.126.107.38])
        by smtp.gmail.com with ESMTPSA id b15-20020adff24f000000b002345cb2723esm7585981wrp.17.2022.11.13.11.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Nov 2022 11:52:45 -0800 (PST)
Message-ID: <1cba26d1-a96f-f1dd-6d58-72ffaec7efb1@linaro.org>
Date:   Sun, 13 Nov 2022 20:52:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v5 15/20] hw/i386: update vapic_write to use MemTxAttrs
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     f4bug@amsat.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20221111182535.64844-1-alex.bennee@linaro.org>
 <20221111182535.64844-16-alex.bennee@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221111182535.64844-16-alex.bennee@linaro.org>
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

On 11/11/22 19:25, Alex Bennée wrote:
> This allows us to drop the current_cpu hack and properly model an
> invalid access to the vapic.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   hw/i386/kvmvapic.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
> index 43f8a8f679..a76ed07199 100644
> --- a/hw/i386/kvmvapic.c
> +++ b/hw/i386/kvmvapic.c
> @@ -635,20 +635,21 @@ static int vapic_prepare(VAPICROMState *s)
>       return 0;
>   }
>   
> -static void vapic_write(void *opaque, hwaddr addr, uint64_t data,
> -                        unsigned int size)
> +static MemTxResult vapic_write(void *opaque, hwaddr addr, uint64_t data,
> +                               unsigned int size, MemTxAttrs attrs)
>   {
>       VAPICROMState *s = opaque;
> +    CPUState *cs;
>       X86CPU *cpu;
>       CPUX86State *env;
>       hwaddr rom_paddr;
>   
> -    if (!current_cpu) {
> -        return;
> +    if (attrs.requester_type != MTRT_CPU) {
> +        return MEMTX_ACCESS_ERROR;
>       }
> -
> -    cpu_synchronize_state(current_cpu);
> -    cpu = X86_CPU(current_cpu);
> +    cs = qemu_get_cpu(attrs.requester_id);
> +    cpu_synchronize_state(cs);
> +    cpu = X86_CPU(cs);
>       env = &cpu->env;
>   
>       /*
> @@ -708,6 +709,8 @@ static void vapic_write(void *opaque, hwaddr addr, uint64_t data,
>           }
>           break;
>       }
> +
> +    return MEMTX_OK;
>   }
>   
>   static uint64_t vapic_read(void *opaque, hwaddr addr, unsigned size)
> @@ -716,7 +719,7 @@ static uint64_t vapic_read(void *opaque, hwaddr addr, unsigned size)
>   }
>   
>   static const MemoryRegionOps vapic_ops = {
> -    .write = vapic_write,
> +    .write_with_attrs = vapic_write,
>       .read = vapic_read,

Shouldn't we do the same for the read() path?

>       .endianness = DEVICE_NATIVE_ENDIAN,
>   };

