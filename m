Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C1D18F7D4
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 15:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgCWO6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 10:58:35 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38297 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgCWO6e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 10:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584975513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d3WRK4z56Y42/PY4ghJillk9+g6MIzYsEFbTD8+0g1Y=;
        b=b+NEvRIRjs7TEJ0cyCOWuLA5lNVxgKtWBdZfYEPrBZn+ouR11W0Rwd8pdD7hw5JAIDnKdc
        8wmXJJI92dTlYjWMUZlEU5fEgQ3QdaoW0TKT7yaYG33t1UK6j5Eo1XGdpWg7DHBFadvniu
        0jZftBintjl9L7+4AuAJ6Blvtfvsx/I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-jFyzy9QVNS2PPiQ8uMlUZw-1; Mon, 23 Mar 2020 10:58:31 -0400
X-MC-Unique: jFyzy9QVNS2PPiQ8uMlUZw-1
Received: by mail-wr1-f70.google.com with SMTP id v6so7423368wrg.22
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 07:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d3WRK4z56Y42/PY4ghJillk9+g6MIzYsEFbTD8+0g1Y=;
        b=p0NCkN9H7IKFiWxfo8swHLaHfrtvVi9AS+obl5XhdG/JZFFWRSA1PQBEYbiemHvTB4
         qMHgZDmsUc5QKNwTqPrY7baB57phhd0mfqwD7Z/4deklLRy4Y/HNpmZkF/N8z8fZ2X+7
         gaXjAeuGo0D1Cv/JGBjb2hmrry0B3Jpam9+Uw2Sw+nVq5vwmWqI7yIqlBdHy6eE6pAeO
         pWbHeekcB8oRkSxkQk/6ISEEgc4R2y7eObSnpjQjg2/+9TXK77NLB/U8nyvTb8YporvC
         q/S36BuyqdT6OodfP5iwR56lbaInEOA5OJGOYWWDCe7jQDL92ZAFVf96uvRTKmFlhjlQ
         W8cQ==
X-Gm-Message-State: ANhLgQ2qLjETIqnp5viPhuWGIlHWo2uvslCEkEPfgJS9ZTCvccC/FXmh
        ZsWmAAlNJWFy8mFmnPBFRpmbmSkaeVm5tWJK+no5sECXolfq+VK1TlHXfhd3X4bnRQRNxiF/QDI
        2Pd+XYfFX5h93
X-Received: by 2002:a1c:63c4:: with SMTP id x187mr27485585wmb.124.1584975510400;
        Mon, 23 Mar 2020 07:58:30 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtoTXAh8X4n57EHAjSowNYqJvDEgjxu7m+yH90pSUDygASePCuRdJZ/5o/fIE8laYiQAShSiw==
X-Received: by 2002:a1c:63c4:: with SMTP id x187mr27485546wmb.124.1584975510037;
        Mon, 23 Mar 2020 07:58:30 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id 195sm22060803wmb.8.2020.03.23.07.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 07:58:29 -0700 (PDT)
Date:   Mon, 23 Mar 2020 10:58:24 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200323145824.GI127076@xz-x1>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-4-peterx@redhat.com>
 <20200321192211.GC13851@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200321192211.GC13851@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 21, 2020 at 12:22:11PM -0700, Sean Christopherson wrote:
> On Wed, Mar 18, 2020 at 12:37:09PM -0400, Peter Xu wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e54c6ad628a8..a5123a0aa7d6 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9786,7 +9786,34 @@ void kvm_arch_sync_events(struct kvm *kvm)
> >  	kvm_free_pit(kvm);
> >  }
> >  
> > -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > +#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
> > +
> > +/**
> > + * __x86_set_memory_region: Setup KVM internal memory slot
> > + *
> > + * @kvm: the kvm pointer to the VM.
> > + * @id: the slot ID to setup.
> > + * @gpa: the GPA to install the slot (unused when @size == 0).
> > + * @size: the size of the slot. Set to zero to uninstall a slot.
> > + *
> > + * This function helps to setup a KVM internal memory slot.  Specify
> > + * @size > 0 to install a new slot, while @size == 0 to uninstall a
> > + * slot.  The return code can be one of the following:
> > + *
> > + *   HVA:           on success (uninstall will return a bogus HVA)
> > + *   -errno:        on error
> > + *
> > + * The caller should always use IS_ERR() to check the return value
> > + * before use.  NOTE: KVM internal memory slots are guaranteed and
> 
> "are guaranteed" to ...
> 
> > + * won't change until the VM is destroyed. This is also true to the
> > + * returned HVA when installing a new memory slot.  The HVA can be
> > + * invalidated by either an errornous userspace program or a VM under
> > + * destruction, however as long as we use __copy_{to|from}_user()
> > + * properly upon the HVAs and handle the failure paths always then
> > + * we're safe.
> 
> Regarding the HVA, it's a bit confusing saying that it's guaranteed to be
> valid, and then contradicting that in the second clause.  Maybe something
> like this to explain the GPA->HVA is guaranteed to be valid, but the
> HVA->HPA is not.
>  
> /*
>  * before use.  Note, KVM internal memory slots are guaranteed to remain valid
>  * and unchanged until the VM is destroyed, i.e. the GPA->HVA translation will
>  * not change.  However, the HVA is a user address, i.e. its accessibility is
>  * not guaranteed, and must be accessed via __copy_{to,from}_user().
>  */

Sure I can switch to this, though note that I still think the GPA->HVA
is not guaranteed logically because the userspace can unmap any HVA it
wants..  However I agree that shouldn't be important from kvm's
perspective as long as we always emphasize on using legal HVA accessors.

-- 
Peter Xu

