Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DD76C847C
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 19:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbjCXSH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 14:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjCXSHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 14:07:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C191EBC6
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 11:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 411FCB82548
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 18:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50871C4339C;
        Fri, 24 Mar 2023 18:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679681152;
        bh=FXFeZRDF1NiF4aIUdJx1I3PwOayHinnptrBiDZth4YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihdZuPu36Le9QqF2nPuB3jVqTNQlEV8phDPgNqRJxZbum8yHTju0NYmL5EAH3AFhv
         yhY+nzyCByhZCwksjvkufxw7h0mUZp52dgZacocKrDpdPjHz5+z80pnHiJP3I+3Pbq
         p2NvQSdIi6RBvjVphDlnaW2SsHDQ55MZ/rA96rZ89q6K8odBWsZ+zojWCS8ESwEQdJ
         cfGTWHZ40mF6qPuP41mZ7QvhR+4+u7MHk4J06BtbQaCFp2lbe/uWqcvrtyAU5UjTZM
         R5U1FN7Ow4bcqmGvrZ+eQPWp7B2RKjsoLTEjtrR48wPSM7VLoWHptGrDXTc3d5sOjl
         S3s2DbF21Qbnw==
From:   Will Deacon <will@kernel.org>
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, apatel@ventanamicro.com, atishp@rivosinc.com,
        andre.przywara@arm.com
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 kvmtool 1/1] riscv: Move serial and rtc from IO port space to MMIO area.
Date:   Fri, 24 Mar 2023 18:05:43 +0000
Message-Id: <167967925728.938764.17341365677670878604.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230203122934.18714-1-rkanwal@rivosinc.com>
References: <20230203122934.18714-1-rkanwal@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Feb 2023 12:29:34 +0000, Rajnesh Kanwal wrote:
> The default serial and rtc IO region overlaps with PCI IO bar
> region leading bar 0 activation to fail. Moving these devices
> to MMIO region similar to ARM.
> 
> Given serial has been moved from 0x3f8 to 0x10000000, this
> requires us to now pass earlycon=uart8250,mmio,0x10000000
> from cmdline rather than earlycon=uart8250,mmio,0x3f8.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] riscv: Move serial and rtc from IO port space to MMIO area.
      https://git.kernel.org/will/kvmtool/c/2f030d283c0e

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
