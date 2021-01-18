Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC762FA896
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389885AbhARSUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:20:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391921AbhARSUV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 13:20:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610993932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nzdbHs9DnXZuwfCrxQgg5xsyFMv8U3zDctTnTYZOsA=;
        b=S0JRkSkJnSuMAntQ1nbBfn3Hn76a97MSeTlWm+w1RSDAcUaZGUpWo8oRXFWQwvkLf8DPqp
        b1hC34NjPRXozzuUiYjc2D8ojar8TGqBfFV9DS+bWifM3C6MGSVZGcjPt7j7a2JL2ADTKC
        T5ylfeHcSO534mZVPjuWqOJUfHLCiWo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-BThCoTDWMKSiMUAvvWSkrQ-1; Mon, 18 Jan 2021 13:18:48 -0500
X-MC-Unique: BThCoTDWMKSiMUAvvWSkrQ-1
Received: by mail-wm1-f72.google.com with SMTP id k64so1308995wmb.6
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 10:18:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9nzdbHs9DnXZuwfCrxQgg5xsyFMv8U3zDctTnTYZOsA=;
        b=IotGVJ4yIiOcHo6Md9jPQOppHZP/GWUoYwnwgT/lGMaMbh+7omFlmdKGUNRgtX3cAY
         j4cIZheagXJH2PQI5GtFgRhoM0fsHauKISYp+gjGc8BFzeB7sIegPl7yz0nNMsoI2KNS
         2SQdF18BGWPXYj1jq2Yp2Vsac7HtXBvSWC99eIX7oRYJ5nQ/reqkMmLz6YDJMF1romgE
         HMMIZ+VAidER0pbWHKSDOWoYzvs7L1UnMvo1MDqiU3o53fxidY5QnsnTmF7e7xT/2/Dp
         KLYx4oVOAQu/SfyNgfDHefzpf5Qgf0gfFNYVO+Ql5rGunmuJcivpIU6hcuIi4z0fLLb8
         7A6Q==
X-Gm-Message-State: AOAM530qr49DigKexjNxPosCeARzliWY+71iLbmAOmL9h6XNL2fxz98h
        R4uBTYS1ZWQy1RYE2/Wsse9VzRJRzVXVqIMVc8uqNrbq4U8gddRv3k+1ROCWm8op+xF/CMJUYpE
        97QYOknade291
X-Received: by 2002:adf:ca0c:: with SMTP id o12mr755550wrh.154.1610993927414;
        Mon, 18 Jan 2021 10:18:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1+2GeM/1qZYRcP6dljE5LJB1kHaItKj7JwS5ZOhG3A410YI5REfRSqIG8QmHU2Hq01eib7g==
X-Received: by 2002:adf:ca0c:: with SMTP id o12mr755525wrh.154.1610993927121;
        Mon, 18 Jan 2021 10:18:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b10sm245322wmj.5.2021.01.18.10.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 10:18:46 -0800 (PST)
Subject: Re: [PATCH 0/6] KVM: selftests: Perf test cleanups and memslot
 modification test
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>, Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>
References: <20210112214253.463999-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <583b1769-0f35-8f77-8570-2cc41612e4d4@redhat.com>
Date:   Mon, 18 Jan 2021 19:18:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112214253.463999-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 22:42, Ben Gardon wrote:
> This series contains a few cleanups that didn't make it into previous
> series, including some cosmetic changes and small bug fixes. The series
> also lays the groundwork for a memslot modification test which stresses
> the memslot update and page fault code paths in an attempt to expose races.
> 
> Tested: dirty_log_perf_test, memslot_modification_stress_test, and
> 	demand_paging_test were run, with all the patches in this series
> 	applied, on an Intel Skylake machine.
> 
> 	echo Y > /sys/module/kvm/parameters/tdp_mmu; \
> 	./memslot_modification_stress_test -i 1000 -v 64 -b 1G; \
> 	./memslot_modification_stress_test -i 1000 -v 64 -b 64M -o; \
> 	./dirty_log_perf_test -v 64 -b 1G; \
> 	./dirty_log_perf_test -v 64 -b 64M -o; \
> 	./demand_paging_test -v 64 -b 1G; \
> 	./demand_paging_test -v 64 -b 64M -o; \
> 	echo N > /sys/module/kvm/parameters/tdp_mmu; \
> 	./memslot_modification_stress_test -i 1000 -v 64 -b 1G; \
> 	./memslot_modification_stress_test -i 1000 -v 64 -b 64M -o; \
> 	./dirty_log_perf_test -v 64 -b 1G; \
> 	./dirty_log_perf_test -v 64 -b 64M -o; \
> 	./demand_paging_test -v 64 -b 1G; \
> 	./demand_paging_test -v 64 -b 64M -o
> 
> 	The tests behaved as expected, and fixed the problem of the
> 	population stage being skipped in dirty_log_perf_test. This can be
> 	seen in the output, with the population stage taking about the time
> 	dirty pass 1 took and dirty pass 1 falling closer to the times for
> 	the other passes.
> 
> Note that when running these tests, the -o option causes the test to take
> much longer as the work each vCPU must do increases proportional to the
> number of vCPUs.
> 
> You can view this series in Gerrit at:
> https://linux-review.googlesource.com/c/linux/kernel/git/torvalds/linux/+/7216
> 
> Ben Gardon (6):
>    KVM: selftests: Rename timespec_diff_now to timespec_elapsed
>    KVM: selftests: Avoid flooding debug log while populating memory
>    KVM: selftests: Convert iterations to int in dirty_log_perf_test
>    KVM: selftests: Fix population stage in dirty_log_perf_test
>    KVM: selftests: Add option to overlap vCPU memory access
>    KVM: selftests: Add memslot modification stress test
> 
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/demand_paging_test.c        |  40 +++-
>   .../selftests/kvm/dirty_log_perf_test.c       |  72 +++---
>   .../selftests/kvm/include/perf_test_util.h    |   4 +-
>   .../testing/selftests/kvm/include/test_util.h |   2 +-
>   .../selftests/kvm/lib/perf_test_util.c        |  25 ++-
>   tools/testing/selftests/kvm/lib/test_util.c   |   2 +-
>   .../kvm/memslot_modification_stress_test.c    | 211 ++++++++++++++++++
>   9 files changed, 307 insertions(+), 51 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/memslot_modification_stress_test.c
> 

Queued, thanks.

Paolo

