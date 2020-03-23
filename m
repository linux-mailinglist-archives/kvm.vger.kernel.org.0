Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5295218FD5B
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 20:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgCWTMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 15:12:12 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:28088 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727624AbgCWTMM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 15:12:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584990731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fgrAHu1BxFkFO8E2XTbHvJRFF+z4d/8YKZf4AbCghtU=;
        b=BzGKmwYHvORXIg48h0vUhAxwKV18cjs6WMvEJVtY5jSUeedmm+x7RYf0nv0MeXq/EEchzI
        nQvwtE9F8HNzu3dbYN7PulU6BkoqHk1OPTrAn37Ofw59Rebh6STtwxjenlyi6M3ygyKHGd
        Ck9f7D1HCHNbkhjAHfZqmQRKjZqN7l4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-YrtcqZEwOeGpdx6QLviK0g-1; Mon, 23 Mar 2020 15:12:09 -0400
X-MC-Unique: YrtcqZEwOeGpdx6QLviK0g-1
Received: by mail-wm1-f70.google.com with SMTP id f185so207454wmf.8
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 12:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fgrAHu1BxFkFO8E2XTbHvJRFF+z4d/8YKZf4AbCghtU=;
        b=ekD2gg2cXculSuUU1IC2G70m35tUv4JcYb+jLY8utANVQy3mWLpoInamHTS5xnuy1Y
         JQQA+Vgwz79eeih47AAHyHgoV/V+Dl82D4zhSZsZxvF7dPbEtJsagdURcAhoKjiYIbv1
         2fcK6QiZelEa0Tus3zjq+J6u/gHYUPslVsgWOfHIrcXdK8TW/+IVXfwfAbzck8XmJH92
         L5CBXt53LGqiqZkdt+eS44m6oHIcE88x0be5ZNULrJ55/Uk19cL/XiGJLRGfe8WKLSt7
         OoPtSfFYPM4Mr6eQ/meYN8Taie+m+Yrf9Xrk0VxpVvvg/era4cQXw3n6NxbRXte/mT7U
         ZWFA==
X-Gm-Message-State: ANhLgQ0V1atRne0cm5DykvDL8/nrhWGt7L0TYulyjduxYfOY6a3PEUn+
        +Cn7kFV5FVusFMSIeUudwkGay0bM7YnbQWYZP0dTg16SrSqdGwRsAoJ2bhxpUjlw1VTM5NylRcP
        QxfFR9wp8NZGs
X-Received: by 2002:a05:600c:20c7:: with SMTP id y7mr969801wmm.38.1584990727798;
        Mon, 23 Mar 2020 12:12:07 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvI6FN87AuoICeOVZww+CrDUVby7jnBBCp+g/rZiiNhh884vbdRbO+WpvR0BsEJUCbSMTPLFA==
X-Received: by 2002:a05:600c:20c7:: with SMTP id y7mr969764wmm.38.1584990727468;
        Mon, 23 Mar 2020 12:12:07 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id s22sm655926wmc.16.2020.03.23.12.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 12:12:06 -0700 (PDT)
Date:   Mon, 23 Mar 2020 15:12:02 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH 6/7] KVM: selftests: Expose the primary memslot number to
 tests
Message-ID: <20200323191202.GN127076@xz-x1>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-7-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200320205546.2396-7-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 01:55:45PM -0700, Sean Christopherson wrote:
> Add a define for the primary memslot number so that tests can manipulate
> the memslot, e.g. to delete it.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 2 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 0f0e86e188c4..43b5feb546c6 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -60,6 +60,8 @@ enum vm_mem_backing_src_type {
>  	VM_MEM_SRC_ANONYMOUS_HUGETLB,
>  };
>  
> +#define VM_PRIMARY_MEM_SLOT	0
> +
>  int kvm_check_cap(long cap);
>  int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
>  
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index f69fa84c9a4c..6a1af0455e44 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -247,8 +247,8 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  	/* Allocate and setup memory for guest. */
>  	vm->vpages_mapped = sparsebit_alloc();
>  	if (phy_pages != 0)
> -		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> -					    0, 0, phy_pages, 0);
> +		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0,
> +					    VM_PRIMARY_MEM_SLOT, phy_pages, 0);

IIUC VM_PRIMARY_MEM_SLOT should be used more than here... E.g., to all
the places that allocate page tables in virt_map() as the last param?
I didn't check other places.

Maybe it's simpler to drop this patch for now and use 0 directly as
before for now, after all in the last patch the comment is good enough
for me to understand slot 0 is the default slot.

Thanks,

>  
>  	return vm;
>  }
> -- 
> 2.24.1
> 

-- 
Peter Xu

