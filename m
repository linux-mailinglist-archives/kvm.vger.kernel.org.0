Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60072AD3F5
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 11:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgKJKkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 05:40:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727114AbgKJKkm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 05:40:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605004840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mFapeUoz9EK+CeReEbp81IVPN8G8zVDapgbISzQg6Vs=;
        b=ZravZIYZ904Xj210Gmu5ZbplPBdlSpO5rWG+ngA15PfevgyevZv0wZs4LJLGpyi8G/Rnhu
        3IeEzh1F4VbD2kxfTQ3j/0FRltXscjCxKtMpm51gWLKd+foZj9mFu9/BMsB2EokUY7ihoF
        3Z8sKcL+m9U204JeJkt4RQfNNO5v1pA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-5dEt1Qq1PJGjJvjGg41b4Q-1; Tue, 10 Nov 2020 05:40:38 -0500
X-MC-Unique: 5dEt1Qq1PJGjJvjGg41b4Q-1
Received: by mail-ed1-f72.google.com with SMTP id bc27so4003545edb.18
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 02:40:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mFapeUoz9EK+CeReEbp81IVPN8G8zVDapgbISzQg6Vs=;
        b=EtZAmMmA85sRJB3pfzslxz+5YJ4voGdBKOahqvR2+NdQ8STvRmOFkSHIsvOhmoSqHr
         caKPcNa2e84G++/GSbbUEFGP/L9c3f59c76NIOldGpWAvApRYim/+4Ik3g6Q93wQBspO
         wsuzUzeCWVTh2u2J+1LZdoG/bbSNjGrXqqoAB1aLn2dO+oTRoiaxn0YCkuBuRr+78yBq
         dZfSuUIXpMYTvND+XxBURymYJJuRR3UQxzn06+uPBDT1t9staoWBi0Bi0Zr75+2/sGB9
         OsHZxSjShVW9GEzs7HQ7UWoZeCx4M3EcM3hB3tw6eHEjZzuHYvMnHfR5MjDwNuRHs8gg
         su3w==
X-Gm-Message-State: AOAM5314+oKPxXX67KlWiC8HsCvkeHVizLzpcM8nx1xmlf4R5DvV/CLs
        Zez9w4sDflA9Vxwpxfw1yyjNuYvNErxy17VCifVg1sEkzLzuFCNrji/STvwUHmoywKswUjbrtbT
        Wphi4cPUbR8qZyM0pzoaKttPA4qtz7nqPnmdmZWnlPDk6YJy6OsgzAO4jY1B+RE3D
X-Received: by 2002:a17:906:1183:: with SMTP id n3mr19064874eja.188.1605004837199;
        Tue, 10 Nov 2020 02:40:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnjrd2VMYhvgmNsyYwtSr3fGttybQrjvuv3QVZvsz5l664w5dGcdQ9COwyU1SYrBNdF5vTUQ==
X-Received: by 2002:a17:906:1183:: with SMTP id n3mr19064842eja.188.1605004836846;
        Tue, 10 Nov 2020 02:40:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m16sm8760572eja.58.2020.11.10.02.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 02:40:35 -0800 (PST)
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        Jim Mattson <jmattson@google.com>, Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
 <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
 <20201110063151.GB7290@nazgul.tnic>
 <094c2395-b1b3-d908-657c-9bd4144e40ac@redhat.com>
 <20201110095615.GB9450@nazgul.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/mce: Check for hypervisor before enabling additional
 error logging
Message-ID: <b8de7f7b-7aa1-d98b-74be-62d7c055542b@redhat.com>
Date:   Tue, 10 Nov 2020 11:40:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201110095615.GB9450@nazgul.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/20 10:56, Borislav Petkov wrote:
> On Tue, Nov 10, 2020 at 09:50:43AM +0100, Paolo Bonzini wrote:
>> 1) ignore_msrs _cannot_ be on by default.  You cannot know in advance that
>> for all non-architectural MSRs it's okay for them to read as zero and eat
>> writes.  For some non-architectural MSR which never reads as zero on real
>> hardware, who knows that there isn't some code using the contents of the MSR
>> as a divisor, and causing a division by zero exception with ignore_msrs=1?
> 
> So if you're emulating a certain type of hardware - say a certain CPU
> model - then what are you saying? That you're emulating it but not
> really all of it, just some bits?

We try to emulate all that is described in the SDM as architectural, as 
long as we expose the corresponding CPUID leaves.

However, f/m/s mean nothing when running virtualized.  First, trying to 
derive any non-architectural property from the f/m/s is going to fail. 
Second, even the host can be anything as long as it's newer than the 
f/m/s that the VM reports (i.e. you can get a Sandy Bridge model and 
model name even if running on Skylake).

Also, X86_FEATURE_HYPERVISOR might be clear even if running virtualized. 
  (Thank you nVidia for using it to play market segmentation games).

> Because this is what happens - the kernel checks that it runs on a
> certain CPU type and this tells it that those MSRs are there. But then
> comes virt and throws all assumptions out.
> 
> So if it emulates a CPU model and the kernel tries to access those MSRs,
> then the HV should ignore those MSR accesses if it doesn't know about
> them. Why should the kernel change everytime some tool or virtualization
> has shortcomings?

See above: how can the hypervisor know a safe value for all MSRs, 
possibly including the undocumented ones?

>> 3) because of (1) and (2), the solution is very simple.  If the MSR is
>> architectural, its absence is a KVM bug and we'll fix it in all stable
>> versions.  If the MSR is not architectural (and 17Fh isn't; not only it's
>> not mentioned in the SDM,
> 
> It is mentioned in the SDM.

Oh right they moved the MSRs to a separate manual; found it now.  Still, 
it's not architectural.

> But maybe we should have a choice and maybe qemu/kvm should have a way
> to ignore certain MSRs for certain CPU types, regardless of them being
> architectural or not.

If it makes sense to emulate certain non-architectural MSRs we can add 
them.  Supporting the error control MSR wouldn't even be hard, but I'm 
not sure it makes sense:

1) that MSR has not been there on current processors for several years 
(and therefore Intel has clearly no intention of making architectural). 
  For what we know, even current processors might not provide any of 
that extended information at all (and still the VM could present Sandy 
Bridge f/m/s).

2) it would only present extended error info if the host itself enables 
the bit, so one might question the wisdom of backporting that support 
this to stable kernels

3) It's unclear whether the guest would be able to use the extended 
error information at all (and in some cases the description in the 
manual is not even proper English: "allows the iMC to log first device 
error when corrected error is detected during normal read"?).

4) other hypervisors, including older distros, would likely have the 
same issue.

Paolo

