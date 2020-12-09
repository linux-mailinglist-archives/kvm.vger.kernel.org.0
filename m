Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199362D3978
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 05:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgLIELY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 23:11:24 -0500
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:59554 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbgLIELY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 23:11:24 -0500
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id CDF9520F59
        for <kvm@vger.kernel.org>; Wed,  9 Dec 2020 04:10:42 +0000 (UTC)
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [149.56.97.132])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 9915C2008F
        for <kvm@vger.kernel.org>; Wed,  9 Dec 2020 04:09:50 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id B8A033F202;
        Wed,  9 Dec 2020 04:08:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 06F2D2A510;
        Wed,  9 Dec 2020 05:08:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1607486898;
        bh=ruXF4j8WBiywZ0tao5Nu305nOOMAqRPpLkUtXs/EBvY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=tQQceO++rGkCF4j0JsCWRpda+pFI40GwuTRtEJVOe730aAI9eFJMMYFUKHh4V09Bd
         +0ASkhugZ49diEHte4eHrGiG4mqQECaNtqF5Jw8PA7/dlbqyVhIXpNXC8RvYEktUiV
         z7iWhRt1JDkMUloTKzcxF10PPKzl5AeAqKcTv1Aw=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QJDo6zIrjnEw; Wed,  9 Dec 2020 05:08:16 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Wed,  9 Dec 2020 05:08:16 +0100 (CET)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 2392A41F0C;
        Wed,  9 Dec 2020 04:08:16 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="VJRtrAxN";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (unknown [154.17.13.103])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 4DA8941FA8;
        Wed,  9 Dec 2020 04:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1607486886;
        bh=ruXF4j8WBiywZ0tao5Nu305nOOMAqRPpLkUtXs/EBvY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VJRtrAxN4vDG7llzb6BwUUhWh/qLZeftFJea32nPYauK5OzwRi8FO4XdYP+3TEOj6
         B93D6W6BDRNg+10OY4Flenq5cg5bIr0u9agjMNfHP9ya6iJCzNHipYeZnPn6RbfNXS
         gKe/+Ke3luZkO2vXDTpDRK8SFeYJppzlY/oprIRw=
Subject: Re: [PATCH 00/17] target/mips: Convert MSA ASE to decodetree
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <84a9e6e1-8606-777d-2204-63effb649184@flygoat.com>
Date:   Wed, 9 Dec 2020 12:07:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 2392A41F0C
X-Spamd-Result: default: False [-0.10 / 10.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all:c];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[8];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2020/12/8 上午8:36, Philippe Mathieu-Daudé 写道:
> Finally, we use decodetree with the MIPS target.
>
> Starting easy with the MSA ASE. 2700+ lines extracted
> from helper.h and translate.c, now built as an new
> object: mod-msa_translate.o.
>
> While the diff stat is positive by 86 lines, we actually
> (re)moved code, but added (C) notices.
>
> The most interesting patches are the 2 last ones.
>
> Please review,
>
> Phil.
>
> Based-on: <20201207224335.4030582-1-f4bug@amsat.org>
> (linux-user: Rework get_elf_hwcap() and support MIPS Loongson 2F/3A)
> Based-on: <20201207235539.4070364-1-f4bug@amsat.org>
> (target/mips: Add translate.h and fpu_translate.h headers)

Great work!

For the whole series:

Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

>
> Philippe Mathieu-Daudé (17):
>    target/mips: Introduce ase_msa_available() helper
>    target/mips: Simplify msa_reset()
>    target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA
>    target/mips: Simplify MSA TCG logic
>    target/mips: Remove now unused ASE_MSA definition
>    target/mips: Alias MSA vector registers on FPU scalar registers
>    target/mips: Extract msa_translate_init() from mips_tcg_init()
>    target/mips: Remove CPUMIPSState* argument from gen_msa*() methods
>    target/mips: Explode gen_msa_branch() as gen_msa_BxZ_V/BxZ()
>    target/mips: Rename msa_helper.c as mod-msa_helper.c
>    target/mips: Move msa_reset() to mod-msa_helper.c
>    target/mips: Extract MSA helpers from op_helper.c
>    target/mips: Extract MSA helper definitions
>    target/mips: Declare gen_msa/_branch() in 'translate.h'
>    target/mips: Extract MSA translation routines
>    target/mips: Introduce decode tree bindings for MSA opcodes
>    target/mips: Use decode_msa32() generated from decodetree
>
>   target/mips/cpu.h                             |    6 +
>   target/mips/fpu_translate.h                   |   10 -
>   target/mips/helper.h                          |  436 +---
>   target/mips/internal.h                        |    4 +-
>   target/mips/mips-defs.h                       |    1 -
>   target/mips/translate.h                       |    4 +
>   target/mips/mod-msa32.decode                  |   24 +
>   target/mips/kvm.c                             |   12 +-
>   .../mips/{msa_helper.c => mod-msa_helper.c}   |  429 ++++
>   target/mips/mod-msa_translate.c               | 2270 +++++++++++++++++
>   target/mips/op_helper.c                       |  394 ---
>   target/mips/translate.c                       | 2264 +---------------
>   target/mips/meson.build                       |    9 +-
>   target/mips/mod-msa_helper.h.inc              |  443 ++++
>   target/mips/translate_init.c.inc              |   38 +-
>   15 files changed, 3215 insertions(+), 3129 deletions(-)
>   create mode 100644 target/mips/mod-msa32.decode
>   rename target/mips/{msa_helper.c => mod-msa_helper.c} (93%)
>   create mode 100644 target/mips/mod-msa_translate.c
>   create mode 100644 target/mips/mod-msa_helper.h.inc
>
