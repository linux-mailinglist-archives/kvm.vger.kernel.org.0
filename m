Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25833296116
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 16:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901065AbgJVOpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 10:45:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2901061AbgJVOpA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 10:45:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603377898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MMaUMBupo+aMZow4IDwl1t08XFtpsf1GwqJ0/qCgZAo=;
        b=F7R5hxmHRmIluVNffyHNA0bL31kM6fDqmUQzXfIamrikEXiPNLwIFreVrrgbm/KKce/JSE
        qpRSkZLiKHRRCv8pYlbd7gsBGSL9w/KU3U+HfSchYY5rcQNbr+L52qRD0a1saNVsJlAOuh
        1qezLCcbvwn7n8hDmysrzGu8MclyN8U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-a6T3n685O0qaD6jIkctaUw-1; Thu, 22 Oct 2020 10:44:56 -0400
X-MC-Unique: a6T3n685O0qaD6jIkctaUw-1
Received: by mail-wm1-f71.google.com with SMTP id g71so675491wmg.2
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 07:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MMaUMBupo+aMZow4IDwl1t08XFtpsf1GwqJ0/qCgZAo=;
        b=CypSbsDLI4+QY0jQY+PcmH9hAvCRxcIlqrvL5re+wPfCLL1rXYEV3pxg9J7uDk8OPi
         mot2q304AbDbSlCVBjZJfRAbQl9QE7DTlckuO9D2vOYs8w4qebm+GumTZUYncmBxtq1H
         8LD9aDUpaHM2N15W8zilzGyMP+zaq6+Nc41fGN9I3kPVftxQz00yCrCrT5iPJ+wOVwqX
         xzzvN0cqwVtC0HfWizGyHl3rhTlKnaRx2+7hBlBs78rkIuVyoc3AAbTDG5TC+qhlOEF0
         5uU8eKXrHQzkt1SHgcxYp2trStX5qqzkturkfPdycURzgiEeocNb/DRpWY2dP2Pv4JLe
         3Kvg==
X-Gm-Message-State: AOAM5331ysqXfocPE7MHNx3nCXMoRhJcBQ5MnmaxfW9AEmt+8tjF+i9k
        gdGKn7GhNeRsA0Czg+457bVcCK+Qx5IB3KW5QxddAL9mI9EuOf2uc2IaRXfxuv2621Oz4Xt/J8V
        k3GtOsoIbC54d
X-Received: by 2002:a5d:6341:: with SMTP id b1mr3025887wrw.373.1603377895531;
        Thu, 22 Oct 2020 07:44:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyy6/ULc2Qhz/lkjYdnyHz1JbZVqrBgfAegGJEfIA9/WIOjOlNUiHYm8Jolf3SALmV2NNabnA==
X-Received: by 2002:a5d:6341:: with SMTP id b1mr3025872wrw.373.1603377895365;
        Thu, 22 Oct 2020 07:44:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n62sm4120086wmb.10.2020.10.22.07.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 07:44:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in
 KVM_GET_SUPPORTED_CPUID
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
 <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
 <6ad94df6-9ecd-e364-296a-34ba41e938b1@intel.com>
 <31b189e0-503f-157d-7af0-329744ed5369@redhat.com>
 <18e7a0c6-faff-8c4c-0830-a0bc02627a36@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4a5d0ccd-f6a7-2afe-2480-991ff7e079b4@redhat.com>
Date:   Thu, 22 Oct 2020 16:44:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <18e7a0c6-faff-8c4c-0830-a0bc02627a36@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/20 16:28, Xiaoyao Li wrote:
> On 10/22/2020 10:06 PM, Paolo Bonzini wrote:
>> On 22/10/20 15:31, Xiaoyao Li wrote:
>>>>
>>>> It's common for userspace to copy all supported CPUID bits to
>>>> KVM_SET_CPUID2, I don't think this is the right behavior for
>>>> KVM_HINTS_REALTIME.
>>>
>>> It reminds of X86_FEATURE_WAITPKG, which is added to supported CPUID
>>> recently as a fix but QEMU exposes it to guest only when "-overcommit
>>> cpu-pm"
>>
>> WAITPKG is not included in KVM_GET_SUPPORTED_CPUID either.  QEMU detects
>> it through the MSR_IA32_UMWAIT register.
> 
> Doesn't 0abcc8f65cc2 ("KVM: VMX: enable X86_FEATURE_WAITPKG in KVM
> capabilities") add WAITPKG to KVM_GET_SUPPORTED_CPUID?

You're right, I shouldn't have checked only cpuid.c. :)

Still I think WAITPKG is different, because it's only for userspace and
it's always possible for userspace to do "for(;;)" and burn CPU.
KVM_HINTS_REALTIME is more similar to MONITOR, which is not set.

Paolo

