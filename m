Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9B849225A
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345435AbiARJPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:15:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240515AbiARJPi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:15:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642497337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wleA9ED/7itiSwmOi1fBFawSTLMvGmOl9JfJSAZhVNM=;
        b=J8H7MFkMw7r8ITRoWElR7QMTjDjUvRKWll2t49ny7hZK/yNKn+/sVQHJKrLlzE5fdqPspV
        SFrIU4dGupTa0UfW/pcTpekaUIzRI+ryesGqwCmx05x9/AgOCHSFy/tx2xvgzTrrQOUSt6
        7gMBHdMYo671Z4ds7Tvz+cJmQicODXc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-Ex6gVAIwOMK8hIpSYxp4-w-1; Tue, 18 Jan 2022 04:15:34 -0500
X-MC-Unique: Ex6gVAIwOMK8hIpSYxp4-w-1
Received: by mail-wm1-f69.google.com with SMTP id p7-20020a05600c1d8700b0034a0c77dad6so1609954wms.7
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 01:15:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wleA9ED/7itiSwmOi1fBFawSTLMvGmOl9JfJSAZhVNM=;
        b=O5Nfcs9v3qIqYxHCjqdlgBUdznnNHa/SaAdEE7LGJNvJ4ZC6o9Tvg/SoWHq9AEBRM/
         w9ZWs26MRDFgxjH1ShqNblS76f5G8LTsyLm1ydU6SzVmpxxmnGS8QCSklLuW4s342MnU
         kqn9+t2uqTgrNhRHbv7tyZznq6xHhA8xTtiibbd9TQnKutXSyK83G03nPPVvjMrdQ7Pw
         LAD+vrXx4VhDUklDI258gKebfQ6A5SKbq5MFjWsrPOEsAm0BQ+O+DYBTI5KKlHeZcSpA
         hRbgCj4Q7Wx4+/3oVZf8i9bVLT9ZlrjVO3dBsMIH1SsXmXGZFGpOQhK7PgyJVb9sTRz8
         0mBA==
X-Gm-Message-State: AOAM531fkYPGbhBy+k7/jfEo/waqhmrvUrWHM3agcdX/5ZjHG1iIHU4C
        7RrAjAo09ewwhWjYmPTFcBmU/zycszobivRT88SIf04uL4X5luNaqCfman/tvDgFy1IWL7ciVvw
        ++ZjBRE4+6+fe
X-Received: by 2002:a05:6000:156c:: with SMTP id 12mr22113075wrz.45.1642497333202;
        Tue, 18 Jan 2022 01:15:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3AHBs4Dn5TLUZsTNdLaWKwdXwQq4cyVSB214sMuljBKyZrOTPmaYlkEc3SUgIZ6gKqODLyA==
X-Received: by 2002:a05:6000:156c:: with SMTP id 12mr22113058wrz.45.1642497333023;
        Tue, 18 Jan 2022 01:15:33 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o3sm10003122wry.14.2022.01.18.01.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 01:15:32 -0800 (PST)
Message-ID: <170c4188-7ecd-a51c-2bcd-518ccc94251f@redhat.com>
Date:   Tue, 18 Jan 2022 10:15:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 0/6] KVM: x86/pmu: Use binary search to check filtered
 events
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, daviddunn@google.com,
        cloudliang@tencent.com
References: <20220114012109.153448-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220114012109.153448-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/22 02:21, Jim Mattson wrote:
> This started out as a simple change to sort the (up to 300 element)
> PMU filtered event list and to use binary search rather than linear
> search to see if an event is in the list.
> 
> I thought it would be nice to add a directed test for the PMU event
> filter, and that's when things got complicated. The Intel side was
> fine, but the AMD side was a bit ugly, until I did a few
> refactorings. Imagine my dismay when I discovered that the PMU event
> filter works fine on the AMD side, but that fundamental PMU
> virtualization is broken. And I don't just mean erratum 1292, though
> that throws even more brokenness into the mix.
> 
> v1 -> v2
> * Drop the check for "AMDisbetter!" in is_amd_cpu() [David Dunn]
> * Drop the call to cpuid(0, 0) that fed the original check for
>    CPU vendor string "AuthenticAMD" in vm_compute_max_gfn().
> * Simplify the inline asm in the selftest by using the compound literal
>    for both input & output.

Queued, thanks.

Paolo

> Jim Mattson (6):
>    KVM: x86/pmu: Use binary search to check filtered events
>    selftests: kvm/x86: Parameterize the CPUID vendor string check
>    selftests: kvm/x86: Introduce is_amd_cpu()
>    selftests: kvm/x86: Export x86_family() for use outside of processor.c
>    selftests: kvm/x86: Introduce x86_model()
>    selftests: kvm/x86: Add test for KVM_SET_PMU_EVENT_FILTER
> 
>   arch/x86/kvm/pmu.c                            |  30 +-
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/x86_64/processor.h  |  18 ++
>   .../selftests/kvm/lib/x86_64/processor.c      |  40 +--
>   .../kvm/x86_64/pmu_event_filter_test.c        | 306 ++++++++++++++++++
>   6 files changed, 361 insertions(+), 35 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> 

