Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03902D0CE4
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 12:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfJIKfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 06:35:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfJIKfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 06:35:42 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A42AE18C426F;
        Wed,  9 Oct 2019 10:35:41 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.36.118.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A08A601AF;
        Wed,  9 Oct 2019 10:35:36 +0000 (UTC)
Subject: Re: [PATCH] powerpc: Fix up RTAS invocation for new qemu versions
To:     David Gibson <david@gibson.dropbear.id.au>, lvivier@redhat.com
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com
References: <20191004103844.32590-1-david@gibson.dropbear.id.au>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <07997795-3b64-5c85-e8a1-e9d81e57784e@redhat.com>
Date:   Wed, 9 Oct 2019 12:35:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191004103844.32590-1-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Wed, 09 Oct 2019 10:35:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/2019 12.38, David Gibson wrote:
> In order to call RTAS functions on powerpc kvm-unit-tests relies on the
> RTAS blob supplied by qemu.  But new versions of qemu don't supply an RTAS
> blob: since the normal way for guests to get RTAS is to call the guest
> firmware's instantiate-rtas function, we now rely on that guest firmware
> to provide the RTAS code itself.
> 
> But qemu-kvm-tests bypasses the usual guest firmware to just run itself,

s/qemu-kvm-tests/kvm-unit-tests/

> so we can't get the rtas blob from SLOF.
> 
> But.. in fact the RTAS blob under qemu is a bit of a sham anyway - it's
> a tiny wrapper that forwards the RTAS call to a hypercall.  So, we can
> just invoke that hypercall directly.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  lib/powerpc/asm/hcall.h |  3 +++
>  lib/powerpc/rtas.c      |  6 +++---
>  powerpc/cstart64.S      | 20 ++++++++++++++++----
>  3 files changed, 22 insertions(+), 7 deletions(-)
> 
> So.. "new versions of qemu" in this case means ones that incorporate
> the pull request I just sent today.
> 
> diff --git a/lib/powerpc/asm/hcall.h b/lib/powerpc/asm/hcall.h
> index a8bd7e3..1173fea 100644
> --- a/lib/powerpc/asm/hcall.h
> +++ b/lib/powerpc/asm/hcall.h
> @@ -24,6 +24,9 @@
>  #define H_RANDOM		0x300
>  #define H_SET_MODE		0x31C
>  
> +#define KVMPPC_HCALL_BASE	0xf000
> +#define KVMPPC_H_RTAS		(KVMPPC_HCALL_BASE + 0x0)
> +
>  #ifndef __ASSEMBLY__
>  /*
>   * hcall_have_broken_sc1 checks if we're on a host with a broken sc1.
> diff --git a/lib/powerpc/rtas.c b/lib/powerpc/rtas.c
> index 2e7e0da..41c0a24 100644
> --- a/lib/powerpc/rtas.c
> +++ b/lib/powerpc/rtas.c
> @@ -46,9 +46,9 @@ void rtas_init(void)
>  	prop = fdt_get_property(dt_fdt(), node,
>  				"linux,rtas-entry", &len);
>  	if (!prop) {
> -		printf("%s: /rtas/linux,rtas-entry: %s\n",
> -				__func__, fdt_strerror(len));
> -		abort();
> +		/* We don't have a qemu provided RTAS blob, enter_rtas
> +		 * will use H_RTAS directly */
> +		return;
>  	}
>  	data = (u32 *)prop->data;
>  	rtas_entry = (unsigned long)fdt32_to_cpu(*data);
> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> index ec673b3..972851f 100644
> --- a/powerpc/cstart64.S
> +++ b/powerpc/cstart64.S
> @@ -121,13 +121,25 @@ halt:
>  
>  .globl enter_rtas
>  enter_rtas:
> +	LOAD_REG_ADDR(r11, rtas_entry)
> +	ld	r10, 0(r11)
> +
> +	cmpdi	r10,0
> +	bne	external_rtas
> +
> +	/* Use H_RTAS directly */
> +	mr	r4,r3
> +	lis	r3,KVMPPC_H_RTAS@h
> +	ori	r3,r3,KVMPPC_H_RTAS@l
> +	b	hcall
> +
> +external_rtas:
> +	/* Use external RTAS blob */
>  	mflr	r0
>  	std	r0, 16(r1)
>  
> -	LOAD_REG_ADDR(r10, rtas_return_loc)
> -	mtlr	r10
> -	LOAD_REG_ADDR(r11, rtas_entry)
> -	ld	r10, 0(r11)
> +	LOAD_REG_ADDR(r11, rtas_return_loc)
> +	mtlr	r11
>  
>  	mfmsr	r11
>  	LOAD_REG_IMMEDIATE(r9, RTAS_MSR_MASK)
> 

With the typo in the commit message fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>

Paolo, I currently don't have any other kvm-unit-test patches pending,
could you pick this up directly, please?
