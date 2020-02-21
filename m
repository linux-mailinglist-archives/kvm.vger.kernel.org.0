Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FA9167547
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 09:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbgBUIZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 03:25:01 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42810 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388735AbgBUIZA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 03:25:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582273499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JpEsbhm0dnY2XkgMWgpgEc7Vy7naaq05yoFLVGVNgFQ=;
        b=e7aHyw0se/XHegFRH/m22PZKO0adu8vSeR0gIKpNKaBQntokLJXlf8jYRGEw+OVcYFm1vC
        1G142RwLWmGKrpGrQuWXy9ITxveUNlygL/b+F6pPYxzgGY/ORgkRZcpBX/jUpk0yMLFInq
        IUBm4D5xmE8fClKrVodhK3dLkQE8LRE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-lsFd0_LIPqa_mEkoYPJWrQ-1; Fri, 21 Feb 2020 03:24:58 -0500
X-MC-Unique: lsFd0_LIPqa_mEkoYPJWrQ-1
Received: by mail-wr1-f69.google.com with SMTP id v17so681197wrm.17
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 00:24:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JpEsbhm0dnY2XkgMWgpgEc7Vy7naaq05yoFLVGVNgFQ=;
        b=YK+bUnRCP/8YFFAi+rs9yKoGBFrpwCoz9UAjbqiBZfWgthcCb77PIUc1UBprA8Qqo7
         c6ax5tmJqfCu9hZ9D6ZYG3o0hSvuDTK/bETPjP/91EsETUdWz+jEyTfAZRurJQy6FDWY
         vU3PDjw+ve0QPYvQU31CyrmGEQXsiKsfsChZTkZ6pywpOt3sXQCz8CC9azWH4VAP7l8K
         smHuJzB6xv0NoTHkjLanN8thBbC19JadPLRWPzfmu8Tt/A7pF91mjOIfDUsowyUciSYN
         ++l2Y0n8Us9umBsuJCXeZ++Drse5z0l8r2265OOt34uCX7vv3HtY9f4YgExXZmXkHGzC
         +7pw==
X-Gm-Message-State: APjAAAU4AgI6DhafS8fkXboGJFoks4q2IF44edvEo8x3POSZIrPqPjvj
        Lqz8czqgGW+0aNoZsSXUx5cG1fC32Bg83r9vsJOXPF8a/fwOd066v8s+qgXXcNUYsKGtBek5D6A
        6wuImMMwFQ+0U
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr2314630wmb.32.1582273496978;
        Fri, 21 Feb 2020 00:24:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqy9XEBUNFu6fL1v8qMs+wK6cnizQBZpdG2ONk83LD1yWO4MhmgmtrYJ9GVuWC9Ejix7BrOdkg==
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr2314596wmb.32.1582273496625;
        Fri, 21 Feb 2020 00:24:56 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id x21sm2641985wmi.30.2020.02.21.00.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 00:24:56 -0800 (PST)
Subject: Re: [PATCH] KVM: Suppress warning in __kvm_gfn_to_hva_cache_init
To:     Oliver Upton <oupton@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>
References: <20200218184756.242904-1-oupton@google.com>
 <20200218190729.GD28156@linux.intel.com>
 <f08f7a3b-bd23-e8cd-2fd4-e0f546ad02e5@redhat.com>
 <CAOQ_Qshafx78-O4_HnK9MbOdmoBdZx6_sdAdLmugmXjURTXs6g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <096c6b94-c629-7082-cd70-ab59fedffa7c@redhat.com>
Date:   Fri, 21 Feb 2020 09:24:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_Qshafx78-O4_HnK9MbOdmoBdZx6_sdAdLmugmXjURTXs6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/02/20 05:32, Oliver Upton wrote:
> On Thu, Feb 20, 2020 at 3:23 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 18/02/20 20:07, Sean Christopherson wrote:
>>> On Tue, Feb 18, 2020 at 10:47:56AM -0800, Oliver Upton wrote:
>>>> Particularly draconian compilers warn of a possible uninitialized use of
>>>> the nr_pages_avail variable. Silence this warning by initializing it to
>>>> zero.
>>> Can you check if the warning still exists with commit 6ad1e29fe0ab ("KVM:
>>> Clean up __kvm_gfn_to_hva_cache_init() and its callers")?  I'm guessing
>>> (hoping?) the suppression is no longer necessary.
>>
>> What if __gfn_to_hva_many and gfn_to_hva_many are marked __always_inline?
>>
>> Thanks,
>>
>> Paolo
>>
> 
> Even with this suggestion the compiler is ill-convinced :/
> 
> in re to Sean: what do I mean by "draconian compiler"
> 
> Well, the public answer is that both Barret and I use the same
> compiler. Nothing particularly interesting about it, but idk what our
> toolchain folks' stance is on divulging details.
> 
> I'll instead use Sean's suggested fix (which reads much better) and resend.

Can you instead look into fixing that compiler?  After inlining, it is
trivial to realize that the first two returns imply
kvm_is_error_hva(ghc->hva).  I'm asking this because even for GCC
-Wuninitialized *used to be* total crap, but these days it's quite
reliable and even basic data flow should be able to thread through the
jumps.

I'm more than willing to help the compiler with __always_inline hints,
but an "uninitialized_var()" adds load on the code and I'm not sure it
makes sense to do that for the sake of some proprietary, or at least
unnamed, software.

Paolo

