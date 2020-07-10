Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5F321BC75
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 19:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGJRkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 13:40:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56397 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727065AbgGJRkv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 13:40:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594402850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d5YCjh7Ir73wQYt476RH2SlBQc/3pjz78qQVd8aGWVE=;
        b=etbZJ7uuJxaqjHUKR4ULyPvbSDSBR3le64aw8W2OcrZi9ZeIGpbKs17VV0tFHYvjawLnpz
        EMzgo88JTdYPb54nOgU735DH6gdT1ZV4Xm5MvhT24US5zTJNlxOe/OTn6T2PeS+Wq8QRuq
        Y9MY9NqiUjHMlx8wHpBSYr8cxbq69LA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-CmvS6husP1um65jLpRyb9g-1; Fri, 10 Jul 2020 13:40:48 -0400
X-MC-Unique: CmvS6husP1um65jLpRyb9g-1
Received: by mail-wr1-f72.google.com with SMTP id e11so6743830wrs.2
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 10:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d5YCjh7Ir73wQYt476RH2SlBQc/3pjz78qQVd8aGWVE=;
        b=lehDLl30Rg+3U69WV5iPv5SQ9C4pdyHPjtVJWyd3o9cAWm7uPxY+FqU4bVAySsdJiW
         pfmXfXGzVxMV7XRwigN8g4vq2/SvIXtStjJt2FN+e1DD/DZJIGfgorkOYGjXPIVQqQTF
         DmLafLK0NuncRzCBHKUjdZbhu+pdegysSEf33biK89ro9SV/7/ntvNu646mz9O2CIEyh
         8Hxv8/Lav1vmJJIMiScEWRbO/y7+RXxQZROp0PjjwnYlXq1cKfXOPwQ2YUJrQtRPIbGK
         9UJH64FwIUwcppDpC5hBJ0Pl5zTztUQuM3A1Cx4FER449GKDUMarSJERkziV2a51W3JD
         inwA==
X-Gm-Message-State: AOAM533HyVtfq8yuF/t4Fk8iyo5d48s7MO6Eo5+bk8IBovMcU4Vu63ob
        k6mwILsZsKuzj0xRix1hGTEruDw0okQIjcVafpL2vckr32g2MQkEJM2AwC/6kYcnYSky28+GbIQ
        lsJ00001ndLFT
X-Received: by 2002:adf:ec88:: with SMTP id z8mr68672311wrn.395.1594402846969;
        Fri, 10 Jul 2020 10:40:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAyJuA0aVT6OCO/QR9ECKytqX2ohs3nnhcAp0+m2w0tDW3u6NMegvOnDIlWBMqLatUMq+seQ==
X-Received: by 2002:adf:ec88:: with SMTP id z8mr68672292wrn.395.1594402846714;
        Fri, 10 Jul 2020 10:40:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id d13sm10875974wrn.61.2020.07.10.10.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 10:40:46 -0700 (PDT)
Subject: Re: [PATCH v3 9/9] KVM: x86: SVM: VMX: Make GUEST_MAXPHYADDR <
 HOST_MAXPHYADDR support configurable
To:     Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Babu Moger <babu.moger@amd.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <20200710154811.418214-10-mgamal@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c01fb991-8352-53be-3aab-8de808ead5ea@redhat.com>
Date:   Fri, 10 Jul 2020 19:40:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710154811.418214-10-mgamal@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 17:48, Mohammed Gamal wrote:
> The reason behind including this patch is unexpected behaviour we see
> with NPT vmexit handling in AMD processor.
> 
> With previous patch ("KVM: SVM: Add guest physical address check in
> NPF/PF interception") we see the followning error multiple times in
> the 'access' test in kvm-unit-tests:
> 
>             test pte.p pte.36 pde.p: FAIL: pte 2000021 expected 2000001
>             Dump mapping: address: 0x123400000000
>             ------L4: 24c3027
>             ------L3: 24c4027
>             ------L2: 24c5021
>             ------L1: 1002000021
> 
> This shows that the PTE's accessed bit is apparently being set by
> the CPU hardware before the NPF vmexit. This completely handled by
> hardware and can not be fixed in software.
> 
> This patch introduces a workaround. We add a boolean variable:
> 'allow_smaller_maxphyaddr'
> Which is set individually by VMX and SVM init routines. On VMX it's
> always set to true, on SVM it's only set to true when NPT is not
> enabled.
> 
> We also add a new capability KVM_CAP_SMALLER_MAXPHYADDR which
> allows userspace to query if the underlying architecture would
> support GUEST_MAXPHYADDR < HOST_MAXPHYADDR and hence act accordingly
> (e.g. qemu can decide if it would ignore the -cpu ..,phys-bits=X)
> 
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: Babu Moger <babu.moger@amd.com>
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>

Slightly rewritten commit message:

    KVM: x86: Add a capability for GUEST_MAXPHYADDR < HOST_MAXPHYADDR support
    
    This patch adds a new capability KVM_CAP_SMALLER_MAXPHYADDR which
    allows userspace to query if the underlying architecture would
    support GUEST_MAXPHYADDR < HOST_MAXPHYADDR and hence act accordingly
    (e.g. qemu can decide if it should warn for -cpu ..,phys-bits=X)
    
    The complications in this patch are due to unexpected (but documented)
    behaviour we see with NPF vmexit handling in AMD processor.  If
    SVM is modified to add guest physical address checks in the NPF
    and guest #PF paths, we see the followning error multiple times in
    the 'access' test in kvm-unit-tests:
    
                test pte.p pte.36 pde.p: FAIL: pte 2000021 expected 2000001
                Dump mapping: address: 0x123400000000
                ------L4: 24c3027
                ------L3: 24c4027
                ------L2: 24c5021
                ------L1: 1002000021
    
    This is because the PTE's accessed bit is set by the CPU hardware before
    the NPF vmexit. This is handled completely by hardware and cannot be fixed
    in software.
    
    Therefore, availability of the new capability depends on a boolean variable
    allow_smaller_maxphyaddr which is set individually by VMX and SVM init
    routines. On VMX it's always set to true, on SVM it's only set to true
    when NPT is not enabled.
    
    CC: Tom Lendacky <thomas.lendacky@amd.com>
    CC: Babu Moger <babu.moger@amd.com>
    Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
    Message-Id: <20200710154811.418214-10-mgamal@redhat.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

