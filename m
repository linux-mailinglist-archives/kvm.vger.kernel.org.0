Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9094985E0
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241472AbiAXRHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244149AbiAXRHd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 12:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643044052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LKa+X5L3QDzxsSkbPXeCVIlZkDz5is1AA5jgaq4zus0=;
        b=V0lrG9UCP3x4hko0iiKJBNH3KqiP23bd3U+d5GsJYMYu78z5qF49yhjtmmU7m9rfw5yq+N
        /gYxf0SMirBg0vEIx6hKI/J9ihvWWN9T+P99L07Q4Mv4UvMlPSWxxvl45F7KfrHGjvDBx3
        V8zoej2WW6Ka43+avKkhOahE6DSYa74=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-nArjqqQxP9OrC7MBKf7Mxw-1; Mon, 24 Jan 2022 12:07:30 -0500
X-MC-Unique: nArjqqQxP9OrC7MBKf7Mxw-1
Received: by mail-ed1-f69.google.com with SMTP id h21-20020aa7c955000000b0040390b2bfc5so13441101edt.15
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:07:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LKa+X5L3QDzxsSkbPXeCVIlZkDz5is1AA5jgaq4zus0=;
        b=7EUgkaHEDbyE0+OcTOJ9XQPuh6n5LKGCfk93xoN01GOsjpWMjSeB5NqZgRt/jikAMX
         PdkVkJnn/WhMaOxe+a9tbLRftnVV7mZ9aFOxr4/WOSvC0DGT2+qoXuPRXMxjY9cybGhd
         XZvbDhM1gVWYZG+Blk5juhOJozTeqtDEj1RkqC4RodPTSHlAKTdKzDIgpL0R/4QZdp6L
         o0kFDxlQWWMc3iGxg5/dUXUo7xH4XJk86o9rkRntDbuelUNOUFtFPDpnWJjUq1QiU8XF
         xZTrUpoMRsyacEpjzrpKlhATuTcjSjIVGNwWjZ5o+Haqterqy9h43lhmPN4gqxp3MT6O
         7+1A==
X-Gm-Message-State: AOAM530JPrva9VNFgP+0hlh2KSVFquxdiPcGgINT7Tmf6+0h8NIEciRU
        zBdmhMUtBmMEFvOrUp+eSR9wljbbPab1r2YGUw4Exi1Act/755MkwvjqFRc1O8zTUvtOpV7DP49
        1D9/WvIrH6sgf
X-Received: by 2002:a05:6402:3719:: with SMTP id ek25mr16624315edb.184.1643044049416;
        Mon, 24 Jan 2022 09:07:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJztXM9zvZpq8MpyKh4SDBBtgMtS5GEB+X+ZtAPHxie4kGfRsFVN/rTbpfOQiG00Gi+lx8gdEg==
X-Received: by 2002:a05:6402:3719:: with SMTP id ek25mr16624303edb.184.1643044049234;
        Mon, 24 Jan 2022 09:07:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u12sm6951407edq.8.2022.01.24.09.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 09:07:28 -0800 (PST)
Message-ID: <979883b4-8fcd-7488-0313-de6348863b21@redhat.com>
Date:   Mon, 24 Jan 2022 18:07:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] KVM: x86: Use memcmp in kvm_cpuid_check_equal()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20220124103606.2630588-1-vkuznets@redhat.com>
 <20220124103606.2630588-3-vkuznets@redhat.com>
 <95f63ed6-743b-3547-dda1-4fe83bc39070@redhat.com> <87bl01i2zl.fsf@redhat.com>
 <Ye7ZQJ6NYoZqK9yk@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ye7ZQJ6NYoZqK9yk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/22 17:52, Sean Christopherson wrote:
> On Mon, Jan 24, 2022, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>>> +	if (memcmp(e2, vcpu->arch.cpuid_entries, nent * sizeof(*e2)))
>>>> +		return -EINVAL;
>>>
>>> Hmm, not sure about that due to the padding in struct kvm_cpuid_entry2.
>>>    It might break userspace that isn't too careful about zeroing it.
> 
> Given that we already are fully committed to potentially breaking userspace by
> disallowing KVM_SET_CPUID{2} after KVM_RUN, we might as well get greedy.

Hmm, I thought this series was because we were _not_ fully committed. :)

>> FWIW, QEMU zeroes the whole thing before setting individual CPUID
>> entries. Legacy KVM_SET_CPUID call is also not afffected as it copies
>> entries to a newly allocated "struct kvm_cpuid_entry2[]" and explicitly
>> zeroes padding.
>>
>> Do we need to at least add a check for ".flags"?
> 
> Yes.

Yes, we do.  Alternatively, we can replace memdup with a copy in the 
style of KVM_CPUID.

Paolo

