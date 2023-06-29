Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2D5741F74
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 07:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjF2FEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 01:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjF2FED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 01:04:03 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C9A2707
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 22:04:02 -0700 (PDT)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4Qs5vj1pC8z4wgk;
        Thu, 29 Jun 2023 15:04:01 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qs5vf2n0Rz4wp3;
        Thu, 29 Jun 2023 15:03:58 +1000 (AEST)
Message-ID: <3a1fe20e-8d6e-6de8-1a75-fb15a4910836@kaod.org>
Date:   Thu, 29 Jun 2023 07:03:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 3/6] target/ppc: Move CPU QOM definitions to cpu-qom.h
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
References: <20230627115124.19632-1-philmd@linaro.org>
 <20230627115124.19632-4-philmd@linaro.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230627115124.19632-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/23 13:51, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>




Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.



> ---
>   target/ppc/cpu-qom.h | 5 +++++
>   target/ppc/cpu.h     | 6 ------
>   2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/target/ppc/cpu-qom.h b/target/ppc/cpu-qom.h
> index 9666f54f65..c2bff349cc 100644
> --- a/target/ppc/cpu-qom.h
> +++ b/target/ppc/cpu-qom.h
> @@ -31,6 +31,11 @@
>   
>   OBJECT_DECLARE_CPU_TYPE(PowerPCCPU, PowerPCCPUClass, POWERPC_CPU)
>   
> +#define POWERPC_CPU_TYPE_SUFFIX "-" TYPE_POWERPC_CPU
> +#define POWERPC_CPU_TYPE_NAME(model) model POWERPC_CPU_TYPE_SUFFIX
> +#define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
> +#define cpu_list ppc_cpu_list
> +
>   ObjectClass *ppc_cpu_class_by_name(const char *name);
>   
>   typedef struct CPUArchState CPUPPCState;
> diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
> index af12c93ebc..e91e1774e5 100644
> --- a/target/ppc/cpu.h
> +++ b/target/ppc/cpu.h
> @@ -1468,12 +1468,6 @@ static inline uint64_t ppc_dump_gpr(CPUPPCState *env, int gprn)
>   int ppc_dcr_read(ppc_dcr_t *dcr_env, int dcrn, uint32_t *valp);
>   int ppc_dcr_write(ppc_dcr_t *dcr_env, int dcrn, uint32_t val);
>   
> -#define POWERPC_CPU_TYPE_SUFFIX "-" TYPE_POWERPC_CPU
> -#define POWERPC_CPU_TYPE_NAME(model) model POWERPC_CPU_TYPE_SUFFIX
> -#define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
> -
> -#define cpu_list ppc_cpu_list
> -
>   /* MMU modes definitions */
>   #define MMU_USER_IDX 0
>   static inline int cpu_mmu_index(CPUPPCState *env, bool ifetch)

