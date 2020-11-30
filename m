Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9D2C8C76
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 19:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgK3SRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 13:17:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729542AbgK3SRJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 13:17:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606760142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FiyoWyuNSHuyDR9hIsFud/925yPSvN+8hf0ndeRVCIQ=;
        b=M8x/lZ4fPsktqIX7tMwLmP2jjH892DJiOabPfjxjrHmuUNOw3thB/IoFpfNfo1d61sBChI
        C0k9jh6b8WvAitSPLBOjeNzqAcgYc9TLUPyZ/h2fsON0qNTUturQHIinPtEkA3oGenGj+I
        BrFFG04bc6sUNmE1iz4DyQADzoeAsM8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-x70iMIZENGSssatdVbsSJA-1; Mon, 30 Nov 2020 13:15:40 -0500
X-MC-Unique: x70iMIZENGSssatdVbsSJA-1
Received: by mail-ed1-f71.google.com with SMTP id s7so7193350eds.17
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:15:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FiyoWyuNSHuyDR9hIsFud/925yPSvN+8hf0ndeRVCIQ=;
        b=fvAmBW6rPMUE7EoWKEDvofzuIB17n84vv6rNhhKKnxw+aFiz2DKqV2Ujv/JdE7O+S5
         Wknbr1zGIvFxvuHJ5zjrxmjJ9b7thSzb18KDYJTTJMN4VZf9nCMRZdqp6TW90mnx8Gsh
         5MVCdftJa8JyQKGnxC2me4WEidNt6gbxBX0LLXER7nqZRsRXRe0mXRgSyL2aqpQWktMw
         WIfwppZJ2icSMaiLvssNFPcWaeDuCO/pxKqkrDH2MHA0kaGb9+rlTm/Fld1BndbITdMd
         I9U2wuBI5GXKnqapfoET1ODp7xt47gz/zvS8DvhCyD5PyRkwMuR7DLFsP05BSEz0h/+G
         TJnA==
X-Gm-Message-State: AOAM5312FR5V1ukf3YnBLzEMKKLKWGK6JfLnDFbpmliWF08HkAM1WUWl
        0mfThQHTKzdQhQZOsCs4oMDhxvRZmfOzdNkczax7cHjDUXpq6yPjwZJAupVeT6gPeyCuzi2cDwI
        1dP3QpqFffJm1
X-Received: by 2002:a05:6402:312b:: with SMTP id dd11mr7119190edb.308.1606760137212;
        Mon, 30 Nov 2020 10:15:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzb6sVeMXU3dxEPsQZSrjgkDPkhPZNeXztr8mJq/HGL0Rusiv8nEhQip0Ml0X4YrW7lewwimA==
X-Received: by 2002:a05:6402:312b:: with SMTP id dd11mr7118999edb.308.1606760135721;
        Mon, 30 Nov 2020 10:15:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r9sm1351828ejd.38.2020.11.30.10.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 10:15:34 -0800 (PST)
Subject: Re: [RFC PATCH 22/35] KVM: SVM: Add support for CR0 write traps for
 an SEV-ES guest
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <68f885b63b18e5c72eae92c9c681296083c0ccd8.1600114548.git.thomas.lendacky@amd.com>
 <20200914221353.GJ7192@sjchrist-ice>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <08c28615-e16e-fe5d-4f04-24ec39387c7d@redhat.com>
Date:   Mon, 30 Nov 2020 19:15:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20200914221353.GJ7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/09/20 00:13, Sean Christopherson wrote:
>> +static void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0,
>> +			     unsigned long cr0)
> What about using __kvm_set_cr*() instead of kvm_post_set_cr*()?  That would
> show that __kvm_set_cr*() is a subordinate of kvm_set_cr*(), and from the
> SVM side would provide the hint that the code is skipping the front end of
> kvm_set_cr*().

No, kvm_post_set_cr0 is exactly the right name because it doesn't set 
any state.  __kvm_set_cr0 tells me that it is a (rarely used) way to set 
CR0, which this function isn't.

Sorry Tom for not catching this earlier.

Paolo

>> +{
>> +	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
>> +
>> +	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>> +		kvm_clear_async_pf_completion_queue(vcpu);
>> +		kvm_async_pf_hash_reset(vcpu);
>> +	}
>> +
>> +	if ((cr0 ^ old_cr0) & update_bits)
>> +		kvm_mmu_reset_context(vcpu);
>> +
>> +	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
>> +	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
>> +	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>> +		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
>> +}
>> +
>>   int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>>   {
>>   	unsigned long old_cr0 = kvm_read_cr0(vcpu);
>>   	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
>> -	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
>>   
>>   	cr0 |= X86_CR0_ET;
>>   
>> @@ -842,22 +860,23 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>>   
>>   	kvm_x86_ops.set_cr0(vcpu, cr0);
>>   
>> -	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>> -		kvm_clear_async_pf_completion_queue(vcpu);
>> -		kvm_async_pf_hash_reset(vcpu);
>> -	}
>> +	kvm_post_set_cr0(vcpu, old_cr0, cr0);

