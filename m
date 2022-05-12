Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C87525220
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 18:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356282AbiELQJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 12:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356270AbiELQJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 12:09:53 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E55826607A;
        Thu, 12 May 2022 09:09:52 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i27so11171870ejd.9;
        Thu, 12 May 2022 09:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=628amGtzZZ673GbWTErwtKfiPlcq9yyKij/Inqe5wk0=;
        b=RKiCjnRaZBQShd3Niek0DyfDEKEgcFf3jJzjHtPkDB0r8xseI8pjSeZkzqbmGEwVMf
         YqWTLDEz2CsHA7uRcWzTU6qtJW2XIa2rloxNMk7cgbITxXXtmIq98c89aCDwwxhSecgs
         6T7jki6gjtk9ypkqzPd9mB5UZhxYTyP0QtnPeU9WSUVrXsUybPqwaOkPkztQgkWnG117
         AhGDRo/qq/9lOFCtCMstwLj4tBS+tbalLyOurUxovNLI/6XfV3FwiuqQ8wFs3fUAMl2z
         hZX0dWVCNJA7FEcMDqFriC+kLSkegKf0j+26AXU3TFBpznAVoAg4Kaw3IWpTIZzLp5C4
         Bxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=628amGtzZZ673GbWTErwtKfiPlcq9yyKij/Inqe5wk0=;
        b=4UinTGWdFA3IpdxArz+4cxhhtSSFs/jfuIUCMDoKfH4gE4wDn63bwNA14kYDlVi9M/
         1LJn8C22c1QUixRJie/RbcN9DI3YO27eiet20jlrzwSyikDYFeEbM7Z9OXU7u1AgSEFR
         8CVQrYFhFABVbhNur6rwfEWqI+xurSfFNx+BLc+bCLQnZJxBhtM2xDXrY4mk4WqqIAQ7
         mXpE7WrfElo3G0cRpu3gLqeLjnxd5w3BSLWB/UuhFMInHgyVmIEjgH7bOp05hMMnrNzo
         3hTd56DNIisOVqZaqVBMBQ9vIkjsvpj9nZ8FtcuvUlCsWBTW+XqmwEbnY1y/pXotruYP
         yjng==
X-Gm-Message-State: AOAM532DLe3X1QXDGllGfk7KnoHMsFCaV6oGeYxME3arp6se7RoOpiPk
        ZcxUGd6rwxUZOGscqA1KaO7AIkJxfWKWlw==
X-Google-Smtp-Source: ABdhPJyNg2mDnatpH8WBbXeuhM4mQgsK85nD6TPzYD3eku+ep0sFqg/7n72T+/tpnIdLGQpjDw3UvA==
X-Received: by 2002:a17:907:3f1d:b0:6f4:ce49:52ea with SMTP id hq29-20020a1709073f1d00b006f4ce4952eamr561390ejc.47.1652371790841;
        Thu, 12 May 2022 09:09:50 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u23-20020a509517000000b0042617ba63acsm2743250eda.54.2022.05.12.09.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 09:09:50 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8c92f44f-3e56-5a5d-76c2-b50b8fe58b3d@redhat.com>
Date:   Thu, 12 May 2022 18:09:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 16/22] KVM: x86/mmu: remove redundant bits from extended
 role
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220414074000.31438-1-pbonzini@redhat.com>
 <20220414074000.31438-17-pbonzini@redhat.com> <Ynmv2X5eLz2OQDMB@google.com>
 <e1fc28b6-996f-a436-2664-d6b044d07c82@redhat.com>
 <Yn0XNnqnbstGSiEl@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yn0XNnqnbstGSiEl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/12/22 16:18, Sean Christopherson wrote:
> On Thu, May 12, 2022, Paolo Bonzini wrote:
>> On 5/10/22 02:20, Sean Christopherson wrote:
>>> --
>>> From: Sean Christopherson<seanjc@google.com>
>>> Date: Mon, 9 May 2022 17:13:39 -0700
>>> Subject: [PATCH] KVM: x86/mmu: Return true from is_cr4_pae() iff CR0.PG is set
>>>
>>> Condition is_cr4_pae() on is_cr0_pg() in addition to the !4-byte gPTE
>>> check.  From the MMU's perspective, PAE is disabling if paging is
>>> disabled.  The current code works because all callers check is_cr0_pg()
>>> before invoking is_cr4_pae(), but relying on callers to maintain that
>>> behavior is unnecessarily risky.
>>>
>>> Fixes: faf729621c96 ("KVM: x86/mmu: remove redundant bits from extended role")
>>> Signed-off-by: Sean Christopherson<seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index 909372762363..d1c20170a553 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -240,7 +240,7 @@ static inline bool is_cr0_pg(struct kvm_mmu *mmu)
>>>
>>>    static inline bool is_cr4_pae(struct kvm_mmu *mmu)
>>>    {
>>> -        return !mmu->cpu_role.base.has_4_byte_gpte;
>>> +        return is_cr0_pg(mmu) && !mmu->cpu_role.base.has_4_byte_gpte;
>>>    }
>>>
>>>    static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
>>
>> Hmm, thinking more about it this is not needed for two kind of opposite
>> reasons:
>>
>> * if is_cr4_pae() really were to represent the raw CR4.PAE value, this is
>> incorrect and it should be up to the callers to check is_cr0_pg()
>>
>> * if is_cr4_pae() instead represents 8-byte page table entries, then it does
>> even before this patch, because of the following logic in
>> kvm_calc_cpu_role():
>>
>>          if (!____is_cr0_pg(regs)) {
>>                  role.base.direct = 1;
>>                  return role;
>>          }
>> 	...
>>          role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
>>
>>
>> So whatever meaning we give to is_cr4_pae(), there is no need for the
>> adjustment.
> 
> I disagree, because is_cr4_pae() doesn't represent either of those things.  It
> represents the effective (not raw) CR4.PAE from the MMU's perspective.

Doh, you're right that has_4_byte_gpte is actually 0 if CR0.PG=0. 
Swapping stuff back is hard.

What do you think about a WARN_ON_ONCE(!is_cr0_pg(mmu))?

Paolo
