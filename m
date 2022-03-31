Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5723E4ED51E
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 10:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiCaIET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 04:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiCaIES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 04:04:18 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33BBDAFCC
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 01:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Ljnr2vFjApNZSheu0hoKLS+M8qY09rSnnSAIPptuv0M=;
  b=XqN4mdACTB5MdkY2tRJq+CrwjbZA+JBupYSABR7A3eEl/zNKi2mmm/6E
   tvga1VdLH/HlpvvPHq4JBXGiIfQjn4hVZAAEbgptW3U2FOQ1u20N7pyjt
   kDGT6urtfwgSA3xEr9HsEFlBBFd9P/aLIDHDzrJA0weASAQPZH53G9Qy6
   M=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,224,1643670000"; 
   d="scan'208";a="10134955"
Received: from 203.107.68.85.rev.sfr.net (HELO hadrien) ([85.68.107.203])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 10:02:27 +0200
Date:   Thu, 31 Mar 2022 10:02:25 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Anup Patel <apatel@ventanamicro.com>
cc:     kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Anup Patel <anup@brainfault.org>
Subject: Re: question about arch/riscv/kvm/mmu.c
In-Reply-To: <CAK9=C2XYp5a2diGNLf8=a05uPP-gAmUodtMbDWrByiW9skjjmA@mail.gmail.com>
Message-ID: <alpine.DEB.2.22.394.2203311001000.3195@hadrien>
References: <alpine.DEB.2.22.394.2203162205550.3177@hadrien> <CAK9=C2XYp5a2diGNLf8=a05uPP-gAmUodtMbDWrByiW9skjjmA@mail.gmail.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On Thu, 31 Mar 2022, Anup Patel wrote:

> On Thu, Mar 17, 2022 at 2:40 AM Julia Lawall <julia.lawall@inria.fr> wrote:
> >
> > Hello,
> >
> > The function kvm_riscv_stage2_map contains the code:
> >
> > mmu_seq = kvm->mmu_notifier_seq;
> >
> > I noticed that in every other place in the kernel where the
> > mmu_notifier_seq field is read, there is a read barrier after it.  Is
> > there some reason why it is not necessary here?
>
> When I did the initial porting of KVM RISC-V (2 years back), I did
> not see such a barrier being used along with mmu_notifier_seq
> field hence the current code.
>
> I am certainly okay adding it to be consistent with other architectures.
>
> Can you send a patch for this ?

Sure, will do.

julia

>
> Thanks,
> Anup
>
> >
> > thanks,
> > julia
> >
> > --
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv
>
