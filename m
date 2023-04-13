Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B116E030D
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 02:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjDMAL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 20:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDMALZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 20:11:25 -0400
Received: from out-11.mta1.migadu.com (out-11.mta1.migadu.com [95.215.58.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1A0B3
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 17:11:24 -0700 (PDT)
Date:   Thu, 13 Apr 2023 00:11:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681344683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/xuOUgwS7TiFTRCp7ny40dhXaDJWfispO1TUSx/Mbis=;
        b=b+vcXBq5wvyopZkHQAHD0NtZXphddOBWAPktMo4f69NnKfebtEF46yZUg7HUtmelvVLg1R
        doFyHmUTgqvYxljC5p+HVfGeT8UFIA4tMXL/xhSC+ft+cDOUQoZ/O4Hfe1IBlV/paD9HiY
        VcFtRAjNPuZqRduARLxik/Pl0nqtX2U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: arm64: vhe: Synchronise with page table
 walker on MMU update
Message-ID: <ZDdIp3j1r5ym4nb4@linux.dev>
References: <20230408160427.10672-1-maz@kernel.org>
 <20230408160427.10672-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408160427.10672-5-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 08, 2023 at 05:04:26PM +0100, Marc Zyngier wrote:
> Contrary to nVHE, VHE is a lot easier when it comes to dealing
> with speculative page table walks started at EL1. As we only change
> EL1&0 translation regime when context-switching, we already benefit
> from the effect of the DSB that sits in the context switch code.
> 
> We only need to take care of it in the NV case, where we can
> flip between between two EL1 contexts (one of them being the virtual
> EL2) without a context switch.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
