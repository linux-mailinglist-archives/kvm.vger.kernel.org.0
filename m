Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2B0267868
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 08:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgILGyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 02:54:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23188 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725788AbgILGye (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Sep 2020 02:54:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599893672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v7+8tnmDpkfdaqx/e481xsksUmZX5LqSfuZv0e8PXqU=;
        b=eQ13U2a+5i1a8hVMaFvYcqH7lfFWw3NY5Hsj8d2AMcmvLMScS2CHNH3m/2M+CvIDQNya0A
        yjAmV/qeHVulwZvmZQ0v3516I3IGL69EXGOJWfYI+FcFEhHoNiZzpwBwbigTwcBoYwbJcN
        11Uhf7+orxasdnowC/tb2SApKt6NIMg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-RG2y8cPiPN-8f00Vcv1TIw-1; Sat, 12 Sep 2020 02:54:30 -0400
X-MC-Unique: RG2y8cPiPN-8f00Vcv1TIw-1
Received: by mail-wm1-f72.google.com with SMTP id x6so1713670wmi.1
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 23:54:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v7+8tnmDpkfdaqx/e481xsksUmZX5LqSfuZv0e8PXqU=;
        b=bl9aDiGTX1ZSPSWzjq55MKIEXyjsgNyPe75+CoEQ+s0xELE30i0mSjLmSqtqfQwwYA
         zVVjiAor9fKNEP6VPzdK52mJi2p37nH7LCHBs/rFh82KQzYukmUuVoP0glVDUOSP/okD
         YqgZVJIiA4OyYHqSNND7ITVwYZ6tcKqwg8aM5f/wVTlMDd1yLQwzJ0ANjsK9K8ggnGsT
         zg61vzhPQ9LDxw8LsYKcPa9dxy/ViI29WRf/U4cFhx+jBuHpJUX0g3XYXrLg0FhN1M5I
         VCnegKFGLKLt4LQoExnL9/vDRhp/K1pFpLL9sp2E8nNll3QdgOIxLWBF0ZV0G45xIuRH
         YMAg==
X-Gm-Message-State: AOAM531rnQRCvFdyC9GVVNp7VNKRkMHylVqCCapxkKI5uNzmMfzdyKi7
        aYZeSFxhqQBH7g90izR6P1CP9EGDhPnz5DbYgmQkgPMCQ/sZ6KLFNR6TEQLq/eUfwy55EdWJVKS
        vPRDvoOdUKMRr
X-Received: by 2002:adf:f808:: with SMTP id s8mr5495667wrp.268.1599893669334;
        Fri, 11 Sep 2020 23:54:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8jhcWL8cf0hYJvoxbAHPgoU2Eom1gEDIDkit2PwJcvCTjnzMyWT8BFaK2yffVtB5WlNcPHQ==
X-Received: by 2002:adf:f808:: with SMTP id s8mr5495647wrp.268.1599893669152;
        Fri, 11 Sep 2020 23:54:29 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id s5sm9005131wrm.33.2020.09.11.23.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 23:54:28 -0700 (PDT)
Subject: Re: [PATCH 1/4 v3] x86: AMD: Replace numeric value for SME CPUID leaf
 with a #define
To:     Borislav Petkov <bp@alien8.de>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
References: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
 <20200911192601.9591-2-krish.sadhukhan@oracle.com>
 <20200911212131.GB4110@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c11dee69-e5fe-ce7a-8912-17393d2e1452@redhat.com>
Date:   Sat, 12 Sep 2020 08:54:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200911212131.GB4110@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/20 23:21, Borislav Petkov wrote:
> On Fri, Sep 11, 2020 at 07:25:58PM +0000, Krish Sadhukhan wrote:
> 
> <-- patches need commit message.
> 
> ...
> 
>> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
>> index 62b137c3c97a..033c112e03fc 100644
>> --- a/arch/x86/kernel/cpu/scattered.c
>> +++ b/arch/x86/kernel/cpu/scattered.c
>> @@ -39,8 +39,8 @@ static const struct cpuid_bit cpuid_bits[] = {
>>  	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
>>  	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
>>  	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
>> -	{ X86_FEATURE_SME,		CPUID_EAX,  0, 0x8000001f, 0 },
>> -	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
>> +	{ X86_FEATURE_SME,		CPUID_EAX,  0, CPUID_AMD_SME, 0 },
>> +	{ X86_FEATURE_SEV,		CPUID_EAX,  1, CPUID_AMD_SME, 0 },
> 
> So this one gets a name and all the others above don't?
> 
> This fact should've given you a hint that there's no need for naming
> CPUID leafs - it is easier to grep CPU manuals by the values so you can
> drop this patch.

Also, there'd be confusion between the CPUID_* enum in
arch/x86/include/asm/cpufeature.h.

Paolo

