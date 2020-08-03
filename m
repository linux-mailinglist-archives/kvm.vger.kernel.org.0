Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597DD23A1AB
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 11:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgHCJRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 05:17:50 -0400
Received: from relay5.mymailcheap.com ([159.100.241.64]:40896 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgHCJRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 05:17:50 -0400
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.199.117])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 9F360206BD
        for <kvm@vger.kernel.org>; Mon,  3 Aug 2020 09:17:48 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id 265DD3F1D0;
        Mon,  3 Aug 2020 11:17:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 56F8F2A3BC;
        Mon,  3 Aug 2020 05:17:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1596446264;
        bh=22/goNB7gt/XyIaESxstbuULirnXgB6CEVT5iza0SEo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=D3HX9gdmvUNlV+i63rHLXEm9L6hgAHZ59sf/KuYwrfgLdgjaB0RQB4L4qCy2n19jj
         Odfj4bEyY0sQSoCs391HK1/akBH181CApeT3A6+hSKS8zumlfXtrB3CKBGs8AH567/
         Up5MlxJVLNf4+lbq9ALJlCZFlYoy2giYAgigk8Ps=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zBzcSTGfcWSy; Mon,  3 Aug 2020 05:17:42 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Mon,  3 Aug 2020 05:17:42 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 108B34014B;
        Mon,  3 Aug 2020 09:17:41 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="W34K0YrP";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (n11212042148.netvigator.com [112.120.42.148])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id E78D64014B;
        Mon,  3 Aug 2020 09:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1596446031;
        bh=22/goNB7gt/XyIaESxstbuULirnXgB6CEVT5iza0SEo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=W34K0YrPVs/+TXT0otCrjxRv25RDq7fmfcWDp1cksmaeCNo2WDmCJs2pIzu44t/Mp
         GTFKPVM/vBXg/eIt2RZr111mQj7JtcmbK126XgqXC90gmOZoIxz1bQg/Iraim7ktdj
         l+ueH+OqaTFCEoeEQJOiUpvU758niCr9miJuE04k=
Subject: Re: [PATCH 2/5] dt-bindings: mips: Document Loongson kvm guest board
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Fuxin Zhang <zhangfx@lemote.com>
References: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
 <1596005919-29365-2-git-send-email-chenhc@lemote.com>
 <20200729095248.GA9234@alpha.franken.de>
 <CAAhV-H7MzcW6Uv8XPaOh=5PmsFbRa9n=W1GjWP1WWwCYL_r-hA@mail.gmail.com>
 <CAAhV-H4SXCmW8V-fXhGGiSQbM4cQ3bN3K76JK61Ms+vWxiuviw@mail.gmail.com>
 <20200731083252.GA7946@alpha.franken.de>
 <89376514-e6c1-469c-f212-865d7a549854@flygoat.com>
 <CAAhV-H4amAWtNr-DTWV=W-g-B4eob3+zLjVDN5GgKMumnjqYjw@mail.gmail.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <a1147c93-8852-4a6f-fdee-214b64f2db65@flygoat.com>
Date:   Mon, 3 Aug 2020 17:13:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4amAWtNr-DTWV=W-g-B4eob3+zLjVDN5GgKMumnjqYjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 108B34014B
X-Spamd-Result: default: False [1.40 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         RCPT_COUNT_SEVEN(0.00)[8];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         TO_DN_ALL(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         FREEMAIL_CC(0.00)[alpha.franken.de,redhat.com,gmail.com,kernel.org,vger.kernel.org,lemote.com];
         SUSPICIOUS_RECIPS(1.50)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2020/8/3 下午2:05, Huacai Chen 写道:
> Hi, Thomas,
>
> On Fri, Jul 31, 2020 at 7:57 PM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
>>
>>
>> 在 2020/7/31 下午4:32, Thomas Bogendoerfer 写道:
>>> On Fri, Jul 31, 2020 at 11:01:58AM +0800, Huacai Chen wrote:
>>>> Hi, Thomas,
>>>>
>>>> On Wed, Jul 29, 2020 at 6:08 PM Huacai Chen <chenhc@lemote.com> wrote:
>>>>> Hi, Thomas,
>>>>>
>>>>>
>>>>> On Wed, Jul 29, 2020 at 6:00 PM Thomas Bogendoerfer
>>>>> <tsbogend@alpha.franken.de> wrote:
>>>>>> On Wed, Jul 29, 2020 at 02:58:36PM +0800, Huacai Chen wrote:
>>>>>>> Document loongson64v-4core-virtio, a virtio based kvm guest board for
>>>>>>> Loongson-3.
>>>>>>>
>>>>>>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>>>>>>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>>>>>>> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>>>>>> hmm, I can't remember adding my signed-off to this patch. Could you
>>>>>> give me a reference for this ?
>>>>>>
>>>>> I'm sorry, this is a copy paste error..
>>>>>
>>>> Should I send V2 for this series?
>>> no, if nothing else needs a resent. Problem with this series is,
>>> that it touches a few places, so it's not clear who should merge
>>> it...
>> Actually the first patch is already in the next. I suspect they should
>> go through MIPS tree.
>> Probably this patch needs a ack from Rob?
> I agree with Jiaxun, this series should go through MIPS tree.

I'd suggest to have a topic branch for this after getting PCI tree merged.

Anyway, I really wish to see this as a part of 5.9 release.

Thanks.

- Jiaxun
>
> Huacai
>> - Jiaxun
>>
>>> Thomas.
>>>
