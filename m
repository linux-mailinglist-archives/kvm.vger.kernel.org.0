Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBD94322B0
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 17:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhJRPXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 11:23:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232303AbhJRPXE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 11:23:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634570452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=weGzz/RU3tcYXCDKayytqHwl63UjBOGSEo1p1tbZCGw=;
        b=VbbEvpCD5d2Xx0XsKJ7xF9WF7kd5JITxQ4vQWSEcoGZSuXWHLWSg0gh21BBBu+CBzkxGEC
        BCqFNXQVbjhR/zwyPAPcH40X+v+4w1PirQhorxAOh0EgO2CaSnsP4wFcPKlVNnMYEiYTUZ
        WYmgoC2bXIRYylIKvN4Hwm8HghwBZGQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-63efWY8jOeK7JOKWw3-rWA-1; Mon, 18 Oct 2021 11:20:51 -0400
X-MC-Unique: 63efWY8jOeK7JOKWw3-rWA-1
Received: by mail-wr1-f69.google.com with SMTP id j19-20020adfb313000000b00160a9de13b3so8968476wrd.8
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 08:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=weGzz/RU3tcYXCDKayytqHwl63UjBOGSEo1p1tbZCGw=;
        b=X6WWRIn7xBFObQJPyVA7rymPahBuks+3QVfSX33yA3ALySTORNnDgsPIFhrEcqzqGF
         Nytm64hx8tWmLMFsp6P2iNr4tS/OeW4HyrhvkpDWTWYx8DE/godvV7k5QWH/Xm+VJIDs
         SlnBMkN0h71v+i+DlYyYHyGLsyhOaaWU1w2PBbcx/PZW9w/mh3sSaHeR921Kw9U5k96+
         Iess9V8CqGoqc/wlBNVmgKIX9SkYJt+er3Gw2GtBJuEIM9pCFzBvvdxv60DFowH1qawL
         BaujW+Gd4UWZ4LESFLyicwuI9KmC+Pt5qoisCeAffKjjo5YSodtlaJgW4GP3KA48BRSC
         Ko1Q==
X-Gm-Message-State: AOAM533V76E9JgjLEMzIc0JHdc9E0n54XlzIPNp1oPdrvT9EXEOH6kjb
        pH3jw7WxLdTmH1JGfQxftegNH/4hhI0eT56VHdo5CqVutpsC572fVHjlURpo09fI76mv4UG0Ttp
        cqaDtKhIdwkQv
X-Received: by 2002:adf:b348:: with SMTP id k8mr36302727wrd.435.1634570450120;
        Mon, 18 Oct 2021 08:20:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSU9ALI4vxdT0LUFYoXuruFKnLY/vFTpcmEgvyCKPpz+nFfh4q+eQTHiETxKUF6r7bU2FsEA==
X-Received: by 2002:adf:b348:: with SMTP id k8mr36302694wrd.435.1634570449934;
        Mon, 18 Oct 2021 08:20:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l5sm12672972wrq.77.2021.10.18.08.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 08:20:49 -0700 (PDT)
Message-ID: <96d0ff43-9b25-5f07-3fe8-7bd245ce06e4@redhat.com>
Date:   Mon, 18 Oct 2021 17:20:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 7/7] KVM: VMX: Only context switch some PT MSRs when
 they exist
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-8-xiaoyao.li@intel.com>
 <50b4c1f0-be96-c1b5-aab1-69f4f61ec43f@redhat.com>
 <d54269db-d0ea-bcc3-935f-d29eb7c7d039@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d54269db-d0ea-bcc3-935f-d29eb7c7d039@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 16:04, Xiaoyao Li wrote:
>>
>> If intel_pt_validate_hw_cap is not fast enough, it should be optimized.
>> Something like this:
> 
> If I understand correctly, you mean we don't need to cache the existence 
> with two variable, right?
> 

Yes, exactly.

Paolo

