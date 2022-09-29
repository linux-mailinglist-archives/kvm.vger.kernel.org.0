Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9A95EF8B4
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbiI2P3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbiI2P3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:29:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FF515D664
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664465339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dovtu1XlKkEDvNR0VywsQZbH64mld5MIvsTiAroU6wc=;
        b=UZBWlopTfSIH+ol+S4vy8YZ0zCStjR5THkafhjtrV/TRIu0Rg6+dXDsBVefHpzzsJo/lxC
        hxk4asUy2uwO7378oRGw9UaRTJRO4Sj08YckoV6eTYpqwf988si3c2oy52hJ8ElodMgZ0/
        iJDv7Ic5J1uVHMZguWCYVV2cOYCbFAU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-116-MfaPIqMaMPS6U0Q-yLWwrw-1; Thu, 29 Sep 2022 11:28:58 -0400
X-MC-Unique: MfaPIqMaMPS6U0Q-yLWwrw-1
Received: by mail-ej1-f72.google.com with SMTP id qk10-20020a1709077f8a00b0078297c303afso904350ejc.20
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dovtu1XlKkEDvNR0VywsQZbH64mld5MIvsTiAroU6wc=;
        b=GKwCmpMvyLojdU3V+fcZyEJ0eI/b131Clh7Y9qm1wYERZ0oA65CSov92Ucg2HH2lBT
         ns5ITLYh2qCo7eRkx+Se5uA5bGwecf+goD4z0m5ZrIIUSgpxbaQ1KA8xE35BN4OJ90P1
         lBLUdPW80W2bjDSEm/TzG1mn4I38cYBqg1WzgHIWCsyvIOYsrPSEKp+zGq/cjoQSUxf0
         s4S0l1O4ZscT/up811OhdRGnDHU+kW72J/QyR5F8hon40ASNeMu1/P+u4apLWG8dmC6w
         NNmGuM5cAjuIA5wYoSGE8cBwxG4lIHJjbdm9CimY3eDtv63jaGWYbdNiTKf34yBdffUM
         wfSA==
X-Gm-Message-State: ACrzQf0F5nPgVjjvqQoBTZSaA3zP/bn8x8pVDKOFLibAu3UqcPF+0Ssm
        qiRuFIEnBn8KSDJ1rr+RZSOCQVAy9JIzTMrCbS2TW+iH7cFo5SvweChgONF9ob8jhDZwqVw3Ale
        OkzwhuLrM4rDn
X-Received: by 2002:a17:907:d91:b0:784:107a:6aca with SMTP id go17-20020a1709070d9100b00784107a6acamr3121078ejc.761.1664465337350;
        Thu, 29 Sep 2022 08:28:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4iWYv81N04+0LcVcXAqmQXSTMMkIagAop7HXTUqkUeD5sjhj6XrYsnsbS5pmwGrJ/GufTsyg==
X-Received: by 2002:a17:907:d91:b0:784:107a:6aca with SMTP id go17-20020a1709070d9100b00784107a6acamr3121057ejc.761.1664465337055;
        Thu, 29 Sep 2022 08:28:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id r19-20020a05640251d300b0044f21c69608sm5836698edd.10.2022.09.29.08.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 08:28:56 -0700 (PDT)
Message-ID: <d8d2bd39-cbb3-010d-266a-4e967765a382@redhat.com>
Date:   Thu, 29 Sep 2022 17:28:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
 <YzRvMZDoukMbeaxR@google.com>
 <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
 <YzSxhHzgNKHL3Cvm@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
In-Reply-To: <YzSxhHzgNKHL3Cvm@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/28/22 22:41, Sean Christopherson wrote:
> On Wed, Sep 28, 2022, Paolo Bonzini wrote:
>> On 9/28/22 17:58, Sean Christopherson wrote:
>>> I don't disagree that the memslots API is lacking, but IMO that is somewhat
>>> orthogonal to fixing KVM x86's "code fetch to MMIO" mess.  Such a massive new API
>>> should be viewed and prioritized as a new feature, not as a bug fix, e.g. I'd
>>> like to have the luxury of being able to explore ideas beyond "let userspace
>>> batch memslot updates", and I really don't want to feel pressured to get this
>>> code reviewed and merge.
>>
>> I absolutely agree that this is not a bugfix.  Most new features for KVM can
>> be seen as bug fixes if you squint hard enough, but they're still features.
> 
> I guess I'm complaining that there isn't sufficient justification for this new
> feature.  The cover letter provides a bug that would be fixed by having batched
> updates, but as above, that's really due to deficiencies in a different KVM ABI.

I disagree.  Failure to fetch should be fixed but is otherwise a red 
herring.  It's the whole memslot API (including dirty logging) that is a 
mess.

If you think we should overhaul it even more than just providing atomic 
batched updates, that's fine.  But still, the impossibility to perform 
atomic updates in batches *is* a suboptimal part of the KVM API.

>    - Why can't this be solved in userspace?

I don't think *can't* is the right word.  If the metric of choice was 
"what can be solved in userspace", we'd all be using microkernels.  The 
question is why userspace would be a better place to solve it.

The only reason to do it in userspace would be if failure to fetch is 
something that is interesting to userspace, other than between two 
KVM_SET_USER_MEMORY_REGION.  Unless you provide an API to pass failures 
to fetch down to userspace, the locking in userspace is going to be 
inferior, because it would have to be unconditional.  This means worse 
performance and more complication, not to mention having to do it N 
times instead of 1 for N implementations.

Not forcing userspace to do "tricks" is in my opinion a strong part of 
deciding whether an API belongs in KVM.

>    - What operations does userspace truly need?  E.g. if the only use case is to
>      split/truncate/hole punch an existing memslot, can KVM instead provide a
>      memslot flag and exit reason that allows kicking vCPUs to userspace if the
>      memslot is accessed?  E.g. KVM_MEM_DISABLED that acts like an invalid memslot,
>      but KVM exists with a dedicated exit reason instead of generating MMIO semantics.

The main cases are:

- for the boot case, splitting and merging existing memslots.  QEMU 
likes to merge adjacent memory regions into a single memslot, so if 
something goes from read-write to read-only it has to be split and vice 
versa.  I guess a "don't merge this memory region" flag would be the 
less hideous way to solve it in userspace.

- however, there is also the case of resizing an existing memslot which 
is what David would like to have for virtio-mem.  This is not really 
fixable because part of the appeal of virtio-mem is to have a single 
huge memslot instead of many smaller ones, in order to reduce the 
granularity of add/remove (David, correct me if I'm wrong).

(The latter _would_ be needed by other VMMs).

> If updates only need to be "atomic" for an address space, does the API allowing
> mixing non-SMM and SMM memslots?

I agree that the address space should be moved out of the single entries 
and into the header if we follow through with this approach.

> The update needs to be "atomic", i.e. vCPUs
> must never see an invalid/deleted memslot, but if the memslot is writable,
> how does KVM prevent some writes from hitting the old HVA and some from hitting
> the new HVA without a quiescent period?

(Heh, and I forgot likewise that non-x86 does not retry on 
KVM_MEMSLOT_INVALID.  Yes, that would be treated as a bug on other 
architectures).

>> Wholesale replacement was my first idea when I looked at the issue, I think
>> at the end of 2020.  I never got to a full implementation, but my impression
>> was that allocating/deallocating dirty bitmaps, rmaps etc. would make it any
>> easier than arbitrary batch updates.
> 
> It's not obvious to me that the memslot metadata is going to be easy to handle
> regardless of what we do.  E.g. I'm pretty sure that batching updates will "corrupt"
> the dirty bitmap if a hole is punched in a memslot that's being dirty logged.

Indeed; I would have thought that it is clear with the batch updates API 
(which requires the update to be split into delete and insert), but 
apparently it's not and it's by no means optimal.

Paolo

