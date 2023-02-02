Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE1A688AF1
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 00:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjBBXkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 18:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjBBXkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 18:40:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6785561D73;
        Thu,  2 Feb 2023 15:40:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2C9761D1A;
        Thu,  2 Feb 2023 23:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 571D0C433EF;
        Thu,  2 Feb 2023 23:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675381235;
        bh=aD0wz/pJ0BiJsKx6MNlQbfZ5Myimjsn4T14W0hANWRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QKCpMmSWQfJed7D9pDLAvYigyp1GMf7W1KlxCHCBuzIpFquK+tsbF3exUEZtXWIiA
         qfS8WLdY9fJOB9Poz+B6rG7yJUkafX6mx1vTEwDL638B+gGZL0oq5OZh0SCTeMaXyB
         zSpneZAPLZKpenjSrgiSNmDJWeN6D0nF6HL+XhjG6/mrBYbkao4ExKLOkgbSFeQvOu
         On0GhSg6cxLFmi3+vw1YWyl42uZTbtA0XVL57GkWS4Yoa8mWxJAV6Ob1Hi6G6c/GX5
         CTAmex1VLHuY/Lc9/PtGOLu0psDRAtkFsg4JUnlD1KKZgoPxpvP2EAV0qVnl2mu5GX
         3fCxqMxTbCgLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F03BE21EEC;
        Thu,  2 Feb 2023 23:40:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
From:   patchwork-bot+linux-riscv@kernel.org
Message-Id: <167538123525.14322.1108858489360294941.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 23:40:35 +0000
References: <20230128172856.3814-1-jszhang@kernel.org>
In-Reply-To: <20230128172856.3814-1-jszhang@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
        anup@brainfault.org, atishp@atishpatra.org, heiko@sntech.de,
        ajones@ventanamicro.com, conor.dooley@microchip.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
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

On Sun, 29 Jan 2023 01:28:43 +0800 you wrote:
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
  - [v5,01/13] riscv: move riscv_noncoherent_supported() out of ZICBOM probe
    https://git.kernel.org/riscv/c/abcc445acdbe
  - [v5,02/13] riscv: cpufeature: detect RISCV_ALTERNATIVES_EARLY_BOOT earlier
    https://git.kernel.org/riscv/c/191b27c7c0e8
  - [v5,03/13] riscv: hwcap: make ISA extension ids can be used in asm
    https://git.kernel.org/riscv/c/d8a3d8a75206
  - [v5,04/13] riscv: cpufeature: extend riscv_cpufeature_patch_func to all ISA extensions
    https://git.kernel.org/riscv/c/4bf8860760d9
  - [v5,05/13] riscv: introduce riscv_has_extension_[un]likely()
    https://git.kernel.org/riscv/c/bdda5d554e43
  - [v5,06/13] riscv: fpu: switch has_fpu() to riscv_has_extension_likely()
    https://git.kernel.org/riscv/c/702e64550b12
  - [v5,07/13] riscv: module: move find_section to module.h
    https://git.kernel.org/riscv/c/e0c267e03b0c
  - [v5,08/13] riscv: module: Add ADD16 and SUB16 rela types
    https://git.kernel.org/riscv/c/1bc400ffb52b
  - [v5,09/13] riscv: switch to relative alternative entries
    https://git.kernel.org/riscv/c/8d23e94a4433
  - [v5,10/13] riscv: alternative: patch alternatives in the vDSO
    https://git.kernel.org/riscv/c/cabfd146b371
  - [v5,11/13] riscv: cpu_relax: switch to riscv_has_extension_likely()
    https://git.kernel.org/riscv/c/95bc69a47be2
  - [v5,12/13] riscv: KVM: Switch has_svinval() to riscv_has_extension_unlikely()
    https://git.kernel.org/riscv/c/e8ad17d2b5f3
  - [v5,13/13] riscv: remove riscv_isa_ext_keys[] array and related usage
    https://git.kernel.org/riscv/c/03966594e117

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


