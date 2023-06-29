Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EF4741F7A
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 07:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjF2FGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 01:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjF2FGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 01:06:39 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCE32701
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 22:06:38 -0700 (PDT)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4Qs5yj0c8fz4wbP;
        Thu, 29 Jun 2023 15:06:37 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qs5yf1qGMz4wZp;
        Thu, 29 Jun 2023 15:06:33 +1000 (AEST)
Message-ID: <d9bc48aa-6f12-f0fb-9a24-b605e87537e4@kaod.org>
Date:   Thu, 29 Jun 2023 07:06:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 4/6] target/ppc: Define TYPE_HOST_POWERPC_CPU in
 cpu-qom.h
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
References: <20230627115124.19632-1-philmd@linaro.org>
 <20230627115124.19632-5-philmd@linaro.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230627115124.19632-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/23 13:51, Philippe Mathieu-Daudé wrote:
> TYPE_HOST_POWERPC_CPU is used in various places of cpu_init.c,
> in order to restrict "kvm_ppc.h" to sysemu, move this QOM-related
> definition to cpu-qom.h.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>




Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.



> ---
>   target/ppc/cpu-qom.h | 2 ++
>   target/ppc/kvm_ppc.h | 2 --
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/ppc/cpu-qom.h b/target/ppc/cpu-qom.h
> index c2bff349cc..4e4061068e 100644
> --- a/target/ppc/cpu-qom.h
> +++ b/target/ppc/cpu-qom.h
> @@ -36,6 +36,8 @@ OBJECT_DECLARE_CPU_TYPE(PowerPCCPU, PowerPCCPUClass, POWERPC_CPU)
>   #define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
>   #define cpu_list ppc_cpu_list
>   
> +#define TYPE_HOST_POWERPC_CPU POWERPC_CPU_TYPE_NAME("host")
> +
>   ObjectClass *ppc_cpu_class_by_name(const char *name);
>   
>   typedef struct CPUArchState CPUPPCState;
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index 49954a300b..901e188c9a 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -13,8 +13,6 @@
>   #include "exec/hwaddr.h"
>   #include "cpu.h"
>   
> -#define TYPE_HOST_POWERPC_CPU POWERPC_CPU_TYPE_NAME("host")
> -
>   #ifdef CONFIG_KVM
>   
>   uint32_t kvmppc_get_tbfreq(void);

