Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06893BDB85
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 18:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhGFQow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 12:44:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229935AbhGFQov (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 12:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625589732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cIGfRNQJl5ggKMxg79cS0CRRyE/NvGU9bwegJhnpmik=;
        b=I+FAsZ66VRMkds6xWHKvn1fgHsL5soG/gy7rTqsOqSjxkPofx5bxWLYI1NsWHHtxn8o3jp
        CDDcIs8ZvMC9966n6eVRN6iMSBRLVNNFh328DqSlraTL7Wamn9EJVqkEjtHk8Jc/MU9mP+
        T8kdbFAxTGwN6epnqGt4KY2sB5QdfKI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242---hRJYnfM4229tzgzIbXTA-1; Tue, 06 Jul 2021 12:42:11 -0400
X-MC-Unique: --hRJYnfM4229tzgzIbXTA-1
Received: by mail-lf1-f71.google.com with SMTP id c20-20020a0565122394b0290328f0b3dcdcso5469398lfv.7
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 09:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIGfRNQJl5ggKMxg79cS0CRRyE/NvGU9bwegJhnpmik=;
        b=hfG2XQGJBAyo0lHim2X5fstYf5e1CF24W1wQ85SSJ924cTHlFcUVt4UmuoS7c2yK3K
         V8pyD8EirBAgKd/Umt+352NucScJ8vQbXzj7WHLTEdPjtbrtnNH45Qvs5cQJ7nRyrEM+
         bKOPT/WKQpqIrMqMmo2EWX+baXGiRM0idadoziPs/SRtPqe3ADwPWL6sdd6vTeFnZWHh
         Kfh0tcOw17nbAv7+TWZxNtQgt0qUldD9L2aKkqYg2UR49GyajJoVs/q4WQSW0/cqi9Bu
         OeS0HjuW/82BAN+j0trRTJAZId37aZMWEntxIVR54GahrDml1JKg4nGLYffQMUbREQC4
         cU3A==
X-Gm-Message-State: AOAM53262POGvuDMW2iLnO27GXnnPIUQlHnef0gwwlbPEKunyMWfdJvO
        oUOwVOBrab/9gQuk3FPMC9Oql/M8yQAf9OSQ3ibYyASsvVydXxoi6qlx+2kSI1vHqWKJxUuQ0A0
        7IZdxq/GeZX0gubvn9MfGPbRIl6oDG1XlfBVdlPQzWOo+jRm1HGt3c8Wr7ormad7f
X-Received: by 2002:a17:906:2b85:: with SMTP id m5mr19699923ejg.141.1625589373130;
        Tue, 06 Jul 2021 09:36:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwklRUDSeiurdb2sBPdof7jI8gOjgmNWus52vqj/2qJ07LO5gCWoAEqWQqjNpNwlfPHkYs8oQ==
X-Received: by 2002:a17:906:2b85:: with SMTP id m5mr19699873ejg.141.1625589372890;
        Tue, 06 Jul 2021 09:36:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hw6sm6009886ejc.37.2021.07.06.09.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 09:36:12 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] Add support for XMM fast hypercalls
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1622019133.git.sidcha@amazon.de>
 <20210630115559.GA32360@u366d62d47e3651.ant.amazon.com>
 <f318fd42-6b98-1a82-f334-d05f4e6cb715@redhat.com>
 <20210706151535.GA28697@u366d62d47e3651.ant.amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d0d8c67f-ac0b-255e-c7a3-e7d4ac37a654@redhat.com>
Date:   Tue, 6 Jul 2021 18:36:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706151535.GA28697@u366d62d47e3651.ant.amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/21 17:15, Siddharth Chandrasekaran wrote:
> On Tue, Jul 06, 2021 at 05:04:59PM +0200, Paolo Bonzini wrote:
>> On 30/06/21 13:56, Siddharth Chandrasekaran wrote:
>>> On Wed, May 26, 2021 at 10:56:07AM +0200, Siddharth Chandrasekaran wrote:
>>>> Hyper-V supports the use of XMM registers to perform fast hypercalls.
>>>> This allows guests to take advantage of the improved performance of the
>>>> fast hypercall interface even though a hypercall may require more than
>>>> (the current maximum of) two general purpose registers.
>>>>
>>>> The XMM fast hypercall interface uses an additional six XMM registers
>>>> (XMM0 to XMM5) to allow the caller to pass an input parameter block of
>>>> up to 112 bytes. Hyper-V can also return data back to the guest in the
>>>> remaining XMM registers that are not used by the current hypercall.
>>>>
>>>> Although the Hyper-v TLFS mentions that a guest cannot use this feature
>>>> unless the hypervisor advertises support for it, some hypercalls which
>>>> we plan on upstreaming in future uses them anyway. This patchset adds
>>>> necessary infrastructure for handling input/output via XMM registers and
>>>> patches kvm_hv_flush_tlb() to use xmm input arguments.
>>>
>>> Hi Paolo,
>>>
>>> Are you expecting more reviews on these patches?
>>
>> They are part of 5.14 already. :)
> 
> Ahh, I see them now. I was expecting them to show up in master - that was
> the confusion.

No problem! The patches for the rc period (in your case it was 5.13) go 
in master, while yours ended up in next (destined for 5.14).

I usually update master only after 5.14-rc1 is out.  In this case I 
didn't even have access to kvm.git on the day that Linus pulled your 
patches into his tree.

Paolo

