Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7016B6E0311
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 02:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjDMAPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 20:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDMAPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 20:15:38 -0400
Received: from out-4.mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754952100
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 17:15:37 -0700 (PDT)
Date:   Thu, 13 Apr 2023 00:15:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681344935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oxKqdN2d9o1rjgNqs0FzqHDIOpuH0PBhahAh2+r4yw4=;
        b=mo00ZAK6PrrPng6pfwi13RNopdcsOdIQYpWIg7UhZfUS+CmcM4ej/RoJevZVAE9sIjd22R
        lDs9e8VgSWq9lIPg+iGXN1Kgn2JEPnhldHQeU9viU33XhZfqAhcvDCIFsP6cVbCQ2EKEXD
        e4QmadRWlZvSCeNPMG/WwWkAfoafDIE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: arm64: vhe: Drop extra isb() on guest exit
Message-ID: <ZDdJpDaQYJGiWflS@linux.dev>
References: <20230408160427.10672-1-maz@kernel.org>
 <20230408160427.10672-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408160427.10672-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 08, 2023 at 05:04:27PM +0100, Marc Zyngier wrote:
> __kvm_vcpu_run_vhe() end on VHE with an isb(). However, this
> function is only reachable via kvm_call_hyp_ret(), which already
> contains an isb() in order to mimick the behaviour of nVHE and
> provide a context synchronisation event.
> 
> We thus have two isb()s back to back, which is one too many.
> Drop the first one and solely rely on the one in the helper.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
