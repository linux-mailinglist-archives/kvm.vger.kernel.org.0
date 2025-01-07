Return-Path: <kvm+bounces-34695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9163AA047EE
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 18:16:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89465166617
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 17:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C207B1F4283;
	Tue,  7 Jan 2025 17:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XeHWCDWq"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE351F2C3F
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 17:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736270084; cv=none; b=lMOqbTHiVHdOCldXYYSbTS5a+NUfcWarUiVy4hMcwRyo1MDVrSwQcZUl09MemEyyI9n/KETqcDaJtVIL5pmXCLXrs20CVJeYpbZE7gteEmKeeKX2upwhO30GQkvhk7sk4WceK7avYqr00BckXCBl7pOqcs0NGAWsiMpizmlsD5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736270084; c=relaxed/simple;
	bh=sbgGqCXj+iltSiYLMpJplnttTaUepkN7Cghr6Y90ZQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6vy+j31DhsTbITwtHe4VTszoClANmuWkZMY8TWXCps6b5T44K7aZ0KKqrX4bX2sLHaJ9uqIOZUjVPNgVrhPqnDWrmaeESWBwf/gZN6SlSSU4WbKJJne1hdOyMNhIB7M/ZZxDkcaJsgiMTxaexk0a5UVudyIRHtTSiVY117TI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XeHWCDWq; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 7 Jan 2025 18:14:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736270078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xg+dc2tTYCj5PN7khBUdbRLWSlxt/+MSQH3EPBE/qm0=;
	b=XeHWCDWqs8WXzxdf4zisWw6JDrnMqtXYQOuxWWXFC8chJ2gzoYPf5nKqVtUqf5+pNRg0L6
	zXmCKqMPlVVjsm3qAkSU75BvOL8GoWq4zJLZTPUVJOBwl970Kb+etIzOZpHhOWJMXaqSEa
	nlkQ9r0P8x7xo+JFXtLMyQMM9naZjHg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v4 1/5] kbuild: allow multiple asm-offsets
 file to be generated
Message-ID: <20250107-7e693ed9a487a4c6e714d071@orel>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
 <20241125162200.1630845-2-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241125162200.1630845-2-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 25, 2024 at 05:21:50PM +0100, Clément Léger wrote:
> In order to allow multiple asm-offsets files to generated the include
> guard need to be different between these file. Add a asm_offset_name
> makefile macro to obtain an uppercase name matching the original asm
> offsets file.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  scripts/asm-offsets.mak | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/scripts/asm-offsets.mak b/scripts/asm-offsets.mak
> index 7b64162d..a5fdbf5d 100644
> --- a/scripts/asm-offsets.mak
> +++ b/scripts/asm-offsets.mak
> @@ -15,10 +15,14 @@ define sed-y
>  	s:->::; p;}'
>  endef
>  
> +define asm_offset_name
> +	$(shell echo $(notdir $(1)) | tr [:lower:]- [:upper:]_)
> +endef
> +
>  define make_asm_offsets
>  	(set -e; \
> -	 echo "#ifndef __ASM_OFFSETS_H__"; \
> -	 echo "#define __ASM_OFFSETS_H__"; \
> +	 echo "#ifndef __$(strip $(asm_offset_name))_H__"; \
> +	 echo "#define __$(strip $(asm_offset_name))_H__"; \
>  	 echo "/*"; \
>  	 echo " * Generated file. DO NOT MODIFY."; \
>  	 echo " *"; \
> @@ -29,12 +33,16 @@ define make_asm_offsets
>  	 echo "#endif" ) > $@
>  endef
>  
> -$(asm-offsets:.h=.s): $(asm-offsets:.h=.c)
> -	$(CC) $(CFLAGS) -fverbose-asm -S -o $@ $<
> +define gen_asm_offsets_rules
> +$(1).s: $(1).c
> +	$(CC) $(CFLAGS) -fverbose-asm -S -o $$@ $$<
> +
> +$(1).h: $(1).s
> +	$$(call make_asm_offsets,$(1))
> +	cp -f $$@ lib/generated/
> +endef
>  
> -$(asm-offsets): $(asm-offsets:.h=.s)
> -	$(call make_asm_offsets)
> -	cp -f $(asm-offsets) lib/generated/
> +$(foreach o,$(asm-offsets),$(eval $(call gen_asm_offsets_rules, $(o:.h=))))
>  
>  OBJDIRS += lib/generated
>  
> -- 
> 2.45.2
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

