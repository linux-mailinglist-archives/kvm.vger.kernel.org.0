Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E64E66102B
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 17:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjAGQDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Jan 2023 11:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjAGQDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Jan 2023 11:03:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81124F13F;
        Sat,  7 Jan 2023 08:03:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BF6AB80951;
        Sat,  7 Jan 2023 16:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2920FC433D2;
        Sat,  7 Jan 2023 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673107385;
        bh=1hG2Re5Bx7ubivhRbIbvVITI44UJptNZ8stv4wtQE9s=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=l2yG0NujUjGd6IAJ9nY8oZ8h8wCPANX6iws/+UQPV5e98d347cVUVCvPSx45SKYL9
         Mi3hnDa9JKw42K/N53pLG0Npt4NRsgOyPDOt5ezN/yJO/85pcpGfc2FaVMCLaIWzUv
         61bRk01JRJay8sAKHDz4LdodS8tpvpfImB/DftGVSUFyODz9Jj2TJg07yTY872Lom+
         zk/zEL1AZSJdMiMEggIG/oS8yXVkSm3QG7odp8eWJXJ+72ZU8iQD5YoVRZhugEZ+cn
         EctlV3xHNqOzBD5zj/1h0jE3hsJhxCxXnv/VvpFhphbK4mNogJNBPDhKkXZHtYu48c
         E47ZUzKxkgwxw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id BD5835C09F1; Sat,  7 Jan 2023 08:03:04 -0800 (PST)
Date:   Sat, 7 Jan 2023 08:03:04 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Anup Patel <anup@brainfault.org>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH rcu 05/27] arch/riscv/kvm: Remove "select SRCU"
Message-ID: <20230107160304.GZ4028633@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-5-paulmck@kernel.org>
 <CAAhSdy1VsT48WPQHZ5Pj5WNZRPUQvciFPF2LySawVv27tehD+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhSdy1VsT48WPQHZ5Pj5WNZRPUQvciFPF2LySawVv27tehD+g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 07, 2023 at 03:28:06PM +0530, Anup Patel wrote:
> On Thu, Jan 5, 2023 at 6:08 AM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > Now that the SRCU Kconfig option is unconditionally selected, there is
> > no longer any point in selecting it.  Therefore, remove the "select SRCU"
> > Kconfig statements.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Anup Patel <anup@brainfault.org>
> > Cc: Atish Patra <atishp@atishpatra.org>
> > Cc: Paul Walmsley <paul.walmsley@sifive.com>
> > Cc: Palmer Dabbelt <palmer@dabbelt.com>
> > Cc: Albert Ou <aou@eecs.berkeley.edu>
> > Cc: <kvm@vger.kernel.org>
> > Cc: <kvm-riscv@lists.infradead.org>
> > Cc: <linux-riscv@lists.infradead.org>
> 
> For KVM RISC-V:
> Acked-by: Anup Patel <anup@brainfault.org>

Thank you, Anup!  I will apply this on my next rebase.

							Thanx, Paul

> Thanks,
> Anup
> 
> > ---
> >  arch/riscv/kvm/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> > index f36a737d5f96d..6bc9b290c1283 100644
> > --- a/arch/riscv/kvm/Kconfig
> > +++ b/arch/riscv/kvm/Kconfig
> > @@ -27,7 +27,6 @@ config KVM
> >         select KVM_XFER_TO_GUEST_WORK
> >         select HAVE_KVM_VCPU_ASYNC_IOCTL
> >         select HAVE_KVM_EVENTFD
> > -       select SRCU
> >         help
> >           Support hosting virtualized guest machines.
> >
> > --
> > 2.31.1.189.g2e36527f23
> >
