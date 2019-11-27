Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9189C10B598
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 19:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfK0SYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 13:24:03 -0500
Received: from foss.arm.com ([217.140.110.172]:51442 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfK0SYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 13:24:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E474C31B;
        Wed, 27 Nov 2019 10:24:02 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 014063F6C4;
        Wed, 27 Nov 2019 10:24:01 -0800 (PST)
Date:   Wed, 27 Nov 2019 18:23:49 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: Re: [PATCH kvmtool 01/16] Makefile: Use correct objcopy binary when
 cross-compiling for x86_64
Message-ID: <20191127182349.0541c86a@donnerap.cambridge.arm.com>
In-Reply-To: <20191125103033.22694-2-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
        <20191125103033.22694-2-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Nov 2019 10:30:18 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> Use the compiler toolchain version of objcopy instead of the native one
> when cross-compiling for the x86_64 architecture.

Indeed, confirmed to fix aarch64->x86_64 cross builds (that's a thing!).

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index b76d844f2e01..6d6880dd4f8a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -22,6 +22,7 @@ CC	:= $(CROSS_COMPILE)gcc
>  CFLAGS	:=
>  LD	:= $(CROSS_COMPILE)ld
>  LDFLAGS	:=
> +OBJCOPY	:= $(CROSS_COMPILE)objcopy
>  
>  FIND	:= find
>  CSCOPE	:= cscope
> @@ -479,7 +480,7 @@ x86/bios/bios.bin.elf: x86/bios/entry.S x86/bios/e820.c x86/bios/int10.c x86/bio
>  
>  x86/bios/bios.bin: x86/bios/bios.bin.elf
>  	$(E) "  OBJCOPY " $@
> -	$(Q) objcopy -O binary -j .text x86/bios/bios.bin.elf x86/bios/bios.bin
> +	$(Q) $(OBJCOPY) -O binary -j .text x86/bios/bios.bin.elf x86/bios/bios.bin
>  
>  x86/bios/bios-rom.o: x86/bios/bios-rom.S x86/bios/bios.bin x86/bios/bios-rom.h
>  	$(E) "  CC      " $@

