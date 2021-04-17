Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF97B3630A5
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 16:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbhDQOgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 10:36:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233008AbhDQOgO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 10:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618670147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6HkMZ7LA7IuXSwA4MH+v8PQ1zPBCTNZQiVqKWTZqazw=;
        b=gmqvZ0grleW4tgu3z9ca5tA8M+kOiTcqqpLK4k3aCcgc8+hiDVGxdt39ETwjE5qPdk1sjh
        g2KMFovvieu2nfeXMf42RotRT3JrumTQM6iMAC6De05LiYn8DBETUSFb7ZYu3ogzqddLgW
        6eGF8ZDxeAfu2m3ue6RqrR01I+NGwY4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32--23EKmJGNDqGkrl8E2rVug-1; Sat, 17 Apr 2021 10:35:45 -0400
X-MC-Unique: -23EKmJGNDqGkrl8E2rVug-1
Received: by mail-ed1-f69.google.com with SMTP id w14-20020aa7da4e0000b02903834aeed684so6947391eds.13
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 07:35:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6HkMZ7LA7IuXSwA4MH+v8PQ1zPBCTNZQiVqKWTZqazw=;
        b=KpeJ8DtvuX4K2K4adMkpJvt8sv0C43uwJGoAczaSnIbmQWWEvqop2Tl5z70rcPIWk3
         KgLGNPZmV3IzpwxFg8Gd8VcYXbSGojjYAJ1N+EcC52/o7Av84FotbDC/64xg+F3LK1Pe
         3/9Jyhw95tE7REJIZYt4TOepoRwfraFNgZTs0NdO+O5TKDKclbCt1p9N31c2KE6vZlno
         ziMBd9XyYlxH9PKf8jw/aEfTT95f3rsPZHjR5QG7toFojRjtt5lY7hx3sQ4MuWz/e8CE
         zuWADd0pbbiwYjURxzN3C5a3+kevZUXQ/QnNx/Hs4OFnazb3sGtibdbLTuoWuY1tc68i
         QbUA==
X-Gm-Message-State: AOAM531cD8wh0qKZmkrQKBgcYAzb5rbZcrhVZSvioY5bUJWE6sAZagwM
        CFwpXKde4xa2SGAJf6O7KQR/jRLniazZQHloZnatfxBKl0yLXlef2DEt1rOFZbcUQUheRA+zT5+
        oegZ0pdt0RqJI
X-Received: by 2002:aa7:de12:: with SMTP id h18mr15931731edv.380.1618670144116;
        Sat, 17 Apr 2021 07:35:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl6dU7W8DT1mDOg6ktEsC+ATqiiq5mWbiypas3/CSL+F7nL9mY2xDAM1aE5UPZH6Gv6gCXPg==
X-Received: by 2002:aa7:de12:: with SMTP id h18mr15931724edv.380.1618670143969;
        Sat, 17 Apr 2021 07:35:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b8sm8594759edu.41.2021.04.17.07.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 07:35:43 -0700 (PDT)
Subject: Re: [PATCH 0/7 v7] KVM: nSVM: Check addresses of MSR bitmap and IO
 bitmap tables on vmrun of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <19810419-1b0d-ff89-5c69-2d5d613f8f0f@redhat.com>
Date:   Sat, 17 Apr 2021 16:35:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 23:56, Krish Sadhukhan wrote:
> v6 -> v7:
> 	1. In patch# 4, the logic in nested_svm_check_bitmap_pa() has been
> 	   fixed. The size of IOPM passed to nested_svm_check_bitmap_pa() has
> 	   also been corrected. Indentation has been improved.
> 	2. In patch# 1, the names of the #defines have been changed.
> 	3. In patch# 2, a new exit code is defined to differentiate between
> 	   consistency failures and failures after switching to guest mode,
> 	   because tests need to know the exact failure instead of
> 	   SVM_EXIT_ERR. This exit code is similar to what nVMX does and
> 	   appears to be the best solution to differentiate the above-mentioned
> 	   error scenarios.
> 	4. In patch# 3, code that unset bit 11:0 of the MSRPm and IOPM tables,
> 	   has been removed because hardware doesn't care about the value
> 	   these bits. Also, tests need to verify hardware behavior. So if
> 	   these bits are unset, the checks in nested_svm_check_bitmap_pa()
> 	   do not work as expected.
> 	5. In patch# 7, additional test cases have been added.
> 
> 
> [PATCH 1/7 v7] KVM: SVM: Define actual size of IOPM and MSRPM tables
> [PATCH 2/7 v7] KVM: nSVM: Define an exit code to reflect consistency
> [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and IOPM
> [PATCH 4/7 v7] nSVM: Check addresses of MSR and IO permission maps
> [PATCH 5/7 v7] SVM: Use ALIGN macro when aligning 'io_bitmap_area'
> [PATCH 6/7 v7] nSVM: Define an exit code to reflect consistency check
> [PATCH 7/7 v7] nSVM: Test addresses of MSR and IO permissions maps
> 
>   arch/x86/include/uapi/asm/svm.h |  1 +
>   arch/x86/kvm/svm/nested.c       | 29 +++++++++++++++++++++++------
>   arch/x86/kvm/svm/svm.c          | 20 ++++++++++----------
>   arch/x86/kvm/svm/svm.h          |  3 +++
>   4 files changed, 37 insertions(+), 16 deletions(-)
> 
> Krish Sadhukhan (4):
>        KVM: SVM: Define actual size of IOPM and MSRPM tables
>        KVM: nSVM: Define an exit code to reflect consistency check failure
>        KVM: nSVM: No need to set bits 11:0 in MSRPM and IOPM bitmaps
>        nSVM: Check addresses of MSR and IO permission maps
> 
>   x86/svm.c       |  2 +-
>   x86/svm.h       |  1 +
>   x86/svm_tests.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 79 insertions(+), 2 deletions(-)
> 
> Krish Sadhukhan (3):
>        SVM: Use ALIGN macro when aligning 'io_bitmap_area'
>        nSVM: Define an exit code to reflect consistency check failure
>        nSVM: Test addresses of MSR and IO permissions maps
> 

Queued except for SVM_CONSISTENCY_ERR.

Paolo

