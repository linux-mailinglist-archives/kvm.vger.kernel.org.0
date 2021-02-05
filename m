Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E203108CC
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 11:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhBEKOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 05:14:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230126AbhBEKMP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 05:12:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612519848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uwWH69RD/U8R/Yz9V56rEzUfEXvsQXclaTN8AOW6CJQ=;
        b=ZSSGgvmYwPK4dGJI1ce+iS4F2bPIlIfB96cgiui1PmdnOR/D9fPr6X1h1QMlvjLs3z8H8P
        r4YVmKPK8yc4gFl/AS30nVVnbVxUfl1Cyx1J1kbvdjwJ9Wi29X4HJVQhG+PvMWFFGQ4zTn
        YRzRCsMpZCnaaAKi282XsSPrtEcQYHg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-vcxDt6RhNCyhPuRLUEnImw-1; Fri, 05 Feb 2021 05:10:46 -0500
X-MC-Unique: vcxDt6RhNCyhPuRLUEnImw-1
Received: by mail-wr1-f70.google.com with SMTP id h18so5086171wrr.5
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:10:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uwWH69RD/U8R/Yz9V56rEzUfEXvsQXclaTN8AOW6CJQ=;
        b=QlKKO0fcdhuJlBgs9AYzr3ewLW41pAiVMzM6MIPmo5Bxt0gWHsNR2wXmVYPoyi7kbi
         xKiWlvDevo24WwLwGkVTlJsUNzfmuRr1eQl6lqYL1iRL9p54i+W2K6uR7QOsztReVNIH
         bNQCOcYzbSFWVZF0IrjJM6QdhMeKcn+EYA9nwKZ52GiM2nrpqjSX8a0+wNri7UnU7riF
         X00qauOilQwiTr7oJ6olh8ZEIAwqWG8HwQmSLQvz7zYy2LQpZxbDlkLhmXnKxM9N1yp9
         bfjsVqGjgWJA4R5rBVjslFzZZQDObuJeZ+cDrt+TKMaWA0tS3gQHEY8NsnDdjkke/6Xs
         uXKg==
X-Gm-Message-State: AOAM532id9KHpT8okCyPnm2Be5Zr6xiK1c6b/spXpwhFvSwpSFcSTS5g
        IJ5u8pXOZoRpeC55jI4BQUJEXPO4CEHzqxnTZ0lV+73EIWxVBsf6MIHeXo9JBLWc5ygBwquf2A7
        ama++Ipa/8iIZ
X-Received: by 2002:adf:f6c4:: with SMTP id y4mr4033436wrp.127.1612519845816;
        Fri, 05 Feb 2021 02:10:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxx47BL9I/3ugpty5hVt2p3Lu1LcqvAbsB3zBvejcpJSyGhSuJeFM9oXaqJJ5kZd9xpcKW0WA==
X-Received: by 2002:adf:f6c4:: with SMTP id y4mr4033412wrp.127.1612519845639;
        Fri, 05 Feb 2021 02:10:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l10sm11574979wro.4.2021.02.05.02.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:10:44 -0800 (PST)
Subject: Re: [PATCH v4 2/5] KVM: X86: Expose PKS to guest
To:     Borislav Petkov <bp@alien8.de>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
 <20210205083706.14146-3-chenyi.qiang@intel.com>
 <8768ad06-e051-250d-93ec-fa4d684bc7b0@redhat.com>
 <20210205095603.GB17488@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e90dadf9-a4ad-96f2-01fd-9f57b284fa3f@redhat.com>
Date:   Fri, 5 Feb 2021 11:10:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210205095603.GB17488@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 10:56, Borislav Petkov wrote:
> On Fri, Feb 05, 2021 at 10:25:48AM +0100, Paolo Bonzini wrote:
>> On 05/02/21 09:37, Chenyi Qiang wrote:
>>>
>>> diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
>>> index 57718716cc70..8027f854c600 100644
>>> --- a/arch/x86/mm/pkeys.c
>>> +++ b/arch/x86/mm/pkeys.c
>>> @@ -390,3 +390,9 @@ void pks_key_free(int pkey)
>>>   	__clear_bit(pkey, &pks_key_allocation_map);
>>>   }
>>>   EXPORT_SYMBOL_GPL(pks_key_free);
>>> +
>>> +u32 get_current_pkrs(void)
>>> +{
>>> +	return this_cpu_read(pkrs_cache);
>>> +}
>>> +EXPORT_SYMBOL_GPL(get_current_pkrs);
>>> diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
>>> index bed0e293f13b..480429020f4c 100644
>>> --- a/include/linux/pkeys.h
>>> +++ b/include/linux/pkeys.h
>>> @@ -72,6 +72,10 @@ static inline void pks_mk_readwrite(int pkey)
>>>   {
>>>   	pr_err("%s is not valid without PKS support\n", __func__);
>>>   }
>>> +static inline u32 get_current_pkrs(void)
>>> +{
>>> +	return 0;
>>> +}
>>>   #endif /* ! CONFIG_ARCH_HAS_SUPERVISOR_PKEYS */
>>
>> This would need an ack from the x86 people.  Andy, Boris?
> 
> This looks like the PKS baremetal pile needs to be upstream first.

Yes, it does.  I would like to have an ack for including the above two 
hunks once PKS is upstream.

I also have CET and bus lock #DB queued and waiting for the bare metal 
functionality, however they do not touch anything outside arch/x86/kvm.

Paolo

