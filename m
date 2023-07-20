Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7863075B3C6
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 18:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjGTQFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 12:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbjGTQEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 12:04:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D94E171E
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 09:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3223D619D3
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 16:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F53AC433CB;
        Thu, 20 Jul 2023 16:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689869088;
        bh=cE3O19oisYoA2D5yqYpCgQsczA/gK1iYyWuDoNHmM/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkCBaPhHPI0FkwISMfUT4p0ENMNO/xc9jVFOt3tXkQdgb568WdysAqPaXu5K4yz3B
         8AjqLsUMj1DImXoWiHn8vkbtPW+X4/w19SD3POlu+ZWPC/sgch+DB5UpasIlLUH4oF
         Z+SNE14Bicgl7IYUryzYC+B8KssvaPgIV66kyoYvFQJfLCbTzq6D/Am/by8PbG1k20
         ncW35ERPE3uqXYUllMnNjeXdIdNu6BHfAQ73EnZjDyd9ZYeEefwefj953dStE5CD2t
         Nh6p2+How7fsv4Em58Jd7wbbbxGb1t4bk9oT5LEMzLNKldKKjWHgYBckRh3dS1BTjy
         VYgjfiXnNma1Q==
From:   Will Deacon <will@kernel.org>
To:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Anup Patel <apatel@ventanamicro.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>
Subject: Re: [kvmtool PATCH v4 0/9] RISC-V SBI enable/disable, Zbb, Zicboz, and Ssaia support
Date:   Thu, 20 Jul 2023 17:04:39 +0100
Message-Id: <168986517012.3086307.1888752231956269805.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230712163501.1769737-1-apatel@ventanamicro.com>
References: <20230712163501.1769737-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jul 2023 22:04:52 +0530, Anup Patel wrote:
> The latest KVM in Linux-6.4 has support for:
> 1) Enabling/disabling SBI extensions from KVM user-space
> 2) Zbb ISA extension support
> 3) Zicboz ISA extension support
> 4) Ssaia ISA extension support
> 
> This series adds corresponding changes in KVMTOOL to use the above
> mentioned features for Guest/VM.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/9] kvm tools: Add __DECLARE_FLEX_ARRAY() in include/linux/stddef.h
      https://git.kernel.org/will/kvmtool/c/d8343698df72
[2/9] Sync-up headers with Linux-6.4
      https://git.kernel.org/will/kvmtool/c/be98682486a0
[3/9] riscv: Allow setting custom mvendorid, marchid, and mimpid
      https://git.kernel.org/will/kvmtool/c/9e9cfde59dfe
[4/9] riscv: Allow disabling SBI extensions for Guest
      https://git.kernel.org/will/kvmtool/c/a416fdc2e664
[5/9] riscv: Sort the ISA extension array alphabetically
      https://git.kernel.org/will/kvmtool/c/b346fabe6d2c
[6/9] riscv: Add zbb extension support
      https://git.kernel.org/will/kvmtool/c/8c1584e776a4
[7/9] riscv: Add Zicboz extension support
      https://git.kernel.org/will/kvmtool/c/8f1e47ca04c9
[8/9] riscv: Add Ssaia extension support
      https://git.kernel.org/will/kvmtool/c/8659200f6931
[9/9] riscv: Fix guest RAM alloc size computation for RV32
      https://git.kernel.org/will/kvmtool/c/106e2ea7756d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
