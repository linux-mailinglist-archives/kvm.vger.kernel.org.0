Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C82C1C409A
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgEDQ5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:57:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54149 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728655AbgEDQ5G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 12:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588611425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cA54hjMXQwu2Lvqq0IfxR+bA86FjlLo/DYJm0KvwWBE=;
        b=fvtyd8liSZun1pVrctTopAFzThDo9Toixhd2YiciHwTMC9Gy0+7LjYVcG1sl4sTUr6ZUrh
        SFDXaxlDSgklTyO6IRUJHivj+iA5CyNwZtTNs7WEQOMt81SEYul/N64bZ86IXFzp6+THW4
        BCjZghf3mKbhB+4P1X9+HNx9ojb2eeU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-Zk_y6fv4PNuVldXz63DegQ-1; Mon, 04 May 2020 12:57:03 -0400
X-MC-Unique: Zk_y6fv4PNuVldXz63DegQ-1
Received: by mail-wm1-f70.google.com with SMTP id f81so121402wmf.2
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cA54hjMXQwu2Lvqq0IfxR+bA86FjlLo/DYJm0KvwWBE=;
        b=Z7cbX7gcqGKd3W4I5Tu7YopgT1+C2Prd1MxArgz56Psnu6c0Fi1ZvEojVK8aALacqQ
         lsF8KJ91ShlJnJg0jUEf+R+zGV1fvRkjRMlYx6Zz+l0zMx5vg7zgPC10XjgxywyPHGMp
         BUORD6cPjZf0sGXvZitKkoydF1vVa1ak9AVNLp5HOHYU6NF3sMw1FXc31FBnOSUHu7qH
         9WCpvfzqi5V2rQVuc3NkMQyskRxnmCt9EGwEpmJ5xJfEciQSxKruvfKOoljfKxv2HXQG
         P+Deh5MMj5MaKDyV4eTVXLWlny4K9b7+JjwUA2uE4s7RUeXjstd6i+4pRBsdynQjtH6d
         ap8g==
X-Gm-Message-State: AGi0PuYc/thlkHTrn8UXvtbX+9QJ88IToM/y7uzYJ25ZT+/JoOz8A6ZM
        bHwPN/um66JqUFpfqaQrGDIseR+sj55W+hT0zg1xj5gSAE4iRFdCOlNqEr2W0JnwNbo2IDbY2QV
        Gqsa8PquYWQ7b
X-Received: by 2002:a1c:7416:: with SMTP id p22mr16405973wmc.80.1588611422614;
        Mon, 04 May 2020 09:57:02 -0700 (PDT)
X-Google-Smtp-Source: APiQypLfpkBvwAD0WlLP09KJEHHrrBHKkgnUHm4rVDiq9YqMhWUzzIs80/IV4XB8GGW3iWPsax4ENw==
X-Received: by 2002:a1c:7416:: with SMTP id p22mr16405959wmc.80.1588611422393;
        Mon, 04 May 2020 09:57:02 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id u2sm17818146wrd.40.2020.05.04.09.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:57:01 -0700 (PDT)
Subject: Re: [RESEND PATCH] KVM: x86/pmu: Support full width counting
To:     Like Xu <like.xu@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200427071922.86257-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa182eec-3d0b-1452-19cc-20654190a2ae@redhat.com>
Date:   Mon, 4 May 2020 18:57:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200427071922.86257-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/20 09:19, Like Xu wrote:
> +	if (vmx_supported_perf_capabilities())
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_PDCM);

I think we can always set it, worst case it will be zero.

However, blocking intel_pmu_set_msr altogether is incorrect.  Instead,
you need to:

- list the MSR in msr_based_features_all so that it appears in
KVM_GET_MSR_FEATURE_INDEX_LIST

- return the supported bits in vmx_get_msr_feature

- allow host-initiated writes (as long as they only set supported bits)
of the MSR in intel_pmu_set_msr.

Thanks,

Paolo

