Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1326630DB8E
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 14:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhBCNnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 08:43:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231910AbhBCNmj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 08:42:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612359668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msAcTyPpH0uhCVhlJSk7w3lzIdisxEsipIij/eqjQsw=;
        b=D7bAo1A1hs91LgcWk8eA014fS2TyxkAr3qXK+Kt9tfL0PtSe5pj2Y08/ISXBW+jA6yipOO
        V64lBcdO5HGWttOyv8B68Ff/7HG/SDclSJbXsjnOQ+8HZPbHvb2P67nEbMvi7o9s7g6xV9
        kf9YlmEK/E3YU+TOr16ANRI05MysO4Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-x3DJ7k6LNjeJzy9zSXiJKQ-1; Wed, 03 Feb 2021 08:41:06 -0500
X-MC-Unique: x3DJ7k6LNjeJzy9zSXiJKQ-1
Received: by mail-ed1-f72.google.com with SMTP id g6so3738019edy.9
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 05:41:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=msAcTyPpH0uhCVhlJSk7w3lzIdisxEsipIij/eqjQsw=;
        b=K+N8C0fcFoadLS7FDwnVG/bNHRg6NQOkNdgWcEqHz7LwLENKs7wPY5QtY2T53xyN7A
         UtHROX0s7QK5F1CRZk5QcSw5qReAfEOMtQOKZ6PvTUPNyI1N3vGRALcOYJpHZ30jpi7p
         Hbqv2Xa2FgcKitjuXOYZHCAtT8gPJOlh67zAajJS/vrWLZRlrU4ILC7mvY1pAdUaIUKq
         JtWI1AQGhsx6T1YtjQgn3N5FEr1VOEWvhGz7gjKj0XN5SvQjd+jso2aoBRPbj2dM1aYg
         DXkcccMteIU2fnwgQUhUiIDtI0gODJH+VLUg7SguooiQZ319atslQ+9RvSUPgJMqhzC/
         1Jug==
X-Gm-Message-State: AOAM533Emb8tOkZFtFLaUj1LYiD0lhpevsVw8uCGz3K/6fjtuxNhQyvd
        7GiMTgF8d+xI6r5GAYsNUm3QFA4K198ZLM42iMPNc8lInIALTEP3SYmQj/CJKhdsXLpAjxMlMzT
        I6RqZua65v/JZ
X-Received: by 2002:aa7:dbd4:: with SMTP id v20mr3099888edt.330.1612359664819;
        Wed, 03 Feb 2021 05:41:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5RqYAPRRgfzLBlQj3QtEFUTTMAWVBk2kNfGn0CfoyXUMV2LaPkgLSfawvzDEpBA6U8agzMA==
X-Received: by 2002:aa7:dbd4:: with SMTP id v20mr3099857edt.330.1612359664645;
        Wed, 03 Feb 2021 05:41:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s15sm1010923ejy.68.2021.02.03.05.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 05:41:03 -0800 (PST)
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
 <4d748e0fd50bac68ece6952129aed319502b6853.1612140117.git.maciej.szmigiero@oracle.com>
 <YBisBkSYPoaOM42F@google.com>
 <9e6ca093-35c3-7cca-443b-9f635df4891d@maciej.szmigiero.name>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] KVM: Scalable memslots implementation
Message-ID: <4bdcb44c-c35d-45b2-c0c1-e857e0fd383e@redhat.com>
Date:   Wed, 3 Feb 2021 14:41:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9e6ca093-35c3-7cca-443b-9f635df4891d@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 23:42, Maciej S. Szmigiero wrote:
>> I'm not opposed to using more sophisticated storage for the gfn 
>> lookups, but only if there's a good reason for doing so.  IMO, the
>> rbtree isn't simpler, just different.

And it also has worse cache utilization than an array, due to memory 
footprint (as you point out below) but also pointer chasing.

>> Memslot modifications are
>> unlikely to be a hot path (and if it is, x86's "zap everything"
>> implementation is a far bigger problem), and it's hard to beat the
>> memory footprint of a raw array.  That doesn't leave much 
>> motivation for such a big change to some of KVM's scariest (for me)
>> code.
>> 
> 
> Improvements can be done step-by-step, 
> kvm_mmu_invalidate_zap_pages_in_memslot() can be rewritten, too in
> the future, if necessary. After all, complains are that this change
> alone is too big.
> 
> I think that if you look not at the patch itself but at the
> resulting code the new implementation looks rather straightforward,
> there are comments at every step in kvm_set_memslot() to explain
> exactly what is being done. Not only it already scales well, but it
> is also flexible to accommodate further improvements or even new
> operations.
> 
> The new implementation also uses standard kernel {rb,interval}-tree
> and hash table implementation as its basic data structures, so it 
> automatically benefits from any generic improvements to these.
> 
> All for the low price of just 174 net lines of code added.

I think the best thing to do here is to provide a patch series that 
splits the individual changes so that they can be reviewed and their 
separate merits evaluated.

Another thing that I dislike about KVM_SET_USER_MEMORY_REGION is that 
IMO userspace should provide all memslots at once, for an atomic switch 
of the whole memory array.  (Or at least I would like to see the code; 
it might be a bit tricky because you'll need code to compute the 
difference between the old and new arrays and invoke 
kvm_arch_prepare/commit_memory_region).  I'm not sure how that would 
interact with the active/inactive pair that you introduce here.

Paolo

