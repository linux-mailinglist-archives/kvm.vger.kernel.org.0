Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19C86FB31B
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 16:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbjEHOmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 10:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjEHOl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 10:41:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E8F659D;
        Mon,  8 May 2023 07:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1D7C64032;
        Mon,  8 May 2023 14:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42548C4339B;
        Mon,  8 May 2023 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683556916;
        bh=YXxl4On9aUp+qENgwuLh+t3KJIhUCYKdbI8RTQ8n8hY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iRzfRfbCybwnwxZuK2UWb0o12Ni2gO3hrV68RhuCx97sWEn8BpGCSso5OMSh04Sc3
         PlBULxZhC3h3b+cLkhXyC9yd4J5nb8bgf4bRdZ+ikUQRfq7j5uqDCbKm4+RL2XEkXZ
         oS8My+zuEVvUJ+S5yIltduZQbX4YkCQvH+mBapZsbFM1OvFq37OWFtMmLqP2Sn/EGC
         P8nD7VXhRU8b1fMkLOPpmlqY3n4kqrQOrC23vG44oayGnHhA3vaWXvX2vHUbQn+FHh
         nQeO6TQ/vLICZQRUsgL3Dlt6PWeIcKlAhzsmcsLFrxSxgGUxV210JuxdXTbTfhsNaQ
         aIgS6UWPb0XZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20FCDE26D2A;
        Mon,  8 May 2023 14:41:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/9] RISC-V KVM virtualize AIA CSRs
From:   patchwork-bot+linux-riscv@kernel.org
Message-Id: <168355691612.25692.18026597841875424784.git-patchwork-notify@kernel.org>
Date:   Mon, 08 May 2023 14:41:56 +0000
References: <20230404153452.2405681-1-apatel@ventanamicro.com>
In-Reply-To: <20230404153452.2405681-1-apatel@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     linux-riscv@lists.infradead.org, pbonzini@redhat.com,
        atishp@atishpatra.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, ajones@ventanamicro.com,
        anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello:

This series was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Tue,  4 Apr 2023 21:04:43 +0530 you wrote:
> The RISC-V AIA specification is now frozen as-per the RISC-V international
> process. The latest frozen specifcation can be found at:
> https://github.com/riscv/riscv-aia/releases/download/1.0-RC3/riscv-interrupts-1.0-RC3.pdf
> 
> This series implements first phase of AIA virtualization which targets
> virtualizing AIA CSRs. This also provides a foundation for the second
> phase of AIA virtualization which will target in-kernel AIA irqchip
> (including both IMSIC and APLIC).
> 
> [...]

Here is the summary with links:
  - [v4,1/9] RISC-V: Add AIA related CSR defines
    https://git.kernel.org/riscv/c/d6f5f6e904be
  - [v4,2/9] RISC-V: Detect AIA CSRs from ISA string
    https://git.kernel.org/riscv/c/8fe6f7e14c7e
  - [v4,3/9] RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
    (no matching commit)
  - [v4,4/9] RISC-V: KVM: Initial skeletal support for AIA
    (no matching commit)
  - [v4,5/9] RISC-V: KVM: Implement subtype for CSR ONE_REG interface
    (no matching commit)
  - [v4,6/9] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
    (no matching commit)
  - [v4,7/9] RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
    (no matching commit)
  - [v4,8/9] RISC-V: KVM: Virtualize per-HART AIA CSRs
    (no matching commit)
  - [v4,9/9] RISC-V: KVM: Implement guest external interrupt line management
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


