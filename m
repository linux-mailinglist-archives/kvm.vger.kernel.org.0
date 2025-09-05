Return-Path: <kvm+bounces-56893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1E0B45C9F
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 17:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BA4E7A911C
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 15:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F97288C0E;
	Fri,  5 Sep 2025 15:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="owBLh8CY"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454E32F1FD1
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 15:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757086285; cv=none; b=GIID9ZyFDGBhBLZTRdqNEPLWCmlRxUubjo7g+zfzZJv/LYPgBT2Gd3QK8NEEWRNIi6UBtvidPgEHJvqEXOdL3+x512kCfTwRwlhnZpPtIDltMsMVpMXmaWjv4mK6WXmyfMOPHCTwvb40TsjbuZqD6ACL3807Fre1enqeurC6Mcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757086285; c=relaxed/simple;
	bh=wzG2lnHPN2F8fvVd9F6GGAHU+npkUgJbqXnQ/SIdMDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bkSWDV5FFAnpoo88VKymQcYXZ/MoIz2Un/YXqxLA52EDYAXS3tZ4s/wcpMTFmD4mDY5xE7aNFHWM5GMQekZLliF5UZgtrZhfS9dASf9dgle9jzC/RnKL7mYB2f+73/ijyttMkYUSePvTPh/qTTqrOKTnOWmHDbFmWX1PysoBwec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=owBLh8CY; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 5 Sep 2025 10:31:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757086279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oSeZxdMsuw6Z2poCMeEkBswxhwvL2OzwHT8BiaKUwhg=;
	b=owBLh8CY+Jo16DSfNvepvejZHN+5nuXZKIMNLZPRudno405ir7arK0xzu0El3RoB6lB/iP
	pVgREAkR3BnY4pcRHeALllE1ccQ0Z3aIxp1QydMxLhUZJxUMY+3dqumlVrqQx27gUOxQoJ
	zBUzZ6ka88jkWtWdsyVh9PHbRAhbArc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Joel Stanley <joel@jms.id.au>, kvm-riscv@lists.infradead.org, 
	Buildroot Mailing List <buildroot@buildroot.org>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests] riscv build failure
Message-ID: <20250905-d9a046fd4787ec78ab611495@orel>
References: <CACPK8XddfiKcS_-pYwG5b7i8pwh7ea-QDA=fwZgkP245Ad9ECQ@mail.gmail.com>
 <20250904-11ba6fa251f914016170c0e4@orel>
 <csh2fzymze636erajmsu5d55id6fpfsnvypkz3at7anp5i35uw@fhn2qgz327vj>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <csh2fzymze636erajmsu5d55id6fpfsnvypkz3at7anp5i35uw@fhn2qgz327vj>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 05, 2025 at 06:26:55PM +1000, Nicholas Piggin wrote:
> On Thu, Sep 04, 2025 at 05:17:45PM -0500, Andrew Jones wrote:
> > On Thu, Sep 04, 2025 at 08:57:54AM +0930, Joel Stanley wrote:
> > > I'm building kvm-unit-tests as part of buildroot and hitting a build
> > > failure. It looks like there's a missing dependency on
> > > riscv/sbi-asm.S, as building that manually fixes the issue. Triggering
> > > buildroot again (several times) doesn't resolve the issue so it
> > > doesn't look like a race condition.
> > > 
> > > I can't reproduce with a normal cross compile on my machine. Buildroot
> > > uses make -C, in case that makes a difference.
> > > 
> > > The build steps look like this:
> > > 
> > > bzcat /localdev/jms/buildroot/dl/kvm-unit-tests/kvm-unit-tests-v2025-06-05.tar.bz2
> > > | /localdev/jms/buildroot/output-riscv-rvv/host/bin/tar
> > > --strip-components=1 -C
> > > /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
> > >   -xf -
> > > cd /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
> > > && ./configure --disable-werror --arch="riscv64" --processor=""
> > > --endian="little"
> > > --cross-prefix="/localdev/jms/buildroot/output-riscv-rvv/host/bin/riscv64-buildroot-linux-gnu-"
> > > GIT_DIR=. PATH="/localdev/jms/buildroot/output-riscv-rvv/host/bin:/localdev/jms/buildroot/output-riscv-rvv/host/sbin:/home/jms/.local/bin:/home/jms/bin:/home/jms/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
> > > /usr/bin/make -j385  -C
> > > /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
> > > standalone
> > 
> > I applied similar steps but couldn't reproduce this. It also looks like we
> > have a dependency because configuring with '--cc=/path/to/mygcc', where
> > mygcc is
> > 
> >    #!/bin/bash
> >    for x in $@; do
> >        if [[ $x =~ sbi-asm ]] && ! [[ $x =~ sbi-asm-offsets ]]; then
> >            sleep 5
> >            break
> >        fi
> >    done
> >    /path/to/riscv64-linux-gnu-gcc $@
> > 
> > stalls the build 5 seconds when compiling sbi-asm.S but doesn't reproduce
> > the issue. That said, running make with -d shows that riscv/sbi-asm.o is
> > an implicit prerequisite, although so are other files. I'm using
> > GNU Make 4.4.1. Which version are you using?
> > 
> > Also, while the steps above shouldn't cause problems, they are a bit odd
> >  * '--endian' only applies to ppc64
> >  * -j385 is quite large and specific. Typicall -j$(nproc) is recommended.
> >  * No need for '-C "$PWD"'
> 
> Thanks for taking a look, it's Make 4.2.1 at least. I tracked it down
> to second expansion barfing when the variable name has a / in it. It
> looks like it can be fixed with the below, so I didn't look too closely
> at whether that's a bug, in what versions, or not previously supported
> because I was able to fix it like this.
> 
> Thanks,
> Nick
> 
>     build: work around second expansion limitation with some Make versions
>     
>     GNU Make 4.2.1 as shipped in Ubuntu 20.04 has a problem with secondary
>     expansion and variable names containing the '/' character. Make 4.3 and
>     4.4 don't have the problem.
>     
>     Avoid putting the riscv/ directory name in the sbi-deps variable, and
>     instead strip the directory off the target name when turning it into
>     the dependency variable name.
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index beaeaefa..64720c38 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -18,12 +18,12 @@ tests += $(TEST_DIR)/isa-dbltrp.$(exe)
>  
>  all: $(tests)
>  
> -$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-asm.o
> -$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-dbtr.o
> -$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-fwft.o
> -$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-sse.o
> +sbi-deps += $(TEST_DIR)/sbi-asm.o
> +sbi-deps += $(TEST_DIR)/sbi-dbtr.o
> +sbi-deps += $(TEST_DIR)/sbi-fwft.o
> +sbi-deps += $(TEST_DIR)/sbi-sse.o
>  
> -all_deps += $($(TEST_DIR)/sbi-deps)
> +all_deps += $(sbi-deps)
>  
>  # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
>  $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
> @@ -113,7 +113,7 @@ cflatobjs += lib/efi.o
>  .PRECIOUS: %.so
>  
>  %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
> -%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o $$($$*-deps)
> +%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o $$($$(notdir $$*)-deps)
>  	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
>  		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
>  
> @@ -129,7 +129,7 @@ cflatobjs += lib/efi.o
>  		-O binary $^ $@
>  else
>  %.elf: LDFLAGS += -pie -n -z notext
> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o $$($$*-deps)
> +%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o $$($$(notdir $$*)-deps)
>  	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
>  		$(filter %.o, $^) $(FLATLIBS)
>  	@chmod a-x $@

Thanks, Nicholas.

This looks good to me. Can you please send as an independent patch with
your sign-off?

Thanks,
drew

