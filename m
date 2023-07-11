Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5C574F899
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 22:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjGKUBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 16:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjGKUBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 16:01:14 -0400
Received: from out-32.mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEE01718
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 13:01:10 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689105668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H4U0BqZH6IJqZy7LVpNL5UW+eWiw5deb+05/t7QjPmA=;
        b=Q0IkcWGLQ1D3CsbhY2XMmuHN8nUgph7WOGKfiJcHZLLSN2GvQl5d+kl7obg/EPu+63qFn7
        /FscK+P5pCfVMv7GPTnNvPCrofwvE5YolEMldr3Hu2u5MdlwNcNSsPGOyR2QqNmsK4Vs0H
        bUkMrHzftXJsAQCEeFc2o5jY7GPSI30=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        seanjc@google.com, Zenghui Yu <yuzenghui@huawei.com>,
        isaku.yamahata@intel.com, James Morse <james.morse@arm.com>,
        stable@vger.kernek.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
Date:   Tue, 11 Jul 2023 20:00:45 +0000
Message-ID: <168910562680.2605377.17070403411705802542.b4-ty@linux.dev>
In-Reply-To: <20230703163548.1498943-1-maz@kernel.org>
References: <20230703163548.1498943-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Jul 2023 17:35:48 +0100, Marc Zyngier wrote:
> Since 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect
> kvm_usage_count with kvm_lock"), hotplugging back a CPU whilst
> a guest is running results in a number of ugly splats as most
> of this code expects to run with preemption disabled, which isn't
> the case anymore.
> 
> While the context is preemptable, it isn't migratable, which should
> be enough. But we have plenty of preemptible() checks all over
> the place, and our per-CPU accessors also disable preemption.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
      https://git.kernel.org/kvmarm/kvmarm/c/970dee09b230

--
Best,
Oliver
