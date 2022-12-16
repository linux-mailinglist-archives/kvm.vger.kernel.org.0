Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C5D64EF34
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiLPQeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiLPQdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:33:45 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95A7F09
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:33:44 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1322d768ba7so3905871fac.5
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ikyShjz8bCnOuVG2FrXIyeFfnEFNbKtS3+YKrJrfDzk=;
        b=C5FlGKQVSe83KlYXSW/Rb5Ao+TYgwLxKdXSSk7bG4r9JB5CXEx8h09YRBonS3QUcPY
         KKm0+86REt6Y1+4XiPzS9+WopZZxE8fFo6tD/Ov90PWn3idLCzoL6IvACXl8etGvLHql
         Bho40ZGJSTG/KnnfOhCsj2NXU7m197/EXdi7KHsoj7/kJeqJBmkIyBASAroCRZ/TktAC
         +RwlTr9NfAPKvaRgfzaT2KqM3JL04y50fqWGnZ0nBVfFogXgQYUZ7QZWBMH5qe4lhaom
         2Koj6vuL3alc4934XpFrJYYuhmqgfuV1DViXWAVkRNtIzPL1ir8zObSI+Qe0AWJIqBt9
         hEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikyShjz8bCnOuVG2FrXIyeFfnEFNbKtS3+YKrJrfDzk=;
        b=V4gbeFRxky1zNUsgJMmm3lUJmiA5LW8MyrSTmQdlaHlC4CDGhVAkeqM5n0SrybqMcv
         2hBmFsHVUQmK6JCOtdkdsyh0IHBn1acXavAGoMxIXJueLo/ZI5G7Ga4y0srpKF7AFGY5
         WFGDVyqRHvs9wSWpSi43CiAigoTQIy+o211Ikh9I9jDvqMvV2f/4I0BDIymJSBWLcAOH
         6d7QE3j2GTypga2/AUhdJIaqXIPRfh7+YlVtviIzGXI5MQOroolumow7XoYMxwNpU8Vd
         bwjCB9QGCAxoDqJ7gr1/T1M6ZIyxeVMpr/szplXkxvP29/hVRadvGx7Ec9z54kKxNvh2
         mlYQ==
X-Gm-Message-State: AFqh2koSXrfH4KytpaGS6gfy9ssKLMy+6EMHSj4v4CgQis0TE456wpiU
        xyZN1h8lc6kXMUdzxZe8nGLsTz/CB/A=
X-Google-Smtp-Source: AMrXdXtaiWb9g3+Gs/cXcWNJFII9MVarhj/56xxwQ1vf3Jy8KOWR0uBC25GlRt2Dn6pS0/xaPcSOZw==
X-Received: by 2002:a05:6870:e246:b0:14b:da26:5248 with SMTP id d6-20020a056870e24600b0014bda265248mr894039oac.19.1671208424005;
        Fri, 16 Dec 2022 08:33:44 -0800 (PST)
Received: from [192.168.68.106] (201-43-103-101.dsl.telesp.net.br. [201.43.103.101])
        by smtp.gmail.com with ESMTPSA id w23-20020a056870b39700b0014b8347e1e3sm1141099oap.12.2022.12.16.08.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 08:33:43 -0800 (PST)
Message-ID: <47b89df9-4977-75b2-6f60-092e147b1305@gmail.com>
Date:   Fri, 16 Dec 2022 13:33:39 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH-for-8.0 1/4] target/ppc/kvm: Add missing "cpu.h" and
 "exec/hwaddr.h"
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
References: <20221213123550.39302-1-philmd@linaro.org>
 <20221213123550.39302-2-philmd@linaro.org>
Content-Language: en-US
From:   Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <20221213123550.39302-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/13/22 09:35, Philippe Mathieu-Daudé wrote:
> kvm_ppc.h is missing various declarations from "cpu.h":
> 
>    target/ppc/kvm_ppc.h:128:40: error: unknown type name 'CPUPPCState'; did you mean 'CPUState'?
>    static inline int kvmppc_get_hypercall(CPUPPCState *env,
>                                           ^~~~~~~~~~~
>                                           CPUState
>    include/qemu/typedefs.h:45:25: note: 'CPUState' declared here
>    typedef struct CPUState CPUState;
>                            ^
>    target/ppc/kvm_ppc.h:134:40: error: unknown type name 'PowerPCCPU'
>    static inline int kvmppc_set_interrupt(PowerPCCPU *cpu, int irq, int level)
>                                           ^
>    target/ppc/kvm_ppc.h:285:38: error: unknown type name 'hwaddr'
>                                         hwaddr ptex, int n)
>                                         ^
>    target/ppc/kvm_ppc.h:220:15: error: unknown type name 'target_ulong'
>    static inline target_ulong kvmppc_configure_v3_mmu(PowerPCCPU *cpu,
>                  ^
>    target/ppc/kvm_ppc.h:286:38: error: unknown type name 'ppc_hash_pte64_t'
>    static inline void kvmppc_read_hptes(ppc_hash_pte64_t *hptes,
>                                         ^
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>

>   target/ppc/kvm_ppc.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index ee9325bf9a..5fd9753953 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -9,6 +9,9 @@
>   #ifndef KVM_PPC_H
>   #define KVM_PPC_H
>   
> +#include "exec/hwaddr.h"
> +#include "cpu.h"
> +
>   #define TYPE_HOST_POWERPC_CPU POWERPC_CPU_TYPE_NAME("host")
>   
>   #ifdef CONFIG_KVM
