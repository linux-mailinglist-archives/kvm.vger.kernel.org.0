Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FD1374835
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 20:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhEESwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 14:52:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229810AbhEESwA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 14:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620240663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/f6nPtRfydWf5Sc5vWD5jCoaPtMKQTnRZKEd1p88nko=;
        b=H4pfEASiGg9suvP7i39kQwILIzfVcxLREEogA43q11COdIKJHVieBntQEwnqDfzLB92fsD
        xQrIOGkS5HIdpPq+ldXLT8nNupDsIapB3SVCf7RJUqIWFWTvw4u82jUjQ1fyaxcPip6yBs
        ljJX/xlod6YDyp8akJF1y7+SLWPV1eg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-8-LbLNpcOSC_SB7Oy0-JbA-1; Wed, 05 May 2021 14:50:59 -0400
X-MC-Unique: 8-LbLNpcOSC_SB7Oy0-JbA-1
Received: by mail-wr1-f72.google.com with SMTP id p19-20020adfc3930000b029010e10128a04so1063379wrf.3
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 11:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/f6nPtRfydWf5Sc5vWD5jCoaPtMKQTnRZKEd1p88nko=;
        b=pE7pyKrujiGolF8H1kH6DneRNMA2yOzFd75cUsuwe5GEdJU1bPPJhrSwJCK16vRHeZ
         mR1kxaW8sbK/YiwMEAhbD5FTtRhFdIZateRB5TtkdMoyrl0YC6piFznBMcsRWQvWU7Nj
         I5iX8MeQOkowUxx4PFMSjodcMVoE4f8MiQLaAHI2qcu01Ye2O63gOHBkmzfeK6U66RpC
         757EsVU2YGgR1ZqgJ8vFQAx02e1NTSJ13i0qWyHT2p6Dt8hPB3pw+eddAqd0vsII6UwZ
         KoST4wTUei/FMBl3BAqW0uy8M+IMSn6blxee7WuaQDc0paFI0X+xtw3u147M/h1h2eBc
         3x1Q==
X-Gm-Message-State: AOAM532+jceplRBPzasbh6Wjkj3Y9Fu6TcuWJ5h/Lmcc2gsIT961pGGo
        iXr1UxNHfsz5QFhu9OWGcNkNx6M951to7cWBybtfENQ7ys/F3VkTVFYF62qQ1/LpQ3AkVWy+B5X
        i+U03RAfj3meH
X-Received: by 2002:a5d:500d:: with SMTP id e13mr529931wrt.39.1620240658675;
        Wed, 05 May 2021 11:50:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwxXCIdmmj0SyMaEDXgql4qemuG2qYkAnHWyQSXD7fqiXmhrvNUdnf1PYX4saWhQV+HAW5kg==
X-Received: by 2002:a5d:500d:: with SMTP id e13mr529908wrt.39.1620240658448;
        Wed, 05 May 2021 11:50:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k11sm6470865wmj.1.2021.05.05.11.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 11:50:57 -0700 (PDT)
Subject: Re: SRCU dereference check warning with SEV-ES
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        kvm list <kvm@vger.kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>
References: <601f1278-17dd-7124-f328-b865447ca160@amd.com>
 <c65e06ed-2bd8-cac9-a933-0117c99fc856@redhat.com>
 <9bbc82fa-9560-185c-7780-052a3ee963b9@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a6bf7668-f217-4217-501a-f9a12a41beb3@redhat.com>
Date:   Wed, 5 May 2021 20:50:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <9bbc82fa-9560-185c-7780-052a3ee963b9@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 20:39, Tom Lendacky wrote:
> On 5/5/21 11:16 AM, Paolo Bonzini wrote:
>> On 05/05/21 16:01, Tom Lendacky wrote:
>>> Boris noticed the below warning when running an SEV-ES guest with
>>> CONFIG_PROVE_LOCKING=y.
>>>
>>> The SRCU lock is released before invoking the vCPU run op where the SEV-ES
>>> support will unmap the GHCB. Is the proper thing to do here to take the
>>> SRCU lock around the call to kvm_vcpu_unmap() in this case? It does fix
>>> the issue, but I just want to be sure that I shouldn't, instead, be taking
>>> the memslot lock:
>>
>> I would rather avoid having long-lived maps, as I am working on removing
>> them from the Intel code.  However, it seems to me that the GHCB is almost
>> not used after sev_handle_vmgexit returns?
> 
> Except for as you pointed out below, things like MMIO and IO. Anything
> that has to exit to userspace to complete will still need the GHCB mapped
> when coming back into the kernel if the shared buffer area of the GHCB is
> being used.
> 
> Btw, what do you consider long lived maps?  Is having a map while context
> switching back to userspace considered long lived? The GHCB will
> (possibly) only be mapped on VMEXIT (VMGEXIT) and unmapped on the next
> VMRUN for the vCPU. An AP reset hold could be a while, though.

Anything that cannot be unmapped in the same function that maps it, 
essentially.

>> 2) upon an AP reset hold exit, the above patch sets the EXITINFO2 field
>> before the SIPI was received.  My understanding is that the processor will
>> not see the value anyway until it resumes execution, and why would other
>> vCPUs muck with the AP's GHCB.  But I'm not sure if it's okay.
> 
> As long as the vCPU might not be woken up for any reason other than a
> SIPI, you can get a way with this. But if it was to be woken up for some
> other reason (an IPI for some reason?), then you wouldn't want the
> non-zero value set in the GHCB in advance, because that might cause the
> vCPU to exit the HLT loop it is in waiting for the actual SIPI.

Ok.  Then the best thing to do is to pull sev_es_pre_run to the 
prepare_guest_switch callback.

Paolo

