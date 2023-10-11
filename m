Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A8B7C4BAF
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 09:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344777AbjJKH1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 03:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344185AbjJKH1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 03:27:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E870B98;
        Wed, 11 Oct 2023 00:27:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03683C433C7;
        Wed, 11 Oct 2023 07:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1697009225;
        bh=wdBRBWPG1q+slhhNVCbJyKyr4zxhG5iWNoRBaC45st0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sM6P/GYLthcfQbXg4JirQV4bK0QZKxkEghoQcQYgs8kX/K4EDu95Wcn6L8UQnSDWW
         rZf7pdAcvMFZONtoU2fTHSUZHnC60MjoaJkIYNcuGZQyH3EmdflPgP4Jl75eTej5di
         KYtj+i110e2I/lBBebrafdiPPzsNzo4mviAIPdOE=
Date:   Wed, 11 Oct 2023 09:27:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] RISC-V: KVM: Change the SBI specification version to
 v2.0
Message-ID: <2023101107-endorse-large-ef50@gregkh>
References: <20231010170503.657189-1-apatel@ventanamicro.com>
 <20231010170503.657189-3-apatel@ventanamicro.com>
 <2023101013-overfeed-online-7f69@gregkh>
 <CAK9=C2WbW_WvoU59Ba9VrKf5GbbXmMOhB2jsiAp0a=SJYh3d7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9=C2WbW_WvoU59Ba9VrKf5GbbXmMOhB2jsiAp0a=SJYh3d7w@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 11:49:14AM +0530, Anup Patel wrote:
> On Tue, Oct 10, 2023 at 10:43 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Oct 10, 2023 at 10:34:59PM +0530, Anup Patel wrote:
> > > We will be implementing SBI DBCN extension for KVM RISC-V so let
> > > us change the KVM RISC-V SBI specification version to v2.0.
> > >
> > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > ---
> > >  arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > index cdcf0ff07be7..8d6d4dce8a5e 100644
> > > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > @@ -11,7 +11,7 @@
> > >
> > >  #define KVM_SBI_IMPID 3
> > >
> > > -#define KVM_SBI_VERSION_MAJOR 1
> > > +#define KVM_SBI_VERSION_MAJOR 2
> >
> > What does this number mean?  Who checks it?  Why do you have to keep
> > incrementing it?
> 
> This number is the SBI specification version implemented by KVM RISC-V
> for the Guest kernel.
> 
> The original sbi_console_putchar() and sbi_console_getchar() are legacy
> functions (aka SBI v0.1) which were introduced a few years back along
> with the Linux RISC-V port.
> 
> The latest SBI v2.0 specification (which is now frozen) introduces a new
> SBI debug console extension which replaces legacy sbi_console_putchar()
> and sbi_console_getchar() functions with better alternatives.
> (Refer, https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/commit-fe4562532a9cc57e5743b6466946c5e5c98c73ca/riscv-sbi.pdf)
> 
> This series adds SBI debug console implementation in KVM RISC-V
> so the SBI specification version advertised by KVM RISC-V must also be
> upgraded to v2.0.
> 
> Regarding who checks its, the SBI client drivers in the Linux kernel
> will check SBI specification version implemented by higher privilege
> mode (M-mode firmware or HS-mode hypervisor) before probing
> the SBI extension. For example, the HVC SBI driver (PATCH5)
> will ensure SBI spec version to be at least v2.0 before probing
> SBI debug console extension.

Is this api backwards compatible, or did you just break existing
userspace that only expects version 1.0?

thanks,

greg k-h
