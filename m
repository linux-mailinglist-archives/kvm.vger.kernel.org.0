Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3C8494B0E
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359643AbiATJtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:49:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233682AbiATJtF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 04:49:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642672144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ASD723Fq05/u+RSMddSwINm6iuW+XRhy8TGVViJ7jE=;
        b=Y3OEwjfD/FReXDiKMhg38/LHeAX346JrJUsPWWKA0rmy9HIgAEHeiPA8XOoK0oBKz6PI+k
        emnB+gLhpR09exfgp8VLNg1QAL3fBqPhKEenBIOf4itcSmwdisyJzu7h8RRS1RMBdjw6x9
        oHMAbG01QFJVGry8YCcP3qGkCS9mLrI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-LRvCHgxZPo-M4y8bckGT1g-1; Thu, 20 Jan 2022 04:49:03 -0500
X-MC-Unique: LRvCHgxZPo-M4y8bckGT1g-1
Received: by mail-wm1-f69.google.com with SMTP id z2-20020a05600c220200b0034d2eb95f27so3708620wml.1
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 01:49:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3ASD723Fq05/u+RSMddSwINm6iuW+XRhy8TGVViJ7jE=;
        b=MnxKu/3jJ3XtkJ+c8VerY81UNDASuPUOKkLU5jz4OL5UDMrBwy5sebWrooA9UuQDCw
         pWkWIqMMouADQvQXXixtwuabGkX6naDhq9Zf2P8n6oLafOPAjHn1ojQC7AUoGLMy93EA
         rSbjqmBTUV/t1Es98csQV/EWSFGNUq2LLrv5McYnm/01CzQi3v5tZi5jmc6iAZDZkiOP
         EiTpOQJM+B8sxNbQ9QxIfhqyFrOJj8rJU2p/wJXvp56VsyW9IPPFDbUrDPrFv3unWkkq
         LYq9gDXHVaUzcj1LZGH6F0P/xjw8trETklxn9FhS59KPOWXHRgQGIyww+PXSN4irVcPR
         5nmQ==
X-Gm-Message-State: AOAM5301koc54VnuNTUxPLdOd7bC+GhX8nokMBbp12Qzk+7SQjoNvG/J
        DZijldqKzDGAkoquQ6m58tJg3Q9TiM9NFBFYullJ9cjuwOhlSy8ftaikpk0u8r5wtD/WwIc9Lyp
        vgPp18qGeMOTd
X-Received: by 2002:a5d:464e:: with SMTP id j14mr27171729wrs.252.1642672142057;
        Thu, 20 Jan 2022 01:49:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlYe/3RfiOjswaZnOooonISxe6eEP7wKl0mY0RlahITBbXhrOgxhrgk3MGbTim1FUrgIqcHw==
X-Received: by 2002:a5d:464e:: with SMTP id j14mr27171710wrs.252.1642672141823;
        Thu, 20 Jan 2022 01:49:01 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r2sm3567451wrz.99.2022.01.20.01.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 01:49:01 -0800 (PST)
Message-ID: <5de5120f-e4b1-5888-58cb-b642361ea5cd@redhat.com>
Date:   Thu, 20 Jan 2022 10:49:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [DROP][PATCH] KVM: x86: Fix the #GP(0) and #UD conditions for
 XSETBV emulation
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Jun Nakajima <jun.nakajima@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117072456.71155-1-likexu@tencent.com>
 <a133d6e2-34de-8a41-475e-3858fc2902bf@redhat.com>
 <9c655b21-640f-6ce8-61b4-c6444995091e@gmail.com>
 <0d7ed850-8791-42b4-ef9a-bbaa8c52279e@redhat.com>
 <92b16faf-c9a7-4be3-43f7-3450259346e9@gmail.com>
 <19c4168f-c65b-fc9a-fe4c-152284e18d30@redhat.com>
 <d0855fb0-4e98-1090-a230-132b08864ed3@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d0855fb0-4e98-1090-a230-132b08864ed3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 10:31, Xiaoyao Li wrote:
>>
>> So while my gut feeling that #UD would not cause a vmexit was correct,
>> technically I was reading the SDM incorrectly.
> 
> SDM also states
> 
>    Certain exceptions have priority over VM exits. These include
>    invalid-opcode exception, faults based on privilege level,
>    and general-protection exceptions that are based on checking
>    I/O permission bits in the task-state segment(TSS)
> 
> in "Relative Priority of Faults and VM Exits"
> 
> So my understanding is that the architectural check always takes the 
> higher priority than VM exit.

Good point!  It's right above in 25.1.1.  I was confused by the specific 
mention of GETSEC, but the reason for the footnote is because undefined 
GETSEC leaves cause a vmexit instead of #UD, and GETSEC vmexits also 
override #GP faults based on privilege level.

Thanks,

Paolo

