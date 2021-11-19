Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6468457012
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 14:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbhKSNyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 08:54:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235574AbhKSNyS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 08:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637329876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0MQ6EmX5xeBMO7143sm+kmalOXvvH8veZYgNdztafAY=;
        b=Du9s4mAvHjp3HTcNatjhyJ3KkDckrh1zfwF+jr9J7tVTUY1CrL3DfvyXUTHnLQHOe9Rno0
        suBtY3F0jMozvjK2dV6+9taJfE+cvwqxmE/+wdEDYJ80TACvb3c4u2WGCrA7hu6Ypu+1H8
        V3z1nmVNSaNiEo+61RmAq44xQqOo/lo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-VJVV2pDlNlGcw331IPvvuQ-1; Fri, 19 Nov 2021 08:51:15 -0500
X-MC-Unique: VJVV2pDlNlGcw331IPvvuQ-1
Received: by mail-wm1-f71.google.com with SMTP id r129-20020a1c4487000000b00333629ed22dso5935189wma.6
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 05:51:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=0MQ6EmX5xeBMO7143sm+kmalOXvvH8veZYgNdztafAY=;
        b=1UKWoFcppQXgIdRgP/06DsZkn4r8/Hh/o9GNjC8wPe5xSMUkUa8L9hvKUYuTF+EgGW
         IJqICbwQhm7RDuotwIdX1vR5dMvtxyRL6xsJNkD1wjxFD7zHtV+bEC9gPOhq7sw8LOF6
         WwTBL31TDCIqjeAsRjJ+SCwsglSfx93wiw/YPx7cL/8t9Rc/p2eGNMJ6tjOjvSd3yc5O
         hkoZbjWSLCNT+0ghM1D+E6ktawqmDlU/RlXZn5um7XyawoewdZYaQKk+JIqvjR6eG9Ew
         B4uMrl0jyAN1i+S9oL0NR78xfNa70QRapA2OL8zoytMG5UA2VyFrNrUyYIpxUzat1WdU
         RG2w==
X-Gm-Message-State: AOAM533wJStDy+2TS5IAGGkQWdM0vhhZE9ToqHPgzoFk7zTU2zhJUJL4
        W9EUgaokGKM6J9q6udmb7j2jEiQP+uqMKpupsnNy/MnVId27A/gWFkpUjfonpY80ltOmzKjnfKh
        Zr35utzaxRWF3
X-Received: by 2002:a05:6000:1a45:: with SMTP id t5mr7549027wry.306.1637329874054;
        Fri, 19 Nov 2021 05:51:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyguzOIQ4dtj/UgUT64libXTpwo03IBVeH470Oj9eTA/dOIJOsebKLkqM9WONqcZosshV46JQ==
X-Received: by 2002:a05:6000:1a45:: with SMTP id t5mr7548995wry.306.1637329873829;
        Fri, 19 Nov 2021 05:51:13 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6271.dip0.t-ipconnect.de. [91.12.98.113])
        by smtp.gmail.com with ESMTPSA id f15sm3823943wmg.30.2021.11.19.05.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 05:51:13 -0800 (PST)
Message-ID: <942e0dd6-e426-06f6-7b6c-0e80d23c27e6@redhat.com>
Date:   Fri, 19 Nov 2021 14:51:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC v2 PATCH 01/13] mm/shmem: Introduce F_SEAL_GUEST
Content-Language: en-US
To:     Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, john.ji@intel.com, susie.li@intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com
References: <20211119134739.20218-1-chao.p.peng@linux.intel.com>
 <20211119134739.20218-2-chao.p.peng@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211119134739.20218-2-chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.11.21 14:47, Chao Peng wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> The new seal type provides semantics required for KVM guest private
> memory support. A file descriptor with the seal set is going to be used
> as source of guest memory in confidential computing environments such as
> Intel TDX and AMD SEV.
> 
> F_SEAL_GUEST can only be set on empty memfd. After the seal is set
> userspace cannot read, write or mmap the memfd.
> 
> Userspace is in charge of guest memory lifecycle: it can allocate the
> memory with falloc or punch hole to free memory from the guest.
> 
> The file descriptor passed down to KVM as guest memory backend. KVM
> register itself as the owner of the memfd via memfd_register_guest().
> 
> KVM provides callback that needed to be called on fallocate and punch
> hole.
> 
> memfd_register_guest() returns callbacks that need be used for
> requesting a new page from memfd.
> 

Repeating the feedback I already shared in a private mail thread:


As long as page migration / swapping is not supported, these pages
behave like any longterm pinned pages (e.g., VFIO) or secretmem pages.

1. These pages are not MOVABLE. They must not end up on ZONE_MOVABLE or
MIGRATE_CMA.

That should be easy to handle, you have to adjust the gfp_mask to
	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
just as mm/secretmem.c:secretmem_file_create() does.

2. These pages behave like mlocked pages and should be accounted as such.

This is probably where the accounting "fun" starts, but maybe it's
easier than I think to handle.

See mm/secretmem.c:secretmem_mmap(), where we account the pages as
VM_LOCKED and will consequently check per-process mlock limits. As we
don't mmap(), the same approach cannot be reused.

See drivers/vfio/vfio_iommu_type1.c:vfio_pin_map_dma() and
vfio_pin_pages_remote() on how to manually account via mm->locked_vm .

But it's a bit hairy because these pages are not actually mapped into
the page tables of the MM, so it might need some thought. Similarly,
these pages actually behave like "pinned" (as in mm->pinned_vm), but we
just don't increase the refcount AFAIR. Again, accounting really is a
bit hairy ...



-- 
Thanks,

David / dhildenb

