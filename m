Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277CD2CCD66
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 04:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgLCDkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 22:40:09 -0500
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:45456 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgLCDkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 22:40:08 -0500
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 78B2C20F6B
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 03:39:27 +0000 (UTC)
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.119.155])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 1A14D260EB
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 03:38:35 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id 7ECBD3F15F;
        Thu,  3 Dec 2020 04:37:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id C188B2A374;
        Wed,  2 Dec 2020 22:37:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1606966621;
        bh=70YbnXa0sCfLKWQ9uffWIJYIy3lO51uB5MTk6KloPno=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LIX5/vCvoGrRXuVIubqQHVqIi76ma7xML9wx83d6fXt3LfGB9YRIl23IBvglVHaVN
         GpnD/6L6TCusoJOjz7473nS9CcewpOkJe3aE5LD2mODKknRtO75CzcEVj5G9sEmLzs
         AFARWwyis8yfbrylZtCe7+kz3ArOe+sIEsRdAfYY=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id abE1zEUi6Byy; Wed,  2 Dec 2020 22:36:58 -0500 (EST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Wed,  2 Dec 2020 22:36:58 -0500 (EST)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id BFE214100D;
        Thu,  3 Dec 2020 03:36:55 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="IQ8Vho6E";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (li1861-199.members.linode.com [172.105.207.199])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id EDAF74100D;
        Thu,  3 Dec 2020 03:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1606966611;
        bh=70YbnXa0sCfLKWQ9uffWIJYIy3lO51uB5MTk6KloPno=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IQ8Vho6EEVoYb2ck3j7oEbuHAYh2H5KtFuNsLlz1lkYTGA4uIykm8i97JYtwSch0O
         NAHnCrQuCYLnCzYz82FA0kgkX3Od8yQ4Pc9PQiDmjp7jOZn42T5ga+IIU3dJLUZzAm
         +Qd5apxycTDOJKUd/R/qBussg4hEWqbMBkFRzYLU=
Subject: Re: [PATCH 0/9] target/mips: Simplify MSA TCG logic
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Huacai Chen <chenhc@lemote.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <b98de2d2-98db-1e34-64fd-ec0b4cafae11@flygoat.com>
Date:   Thu, 3 Dec 2020 11:36:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-1-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: BFE214100D
X-Spamd-Result: default: False [2.90 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         RECEIVED_SPAMHAUS_XBL(3.00)[172.105.207.199:received];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         ARC_NA(0.00)[];
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



在 2020/12/3 上午2:44, Philippe Mathieu-Daudé 写道:
> I converted MSA opcodes to decodetree. To keep the series
> small I split it in 2, this is the non-decodetree specific
> patches (so non-decodetree experts can review it ;) ).
>
> First we stop using env->insn_flags to check for MSAi
> presence, then we restrict TCG functions to DisasContext*.

Hi Philippe,

For the whole series,
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>


I'm just curious about how would you deal with so many condition flags
with decodetree?

Unlike other ISAs, MIPS have so many flavors, every ISA level (MIPS-III 
R2 R5 R6)
has it's own instructions, and in my understanding decodetree file won't 
generate
these switches. I was trying to do the same thing but soon find out 
we'll have around
20 decodertree for MIPS.

Thanks.

- Jiaxun

>
> Based-on: <20201130102228.2395100-1-f4bug@amsat.org>
> "target/mips: Allow executing MSA instructions on Loongson-3A4000"
>
> Philippe Mathieu-Daudé (9):
>    target/mips: Introduce ase_msa_available() helper
>    target/mips: Simplify msa_reset()
>    target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA
>    target/mips: Simplify MSA TCG logic
>    target/mips: Remove now unused ASE_MSA definition
>    target/mips: Alias MSA vector registers on FPU scalar registers
>    target/mips: Extract msa_translate_init() from mips_tcg_init()
>    target/mips: Remove CPUMIPSState* argument from gen_msa*() methods
>    target/mips: Explode gen_msa_branch() as gen_msa_BxZ_V/BxZ()
>
>   target/mips/internal.h           |   8 +-
>   target/mips/mips-defs.h          |   1 -
>   target/mips/kvm.c                |  12 +-
>   target/mips/translate.c          | 206 ++++++++++++++++++-------------
>   target/mips/translate_init.c.inc |  12 +-
>   5 files changed, 138 insertions(+), 101 deletions(-)
>
