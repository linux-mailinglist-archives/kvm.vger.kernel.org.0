Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025BF367A7B
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 09:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhDVHDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 03:03:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234777AbhDVHD2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 03:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619074974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U1sBIWc97pwUoI/Y/7htamKNpDUssIIcTnKBNjle2Og=;
        b=bezU014srEopERg1BU56cqWRPWt2I1+kIkQFkF+NO9DomHp0rmtGvIMlNIq9V9/s6b44BW
        SFcw3M47HMs42V3BOORAJaiyTF3Jq4O2htWfhXOjwZ1nFxwh+c/AW6MwTRjWwk7Z1Xj0OZ
        4RzOgDppkfZibh75pFp7jnl/5Ixz+tc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-GZLWv_hnN-qdrNQGcz0MhQ-1; Thu, 22 Apr 2021 03:02:13 -0400
X-MC-Unique: GZLWv_hnN-qdrNQGcz0MhQ-1
Received: by mail-ed1-f70.google.com with SMTP id p16-20020a0564021550b029038522733b66so8159033edx.11
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 00:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U1sBIWc97pwUoI/Y/7htamKNpDUssIIcTnKBNjle2Og=;
        b=E/dwCIcs2vi8C8Q/uqmi8f4Intfm9Mf8/YLQG6UMWAoEGxngSBkeFLhKfxQeleIwWR
         mQUFuG7bK1ZcubAKfG0za7DGs/4OJXDp2dCHvttSInIIsgzv2Mr62X6HpGhwppnqyXj5
         QBKe9MfFl6cd+n/BB79/Te/Zb7+dlszmBgfuMDe3eNZrYuBQptsNVIZGRBhQ6WlACRDh
         nGr+HvWxLrcpGhK1JwUH59BML44uCI8wVwYbYeh1WDH5Lwkc36qHLfxQPgZe4E39Fabh
         WLC5gOSWnXdgZ+jinEhQNGV5XnayvL69wYK4XQx/C2PHSynjbmZIcdfKIiCivGhjiMcx
         mSsA==
X-Gm-Message-State: AOAM533F988WkpzxJsEF/5QHrww/ectVk4+yoUPzYSvHJS/jppcigrLS
        gDzkcgMfjil0MrYJDLk7uIb5q+1Wz9oi3ip3OxGX7CNxXXB746kuQXjy76mDPxEZtEzCK0YL26k
        mkQ62ZOLHozxV
X-Received: by 2002:a05:6402:54f:: with SMTP id i15mr1922201edx.365.1619074932203;
        Thu, 22 Apr 2021 00:02:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwW6HSmx2bqE6mJ1T+jSutBTgTnXdsbeh+wMEVf31ITrNbtI2a0LDOgDf0Ru09R/HBq590CVw==
X-Received: by 2002:a05:6402:54f:: with SMTP id i15mr1922156edx.365.1619074931964;
        Thu, 22 Apr 2021 00:02:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n13sm1196993ejx.27.2021.04.22.00.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 00:02:11 -0700 (PDT)
Subject: Re: [PATCH 0/5] KVM: x86: Use kernel x86 cpuid utilities in KVM
 selftests
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210422005626.564163-1-ricarkol@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c4524e4a-55c7-66f9-25d6-d397f11d25a8@redhat.com>
Date:   Thu, 22 Apr 2021 09:02:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422005626.564163-1-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 02:56, Ricardo Koller wrote:
> The kernel has a set of utilities and definitions to deal with x86 cpu
> features.  The x86 KVM selftests don't use them, and instead have
> evolved to use differing and ad-hoc methods for checking features. The
> advantage of the kernel feature definitions is that they use a format
> that embeds the info needed to extract them from cpuid (function, index,
> and register to use).
> 
> The first 3 patches massage the related cpuid header files in the kernel
> side, then copy them into tools/ so they can be included by selftests.
> The last 2 patches replace the tests checking for cpu features to use
> the definitions and utilities introduced from the kernel.

I queued the first, but I am not sure about the rest.

An alternative is to copy over the code from kvm-unit-tests which 
encodes the leaf/subleaf/register/bit values into the X86_FEATURE_* 
value.  Sharing code with kvm-unit-tests is probably simpler than adding 
#ifdef __KERNEL__ and keeping the headers in sync.

Paolo

> Thanks,
> Ricardo
> 
> Ricardo Koller (5):
>    KVM: x86: Move reverse CPUID helpers to separate header file
>    x86/cpu: Expose CPUID regs, leaf and index definitions to tools
>    tools headers x86: Copy cpuid helpers from the kernel
>    KVM: selftests: Introduce utilities for checking x86 features
>    KVM: selftests: Use kernel x86 cpuid features format
> 
>   arch/x86/events/intel/pt.c                    |   1 +
>   arch/x86/include/asm/cpufeature.h             |  23 +-
>   arch/x86/include/asm/processor.h              |  11 -
>   arch/x86/kernel/cpu/scattered.c               |   2 +-
>   arch/x86/kernel/cpuid.c                       |   2 +-
>   arch/x86/kvm/cpuid.h                          | 177 +-----------
>   arch/x86/kvm/reverse_cpuid.h                  | 185 +++++++++++++
>   tools/arch/x86/include/asm/cpufeature.h       | 257 ++++++++++++++++++
>   tools/arch/x86/include/asm/cpufeatures.h      |   3 +
>   .../selftests/kvm/include/x86_64/cpuid.h      |  61 +++++
>   .../selftests/kvm/include/x86_64/processor.h  |  16 --
>   .../kvm/include/x86_64/reverse_cpuid.h        | 185 +++++++++++++
>   .../selftests/kvm/include/x86_64/svm_util.h   |  11 +-
>   tools/testing/selftests/kvm/lib/x86_64/svm.c  |   6 +-
>   tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   5 +-
>   tools/testing/selftests/kvm/steal_time.c      |   5 +-
>   .../kvm/x86_64/cr4_cpuid_sync_test.c          |  23 +-
>   .../selftests/kvm/x86_64/set_sregs_test.c     |  25 +-
>   .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c  |   8 +-
>   .../kvm/x86_64/vmx_set_nested_state_test.c    |   5 +-
>   .../selftests/kvm/x86_64/xss_msr_test.c       |  10 +-
>   21 files changed, 749 insertions(+), 272 deletions(-)
>   create mode 100644 arch/x86/kvm/reverse_cpuid.h
>   create mode 100644 tools/arch/x86/include/asm/cpufeature.h
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/cpuid.h
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/reverse_cpuid.h
> 

