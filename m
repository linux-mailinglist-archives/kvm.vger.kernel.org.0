Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4839D621ADD
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 18:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiKHRjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 12:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiKHRjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 12:39:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFAC4E412
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 09:38:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 705FFB81BE4
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 17:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E75C433C1;
        Tue,  8 Nov 2022 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667929137;
        bh=wzU5BMT0P2L/QNKYI4eVeLdnt6e73MorMBhHl3eBSTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C88O5RT+f4IG9VpA2nHP4BXGtrr53GpaJXP+VWsQwZ2GhSELSci9yiXU25ZItsgtr
         wQRLeTynUZ04IUTlurzdeebCkYNBdfI1IIrgkOSQVH4774Fo9xsmqojkqka9K6LT1i
         rdN+DIJDUKcXtZvx4MxrkVNLuomE9KF4QOYhE8aZI+DuF6ytg+Z1+s3HcYp8wtoG1Y
         1UY+Afs4CCRS4Cx68pwlux2B+yv7sjsPcwWN5vxi7DDxPlRkzuDRh3AQKBvu0M0pCk
         xxZOSCsistuRC2c2HSqBJhcOQ5MIXIcgfcys+GECKUiiPOqD/4WiKe/dxJ+AEAd5j2
         bY3K+lfAQaMUw==
From:   Will Deacon <will@kernel.org>
To:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Anup Patel <apatel@ventanamicro.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 0/6] RISC-V Svinval, Zihintpause, anad Zicbom support
Date:   Tue,  8 Nov 2022 17:38:38 +0000
Message-Id: <166792166159.1914852.10387116696255694350.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221018140854.69846-1-apatel@ventanamicro.com>
References: <20221018140854.69846-1-apatel@ventanamicro.com>
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

On Tue, 18 Oct 2022 19:38:48 +0530, Anup Patel wrote:
> The latest Linux-6.1-rc1 has support for Svinval, Zihintpause and Zicbom
> extensions in KVM RISC-V. This series adds corresponding changes in KVMTOOL
> to allow Guest/VM use these new RISC-V extensions.
> 
> These patches can also be found in the riscv_svinval_zihintpause_zicbom_v1
> branch at: https://github.com/avpatel/kvmtool.git
> 
> [...]

Applied to kvmtool (master), thanks!

[1/6] Update UAPI headers based on Linux-6.1-rc1
      https://git.kernel.org/will/kvmtool/c/76dfc0cf2d6b
[2/6] riscv: Add Svinval extension support
      https://git.kernel.org/will/kvmtool/c/ac16e9430627
[3/6] riscv: Add zihintpause extension support
      https://git.kernel.org/will/kvmtool/c/23a8ed907331
[4/6] riscv: Move reg encoding helpers to kvm-cpu-arch.h
      https://git.kernel.org/will/kvmtool/c/b721ac0ad88a
[5/6] riscv: Add Zicbom extension support
      https://git.kernel.org/will/kvmtool/c/798398f40a16
[6/6] riscv: Add --disable-<xyz> options to allow user disable extensions
      https://git.kernel.org/will/kvmtool/c/e17d182ad3f7

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
