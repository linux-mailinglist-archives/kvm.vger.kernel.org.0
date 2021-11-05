Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4AE4460D5
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 09:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhKEIrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 04:47:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229473AbhKEIrh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 04:47:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636101898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ILMiQoA9N1ZZHarQUH3yJ1BzVlW0gt9hlPE7t59A3Pw=;
        b=ZE3qjOZIRJyZQbQzHvr7qHMHmttqxIlBE/FZ7YNhLCKisrHt22kfieRR+T+XRp3KicbNvt
        floP+2+MD0bEXr4CFc2nUK0Vtxf16SmiBEaebJQ8GtIs1EL63xAncW+SO4yLfE4razUcK9
        Qe7IsbBL01W6i06lN6te56tRKHBfBHY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-QRhjP_tQN2iwLT1S-FaJhg-1; Fri, 05 Nov 2021 04:44:55 -0400
X-MC-Unique: QRhjP_tQN2iwLT1S-FaJhg-1
Received: by mail-wr1-f71.google.com with SMTP id w14-20020adfbace000000b001884bf6e902so1371773wrg.3
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 01:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ILMiQoA9N1ZZHarQUH3yJ1BzVlW0gt9hlPE7t59A3Pw=;
        b=dafIw57mRQEPO1xCod5u9afiqDwh8tyJ6NnOa/YM/M+6FLJ6UGVKacWaTxGCw01VfX
         KVs95YVYDplnRW3GYxdzzzFohcAoS6r8wxkbQlyC923NZ/lLiKEgpHCQivgrkSXaCTb6
         vcFhlap23OOqT0gE7Erj5wQX/DnwPkURtHob9SzmK8Zt+myUDysCAdAWbJFd4UOjw645
         xGsOv7odIEm1Hnd/B/3wudeXBqjrWS0MI1duxOrH33Wpm1sIchjAD3eC3u60C/umdHKn
         NJWAfU8Mb7AImJO+z/LbkfirL0xW/1VVofZn0i1rVvKWnUMw1JRJbbzUC93tVa29J1p1
         RTlg==
X-Gm-Message-State: AOAM532gKZC0W8E+QA0ikmHnQRpG8WAM5VgiSG1EByMmbXVeOhyT45bC
        BIkkOn9ieQibztiv8SSnLt/kimlzURjPvZyZ2ggES13Z9Dd5Sqw6EgkylziVn77RHl2rrNjpg8d
        YuBo36fQMUKc4
X-Received: by 2002:adf:bd8a:: with SMTP id l10mr71441136wrh.159.1636101894215;
        Fri, 05 Nov 2021 01:44:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUYl+88kzXLPjQo33rtPM4xQCktiHkNFHkzUCA5+RxLTr+Hy/vtCp1QgFxmdJaBTKvgNy6Eg==
X-Received: by 2002:adf:bd8a:: with SMTP id l10mr71441108wrh.159.1636101894003;
        Fri, 05 Nov 2021 01:44:54 -0700 (PDT)
Received: from [192.168.43.15] (93-33-2-31.ip42.fastwebnet.it. [93.33.2.31])
        by smtp.gmail.com with ESMTPSA id h7sm7103976wrt.64.2021.11.05.01.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 01:44:53 -0700 (PDT)
Message-ID: <c9bd3bca-f901-d8db-c23d-5292ab7bd247@redhat.com>
Date:   Fri, 5 Nov 2021 09:44:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: RFC: KVM: x86/mmu: Eager Page Splitting
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
References: <CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/21 23:45, David Matlack wrote:
> The goal of this RFC is to get feedback on "Eager Page Splitting",
> an optimization that has been in use in Google Cloud since 2016 to 
> reduce the performance impact of live migration on customer 
> workloads. We wanted to get feedback on the feature before delving 
> too far into porting it to the latest upstream kernel for submission.
> If there is interest in adding this feature to KVM we plan to follow
> up in the coming months with patches.

Hi David!

I'm definitely interested in eager page splitting upstream, but with a
twist: in order to limit the proliferation of knobs, I would rather
enable it only when KVM_DIRTY_LOG_INITIALLY_SET is set, and do the split
on the first KVM_CLEAR_DIRTY_LOG ioctl.

Initially-all-set does not require write protection when dirty logging
is enabled; instead, it delays write protection to the first
KVM_CLEAR_DIRTY_LOG.  In fact, I believe that eager page splitting can
be enabled unconditionally for initial-all-set.  You would still have
the benefit of moving the page splitting out of the vCPU run
path; and because you can smear the cost of splitting over multiple
calls, most of the disadvantages go away.

Initially-all-set is already the best-performing method for bitmap-based
dirty page tracking, so it makes sense to focus on it.  Even if Google
might not be using initial-all-set internally, adding eager page
splitting to the upstream code would remove most of the delta related to
it.  The rest of the delta can be tackled later; I'm not super
interested in adding eager page splitting for the older methods (clear
on KVM_GET_DIRTY_LOG, and manual-clear without initially-all-set), but
it should be useful for the ring buffer method and that *should* share
most of the code with the older methods.

> In order to avoid allocating while holding the MMU lock, vCPUs 
> preallocate everything they need to handle the fault and store it in 
> kvm_mmu_memory_cache structs. Eager Page Splitting does the same 
> thing but since it runs outside of a vCPU thread it needs its own 
> copies of kvm_mmu_memory_cache structs. This requires refactoring the
> way kvm_mmu_memory_cache structs are passed around in the MMU code
> and adding kvm_mmu_memory_cache structs to kvm_arch.

That's okay, we can move more arguments to structs if needed in the same
was as struct kvm_page_fault; or we can use kvm_get_running_vcpu() if
it's easier or more appropriate.

> * Increases the duration of the VM ioctls that enable dirty logging. 
> This does not affect customer performance but may have unintended 
> consequences depending on how userspace invokes the ioctl. For 
> example, eagerly splitting a 1.5TB memslot takes 30 seconds.

This issue goes away (or becomes easier to manage) if it's done in
KVM_CLEAR_DIRTY_LOG.

> "RFC: Split EPT huge pages in advance of dirty logging" [1] was a 
> previous proposal to proactively split large pages off of the vCPU 
> threads. However it required faulting in every page in the migration 
> thread, a vCPU-like thread in QEMU, which requires extra userspace 
> support and also is less efficient since it requires faulting.

Yeah, this is best done on the kernel side.

> The last alternative is to perform dirty tracking at a 2M 
> granularity. This would reduce the amount of splitting work required
>  by 512x, making the current approach of splitting on fault less 
> impactful to customer performance. We are in the early stages of 
> investigating 2M dirty tracking internally but it will be a while 
> before it is proven and ready for production. Furthermore there may 
> be scenarios where dirty tracking at 4K would be preferable to reduce
> the amount of memory that needs to be demand-faulted during precopy.

Granularity of dirty tracking is somewhat orthogonal to this anyway,
since you'd have to split 1G pages down to 2M.  So please let me know if
you're okay with the above twist, and let's go ahead with the plan!

Paolo

