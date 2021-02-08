Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2994312F1C
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 11:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhBHKfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 05:35:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232457AbhBHKdJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 05:33:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612780302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K05zC1EUlyTezUmZ1LkF+HhqGZkbRd0Cfn1SraZHoC4=;
        b=Oh3CSr4n3qZQStBSeLcQI9X4PkgXcmVMYRWE0XVBU75pesOkVlxLYWl5sYQrWbclW9JkI3
        SzZqPF2JpIANH1stSHyI2h3u/oyVcyuInosbwbt3mlbAx7xwV2b2JdzN15PkwSnDqkr59o
        I1oXPGXVpo/CBMM6G2rXvydHaUrbsxw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-4PTjjsrcMiWgxuZM2O4WFg-1; Mon, 08 Feb 2021 05:31:40 -0500
X-MC-Unique: 4PTjjsrcMiWgxuZM2O4WFg-1
Received: by mail-wr1-f69.google.com with SMTP id l7so12649854wrp.1
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 02:31:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K05zC1EUlyTezUmZ1LkF+HhqGZkbRd0Cfn1SraZHoC4=;
        b=HkCoYvcNX0BpB56WMXu6WDcFENcUq7BQngQKM2Wm81RQW5h/YPxPRHavjPxWCPoedC
         1v31cVWkLTG6Ybgry1LoQfx9fpDZRsqCqz2LrM86Svm7AJThJYGcGu76CrvmgdV86R9z
         IJB4diqjmk8oOFBAPM2+FfT3ysXtaP9+qem460SRJhMrNFgwlS60if2Zvg8fPqX0FuUx
         pA5Y0Lc4pKhEnPxijqRhY5HqP3T4dE4xuHt4+J2t+EL8Ky7g9KZvfVMm1NytZGKP70rO
         zhjRWvLMZOHC6eSPHS2ijCAAN3suELLt3FCn7PDBinVznrs6syBAT8+zu066r2U2hv7y
         424Q==
X-Gm-Message-State: AOAM530v5ALJyBq1s7jnZq8RqOgjH6CdKwALG4bpiEGVkWiijut6+RcH
        saHoz85XsV1J6iTi1waPKaBZ2Wth7ME6LO3gPf8jorbuoraqpdQxMoIjmv7xBg77HU3CkjbJakZ
        hmmWY04SOFJK/
X-Received: by 2002:a5d:4f84:: with SMTP id d4mr18901195wru.374.1612780299172;
        Mon, 08 Feb 2021 02:31:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwP9s5k4d7RHre3+wLFCfyCISAOk/GvRTsic5k/x4GOrkGIKO3fRxDZ2hY9lCiWS5J/+CKzlQ==
X-Received: by 2002:a5d:4f84:: with SMTP id d4mr18901170wru.374.1612780298938;
        Mon, 08 Feb 2021 02:31:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d3sm31485720wrp.79.2021.02.08.02.31.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 02:31:38 -0800 (PST)
Subject: Re: [PATCH v2 4/4] KVM: x86: Expose Architectural LBR CPUID and its
 XSAVES bit
To:     "Xu, Like" <like.xu@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
 <20210203135714.318356-5-like.xu@linux.intel.com>
 <8321d54b-173b-722b-ddce-df2f9bd7abc4@redhat.com>
 <219d869b-0eeb-9e52-ea99-3444c6ab16a3@intel.com>
 <b73a2945-11b9-38bf-845a-c64e7caa9d2e@intel.com>
 <7698fd6c-94da-e352-193f-e09e002a8961@redhat.com>
 <6f733543-200e-9ddd-240b-1f956a003ed6@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c3b916c2-5b4e-31d1-b27b-bf71b621bd7b@redhat.com>
Date:   Mon, 8 Feb 2021 11:31:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6f733543-200e-9ddd-240b-1f956a003ed6@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/21 02:02, Xu, Like wrote:
> On 2021/2/5 19:00, Paolo Bonzini wrote:
>> On 05/02/21 09:16, Xu, Like wrote:
>>> Hi Paolo,
>>>
>>> I am wondering if it is acceptable for you to
>>> review the minor Architecture LBR patch set without XSAVES for v5.12 ?
>>>
>>> As far as I know, the guest Arch LBR  can still work without XSAVES 
>>> support.
>>
>> I dopn't think it can work.  You could have two guests on the same 
>> physical CPU and the MSRs would be corrupted if the guests write to 
>> the MSR but they do not enable the LBRs.
>>
>> Paolo
>>
> Neither Arch LBR nor the old version of LBR have this corruption issue,
> and we will not use XSAVES for at least LBR MSRs in the VMX transaction.
> 
> This is because we have reused the LBR save/restore swicth support from the
> host perf mechanism in the legacy LBR support, which will save/restore 
> the LBR
> MSRs of the vcpu (thread) when the vcpu is sched in/out.
> 
> Therefore, if we have two guests on the same physical CPU, the usage of 
> LBR MSRs
> is isolated, and it's also true when we use LBR to trace the hypervisor 
> on the host.
> The same thing happens on the platforms which supports Arch LBR.
> 
> I propose that we don't support using XSAVES to save/restore Arch LRB 
> *in the guest*
> (just like the guest Intel PT), but use the traditional RD/WRMSR, which 
> still works
> like the legacy LBR.

Ok, this makes sense.  I'll review the patches more carefully, looking 
at 5.13 for the target.

Paolo

> Since we already have legacy LBR support, we can add a small amount of 
> effort (just
> two more MSRs emulation and related CPUID exposure) to support Arch LBR 
> w/o XSAVES.
> 
> I estimate that there are many issues we need to address when we 
> supporting guests
> to use xsaves instructions. As a rational choice, we could enable the 
> basic Arch LBR.
> 
> Paolo and Sean, what do you think ?
> 
> ---
> thx, likexu
> 

