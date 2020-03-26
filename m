Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4CC1947C5
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 20:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgCZTp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 15:45:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:23617 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbgCZTp4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 15:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585251954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j/QkZIwZAYRuVJgK41SETHWfHlCLzylTanLn5vMvqiQ=;
        b=P8Wwqk3wUhukJCt1HQEikimLeW9nCk1uT8Vqvqr9ZjgmAIIvTwrKz+0dTvVxHRMQBq2qCp
        h2epB4smHqkGPMgmVSGjXGclPB+P0swrcXgBJv/URpclV48ulAhKmvAg+jTWGBaC8Mp8SF
        cjOgZr2Nl6jM5eNhp6PztaOpzCOLsf4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-NLFSVKP_O8a9wwDRATKFIw-1; Thu, 26 Mar 2020 15:45:53 -0400
X-MC-Unique: NLFSVKP_O8a9wwDRATKFIw-1
Received: by mail-wm1-f69.google.com with SMTP id v184so3021889wme.7
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 12:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j/QkZIwZAYRuVJgK41SETHWfHlCLzylTanLn5vMvqiQ=;
        b=nA+weYlknNfp90sClBW7zhiNSFJC52lkFv9DCnMqBCBVu6Ghj2qLbGzLNiYK4DH30O
         14SgZKpEOYYTLRLJmvK3ObMYMv5qW8kOEsnwZt2+dMq8Ss2HJFI41j92hFlBC7iV2hs4
         rHHD498/Vl4/bshs+C1nWpBEMSxJl9AFnCV4/ujofmKGGs/8Vj3xQMcVxUHgs4Ws9cZY
         n0L3jlh9xBaH0Y5tsvL0W2PhEN2aNQpffq3XvPZvxJIc/1BaM53IQpivJ+lRnIyvnva3
         00xT2Zd+MbnF7bhzvOyvOI3ayXqDL56FLcAAkNTvMPJ90K2jEsCKdJCivuN7L08y0Yot
         i8iw==
X-Gm-Message-State: ANhLgQ1lXQMm0WYMFBklLxHehA/FxE6CXDEhqrAVgJDe5z4qllvs+qam
        jQQemUQuF2Ba9vDq4DRSyWnIYkRpGrs4daljC0FWgGUFfK0VUbqkk7ROw8Q9OUQiIoARsPA8gh2
        etDehH3zSBwvH
X-Received: by 2002:a7b:c74a:: with SMTP id w10mr1556649wmk.148.1585251948905;
        Thu, 26 Mar 2020 12:45:48 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtkzjJVQR0L2kBAgXHawkwn6IjmfgdffWupvHBQgJ6axyAXNIWiCOxX44A6i4JirFtb4neiag==
X-Received: by 2002:a7b:c74a:: with SMTP id w10mr1556624wmk.148.1585251948653;
        Thu, 26 Mar 2020 12:45:48 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id t21sm4755144wmt.43.2020.03.26.12.45.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 12:45:47 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: x86: cleanup kvm_inject_emulated_page_fault
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200326093516.24215-1-pbonzini@redhat.com>
 <20200326093516.24215-3-pbonzini@redhat.com>
 <877dz75j4i.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d2222e81-8618-b3b0-baf3-2bda72d48ede@redhat.com>
Date:   Thu, 26 Mar 2020 20:45:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <877dz75j4i.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/20 14:41, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> To reconstruct the kvm_mmu to be used for page fault injection, we
>> can simply use fault->nested_page_fault.  This matches how
>> fault->nested_page_fault is assigned in the first place by
>> FNAME(walk_addr_generic).
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c         | 6 ------
>>  arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
>>  arch/x86/kvm/x86.c             | 7 +++----
>>  3 files changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index e26c9a583e75..6250e31ac617 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4353,12 +4353,6 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
>>  	return kvm_read_cr3(vcpu);
>>  }
>>  
>> -static void inject_page_fault(struct kvm_vcpu *vcpu,
>> -			      struct x86_exception *fault)
>> -{
>> -	vcpu->arch.mmu->inject_page_fault(vcpu, fault);
>> -}
>> -
> 
> This is already gone with Sean's "KVM: x86: Consolidate logic for
> injecting page faults to L1".
> 
> It would probably make sense to have a combined series (or a branch on
> kvm.git) to simplify testing efforts.

Yes, these three patches replace part of Sean's (the patch you mention
and the next one, "KVM: x86: Sync SPTEs when injecting page/EPT fault
into L1").

I pushed the result to a branch named kvm-tlb-cleanup on kvm.git.

Paolo

