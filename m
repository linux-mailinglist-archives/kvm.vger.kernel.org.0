Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A911460F20F
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiJ0ISX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiJ0ISV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:18:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A6AF88C0
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 01:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666858700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H+zjgwfHgHFBXNtS1dcXbFjT5C6bNkpnBbMlxremMWY=;
        b=exNv1AAoPH87hdkSdMIegQEaIkbtPoC1Gge8wGbCz+H0KaWXI1HSB9WZOYrkHn/ENNTzSA
        Vy1cKV9aISrbb8hUUQw48S72sHY3/SJfGl/k3kccjhDA/CEs2AbT7HQXhIM2FTtOEUE5P5
        F5R8xncC3ilINkEcH6gtmJrXmjN9FHc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-31-n7T2k-UYPnuMjdP9Nw4xuQ-1; Thu, 27 Oct 2022 04:18:17 -0400
X-MC-Unique: n7T2k-UYPnuMjdP9Nw4xuQ-1
Received: by mail-wm1-f70.google.com with SMTP id n19-20020a7bcbd3000000b003c4a72334e7so260831wmi.8
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 01:18:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H+zjgwfHgHFBXNtS1dcXbFjT5C6bNkpnBbMlxremMWY=;
        b=PNYGGnGA0HSse5tnwca2ZfE+iPrDrvrENhvWnbXbvOr8qd+SqCokaP8DoN6eFIT1NC
         dSvNz9U/nnjnpyUjGuwDOAEdENge83P7h+UxVcQAkoYctjWi1dnnnv2U3vHMrO8GR/Ns
         uDHYxNmhbY2MN7vvfkiEcPG4GzptJdNPgEqPvaTVgn1NF1wno5HjPPJzT1MevWDimU4m
         5YvwU2z3nEs3EX+R6hAp+D0feTh7Sl7lkAcySPt8MJTQPN0cZ3i8zAyB5XqWFIX4acaX
         NXnjkzYtZdU6N0h3fqWhk5bfjlVrEfPL9kUCi2GH8Gr+CMxrHcztRz3OnoRJjxicfgMq
         ZO/Q==
X-Gm-Message-State: ACrzQf1UIAH3+om6KXllVOknRsDjIIJ3pnuld5SE4lt1rmyN3k/H89ja
        aPMKWzDUQVHFWR0uZIUv7anx+vZLH2rq2U5PnsVPtw7vRBxsns+N5Qr/XHAIfa9pZzbURY6kJo1
        FsvEddSwajuFm
X-Received: by 2002:adf:ebcf:0:b0:22c:9eb4:d6f6 with SMTP id v15-20020adfebcf000000b0022c9eb4d6f6mr31409127wrn.251.1666858696587;
        Thu, 27 Oct 2022 01:18:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4CgeyUAU3EZlndfaRTAGP3JWCxEXgwxeBo73X8Vdko0Rf33SSC2AqFidTXI1tyqPqoddOuig==
X-Received: by 2002:adf:ebcf:0:b0:22c:9eb4:d6f6 with SMTP id v15-20020adfebcf000000b0022c9eb4d6f6mr31409114wrn.251.1666858696314;
        Thu, 27 Oct 2022 01:18:16 -0700 (PDT)
Received: from ovpn-194-52.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k1-20020a05600c1c8100b003b4fe03c881sm4208779wms.48.2022.10.27.01.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 01:18:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 13/46] KVM: x86: Prepare kvm_hv_flush_tlb() to
 handle L2's GPAs
In-Reply-To: <Y1m0HCMgwJen/NnU@google.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
 <20221021153521.1216911-14-vkuznets@redhat.com>
 <Y1m0HCMgwJen/NnU@google.com>
Date:   Thu, 27 Oct 2022 10:18:14 +0200
Message-ID: <87ilk5u1bt.fsf@ovpn-194-52.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Oct 21, 2022, Vitaly Kuznetsov wrote:
>> To handle L2 TLB flush requests, KVM needs to translate the specified
>> L2 GPA to L1 GPA to read hypercall arguments from there.
>> 
>> No functional change as KVM doesn't handle VMCALL/VMMCALL from L2 yet.
>> 
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>> 
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index fca9c51891f5..df1efb821eb0 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -23,6 +23,7 @@
>>  #include "ioapic.h"
>>  #include "cpuid.h"
>>  #include "hyperv.h"
>> +#include "mmu.h"
>>  #include "xen.h"
>>  
>>  #include <linux/cpu.h>
>> @@ -1908,6 +1909,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  	 */
>>  	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64);
>>  
>> +	if (!hc->fast && is_guest_mode(vcpu)) {
>
> Please add a comment explaining why only "slow" hypercalls need to translate the
> GPA from L2=>L1.
>
> With a comment (and assuming this isn't a bug),

This is intended,

For "slow" hypercalls 'hc->ingpa' is the GPA (or an 'nGPA' -- thus the
patch) in guest memory where hypercall parameters are placed, kvm reads
them with kvm_read_guest() later. For "fast" hypercalls 'ingpa' is a
misnomer as it is not an address but the first parameter (in the 'tlb
flush' case it's 'address space id' which we currently don't
analyze). We may want to add a union in 'struct kvm_hv_hcall' to make
this explicit.

The comment I'm thinking of would be:

"
/*
 * 'Slow' hypercall's first parameter is the address in guest's memory where
 * hypercall parameters are placed. This is either a GPA or a nested GPA when
 * KVM is handling the call from L2 ('direct' TLB flush), translate the address
 * here so the memory can be uniformly read with kvm_read_guest().
 */
"

>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>

-- 
Vitaly

