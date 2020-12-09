Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3ADE2D397B
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 05:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgLIEMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 23:12:40 -0500
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:59556 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgLIEMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 23:12:40 -0500
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id E1E2B20F59
        for <kvm@vger.kernel.org>; Wed,  9 Dec 2020 04:11:58 +0000 (UTC)
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.66.162])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id E6A5D260EB
        for <kvm@vger.kernel.org>; Wed,  9 Dec 2020 04:11:06 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay2.mymailcheap.com (Postfix) with ESMTPS id 11B5C3ECD9;
        Wed,  9 Dec 2020 05:09:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 577FC2A36D;
        Tue,  8 Dec 2020 23:09:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1607486973;
        bh=Omf4375Bcm8QKp7HuGa223zj7zWUqbF5ZEXTNzqxj2U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=y+goKP9ZT32TBWiQO3E1chp1bxmSeKCbmP7XFbYbgQmw/IPlEZBPdSjtxQsgjRv6H
         fof022deJPi8PNDVT/bT8OV1TSdZJMITH15GigmUKplmJ65hQkpTQHlbzCmWdoJgGm
         U5hlZVdME3dBai5MIkGjK6MEwVyFWazYhpPYPAi4=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4M9iPFcP7rxw; Tue,  8 Dec 2020 23:09:32 -0500 (EST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Tue,  8 Dec 2020 23:09:32 -0500 (EST)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 127CF41FA4;
        Wed,  9 Dec 2020 04:09:31 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="Xca5lk2W";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (unknown [154.17.13.103])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id A29C941FA4;
        Wed,  9 Dec 2020 04:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1607486965;
        bh=Omf4375Bcm8QKp7HuGa223zj7zWUqbF5ZEXTNzqxj2U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Xca5lk2WgI6DV/NwF7JwKW5JlW+Xx5vLuzdgwmQhu4UMF+99fDZqT7+M/OeQbsh7A
         9LwBC3H38mEgWTTu5QJiw4teGLYmhGHU8eXOYGYhrkNTirtGYwI3B51lcHPCHoCfuY
         ELgARzSx9IQyenlqhYdcXZVZ4Hls3zKIBEZhRfiw=
Subject: Re: [PATCH 16/17] target/mips: Introduce decode tree bindings for MSA
 opcodes
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <20201208003702.4088927-17-f4bug@amsat.org>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <f9fe41e5-14c9-82f0-f2bb-a343ee532216@flygoat.com>
Date:   Wed, 9 Dec 2020 12:09:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201208003702.4088927-17-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 127CF41FA4
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[8];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1]
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2020/12/8 上午8:37, Philippe Mathieu-Daudé 写道:
> Introduce the 'mod-msa32' decodetree config for the 32-bit MSA ASE.
>
> We decode the branch instructions, and all instructions based
> on the MSA opcode.
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

Double checked opcode formats with the manual.

Thanks!

- Jiaxun

> ---
>   target/mips/translate.h         |  1 +
>   target/mips/mod-msa32.decode    | 24 ++++++++++++++++++++++++
>   target/mips/mod-msa_translate.c | 31 +++++++++++++++++++++++++++++++
>   target/mips/meson.build         |  5 +++++
>   4 files changed, 61 insertions(+)
>   create mode 100644 target/mips/mod-msa32.decode
>
> diff --git a/target/mips/translate.h b/target/mips/translate.h
> index c26b0d9155d..c4fe18d187e 100644
> --- a/target/mips/translate.h
> +++ b/target/mips/translate.h
> @@ -84,5 +84,6 @@ extern TCGv bcond;
>   void msa_translate_init(void);
>   void gen_msa(DisasContext *ctx);
>   void gen_msa_branch(DisasContext *ctx, uint32_t op1);
> +bool decode_msa32(DisasContext *ctx, uint32_t insn);
>   
>   #endif
> diff --git a/target/mips/mod-msa32.decode b/target/mips/mod-msa32.decode
> new file mode 100644
> index 00000000000..d69675132b8
> --- /dev/null
> +++ b/target/mips/mod-msa32.decode
> @@ -0,0 +1,24 @@
> +# MIPS SIMD Architecture Module instruction set
> +#
> +# Copyright (C) 2020  Philippe Mathieu-Daudé
> +#
> +# SPDX-License-Identifier: LGPL-2.1-or-later
> +#
> +# Reference:
> +#       MIPS Architecture for Programmers Volume IV-j
> +#       The MIPS32 SIMD Architecture Module, Revision 1.12
> +#       (Document Number: MD00866-2B-MSA32-AFP-01.12)
> +#
> +
> +&msa_bz             df wt s16
> +
> +@bz                 ...... ... ..   wt:5 s16:16             &msa_bz df=3
> +@bz_df              ...... ... df:2 wt:5 s16:16             &msa_bz
> +
> +BZ_V                010001 01011  ..... ................    @bz
> +BNZ_V               010001 01111  ..... ................    @bz
> +
> +BZ_x                010001 110 .. ..... ................    @bz_df
> +BNZ_x               010001 111 .. ..... ................    @bz_df
> +
> +MSA                 011110 --------------------------
> diff --git a/target/mips/mod-msa_translate.c b/target/mips/mod-msa_translate.c
> index 55c2a2f1acc..02df39c6b6c 100644
> --- a/target/mips/mod-msa_translate.c
> +++ b/target/mips/mod-msa_translate.c
> @@ -6,6 +6,7 @@
>    *  Copyright (c) 2006 Thiemo Seufer (MIPS32R2 support)
>    *  Copyright (c) 2009 CodeSourcery (MIPS16 and microMIPS support)
>    *  Copyright (c) 2012 Jia Liu & Dongxue Zhang (MIPS ASE DSP support)
> + *  Copyright (c) 2020 Philippe Mathieu-Daudé
>    *
>    * SPDX-License-Identifier: LGPL-2.1-or-later
>    */
> @@ -17,6 +18,9 @@
>   #include "fpu_helper.h"
>   #include "internal.h"
>   
> +/* Include the auto-generated decoder.  */
> +#include "decode-mod-msa32.c.inc"
> +
>   #define OPC_MSA (0x1E << 26)
>   
>   #define MASK_MSA_MINOR(op)          (MASK_OP_MAJOR(op) | (op & 0x3F))
> @@ -370,6 +374,16 @@ static bool gen_msa_BxZ_V(DisasContext *ctx, int wt, int s16, TCGCond cond)
>       return true;
>   }
>   
> +static bool trans_BZ_V(DisasContext *ctx, arg_msa_bz *a)
> +{
> +    return gen_msa_BxZ_V(ctx, a->wt, a->s16, TCG_COND_EQ);
> +}
> +
> +static bool trans_BNZ_V(DisasContext *ctx, arg_msa_bz *a)
> +{
> +    return gen_msa_BxZ_V(ctx, a->wt, a->s16, TCG_COND_NE);
> +}
> +
>   static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
>   {
>       check_msa_access(ctx);
> @@ -391,6 +405,16 @@ static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
>       return true;
>   }
>   
> +static bool trans_BZ_x(DisasContext *ctx, arg_msa_bz *a)
> +{
> +    return gen_msa_BxZ(ctx, a->df, a->wt, a->s16, false);
> +}
> +
> +static bool trans_BNZ_x(DisasContext *ctx, arg_msa_bz *a)
> +{
> +    return gen_msa_BxZ(ctx, a->df, a->wt, a->s16, true);
> +}
> +
>   void gen_msa_branch(DisasContext *ctx, uint32_t op1)
>   {
>       uint8_t df = (ctx->opcode >> 21) & 0x3;
> @@ -2264,3 +2288,10 @@ void gen_msa(DisasContext *ctx)
>           break;
>       }
>   }
> +
> +static bool trans_MSA(DisasContext *ctx, arg_MSA *a)
> +{
> +    gen_msa(ctx);
> +
> +    return true;
> +}
> diff --git a/target/mips/meson.build b/target/mips/meson.build
> index b6697e2fd72..7d0414bbe23 100644
> --- a/target/mips/meson.build
> +++ b/target/mips/meson.build
> @@ -1,4 +1,9 @@
> +gen = [
> +  decodetree.process('mod-msa32.decode', extra_args: [ '--decode=decode_msa32' ]),
> +]
> +
>   mips_ss = ss.source_set()
> +mips_ss.add(gen)
>   mips_ss.add(files(
>     'cpu.c',
>     'dsp_helper.c',
