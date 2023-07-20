Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534A775B572
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 19:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjGTRTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 13:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjGTRTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 13:19:38 -0400
Received: from out-17.mta1.migadu.com (out-17.mta1.migadu.com [IPv6:2001:41d0:203:375::11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EB7CC
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 10:19:37 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689873575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYivxBWQ3YZQD179gp3mRMOft6cNkrnqZJhnecUb8kk=;
        b=lo7+AI8HOdXJoMbn030Hs420eLQ10ibM8nACrZO2FcXoUKxenC+5mGyAIA9D3g37Ei8b0N
        9TsVXovL7XTWEG76ZO51sIC+IrYh4aQQ5qWYu48lmJmToB3xbB7xTctOXka5DejDutnHeh
        GmqOAnIrPV5D/DdDeIOxjT05AtzRvTA=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>,
        Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev, Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Colton Lewis <coltonlewis@google.com>,
        Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Fix hardware enable/disable flows for pKVM
Date:   Thu, 20 Jul 2023 17:19:22 +0000
Message-ID: <168987354993.692466.16634039861064795931.b4-ty@linux.dev>
In-Reply-To: <20230719215725.799162-1-rananta@google.com>
References: <20230719215725.799162-1-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Jul 2023 21:57:25 +0000, Raghavendra Rao Ananta wrote:
> When running in protected mode, the hyp stub is disabled after pKVM is
> initialized, meaning the host cannot enable/disable the hyp at
> runtime. As such, kvm_arm_hardware_enabled is always 1 after
> initialization, and kvm_arch_hardware_enable() never enables the vgic
> maintenance irq or timer irqs.
> 
> Unconditionally enable/disable the vgic + timer irqs in the respective
> calls, instead relying on the percpu bookkeeping in the generic code
> to keep track of which cpus have the interrupts unmasked.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Fix hardware enable/disable flows for pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/c718ca0e9940

--
Best,
Oliver
