Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC1C38CC93
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 19:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbhEURtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 13:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235755AbhEURtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 13:49:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FA836135C;
        Fri, 21 May 2021 17:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621619273;
        bh=xOq3jj2UbZa7lDCzy39FJlunDF10xKfCJ5FyeAWwORQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KBD6lbrTjL2LnMejfzX5ud65busPKGi/lpJ5soBktqKEEpW0q6Q6RPLPSTn5hfIHM
         +M+fDBS/u7VpUhjC6axyc2792Z/IHzPsQ6ZlEk30RF72T56Ut8cvZkW3OYoikfOVsI
         An7+UKMeTx7OhM7Vig7bmYyLVyhSJqX/6Jz6i2BU=
Date:   Fri, 21 May 2021 19:47:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>, anup@brainfault.org,
        Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, corbet@lwn.net, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
Message-ID: <YKfyR5jUu3HMvYg5@kroah.com>
References: <mhng-37377fcb-af8f-455c-be08-db1cd5d4b092@palmerdabbelt-glaptop>
 <ff55329c-709d-c1a5-a807-1942f515bba7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff55329c-709d-c1a5-a807-1942f515bba7@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 07:21:12PM +0200, Paolo Bonzini wrote:
> On 21/05/21 19:13, Palmer Dabbelt wrote:
> > > 
> > 
> > I don't view this code as being in a state where it can be
> > maintained, at least to the standards we generally set within the
> > kernel.  The ISA extension in question is still subject to change, it
> > says so right at the top of the H extension <https://github.com/riscv/riscv-isa-manual/blob/master/src/hypervisor.tex#L4>
> > 
> >   {\bf Warning! This draft specification may change before being
> > accepted as standard by the RISC-V Foundation.}
> 
> To give a complete picture, the last three relevant changes have been in
> August 2019, November 2019 and May 2020.  It seems pretty frozen to me.
> 
> In any case, I think it's clear from the experience with Android that
> the acceptance policy cannot succeed.  The only thing that such a policy
> guarantees, is that vendors will use more out-of-tree code.  Keeping a
> fully-developed feature out-of-tree for years is not how Linux is run.
> 
> > I'm not sure where exactly the line for real hardware is, but for
> > something like this it would at least involve some chip that is
> > widely availiable and needs the H extension to be useful
> 
> Anup said that "quite a few people have already implemented RISC-V
> H-extension in hardware as well and KVM RISC-V works on real HW as well".
> Those people would benefit from having KVM in the Linus tree.

Great, but is this really true?  If so, what hardware has this?  I have
a new RISC-V device right here next to me, what would I need to do to
see if this is supported in it or not?

If this isn't in any hardware that anyone outside of
internal-to-company-prototypes, then let's wait until it really is in a
device that people can test this code on.

What's the rush to get this merged now if no one can use it?

thanks,

greg k-h
