Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301274A5C1F
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 13:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiBAMWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 07:22:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237962AbiBAMWX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 07:22:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643718142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+zwjl6zVt+33hZ3YalCz0+Xw+BiJ+KK7jM3VRDmITI=;
        b=cPkL1AJUeXjPHtfs1CtbOhdQLIAvZIP4iWVR7zp/YD9jPsMPw52moMOF57BAXZhwigvEQF
        ntNBw7FdVksCNZ2Usff1gXKIeknltvqQ/oM0YnDGk6Tvl+JSZsHfaDupVSTX4LMk8L4Fa9
        sQLNBzpZymLWccsyRlUWZifyglX8dlc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-TZCDG_VTNY6rfia0lPz32g-1; Tue, 01 Feb 2022 07:22:21 -0500
X-MC-Unique: TZCDG_VTNY6rfia0lPz32g-1
Received: by mail-ed1-f69.google.com with SMTP id o25-20020a056402039900b0040631c2a67dso8512156edv.19
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 04:22:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K+zwjl6zVt+33hZ3YalCz0+Xw+BiJ+KK7jM3VRDmITI=;
        b=7AqA9stjAimcSim03rM2WXqdRViMj1Huuut1DiIbgrF18d0Yl0LkRaLV8zG0x6E0Up
         KJgynaRnkUtH5w/0008PzrBXHtRy3GdYyjQgyYiL/5YCR97YU5YPIj6wbKscsCIb/yHV
         xhqBJOSA4WoJSBDrpM6/+Cgfez8QrgmfcrClDNsm3ylSKYJLvv6Q00EKV6H+OSMY2Tpk
         GkmlsJEEreik8vu7hFNYmUnJrl4I/pblYDFWP+qviucPA7mrrClzvVK1W3SRLicJsp/S
         XAmuIx27twX1EuK4+9lTxf6f4hyqoI1EZmjAQuDhZE+Xuq2+SKM4Pqlb+LemQWvBoCcc
         GmoQ==
X-Gm-Message-State: AOAM530tlgsCM5pLBwVom7fRLDqgpGLcRLhCiHRX0g7B/aQ0EXH7pnx3
        ldT18licl10t+aVqTkNGyzxCVRzY5n5kdr2LGmckJLdI7PziBFoMyxl8kOnVh7wXQM+1hdr+sOR
        iAp9TFZjpQEmf
X-Received: by 2002:a17:907:9488:: with SMTP id dm8mr20571260ejc.73.1643718140518;
        Tue, 01 Feb 2022 04:22:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbGIDzyffz3cwhpFm84Jbqksw7iIz7Tg8rbce5YY1BTzrEz3vbTUbjX16oZxcVBCSmlY1Xmg==
X-Received: by 2002:a17:907:9488:: with SMTP id dm8mr20571248ejc.73.1643718140294;
        Tue, 01 Feb 2022 04:22:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id v23sm14754076ejy.177.2022.02.01.04.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 04:22:19 -0800 (PST)
Message-ID: <a74c63d6-f5e2-6ac3-0682-24e9a9ff39cd@redhat.com>
Date:   Tue, 1 Feb 2022 13:22:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/5] KVM: x86/mmu: Clean up {Host,MMU}-writable
 documentation and validation
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>
References: <20220125230518.1697048-1-dmatlack@google.com>
 <CALzav=f9EongPybjOpm8Lv_vHnBpk8DF3DUCkxz7NpxMR5vx4g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=f9EongPybjOpm8Lv_vHnBpk8DF3DUCkxz7NpxMR5vx4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/22 00:16, David Matlack wrote:
>>
>> David Matlack (5):
>>    KVM: x86/mmu: Move SPTE writable invariant checks to a helper function
>>    KVM: x86/mmu: Check SPTE writable invariants when setting leaf SPTEs
>>    KVM: x86/mmu: Move is_writable_pte() to spte.h
>>    KVM: x86/mmu: Rename DEFAULT_SPTE_MMU_WRITEABLE to
>>      DEFAULT_SPTE_MMU_WRITABLE
>>    KVM: x86/mmu: Consolidate comments about {Host,MMU}-writable
> The email threading on this series got a bit messed up (at least on
> lore). I had a misspelling in the signed-off-by tag in patch 4 that
> was caught by git-send-email after sending the cover letter and
> patches 1-3. So I fixed it and sent patch 4 and 5 separately.
> 
> I can resend the series again if anyone prefers.
> 

Not sure how that's even possible, but Thunderbird showed me correct 
threading.  Patch queued now, thanks.

Next time this happens you can send the other patches with --in-reply-to 
--no-thread:

        --in-reply-to=<identifier>
            Make the first mail (or all the mails with --no-thread)
            appear as a reply to the given Message-Id [...]

Thanks,

Paolo

