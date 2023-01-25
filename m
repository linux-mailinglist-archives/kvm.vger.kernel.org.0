Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462E567A964
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 04:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbjAYDuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 22:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYDuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 22:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385BC4863A;
        Tue, 24 Jan 2023 19:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABD5A61444;
        Wed, 25 Jan 2023 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06804C433D2;
        Wed, 25 Jan 2023 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674618619;
        bh=OGOOxscv3pLswnr3v5bGmdovPZ+cxPyFs3HDLZAlpLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ti634rysOu54xHK5FH5WwlxZATlXozR8wPVaDT78pU+UgsersLt5Rti3NlyjFp39x
         NVOIkkFkw7dA3C+xFMtHl7YiS8oOr+GLzG1LeQHNum7VobiWnEYiXFsPpT+fSTJcJO
         6n+ffLCGpmWXHwmZIInyKFYCeFmi2wCCgGv+RuXQKdTh7TpWhooE0nyoujRJUtuhI+
         X1c3ZkIaRmiRZPmEnwOS/2/8ewNTgmL20ybKk+OPi4nSTOZaaqCACiWQlcTI2PTQiq
         9I5etNCOxDJu8rR58pt8aDxybUmJmKvPWCxM23h4m7e6ze52DJtDNfw/6/bhqg5INi
         wOkdT/az3zbIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4EF8F83ED2;
        Wed, 25 Jan 2023 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 00/13] riscv: improve boot time isa extensions handling
From:   patchwork-bot+linux-riscv@kernel.org
Message-Id: <167461861886.411.4529941581273369452.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 03:50:18 +0000
References: <20230115154953.831-1-jszhang@kernel.org>
In-Reply-To: <20230115154953.831-1-jszhang@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, anup@brainfault.org,
        atishp@atishpatra.org, heiko@sntech.de, conor.dooley@microchip.com,
        ajones@ventanamicro.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello:

This series was applied to riscv/linux.git (for-next)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Sun, 15 Jan 2023 23:49:40 +0800 you wrote:
> Generally, riscv ISA extensions are fixed for any specific hardware
> platform, so a hart's features won't change after booting, this
> chacteristic makes it straightforward to use a static branch to check
> a specific ISA extension is supported or not to optimize performance.
> 
> However, some ISA extensions such as SVPBMT and ZICBOM are handled
> via. the alternative sequences.
> 
> [...]

Here is the summary with links:
  - [v4,01/13] riscv: fix jal offsets in patched alternatives
    https://git.kernel.org/riscv/c/9d5567ccf96f
  - [v4,02/13] riscv: move riscv_noncoherent_supported() out of ZICBOM probe
    (no matching commit)
  - [v4,03/13] riscv: cpufeature: detect RISCV_ALTERNATIVES_EARLY_BOOT earlier
    (no matching commit)
  - [v4,04/13] riscv: hwcap: make ISA extension ids can be used in asm
    (no matching commit)
  - [v4,05/13] riscv: cpufeature: extend riscv_cpufeature_patch_func to all ISA extensions
    (no matching commit)
  - [v4,06/13] riscv: introduce riscv_has_extension_[un]likely()
    (no matching commit)
  - [v4,07/13] riscv: fpu: switch has_fpu() to riscv_has_extension_likely()
    (no matching commit)
  - [v4,08/13] riscv: module: move find_section to module.h
    (no matching commit)
  - [v4,09/13] riscv: switch to relative alternative entries
    (no matching commit)
  - [v4,10/13] riscv: alternative: patch alternatives in the vDSO
    (no matching commit)
  - [v4,11/13] riscv: cpu_relax: switch to riscv_has_extension_likely()
    (no matching commit)
  - [v4,12/13] riscv: KVM: Switch has_svinval() to riscv_has_extension_unlikely()
    (no matching commit)
  - [v4,13/13] riscv: remove riscv_isa_ext_keys[] array and related usage
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


