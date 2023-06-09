Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997E1729D4D
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 16:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbjFIOub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 10:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjFIOua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 10:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5BA2715
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 07:50:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A850B60F66
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 14:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10975C4339C;
        Fri,  9 Jun 2023 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686322228;
        bh=Nn/01o7I0aVw4MTKlFdYuagk2aYV5y/tHfOUoSVHBx4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rKgW1rtv1jdX1vycZBtrCW65EiO7PtV5BcAmfWPGd3Ls4oagJX5F8i57AGF59j+BA
         wS2VzG0ofupbmiRY9GJLWLiANRHfCid+o0c9C5xNEYpSicKmM19D9f7edu1Ha3/hiZ
         D4dqkMrTvTrMNCMJS8LMN5VFCiMvP88VrtKy4eNfVc9JgcwYyY3RjrOd0Yyra2BXOf
         y0KjpUi/o/IDPxBC5sW5ZzSi2WfZ2mnVGBtuq62WHWuneTX/Ey4oV5a1sjBs/0rfLW
         ZYmsTODq/FysocmZjeNkC06a+v0RNz+FbWWhxoT2cw+cXw+Xmc4xePzljSKhzYRgTZ
         oPcmdWuqn103A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE47AC395F3;
        Fri,  9 Jun 2023 14:50:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v21 00/27] riscv: Add vector ISA support
From:   patchwork-bot+linux-riscv@kernel.org
Message-Id: <168632222790.22856.6029833581193982930.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jun 2023 14:50:27 +0000
References: <20230605110724.21391-1-andy.chiu@sifive.com>
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com
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

This series was applied to riscv/linux.git (for-next)
by Palmer Dabbelt <palmer@rivosinc.com>:

On Mon,  5 Jun 2023 11:06:57 +0000 you wrote:
> This is the v21 patch series for adding Vector extension support in
> Linux. Please refer to [1] for the introduction of the patchset. The
> v21 patch series was aimed to solve build issues from v19, provide usage
> guideline for the prctl interface, and address review comments on v20.
> 
> Thank every one who has been reviewing, suggesting on the topic. Hope
> this get a step closer to the final merge.
> 
> [...]

Here is the summary with links:
  - [-next,v21,01/27] riscv: Rename __switch_to_aux() -> fpu
    https://git.kernel.org/riscv/c/419d5d38ac5d
  - [-next,v21,02/27] riscv: Extending cpufeature.c to detect V-extension
    https://git.kernel.org/riscv/c/dc6667a4e7e3
  - [-next,v21,03/27] riscv: hwprobe: Add support for probing V in RISCV_HWPROBE_KEY_IMA_EXT_0
    https://git.kernel.org/riscv/c/162e4df137c1
  - [-next,v21,04/27] riscv: Add new csr defines related to vector extension
    https://git.kernel.org/riscv/c/b5665d2a9432
  - [-next,v21,05/27] riscv: Clear vector regfile on bootup
    https://git.kernel.org/riscv/c/6b533828726a
  - [-next,v21,06/27] riscv: Disable Vector Instructions for kernel itself
    https://git.kernel.org/riscv/c/74abe5a39d3a
  - [-next,v21,07/27] riscv: Introduce Vector enable/disable helpers
    https://git.kernel.org/riscv/c/0a3381a01dcc
  - [-next,v21,08/27] riscv: Introduce riscv_v_vsize to record size of Vector context
    https://git.kernel.org/riscv/c/7017858eb2d7
  - [-next,v21,09/27] riscv: Introduce struct/helpers to save/restore per-task Vector state
    https://git.kernel.org/riscv/c/03c3fcd9941a
  - [-next,v21,10/27] riscv: Add task switch support for vector
    https://git.kernel.org/riscv/c/3a2df6323def
  - [-next,v21,11/27] riscv: Allocate user's vector context in the first-use trap
    https://git.kernel.org/riscv/c/cd054837243b
  - [-next,v21,12/27] riscv: Add ptrace vector support
    https://git.kernel.org/riscv/c/0c59922c769a
  - [-next,v21,13/27] riscv: signal: check fp-reserved words unconditionally
    https://git.kernel.org/riscv/c/a45cedaa1ac0
  - [-next,v21,14/27] riscv: signal: Add sigcontext save/restore for vector
    https://git.kernel.org/riscv/c/8ee0b41898fa
  - [-next,v21,15/27] riscv: signal: Report signal frame size to userspace via auxv
    https://git.kernel.org/riscv/c/e92f469b0771
  - [-next,v21,16/27] riscv: signal: validate altstack to reflect Vector
    https://git.kernel.org/riscv/c/76e22fdc2c26
  - [-next,v21,17/27] riscv: prevent stack corruption by reserving task_pt_regs(p) early
    https://git.kernel.org/riscv/c/c7cdd96eca28
  - [-next,v21,18/27] riscv: kvm: Add V extension to KVM ISA
    https://git.kernel.org/riscv/c/bf78f1ea6e51
  - [-next,v21,19/27] riscv: KVM: Add vector lazy save/restore support
    https://git.kernel.org/riscv/c/0f4b82579716
  - [-next,v21,20/27] riscv: hwcap: change ELF_HWCAP to a function
    https://git.kernel.org/riscv/c/50724efcb370
  - [-next,v21,21/27] riscv: Add prctl controls for userspace vector management
    https://git.kernel.org/riscv/c/1fd96a3e9d5d
  - [-next,v21,22/27] riscv: Add sysctl to set the default vector rule for new processes
    https://git.kernel.org/riscv/c/7ca7a7b9b635
  - [-next,v21,23/27] riscv: detect assembler support for .option arch
    https://git.kernel.org/riscv/c/e4bb020f3dbb
  - [-next,v21,24/27] riscv: Enable Vector code to be built
    https://git.kernel.org/riscv/c/fa8e7cce55da
  - [-next,v21,25/27] riscv: Add documentation for Vector
    https://git.kernel.org/riscv/c/04a4722eeede
  - [-next,v21,26/27] selftests: Test RISC-V Vector prctl interface
    https://git.kernel.org/riscv/c/7cf6198ce22d
  - [-next,v21,27/27] selftests: add .gitignore file for RISC-V hwprobe
    https://git.kernel.org/riscv/c/1e72695137ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


