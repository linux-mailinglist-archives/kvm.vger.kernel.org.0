Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4A76BDE1F
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCQBUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCQBUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:20:32 -0400
Received: from out-40.mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486DA1FCE
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 18:20:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679016029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nc7w7qAQ6zyR0/2M81jaXDe/qAYliYKNQvNHrFqPVgY=;
        b=Jw6gTg18DP+4XKnTmYJ5Le6tFsjj+OGlSTWIlMNIMDuRTF1ls9M+LX7VGTerh9cp+Ew7jS
        GdAv5vE1Eik0jzRlHRMnSSq2vXUHcU9MNYjjFjP2V4PzdEnlnvNvF0DrGM3vqIdXEUol0c
        dRGpuPA8LzBJ5cYSwhDnFYvn7hsw9bo=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Plug a couple of MM races
Date:   Fri, 17 Mar 2023 01:20:03 +0000
Message-Id: <167901338534.2794852.13463993728106907466.b4-ty@linux.dev>
In-Reply-To: <20230316174546.3777507-1-maz@kernel.org>
References: <20230316174546.3777507-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Mar 2023 17:45:44 +0000, Marc Zyngier wrote:
> Ard recently reported a really odd warning generated with KASAN, where
> the page table walker we use to inspect the userspace page tables was
> going into the weeds and accessing something that was looking totally
> unrelated (and previously freed).
> 
> Will and I spent quite some time looking into it, and while we were
> not able to reproduce the issue, we were able to spot at least a
> couple of issues that could partially explain the issue.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/2] KVM: arm64: Disable interrupts while walking userspace PTs
      https://git.kernel.org/kvmarm/kvmarm/c/e86fc1a3a3e9
[2/2] KVM: arm64: Check for kvm_vma_mte_allowed in the critical section
      https://git.kernel.org/kvmarm/kvmarm/c/8c2e8ac8ad4b

--
Best,
Oliver
