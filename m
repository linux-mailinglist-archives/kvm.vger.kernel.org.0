Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89242192D92
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgCYP5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:57:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbgCYP5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 11:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=0Nq4yxa20BJ37D0s9zLhKVxO/JAu1Z42ScKUYri07QE=; b=Z/NtPChqiONDSQ1rBH5Zm0gRDL
        fJ27q2PwIEazs4iALNhvZqw0guyErk+s5SN9N1OTzDukEAwKlvvAGObBeZh96TXJujzhaBs2hjg6h
        UtBvh3Irht1oTEwVXwZnrF8Nm5JvyUQbG27ZzZchwXrVcx0aMtxkmVZHKls3U990Q8CEgbnPtanli
        k03nHr1rNW43oAke4lBo8U16gihxsyqTy0cbJvPq9a/Ffi+GEje+uCqYT4Bjj09y7Gm2UeaqGgBPb
        OimelX9k2iqf78qNic+/dkvBoawQ2RaKZGnYCmisjVjuwrX6ZsjQ370U1u3NOrj0LS+4v1V0fWNFF
        ADbH30MA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH8PJ-0000jp-Ru; Wed, 25 Mar 2020 15:57:29 +0000
Subject: Re: linux-next: Tree for Mar 25 (arch/x86/kvm/)
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20200325195350.7300fee9@canb.auug.org.au>
 <e9286016-66ae-9505-ea52-834527cdae27@infradead.org>
 <d9af8094-96c3-3b7f-835c-4e48d157e582@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <064720eb-2147-1b92-7a62-f89d6380f40a@infradead.org>
Date:   Wed, 25 Mar 2020 08:57:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d9af8094-96c3-3b7f-835c-4e48d157e582@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/20 8:46 AM, Paolo Bonzini wrote:
> On 25/03/20 16:30, Randy Dunlap wrote:
>> 24 (only showing one of them here) BUILD_BUG() errors in arch/x86/kvm/cpuid.h
>> function __cpuid_entry_get_reg(), for the default: case.
>>
>>
>>   CC      arch/x86/kvm/cpuid.o
>> In file included from ../include/linux/export.h:43:0,
>>                  from ../include/linux/linkage.h:7,
>>                  from ../include/linux/preempt.h:10,
>>                  from ../include/linux/hardirq.h:5,
>>                  from ../include/linux/kvm_host.h:7,
>>                  from ../arch/x86/kvm/cpuid.c:12:
>> In function ‘__cpuid_entry_get_reg’,
>>     inlined from ‘kvm_cpu_cap_mask’ at ../arch/x86/kvm/cpuid.c:272:25,
>>     inlined from ‘kvm_set_cpu_caps’ at ../arch/x86/kvm/cpuid.c:292:2:
>> ../include/linux/compiler.h:394:38: error: call to ‘__compiletime_assert_114’ declared with attribute error: BUILD_BUG failed
>>   _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>>                                       ^
>> ../include/linux/compiler.h:375:4: note: in definition of macro ‘__compiletime_assert’
>>     prefix ## suffix();    \
>>     ^~~~~~
>> ../include/linux/compiler.h:394:2: note: in expansion of macro ‘_compiletime_assert’
>>   _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>>   ^~~~~~~~~~~~~~~~~~~
>> ../include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
>>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>>                                      ^~~~~~~~~~~~~~~~~~
>> ../include/linux/build_bug.h:59:21: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
>>  #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
>>                      ^~~~~~~~~~~~~~~~
>> ../arch/x86/kvm/cpuid.h:114:3: note: in expansion of macro ‘BUILD_BUG’
>>    BUILD_BUG();
>>    ^~~~~~~~~
>>
> 
> Looks like the compiler is not smart enough to figure out the constant 
> expressions in BUILD_BUG.  I think we need to do something like this:
> 
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 23b4cd1ad986..8f711b0cdec0 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -40,6 +40,7 @@ struct cpuid_reg {
>  	int reg;
>  };
>  
> +/* Update reverse_cpuid_check as well when adding an entry.  */
>  static const struct cpuid_reg reverse_cpuid[] = {
>  	[CPUID_1_EDX]         = {         1, 0, CPUID_EDX},
>  	[CPUID_8000_0001_EDX] = {0x80000001, 0, CPUID_EDX},
> @@ -68,12 +69,21 @@ static const struct cpuid_reg reverse_cpuid[] = {
>   */
>  static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
>  {
> -	BUILD_BUG_ON(x86_leaf == CPUID_LNX_1);
> -	BUILD_BUG_ON(x86_leaf == CPUID_LNX_2);
> -	BUILD_BUG_ON(x86_leaf == CPUID_LNX_3);
> -	BUILD_BUG_ON(x86_leaf == CPUID_LNX_4);
> -	BUILD_BUG_ON(x86_leaf >= ARRAY_SIZE(reverse_cpuid));
> -	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
> +	BUILD_BUG_ON(x86_leaf != CPUID_1_EDX &&
> +	             x86_leaf != CPUID_8000_0001_EDX &&
> +	             x86_leaf != CPUID_8086_0001_EDX &&
> +	             x86_leaf != CPUID_1_ECX &&
> +	             x86_leaf != CPUID_C000_0001_EDX &&
> +	             x86_leaf != CPUID_8000_0001_ECX &&
> +	             x86_leaf != CPUID_7_0_EBX &&
> +	             x86_leaf != CPUID_D_1_EAX &&
> +	             x86_leaf != CPUID_8000_0008_EBX &&
> +	             x86_leaf != CPUID_6_EAX &&
> +	             x86_leaf != CPUID_8000_000A_EDX &&
> +	             x86_leaf != CPUID_7_ECX &&
> +	             x86_leaf != CPUID_8000_0007_EBX &&
> +	             x86_leaf != CPUID_7_EDX &&
> +	             x86_leaf != CPUID_7_1_EAX);
>  }
>  
>  /*
> 
> Randy, can you test it with your compiler?

Nope, no help.  That's the wrong location.
Need a patch for this:
>> 24 (only showing one of them here) BUILD_BUG() errors in arch/x86/kvm/cpuid.h
>> function __cpuid_entry_get_reg(), for the default: case.


-- 
~Randy

