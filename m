Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA365E91A
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 11:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjAEKiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 05:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbjAEKiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 05:38:14 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F49395DF;
        Thu,  5 Jan 2023 02:38:12 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d4so27695320wrw.6;
        Thu, 05 Jan 2023 02:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CW10rsYbYXdLKIgJ082Jp7J1CjAJchYjHoksJUpD20M=;
        b=bgdiXrwUjzknqntCCXHH54/YPHqNV4l/VUPOpQEg/UEzwmZhtsftHO8GMM9ah6lh5D
         /cQmaWMyTt6j0VBnqIXDIRNbfB4iN8hT6aEfF0TVa7CtW93p+wY32vgtm+eizOULhCS7
         u1LwTDBLiKCLy44GwKQ/hbUSwTvIsxZgTG7Xu+sMbFvWo6/7D2zzu3WetJIXMr+07hGA
         emzFpzI4IJFNsrcpv+HsZSgfS7qJXYitMECzpjlcRHZSKQ9b2CSZ4sOon4fqeVN2G0p5
         bvwGB6m84twjuHX27+31tLUcKW08hvgtwrM8GdoxooMDQBGVuhwzLKB6oPslECcs+FGG
         9yKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CW10rsYbYXdLKIgJ082Jp7J1CjAJchYjHoksJUpD20M=;
        b=RDxweRmtB4BhZ1hKipg8JA9iA3MgBDZsHB+xQHUN2C0ZDugVKqROyaEBAOlgyH1/mJ
         X8Z1i7xh/wyODfwLy4W4pFZGaU+JBUiy1JKzmAG0Z/QKCp2dY7y3cLs7grDu8zW+18el
         7G+HPgOdAmZssDa31IWQvSxgKq7Mh2hlzz95V7SsXGnquBY/Y6d4Lj3hdxeov4dpXpwd
         rJ8iD1WABGt2zskkc0rN9Hc3Hl0RHVcunGyU08MWQCNxk72P+ciq4+1/9imvK+doMW9U
         DUSsQoVZUfp40hOKRRP0W+CkLOE4vtYAtT38tUBlNVLR+ZHsTXLNs65nMrNlnxCq1lgl
         gZUQ==
X-Gm-Message-State: AFqh2krUwSoJDavFv7GeQHdFwG7h+VUBXXj18ZwpWf9v9zb1GFXbYQp5
        /OlAbd1Y5Uta/ItOm19WOoY=
X-Google-Smtp-Source: AMrXdXtBYsecr590alx5BnHooWMq9Q7/VNrR1KlOpdJzkFdVT7xcAfrvr08CIgfPq+kmLlZ6zph0Iw==
X-Received: by 2002:adf:e449:0:b0:27c:fdb:cfef with SMTP id t9-20020adfe449000000b0027c0fdbcfefmr21829988wrm.49.1672915091252;
        Thu, 05 Jan 2023 02:38:11 -0800 (PST)
Received: from [10.95.148.22] (54-240-197-226.amazon.com. [54.240.197.226])
        by smtp.gmail.com with ESMTPSA id i13-20020a5d438d000000b0029e1aa67fd2sm7583342wrq.115.2023.01.05.02.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 02:38:09 -0800 (PST)
Message-ID: <82fbc53e-be3e-b516-2420-dc27e5b811e8@gmail.com>
Date:   Thu, 5 Jan 2023 10:38:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v6 1/2] KVM: x86/cpuid: generalize
 kvm_update_kvm_cpuid_base() and also capture limit
To:     Sean Christopherson <seanjc@google.com>,
        Paul Durrant <pdurrant@amazon.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <20221220134053.15591-1-pdurrant@amazon.com>
 <20221220134053.15591-2-pdurrant@amazon.com> <Y7XU2R0f3pCYF9uz@google.com>
Content-Language: en-US
From:   Paul Durrant <xadimgnik@gmail.com>
In-Reply-To: <Y7XU2R0f3pCYF9uz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/01/2023 19:34, Sean Christopherson wrote:
> On Tue, Dec 20, 2022, Paul Durrant wrote:
>> A sunsequent patch will need to acquire the CPUID leaf range for emulated
>> Xen so explicitly pass the signature of the hypervisor we're interested in
>> to the new function. Also introduce a new kvm_hypervisor_cpuid structure
>> so we can neatly store both the base and limit leaf indices.
>>
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>> ---
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>>
>> v6:
>>   - New in this version
>> ---
>>   arch/x86/include/asm/kvm_host.h |  7 ++++++-
>>   arch/x86/kvm/cpuid.c            | 15 ++++++++-------
>>   2 files changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index f35f1ff4427b..ff201ad35551 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -710,6 +710,11 @@ struct kvm_queued_exception {
>>   	bool has_payload;
>>   };
>>   
>> +struct kvm_hypervisor_cpuid {
>> +	u32 base;
>> +	u32 limit;
>> +};
> 
> Probably makes sense to place this above "struct kvm_vcpu_xen" right away to
> avoid the (very minor) churn.
> 

Sure.

>>   struct kvm_vcpu_arch {
>>   	/*
>>   	 * rip and regs accesses must go through
>> @@ -826,7 +831,7 @@ struct kvm_vcpu_arch {
>>   
>>   	int cpuid_nent;
>>   	struct kvm_cpuid_entry2 *cpuid_entries;
>> -	u32 kvm_cpuid_base;
>> +	struct kvm_hypervisor_cpuid kvm_cpuid;
>>   
>>   	u64 reserved_gpa_bits;
>>   	int maxphyaddr;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 0b5bf013fcb8..2468720f8d84 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -180,12 +180,13 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
>>   	return 0;
>>   }
>>   
>> -static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
>> +static void kvm_update_hypervisor_cpuid(struct kvm_vcpu *vcpu, const char *hypervisor_signature,
> 
> Please wrap.  The 80 char limit is a soft limit, but should still be honored unless
> there's a good reason to run over.

Ok.

> 
> I also vote to name the param "sig" to keep line lengths short.
> 
>> +					struct kvm_hypervisor_cpuid *hypervisor_cpuid)
> 
> Since the struct is a 64-bit value, what about making this a pure getter that
> returns a copy?
> 
> static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
> 							    const char *sig)
> {
> 	struct kvm_hypervisor_cpuid cpuid = {};
> 	struct kvm_cpuid_entry2 *entry;
> 	u32 function;
> 
> 	for_each_possible_hypervisor_cpuid_base(cpuid.base) {
> 		entry = kvm_find_cpuid_entry(vcpu, function);
> 
> 		if (entry) {
> 			u32 signature[3];
> 
> 			signature[0] = entry->ebx;
> 			signature[1] = entry->ecx;
> 			signature[2] = entry->edx;
> 
> 			if (!memcmp(signature, sig, sizeof(signature))) {
> 				cpuid.base = function;
> 				cpuid.limit = entry->eax;
> 				break;
> 			}
> 		}
> 	}
> 
> 	return cpuid;
> }
> 
> 
> 	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
> 	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);

Yes, if that's preferable then no problem.

   Paul

