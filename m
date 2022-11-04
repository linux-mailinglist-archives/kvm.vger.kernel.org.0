Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1050A619337
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 10:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiKDJNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 05:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiKDJNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 05:13:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89902291;
        Fri,  4 Nov 2022 02:13:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D87C61FB;
        Fri,  4 Nov 2022 02:13:25 -0700 (PDT)
Received: from [10.1.27.15] (e122027.cambridge.arm.com [10.1.27.15])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AAE83F703;
        Fri,  4 Nov 2022 02:13:16 -0700 (PDT)
Message-ID: <55b704b7-0a44-8f34-e22f-d60b58db610f@arm.com>
Date:   Fri, 4 Nov 2022 09:13:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] arm64: paravirt: remove conduit check in
 has_pv_steal_clock
To:     Usama Arif <usama.arif@bytedance.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, mark.rutland@arm.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
References: <20221104061659.4116508-1-usama.arif@bytedance.com>
Content-Language: en-GB
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20221104061659.4116508-1-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/2022 06:16, Usama Arif wrote:
> arm_smccc_1_1_invoke() which is called later on in the function
> will return failure if there's no conduit (or pre-SMCCC 1.1),
> hence the check is unnecessary.
> 
> Suggested-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  arch/arm64/kernel/paravirt.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
> index 57c7c211f8c7..aa718d6a9274 100644
> --- a/arch/arm64/kernel/paravirt.c
> +++ b/arch/arm64/kernel/paravirt.c
> @@ -141,10 +141,6 @@ static bool __init has_pv_steal_clock(void)
>  {
>  	struct arm_smccc_res res;
>  
> -	/* To detect the presence of PV time support we require SMCCC 1.1+ */
> -	if (arm_smccc_1_1_get_conduit() == SMCCC_CONDUIT_NONE)
> -		return false;
> -
>  	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>  			     ARM_SMCCC_HV_PV_TIME_FEATURES, &res);
>  

