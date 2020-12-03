Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876E62CCD68
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 04:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgLCDmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 22:42:06 -0500
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:45464 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgLCDmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 22:42:06 -0500
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id E4BB420F6B
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 03:41:24 +0000 (UTC)
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [151.80.165.199])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 04E4A260EB
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 03:40:33 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay2.mymailcheap.com (Postfix) with ESMTPS id A5EC73EDEC;
        Thu,  3 Dec 2020 04:39:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 828752A6DF;
        Thu,  3 Dec 2020 04:39:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1606966741;
        bh=BrT1zud3EMh1mpq1CBXrkVC+Yfu/F2BS9l1iCiJzhkQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=yVtdEEoJivmxBOPHSm7Jmj4TAg5VR707z3o1JDLtQyOa2Zwv4KvYSsMUgZ93vuS9n
         2KJ0vk0Pc/iWRc00m2cnOht931y/ejiweXVNpF2dgD5IAIoeBYHfP3jk9uFpNuTqfA
         /tsizV1kFTjFX8g+mX58E2hzd6g/jnyOmWiKgE2g=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ud42ebzwi66W; Thu,  3 Dec 2020 04:39:00 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Thu,  3 Dec 2020 04:39:00 +0100 (CET)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id AA1144100D;
        Thu,  3 Dec 2020 03:38:59 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="byl6G82S";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (li1861-199.members.linode.com [172.105.207.199])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 32E0C42237;
        Thu,  3 Dec 2020 03:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1606966733;
        bh=BrT1zud3EMh1mpq1CBXrkVC+Yfu/F2BS9l1iCiJzhkQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=byl6G82SBTOg5xQ5c0kAFlRdg9EJPqICYiUuuW2ZVIs4VcP5PTbgdWqKwGRpInBax
         a07q5+QDPd+lGE4c73I20e7URPmCPxIBa2x8q+K/wcjNoA8WNTGFzaGnoFkzU+bv2D
         1YCJjkJLTirMnnwXDOQ94t5i5vhNjrSWpslqMCI0=
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
Message-ID: <66b6e3b7-d13f-4224-cce4-0a8dd5fd9788@flygoat.com>
Date:   Thu, 3 Dec 2020 11:38:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201202184415.1434484-1-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: AA1144100D
X-Spamd-Result: default: False [2.90 / 10.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         RECEIVED_SPAMHAUS_XBL(3.00)[172.105.207.199:received];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all:c];
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
20 decodetree for MIPS.

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
