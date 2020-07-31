Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042FF2344E7
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 13:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732808AbgGaL5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 07:57:33 -0400
Received: from relay5.mymailcheap.com ([159.100.241.64]:57700 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732689AbgGaL5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 07:57:33 -0400
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.113.132])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id A86CD206DF;
        Fri, 31 Jul 2020 11:57:30 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay2.mymailcheap.com (Postfix) with ESMTPS id 0B8633E90B;
        Fri, 31 Jul 2020 13:57:26 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 4B6F52A3A4;
        Fri, 31 Jul 2020 07:57:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1596196645;
        bh=+cx5bMqMM+l5lmOeeyPclIOj+NELMcWN+i1mN67AK9k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=EcyN6Ph5V2JOFYWQ5c3W8O0e5D+o1zJDULLpSE4MZ2iYT3+lwGTntEXt45BCbI3m0
         FnZC5LycAZvfA3YF2LBs+tcIR2p9FZkZVTsxHpwxaeXuiXHn+DDwnhXwfURfgcll/Y
         1JpUWxpHdjeoDL07ElVPHgOhzFl3PANTrebe3z7U=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1tEkQnz2IREZ; Fri, 31 Jul 2020 07:57:23 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Fri, 31 Jul 2020 07:57:23 -0400 (EDT)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 694554115D;
        Fri, 31 Jul 2020 11:57:20 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="lWhVektd";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (unknown [203.86.239.91])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id AC4584085D;
        Fri, 31 Jul 2020 11:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1596196624;
        bh=+cx5bMqMM+l5lmOeeyPclIOj+NELMcWN+i1mN67AK9k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lWhVektd60zUAvAhL/+9c9fC4Kk/iGagIPA0DruARg7LhYsuQf89Q8Ae2uKxGba9K
         VHBhu2ecFRNnJv9HJcA4xFf3Arp/FEIRcw9ZQnS3m87KIS+nWLneHiwCcg+M2fuvQX
         2v4/H0iizZyoJ0jDX6yrXK8Tujb6xDaWHXtS6mRI=
Subject: Re: [PATCH 2/5] dt-bindings: mips: Document Loongson kvm guest board
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <89376514-e6c1-469c-f212-865d7a549854@flygoat.com>
Date:   Fri, 31 Jul 2020 19:56:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731083252.GA7946@alpha.franken.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 694554115D
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
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1];
         ML_SERVERS(-3.10)[213.133.102.83];
         TO_DN_ALL(0.00)[];
         DKIM_TRACE(0.00)[flygoat.com:+];
         RCPT_COUNT_SEVEN(0.00)[8];
         RCVD_IN_DNSWL_NONE(0.00)[213.133.102.83:from];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         FREEMAIL_CC(0.00)[redhat.com,gmail.com,kernel.org,vger.kernel.org,lemote.com];
         SUSPICIOUS_RECIPS(1.50)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



ÔÚ 2020/7/31 ÏÂÎç4:32, Thomas Bogendoerfer Ð´µÀ:
> On Fri, Jul 31, 2020 at 11:01:58AM +0800, Huacai Chen wrote:
>> Hi, Thomas,
>>
>> On Wed, Jul 29, 2020 at 6:08 PM Huacai Chen <chenhc@lemote.com> wrote:
>>> Hi, Thomas,
>>>
>>>
>>> On Wed, Jul 29, 2020 at 6:00 PM Thomas Bogendoerfer
>>> <tsbogend@alpha.franken.de> wrote:
>>>> On Wed, Jul 29, 2020 at 02:58:36PM +0800, Huacai Chen wrote:
>>>>> Document loongson64v-4core-virtio, a virtio based kvm guest board for
>>>>> Loongson-3.
>>>>>
>>>>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>>>>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>>>>> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>>>> hmm, I can't remember adding my signed-off to this patch. Could you
>>>> give me a reference for this ?
>>>>
>>> I'm sorry, this is a copy paste error..
>>>
>> Should I send V2 for this series?
> no, if nothing else needs a resent. Problem with this series is,
> that it touches a few places, so it's not clear who should merge
> it...

Actually the first patch is already in the next. I suspect they should 
go through MIPS tree.
Probably this patch needs a ack from Rob?

- Jiaxun

>
> Thomas.
>
