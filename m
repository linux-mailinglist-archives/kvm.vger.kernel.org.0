Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4858F334004
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 15:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhCJOMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 09:12:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231690AbhCJOLv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 09:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615385511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XaCRIAv0zuOi3e4F8mNsYwyfx5x3dexvNCXAIAOhExc=;
        b=WOjytyr90G0fxeV2GlzD7RP24dZa63uP7V3n5OY0HPi78MCJ5DFmY3l47JV9oK7f3Zc7M5
        rJx2S1PdoQ7r48tJfpxo+jvnQOyE3PEUMAeChkHk5egHkZ5BhJRH90H1LyyCzniIVipWok
        hzKrH7TNGSdmdeScLC3zrhYKdEpSB3M=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56--fPNBIeRMDCv3NaCwrvA6Q-1; Wed, 10 Mar 2021 09:11:49 -0500
X-MC-Unique: -fPNBIeRMDCv3NaCwrvA6Q-1
Received: by mail-ej1-f69.google.com with SMTP id rl7so7237324ejb.16
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 06:11:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XaCRIAv0zuOi3e4F8mNsYwyfx5x3dexvNCXAIAOhExc=;
        b=kEcGHyuEeTg8ZG5FVpxmmONJpLSI1gYIibWWB48o5ri2GN6po+ysHylJhf4RJjwpgA
         AcOImisy2ahSRZsG1a8l7lKobuL+fEuTqrlrbYGTryfoCCr7byhjJk3zhnnNAUIpo5EQ
         Cuy5GMyrGD4uHCnZUnlwxxZfevDUNYnRNDq7l8ug8MPccjPticcIid2DvTPVW8nzTA+I
         rX2CDdwzVXwO9Dw0AnIPpbpAGEBE0drBhrLePxrgKgYG2Kj07ld00ayd9KC7paccI8BS
         ihsQp6b0RwWLXg1L/zwflR4QXvXdbjAEOYorbmBKFs3H/tVkhfm4OpmvONiLXBmr/sP2
         Xqjg==
X-Gm-Message-State: AOAM532tAPxvYpxy3MOuvg0RpjHXEQqm7Q6y2WyOFWDX8SYGNeyjstOK
        jYZZ9TUDeZrmhGkMPRNn2xnOPGZodne6Z8xmlmcPM7LLjpFFqboYs7t45MsZ1I75wgku6Eki8c2
        BgOpS4LUWbaRz
X-Received: by 2002:aa7:ce8a:: with SMTP id y10mr3556879edv.66.1615385507956;
        Wed, 10 Mar 2021 06:11:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDWBMa1rXHJdqpGzsMxuiyTfPR3uDelc2RKoozPlpamdPNfqC+GTbwZjDfQAUqseGCiLihxA==
X-Received: by 2002:aa7:ce8a:: with SMTP id y10mr3556852edv.66.1615385507766;
        Wed, 10 Mar 2021 06:11:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id br13sm10206941ejb.87.2021.03.10.06.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 06:11:46 -0800 (PST)
Subject: Re: [RFC v3 4/5] KVM: add ioregionfd context
To:     Elena Afanasova <eafanasova@gmail.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
 <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
 <2ee8cb35-3043-fc06-9973-c8bb33a90d40@redhat.com>
 <2e7dfb1c-fe13-4e6d-ae65-133116866c2a@redhat.com>
 <c9d8e6a6b533e67192b391dd902e27609121222c.camel@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <50823987-d285-7a18-7c46-771f08c3c0ff@redhat.com>
Date:   Wed, 10 Mar 2021 15:11:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c9d8e6a6b533e67192b391dd902e27609121222c.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/03/21 14:20, Elena Afanasova wrote:
> On Tue, 2021-03-09 at 09:01 +0100, Paolo Bonzini wrote:
>> On 09/03/21 08:54, Jason Wang wrote:
>>>> +        return;
>>>> +
>>>> +    spin_lock(&ctx->wq.lock);
>>>> +    wait_event_interruptible_exclusive_locked(ctx->wq, !ctx-
>>>>> busy);
>>>
>>> Any reason that a simple mutex_lock_interruptible() can't work
>>> here?
>>
>> Or alternatively why can't the callers just take the spinlock.
>>
> I'm not sure I understand your question. Do you mean why locked version
> of wait_event() is used?

No, I mean why do you need to use ctx->busy and wait_event, instead of 
operating directly on the spinlock or on a mutex.

Paolo

