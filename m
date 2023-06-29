Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306A4741F72
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 07:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjF2FDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 01:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjF2FDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 01:03:44 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD352695
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 22:03:43 -0700 (PDT)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4Qs5vK0tQ7z4whk;
        Thu, 29 Jun 2023 15:03:41 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qs5vG00FPz4wgk;
        Thu, 29 Jun 2023 15:03:37 +1000 (AEST)
Message-ID: <3a67f533-4f9b-baa1-c6ea-181a89f4d400@kaod.org>
Date:   Thu, 29 Jun 2023 07:03:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 1/6] target/ppc: Have 'kvm_ppc.h' include
 'sysemu/kvm.h'
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
References: <20230627115124.19632-1-philmd@linaro.org>
 <20230627115124.19632-2-philmd@linaro.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230627115124.19632-2-philmd@linaro.org>
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
> "kvm_ppc.h" declares:
> 
>    int kvm_handle_nmi(PowerPCCPU *cpu, struct kvm_run *run);
> 
> 'struct kvm_run' is declared in "sysemu/kvm.h", include it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>




Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.



> ---
>   target/ppc/kvm_ppc.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
> index 611debc3ce..2e395416f0 100644
> --- a/target/ppc/kvm_ppc.h
> +++ b/target/ppc/kvm_ppc.h
> @@ -9,6 +9,7 @@
>   #ifndef KVM_PPC_H
>   #define KVM_PPC_H
>   
> +#include "sysemu/kvm.h"
>   #include "exec/hwaddr.h"
>   #include "cpu.h"
>   

