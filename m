Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B309D1D131B
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 14:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgEMMtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 08:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgEMMtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 08:49:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3687BC061A0C;
        Wed, 13 May 2020 05:49:19 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so20733778wra.7;
        Wed, 13 May 2020 05:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iP01j1nGFSda70n3ErSleGKHSypa0Pi6uR0PO3xQfnA=;
        b=LpaproBuZTVs/ugiIWm7Wck/niaWQtlX00MhYEdhDKkVab43pvnbtbBIyhDPsm7YeN
         AVAtYDyK9R3j2nvBPBv++eP5iN23LQFwDGtQY2J9+VaCskNp8vVsAEDGwT4qBd5FpJem
         iPO8+FzuD4xJnCIVUwOogmqo1Sf3HPFHzMNdAQIZi7rc1FGcXzUQH/UNcsJCJGc/s++7
         /9W7fvdy7AoeDih8dplkVftaLW/YPyuzwucGifKXnVVjg7KuQmOJOGvLXPDe1zg2tqu/
         imKwfixEAewrgply9X0oXjaziGRPdmhdNyboPSmttQNoRWx6qblHeCoaEwc3+YoscRWc
         znJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iP01j1nGFSda70n3ErSleGKHSypa0Pi6uR0PO3xQfnA=;
        b=CJWJJeZI7oXR3cbIMuJzby2cbReRcQyY1/VBolJEn7gx0Prsw4Nz5PXVcvj2NLvzB8
         0cEHua4FWetQtclsdSkRV/IRQt354FB/lg+qlaEgOH2KXE8g/P5BdHkl0slTdz4ypchH
         yjcuECvBWU6uxj1Rgfot9Z6GYrOLgwez56ULXWcL/FMVEum03PsbforsZdJlesLGwKTe
         NyzbhTEu43FSfriyAy6dIEBa25JbJNMPE9rbhCvTpPwwJqmp1Ws3NMNArIRmEBSahH59
         fb50FD2VwXnyFYHMEwKl7h+RB604mf0z88V8r/HzNlq4rwEx0fikvlIU3u/8cYxy7+Lx
         Kh/w==
X-Gm-Message-State: AGi0PuYpPiCeGBpu7wXV1Frk/PUKZTjpKX7RBiveHZGmqdw1WjP3iDfr
        LnZaGo0W4egYddLFwLL4WlN3fkd4nOM=
X-Google-Smtp-Source: APiQypLVuooIz/ru7rnBf1UvsjPOxqEUPQ19VDhjW9yYEhxHZ7nfgY2KDJUWZR6SG21Swf8+zPlj7g==
X-Received: by 2002:adf:ea90:: with SMTP id s16mr31110947wrm.19.1589374157860;
        Wed, 13 May 2020 05:49:17 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id v126sm7086451wmb.4.2020.05.13.05.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 05:49:17 -0700 (PDT)
Date:   Wed, 13 May 2020 15:49:15 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH v11 2/7] x86/kvm/hyper-v: Simplify addition for custom
 cpuid leafs
Message-ID: <20200513124915.GM2862@jondnuc>
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-3-arilou@gmail.com>
 <20200513092404.GB29650@rvkaganb.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200513092404.GB29650@rvkaganb.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2020, Roman Kagan wrote:
>On Fri, Apr 24, 2020 at 02:37:41PM +0300, Jon Doron wrote:
>> Simlify the code to define a new cpuid leaf group by enabled feature.
>>
>> This also fixes a bug in which the max cpuid leaf was always set to
>> HYPERV_CPUID_NESTED_FEATURES regardless if nesting is supported or not.
>
>I'm not sure the bug is there.  My understanding is that
>HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS is supposed to provide the range
>of leaves that return meaningful information.
>HYPERV_CPUID_NESTED_FEATURES *can* return meaningful information
>regardless of whether nested virt is active.
>
>So I'd rather skip reducing the returned set if !evmcs_ver.  The
>returned set is sparse in .function anyway; anything that isn't there
>will just return zeros to the guest.
>
>Changing the cpuid is also guest-visible so care must be taken with
>this.
>

To be honest from my understanding of the TLFS it states:
"The maximum input value for hypervisor CPUID information."

So we should not expose stuff we wont "answer" to, I agree you can 
always issue CPUID to any leaf and you will get zeroes but if we try to 
follow TLFS it sounds like this needs to be capped here.

>> Any new CPUID group needs to consider the max leaf and be added in the
>> correct order, in this method there are two rules:
>> 1. Each cpuid leaf group must be order in an ascending order
>> 2. The appending for the cpuid leafs by features also needs to happen by
>>    ascending order.
>
>It looks like unnecessary complication.  I think all you need to do to
>simplify adding new leaves is to add a macro to hyperv-tlfs.h, say,
>HYPERV_CPUID_MAX_PRESENT_LEAF, define it to
>HYPERV_CPUID_NESTED_FEATURES, and redefine once another leaf is added
>(compat may need to be taken care of).
>
>Thanks,
>Roman.
>

I suggest you will see the discussion around v8 of this patchset where I 
simply set HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS to be the maximum 
value, but then we noticed this issue and hence why this patch was 
revised to current form. (I agree it could be done under the TLFS header 
file but as I understand from other emails from Michal it's going to get 
re-worked a bit and splitted, still have not got into the details of 
that work).

Thanks,
-- Jon.

>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: Jon Doron <arilou@gmail.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 46 ++++++++++++++++++++++++++++++-------------
>>  1 file changed, 32 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index bcefa9d4e57e..ab3e9dbcabbe 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1785,27 +1785,45 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args)
>>  	return kvm_hv_eventfd_assign(kvm, args->conn_id, args->fd);
>>  }
>>
>> +/* Must be sorted in ascending order by function */
>> +static struct kvm_cpuid_entry2 core_cpuid_entries[] = {
>> +	{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
>> +	{ .function = HYPERV_CPUID_INTERFACE },
>> +	{ .function = HYPERV_CPUID_VERSION },
>> +	{ .function = HYPERV_CPUID_FEATURES },
>> +	{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
>> +	{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
>> +};
>> +
>> +static struct kvm_cpuid_entry2 evmcs_cpuid_entries[] = {
>> +	{ .function = HYPERV_CPUID_NESTED_FEATURES },
>> +};
>> +
>> +#define HV_MAX_CPUID_ENTRIES \
>> +	(ARRAY_SIZE(core_cpuid_entries) +\
>> +	 ARRAY_SIZE(evmcs_cpuid_entries))
>> +
>>  int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>>  				struct kvm_cpuid_entry2 __user *entries)
>>  {
>>  	uint16_t evmcs_ver = 0;
>> -	struct kvm_cpuid_entry2 cpuid_entries[] = {
>> -		{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
>> -		{ .function = HYPERV_CPUID_INTERFACE },
>> -		{ .function = HYPERV_CPUID_VERSION },
>> -		{ .function = HYPERV_CPUID_FEATURES },
>> -		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
>> -		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
>> -		{ .function = HYPERV_CPUID_NESTED_FEATURES },
>> -	};
>> -	int i, nent = ARRAY_SIZE(cpuid_entries);
>> +	struct kvm_cpuid_entry2 cpuid_entries[HV_MAX_CPUID_ENTRIES];
>> +	int i, nent = 0;
>> +
>> +	/* Set the core cpuid entries required for Hyper-V */
>> +	memcpy(&cpuid_entries[nent], &core_cpuid_entries,
>> +	       sizeof(core_cpuid_entries));
>> +	nent = ARRAY_SIZE(core_cpuid_entries);
>>
>>  	if (kvm_x86_ops.nested_get_evmcs_version)
>>  		evmcs_ver = kvm_x86_ops.nested_get_evmcs_version(vcpu);
>>
>> -	/* Skip NESTED_FEATURES if eVMCS is not supported */
>> -	if (!evmcs_ver)
>> -		--nent;
>> +	if (evmcs_ver) {
>> +		/* EVMCS is enabled, add the required EVMCS CPUID leafs */
>> +		memcpy(&cpuid_entries[nent], &evmcs_cpuid_entries,
>> +		       sizeof(evmcs_cpuid_entries));
>> +		nent += ARRAY_SIZE(evmcs_cpuid_entries);
>> +	}
>>
>>  	if (cpuid->nent < nent)
>>  		return -E2BIG;
>> @@ -1821,7 +1839,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>>  		case HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS:
>>  			memcpy(signature, "Linux KVM Hv", 12);
>>
>> -			ent->eax = HYPERV_CPUID_NESTED_FEATURES;
>> +			ent->eax = cpuid_entries[nent - 1].function;
>>  			ent->ebx = signature[0];
>>  			ent->ecx = signature[1];
>>  			ent->edx = signature[2];
>> --
>> 2.24.1
>>
