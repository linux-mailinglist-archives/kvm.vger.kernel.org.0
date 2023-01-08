Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC5E661875
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 20:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjAHTNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 14:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbjAHTNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 14:13:23 -0500
Received: from out-221.mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2187864D1
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 11:13:19 -0800 (PST)
Date:   Sun, 8 Jan 2023 11:13:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673205197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EtOSkw9vvFtKfh4yvVAsnzJijn2Et/7oRxLgfYGNWPI=;
        b=nPcwPea7zsQ+ilcb/b+J2Xj1qgcWvzZyxqZmMpc4PtNi+4wDs2HPxcPMLTe/clGPcB55oZ
        yyBr23fALcfqDT6tOw/U7QL8LBqazEiCBTf9GaePEbT5W2Vanr5ZHY1bu4hyg17TNEjAO5
        1Nfjo46XI8Ai3XOCYDVZCE6VKJBISd8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 2/7] KVM: arm64: PMU: Use reset_pmu_reg() for
 PMUSERENR_EL0 and PMCCFILTR_EL0
Message-ID: <Y7sVx8sv2BYiMihZ@thinky-boi>
References: <20221230035928.3423990-1-reijiw@google.com>
 <20221230035928.3423990-3-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230035928.3423990-3-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 29, 2022 at 07:59:23PM -0800, Reiji Watanabe wrote:
> The default reset function for PMU registers (reset_pmu_reg())
> now simply clears a specified register. Use that function for
> PMUSERENR_EL0 and PMCCFILTR_EL0, since those registers should
> simply be cleared on vCPU reset.

AFAICT, the fields in both these registers have UNKNOWN reset values. Of
course, 0 is an entirely valid reset value but the architectural
behavior should be mentioned in the commit message.

--
Thanks,
Oliver
