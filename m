Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C335316EF3
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 19:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhBJSmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 13:42:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234146AbhBJSjp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 13:39:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612982261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YkZWpbYsRKJjW/NAfUknYV9OoyTRDMeK+ozCPOtJ+JU=;
        b=Gkqcse+JzoeKOY/JvDhLZVicwEEcdBlWSFfyDk29k7KhPs0f9hRQXH/IDmNEK9De5H3xBD
        zuvIui6kXvmZ05d9OupW5nUx65gTAmlXuw7vW0OO4xlGa/oT1s8nem4+0zddq4kxraj/R1
        QD7ZwwCHv7iEzvE8rqtXzd/6ioNCHT4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-fVD-xPegMVmxhMPw8ZtC9w-1; Wed, 10 Feb 2021 13:37:39 -0500
X-MC-Unique: fVD-xPegMVmxhMPw8ZtC9w-1
Received: by mail-wm1-f69.google.com with SMTP id u15so1815917wmj.2
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 10:37:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YkZWpbYsRKJjW/NAfUknYV9OoyTRDMeK+ozCPOtJ+JU=;
        b=b7LnQUD7MnZHNq5hHdFQkCDt2UJGzhq91U3e/gsdqnhSzait1RAuxn9WwgXlIRh23g
         kbE958H/371x0FAhay02fQ/wiFq1uibyXBZ6zMwRyOB3kwMLwHA5uaSMlmnkfC2numvc
         wh6Q42T1xgfpwUnWVce4AjE0SyFkuBVLQCCVLBBEABHarmzXnmWvRp1xqIyEYvY/JWfV
         50Bp+w79z0+KSavg8EQEHChT9/HbErmMOadXKVXJpFXlGWtIhW5e7Pocr9Pz34UDESiV
         xFhFV3naGm7EO5Mgw7K73ErNxl7XvHe8ny7dp6IfvQBIYpVNmz1qPwZ5WJ9Wdke0KBFu
         /1+w==
X-Gm-Message-State: AOAM531L2zYDnJq1q6/hHWcVAIVj6S3kOk5p0iTXfERox7nEX6qBagqy
        VzdtrZuvKW1ijFbvbcJ+d4q64yZA8UFY/pe4rzuzNEP23TpSkiNsHFWkN6JL7cykGl89w3jlnn8
        rJ3ZUb8jX670w
X-Received: by 2002:a05:600c:4242:: with SMTP id r2mr238755wmm.109.1612982258413;
        Wed, 10 Feb 2021 10:37:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvYPABVcDXEVZzk5DLGtlJTGuU5nmbBaGPIcD5k+EhFtjbWNd0Jaor9nUC8Ahgggr2TYTRsA==
X-Received: by 2002:a05:600c:4242:: with SMTP id r2mr238737wmm.109.1612982258248;
        Wed, 10 Feb 2021 10:37:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w25sm3494429wmc.42.2021.02.10.10.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 10:37:37 -0800 (PST)
Subject: Re: [PATCH 0/5] KVM: x86/xen: Selftest fixes and a cleanup
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>
References: <20210210182609.435200-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc334fe4-0ddc-b991-ad76-1d70c065fc16@redhat.com>
Date:   Wed, 10 Feb 2021 19:37:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210210182609.435200-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/21 19:26, Sean Christopherson wrote:
> Fix a '40' vs '0x40' bug in the new Xen shinfo selftest, and clean up some
> other oddities that made root causing the problem far more painful than it
> needed to be.
> 
> Note, Paolo already queued a patch from Vitaly that adds the tests to
> .gitignore[*], i.e. patch 01 can likely be dropped.  I included it here
> for completeness.
> 
> [*] https://lkml.kernel.org/r/20210129161821.74635-1-vkuznets@redhat.com
> 
> Sean Christopherson (5):
>    KVM: selftests: Ignore recently added Xen tests' build output
>    KVM: selftests: Fix size of memslots created by Xen tests
>    KVM: selftests: Fix hex vs. decimal snafu in Xen test
>    KVM: sefltests: Don't bother mapping GVA for Xen shinfo test
>    KVM: x86/xen: Explicitly pad struct compat_vcpu_info to 64 bytes
> 
>   arch/x86/kvm/xen.h                                   | 11 ++++++-----
>   tools/testing/selftests/kvm/.gitignore               |  2 ++
>   tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 12 +++++-------
>   tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c |  3 +--
>   4 files changed, 14 insertions(+), 14 deletions(-)
> 

Stupid question: how did you notice that?  In other words what broke for 
you and not for me?

Paolo

