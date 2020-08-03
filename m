Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2841239DCB
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 05:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgHCDMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Aug 2020 23:12:48 -0400
Received: from relay5.mymailcheap.com ([159.100.241.64]:39971 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgHCDMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Aug 2020 23:12:47 -0400
Received: from relay3.mymailcheap.com (relay3.mymailcheap.com [217.182.66.161])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id E041A2013D;
        Mon,  3 Aug 2020 03:12:45 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay3.mymailcheap.com (Postfix) with ESMTPS id 65B2A3F1CC;
        Mon,  3 Aug 2020 05:12:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 4626C2A90C;
        Mon,  3 Aug 2020 05:12:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1596424363;
        bh=UZjQrpxLZgzj7AV9GHXgrfKAipjYjl3Ae1P9Qhh/JxI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=I3KaMM4sG0Clk8fbwmvMQJaz2+ibJAfocx03kCYFoVvsm2CBHKyIRO3lWwAhrPEPs
         5Fi5RvFy3jVkex8hhjycl3hRZYsCitdKrEz6lm3knf/j7sMQyJLhW/0kAFMcrgURKv
         NReqxv8rdxznmBBI2ScbxmelyclTdHo+Wt63jr1o=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id J8Q3nTzhZUE4; Mon,  3 Aug 2020 05:12:41 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Mon,  3 Aug 2020 05:12:41 +0200 (CEST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 55145414C8;
        Mon,  3 Aug 2020 03:12:39 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="WoaPoWg3";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (unknown [203.86.239.91])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 9DA4E41337;
        Mon,  3 Aug 2020 03:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1596424311;
        bh=UZjQrpxLZgzj7AV9GHXgrfKAipjYjl3Ae1P9Qhh/JxI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WoaPoWg3w4Pv22ogu9wkfPA0IQ7S+Nbm4jwrI6pNKGwW3pPPz10AmXczh9n+6MCTN
         rTaJ5P++haLVPi5IgP8mw6hy5KXa6bK/Lf6PrBzH3Lu3QeER0JSfOfwS/ZYAZGM32S
         79dg2XKLj/DvFBSvJzUsQX6/aydPNTDmK67aHwBo=
Subject: Re: [PATCH] MIPS: KVM: Convert a fallthrough comment to fallthrough
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
References: <20200706014534.352509-1-jiaxun.yang@flygoat.com>
 <CAAhV-H753naJOe9BnHTr-OoWDo=Bg-PAVpTNFU5fk0MB-pP5zA@mail.gmail.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <32a41c71-6bb5-1b76-8a31-cc17312440b6@flygoat.com>
Date:   Mon, 3 Aug 2020 11:11:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H753naJOe9BnHTr-OoWDo=Bg-PAVpTNFU5fk0MB-pP5zA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 55145414C8
X-Spamd-Result: default: False [1.40 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         RCPT_COUNT_FIVE(0.00)[5];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1];
         ML_SERVERS(-3.10)[213.133.102.83];
         TO_DN_ALL(0.00)[];
         DKIM_TRACE(0.00)[flygoat.com:+];
         RCVD_IN_DNSWL_NONE(0.00)[213.133.102.83:from];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,alpha.franken.de];
         SUSPICIOUS_RECIPS(1.50)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Paoli,

Could you please take a look at this patch?

Thanks.

- Jiaxun

在 2020/7/8 下午4:04, Huacai Chen 写道:
> Reviewed-by: Huacai Chen <chenhc@lemote.com>
>
> On Mon, Jul 6, 2020 at 9:53 AM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
>> There is a fallthrough comment being forgotten,
>> GCC complains about it:
>>
>> arch/mips/kvm/emulate.c: In function kvm_mips_emulate_load:
>> arch/mips/kvm/emulate.c:1936:21: error: this statement may fall through
>>   1936 |   vcpu->mmio_needed = 1; /* unsigned */
>>        |   ~~~~~~~~~~~~~~~~~~^~~
>> arch/mips/kvm/emulate.c:1939:2: note: here
>>   1939 |  case lw_op:
>>
>> Just fix it.
>>
>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>> ---
>>   arch/mips/kvm/emulate.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
>> index 5ae82d925197..bb17d8274462 100644
>> --- a/arch/mips/kvm/emulate.c
>> +++ b/arch/mips/kvm/emulate.c
>> @@ -1934,7 +1934,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>>
>>          case lwu_op:
>>                  vcpu->mmio_needed = 1;  /* unsigned */
>> -               /* fall through */
>> +               fallthrough;
>>   #endif
>>          case lw_op:
>>                  run->mmio.len = 4;
>> --
>> 2.27.0
>>
