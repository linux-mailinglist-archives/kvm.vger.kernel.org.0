Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F030725785
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 10:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239287AbjFGI0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 04:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239263AbjFGI0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 04:26:45 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C75A95;
        Wed,  7 Jun 2023 01:26:43 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-39a3f165ac5so6158812b6e.3;
        Wed, 07 Jun 2023 01:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686126403; x=1688718403;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0OyKL8u76cOWS8rMkXzpr40joVTVvs+ER4J7F7RIUc=;
        b=gx1AjEIRVKwC+e/wYi+5OJVPxwD24AqcSgDNzNjEGmxN9LybTFcLwReCPofBu/oU27
         TPsIqdI18Y4gzDn/PamlyLMVjXB/SlBoYCZ3e012AKFP3ibEDLJ3GBZLHPmiYmZlIqwA
         MOZtje7230z9BYI3KPM1WQP+xH4cQkApMzFMGPc8vL0LzuPup1PRUxK90PD6usWANsz0
         5Eb9fFwRPl01u+1z/6IOKHu2eBgaZBk8XDosHmv/3dxCU05kZLyc/0CwtW61Fx3Xf1F9
         76eRKSm3Vc27Ryz+mfY71QPAYWkwiYyGjg65YH89dYjA23NMGzNhLjCj7TKZ+e7HlO9R
         /KQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686126403; x=1688718403;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q0OyKL8u76cOWS8rMkXzpr40joVTVvs+ER4J7F7RIUc=;
        b=Phn77kdlkCCbGI7fZwWLn9AAPpiGM6xQIqJLR6HjM2T+j+vYO19edJDDA7lYk2cIgC
         c9mr/0QNP4hoZtOtN8yD3QpiLEK0ygGvychSw+Yb7JyL8Qg/UzVyLfUMFlbn6cTmSPyG
         a9IcBFEiN/z23+Egou0UQIJD3ynBS8acOtYYVDIhlKpGdtXF0R/ukDgVu9cAoMJ/R6WL
         5anbz00tU8BnjSqesmiR+3ySdgvJ4wMMvk+GZg+Dh8vgMy+EFLi1ig59uzEwb4LK0+tK
         +/HPCyx0auiLHu2Y9lbA6N8AJLxuNceCNsJ0hs0XgB7CMAu5ezMUFqGz+fcrS0RvStdz
         nr9g==
X-Gm-Message-State: AC+VfDwIkfhQ7QWt3ZNv6mCzRC2bA7VssdwyjNEwnixLK47fBJ5Ci5G+
        sOfIA4W7UcZvXrS2IBkmdcs=
X-Google-Smtp-Source: ACHHUZ52S9FmYHylCGUBDHU6A/rnvTKpdnJxmZbNyuim1YSbqrzR0jOjQly/hHUgV49Csb4p+rh46A==
X-Received: by 2002:a54:418f:0:b0:398:57ac:23fe with SMTP id 15-20020a54418f000000b0039857ac23femr4810602oiy.10.1686126402630;
        Wed, 07 Jun 2023 01:26:42 -0700 (PDT)
Received: from localhost (58-6-224-112.tpgi.com.au. [58.6.224.112])
        by smtp.gmail.com with ESMTPSA id z3-20020a170903018300b001b1a2bf5277sm9843062plg.39.2023.06.07.01.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 01:26:41 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 07 Jun 2023 18:26:35 +1000
Message-Id: <CT69X8Q3NVVO.GXEUNFGVDL08@wheely>
Subject: Re: [RFC PATCH v2 4/6] KVM: PPC: Add helper library for Guest State
 Buffers
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Jordan Niethe" <jpn@linux.vnet.ibm.com>,
        <linuxppc-dev@lists.ozlabs.org>
Cc:     <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <mikey@neuling.org>, <paulus@ozlabs.org>,
        <kautuk.consul.1980@gmail.com>, <vaibhav@linux.ibm.com>,
        <sbhat@linux.ibm.com>
X-Mailer: aerc 0.14.0
References: <20230605064848.12319-1-jpn@linux.vnet.ibm.com>
 <20230605064848.12319-5-jpn@linux.vnet.ibm.com>
In-Reply-To: <20230605064848.12319-5-jpn@linux.vnet.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Jun 5, 2023 at 4:48 PM AEST, Jordan Niethe wrote:
> The new PAPR nested guest API introduces the concept of a Guest State
> Buffer for communication about L2 guests between L1 and L0 hosts.
>
> In the new API, the L0 manages the L2 on behalf of the L1. This means
> that if the L1 needs to change L2 state (e.g. GPRs, SPRs, partition
> table...), it must request the L0 perform the modification. If the
> nested host needs to read L2 state likewise this request must
> go through the L0.
>
> The Guest State Buffer is a Type-Length-Value style data format defined
> in the PAPR which assigns all relevant partition state a unique
> identity. Unlike a typical TLV format the length is redundant as the
> length of each identity is fixed but is included for checking
> correctness.
>
> A guest state buffer consists of an element count followed by a stream
> of elements, where elements are composed of an ID number, data length,
> then the data:
>
>   Header:
>
>    <---4 bytes--->
>   +----------------+-----
>   | Element Count  | Elements...
>   +----------------+-----
>
>   Element:
>
>    <----2 bytes---> <-2 bytes-> <-Length bytes->
>   +----------------+-----------+----------------+
>   | Guest State ID |  Length   |      Data      |
>   +----------------+-----------+----------------+
>
> Guest State IDs have other attributes defined in the PAPR such as
> whether they are per thread or per guest, or read-only.
>
> Introduce a library for using guest state buffers. This includes support
> for actions such as creating buffers, adding elements to buffers,
> reading the value of elements and parsing buffers. This will be used
> later by the PAPR nested guest support.

This is a tour de force in one of these things, so I hate to be
the "me smash with club" guy, but what if you allocated buffers
with enough room for all the state (or 99% of cases, in which
case an overflow would make an hcall)?

What's actually a fast-path that we don't get from the interrupt
return buffer? Getting and setting a few regs for MMIO emulation?


> Signed-off-by: Jordan Niethe <jpn@linux.vnet.ibm.com>
> ---
> v2:
>   - Add missing #ifdef CONFIG_VSXs
>   - Move files from lib/ to kvm/
>   - Guard compilation on CONFIG_KVM_BOOK3S_HV_POSSIBLE
>   - Use kunit for guest state buffer tests
>   - Add configuration option for the tests
>   - Use macros for contiguous id ranges like GPRs
>   - Add some missing EXPORTs to functions
>   - HEIR element is a double word not a word
> ---
>  arch/powerpc/Kconfig.debug                    |  12 +
>  arch/powerpc/include/asm/guest-state-buffer.h | 901 ++++++++++++++++++
>  arch/powerpc/include/asm/kvm_book3s.h         |   2 +
>  arch/powerpc/kvm/Makefile                     |   3 +
>  arch/powerpc/kvm/guest-state-buffer.c         | 563 +++++++++++
>  arch/powerpc/kvm/test-guest-state-buffer.c    | 321 +++++++
>  6 files changed, 1802 insertions(+)
>  create mode 100644 arch/powerpc/include/asm/guest-state-buffer.h
>  create mode 100644 arch/powerpc/kvm/guest-state-buffer.c
>  create mode 100644 arch/powerpc/kvm/test-guest-state-buffer.c
>
> diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
> index 6aaf8dc60610..ed830a714720 100644
> --- a/arch/powerpc/Kconfig.debug
> +++ b/arch/powerpc/Kconfig.debug
> @@ -82,6 +82,18 @@ config MSI_BITMAP_SELFTEST
>  	bool "Run self-tests of the MSI bitmap code"
>  	depends on DEBUG_KERNEL
> =20
> +config GUEST_STATE_BUFFER_TEST
> +	def_tristate n
> +	prompt "Enable Guest State Buffer unit tests"
> +	depends on KUNIT
> +	depends on KVM_BOOK3S_HV_POSSIBLE
> +	default KUNIT_ALL_TESTS
> +	help
> +	  The Guest State Buffer is a data format specified in the PAPR.
> +	  It is by hcalls to communicate the state of L2 guests between
> +	  the L1 and L0 hypervisors. Enable unit tests for the library
> +	  used to create and use guest state buffers.
> +
>  config PPC_IRQ_SOFT_MASK_DEBUG
>  	bool "Include extra checks for powerpc irq soft masking"
>  	depends on PPC64
> diff --git a/arch/powerpc/include/asm/guest-state-buffer.h b/arch/powerpc=
/include/asm/guest-state-buffer.h
> new file mode 100644
> index 000000000000..65a840abf1bb
> --- /dev/null
> +++ b/arch/powerpc/include/asm/guest-state-buffer.h
> @@ -0,0 +1,901 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Interface based on include/net/netlink.h
> + */
> +#ifndef _ASM_POWERPC_GUEST_STATE_BUFFER_H
> +#define _ASM_POWERPC_GUEST_STATE_BUFFER_H
> +
> +#include <linux/gfp.h>
> +#include <linux/bitmap.h>
> +#include <asm/plpar_wrappers.h>
> +
> +/***********************************************************************=
***
> + * Guest State Buffer Constants
> + ***********************************************************************=
***/
> +#define GSID_BLANK			0x0000

The namespaces are a little abbreviated. KVM_PAPR_ might be nice if
you're calling the API that.

> +
> +#define GSID_HOST_STATE_SIZE		0x0001 /* Size of Hypervisor Internal Form=
at VCPU state */
> +#define GSID_RUN_OUTPUT_MIN_SIZE	0x0002 /* Minimum size of the Run VCPU =
output buffer */
> +#define GSID_LOGICAL_PVR		0x0003 /* Logical PVR */
> +#define GSID_TB_OFFSET			0x0004 /* Timebase Offset */
> +#define GSID_PARTITION_TABLE		0x0005 /* Partition Scoped Page Table */
> +#define GSID_PROCESS_TABLE		0x0006 /* Process Table */

> +
> +#define GSID_RUN_INPUT			0x0C00 /* Run VCPU Input Buffer */
> +#define GSID_RUN_OUTPUT			0x0C01 /* Run VCPU Out Buffer */
> +#define GSID_VPA			0x0C02 /* HRA to Guest VCPU VPA */
> +
> +#define GSID_GPR(x)			(0x1000 + (x))
> +#define GSID_HDEC_EXPIRY_TB		0x1020
> +#define GSID_NIA			0x1021
> +#define GSID_MSR			0x1022
> +#define GSID_LR				0x1023
> +#define GSID_XER			0x1024
> +#define GSID_CTR			0x1025
> +#define GSID_CFAR			0x1026
> +#define GSID_SRR0			0x1027
> +#define GSID_SRR1			0x1028
> +#define GSID_DAR			0x1029

It's a shame you have to rip up all your wrapper functions now to
shoehorn these in.

If you included names analogous to the reg field names in the kvm
structures, the wrappers could do macro expansions that get them.

#define __GSID_WRAPPER_dar		GSID_DAR

Or similar.

And since of course you have to explicitly enumerate all these, I
wouldn't mind defining the types and lengths up-front rather than
down in the type function. You'd like to be able to go through the
spec and eyeball type, number, size.

[snip]

> +/**
> + * gsb_paddress() - the physical address of buffer
> + * @gsb: guest state buffer
> + *
> + * Returns the physical address of the buffer.
> + */
> +static inline u64 gsb_paddress(struct gs_buff *gsb)
> +{
> +	return __pa(gsb_header(gsb));
> +}

> +/**
> + * __gse_put_reg() - add a register type guest state element to a buffer
> + * @gsb: guest state buffer to add element to
> + * @iden: guest state ID
> + * @val: host endian value
> + *
> + * Adds a register type guest state element. Uses the guest state ID for
> + * determining the length of the guest element. If the guest state ID ha=
s
> + * bits that can not be set they will be cleared.
> + */
> +static inline int __gse_put_reg(struct gs_buff *gsb, u16 iden, u64 val)
> +{
> +	val &=3D gsid_mask(iden);
> +	if (gsid_size(iden) =3D=3D sizeof(u64))
> +		return gse_put_u64(gsb, iden, val);
> +
> +	if (gsid_size(iden) =3D=3D sizeof(u32)) {
> +		u32 tmp;
> +
> +		tmp =3D (u32)val;
> +		if (tmp !=3D val)
> +			return -EINVAL;
> +
> +		return gse_put_u32(gsb, iden, tmp);
> +	}
> +	return -EINVAL;
> +}

There is a clever accessor that derives the length from the type, but
then you fall back to this.

> +/**
> + * gse_put - add a guest state element to a buffer
> + * @gsb: guest state buffer to add to
> + * @iden: guest state identity
> + * @v: generic value
> + */
> +#define gse_put(gsb, iden, v)					\
> +	(_Generic((v),						\
> +		  u64 : __gse_put_reg,				\
> +		  long unsigned int : __gse_put_reg,		\
> +		  u32 : __gse_put_reg,				\
> +		  struct gs_buff_info : gse_put_buff_info,	\
> +		  struct gs_proc_table : gse_put_proc_table,	\
> +		  struct gs_part_table : gse_put_part_table,	\
> +		  vector128 : gse_put_vector128)(gsb, iden, v))
> +
> +/**
> + * gse_get - return the data of a guest state element
> + * @gsb: guest state element to add to
> + * @v: generic value pointer to return in
> + */
> +#define gse_get(gse, v)						\
> +	(*v =3D (_Generic((v),					\
> +			u64 * : __gse_get_reg,			\
> +			unsigned long * : __gse_get_reg,	\
> +			u32 * : __gse_get_reg,			\
> +			vector128 * : gse_get_vector128)(gse)))

I don't see the benefit of this. Caller always knows the type doesn't
it? It seems like the right function could be called directly. It
makes the calling convention a bit clunky too. I know there's similar
precedent for uaccess functions, but not sure I like it for this.

> +struct gs_buff *gsb_new(size_t size, unsigned long guest_id,
> +			unsigned long vcpu_id, gfp_t flags)
> +{
> +	struct gs_buff *gsb;
> +
> +	gsb =3D kzalloc(sizeof(*gsb), flags);
> +	if (!gsb)
> +		return NULL;
> +
> +	size =3D roundup_pow_of_two(size);
> +	gsb->hdr =3D kzalloc(size, GFP_KERNEL);
> +	if (!gsb->hdr)
> +		goto free;
> +
> +	gsb->capacity =3D size;
> +	gsb->len =3D sizeof(struct gs_header);
> +	gsb->vcpu_id =3D vcpu_id;
> +	gsb->guest_id =3D guest_id;
> +
> +	gsb->hdr->nelems =3D cpu_to_be32(0);
> +
> +	return gsb;
> +
> +free:
> +	kfree(gsb);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(gsb_new);

Should all be GPL exports.

Needs more namespace too, I reckon (not just exports but any kernel-wide
name this short and non-descriptive needs a kvmppc or kvm_papr or
something).

Thanks,
Nick
