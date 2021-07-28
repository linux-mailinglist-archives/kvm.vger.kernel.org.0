Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE8D3D8D49
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 13:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbhG1L4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 07:56:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234703AbhG1L4s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 07:56:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627473406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/XaRRTboc70MUCyM0TQteUnofxTwGl2oCgNNxgCYL0w=;
        b=HSWbQfPM+oMOgocyMrVHsboKe/KBPgiYgd6eY6+iB0tpd9d14xCOUdCPNUGje0MWyfPvlf
        od5vQIgsecLysMN/zn+Qi4XpNdV+3XZo46ZbCwuPPJk2VrXhn41CuZimB28q5qotCz5/zD
        CPfJZp13YAZIjPr52/OkPhDicV3fdi0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-7HnEio8KPn-MpKm0EBKKxA-1; Wed, 28 Jul 2021 07:56:44 -0400
X-MC-Unique: 7HnEio8KPn-MpKm0EBKKxA-1
Received: by mail-wr1-f72.google.com with SMTP id n1-20020a5d59810000b029013cd60e9baaso852139wri.7
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 04:56:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/XaRRTboc70MUCyM0TQteUnofxTwGl2oCgNNxgCYL0w=;
        b=fIGIgLLFRouyXht4DHZCEL0wwq9hnaXbcUVOjC7sQ6p7WprWKbS9BKeE5eIb6cN1U8
         BAngVH4PaQ1HhqiSUXxYQ5d1q2Q8SkIB4PprlIozDe5170O/Gpyxk9N1Q4RAXGBkyVhq
         8OPtm6cc0GT++eaLEXW65UTNGyedg/CGZxYTSiivHUh8kDlU/F2UJp2NVWqkF/yIcM7Y
         eX0R1GbWFEMeVTCqxcZiLW4XZEfXOtLBBdy33aZXoOvAafYAuKbusBiOlaPBb/V7MqRG
         QzR+/fy3NJEVX57jckUs8F1TgWTGJuloNDP9KlYVH9i9o9nvdL4Zf+P6aS6RS2vXxR4v
         xrmA==
X-Gm-Message-State: AOAM533I9mimRCIxi40XA2WvtPjg17h6jJfyoBVgfBYd93NI/1oYubpE
        JHMdiuLYPaHu86YR+f2SKhlqI2HIVWGHDDgK1OA+WFIw7WEUH9KvlECaINM9LQdR6ugW5SRxiS1
        GYUNFgKgAwvh9
X-Received: by 2002:a05:600c:88a:: with SMTP id l10mr1874075wmp.78.1627473403531;
        Wed, 28 Jul 2021 04:56:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzorpSuliVsG4NQ0s7BaFDu+gPHUAXbzulsOoPrbAqQKRZIKFJsvzbR5rPxJnHpBC1yStYWg==
X-Received: by 2002:a05:600c:88a:: with SMTP id l10mr1874066wmp.78.1627473403297;
        Wed, 28 Jul 2021 04:56:43 -0700 (PDT)
Received: from thuth.remote.csb (p5791d475.dip0.t-ipconnect.de. [87.145.212.117])
        by smtp.gmail.com with ESMTPSA id q22sm5971323wmc.16.2021.07.28.04.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 04:56:42 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Add SPDX and header comments
 for s390x/* and lib/s390x/*
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com
References: <20210728101328.51646-1-frankja@linux.ibm.com>
 <20210728101328.51646-2-frankja@linux.ibm.com>
 <20210728123221.7ca90b35@p-imbrenda>
 <d5c31cc5-0645-aa91-374e-c668b37e1150@redhat.com>
 <2e391a1a-54d4-8713-4a93-104a6b4cfaf1@linux.ibm.com>
 <d1c3e9f0-57c0-e941-3e3f-94a897ace177@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <32e8624e-4dd9-0c39-fe65-87f1ba0a4b24@redhat.com>
Date:   Wed, 28 Jul 2021 13:56:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <d1c3e9f0-57c0-e941-3e3f-94a897ace177@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/2021 13.41, Janosch Frank wrote:
> On 7/28/21 1:36 PM, Janosch Frank wrote:
>> On 7/28/21 12:36 PM, Thomas Huth wrote:
>>> On 28/07/2021 12.32, Claudio Imbrenda wrote:
>>>> On Wed, 28 Jul 2021 10:13:26 +0000
>>>> Janosch Frank <frankja@linux.ibm.com> wrote:
>>>>
>>>>> Seems like I missed adding them.
>>>>>
>>>>> The s390x/sieve.c one is a bit of a head scratcher since it came with
>>>>> the first commit but I assume it's lpgl2-only since that's what the
>>>>> COPYRIGHT file said then.
>>>>>
>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> ---
>>>>>    lib/s390x/uv.c   |  9 +++++++++
>>>>>    s390x/mvpg-sie.c |  9 +++++++++
>>>>>    s390x/sie.c      | 10 ++++++++++
>>>>>    x86/sieve.c      |  5 +++++
>>>>>    4 files changed, 33 insertions(+)
>>> [...]
>>>>> diff --git a/x86/sieve.c b/x86/sieve.c
>>>>> index 8150f2d9..b89d5f80 100644
>>>>> --- a/x86/sieve.c
>>>>> +++ b/x86/sieve.c
>>>>> @@ -1,3 +1,8 @@
>>>>> +/* SPDX-License-Identifier: LGPL-2.0-only */
>>>>
>>>> do you really need to fix something in the x86 directory? (even though
>>>> it is also used on other archs)
>>>
>>> I just realized that s390x/sieve.c is just a symlink, not a copy of the file :-)
>>
>> You're not the only one...
>>
>>>
>>>> maybe you can split out this as a separate patch, so s390x stuff is
>>>> more self contained, and others can then discuss the sieve.c patch
>>>> separately if needed?
>>>
>>> That might make sense, indeed.
>>
>> Yup will do
> 
> On second thought I'm just gonna drop that hunk since x86 doesn't really
> have SPDX or header comments for most of their files anyway.

That's fine, too. We can still add them there later.

  Thomas

