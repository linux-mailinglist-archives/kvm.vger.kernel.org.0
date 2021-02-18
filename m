Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC3431EE4A
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBRS25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:28:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234091AbhBRQ5j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 11:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613667370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uqmlb6nipGQi0xRt4b+2sX7cCXPvhlWVu38fDYg+VcA=;
        b=CiRSDHigg3RT7YC9Hh/yyGkfZZPFpyTenJfX55u7pbg5tnQt5R5ijP7IaZzFzZcDuQqEhR
        HX7ilSMgqo6kDl6ma2Szvo+gL5R68tcv5Pk45RZaU8xXhdCLuvHZZZUwhSyCKkkIy8jjfO
        weaiz57AmNyBAHANVU0aQKEWi4Hmegc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-oRMe-SmhPpi-BX9PNDkXvQ-1; Thu, 18 Feb 2021 11:56:08 -0500
X-MC-Unique: oRMe-SmhPpi-BX9PNDkXvQ-1
Received: by mail-wr1-f69.google.com with SMTP id u15so1245753wrn.3
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 08:56:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uqmlb6nipGQi0xRt4b+2sX7cCXPvhlWVu38fDYg+VcA=;
        b=Dwuf4wqvb7zoXgRdz7zFvDdCgZrMjkJ5FSytX4nRAc5b3c02LBJYYNkT5ZvYoh+1Ei
         QDYPZo1E8HJ619eQ+Sg8aHOslOl2lI35tck0oIDOAuEglTa8czY13D97rKXocor2dZ/E
         Oy/DFxZn1WPvU3iswZ068bri8zLySxbQs5nzQ2XUc6pSX+YMFbYT7qwsFWlSrf/UqofM
         TxsLCzR2Bh5ZmPayQ7lmT2BSUNWJ2Lp5IqSn8ZDNgwuEbsuuk0NhQeuwgrfmSUhWaK8f
         egSradLu/3mbvliUkjbvRRsRtC/qH+ms7fBV2KkdxepywEccdDv8q+Gen+tf2qsQrAbj
         lnDQ==
X-Gm-Message-State: AOAM530L12jSS7LJCdKy+wYIFZH429oBldaEWi11RxRE8ViuO0gu7lqX
        Y289fNWjYQO2wsaFDRd8CAGVf9epnnnr385A7AjKED5MHaTi5MlzoRqTCqsHEdJyjEw/ervp+6V
        PQG4zoaMBaiQ5
X-Received: by 2002:a7b:c107:: with SMTP id w7mr4406991wmi.169.1613667367346;
        Thu, 18 Feb 2021 08:56:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBCNLyGPqnDhRF1msgy9AYRl11w8cwoz3PUf2c3305gv5El6yheeC8/xTFqw7uDzozRAoJgw==
X-Received: by 2002:a7b:c107:: with SMTP id w7mr4406983wmi.169.1613667367161;
        Thu, 18 Feb 2021 08:56:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z2sm8329822wml.30.2021.02.18.08.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 08:56:06 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
References: <20210213005015.1651772-1-seanjc@google.com>
 <20210213005015.1651772-11-seanjc@google.com>
 <2d455c2e-1db4-5aff-45eb-529e68127fe7@redhat.com>
 <YC6SjgYTi+Dr1l0d@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/14] KVM: x86: Further clarify the logic and comments
 for toggling log dirty
Message-ID: <d911b26e-1f36-13f8-913e-1e3e3b9649cf@redhat.com>
Date:   Thu, 18 Feb 2021 17:56:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC6SjgYTi+Dr1l0d@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/21 17:15, Sean Christopherson wrote:
> On Thu, Feb 18, 2021, Paolo Bonzini wrote:
>> On 13/02/21 01:50, Sean Christopherson wrote:
>>>
>>> -	 * Nothing to do for RO slots or CREATE/MOVE/DELETE of a slot.
>>> -	 * See comments below.
>>> +	 * Nothing to do for RO slots (which can't be dirtied and can't be made
>>> +	 * writable) or CREATE/MOVE/DELETE of a slot.  See comments below.
>>>   	 */
>>>   	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
>>>   		return;
>>> +	/*
>>> +	 * READONLY and non-flags changes were filtered out above, and the only
>>> +	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
>>> +	 * logging isn't being toggled on or off.
>>> +	 */
>>> +	if (WARN_ON_ONCE(!((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)))
>>> +		return;
>>> +
>>
>> What about readonly -> readwrite changes?
> 
> Not allowed without first deleting the memslot.  See commit 75d61fbcf563 ("KVM:
> set_memory_region: Disallow changing read-only attribute later").  RW->RO is
> also not supported.
> 
> 	if (!old.npages) {
> 		change = KVM_MR_CREATE;
> 		new.dirty_bitmap = NULL;
> 		memset(&new.arch, 0, sizeof(new.arch));
> 	} else { /* Modify an existing slot. */
> 		if ((new.userspace_addr != old.userspace_addr) ||
> 		    (new.npages != old.npages) ||
> 		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
> 			return -EINVAL;
> 

Right you are, thanks.  Then the warning would catch this quick.  I 
queued 10 and 11 too, and will reply on 12 now that I looked at it more 
closely.

Paolo

