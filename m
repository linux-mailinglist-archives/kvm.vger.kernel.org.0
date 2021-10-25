Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7D6439A59
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 17:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhJYPYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 11:24:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229897AbhJYPYX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 11:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635175320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4XvEiZf2+PlOP4jQfZDuL7k1/1lBVAKJKfCdxPMRvMw=;
        b=Wjc6niCZSAWEj4cVz2HCxAfFJ6RYENp2hp3iGU/BDSsFhzTCNoXM2Fv/05nxtiWAd958Zg
        3pPk0Z25O4QpKbe7ur/vUAqHTWopL5SzJNkDzl0MBDdyy7YAbJLaxj08SxOr09MXaGc/Zr
        RH11mjz4D5kl841kv0L4abU04coGBd4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-24Z53SOGP4KHwbpxCGskCA-1; Mon, 25 Oct 2021 11:21:58 -0400
X-MC-Unique: 24Z53SOGP4KHwbpxCGskCA-1
Received: by mail-ed1-f71.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so10208374edj.21
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 08:21:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4XvEiZf2+PlOP4jQfZDuL7k1/1lBVAKJKfCdxPMRvMw=;
        b=wThtf93KiFbU0KOK2giu41+CFZ+xldNjICYjVgY0JmnhU/JKa+jtJNioPYyY94P+Ck
         xNlcqj1glhNKdC6hgQNXlcZ/aCT8NkWwaP7kHlCmDVUttIL2beXHhc+WU6hvEiAGwO44
         F6Xbp1ZO90ufMrAj993ipvOAn+r3ygRhqcx2S2zCAEmmmeTa8++XNl67vXU1R0dsE/5I
         MDVkWYMPTpY4y91GnUxV1zDC+7Sa3EvbdWUBqcVrvZyfU6a1RYrsqXFZ7YbeAzO57TYp
         UM7Munys/JuBNRwdePTH2m+4q3kCJKFLMQ0LwdtrvljzvUJnB0ZnR7LU0CjGCnAQj6Wt
         bsCg==
X-Gm-Message-State: AOAM532x+lByUqvpr5m76cnc3o9y17GDeCA105ZsvVt2v1DoxZQ6xZGQ
        9yAeqflhatqnu+edhuMq8j+OhQUcF+eyUtaj2qHQ8/pOh/hWCzQtumDjMPECIuRZ0cJmtcgzE4T
        MGAi1a8jX4zhe
X-Received: by 2002:a17:906:15d0:: with SMTP id l16mr23395540ejd.462.1635175317468;
        Mon, 25 Oct 2021 08:21:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzF6LPnRTghCLifJUp2dbPdHn31IcztASGLIuIqGJjD3b3HXwvY7pD47zsSUkWHV1930VgzTA==
X-Received: by 2002:a17:906:15d0:: with SMTP id l16mr23395507ejd.462.1635175317210;
        Mon, 25 Oct 2021 08:21:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cn2sm2671320edb.83.2021.10.25.08.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 08:21:56 -0700 (PDT)
Message-ID: <674bc620-f013-d826-a4d4-00a142755a9e@redhat.com>
Date:   Mon, 25 Oct 2021 17:21:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 0/4] KVM: x86: APICv cleanups
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211022004927.1448382-1-seanjc@google.com>
 <23d9b009-2b48-d93c-3c24-711c4757ca1b@redhat.com>
 <9c159d2f23dc3957a2fda0301b25fca67aa21b30.camel@redhat.com>
 <b931906f-b38e-1cb5-c797-65ef82c8b262@redhat.com>
 <YXbAxkf1W37m9eZp@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXbAxkf1W37m9eZp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/21 16:35, Sean Christopherson wrote:
>> So yeah, I think you're right.
> Yep.  The alternative would be to explicitly check for a pending APICv update.
> I don't have a strong opinion, I dislike both options equally:-)

No, checking for the update is worse and with this example, I can now 
point my finger on why I preferred the VM check even before: because 
even though the page fault path runs in vCPU context and uses a 
vCPU-specific role, overall the page tables are still per-VM.

Therefore it makes sense for the page fault path to synchronize with 
whoever updates the flag and zaps the page, and not with the KVM_REQ_* 
handler of the same vCPU.

(Here goes the usual shameless plug of my lockless programming articles 
on LWN---I think you're old enough to vaguely remember Jerry 
Pournelle---and in particular the first one at 
https://lwn.net/Articles/844224/).

> Want me to type up a v3 comment?

Yes, please do.

Paolo

