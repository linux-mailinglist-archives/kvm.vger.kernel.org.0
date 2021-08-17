Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1C13EF077
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 18:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhHQQvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 12:51:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230369AbhHQQvh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 12:51:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629219064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LkpWN9F0AvL53nNW2SYNMY71oeSLSSYwER2BZGJYmaA=;
        b=PHJd9UlzQY8AtCQR6dwWXBwMIMl/YVrgSlK1HPmmFUm4zg57DtHBUHNl3AldDg/yQlSxs7
        656PAUZuGhKSnqOW7C35TfV9LfvNSDZajp6oz+AmDA0BgdOcTvvIQ5ej6jDc3C+E4pdXSo
        UK8iD7NNiiTh2vebRcCmxCBvQhQifBQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-M1LZ8cVmO_SSeGfb9L68bA-1; Tue, 17 Aug 2021 12:51:02 -0400
X-MC-Unique: M1LZ8cVmO_SSeGfb9L68bA-1
Received: by mail-ed1-f70.google.com with SMTP id e3-20020a50ec830000b02903be5be2fc73so10799659edr.16
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 09:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LkpWN9F0AvL53nNW2SYNMY71oeSLSSYwER2BZGJYmaA=;
        b=C82chv0FQVNv49pnKnaEOGPiy2SJ39o7nT+ulEn3KEdQBEnDOWxK5zORq2I4+bBzv5
         ZuROtuKPetDN8wzSKf6sLajLL0EHWnTz04H7GT9Y+yuzYNprtOzUbVrw4xHlQsr4YriO
         gIk00w9gGnBxN1Bf8FGRkTxJu6jTlsIBVStmHlO0lyj50wRPCF+4V7ZkaqCWOF3JK5A5
         lzROiEbEIDs79qwT51hOIR/76jnJnFwGiUc/F3BB4RlhT/YfBiupxE4yVtXBaMNmgY9q
         V8tluPA3OjJXlyy7kZ4t10TApvmdJTB+VNxWQGgOCc9MdMIViAW9f0eQu9e3J5mn14vG
         /rbQ==
X-Gm-Message-State: AOAM531hu6J9/YQngw9FQRLwkRtx0aKKACVULeqD043U33o4zZ5QBy4X
        7+xGctN7f6OpegYigh9BnhaQBWkysMwqSeJN/kxdj6XP4CS7Qix02KAiWi0rqw9T8/pfovDgkvE
        x7cx6WUM1+Kju
X-Received: by 2002:a05:6402:22d0:: with SMTP id dm16mr4942435edb.107.1629219061760;
        Tue, 17 Aug 2021 09:51:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbrhrDWaApwthxzcul7VdxqoZMpoxk5ZuM/WME+8K6gcS1hIJGG5l6Xu8lsasjhPZQ50NxjA==
X-Received: by 2002:a05:6402:22d0:: with SMTP id dm16mr4942419edb.107.1629219061588;
        Tue, 17 Aug 2021 09:51:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n16sm1289107edv.73.2021.08.17.09.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 09:51:00 -0700 (PDT)
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
References: <332b6896f595282ea3d261095612fd31ce4cf14f.camel@redhat.com>
 <1ff7a205-283d-d2b3-d130-e40066f59df0@redhat.com>
 <efd07fdb5646e6a983d234a0e0bed8db6da4a890.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: RFC: Proposal to create a new version of the SVM nested state
 migration blob
Message-ID: <59a55bd1-6254-311c-b087-ce54f6a9e1e8@redhat.com>
Date:   Tue, 17 Aug 2021 18:50:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <efd07fdb5646e6a983d234a0e0bed8db6da4a890.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/21 18:40, Maxim Levitsky wrote:
> I proposed that on nested entry we leave the processor values in vmcb01,
> as is, and backup the guest visible values in say 'svm->nested.hsave.cr*'
> or something like that.
> Later on nested VM exit we restore vcpu.arch.cr* values from 'svm->nested.hsave.cr*'
> and leave the vmcb01 values alone.
>   
> That isn't strictly related to nested migration state but it seemed
> to me that it would be also nice to have both guest visible
> and cpu visible values of L1 save state in migration state
> as well while we are at redefining it.

But the CPU visible values for L1 are useless, aren't they?  They are 
computed on another system.  So you have to compute them again on the 
destination.

So this idea, which is strictly speaking an optimization of vmexit, is 
unrelated from migration and I would leave it aside.

>> So your proposal would basically be to:
>>
>> * do the equivalent of sync_vmcs02_to_vmcs12+sync_vmcs02_to_vmcs12_rare
>> on KVM_GET_NESTED_STATE
>>
>> * discard the current state on KVM_SET_NESTED_STATE.
>
> I did indeed overlook the fact that vmcb12 save area is not up to date,
> in fact I probably won't even want to read it from the guest memory
> at the KVM_GET_NESTED_STATE time. But it can be constructed from the
> KVM's guest visible CR* values, and values in the VMCB02, roughly like
> how sync_vmcs02_to_vmcs12, or how nested_svm_vmexit does it.

Right.

> The core of my proposal is that while it indeed makes the retrieval of the
> nested state a bit more complicated, but it makes restore of the nested state
> much simpler, since it can be treated as if we are just doing a nested entry,
> eliminating the various special cases we have to have in nested state load on SVM.

This is true.

> Security wise, a bug during retrieval, isn't as bad as a bug during loading of the
> state, so it makes sense to make the load of the state share as much code
> with normal nested entry.
> 
> That means that the whole VMCB12 image can be checked as a whole and loaded
> replacing most of the existing cpu state, in the same manner to regular
> nested entry.
>   
> This also makes nested state load less dependant on its ordering vs setting of
> the other cpu state.
>
> So what do you think? Is it worth it for me to write a RFC patch series for this?

I have a slightly different idea.  Do you think it would make sense to 
use the current processor state to build the VMCB12?  Such a prototype 
would show what KVM_SET_NESTED_STATE would look like with your new blob 
format.  We could use that to see if it worth proceeding further, with 
three possible answer:

1) the new KVM_SET_NESTED_STATE remains complex, so we scrap the idea

2) the new KVM_SET_NESTED_STATE is nice, and we decide it's already good 
enough

3) the new KVM_SET_NESTED_STATE is nice, but there is enough ugliness 
left that the new format seems worthwhile

Paolo

