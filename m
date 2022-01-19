Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71827494005
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356813AbiASShd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:37:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356791AbiASShc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 13:37:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642617451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rorpKq4thwCv1KEG1dELrIisL1eH74YJusfX4RC+vh4=;
        b=azI1ISY57b4AsjAmL6ue/VoZ4b4FnuFqUjsKTHo7D5qHKvX7iFyBFhPQMEzPxuXDBJ0psu
        x/jMbm/00EHIefDnugZg5eRefR9KTPgupDHmRbO2pZdv+eLqtZI1KYvYqMjiquUingHhtb
        rTwUXTjaAJS2RpI6Nzf4eV6UmZRmvus=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644--FCCP44qPOSQ5aOpPzQfYA-1; Wed, 19 Jan 2022 13:37:30 -0500
X-MC-Unique: -FCCP44qPOSQ5aOpPzQfYA-1
Received: by mail-wm1-f71.google.com with SMTP id n19-20020a05600c501300b0034d7b01ae4dso1499989wmr.1
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:37:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rorpKq4thwCv1KEG1dELrIisL1eH74YJusfX4RC+vh4=;
        b=qsflb0H5DJqMpeYU1AzTFvFCoH396y5IiLL5hBNGahIGrwkNPgDcQj3EaUslJ8a+DA
         k2Xy8ik69lKOVqWoc5i3Bl2UUVtGU1N87Q/hBF56N0dDGsPgyDkwBgXlO/jBZlQN7fq/
         fXKcHd0FLGqxuDs9EBpHasL+LVaIJWO97uNn++GdkAh5/64FDZa1dbTa4iAUpo4SP6yl
         Ic2UqDH5Y3A1tJqka1G5lVrfDz6ySIklo2a6kVLD1VX25a7zEbp+XiwPorrthaqgbRPJ
         K6Hy5siNQ/JV14/iZhbuisMCfZuK1reU4YB94BGJMcPN8IUlYW18gBRclsyI4t1nvt7d
         yJSg==
X-Gm-Message-State: AOAM533tQozRgERaVQZkjjGTEfObCxK9KoYaGQNXvpSql3c1ddgA+2ce
        PrRK757qbEZPr9zrGxxop23IuKDiDuXZ7xM+sINeWLiSNslXJqmzy/NsXjiZ4FKpx/xWUcNKa84
        O45JhF7oMvxo/
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr4881012wmk.134.1642617449193;
        Wed, 19 Jan 2022 10:37:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuPjrpRwwRlHfIoCBn2mOel4lTHQHrc3MO/7ZP8UPstbYjQOqGevgMBrzyQV+VDTreeNVJ+A==
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr4880983wmk.134.1642617448949;
        Wed, 19 Jan 2022 10:37:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 9sm793256wrb.77.2022.01.19.10.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 10:37:28 -0800 (PST)
Message-ID: <06e16701-1380-8186-2f21-e5cc5a5c8467@redhat.com>
Date:   Wed, 19 Jan 2022 19:37:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] selftests: kvm/x86: Fix the warning in
 pmu_event_filter_test.c
Content-Language: en-US
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220119133910.56285-1-cloudliang@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220119133910.56285-1-cloudliang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 14:39, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> The following warning appears when executing
> make -C tools/testing/selftests/kvm
> 
> x86_64/pmu_event_filter_test.c: In function ‘vcpu_supports_intel_br_retired’:
> x86_64/pmu_event_filter_test.c:241:28: warning: variable ‘cpuid’ set but not used [-Wunused-but-set-variable]
>    241 |         struct kvm_cpuid2 *cpuid;
>        |                            ^~~~~
> x86_64/pmu_event_filter_test.c: In function ‘vcpu_supports_amd_zen_br_retired’:
> x86_64/pmu_event_filter_test.c:258:28: warning: variable ‘cpuid’ set but not used [-Wunused-but-set-variable]
>    258 |         struct kvm_cpuid2 *cpuid;
>        |                            ^~~~~
> 
> Just delete the unused variables to stay away from warnings.
> 
> Fixes: dc7e75b3b3ee ("selftests: kvm/x86: Add test for KVM_SET_PMU_EVENT_FILTER")
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>   tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 8ac99d4cbc73..0611a5c24bbc 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -238,9 +238,7 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
>   static bool vcpu_supports_intel_br_retired(void)
>   {
>   	struct kvm_cpuid_entry2 *entry;
> -	struct kvm_cpuid2 *cpuid;
>   
> -	cpuid = kvm_get_supported_cpuid();
>   	entry = kvm_get_supported_cpuid_index(0xa, 0);
>   	return entry &&
>   		(entry->eax & 0xff) &&
> @@ -255,9 +253,7 @@ static bool vcpu_supports_intel_br_retired(void)
>   static bool vcpu_supports_amd_zen_br_retired(void)
>   {
>   	struct kvm_cpuid_entry2 *entry;
> -	struct kvm_cpuid2 *cpuid;
>   
> -	cpuid = kvm_get_supported_cpuid();
>   	entry = kvm_get_supported_cpuid_index(1, 0);
>   	return entry &&
>   		((x86_family(entry->eax) == 0x17 &&

Queued, thanks.

Paolo

