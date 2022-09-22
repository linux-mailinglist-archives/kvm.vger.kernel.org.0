Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80B05E62B7
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiIVMq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiIVMqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:46:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599D3D98CE
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 05:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E813E62E0E
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0017CC433C1;
        Thu, 22 Sep 2022 12:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663850749;
        bh=zHhxvurRntGOnR/12g6NoIT2ncqO0nz6U7y4EKm2iYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgKTsSZMy+MQYXIBNBoif/VLc9a3hqSqRfqImtSsHKuwfolm8tmaVq33Y8tBoi49t
         Yd7zkIzz5dgUvhu9QunUGlWPoKqY2Fv1UNYkm8alHQ+ePTyxRwmsFxq/TqYdR8yNg6
         zXJpfvCRLUwIuEIKszqw9IIMbYtUkewq63FiNZT+6pkDe74kdeFykk6xq7KJt/xg4L
         GGHi+uihduGi7owiJtnRxkjf/KvoB1C+78EhkiSxvjlOE/xBeGEjGL+ClwoMFlEHhz
         VGLHLIgR3O1r3WWvi4PF9wkg+2pzhUAnReP7fV62KtYUDpyB3hb2uB9vzqu014Yd6m
         9aWzNozh1cFiA==
From:   Will Deacon <will@kernel.org>
To:     julien.thierry.kdev@gmail.com,
        Anup Patel <apatel@ventanamicro.com>, maz@kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm-riscv@lists.infradead.org
Subject: Re: [PATCH kvmtool 0/5] KVMTOOL RISC-V Svpbmt and Sstc Support
Date:   Thu, 22 Sep 2022 13:45:38 +0100
Message-Id: <166384971661.148293.7516865524083963807.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220815101325.477694-1-apatel@ventanamicro.com>
References: <20220815101325.477694-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Aug 2022 15:43:20 +0530, Anup Patel wrote:
> The latest Linux-6.0-rc1 has support for Svpbmt and Sstc extensions
> in KVM RISC-V. This series adds corresponding changes in KVMTOOL to
> allow Guest/VM use these new RISC-V extensions.
> 
> The PATCH5 is an unrelated fix which was discovered while developing
> this series.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/5] Update UAPI headers based on Linux-6.0-rc1
      https://git.kernel.org/will/kvmtool/c/8d0facec06ae
[2/5] riscv: Append ISA extensions to the device tree
      https://git.kernel.org/will/kvmtool/c/8aff29e1dafe
[3/5] riscv: Add Svpbmt extension support
      https://git.kernel.org/will/kvmtool/c/2b4fe0f8cff1
[4/5] riscv: Add Sstc extension support
      https://git.kernel.org/will/kvmtool/c/3c07aeaf993a
[5/5] riscv: Fix serial0 alias path
      https://git.kernel.org/will/kvmtool/c/ed805be52f57

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
