Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BF458E7B7
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 09:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiHJHRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 03:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiHJHRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 03:17:02 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF2F4D161
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 00:17:00 -0700 (PDT)
Date:   Wed, 10 Aug 2022 02:16:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660115818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lnnnucUQ8BNoxijHKdwN8wjZqldMe4thNdHyaMFPMKo=;
        b=GupU2arkRASHme5PDc96/86JA+M8qFQV4cxtah7aEb1nJ4V4U3iSpefNFfbrnr4K6Nr859
        EnHHrzQWoRr8r5DLx224eIbtKnK+LigVDxshj6LxERc8Xqh+iIw2yIOEHuhdKwjCmBNlmB
        mn5lF9pfKPn5ra/Hq0pbHIPr4gj+N98=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com
Subject: Re: [PATCH 9/9] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the
 guest
Message-ID: <YvNbYyS6eM9mo+Pq@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-10-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-10-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022 at 02:58:13PM +0100, Marc Zyngier wrote:
> Now that the infrastructure is in place, bummp the PMU support up

typo: bump

> to PMUv3p5.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index b33a2953cbf6..fbbe6a7e3837 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1031,6 +1031,6 @@ u8 kvm_arm_pmu_get_host_pmuver(void)
>  	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
>  	tmp = cpuid_feature_cap_perfmon_field(tmp,
>  					      ID_AA64DFR0_PMUVER_SHIFT,
> -					      ID_AA64DFR0_PMUVER_8_4);
> +					      ID_AA64DFR0_PMUVER_8_5);
>  	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), tmp);
>  }
> -- 
> 2.34.1
> 
