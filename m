Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A257227D8
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjFENtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbjFENtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:49:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1CDE8
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 06:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B30E26222F
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 13:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2444DC433D2;
        Mon,  5 Jun 2023 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685972985;
        bh=EdmQBMCh9JLq24i7HrksGwL+NAy9ZjEDJv+yNXwM4CA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=czqFZ9bac4HYOz/vSZ255HcZptTYlKfz0u42Ou0Qe741pehujlZgQ+uvoB1pARZgK
         xcQRFvHfgJwF3ifkckd/raj1RhiBE1vfrku2b9/iCkb9bjC6ZdIVeyt2G2gmzBXCpA
         g+d1SiL3OENP+1pdwqLvPEJKNNXwzg2WJzH5VcbOTH24Q3ZbIuaDXYoBa+uLOqN6h9
         +InKsuLA9WxgzFIwgnzR3GqbLB1HxKVbh5AgCWYrdHD8mvBE4Rp5R+6xfXIdAHecsJ
         BClgAYQHXPyGnQGEKz5fsaG7t0UbfkPYi61KbrR1CtzdmH8JOlpeC8bHilD1SO8Jc+
         1LPuUSKi0/jEw==
Date:   Mon, 5 Jun 2023 14:49:39 +0100
From:   Will Deacon <will@kernel.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: Re: [PATCH kvmtool 1/8] Sync-up headers with Linux-6.4-rc1
Message-ID: <20230605134938.GA21212@willie-the-truck>
References: <20230510083748.1056704-1-apatel@ventanamicro.com>
 <20230510083748.1056704-2-apatel@ventanamicro.com>
 <20230605121221.GA20843@willie-the-truck>
 <CAK9=C2WfNSsW-OODnNVrrxq9YvxBqjT94tWp81pBiKj5e-jjVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9=C2WfNSsW-OODnNVrrxq9YvxBqjT94tWp81pBiKj5e-jjVQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 07:04:27PM +0530, Anup Patel wrote:
> On Mon, Jun 5, 2023 at 5:42 PM Will Deacon <will@kernel.org> wrote:
> > On Wed, May 10, 2023 at 02:07:41PM +0530, Anup Patel wrote:
> > > We sync-up Linux headers to get latest KVM RISC-V headers having
> > > SBI extension enable/disable, Zbb, Zicboz, and Ssaia support.
> > >
> > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > ---
> > >  arm/aarch64/include/asm/kvm.h |  38 ++++++++++++
> > >  include/linux/kvm.h           |  57 +++++++++++-------
> > >  include/linux/virtio_blk.h    | 105 ++++++++++++++++++++++++++++++++++
> > >  include/linux/virtio_config.h |   6 ++
> > >  include/linux/virtio_net.h    |   5 ++
> > >  riscv/include/asm/kvm.h       |  56 +++++++++++++++++-
> > >  x86/include/asm/kvm.h         |  50 ++++++++++++----
> > >  7 files changed, 286 insertions(+), 31 deletions(-)
> >
> > This breaks the build for x86:
> >
> > Makefile:386: Skipping optional libraries: vncserver SDL
> >   CC       builtin-balloon.o
> > In file included from include/linux/kvm.h:15,
> >                  from include/kvm/pci.h:5,
> >                  from include/kvm/vfio.h:6,
> >                  from include/kvm/kvm-config.h:5,
> >                  from include/kvm/kvm.h:6,
> >                  from builtin-balloon.c:9:
> > x86/include/asm/kvm.h:511:17: error: expected specifier-qualifier-list before ‘__DECLARE_FLEX_ARRAY’
> >   511 |                 __DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_data, vmx);
> >       |                 ^~~~~~~~~~~~~~~~~~~~
> > make: *** [Makefile:508: builtin-balloon.o] Error 1
> 
> It seems __DECLARE_FLEX_ARRAY() is not defined in
> include/linux/stddef.h header of KVMTOOL.
> 
> I will send v2 series with this fixed.

Alternatively, you could take a look at the series from Oliver which
also pulls in the -rc1 headers (I've not had chance to test it out yet,
though).

https://lore.kernel.org/r/20230526221712.317287-1-oliver.upton@linux.dev

Will
