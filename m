Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263DD3B195A
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFWLzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34623 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhFWLzO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624449176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ti/ZapEQofSOgyCY32URs7OAEbZg1MUEdI99dbt0WZY=;
        b=bIRsoE3XGEGrCsdKkDVkReaBcv3sLlBLdURVjPsobjeevBx7yCEl6jAZdPQG2kyFQlgRdx
        D/3fWYJNqau2vCqPNuDAu1gl1kWCkuoh7Sbakl/ouVsqZGC6B6zLmB9MI+UNwad3HhAqkV
        w8LzonjURA+L5qQNLu2ubTTcn1K+VAY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-7HWchB6-NQKCD5XlbB8cmg-1; Wed, 23 Jun 2021 07:52:55 -0400
X-MC-Unique: 7HWchB6-NQKCD5XlbB8cmg-1
Received: by mail-wm1-f70.google.com with SMTP id s80-20020a1ca9530000b02901cff732fde5so510045wme.6
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 04:52:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ti/ZapEQofSOgyCY32URs7OAEbZg1MUEdI99dbt0WZY=;
        b=tORmmuBc668rWK2H1Y/IpsSXpAZ06t0VeKJp5Dajz71QdYIa49wwvJaGOCGRghO0He
         Co5SqCVPIkJnJOwCDXuRTf3TF3l3P3fOeoyiqQhJx0WhMvEbjIjUThXa7ApHmiICAEvc
         RxbWj35bwjhhUp6GVPI3oiOOq5I1E3hw/tJO70faWd+viQujG6iypzz4A5Dgtg/vq1el
         b+GrQqIm+Q8toYlgWwzdZsbs+q9KCnF+apxMgYN/8B5EuUaoghDJFUlXdnSZ4NZ9uqD4
         MIk+i03twQCd5kCE8nD9visGyi7zMXAEfFLwlJ1mwp/StQnsc1QwZN65YzDhbvbwW9lQ
         RqwQ==
X-Gm-Message-State: AOAM5312463asP0wAhNasTmdDcz2umpFutc74aguEG6c0N96ESpqtHHq
        rNc0B4L9NwpXcGMxK2k+urDGU9BYwmtMd2oHmbBQ3MJhExtCMcTiIhMyegPvdcY5dKsleuqLaNf
        xVQ57jdQKmLW0bXgt6shOzwct9B3Rf8TrSuly7WOLQO9PJBrWuTeBs/kKHrbB8SZs
X-Received: by 2002:a7b:c346:: with SMTP id l6mr10054526wmj.109.1624449174150;
        Wed, 23 Jun 2021 04:52:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4BtzXNtSWx26WDklJOd7CY3SC2PGptCaT7HfuwW2GeWN9FB5Z3V5p7d4WO2rpm1ywpGuyRg==
X-Received: by 2002:a7b:c346:: with SMTP id l6mr10054502wmj.109.1624449173852;
        Wed, 23 Jun 2021 04:52:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m8sm2729175wrz.97.2021.06.23.04.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 04:52:53 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 00/12] nSVM: NPT improvements and cleanups
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20210622210047.3691840-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b1dc5cf-f602-1ec9-2440-229c599dd7da@redhat.com>
Date:   Wed, 23 Jun 2021 13:52:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 23:00, Sean Christopherson wrote:
> The first chunk of this series (everything up to the lib/vmalloc patch)
> are cleanups and bug fixes for existing nSVM tests that I collected on
> my first attempt at the new NPT test.  I originally wanted to piggyback
> the existing "v1" nSVM tests and implemented the fixes/cleanups, but that
> approach didn't go so well because of the v1 infrastructure limitations.
> 
> The common lib/vmalloc changes are to allow arch code to pass arbitrary
> data to its setup_mmu() function.  x86-64 uses the param to avoid marking
> PTEs a USER so that tests can enable SMEP (#PF if supervisor mode fetches
> from a USER PTE) without exploding or having to duplicate all page tables.
> 
> The "new" test targets nested NPT by running L1 and L2 with different
> EFER.NX and CR4.SMEP settings to verify that KVM uses the correct MMU
> settings when injecting page faults.
> 
> Sean Christopherson (12):
>    nSVM: Provide expected and actual exit codes on VMRUN test failure
>    nSVM: Replace open coded NX manipulation with appropriate macros
>    nSVM: Reset the VMCB before every v1 test
>    nSVM: Explicitly save/update/restore EFER.NX for NPT NX test
>    nSVM: Remove NPT reserved bits tests (new one on the way)
>    nSVM: Stop forcing EFER.NX=1 for all tests
>    nSVM: Remove a superfluous modification of guest EFER.NX in NPT NX
>      test
>    nSVM: Clear guest's EFER.NX in NPT NX test
>    lib/vmalloc: Let arch code pass a value to its setup_mmu() helper
>    x86: Let tests omit PT_USER_MASK when configuring virtual memory
>    x86: Add GBPAGES CPUID macro, clean up CPUID comments
>    nSVM: Add test for NPT reserved bit and #NPF error code behavior
> 
>   lib/arm/mmu.c       |   2 +-
>   lib/s390x/mmu.c     |   3 +-
>   lib/vmalloc.c       |   9 +-
>   lib/vmalloc.h       |   4 +-
>   lib/x86/processor.h |  15 +--
>   lib/x86/vm.c        |  15 ++-
>   s390x/uv-host.c     |   2 +-
>   x86/svm.c           |  10 +-
>   x86/svm_tests.c     | 220 +++++++++++++++++++++++++++++++-------------
>   9 files changed, 196 insertions(+), 84 deletions(-)
> 

Queued, thanks.

Paolo

