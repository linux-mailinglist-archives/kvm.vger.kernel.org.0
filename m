Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447983504C1
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhCaQhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 12:37:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234400AbhCaQgu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 12:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617208609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVCeiltaTGJXJYSW6dhbkobIMYPQfKpSFl3XbU9a+wA=;
        b=Z1Foasehn2XmvJG751Vlb333YRRv2hQxD96MGHmWTyGD0khQBB4hFtKKd7u8BvMNlY28HQ
        6Dah9a+l/mVY69//hjUn179zF4HzhcRzzGXLQN5s42ATAhojMOZ9UO1QBsv/+eFG34oeQ6
        +T1tKhEUDIFdZ9cW4OpQAUqSsKm3dGc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-my1ZWmClNI-DG3-S4l9dNA-1; Wed, 31 Mar 2021 12:36:47 -0400
X-MC-Unique: my1ZWmClNI-DG3-S4l9dNA-1
Received: by mail-ej1-f72.google.com with SMTP id e13so1030222ejd.21
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 09:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QVCeiltaTGJXJYSW6dhbkobIMYPQfKpSFl3XbU9a+wA=;
        b=mhSaov5Y9tW8xgDiF5u7NXCXUmBoOqMYgPIE60WB/b88AsVCKOw7mmBfQIGsR4c4Vc
         ZdeYW7EVCo1M7/T04eKifhXyRzFotC26ZRnuQg0P6dyuXWttKwT3lcY7zmrViyaqYVQM
         IS4np6n8SmNr/HIbWZqvl+Ft26vaN1EXUlZJJwpipGPJoggYsrIWC3fdWL3eAN22W5YS
         JBqmiyXc0kRp5f9IDquNyE83sYwxg/a2DYj5yA9dxg8alwfekouK3u9YZhWwhRCdgyOH
         c5cMrywdeBGP0s0CVUZciBfvjuDw8WmC+RGfE1xiKFYVrlW8omHU3r57W/KY1FO/HnBP
         2beg==
X-Gm-Message-State: AOAM533aG+VycHE/5Hhx2LWB5S6V5MqZ+RTAGBsqudUo1J0Eno1XG5j/
        eFTdVo8eHkHNeZq2JsY1nQ6ecCuPlLG3UfANHPpNldc9mZ8Bek4peVGAj3wknNyWfBVa0OUn9DY
        dQLF7yCbiNF7w
X-Received: by 2002:a17:906:2786:: with SMTP id j6mr4459310ejc.157.1617208606670;
        Wed, 31 Mar 2021 09:36:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyH0TubmRiztxbbKWWpE6U/9a4Jmz4SSbDeZziJUjL7bKl7L31NfjvonwQzH04qoJmbwktymw==
X-Received: by 2002:a17:906:2786:: with SMTP id j6mr4459281ejc.157.1617208606447;
        Wed, 31 Mar 2021 09:36:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hb19sm1500893ejb.11.2021.03.31.09.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 09:36:45 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-11-seanjc@google.com>
 <ba3f7a9c-0b59-cbeb-5d46-4236cde2c51f@redhat.com>
 <YGShRP9E49p3vcos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/18] KVM: Move x86's MMU notifier memslot walkers to
 generic code
Message-ID: <d843bbd5-d3f0-3cda-aaa5-8e0fb1d69554@redhat.com>
Date:   Wed, 31 Mar 2021 18:36:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGShRP9E49p3vcos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 18:20, Sean Christopherson wrote:
> Every call
> to .change_pte() is bookended by .invalidate_range_{start,end}(), i.e. the above
> missing kvm->mmu_notifier_seq++ is benign because kvm->mmu_notifier_count is
> guaranteed to be non-zero.

In fact ARM even relies on invalidate wrapping the change_pte handler.

         /*
          * The MMU notifiers will have unmapped a huge PMD before calling
          * ->change_pte() (which in turn calls kvm_set_spte_hva()) and
          * therefore we never need to clear out a huge PMD through this
          * calling path and a memcache is not required.
          */

> Assuming all of the above is correct, I'm very tempted to rip out .change_pte()
> entirely.

There is still the performance benefit from immediately remapping the 
page to the new destination without waiting for a fault.  Yes it's 
hypothetical but I would prefer to leave that change for later.

The fact that the count is nonzero means that you will not even have to 
complicate kvm_mmu_notifier_change_pte to handle the removal of 
mmu_notifier_seq; just add a patch before this one to WARN if it is 
zero.  (The rest of my review to patch 16 still holds).

Paolo

> It's been dead weight for 8+ years and no one has complained about
> KSM+KVM performance (I'd also be curious to know how much performance was gained
> by shaving VM-Exits).  As KVM is the only user of .change_pte(), dropping it in
> KVM would mean the entire MMU notifier could also go away.
> 

