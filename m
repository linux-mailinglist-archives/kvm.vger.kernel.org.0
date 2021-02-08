Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A30313617
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhBHPF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 10:05:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230447AbhBHPE3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 10:04:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612796571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LbdAFz242/wcccGsjqXRHOfGc7WNX0ivy1w0yG7g8w8=;
        b=BzqFFrAfGy/aZDBXhebaH1vNBH1erdvCD0iEiUWaMSHsaztOjp+jnbxranXMOmLkxkypH5
        HOSdPeLbdzauSVnftCrVRW3iFhX2dr7UCTKYdCyNNlZmlW/08yPKTy3HVRnkLiQnqwxcX9
        vuoSdYAF8ptLHg6BmhCFiygRWe6oW8g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-pfKrlrSAMrOcJj993awlGA-1; Mon, 08 Feb 2021 10:02:49 -0500
X-MC-Unique: pfKrlrSAMrOcJj993awlGA-1
Received: by mail-wr1-f72.google.com with SMTP id s10so151547wro.13
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 07:02:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LbdAFz242/wcccGsjqXRHOfGc7WNX0ivy1w0yG7g8w8=;
        b=VZVulQxmHImr04LKzQlpxmCNEIzvAcMzDD+ljd6iF5Hsb509SMS8GzxEj/iUdqQtYn
         YYStgQMRaoiOcIoamJz4e9VuwmyfwLu9DlZMdzoMDz960w6QGeGJqpnoaRAEfLYoTimd
         Si+mvDTjHRTv8HNjTxnjP47XyWqFSyEOrKZ9Jr0F1JumVFaL6KQ9TSl791v8Q11GIX93
         rTm9V76qKUGYCYQVPRG6a4Jww8Y9aZ2RJ961G6iRCtD7By863Ssi5QYjZBqbOcV5aWsY
         0r3yBykJIXCjUWLAKSsgFU6yZcZuTd1bYGsupknwF90zKeyq78f2F1JgSVJDkgHKYQ2H
         049Q==
X-Gm-Message-State: AOAM533cnnOCqEDO1x0AJXdZo9hRnqRoAMlni/RRbQxvER+t/PmMExGG
        x3HTmE/AQG5gk0ojJpWZFtxDs/h7nimf0GCafj6rQxKkjummArSijuddpaOoUXhMSZKRb69HpY9
        FDKaGn+ZZd8qV
X-Received: by 2002:a05:6000:10cd:: with SMTP id b13mr20330416wrx.163.1612796568345;
        Mon, 08 Feb 2021 07:02:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyySlePztVVF1Am3MW8XyhQbHmBma0CvWfWUPkM8IDA0TcrwwLvx9aCTZ/dl5C5NdCEDDhWcQ==
X-Received: by 2002:a05:6000:10cd:: with SMTP id b13mr20330393wrx.163.1612796568118;
        Mon, 08 Feb 2021 07:02:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m24sm20924095wmi.24.2021.02.08.07.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:02:46 -0800 (PST)
Subject: Re: [PATCH 1/5] KVM: Make the maximum number of user memslots a
 per-VM thing
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
 <20210127175731.2020089-2-vkuznets@redhat.com>
 <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
 <877dnx30vv.fsf@vitty.brq.redhat.com>
 <5b6ac6b4-3cc8-2dc3-cd8c-a4e322379409@oracle.com>
 <34f76035-8749-e06b-2fb0-f30e295f6425@redhat.com>
 <YBL05tbdt9qupGDZ@google.com>
 <538aec50-b448-fbd8-7c65-2f5a50d3874d@redhat.com>
 <87a6seod4c.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c2d797f-0238-b458-d782-4ece74de1168@redhat.com>
Date:   Mon, 8 Feb 2021 16:02:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87a6seod4c.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/21 15:20, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 28/01/21 18:31, Sean Christopherson wrote:
>>>
>>>> For now I applied patches 1-2-5.
>>> Why keep patch 1?  Simply raising the limit in patch 2 shouldn't require per-VM
>>> tracking.
>>
>> Well, right you are.
>>
> 
> ... so are we going to raise it after all? I don't see anything in
> kvm/queue so just wanted to double-check.

Added back, thanks.

Paolo

