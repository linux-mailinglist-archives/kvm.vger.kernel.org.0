Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EF139F0B6
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhFHIXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhFHIXk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 04:23:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623140507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMCysKzuhfWQj6CjYw5Jk5VY+X58qQ9BlT7Wd58h01I=;
        b=iwZ+bpC4zoGVXPlUT2oDxfYnOWAKaPvQM5FmHmz62Nwc34ESwBi+CpOvnvEbAtn0jZOzfw
        3WoK9fItQmsaHkJI+hJRUNBZ3OFCxqNSQjAa8m1HzchZBEYRXImRyek5qRtUHK48iH528W
        4IkUUy/CyvdMcmXxGwxqNAhHfSSDW0o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-myeiPxIFPi-POrg9u8m8iw-1; Tue, 08 Jun 2021 04:21:46 -0400
X-MC-Unique: myeiPxIFPi-POrg9u8m8iw-1
Received: by mail-wm1-f69.google.com with SMTP id u17-20020a05600c19d1b02901af4c4deac5so427107wmq.7
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 01:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dMCysKzuhfWQj6CjYw5Jk5VY+X58qQ9BlT7Wd58h01I=;
        b=hUcEK606TyFBPmYE9gieVRhb89lKLWQYyua3n++cEXtw6aJO4TlTT4YGP0RgV7EZMt
         /69dkaqehexRQVOXzwM5T6eUIx9YBz/E6gk01G+mja1rxrxn7A2I3+av3TLAidpAXYsP
         pnr58iCzQG8TiHWbmUZycYPI/OwU3+O0JH8nleTKCdwM/ROCe9R7myCfY5wc8lG7d2UT
         Eq65oxOvoNawNtC0eAc36kGUowvCaXBuBbUUpEityaaMkKn7cynVFGd/Jxn1p2DjsxYu
         Y7qzUgntoSTojyoaMuO47h6fzYXQiuuHKdm1rIh19+ph5hKQvRqpZKCoR+LqTGK5CRVe
         SS6A==
X-Gm-Message-State: AOAM533NZhXE0o6M8RFRUu6KNSRfwoOfpzuaF18ANtZOptoLAlYlO7MP
        ICZC5V4bmALq0SClHV06Gh+oICL2RQudWqAHj5O21W6f84nT3y0KeMGIaXR0G41eytNMYCJdwj4
        Q96WcjPzSmuF7
X-Received: by 2002:a05:6000:1a8f:: with SMTP id f15mr12814162wry.260.1623140505298;
        Tue, 08 Jun 2021 01:21:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyuR0+5SlrkVXKTif892WYOeuI/p/q0R0wvXFQ+l9tDT532OtMyty7IrKMW9uNQZ/2048MZA==
X-Received: by 2002:a05:6000:1a8f:: with SMTP id f15mr12814155wry.260.1623140505175;
        Tue, 08 Jun 2021 01:21:45 -0700 (PDT)
Received: from gator (93-137-73-41.adsl.net.t-com.hr. [93.137.73.41])
        by smtp.gmail.com with ESMTPSA id b135sm2121778wmb.5.2021.06.08.01.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 01:21:44 -0700 (PDT)
Date:   Tue, 8 Jun 2021 10:21:42 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, maciej.szmigiero@oracle.com,
        pbonzini@redhat.com, shuah@kernel.org
Subject: Re: [PATCH 1/3] Revert "selftests: kvm: make allocation of extra
 memory take effect"
Message-ID: <20210608082142.umk5jauizkxxs4yb@gator>
References: <20210608233816.423958-1-zhenzhong.duan@intel.com>
 <20210608233816.423958-2-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608233816.423958-2-zhenzhong.duan@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 07:38:14AM +0800, Zhenzhong Duan wrote:
> This reverts commit 39fe2fc96694164723846fccf6caa42c3aee6ec4.
> 
> Parameter extra_mem_pages in vm_create_default() is used to calculate
> the page table size for all the memory chunks.
> Real memory allocation for non-slot0 memory happens by extra call of
> vm_userspace_mem_region_add() outside of vm_create_default().
> 
> The reverted commit changed above meaning of extra_mem_pages as extra
> slot0 memory size. This way made the page table size calculations
> open coded in separate test.
> 
> Link: https://lkml.org/lkml/2021/6/3/551
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 28e528c19d28..63418df921f0 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -320,7 +320,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
>  	 */
>  	uint64_t vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
>  	uint64_t extra_pg_pages = (extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
> -	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + extra_mem_pages + vcpu_pages + extra_pg_pages;
> +	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
>  	struct kvm_vm *vm;
>  	int i;
>  
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

