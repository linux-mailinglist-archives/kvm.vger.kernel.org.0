Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF1F213F50
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 20:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgGCSl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 14:41:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42076 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgGCSl2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 14:41:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593801686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c83Dgu3F7bsHrP60t6VLlQzU3WYklyXESDcu0K3MgRU=;
        b=XfMbHs2JD8sSBX5KjRny4etHxOrsVHYiKsXRqDhInM9BCqpQEGzF41b3fXkhiH5MtNXT/a
        VsN/PwNcOxzFA73DyHiymJmLRxval/42BA7hwbbKGJ+GtvBAKPR54Lmz2rMyoMTNPpyR1E
        LlqIIlRkvG9DT87xSUitbp1A/6ubAGM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-B2__HWXXO2W0aUJ7C_I98A-1; Fri, 03 Jul 2020 14:41:25 -0400
X-MC-Unique: B2__HWXXO2W0aUJ7C_I98A-1
Received: by mail-qk1-f197.google.com with SMTP id g12so22183819qko.19
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 11:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c83Dgu3F7bsHrP60t6VLlQzU3WYklyXESDcu0K3MgRU=;
        b=efx0Sy2BAYhdItDjFeQTO0QWFLJ7Xi+g88R2RFhvnX6YG3QABSbpWyYTXOEEwB4YgJ
         btE3NQCjPoJpcQ3iAkt0dRt99Lx7/VKjNQFEMXR58DJ+Gk2VMWJgZdigOvEjW80wVrDT
         hYu5ifAcAdxaTC7mKyGuBoG+ua6AFdGtHCp/xkJhUZF4o0iwIhKjNdgaLDyiSuPcgkLv
         yzMTORBCyVO7+PA3vUrnKXxbgZL0iIQsh2MNMD5UCeDVLmw/xb/gkajfN0iVXUmTJ6YZ
         UCJ6rH58BiBKfYWPKwEnRlbubWeGqCLBP9NxWraryw1CxB/0LDqFqXwBAmOITmbJKxvW
         Ol9A==
X-Gm-Message-State: AOAM533aeUf//XKxrcexCq1I+4NYPLBHH98/Yy7qu7CWSmnzh3LW75uS
        mSubk//bKf6RHj8vK+K1ItMZF+dmQGTNzH78/CA8d6gDB6NzYFHUV8m2ttjhmGPkUVXKGie/U8Z
        AMb5SavcKlbsj
X-Received: by 2002:a0c:db8a:: with SMTP id m10mr36623050qvk.21.1593801684761;
        Fri, 03 Jul 2020 11:41:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBEnbzWFcgnnEyEN9LPngYgaXBJvTYCdREKhTVEN13IPzAhqv4lj8Wr6UjTQ7Znh1FC+wJ5w==
X-Received: by 2002:a0c:db8a:: with SMTP id m10mr36623028qvk.21.1593801684349;
        Fri, 03 Jul 2020 11:41:24 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a28sm10753840qko.45.2020.07.03.11.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 11:41:23 -0700 (PDT)
Date:   Fri, 3 Jul 2020 14:41:22 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v10 02/14] KVM: Cache as_id in kvm_memory_slot
Message-ID: <20200703184122.GF6677@xz-x1>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-3-peterx@redhat.com>
 <20200702230849.GL3575@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200702230849.GL3575@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 04:08:49PM -0700, Sean Christopherson wrote:
> On Mon, Jun 01, 2020 at 07:59:45AM -0400, Peter Xu wrote:
> > Cache the address space ID just like the slot ID.  It will be used in
> > order to fill in the dirty ring entries.
> > 
> > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  include/linux/kvm_host.h | 1 +
> >  virt/kvm/kvm_main.c      | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 01276e3d01b9..5e7bbaf7a36b 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -346,6 +346,7 @@ struct kvm_memory_slot {
> >  	unsigned long userspace_addr;
> >  	u32 flags;
> >  	short id;
> > +	u16 as_id;
> >  };
> >  
> >  static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 74bdb7bf3295..ebdd98a30e82 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1243,6 +1243,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  	if (!mem->memory_size)
> >  		return kvm_delete_memslot(kvm, mem, &old, as_id);
> 
> This technically needs to set as_id in the deleted memslot.  I highly doubt
> it will ever matter from a functionality perspective, but it'd be confusing
> to encounter a memslot whose as_id did not match that of its owner.

Yeah it shouldn't matter because as_id is directly passed in to look up the
pointer of kvm_memslots in kvm_delete_memslot, and memslot->as_id shouldn't be
further referenced.

I can add a comment above if this can clarify things a bit:

+	u16 as_id; /* cache of as_id; only valid if npages != 0 */

Thanks,

-- 
Peter Xu

