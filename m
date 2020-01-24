Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368C41479F5
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 10:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbgAXJDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 04:03:34 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730154AbgAXJDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 04:03:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579856612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cGV03so4TJUVNxTHBPjUgBHf9u2Qt26G8+DPtD3dDMU=;
        b=hf4Zu9Ak8MxJ2PtzIsoKG/ZCw/SynLVpQ8rUYBXouyLLCsc6VzjdUsBrjiiKExUl5b2sla
        6a1+RwAmvAuorztGm4ysSmquhP8fU7RGPtAy5dVQtJKRnYBahekvyMvdq7nRUbdH+6EDuR
        9YJM2lyAuW5ehVaOcCfmyzlQGphcAGE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-KpipDcIeMPqE0I6OtTwmuQ-1; Fri, 24 Jan 2020 04:03:27 -0500
X-MC-Unique: KpipDcIeMPqE0I6OtTwmuQ-1
Received: by mail-wr1-f70.google.com with SMTP id i9so860343wru.1
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 01:03:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cGV03so4TJUVNxTHBPjUgBHf9u2Qt26G8+DPtD3dDMU=;
        b=m8Uvqbo/8sQFodl9XxVY/8JW0U/A9waEv7Gp/s1IU37rqKDd3gXn2QMMTegAZUDrXC
         UQ95VJJ9iW3ffZB0TapQmimyJdVRuq4TMc9NPbDhu9xxvnYgXENc8jJ5XAwUH6p1goO1
         pQJkzvzFZ4wwiXmvEubpLTnKhgleXXbief18ppXrS0zjwMg/DnMle86MVWGjsJdmA89p
         farkLZUNpjc5UxgpsUwj6Zwi21n8qQY/vUWuI7nxLu85gko9eSPzLYPYsWgtpGSeM9Zi
         6Bo0mzpT2XIhHeY5SXkAJE2Tgo7Or4TeLQ3ofJfxb64QeXbfymOeOdsNUmXDhUmUS8Hp
         Ih+A==
X-Gm-Message-State: APjAAAUo42LqPPThStgEqvkQbFUygIp+iAxfj0TXT+rHI3PEwj5ymTf6
        JQSpRUNW+Tblk0SFvzxsBKgbOXhHtBhYMOdPAqK07+w2R+WSkwzMrK7NCdMMEtJRZIyfWnZf6k7
        fs0dixGB+L+Uf
X-Received: by 2002:adf:e984:: with SMTP id h4mr3097041wrm.275.1579856606061;
        Fri, 24 Jan 2020 01:03:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqwVym38FHLzxAKJjxh+pY7fa6l2PaOb5xGqMX5YB5NZ26ONISPMQJkKezf+m5gpTKXuBthv+A==
X-Received: by 2002:adf:e984:: with SMTP id h4mr3097015wrm.275.1579856605784;
        Fri, 24 Jan 2020 01:03:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id x10sm6418162wrv.60.2020.01.24.01.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 01:03:25 -0800 (PST)
Subject: Re: [PATCH v4 00/10] Create a userfaultfd demand paging test
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
References: <20200123180436.99487-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b00b37f7-ab2e-ce8a-da7e-7530f74ce3f4@redhat.com>
Date:   Fri, 24 Jan 2020 10:03:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200123180436.99487-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 19:04, Ben Gardon wrote:
> When handling page faults for many vCPUs during demand paging, KVM's MMU
> lock becomes highly contended. This series creates a test with a naive
> userfaultfd based demand paging implementation to demonstrate that
> contention. This test serves both as a functional test of userfaultfd
> and a microbenchmark of demand paging performance with a variable number
> of vCPUs and memory per vCPU.
> 
> The test creates N userfaultfd threads, N vCPUs, and a region of memory
> with M pages per vCPU. The N userfaultfd polling threads are each set up
> to serve faults on a region of memory corresponding to one of the vCPUs.
> Each of the vCPUs is then started, and touches each page of its disjoint
> memory region, sequentially. In response to faults, the userfaultfd
> threads copy a static buffer into the guest's memory. This creates a
> worst case for MMU lock contention as we have removed most of the
> contention between the userfaultfd threads and there is no time required
> to fetch the contents of guest memory.
> 
> This test was run successfully on Intel Haswell, Broadwell, and
> Cascadelake hosts with a variety of vCPU counts and memory sizes.
> 
> This test was adapted from the dirty_log_test.
> 
> The series can also be viewed in Gerrit here:
> https://linux-review.googlesource.com/c/virt/kvm/kvm/+/1464
> (Thanks to Dmitry Vyukov <dvyukov@google.com> for setting up the Gerrit
> instance)
> 
> v4 (Responding to feedback from Andrew Jones, Peter Xu, and Peter Shier):
> - Tested this revision by running
>   demand_paging_test
>   at each commit in the series on an Intel Haswell machine. Ran
>   demand_paging_test -u -v 8 -b 8M -d 10
>   on the same machine at the last commit in the series.
> - Readded partial aarch64 support, though aarch64 and s390 remain
>   untested
> - Implemented pipefd polling to reduce UFFD thread exit latency
> - Added variable unit input for memory size so users can pass command
>   line arguments of the form -b 24M instead of the raw number or bytes
> - Moved a missing break from a patch later in the series to an earlier
>   one
> - Moved to syncing per-vCPU global variables to guest and looking up
>   per-vcpu arguments based on a single CPU ID passed to each guest
>   vCPU. This allows for future patches to pass more than the supported
>   number of arguments for each arch to the vCPUs.
> - Implemented vcpu_args_set for s390 and aarch64 [UNTESTED]
> - Changed vm_create to always allocate memslot 0 at 4G instead of only
>   when the number of pages required is large.
> - Changed vcpu_wss to vcpu_memory_size for clarity.
> 
> Ben Gardon (10):
>   KVM: selftests: Create a demand paging test
>   KVM: selftests: Add demand paging content to the demand paging test
>   KVM: selftests: Add configurable demand paging delay
>   KVM: selftests: Add memory size parameter to the demand paging test
>   KVM: selftests: Pass args to vCPU in global vCPU args struct
>   KVM: selftests: Add support for vcpu_args_set to aarch64 and s390x
>   KVM: selftests: Support multiple vCPUs in demand paging test
>   KVM: selftests: Time guest demand paging
>   KVM: selftests: Stop memslot creation in KVM internal memslot region
>   KVM: selftests: Move memslot 0 above KVM internal memslots
> 
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   5 +-
>  .../selftests/kvm/demand_paging_test.c        | 680 ++++++++++++++++++
>  .../testing/selftests/kvm/include/test_util.h |   2 +
>  .../selftests/kvm/lib/aarch64/processor.c     |  33 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  27 +-
>  .../selftests/kvm/lib/s390x/processor.c       |  35 +
>  tools/testing/selftests/kvm/lib/test_util.c   |  61 ++
>  8 files changed, 839 insertions(+), 5 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/demand_paging_test.c
>  create mode 100644 tools/testing/selftests/kvm/lib/test_util.c
> 

Queued patches 1-9, thanks.

Paolo

