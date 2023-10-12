Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9847C7622
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 20:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441905AbjJLStk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 14:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379624AbjJLStk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 14:49:40 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F993B7
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 11:49:38 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-690bf8fdd1aso977468b3a.2
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 11:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697136578; x=1697741378; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZeTar64N6wuohyz8CUDjvsEqQJWU9Kuliy7gzDa7hn0=;
        b=A/epL/YBvjjt/yBC9VWF2G/2LR1jnU1Q2uC5Xyb4IpJGWg0FYkKT1OWmNy9IaJ6ii/
         nYcPAsf0EcUcAbjgreOkMaxSZvwIRERC3NbWT7DSUWGWg5YWIqHqCfZ+DAOJoqFXRxdA
         KHS+ODv44B53OQK2R3Eom2X5bZFnbn2uNfI1u5XwwfU/VFVR0DhI8PH2a3eJZqJgHkrB
         yLV5Ecnkj2eIZuLwuiDxmg/16QSOE+Ewrlijo1FFuv4rV861iIN8TbeRR8LbAzpZ1vLg
         zjeE9pOb50p5g/2wOZTVWlgdpo+FuuPMGd36ipuRJ22/2Uqy9TgkPInoADNqJLREKy72
         E60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697136578; x=1697741378;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeTar64N6wuohyz8CUDjvsEqQJWU9Kuliy7gzDa7hn0=;
        b=YQUZ++XjLYdoIUvk3zxVomo8l1ork1mI9Yj0uPZsh0cDpulfY3PuXo8oLToiuAkanI
         6OYqng7uSUPhV7ycJWGtpWv227rKKN1Zj2SbEsAnsDrC4pjjj440KTts3evXl/M+QP/j
         o+vyIvn19zH+iNsKca9Cl+IYMqqQAXJY/2oyFw5mt9W1u3Ubn7b6W0sF/paGLuurAqOR
         ZR7NWMzS/5jSKKNmlqSxhZGE5X0cWM29lwep2KomSdFQh/MLvvmdMS9JtbuCwTa5HVSo
         NcdIhZ1T5tT6Xfx3C5gW6yN2/xAV9i/ON4oK+0E75024+Cobv7UyxmM8XTMKXl7yHa+Z
         miig==
X-Gm-Message-State: AOJu0YzjdS+umZ8GBtsAqROreGsdOPaoK7I31CFTJUq7TppgrhMzfwny
        HxVIRzfSnMgWVtxbZ4+WT+4RdKeVhXI45yry1O4=
X-Google-Smtp-Source: AGHT+IHXsKDRBEja5bS4niSX3rriCA/HCrphDhhcOr6uXCeeOpkaZuBWwysGc/uNrFFtJ7zPVJQzQA==
X-Received: by 2002:a05:6a00:16cd:b0:68b:a137:3739 with SMTP id l13-20020a056a0016cd00b0068ba1373739mr26088031pfc.4.1697136577853;
        Thu, 12 Oct 2023 11:49:37 -0700 (PDT)
Received: from [192.168.68.107] ([177.94.42.196])
        by smtp.gmail.com with ESMTPSA id y21-20020aa78555000000b0068fe9f23bf4sm12093155pfn.103.2023.10.12.11.49.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 11:49:37 -0700 (PDT)
Message-ID: <eddb484d-9134-4930-8b2f-c2f21b0b93d7@ventanamicro.com>
Date:   Thu, 12 Oct 2023 15:49:32 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] sysemu/kvm: Restrict kvmppc_get_radix_page_info()
 to ppc targets
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        Nicholas Piggin <npiggin@gmail.com>
References: <20231003070427.69621-1-philmd@linaro.org>
 <20231003070427.69621-2-philmd@linaro.org>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20231003070427.69621-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/3/23 04:04, Philippe Mathieu-Daudé wrote:
> kvm_get_radix_page_info() is only defined for ppc targets (in
> target/ppc/kvm.c). The declaration is not useful in other targets,
> reduce its scope.
> Rename using the 'kvmppc_' prefix following other declarations
> from target/ppc/kvm_ppc.h.
> 
> Suggested-by: Michael Tokarev <mjt@tls.msk.ru>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---



Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>


>   include/sysemu/kvm.h | 1 -
>   target/ppc/kvm.c     | 4 ++--
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index ee9025f8e9..3bcd8f45be 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -551,7 +551,6 @@ int kvm_set_one_reg(CPUState *cs, uint64_t id, void *source);
>    * Returns: 0 on success, or a negative errno on failure.
>    */
>   int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target);
> -struct ppc_radix_page_info *kvm_get_radix_page_info(void);
>   int kvm_get_max_memslots(void);
>   
>   /* Notify resamplefd for EOI of specific interrupts. */
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 51112bd367..19fe6d2d00 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -268,7 +268,7 @@ static void kvm_get_smmu_info(struct kvm_ppc_smmu_info *info, Error **errp)
>                        "KVM failed to provide the MMU features it supports");
>   }
>   
> -struct ppc_radix_page_info *kvm_get_radix_page_info(void)
> +static struct ppc_radix_page_info *kvmppc_get_radix_page_info(void)
>   {
>       KVMState *s = KVM_STATE(current_accel());
>       struct ppc_radix_page_info *radix_page_info;
> @@ -2372,7 +2372,7 @@ static void kvmppc_host_cpu_class_init(ObjectClass *oc, void *data)
>       }
>   
>   #if defined(TARGET_PPC64)
> -    pcc->radix_page_info = kvm_get_radix_page_info();
> +    pcc->radix_page_info = kvmppc_get_radix_page_info();
>   
>       if ((pcc->pvr & 0xffffff00) == CPU_POWERPC_POWER9_DD1) {
>           /*
