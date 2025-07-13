Return-Path: <kvm+bounces-52243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F044B03153
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 16:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CBBB189E0DA
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 14:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAA2127877D;
	Sun, 13 Jul 2025 14:02:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103471078F;
	Sun, 13 Jul 2025 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752415355; cv=none; b=U1laUSkMAGYzUQuZvDMhVvhZ+0tdhG8G0lg1YwooizBKyKxDvf1bapy23lhnj1CYj8xs/7qcbR+p3vDyvSXefef2Pm3/pTOQ1mGQgcV1pgCZvBJwydYEkH1UoGdS8dipaN/IUGHEWAoLp/PLIqYtUXb2mJDlWZ/zIL3DHju/zoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752415355; c=relaxed/simple;
	bh=EGG+UHOVdSCBQtzHJNmf2/Gd5N+EPop7VvdGtUVpIQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gdkI4pio3L3xC0us4HmDYKyNCXFaibd1ut/xH6m8WNWF2QVNji6fkxqUgzmcNoVWyt55/fQKPV1YWso7mcPesHzmY0GRhcuTYfw7LDHCQwDG9FW7CL7jvh4ctPaF3KXkRomAymt+r74SoxI3MFqqlZOAncoQpaP1U9Zh+BjnTgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 56DE1HTu686944;
	Sun, 13 Jul 2025 09:01:17 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.18.1/8.18.1/Submit) id 56DE1E5M686943;
	Sun, 13 Jul 2025 09:01:14 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Sun, 13 Jul 2025 09:01:14 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Richard Fontana <rfontana@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>, Thomas Huth <thuth@redhat.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-spdx@vger.kernel.org,
        J Lovejoy <opensource@jilayne.com>
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
Message-ID: <aHO8KoFHQVoCK96W@gate>
References: <20250711053509.194751-1-thuth@redhat.com>
 <2025071125-talon-clammy-4971@gregkh>
 <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com>
 <2025071152-name-spoon-88e8@gregkh>
 <aHC-Ke2oLri_m7p6@infradead.org>
 <2025071119-important-convene-ab85@gregkh>
 <CAC1cPGx0Chmz3s+rd5AJAPNCuoyZX-AGC=hfp9JPAG_-H_J6vw@mail.gmail.com>
 <aHGafTZTcdlpw1gN@gate>
 <CAC1cPGzLK8w2e=vz3rgPwWBkqs_2estcbPJgXD-RRx4GjdcB+A@mail.gmail.com>
 <alpine.DEB.2.21.2507122332310.45111@angie.orcam.me.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2507122332310.45111@angie.orcam.me.uk>

On Sat, Jul 12, 2025 at 11:48:16PM +0100, Maciej W. Rozycki wrote:
> On Fri, 11 Jul 2025, Richard Fontana wrote:
>  I don't know what the legal status of the statement referred is, however 
> the original exception as published[1] by FSF says:
> 
> '"GCC" means a version of the GNU Compiler Collection, with or without 
> modifications, governed by version 3 (or a specified later version) of the 
> GNU General Public License (GPL) with the option of using any subsequent 
> versions published by the FSF.'

(which is likely the wrong license, the code in the kernel was taken
from something GPLv2).

> which I think makes it clear that "GCC" is a collection of "GNU compilers" 
> and therefore the two terms are synonymous to each other for the purpose 
> of said exception (in the old days "GCC" stood for "GNU C Compiler", but 
> the old meaning makes no sense anymore now that we have compilers for Ada, 
> Fortran and many other languages included in GCC).

Since, what, 2001?  If this matters for these files, they were forked
*very* long ago!


And, of course, the much better way to solve these self-inflicted
problems is to just use the libgcc that your version of GCC want to use,
the one it ships with itself, it being a necessary portion of the
compiler!

Here, an old patch of mine, this one for SuperH (I have stacks of such
patches, for many archs):

===
commit 9289694955c6105fb6bcc35fbf9ce7acddd60674
Author: Segher Boessenkool <segher@kernel.crashing.org>
Date:   Mon Nov 24 09:36:50 2014 -0800

    sh: Use libgcc
    
    Building the kernel with non-ancient compilers fails, because some
    newer libgcc functions are missing from the kernel's clone of it.
    Use the compiler's libgcc, instead.

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 5c8776482530..eae83b76f17c 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -171,6 +171,8 @@ KBUILD_CFLAGS		+= -pipe $(cflags-y)
 KBUILD_CPPFLAGS		+= $(cflags-y)
 KBUILD_AFLAGS		+= $(cflags-y)
 
+LIBGCC		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
+
 ifeq ($(CONFIG_MCOUNT),y)
   KBUILD_CFLAGS += -pg
 endif
@@ -180,6 +182,7 @@ ifeq ($(CONFIG_DWARF_UNWINDER),y)
 endif
 
 libs-y			:= arch/sh/lib/	$(libs-y)
+libs-y += $(LIBGCC)
 
 BOOT_TARGETS = uImage uImage.bz2 uImage.gz uImage.lzma uImage.xz uImage.lzo \
 	       uImage.srec uImage.bin zImage vmlinux.bin vmlinux.srec \
diff --git a/arch/sh/lib/Makefile b/arch/sh/lib/Makefile
index eb473d373ca4..2acb2d8c0366 100644
--- a/arch/sh/lib/Makefile
+++ b/arch/sh/lib/Makefile
@@ -6,11 +6,6 @@
 lib-y  = delay.o memmove.o memchr.o \
 	 checksum.o strlen.o div64.o div64-generic.o
 
-# Extracted from libgcc
-obj-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
-	 ashlsi3.o ashrsi3.o ashiftrt.o lshrsi3.o \
-	 udiv_qrnnd.o
-
 udivsi3-y			:= udivsi3_i4i-Os.o
 
 ifneq ($(CONFIG_CC_OPTIMIZE_FOR_SIZE),y)
===


Segher

