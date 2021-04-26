Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4286F36B41D
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 15:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhDZN33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 09:29:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232575AbhDZN33 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 09:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619443727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0w6s9JA5RI0isSgkR+9N2p6gh0AphGNhzBqN3GnUkgk=;
        b=KsG7Dcxg3pcg29JfThdBMrrpYXISIr7Yc4Drby/25dCes6kujlJj86y7BdSrBqTpT7WTlc
        XH2VcZoSnAsDukPwxhwsaIoe6tM6hYGm03CqnSpwy+/qMTJzAJfp7B0Skrm93XZdcyS2qs
        cl8pvXFmaHSmJE7iWSRZVpYJ8XWp6kA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-D0G6P2GRM5GLBqYWNGMAjQ-1; Mon, 26 Apr 2021 09:28:45 -0400
X-MC-Unique: D0G6P2GRM5GLBqYWNGMAjQ-1
Received: by mail-ed1-f70.google.com with SMTP id y10-20020a50f1ca0000b0290382d654f75eso23014170edl.1
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 06:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0w6s9JA5RI0isSgkR+9N2p6gh0AphGNhzBqN3GnUkgk=;
        b=TNLqdXZ7OHWIkqzKtaW/WEUKdn70B8/tFIw6Cohfe5WMX4C8jjIgzdAQaSykd0dwmk
         5lgQWDh5rarPEjj8MMsO2/3mL0EUpooSWCZaFgguvSneR/D2yBI2rZ/rOKauuNKAG0KK
         ntPeCeqqDegAeot3ydfkxS4zWKARKdihNV23oOSnEjSkEuRdkM+69+MYrgKfItBjVArb
         CGOo0T3GaEgKd73AdRWXWN4g8Hn5uBlagGaolKfrhT55hW9nlrplyHRN8YU86qQ8WBZ2
         qC1JE3NfIPqU/SAGJ4QnFuatIXxxjWriw7xDc9K8NeafXBj7mBycpedH1TAP+WfhflRy
         FlgQ==
X-Gm-Message-State: AOAM530nejEpDIj1u8NLA8gquY9CHbUSITOmn2SgLrcKW4crR13uEG47
        7VLe1yDfoUxD4ukJHiXNcbkt8jluOFlwwVi7KJtCFgHAy8JufgTl3Gne+D3tkqSBGNQYeGZlIGU
        7cs2/s4m1jMU3
X-Received: by 2002:a17:906:6d12:: with SMTP id m18mr18622291ejr.435.1619443724694;
        Mon, 26 Apr 2021 06:28:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTAoew1cy3xv0PXLFesxN7tVtkXGTKdLFUD1tKu7GQzZWvKsNtpzG29ZVwDbpmC/gjb8duKw==
X-Received: by 2002:a17:906:6d12:: with SMTP id m18mr18622054ejr.435.1619443721952;
        Mon, 26 Apr 2021 06:28:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q25sm14448253edt.51.2021.04.26.06.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 06:28:41 -0700 (PDT)
Subject: Re: [PATCH v2 4/6] KVM: x86: Introduce KVM_GET_SREGS2 /
 KVM_SET_SREGS2
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
 <20210426111333.967729-5-mlevitsk@redhat.com>
 <898a9b18-4578-cb9d-ece7-f45ba5b7bb89@redhat.com>
 <eeaa6c0f6efef926eb606b354052aba8cfef2c21.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <05161b6e-6d85-be14-9e30-e61cb742f6d0@redhat.com>
Date:   Mon, 26 Apr 2021 15:28:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <eeaa6c0f6efef926eb606b354052aba8cfef2c21.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/21 14:56, Maxim Levitsky wrote:
> On Mon, 2021-04-26 at 14:32 +0200, Paolo Bonzini wrote:
>> On 26/04/21 13:13, Maxim Levitsky wrote:
>>> +	if (sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID) {
>>> +
>>> +		if (!is_pae_paging(vcpu))
>>> +			return -EINVAL;
>>> +
>>> +		for (i = 0 ; i < 4 ; i++)
>>> +			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
>>> +
>>> +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
>>> +		mmu_reset_needed = 1;
>>> +	}
>>
>> I think this should also have
>>
>> 	else {
>> 		if (is_pae_paging(vcpu))
>> 			return -EINVAL;
>> 	}
> 
> 
> What about the case when we migrate from qemu that doesn't use
> this ioctl to qemu that does?

Right, that makes sense but then the "else" branch should do the same as 
KVM_SET_SREGS.  Maybe add a "load_pdptrs" bool to __set_sregs_common?

Paolo

