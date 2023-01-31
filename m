Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBCD683712
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjAaUEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjAaUEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:04:23 -0500
X-Greylist: delayed 91985 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 Jan 2023 12:04:22 PST
Received: from out-148.mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854E856491
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:04:22 -0800 (PST)
Date:   Tue, 31 Jan 2023 20:04:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675195460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jh/baY97/lYcQNbE6c9CebV1b/2EgbL4sdH3k9fvFHE=;
        b=M/c4RHMDqFEIf43nHcq4XXwLj+ZTxS1U72lxJF0AmBav2M9r6VikvQHPN28xq2goZ4XtGl
        9XqDq+xHikb+uQqmfHVH8q2XpnErIDdlJlvHv04uKrz9jx76+pf5t81cTV/ljfhiehTPsx
        lEUaqQxggkPB2PEI8qTBNSQh6l4sN9I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v8 01/69] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
Message-ID: <Y9l0PzgnKZiFJjvp@google.com>
References: <20230131092504.2880505-1-maz@kernel.org>
 <20230131092504.2880505-2-maz@kernel.org>
 <b7dbe85e-c7f8-48ad-e1af-85befabd8509@arm.com>
 <86cz6u248j.wl-maz@kernel.org>
 <3c15760c-c76f-3d5d-a661-442459ce4e07@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c15760c-c76f-3d5d-a661-442459ce4e07@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 05:34:39PM +0000, Suzuki K Poulose wrote:
> On 31/01/2023 14:00, Marc Zyngier wrote:

[...]

> > What is exactly the objection here? NV is more or less a VHE++ mode,
> > but is also completely experimental and incomplete.
> 
> I am all in for making this an "optional", only enabled it when "I know
> what I want".
> 
> kvm-arm.mode=nv kind of seems that the KVM driver is conditioned
> mainly for running NV (comparing with the other existing options
> for kvm-arm.mode).
> 
> In reality, as you confirmed, NV is an *additional* capability
> of a VHE hypervisor. So it would be good to "opt" in for "nv" capability
> support.
> 
> e.g,
> 
>    kvm-arm.nv=on
> 
> Thinking more about it, either is fine.

Marc, I'm curious, how do you plan to glue hVHE + NV together (if at
all)? We may need two separate options for this so the user could
separately configure NV for their hVHE KVM instance.

-- 
Thanks,
Oliver
