Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EB77D9E2D
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 18:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345718AbjJ0QrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjJ0QrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 12:47:01 -0400
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86240128
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 09:46:57 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698425215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/gwQv8qy443fb2wqDjI8hOdX2omLUKf6t4hBomdgNUg=;
        b=FGy5oKhOPqivU6LBAEY0Utp8SoLLK2KUi4uRZpFgVEEFcuY3zLJd8SFtAFvJwPWuVHuN3J
        dSaH9BzTaIJFxJKo9NybBPc0RrqTlt2GkdaxFtDe+Ai9PaFmLI3XeI0bw+ZOjZtjTCsRKX
        Gm/FQHbzdHPEeQA4w5eNZBsBuCE0hMA=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Add tracepoint for MMIO accesses where ISV==0
Date:   Fri, 27 Oct 2023 16:46:42 +0000
Message-ID: <169842519565.3393490.939837360614388920.b4-ty@linux.dev>
In-Reply-To: <20231026205306.3045075-1-oliver.upton@linux.dev>
References: <20231026205306.3045075-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Oct 2023 20:53:06 +0000, Oliver Upton wrote:
> It is a pretty well known fact that KVM does not support MMIO emulation
> without valid instruction syndrome information (ESR_EL2.ISV == 0). The
> current kvm_pr_unimpl() is pretty useless, as it contains zero context
> to relate the event to a vCPU.
> 
> Replace it with a precise tracepoint that dumps the relevant context
> so the user can make sense of what the guest is doing.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Add tracepoint for MMIO accesses where ISV==0
      https://git.kernel.org/kvmarm/kvmarm/c/9ec605adafbd

--
Best,
Oliver
