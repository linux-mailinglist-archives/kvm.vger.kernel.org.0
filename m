Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B25F48743C
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 09:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346099AbiAGIpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 03:45:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236390AbiAGIpp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 03:45:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641545144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pJvdwM0wIIO+MMw5O2YidshZCxNzHMhgMOga0XHPFE4=;
        b=cPP9S6oXPBcU87kK3OE2Bd1LfneBrbZRhbPZ4gg4TZq29hVBdoHtGvNWTjbvgYHKT38qCL
        859QJa7n/AZ/5Ldt4wZbAHuZQ01z2mopcWOYSC6pHM/4QplUYaHAdiI0l+MPi4/yOt6014
        QwvzVppGsEmfOcAIFigI2VRh1lFoOu4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-hgTJS0dvPoG8kBz_hE2ZQQ-1; Fri, 07 Jan 2022 03:45:43 -0500
X-MC-Unique: hgTJS0dvPoG8kBz_hE2ZQQ-1
Received: by mail-wr1-f72.google.com with SMTP id a11-20020adffb8b000000b001a0b0f4afe9so1981740wrr.13
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 00:45:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pJvdwM0wIIO+MMw5O2YidshZCxNzHMhgMOga0XHPFE4=;
        b=vsrzDQ7J+CAGUpRF1mF2U11oTkF9Gyn/UYrGTuEDBc6RXVZyxZenB7DyTVbmM11GHA
         GTeUYjAimP1hbcaEocHgPNJ64M/17EOZb314vtG/eLtgG+0YdGgptbyLgBHpkYdrTx6C
         baGs82jFBvvjtmNSxw/mtd0Gz2SJwgr+kaoibgdZ4v4x6H6/iYAnUHt4opfaattVSrUL
         qpLlVu6sYXTKUw5e0ojMxKx6dqu0fHe+Kl3h/rm5rXwG5T8WZcnPqE9IrieyBmQhmJEY
         G7eyWQe2a+Q8d3+ZyUHRkqqYa3Q5IhlcYZwVTpc0839K9FGjAOJm2qt+Y9siWY8fg3S4
         Ks/w==
X-Gm-Message-State: AOAM532GBk0O//DUdjlDE6QWtePSyCvdDQzdaJ/Whg2a9mX0zWUXf2Vd
        phYyd3yNtPJr4XB/lzH3zIJ+jY9GRb9S5el2wJkC/2S6EnP2Oj01bOkjsy0Cd6sCN3bODNy9/Wa
        2pqfJZT3PxINk
X-Received: by 2002:a5d:47c7:: with SMTP id o7mr54569365wrc.642.1641545142515;
        Fri, 07 Jan 2022 00:45:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLAm59DpFY5G+3MCnkpoiNNNcWyFetrQkrVEx7412q7wq9YccEuMXwcnXpg+/qgwcRxCGMWw==
X-Received: by 2002:a5d:47c7:: with SMTP id o7mr54569349wrc.642.1641545142353;
        Fri, 07 Jan 2022 00:45:42 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 6sm3297942wmo.42.2022.01.07.00.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 00:45:41 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: nVMX: Rename vmcs_to_field_offset{,_table} to
 vmcs12_field_offset{,_table}
In-Reply-To: <Ydd9C7A56JtpSWnu@google.com>
References: <20211214143859.111602-1-vkuznets@redhat.com>
 <20211214143859.111602-4-vkuznets@redhat.com>
 <Ydd9C7A56JtpSWnu@google.com>
Date:   Fri, 07 Jan 2022 09:45:40 +0100
Message-ID: <87czl4orwr.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Dec 14, 2021, Vitaly Kuznetsov wrote:
>> vmcs_to_field_offset{,_table} may sound misleading as VMCS is an opaque
>> blob which is not supposed to be accessed directly. In fact,
>> vmcs_to_field_offset{,_table} are related to KVM defined VMCS12 structure.
>> 
>> No functional change intended.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
>> index 2a45f026ee11..13e2bd017538 100644
>> --- a/arch/x86/kvm/vmx/vmcs12.h
>> +++ b/arch/x86/kvm/vmx/vmcs12.h
>> @@ -361,10 +361,10 @@ static inline void vmx_check_vmcs12_offsets(void)
>>  	CHECK_OFFSET(guest_pml_index, 996);
>>  }
>>  
>> -extern const unsigned short vmcs_field_to_offset_table[];
>> +extern const unsigned short vmcs12_field_offset_table[];
>
> While we're tweaking names, what about dropping "table" and calling this
> vmcs12_field_offsets?
>

Ok.

>>  extern const unsigned int nr_vmcs12_fields;
>>  
>> -static inline short vmcs_field_to_offset(unsigned long field)
>> +static inline short vmcs12_field_offset(unsigned long field)
>
> And get_vmcs12_field_offset() here to make it more obvious that it's translating
> something to an offset, which is communicated by the "to" in the current name.
>

I think we could've even used just 'vmcs12_field_offset()' as I don't
see any ambiguity in it but 4 additional letters shouldn't hurt.

>>  {
>>  	unsigned short offset;
>>  	unsigned int index;
>> @@ -377,7 +377,7 @@ static inline short vmcs_field_to_offset(unsigned long field)
>>  		return -ENOENT;
>>  
>>  	index = array_index_nospec(index, nr_vmcs12_fields);
>> -	offset = vmcs_field_to_offset_table[index];
>> +	offset = vmcs12_field_offset_table[index];
>>  	if (offset == 0)
>>  		return -ENOENT;
>>  	return offset;
>> -- 
>> 2.33.1
>> 
>

-- 
Vitaly

