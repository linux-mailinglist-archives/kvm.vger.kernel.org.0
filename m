Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077D24BC6D3
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 08:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbiBSHzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 02:55:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiBSHzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 02:55:08 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89741BB702;
        Fri, 18 Feb 2022 23:54:49 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f17so19298259edd.2;
        Fri, 18 Feb 2022 23:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/sujtErZJ+cZX92Q6Cv+q6DNsfRpWcUhpaeli1GT1M8=;
        b=XizbP9FFeZiEUCd+pENXmC1zGDUmV8nKSM2EcMx5av5DqqycUUKnCmj5xljJoeyK/s
         brw3WtwZPhQrK0iv+eguHizfAWdActwiF9aO3Ri9JpnQYcy35GEE9QKFcd5p0WHH443Y
         6iPnjSyfXo1BpeLjqfU9UEbN8QPNrX3ybQaUNWqp6lfKmQO3g9oyLaJ/tU0uV5crrfHK
         EjGshIKw1HY9Q4VRLm7Motgznzq94ovDRWwb/08ZnLlLYWfjSwnXkl+Wt6WWmb4WC+54
         eEohPkC2XRtpfOUDHkZaMG141TmSfd7F8VRV9ZzQMJAGybOKNT1rMdo7qYHoqmu/5i7B
         tiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/sujtErZJ+cZX92Q6Cv+q6DNsfRpWcUhpaeli1GT1M8=;
        b=bTR0mh7oTncqzkpOsGwhnTWKxKxqKwbgZQYhmmOlbB6pzwuYGHh8/oN4GAx9SXREaK
         QNtkjie77dBK9QaeEUeq0gj1Ioevcv0eClMy2YSxlTVvN0A/Ej49q0MVEUw5+MQiz42o
         /O/YxLg8qIuVgScStpD1LvdnZaD09Ygkgr4m4BuHnLIJ+NqajvpOj7lw2UZfoQA0CnkX
         Ix/Qj46AheBklYT6JST/PSGCCgfwsb94eeZ6cj5i5/B3ac4NgYZ++0dYSbr4CWdmh/hf
         PMl8l8OGAdW4uc3jcYAQfbKD/ZP5BjrMSiaCfJxvY/TBi+XCQWTwsgGh9ddLpN/OU4gu
         Gf1A==
X-Gm-Message-State: AOAM530eEFObgEDkBXdZNNatooKslxQl/8OMBPLjhUh8KbpxHUtl2QBb
        HMJqjHXawCPugL4I8dXgJJXXgzCN8eI=
X-Google-Smtp-Source: ABdhPJy2dNIvR/lTqY5XZ8i7tbwia4QaxTjep6vTEvb0LVr8pL9qhNFo8l0nH5fdILFZBwyfRxPHoA==
X-Received: by 2002:a05:6402:34c5:b0:411:f082:d69 with SMTP id w5-20020a05640234c500b00411f0820d69mr11794036edc.65.1645257288133;
        Fri, 18 Feb 2022 23:54:48 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id eo7sm5245812edb.97.2022.02.18.23.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 23:54:47 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7741eeb1-183c-b465-e0f1-852b47a98780@redhat.com>
Date:   Sat, 19 Feb 2022 08:54:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 16/18] KVM: x86: introduce KVM_REQ_MMU_UPDATE_ROOT
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-17-pbonzini@redhat.com> <YhATewkkO/l4P9UN@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YhATewkkO/l4P9UN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 22:45, Sean Christopherson wrote:
> On Thu, Feb 17, 2022, Paolo Bonzini wrote:
>> Whenever KVM knows the page role flags have changed, it needs to drop
>> the current MMU root and possibly load one from the prev_roots cache.
>> Currently it is papering over some overly simplistic code by just
>> dropping _all_ roots, so that the root will be reloaded by
>> kvm_mmu_reload, but this has bad performance for the TDP MMU
>> (which drops the whole of the page tables when freeing a root,
>> without the performance safety net of a hash table).
>>
>> To do this, KVM needs to do a more kvm_mmu_update_root call from
>> kvm_mmu_reset_context.  Introduce a new request bit so that the call
>> can be delayed until after a possible KVM_REQ_MMU_RELOAD, which would
>> kill all hopes of finding a cached PGD.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
> 
> Please no.
> 
> I really, really do not want to add yet another deferred-load in the nested
> virtualization paths.

This is not a deferred load, is it?  It's only kvm_mmu_new_pgd that is 
deferred, but the PDPTR load is not.

I think I should first merge patches 1-13, then revisit the root_role 
series (which only depends on the fast_pgd_switch and caching changes), 
and then finally get back to this final part.  The reason is that 
root_role is what enables the stale-root check that you wanted; and it's 
easier to think about loading the guest PGD post-kvm_init_mmu if I can 
show you the direction I'd like to have in general, and not leave things 
half-done.

(Patch 17 is also independent and perhaps fixing a case of premature 
optimization, so I'm inclined to merge it as well).

> As Jim pointed out[1], KVM_REQ_GET_NESTED_STATE_PAGES should
> never have been merged. And on that point, I've no idea how this new request will
> interact with KVM_REQ_GET_NESTED_STATE_PAGE.  It may be a complete non-issue, but
> I'd honestly rather not have to spend the brain power.

Fair enough on the interaction, but I still think 
KVM_REQ_GET_NESTED_STATE_PAGES is a good idea.  I don't think KVM should 
access guest memory outside KVM_RUN, though there may be cases (possibly 
some PV MSRs, if I had to guess) where it does.

> And I still do not like the approach of converting kvm_mmu_reset_context() wholesale
> to not doing kvm_mmu_unload().  There are currently eight kvm_mmu_reset_context() calls:
> 
>    1.   nested_vmx_restore_host_state() - Only for a missed VM-Entry => VM-Fail
>         consistency check, not at all a performance concern.
> 
>    2.   kvm_mmu_after_set_cpuid() - Still needs to unload.  Not a perf concern.
> 
>    3.   kvm_vcpu_reset() - Relevant only to INIT.  Not a perf concern, but could be
>         converted manually to a different path without too much fuss.
> 
>    4+5. enter_smm() / kvm_smm_changed() - IMO, not a perf concern, but again could
>         be converted manually if anyone cares.
> 
>    6.   set_efer() - Silly corner case that basically requires host userspace abuse
>         of KVM APIs.  Not a perf concern.
> 
>    7+8. kvm_post_set_cr0/4() - These are the ones we really care about, and they
>         can be handled quite trivially, and can even share much of the logic with
>         kvm_set_cr3().
> 
> I strongly prefer that we take a more conservative approach and fix 7+8, and then
> tackle 1, 3, and 4+5 separately if someone cares enough about those flows to avoid
> dropping roots.

The thing is, I want to get rid of kvm_mmu_reset_context() altogether. 
I dislike the fact that it kills the roots but still keeps them in the 
hash table, thus relying on separate syncing to avoid future bugs.  It's 
very unintuitive what is "reset" and what isn't.

> Regarding KVM_REQ_MMU_RELOAD, that mess mostly goes away with my series to replace
> that with KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.  Obsolete TDP MMU roots will never get
> a cache hit because the obsolete root will have an "invalid" role.  And if we care
> about optimizing this with respect to a memslot (highly unlikely), then we could
> add an MMU generation check in the cache lookup.  I was planning on posting that
> series as soon as this one is queued, but I'm more than happy to speculatively send
> a refreshed version that applies on top of this series.

Yes, please send a version on top of patches 1-13.  That can be reviewed 
and committed in parallel with the root_role changes.

Paolo

> [1] https://lore.kernel.org/all/CALMp9eT2cP7kdptoP3=acJX+5_Wg6MXNwoDh42pfb21-wdXvJg@mail.gmail.com
> [2] https://lore.kernel.org/all/20211209060552.2956723-1-seanjc@google.com

