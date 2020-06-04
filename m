Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF2A1EE879
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgFDQWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:22:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57600 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729811AbgFDQWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 12:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591287720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IFnB5YH86FkA9ElQ2/nU7J/Gt0lAQ+ZY8dNiGTQihDo=;
        b=CCuKDOT00dra0guv5+YZxzKaKLwSp199WBRTfijRBH7gpcPc5sZcOljG9mJRdpPwybI/V9
        s6FjB+Ph596ew14n57K2JByqAbd9FKvQ5Jc1dPu2CJawFMU4vvPdb92YPK8Ym0IFNmC8AY
        SsJiI6yPOevpiZwICNwy95UZU/bH9Bs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-m7EK4LYKPra3hhst-vobdw-1; Thu, 04 Jun 2020 12:21:58 -0400
X-MC-Unique: m7EK4LYKPra3hhst-vobdw-1
Received: by mail-wm1-f72.google.com with SMTP id k185so1938924wme.8
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 09:21:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IFnB5YH86FkA9ElQ2/nU7J/Gt0lAQ+ZY8dNiGTQihDo=;
        b=Ci3PeaIrHx0+c1YceopmhHkEo7JEOLCEjP1PPacT2OXn8kT//lIXCBC0YEtl8ucW0I
         Ro9CJoo8e/5F+hHlEm1/8Ez3erYG2GOynoLcf47GFoaQRPATd/Dr+azBpNCYGkRsarLr
         oL5gGAl5gHNE7Mg2+0RTGNgcBvwhknjZbw7MxkZ0dwsfCq5vSDQ0fswizVXAR9qwpXXp
         qKW4AEugoNY9TtioeXCLOrZp3BntQgp2WOL5z0b62GBgPSCfc0hrG1gbEAUWB3MokPiP
         rMRtnstsM1nduOuS2DLERlaoMxUkorRTX9VAhBJ1TIVv3Jk64QwtAowwR47JVK7gLzEG
         n78w==
X-Gm-Message-State: AOAM531zkJocMIAjp8AR6aZqJM5d3tT9ULYs8auyLWjSaKIWmMpS8RhD
        Ow3pnnn3lLUXSiZjb7jlQAsu1YgxIIY7ZvbWCkKwHQ60ezZkZ5l/TPykFSO7nKe/DmHde4Hebsb
        6atGAP3ysP8EQ
X-Received: by 2002:a7b:c399:: with SMTP id s25mr4991224wmj.185.1591287714283;
        Thu, 04 Jun 2020 09:21:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLoi5S0xA4EpyLYB78gRmIzq6SOAKHh8FD57JzJ5oWW57P3f0077C/yNMMqKxBeCYMsxvChw==
X-Received: by 2002:a7b:c399:: with SMTP id s25mr4991205wmj.185.1591287714053;
        Thu, 04 Jun 2020 09:21:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id 62sm8888268wrm.1.2020.06.04.09.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 09:21:53 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: Assign correct value to array.maxnent
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200604041636.1187-1-xiaoyao.li@intel.com>
 <20200604151233.GC30223@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <16f6f2f6-f10a-b385-2ce1-7a3515633b43@redhat.com>
Date:   Thu, 4 Jun 2020 18:21:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200604151233.GC30223@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 17:12, Sean Christopherson wrote:
> On Thu, Jun 04, 2020 at 12:16:36PM +0800, Xiaoyao Li wrote:
>> Delay the assignment of array.maxnent to use correct value for the case
>> cpuid->nent > KVM_MAX_CPUID_ENTRIES.
>>
>> Fixes: e53c95e8d41e ("KVM: x86: Encapsulate CPUID entries and metadata in struct")
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>> v2:
>>    - remove "const" of maxnent to fix build error.
>> ---
>>  arch/x86/kvm/cpuid.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 253b8e875ccd..3d88ddf781d0 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -426,7 +426,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
>>  
>>  struct kvm_cpuid_array {
>>  	struct kvm_cpuid_entry2 *entries;
>> -	const int maxnent;
>> +	int maxnent;
>>  	int nent;
>>  };
>>  
>> @@ -870,7 +870,6 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>>  
>>  	struct kvm_cpuid_array array = {
>>  		.nent = 0,
>> -		.maxnent = cpuid->nent,
>>  	};
>>  	int r, i;
>>  
>> @@ -887,6 +886,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>>  	if (!array.entries)
>>  		return -ENOMEM;
>>  
>> +	array.maxnent = cpuid->nent;
> 
> Eh, I'd vote to just do:
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 253b8e875ccd..1e5b1ee75a76 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -870,7 +870,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
> 
>         struct kvm_cpuid_array array = {
>                 .nent = 0,
> -               .maxnent = cpuid->nent,
> +               .maxnent = min(cpuid->nent, (u32)KVM_MAX_CPUID_ENTRIES),
>         };
>         int r, i;
> 

Both are fine, I've queued Xiaoyao's patch.

Paolo

