Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95131E4B44
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 19:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgE0RAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 13:00:20 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50029 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726964AbgE0RAU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 13:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590598818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=19uN5uVqFPxYVimAYdibOEMC+SZq9IjB04cBBr/Z/FE=;
        b=cxHPoLdTFMe3NpkJn57fS+25dIDbQyx28cc3oD281IAzxq9+hQ82FuywR9CIJoIYk+awHY
        IWdhQZr+YmWL0nmjtDYNjxaDBZj0ZSETx8MAcKOpe04tvR+nso+r4QcefEgBGOlABgO5/S
        6V1uBcb6ToSas1MuEybonPqLXWp2lhk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-yUzJfUKTP8q7LRu8wxpIZg-1; Wed, 27 May 2020 13:00:16 -0400
X-MC-Unique: yUzJfUKTP8q7LRu8wxpIZg-1
Received: by mail-wr1-f69.google.com with SMTP id z8so11413435wrp.7
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 10:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=19uN5uVqFPxYVimAYdibOEMC+SZq9IjB04cBBr/Z/FE=;
        b=t9ej9fMM6AllC1ssgWT3IwpwHwFBII77p+JeP1x9Syc1urYzopWwzYqD9fabiHwNuJ
         EvLaZ/Oeo/k2jEQJ7opfGJdgUn2Q+j0gjpU+gvhrlpZuIMx8nlQgCiMRB2dWIi4e8FVa
         bimHMUrG14l+Bx5Okm6Im6dSH0yB/Bo57zzyYYx98kutUSCNut+NWpV2SQ9R2AR5ylsY
         Ec3xwx/9uU2LOichdMhCLurpR4YnYpI8Cw82OyApo1OkEJ4M8F3i/hCbhBLIRYKD19zV
         R/HVoR5Q8hMbFWZTlzKPK2deur2IYvQsQjX/uHPVEI7BpZJF9vdviGvuJw5i5T7lqGFr
         77TQ==
X-Gm-Message-State: AOAM532LorlywL4hrCHqYMNzBdJ5pCS+myg/cJp9t5oADhu/TBFFQe/F
        LcmN7Cw2h/xhsXLfbdo9ogl6lBnZsplhm1VlP2XWzEqXDjfQJbY03jyJylS92mzjsW8EdTZpfb9
        UrBAjL+q2zcrk
X-Received: by 2002:adf:feca:: with SMTP id q10mr18966778wrs.380.1590598815731;
        Wed, 27 May 2020 10:00:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZsMcWkS3QYq92JA1gLacyexyY9OQ9Klpg3SI6agBShM60ySQO59nAhfrwJJyiTsfoOy/rdw==
X-Received: by 2002:adf:feca:: with SMTP id q10mr18966738wrs.380.1590598815463;
        Wed, 27 May 2020 10:00:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id h15sm3219876wrt.73.2020.05.27.10.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 10:00:14 -0700 (PDT)
Subject: Re: [PATCH 0/2] Fix issue with not starting nesting guests on my
 system
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Tao Xu <tao3.xu@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jingqi Liu <jingqi.liu@intel.com>
References: <20200523161455.3940-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c12376a8-fc98-5785-e4b6-5c682afd3cd6@redhat.com>
Date:   Wed, 27 May 2020 19:00:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200523161455.3940-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/05/20 18:14, Maxim Levitsky wrote:
> On my AMD machine I noticed that I can't start any nested guests,
> because nested KVM (everything from master git branches) complains
> that it can't find msr MSR_IA32_UMWAIT_CONTROL which my system doesn't support
> at all anyway.
> 
> I traced it to the recently added UMWAIT support to qemu and kvm.
> The kvm portion exposed the new MSR in KVM_GET_MSR_INDEX_LIST without
> checking that it the underlying feature is supported in CPUID.
> It happened to work when non nested because as a precation kvm,
> tries to read each MSR on host before adding it to that list,
> and when read gets a #GP it ignores it.
> 
> When running nested, the L1 hypervisor can be set to ignore unknown
> msr read/writes (I need this for some other guests), thus this safety
> check doesn't work anymore.
> 
> V2: * added a patch to setup correctly the X86_FEATURE_WAITPKG kvm capability
>     * dropped the cosmetic fix patch as it is now fixed in kvm/queue
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (2):
>   kvm/x86/vmx: enable X86_FEATURE_WAITPKG in KVM capabilities
>   kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally
> 
>  arch/x86/kvm/vmx/vmx.c | 3 +++
>  arch/x86/kvm/x86.c     | 4 ++++
>  2 files changed, 7 insertions(+)
> 

Queued for 5.7, thanks (with cosmetic touches to the commit message, and
moving the "case" earlier to avoid conflicts).

Paolo

