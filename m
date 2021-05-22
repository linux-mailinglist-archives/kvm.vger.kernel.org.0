Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B48838D575
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 12:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhEVLAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 May 2021 07:00:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhEVLAt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 May 2021 07:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621681163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j9rn+32PwVgmZlnPZcXzaefsik9C6TcVR0RDLcZXg4E=;
        b=UfqON+G65GIUQ1Xw9vK+Sapzx1Arowl5yirkSpdGC+sD0X9tOqKcldfGi9ie4R+7uC+wuO
        GvIp9v/ZASGrRtWuKkWLaW8UU03N7LMTL2ZufAYiVIzwMAbgjN82FxJTkqSY50MQSlwNf7
        zKKxMM+NjlSbY0cGdoR8HFHIIPPfCKg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-QEZqpLVVPE6GU44yzdTkDg-1; Sat, 22 May 2021 06:59:21 -0400
X-MC-Unique: QEZqpLVVPE6GU44yzdTkDg-1
Received: by mail-ed1-f69.google.com with SMTP id c21-20020a0564021015b029038c3f08ce5aso12842040edu.18
        for <kvm@vger.kernel.org>; Sat, 22 May 2021 03:59:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j9rn+32PwVgmZlnPZcXzaefsik9C6TcVR0RDLcZXg4E=;
        b=P95SUll/lBPC4tA4OhwGwRhPAtMfis+1iERD+BPvxKu9rtpUxtKfFfGnhlgDT+kWDj
         Tg7ipNlHyQigTUcsGbYUE+ZkO0t38UOWyPLNqsORqWrnSFYzwM+wjT6grusqQxr3NDXW
         ZVD8yNi7FBOhtgL7EylXqxmckolNIOzTidPQfEbzcQpEtfdCkpU8qBP/pdZhoq6xcrlx
         +eja/2rVqJ/bfWr3qqxJ4NPPZ/l2uwV+lRyC+PbPsSMrR9RrhjyQayRyqYamp87iXJrH
         9lVWXGv53PLuwcjPRrRWAKNAihcuL4m1BnDa2wN0yiR6evKcR0lxrWj/Xj7OfmXLh7kK
         3u3Q==
X-Gm-Message-State: AOAM530Dl+lUreIWa1O7kumqSECwe1PYG4MgPU88lH0NTZDhWCcjPJPB
        PcFeTvu/5ERGBsHRpaMoyvVsDT6YhQr8TZlrGvTYNUu6XtnsC1/es2N8fSYKGxGEwoG9I2Isf/m
        5jCn2lrcRrg66
X-Received: by 2002:a05:6402:50b:: with SMTP id m11mr16317245edv.367.1621681160272;
        Sat, 22 May 2021 03:59:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAAcmWjNrP2tJwk0BC5NT8x24rlkF12MgYLc3PSnIY9kp3sfdaHj9voOCQUgp3fK/PVVdaQA==
X-Received: by 2002:a05:6402:50b:: with SMTP id m11mr16317227edv.367.1621681160104;
        Sat, 22 May 2021 03:59:20 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id x10sm6039537edd.30.2021.05.22.03.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 03:59:19 -0700 (PDT)
Date:   Sat, 22 May 2021 12:59:18 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Venkatesh Srinivas <venkateshs@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] KVM: selftests: Fix 32-bit truncation of
 vm_get_max_gfn()
Message-ID: <20210522105918.krdukoxe7jd2df6a@gator>
References: <20210521173828.1180619-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521173828.1180619-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:38:28PM +0000, David Matlack wrote:
> vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
> which causes the upper 32-bits of the max_gfn to get truncated.
> 
> Nobody noticed until now likely because vm_get_max_gfn() is only used
> as a mechanism to create a memslot in an unused region of the guest
> physical address space (the top), and the top of the 32-bit physical
> address space was always good enough.
> 
> This fix reveals a bug in memslot_modification_stress_test which was
> trying to create a dummy memslot past the end of guest physical memory.
> Fix that by moving the dummy memslot lower.
> 
> Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
> Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
> 
> v1 -> v2:
>  - Added Venkatesh's R-b line.
>  - Used PRIx64 to print uint64_t instead of %lx.
> 
>  tools/testing/selftests/kvm/include/kvm_util.h |  2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c     |  2 +-
>  .../testing/selftests/kvm/lib/perf_test_util.c |  4 +++-
>  .../kvm/memslot_modification_stress_test.c     | 18 +++++++++++-------
>  4 files changed, 16 insertions(+), 10 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

