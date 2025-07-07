Return-Path: <kvm+bounces-51690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 030F0AFBA2A
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 19:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE32C7A15F9
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 17:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41487262FD5;
	Mon,  7 Jul 2025 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RI5Nhayh"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C361E25FA
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751910824; cv=none; b=i+fS6WsWHG0C8al9MCrx2ozMiPlld91R1yl7z0TdBoTibyJPKXlpVTiNXFkd6vkiayLrIw8gj6PWU80YbWfSIXWi/UmEM7YaF956qjIOtaqfaO+OzB4d9fMX8mrBD9ILVaeAEh0FLcddtjtkbe6jkiQ41hvI445k8BPC7ioFjHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751910824; c=relaxed/simple;
	bh=FstgiVezS+Cw4bDkM5mjMlSN7kCGC2v6i5mmTGG3mIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i0+XbvOpY4HZ3WolqnuXaDBqxq+22taNRPeO4bK/I8M/mPB/+dlNzxhxdcP7lfEXBOvEaEutvZ8Jk3oRH3bSoPzjlcsojjrXnhHKO2aR8qouNT2i9CaTfLz6DA61ZVznv5M0eWUXo4W47eZ1eEAqoMPVvVaD45h5J1IUcS3Q9Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RI5Nhayh; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 7 Jul 2025 19:53:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751910809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VX5mOV2ECOy6u103HTCnW/J+6b4n2WBzehnt0d4S7Wg=;
	b=RI5Nhayh8Fr9nxe3pak2axqXExcuDOeR7ka7nKly+UZdcMtGZAek5Ps+eNublCjABLL+yv
	t8kOCa5SO2GHLb6bCcM14Gbb8ClYDKYAtI4uFFaE51GMjfMoUGkHDqtzLfhvUiXlsk8f5w
	kT4r/kWyk18GHvUoNBVr/Dg82P+A7kw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jesse Taube <jesse@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Charlie Jenkins <charlie@rivosinc.com>, James Raphael Tiovalen <jamestiotio@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Cade Richard <cade.richard@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] riscv: lib: Add sbi-exit-code to
 configure and environment
Message-ID: <20250707-b3aab15f7951255daaf14671@orel>
References: <20250703133601.1396848-1-jesse@rivosinc.com>
 <20250704-d2ca01be799a71427b5163f9@orel>
 <CALSpo=bieq=T8DZR9u=MeEs4w+6_fAshYcpVj4zC-zRhKkc6OA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALSpo=bieq=T8DZR9u=MeEs4w+6_fAshYcpVj4zC-zRhKkc6OA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 07, 2025 at 08:57:37AM -0700, Jesse Taube wrote:
> On Fri, Jul 4, 2025 at 1:17 AM Andrew Jones <andrew.jones@linux.dev> wrote:
> >
> > On Thu, Jul 03, 2025 at 06:36:00AM -0700, Jesse Taube wrote:
> > > Add --[enable|disable]-sbi-exit-code to configure script.
> > > With the default value disabled.
> > > Add a check for SBI_PASS_EXIT_CODE in the environment, so that passing
> > > of the test status is configurable from both the
> > > environment and the configure script
> > >
> > > Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> > > ---
> > >  configure      | 11 +++++++++++
> > >  lib/riscv/io.c | 12 +++++++++++-
> > >  2 files changed, 22 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/configure b/configure
> > > index 20bf5042..7c949bdc 100755
> > > --- a/configure
> > > +++ b/configure
> > > @@ -67,6 +67,7 @@ earlycon=
> > >  console=
> > >  efi=
> > >  efi_direct=
> > > +sbi_exit_code=0
> > >  target_cpu=
> > >
> > >  # Enable -Werror by default for git repositories only (i.e. developer builds)
> > > @@ -141,6 +142,9 @@ usage() {
> > >                                  system and run from the UEFI shell. Ignored when efi isn't enabled
> > >                                  and defaults to enabled when efi is enabled for riscv64.
> > >                                  (arm64 and riscv64 only)
> > > +         --[enable|disable]-sbi-exit-code
> > > +                                Enable or disable sending pass/fail exit code to SBI SRST.
> > > +                                (disabled by default, riscv only)
> > >  EOF
> > >      exit 1
> > >  }
> > > @@ -236,6 +240,12 @@ while [[ $optno -le $argc ]]; do
> > >       --disable-efi-direct)
> > >           efi_direct=n
> > >           ;;
> > > +     --enable-sbi-exit-code)
> > > +         sbi_exit_code=1
> > > +         ;;
> > > +     --disable-sbi-exit-code)
> > > +         sbi_exit_code=0
> > > +         ;;
> > >       --enable-werror)
> > >           werror=-Werror
> > >           ;;
> > > @@ -551,6 +561,7 @@ EOF
> > >  elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
> > >      echo "#define CONFIG_UART_EARLY_BASE ${uart_early_addr}" >> lib/config.h
> > >      [ "$console" = "sbi" ] && echo "#define CONFIG_SBI_CONSOLE" >> lib/config.h
> > > +    echo "#define CONFIG_SBI_EXIT_CODE ${sbi_exit_code}" >> lib/config.h
> > >      echo >> lib/config.h
> > >  fi
> > >  echo "#endif" >> lib/config.h
> > > diff --git a/lib/riscv/io.c b/lib/riscv/io.c
> > > index b1163404..0e666009 100644
> > > --- a/lib/riscv/io.c
> > > +++ b/lib/riscv/io.c
> > > @@ -162,8 +162,18 @@ void halt(int code);
> > >
> > >  void exit(int code)
> > >  {
> > > +     char *s = getenv("SBI_PASS_EXIT_CODE");
> > > +     bool pass_exit = CONFIG_SBI_EXIT_CODE;
> >
> > This is the first case of what may become more common - a config variable
> > which also has an env override. I think it may be good convention to
> > name them the same, i.e. the env name would also be CONFIG_SBI_EXIT_CODE,
> > unless you think that would be confusing for some reason?
> 
> I changed the name because the configure option seemed very long.
> I will make them both SBI_EXIT_CODE.

We need the CONFIG_ part on the config name in order keep it consistent
with other configs, so I think we just need a long name for both.

> Should I add a macro to simplify
> future uses
> of a config variable which also has an env override.

Sounds good to me.

> 
> >
> > > +
> > >       printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> > > -     sbi_shutdown(code == 0);
> > > +
> > > +     if (s)
> > > +             pass_exit = (*s == '1' || *s == 'y' || *s == 'Y');
> >
> > We now have this logic in four places[1]. I think it's time we factor it,
> > and it's counterpart "!(s && (*s == '0' || *s == 'n' || *s == 'N'))"
> > into a couple helper macros. I'm not sure where the best place for
> > those macros to live is, though. I guess libcflat.h, but we really
> > ought to split that thing apart someday...
> 
> Is lib/argv.h an ok place?

That could work.

> getenv is defined in lib/string.c which is interesting. I wonder if it
> could be moved to lib/argv.c?

getenv is libc and in lives in stdlib in libc, so we should move our
prototype to lib/stdlib.h from libcflat.h, but we don't have a stdlib.c
file so string.c and argv.c are both "wrong", but at least string.c
also has all the functions getenv depends on locally...

Thanks,
drew

