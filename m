Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEF7621858
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 16:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbiKHPeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 10:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbiKHPeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 10:34:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B556A58BC9
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 07:34:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FD7561642
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 15:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04364C433D6;
        Tue,  8 Nov 2022 15:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667921642;
        bh=iO5KoSn7HM9LXCUWklPwNrj91yb8tSVOgpDeFSxsog4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OsYH+9VNB7T6V18c7bM7Xw6tU2DdxTs7+t96qLFtSiba/toyNLucXeVJYTyEIQMce
         5t8d5jpBWlEfvUICLsunwOuQAurY150KUQQlaF/JcKB+T5WUbQ/9lq5UTB9d5F+zFB
         zuBMK/isVKjGS+V0vkFdWga5K2ert9kJl+ifoJPeoBXuu03i0yDvfcxurtBEf8niQB
         9Y9bwCzhBTFYLhfl2NC9LA9MiF4qAL2YPMalVoh/Y4h7Z/hzD1jBvO60s3aNGTTdkk
         KeQL9nW1GBhFsfytW40Qlfno0G8rO4m8kcAZIlz54ccnTdbyKiJtrjp0SPIvm9RF0U
         VbpZwV3puWz2g==
Date:   Tue, 8 Nov 2022 15:33:57 +0000
From:   Will Deacon <will@kernel.org>
To:     Anup Patel <anup@brainfault.org>
Cc:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Anup Patel <apatel@ventanamicro.com>
Subject: Re: [PATCH kvmtool 0/6] RISC-V Svinval, Zihintpause, anad Zicbom
 support
Message-ID: <20221108153355.GA23117@willie-the-truck>
References: <20221018140854.69846-1-apatel@ventanamicro.com>
 <CAAhSdy0KcB9_0zh9eHECW1PLN+zAAEpyL5zPWT4VB_8fQ5+4Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhSdy0KcB9_0zh9eHECW1PLN+zAAEpyL5zPWT4VB_8fQ5+4Yw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 05:50:16PM +0530, Anup Patel wrote:
> On Tue, Oct 18, 2022 at 7:39 PM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > The latest Linux-6.1-rc1 has support for Svinval, Zihintpause and Zicbom
> > extensions in KVM RISC-V. This series adds corresponding changes in KVMTOOL
> > to allow Guest/VM use these new RISC-V extensions.
> >
> > These patches can also be found in the riscv_svinval_zihintpause_zicbom_v1
> > branch at: https://github.com/avpatel/kvmtool.git
> >
> > Andrew Jones (2):
> >   riscv: Move reg encoding helpers to kvm-cpu-arch.h
> >   riscv: Add Zicbom extension support
> >
> > Anup Patel (3):
> >   Update UAPI headers based on Linux-6.1-rc1
> >   riscv: Add Svinval extension support
> >   riscv: Add --disable-<xyz> options to allow user disable extensions
> >
> > Mayuresh Chitale (1):
> >   riscv: Add zihintpause extension support
> >
> >  arm/aarch64/include/asm/kvm.h       |  6 ++++--
> >  include/linux/kvm.h                 |  1 +
> >  include/linux/virtio_blk.h          | 19 +++++++++++++++++++
> >  include/linux/virtio_net.h          | 14 +++++++-------
> >  include/linux/virtio_ring.h         | 16 +++++++++++-----
> >  riscv/fdt.c                         | 23 +++++++++++++++++++++--
> >  riscv/include/asm/kvm.h             |  4 ++++
> >  riscv/include/kvm/kvm-config-arch.h | 18 +++++++++++++++++-
> >  riscv/include/kvm/kvm-cpu-arch.h    | 19 +++++++++++++++++++
> >  riscv/kvm-cpu.c                     | 16 ----------------
> >  10 files changed, 103 insertions(+), 33 deletions(-)
> >
> > --
> > 2.34.1
> >
> 
> Friendly ping ?
> 
> Please check this series.

It's all a random sequence of letters to me, so I guess I'll apply it :)

Will
