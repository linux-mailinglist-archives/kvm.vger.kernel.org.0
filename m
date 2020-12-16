Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055512DBF78
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 12:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgLPLcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 06:32:32 -0500
Received: from relay4.mymailcheap.com ([137.74.80.154]:46713 "EHLO
        relay4.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPLcb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 06:32:31 -0500
X-Greylist: delayed 31232 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2020 06:32:30 EST
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id CBB053F162;
        Wed, 16 Dec 2020 12:30:58 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id EBA3A2A0C9;
        Wed, 16 Dec 2020 06:30:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1608118258;
        bh=zvIjcZ2xPsReMVmNP1mXvQf7DBPynXZQ6MmnQiqHoz0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=vFIMsbk/bdzR9TDZsck9Dbyr6UpRe+C+OLtR1OgHToL6tsL6UHzPw1ypzSRJcI7Ql
         IauudoHnrku2uKyh97dWTw1y57PK7xuhYk64DWeKp4JZba7dhwTVFDeNCQ35xqsq94
         UsqzM9uMnubr6ynTDHsQSUbScfmY6aBCHw1yUHnE=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZsiORm8fGa-p; Wed, 16 Dec 2020 06:30:56 -0500 (EST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Wed, 16 Dec 2020 06:30:56 -0500 (EST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 27DC342F4C;
        Wed, 16 Dec 2020 11:30:54 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="u2QKZXik";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (li1000-254.members.linode.com [45.33.50.254])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 1538242F5A;
        Wed, 16 Dec 2020 11:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1608118243;
        bh=zvIjcZ2xPsReMVmNP1mXvQf7DBPynXZQ6MmnQiqHoz0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=u2QKZXikChEi1NMqXQ6NWlmuisje5BkMw+Im66zR7zdrTP4Su5bHDOaTDKpMZytW8
         ttLMYyt7GomTtdfQA+zObni9MKjRF5SdKF03wnCUGGkC65rolFcat1EUfGLKsUiWka
         VXWKHpG2We/llHEL4xpjxbJGWRUwRrSvJKHapFZM=
Subject: Re: [PATCH v2 03/24] target/mips/cpu: Introduce isa_rel6_available()
 helper
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-4-f4bug@amsat.org>
 <508441db-8748-1b55-5f39-e6a778c0bdc0@linaro.org>
 <40e8df0f-01ab-6693-785b-257b8d3144bf@amsat.org>
 <af357960-40f2-b9e6-485f-d1cf36a4e95d@flygoat.com>
 <b1e8b44c-ae6f-786c-abe0-9a03eb5d3d63@flygoat.com>
 <5977d0f5-7e62-5f8a-d4ec-284f6f1af81d@amsat.org>
 <c969a2ab-95bc-8a83-6d59-0037ba725c2a@amsat.org>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <72255c0f-adf6-2546-91bb-2a17f6a3e011@flygoat.com>
Date:   Wed, 16 Dec 2020 19:30:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <c969a2ab-95bc-8a83-6d59-0037ba725c2a@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Server: mail20.mymailcheap.com
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
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
X-Rspamd-Queue-Id: 27DC342F4C
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2020/12/16 下午6:59, Philippe Mathieu-Daudé 写道:
> On 12/16/20 11:50 AM, Philippe Mathieu-Daudé wrote:
>> On 12/16/20 4:14 AM, Jiaxun Yang wrote:
>>> 在 2020/12/16 上午10:50, Jiaxun Yang 写道:
>>>>
>>>> TBH I do think it doesn't sounds like a good idea to make 32-bit
>>>> and 64-bit different. In fact ISA_MIPS32R6 is always set for targets
>>>> with ISA_MIPS64R6.
>>>>
>>>> We're treating MIPS64R6 as a superset of MIPS32R6, and ISA_MIPS3
>>>> is used to tell if a CPU supports 64-bit.
> I suppose you are talking about the CPU definitions
> (CPU_MIPS32R6/CPU_MIPS64R6).
>
>> Which is why I don't understand why they are 2 ISA_MIPS32R6/ISA_MIPS64R6
>> definitions.
> My comment is about the ISA definitions:
>
> #define ISA_MIPS32        0x0000000000000020ULL
> #define ISA_MIPS32R2      0x0000000000000040ULL
> #define ISA_MIPS64        0x0000000000000080ULL
> #define ISA_MIPS64R2      0x0000000000000100ULL
> #define ISA_MIPS32R3      0x0000000000000200ULL
> #define ISA_MIPS64R3      0x0000000000000400ULL
> #define ISA_MIPS32R5      0x0000000000000800ULL
> #define ISA_MIPS64R5      0x0000000000001000ULL
> #define ISA_MIPS32R6      0x0000000000002000ULL
> #define ISA_MIPS64R6      0x0000000000004000ULL

Yes, as insn_flags is set by CPU definitions.

......
/* MIPS Technologies "Release 1" */
#define CPU_MIPS32      (CPU_MIPS2 | ISA_MIPS32)
#define CPU_MIPS64      (CPU_MIPS5 | CPU_MIPS32 | ISA_MIPS64)

/* MIPS Technologies "Release 2" */
#define CPU_MIPS32R2    (CPU_MIPS32 | ISA_MIPS32R2)
#define CPU_MIPS64R2    (CPU_MIPS64 | CPU_MIPS32R2 | ISA_MIPS64R2)
......

As you can see when you're set insn_flags to CPU_MIPS64R2 the ISA flags
for ISA_MIPS64R2 ISA_MIPS32R2 ISA_MIPS32 ISA_MIPS64 ISA_MIPS5
ISA_MIPS3 ISA_MIPS2 ISA_MIPS1 all get set as well.


>>> So we may end up having four series of decodetrees for ISA
>>> Series1: MIPS-II, MIPS32, MIPS32R2, MIPS32R5 (32bit "old" ISAs)
>>> Series2: MIPS-III, MIPS64, MIPS64R2, MIPS64R5 (64bit "old" ISAs)
>>>
>>> Series3: MIPS32R6 (32bit "new" ISAs)
>>> Series4: MIPS64R6 (64bit "new" ISAs)
>> Something like that, I'm starting by converting the messier leaves
>> first, so the R6 and ASEs. My approach is from your "series4" to
>> "series1" last.

Sounds neat!

Thanks

- Jiaxun

