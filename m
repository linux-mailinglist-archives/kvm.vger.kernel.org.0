Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D313C15F5
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 17:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhGHPb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 11:31:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231845AbhGHPb5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 11:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625758154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ytWqP0MZDHhVybckN5p2iymaMJbhbiYb8z9pc5/aYg=;
        b=ftdIukn+2oYhLs5PmvL0G1e3d/RkW+3RcReyBRJZLHD0qmuZ+DEBawvrB+czXrEw8j1OkJ
        GfijvbNnp+7/fRWpgABtZiMnd6UQQnXnnKN8yBX/PfzXFoGPubHdP7HLhLLqy+kzEccI1I
        gC4OozGg8u6wDh9ERibEsdbl9+pJB6E=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-SmCVsGThM7aY7lUo096Dlg-1; Thu, 08 Jul 2021 11:29:13 -0400
X-MC-Unique: SmCVsGThM7aY7lUo096Dlg-1
Received: by mail-ej1-f70.google.com with SMTP id gz14-20020a170907a04eb02904d8b261b40bso1991368ejc.4
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 08:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ytWqP0MZDHhVybckN5p2iymaMJbhbiYb8z9pc5/aYg=;
        b=EK7bwubpvBkxbldPOKigqEf1zlcXf8St4lJ9sjgZ1pKmmEFANgf2/MabAACMjuhN0+
         esX2PwyBvNxjzGGkf0ab2Xzze0poBX0P81BiMC1hZN40GVYgTLWzHDPjogkCko3QyP6b
         m0uoPhXonH0ZH8sOkMa7RgVjrUehPMpU6eklc4RUcIvRAI4rvg4u9XS0D+v1OgSm6XKB
         Vv5ZGo55vE4KI4RFNpteWAgHk2o99rA8KLZx9pXVpDkjsosLaob+xPXFV52dBw7lUvfo
         12BC3nAJZut3KKzlMa9sUyFk7QJNGENGXXYOiEQxfUCLpEUt5YqzCMj8h2onC3KdEA9j
         TYDw==
X-Gm-Message-State: AOAM532mllrpz+xFLUDTSjyAxd7EGMaeahkl/jAJU8mIFYFkuHQPMJ/Q
        2AJppODeIRF6DqrvxmWrZtJxQ1+ooidMqHP+7vpviRGqAXvKFyw/kIj6SM6+Om4/3oepQVL0LmE
        PBOsXbGfzGzN7
X-Received: by 2002:a17:906:70b:: with SMTP id y11mr4774265ejb.328.1625758152482;
        Thu, 08 Jul 2021 08:29:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIamEdl87GewWt/JixiXsX8CrG7mkexH8ZHezkNMDbGG/XPBriNEikqufYoK38vtVIIia6ig==
X-Received: by 2002:a17:906:70b:: with SMTP id y11mr4774237ejb.328.1625758152291;
        Thu, 08 Jul 2021 08:29:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g11sm1448256edt.85.2021.07.08.08.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 08:29:11 -0700 (PDT)
Subject: Re: [RFC PATCH v2 55/69] KVM: VMX: Add 'main.c' to wrap VMX and TDX
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kernel test robot <lkp@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <52e7bb9f6bd27dc56880d81e232270679ffee601.1625186503.git.isaku.yamahata@intel.com>
 <0b1edf62-fce8-f628-b482-021f99004f38@redhat.com>
 <20210708152152.GB278847@private.email.ne.jp>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aca9277a-da65-ab0b-f499-28da1da112e8@redhat.com>
Date:   Thu, 8 Jul 2021 17:29:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708152152.GB278847@private.email.ne.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/21 17:21, Isaku Yamahata wrote:
> On Tue, Jul 06, 2021 at 04:43:22PM +0200,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
>> On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
>>> +#include "vmx.c"
>>
>> What makes it particularly hard to have this as a separate .o file rather
>> than an #include?
> 
> It's to let complier to optimize functionc call of "if (tdx) tdx_xxx() else vmx_xxx()",
> given x86_ops static call story.

As long as it's not an indirect call, not inlining tdx_xxx and vmx_xxx 
is unlikely to give a lot of benefit.

What you could do, is use a static branch that bypasses the 
"is_tdx_vcpu/vm" check if no TDX VM is running.  A similar technique is 
used to bypass the test for in-kernel APIC if all VM have it.

Paolo

