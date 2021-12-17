Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601F44787F3
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 10:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhLQJla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 04:41:30 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:34007 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbhLQJl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 04:41:28 -0500
Received: from [192.168.100.1] ([82.142.30.186]) by mrelayeu.kundenserver.de
 (mreue108 [213.165.67.119]) with ESMTPSA (Nemesis) id
 1Mv2pC-1mgcv93SMK-00r0Fu; Fri, 17 Dec 2021 10:41:19 +0100
Message-ID: <d7ec6d55-1260-cf98-0920-18ac422906ed@vivier.eu>
Date:   Fri, 17 Dec 2021 10:41:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH-for-7.0] target/i386/kvm: Replace use of __u32 type
Content-Language: fr
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     qemu-trivial@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
References: <20211116193955.2793171-1-philmd@redhat.com>
From:   Laurent Vivier <laurent@vivier.eu>
In-Reply-To: <20211116193955.2793171-1-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:vBDF5a2UX+SM84erX35iC7LViCsu2LwVNTDbx1PonKv7rKdTOb4
 SYHKoNugrTEbmDP5uSdCgNh9Cbi16dQbTKcamCnF65gam+zcDxDxFb2N7Ess0oQAxTwsjOC
 /LCP68IUWPybARi0tVgED1psi7Cf1f9innZvDJpTNF1eJR4LjUtqRvTmCeOwVP3kUzr2+SW
 B6JXZFj81CszLuuBHdilw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:v3mtfSElf64=:XCVfw16ZPaa2Tgk0dqtYGN
 QLCpuU4YjP96qsYWKVzSxbHFAkpVuvGyJyeoQqfK60n2g8ERB0T6SOfB5MHISoRfybPJdFbWI
 db7fugPS5ubaqPrhQio/zZnb+IoZvUN8RyRBUCArIQHBeGL3CoTcKbTakGS1HTH/Lq/2bNGTP
 cj7LT4x6WOvhLdKRWWM9x46H5g1kIqSHLhxScT52RtLNmH/kwqOghdBJm/kFS53fUSfRwSi5w
 IYaASAkTKrfNWacGYC7vEQoztl7Vw7oUzn82gEEpTlQjq8J94iy5mNfLz5+lhW6Iyd6fc9BmO
 JbJKZoiaHCidGhjgup296o6NiYKho1a5NcoKaPoAQLDtj4vsyvIxW1ztcPYyjVycSS6Bmi/EV
 V4x1Bit9tgdgOiQlsC/1OHE3tpebNJqDK9IT5lPb8lFIT+Yl46GVRjsidOsETt1hby/vTXD3I
 sRIEpDaB0VszBfV0X4YMJJuHaOXoBSg=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 16/11/2021 à 20:39, Philippe Mathieu-Daudé a écrit :
> QEMU coding style mandates to not use Linux kernel internal
> types for scalars types. Replace __u32 by uint32_t.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/kvm/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 5a698bde19a..13f8e30c2a5 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1406,7 +1406,7 @@ static int hyperv_fill_cpuids(CPUState *cs,
>       c->edx = cpu->hyperv_limits[2];
>   
>       if (hyperv_feat_enabled(cpu, HYPERV_FEAT_EVMCS)) {
> -        __u32 function;
> +        uint32_t function;
>   
>           /* Create zeroed 0x40000006..0x40000009 leaves */
>           for (function = HV_CPUID_IMPLEMENT_LIMITS + 1;
> 

Applied to my trivial-patches branch.

Thanks,
Laurent
