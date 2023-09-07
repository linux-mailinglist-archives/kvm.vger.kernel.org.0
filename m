Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6662797D5F
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 22:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbjIGU1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 16:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbjIGU1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 16:27:24 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 671BCA8
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 13:27:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00FBCFEC;
        Thu,  7 Sep 2023 13:27:58 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A79733F766;
        Thu,  7 Sep 2023 13:27:18 -0700 (PDT)
Date:   Thu, 7 Sep 2023 21:27:12 +0100
From:   Joey Gouly <joey.gouly@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: Re: [PATCH 0/5] KVM: arm64: Accelerate lookup of vcpus by MPIDR
 values
Message-ID: <20230907202712.GA171716@e124191.cambridge.arm.com>
References: <20230907100931.1186690-1-maz@kernel.org>
 <20230907153052.GD69899@e124191.cambridge.arm.com>
 <871qf9q25c.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qf9q25c.wl-maz@kernel.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023 at 07:17:03PM +0100, Marc Zyngier wrote:
> On Thu, 07 Sep 2023 16:30:52 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> 
> [...]
> 
> > Got a roughly similar perf improvement (about 28%).
> 
> Out of curiosity, on which HW?

I used QEMU emulation, but was told after posting this that QEMU is probably
not good to be used for perf measurments? Sorry about that. I can retry on Juno
tomorrow if that's of any use.

> 
> > Tested-by: Joey Gouly <joey.gouly@arm.com>
> 
> Thanks!
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
