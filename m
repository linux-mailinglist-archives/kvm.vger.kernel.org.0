Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A78E61A2A4
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 21:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiKDUra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 16:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKDUr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 16:47:29 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE7842984
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:47:26 -0700 (PDT)
Date:   Fri, 4 Nov 2022 20:47:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667594844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SCB5ELX6zZgbFvMbSeADp4LrffKecUl6OwVcbH2Uzy8=;
        b=fSsh80Ev9RKwyRPXTjPjZnU8OndKbEKKb2oub4IYYNx7/0r0Cl5NPxk7/2oQHRgCEwv50o
        ks3wuR9pOiR7dGF97YOFpa66PwHv7iJ7CIm/sj9Idto43b75OQM2kTtxmGk56r3h2povFz
        toC5JLi8D2aRcFtpZmqyN/ZTcLqeX+A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 01/14] arm64: Add ID_DFR0_EL1.PerfMon values for
 PMUv3p7 and IMP_DEF
Message-ID: <Y2V6WIu40Cg2ShXV@google.com>
References: <20221028105402.2030192-1-maz@kernel.org>
 <20221028105402.2030192-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028105402.2030192-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 28, 2022 at 11:53:49AM +0100, Marc Zyngier wrote:
> Align the ID_DFR0_EL1.PerfMon values with ID_AA64DFR0_EL1.PMUver.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

FYI, another pile of ID reg changes is on the way that'll move DFR0 to a
generated definition.

https://lore.kernel.org/linux-arm-kernel/20220930140211.3215348-1-james.morse@arm.com/

--
Thanks,
Oliver

> ---
>  arch/arm64/include/asm/sysreg.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 7d301700d1a9..84f59ce1dc6d 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -698,6 +698,8 @@
>  #define ID_DFR0_PERFMON_8_1		0x4
>  #define ID_DFR0_PERFMON_8_4		0x5
>  #define ID_DFR0_PERFMON_8_5		0x6
> +#define ID_DFR0_PERFMON_8_7		0x7
> +#define ID_DFR0_PERFMON_IMP_DEF		0xf
>  
>  #define ID_ISAR4_SWP_FRAC_SHIFT		28
>  #define ID_ISAR4_PSR_M_SHIFT		24
> -- 
> 2.34.1
> 
