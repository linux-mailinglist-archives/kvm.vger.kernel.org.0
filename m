Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57209749F0F
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 16:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjGFOdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 10:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjGFOdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 10:33:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6822910F5
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 07:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0064D6197C
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 14:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40B3C433C7;
        Thu,  6 Jul 2023 14:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688654019;
        bh=8u+Hv3WfH+J/Q2HchZKI0zrWzw9DQqG91tEM01FyvXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+Oo1SuJN8rdzzZh6PUelFBZW7VCR5hh3BSySMGJBepPZZYoHG0d17mkQPvbEqbIc
         rR8Hf+QY4FSe+xivykiUUEEJcUOVe0Iu5kziLoOrT0x3JTRmp9B9MBib5bZ78kvzyH
         4FZYGhmPCSvFW7Kpqs+tNKcLsk8H0e7bGMQRP4z1uMz3MaZrXfVj8jrn/52TGOSnYS
         xMzUBNkgp2PayL4YC+x+2P5lmxUbVSAZ3M5f53rvK1/Ws/GEUmEZsXTls0lg5QCd4R
         SchgN359VmXdxnM6cBw+Dh4HqlJz74qlCkp3Y9c/UvEyrkDBakdnquU45Sl+8Flb4x
         kwpMuLEZp7Urw==
Date:   Thu, 6 Jul 2023 15:33:34 +0100
From:   Will Deacon <will@kernel.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 1/8] Sync-up headers with Linux-6.4-rc5
Message-ID: <20230706143333.GA29413@willie-the-truck>
References: <20230605140208.272027-1-apatel@ventanamicro.com>
 <20230605140208.272027-2-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605140208.272027-2-apatel@ventanamicro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 07:32:01PM +0530, Anup Patel wrote:
> We sync-up Linux headers to get latest KVM RISC-V headers having
> SBI extension enable/disable, Zbb, Zicboz, and Ssaia support.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---

Now that 6.4 is released, mind resending this series with a snap to the
released kernel headers instead?

Cheers,

Will
