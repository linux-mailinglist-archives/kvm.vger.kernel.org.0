Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951A4307BCF
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhA1RIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:08:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232799AbhA1RHz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:07:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611853586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wWoEDV2+x1rSSxBhCMufc3CCrdduXE65gmsAzlecp3s=;
        b=HQsZoKyiEayjsWrvxQ75/NuJhNYeVA1g7onQls9iHxGfbh6Wh/ZFfM/dZ8xPiEvgTWqBHS
        zRPw0zM7uPVDSDw94F/aKwzYgRdFreXR9fo5Lxs7dvEYwi1FeVAuZzc2mAJMyR0fdAGqru
        tE1FSEk2FWIpyD8gPke+z7kZ7kaiZ+k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-XB6UKEPWMOS82su0WFE9tA-1; Thu, 28 Jan 2021 12:06:24 -0500
X-MC-Unique: XB6UKEPWMOS82su0WFE9tA-1
Received: by mail-ed1-f72.google.com with SMTP id w4so3493334edu.0
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:06:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wWoEDV2+x1rSSxBhCMufc3CCrdduXE65gmsAzlecp3s=;
        b=ai9UiI3B3riyvQ7mBDEpCJZT6Y6j8WNvI7NtHKdIHlhVsKZzuN5lVvz5CjxNxHFCmE
         +zgIsXh8KRC4LT1x+bC0qN9QmaenoG6T6Ir6Iy7Blwe7LTm9cWxnr/DP/mGVh849zIyo
         OqY6zApCX4FQqqEgxfMAhrTtwE9x0xzIM2NffrXMr2zRUd+66odPr9rYuJIaXpaBM/7G
         Ob3Q5zkbhREn9k5mVBkGF/pA7qOX1xFUA7HyDjfgsABm2nEi83wqWaM2CtqTpfVP4s02
         0dnZgOuIDy1t05eW7PkAwPfeszH3tNzHqLIzIUvLvh2eiWb1TZl1pfzU4RF1PqriKB5/
         hLKA==
X-Gm-Message-State: AOAM533TGbAkaeYLuWrZwHwLkwqihWYVlbM6eN2X/E4WOQsYllkEIy87
        XLzvngdGl4yG2gZlOE0oGACeYfBdlAFK0/B/8KXvYSQuER3rv5ppj2TUpRNf6jFURm6Se4XSB0L
        9lF+yeyVTt8Ag
X-Received: by 2002:aa7:d0cf:: with SMTP id u15mr532302edo.115.1611853583728;
        Thu, 28 Jan 2021 09:06:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx42bUQ5y6gme8lfeeQLMxR56j8DxRTU5kVgISp3SFuW9jPxSqggneqWcz0CXcvkkRN4B9sFw==
X-Received: by 2002:aa7:d0cf:: with SMTP id u15mr532279edo.115.1611853583521;
        Thu, 28 Jan 2021 09:06:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s3sm2457200ejn.47.2021.01.28.09.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:06:22 -0800 (PST)
Subject: Re: [PATCH v5 15/16] KVM: Add documentation for Xen hypercall and
 shared_info updates
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210111195725.4601-1-dwmw2@infradead.org>
 <20210111195725.4601-16-dwmw2@infradead.org>
 <e79d508e-454f-f34e-018b-e6b63fe3d825@redhat.com>
 <dd496053b8d51a400b66622cd25c10f4540ac4d9.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <204b5082-2f8b-9936-675f-0ddc12a6ab43@redhat.com>
Date:   Thu, 28 Jan 2021 18:06:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <dd496053b8d51a400b66622cd25c10f4540ac4d9.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 17:49, David Woodhouse wrote:
> On Thu, 2021-01-28 at 13:18 +0100, Paolo Bonzini wrote:
>> My only qualm is really that the userspace API is really ugly.
>>
>> Can you just have both a VM and a VCPU ioctl (so no vcpu_id to pass!),
> 
> Sure, that seems like a sensible thing to do.
> 
>> add a generous padding to the struct,
> 
> I think I added *some* padding to the struct kvm_xen_hvm_attr which
> wasn't there in Joao's original. I can add more, certainly.
> 
>>   and just get everything out with a
>> single ioctl without having to pass in a type?
> 
> Honestly, I don't even care about reading it out except for long_mode
> which the kernel *does* infer for itself when the MSR is used to fill
> in the hypercall page.

What about VM migration?

> I quite like keeping them separate; they *do* get set separately, in
> response to different hypercalls from the guest. And the capabilities
> translate naturally to a given field existing or not existing; having
> another mapping of that to fields in a binary structure would be
> additional complexity.

Does it make sense to reuse the bits that you return from 
KVM_CHECK_EXTENSION as a bitset for both the get and set ioctls?  The 
struct then would be

	struct kvm_xen_attr {
		uint32_t valid;
		uint32_t lm;
		struct {
		} ...;
		uint8_t pad[nnn /* to 128 bytes */];
	};

The get ioctl would return a constant value in "valid" (different for 
the VM and VCPU ioctls of course), the set ioctl would look only at the 
fields mentioned in "valid" and error out if they're unsupported or 
invalid for VM/VCPU.  Basically the "switch" you have becomes a series 
of "if (attr->valid & ...)" statements.

Paolo

