Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48475741F8E
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 07:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjF2FLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 01:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjF2FKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 01:10:52 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDEF30E6
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 22:10:44 -0700 (PDT)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4Qs63R1jwjz4wp4;
        Thu, 29 Jun 2023 15:10:43 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qs63N3SNlz4wp2;
        Thu, 29 Jun 2023 15:10:40 +1000 (AEST)
Message-ID: <ab48582d-1f29-3c86-7500-a8a0eeff85ed@kaod.org>
Date:   Thu, 29 Jun 2023 07:10:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 6/6] target/ppc: Remove pointless checks of
 CONFIG_USER_ONLY in 'kvm_ppc.h'
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
References: <20230627115124.19632-1-philmd@linaro.org>
 <20230627115124.19632-7-philmd@linaro.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230627115124.19632-7-philmd@linaro.org>
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


I guess the MemoryRegion code has sufficiently changed since commit
98efaf75282a ("ppc: Fix up usermode only builds") ?

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.




> ---
>   target/ppc/kvm_ppc.h | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index 901e188c9a..6a4dd9c560 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -42,7 +42,6 @@ int kvmppc_booke_watchdog_enable(PowerPCCPU *cpu);
>   target_ulong kvmppc_configure_v3_mmu(PowerPCCPU *cpu,
>                                        bool radix, bool gtse,
>                                        uint64_t proc_tbl);
> -#ifndef CONFIG_USER_ONLY
>   bool kvmppc_spapr_use_multitce(void);
>   int kvmppc_spapr_enable_inkernel_multitce(void);
>   void *kvmppc_create_spapr_tce(uint32_t liobn, uint32_t page_shift,
> @@ -52,7 +51,6 @@ int kvmppc_remove_spapr_tce(void *table, int pfd, uint32_t window_size);
>   int kvmppc_reset_htab(int shift_hint);
>   uint64_t kvmppc_vrma_limit(unsigned int hash_shift);
>   bool kvmppc_has_cap_spapr_vfio(void);
> -#endif /* !CONFIG_USER_ONLY */
>   bool kvmppc_has_cap_epr(void);
>   int kvmppc_define_rtas_kernel_token(uint32_t token, const char *function);
>   int kvmppc_get_htab_fd(bool write, uint64_t index, Error **errp);
> @@ -262,7 +260,6 @@ static inline void kvmppc_set_reg_tb_offset(PowerPCCPU *cpu, int64_t tb_offset)
>   {
>   }
>   
> -#ifndef CONFIG_USER_ONLY
>   static inline bool kvmppc_spapr_use_multitce(void)
>   {
>       return false;
> @@ -322,8 +319,6 @@ static inline void kvmppc_write_hpte(hwaddr ptex, uint64_t pte0, uint64_t pte1)
>       abort();
>   }
>   
> -#endif /* !CONFIG_USER_ONLY */
> -
>   static inline bool kvmppc_has_cap_epr(void)
>   {
>       return false;

