Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AB2241C91
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 16:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgHKOjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 10:39:14 -0400
Received: from relay5.mymailcheap.com ([159.100.248.207]:60785 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbgHKOjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 10:39:13 -0400
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.154])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 69B30260EC
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 14:39:10 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id 62B5D3F20A;
        Tue, 11 Aug 2020 16:39:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 322F02A519;
        Tue, 11 Aug 2020 16:39:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1597156747;
        bh=iIou0YGXsaz4tenihi4kspgnU410+h+4rSvatxov18k=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=o4x1IOWGnMOooK/NSHeXWPwWNhS4rEUScv0trMtEpRcB9sZUwGQ6kLI2gDWc6foMf
         LS9sc2Hv2RKwb1kIo+Ae0DzBR6pDDS+iQuDwu5xUxX8VMtMaSHrLHEvfL9lMq0xxwM
         iciB3aYHBPpiijd7zNeukvYNVYCAYiqGPPscCqgg=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Uf-F6loMtAcP; Tue, 11 Aug 2020 16:39:06 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Tue, 11 Aug 2020 16:39:06 +0200 (CEST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 9779640855;
        Tue, 11 Aug 2020 14:39:05 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="sGK+w3Nz";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (n11212042148.netvigator.com [112.120.42.148])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id C91AE40855;
        Tue, 11 Aug 2020 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1597156738;
        bh=iIou0YGXsaz4tenihi4kspgnU410+h+4rSvatxov18k=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=sGK+w3Nz2LronVjeIOj0dAd4di6kmCubd0B1A860wHQXz0D6/C1IWD03D/aYd/qjK
         yqZPUihB4z8fmgmNuJgfFwhpkXmjGWW9MWK40apvDVwt+7BiDyf3728f6pDD4Saz+U
         jYxLKQQem3oXQrxHUhrmaGLDpSj/bI4Ihvbb4beY=
Subject: Re: [PATCH RESEND] KVM: MIPS/VZ: Fix build error caused by 'kvm_run'
 cleanup
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     Xingxing Su <suxingxing@loongson.cn>,
        Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1597138297-2105-1-git-send-email-suxingxing@loongson.cn>
 <49a63b59-c03e-b9f5-03d6-ef268f5a6555@flygoat.com>
Message-ID: <f44652c7-2716-7e56-6e04-3f990a197895@flygoat.com>
Date:   Tue, 11 Aug 2020 22:38:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <49a63b59-c03e-b9f5-03d6-ef268f5a6555@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 9779640855
X-Spamd-Result: default: False [1.40 / 10.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all:c];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[8];
         RCVD_IN_DNSWL_NONE(0.00)[213.133.102.83:from];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         FREEMAIL_TO(0.00)[loongson.cn,lemote.com,alpha.franken.de,gmail.com,redhat.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         SUSPICIOUS_RECIPS(1.50)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2020/8/11 下午10:37, Jiaxun Yang 写道:
>
>
> 在 2020/8/11 下午5:31, Xingxing Su 写道:
>> Commit c34b26b98caca48ec9ee9 ("KVM: MIPS: clean up redundant 'kvm_run'
>> parameters") remove the 'kvm_run' parameter in kvm_vz_gpsi_lwc2.
>>
>> The following build error:
>>
>> arch/mips/kvm/vz.c: In function ‘kvm_trap_vz_handle_gpsi’:
>> arch/mips/kvm/vz.c:1243:43: error: ‘run’ undeclared (first use in 
>> this function)
>>     er = kvm_vz_gpsi_lwc2(inst, opc, cause, run, vcpu);
>>                                             ^~~
>> arch/mips/kvm/vz.c:1243:43: note: each undeclared identifier is 
>> reported only
>> once for each function it appears in
>> scripts/Makefile.build:283: recipe for target 'arch/mips/kvm/vz.o' 
>> failed
>> make[2]: *** [arch/mips/kvm/vz.o] Error 1
>> scripts/Makefile.build:500: recipe for target 'arch/mips/kvm' failed
>> make[1]: *** [arch/mips/kvm] Error 2
>> Makefile:1785: recipe for target 'arch/mips' failed
>> make: *** [arch/mips] Error 2
>>
>> Signed-off-by: Xingxing Su <suxingxing@loongson.cn>
>
> That have already quened in Paolo's KVM tree.
>
> Thanks.

Oops, I was looking at the wrong place, please ignore the noise.

Thanks.

- Jiaxun

>
> - Jiaxun
>
>> ---
>>   +cc Paolo Bonzini <pbonzini@redhat.com> and kvm@vger.kernel.org.
>>
>>
