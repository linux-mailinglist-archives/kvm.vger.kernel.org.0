Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772B817568D
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 10:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgCBJDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 04:03:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48226 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727104AbgCBJDY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Mar 2020 04:03:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583139802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zh8cgchJm1y3v+DF2yCaLs1qahz0gPLON0uwqCUOxqk=;
        b=HrYmg+euQHQWv0TvJAcWx6crGLCRvphnXsr4FMzx2DUJp9noXN0/cpyQyqMjhap25BzyST
        V++z581Wj+Kl9ke2Q84JNbpy9rzpe2c2Vp+/B69LmgNz5vVf8ulczQxM2gZGU8KRCByzEK
        pNJONW+jZf/kovu3liSTzD+0ASO4gyI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-K3t7KUAhPnSgXKKOWeP0Kw-1; Mon, 02 Mar 2020 04:03:19 -0500
X-MC-Unique: K3t7KUAhPnSgXKKOWeP0Kw-1
Received: by mail-wr1-f70.google.com with SMTP id 72so5497333wrc.6
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 01:03:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zh8cgchJm1y3v+DF2yCaLs1qahz0gPLON0uwqCUOxqk=;
        b=NrpTwbpBP730JOnordZgIHNZuhToZME7Y+uMOzaix9R98WoVzJkW+HJKQ8Wykl1CaL
         HaBVNAf50QfyjpfaK3oyOkf4jXoxrGufTmkWYmYnxDcQou7MmL5pNA/J6iWHkjKr3pXI
         i2Nv72O36kmVgWA4PtMnQ5TU24iBNbTqSKRE44NkJtVi2h0xEYM2qMgEyAVCCtTUjQat
         oZ00akbUhtNtL7KrYcsP5SKHGthZtLuRilgONGN0MCn/iTZrA/b246BmneXr1wX8wwLb
         OL4QsYv4Zkxw8h6pLnq4/ibhvYZSV8rnxn6WiPa4d/875vpb2AwBoNCkBH1LlXPHScJ4
         5qmg==
X-Gm-Message-State: APjAAAWyir2FwCgwL7D1JgeeEs6tAxS0YPPC4WsquA43EMnDagHphDNP
        opiBZolFtb6x6ObQZ1+258S/sTd+gN/h5Na7SAk8UyxresXwQWfU6NPZ/8Am62yPa6+W95hQxGV
        70W84m9CuQsFz
X-Received: by 2002:a5d:4b82:: with SMTP id b2mr21266774wrt.102.1583139798117;
        Mon, 02 Mar 2020 01:03:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqyC8l2PJhEaf0MiIHxDflEbFnI0+GLughJFRf0goS12IzY5n+bQfTBb90jKAb24wmRK/g4wRA==
X-Received: by 2002:a5d:4b82:: with SMTP id b2mr21266722wrt.102.1583139797799;
        Mon, 02 Mar 2020 01:03:17 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id w1sm14213034wmc.11.2020.03.02.01.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 01:03:17 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/61] KVM: x86: Introduce KVM cpu caps
In-Reply-To: <20200229183219.GA22451@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <87wo8ak84x.fsf@vitty.brq.redhat.com> <20200229183219.GA22451@linux.intel.com>
Date:   Mon, 02 Mar 2020 10:03:16 +0100
Message-ID: <8736ari0x7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Tue, Feb 25, 2020 at 04:18:38PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> >
>> >   7. Profit!
>> 
>> Would it be better or worse if we eliminate set_supported_cpuid() hook
>> completely by doing an ugly hack like (completely untested):
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index a2a091d328c6..5ad291d48e1b 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1145,8 +1145,6 @@ struct kvm_x86_ops {
>>  
>>         void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
>>  
>> -       void (*set_supported_cpuid)(struct kvm_cpuid_entry2 *entry);
>> -
>>         bool (*has_wbinvd_exit)(void);
>>  
>>         u64 (*read_l1_tsc_offset)(struct kvm_vcpu *vcpu);
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index e8beb1e542a8..88431fc02797 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -749,6 +749,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
>>  		break;
>>  	}
>> +	case 0x8000000A:
>> +		if (boot_cpu_has(X86_FEATURE_SVM)) {
>> +			entry->eax = 1; /* SVM revision 1 */
>> +			entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
>> +					   ASID emulation to nested SVM */
>> +			entry->ecx = 0; /* Reserved */
>> +			entry->edx = 0; /* Per default do not support any
>> +					   additional features */
>
> Lucky thing that you suggested this change, patch ("KVM: SVM: Convert
> feature updates from CPUID to KVM cpu caps") was buggy in that clearing
> entry->edx here would wipe out all X86_FEATURE_NRIPS and X86_FEATURE_NPT.
> Only noticed it when moving this code. 
>

I plan to give your v2 a spin on AMD Epyc, just in case)

-- 
Vitaly

