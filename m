Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC2B311026
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 19:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhBEQ7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 11:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhBEQ6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 11:58:05 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D535BC06174A
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 10:39:47 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id t8so8907554ljk.10
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 10:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=JzcGBOHKvCkTvaHu+Odu5lZVhpV3LjMo1L6z/5BD+YM=;
        b=ML2gkeLHaAJum8rzgoYXHi6FmQyDevlyRaEvqv/rnh7FDCIsF604QuR63ZvL5XpDfW
         k0u3437LRbreeOsSxdf8n5QVdQeozDHe1clZndkAp/bms6WPaQG7VesIjW16PKl+xip8
         atXg+7x/lkm7i4nGUGqGHXIPHtp8tIvsF3ONDgy64sCKGLObeggtuJBdLoKjBJytBxAC
         KEnMGkgtmj5ySvlEOK4e10l2Pu2S6RGff8M2ezayA4yOQEGBIqEdNKlxcNZzDqBxgJ8p
         w8pKqflAi3IL+PfdvZNTpctZhBk6Q+IBzd0hXBtP5kxYD9obesDhP/suQw0Bf12Pmnqy
         W+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JzcGBOHKvCkTvaHu+Odu5lZVhpV3LjMo1L6z/5BD+YM=;
        b=OFAwJgs6fI7pR9mFISRYvuzWvUMK0cDdqS/+u8wz63AEdKMS4Kq0r91t5R2um0JPrv
         dTQbn2tSP07O25mCr5IT9PrziYpw0wjykbfixziZV+zsHpD6N6QjovkqmDThtmfCAxtZ
         xm6TLig8EBMtD8859D9GBw/sfyNAEPf+NjdWvEbCU5WKHuqUoHxxLLG6jCsAtN6PnlGA
         6PUcvmGiVXdC+zEp1QOTcJ3kucit7qkl0lpppgZ6qcBGYrBOBFDe2i5obHlGZnQqE/i+
         IbOZ/jbjsCDUW+meN/Ef32wU7PcdCM1Nn/O4yNgpiVTE+LGDfa0UqSQ4nVxjr5UK6vpu
         jUJA==
X-Gm-Message-State: AOAM532Q3WQ2OvNelP1zajJ8asbhnu/gaSnnnRcki00sZWiZJsyiTHsg
        fthC9AefwW+kdv8cvXlMTDA=
X-Google-Smtp-Source: ABdhPJzNt3VYAXDbxQKh4W5qQPrV2NLB/g5kYqj7hKD2mrTrjkrTbHszNR9pFY6Qqcn6Y49JoTSlSw==
X-Received: by 2002:a2e:894b:: with SMTP id b11mr3516817ljk.265.1612550385580;
        Fri, 05 Feb 2021 10:39:45 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id u12sm1082412lff.250.2021.02.05.10.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 10:39:44 -0800 (PST)
Message-ID: <85cdd5d96b227ba64d333bff112c7900b6f14dea.camel@gmail.com>
Subject: Re: [RESEND RFC v2 1/4] KVM: add initial support for
 KVM_SET_IOREGION
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Date:   Fri, 05 Feb 2021 10:39:33 -0800
In-Reply-To: <20210204140329.5f3a49ca.cohuck@redhat.com>
References: <cover.1611850290.git.eafanasova@gmail.com>
         <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
         <20210204140329.5f3a49ca.cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-02-04 at 14:03 +0100, Cornelia Huck wrote:
> On Fri, 29 Jan 2021 21:48:26 +0300
> Elena Afanasova <eafanasova@gmail.com> wrote:
> 
> [Note: I've just started looking at this, please excuse any questions
> that have already been answered elsewhere.]
> 
> > This vm ioctl adds or removes an ioregionfd MMIO/PIO region. Guest
> > read and write accesses are dispatched through the given ioregionfd
> > instead of returning from ioctl(KVM_RUN). Regions can be deleted by
> > setting fds to -1.
> > 
> > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > ---
> > Changes in v2:
> >   - changes after code review
> > 
> >  arch/x86/kvm/Kconfig     |   1 +
> >  arch/x86/kvm/Makefile    |   1 +
> >  arch/x86/kvm/x86.c       |   1 +
> >  include/linux/kvm_host.h |  17 +++
> >  include/uapi/linux/kvm.h |  23 ++++
> >  virt/kvm/Kconfig         |   3 +
> >  virt/kvm/eventfd.c       |  25 +++++
> >  virt/kvm/eventfd.h       |  14 +++
> >  virt/kvm/ioregion.c      | 232
> > +++++++++++++++++++++++++++++++++++++++
> >  virt/kvm/ioregion.h      |  15 +++
> >  virt/kvm/kvm_main.c      |  11 ++
> >  11 files changed, 343 insertions(+)
> >  create mode 100644 virt/kvm/eventfd.h
> >  create mode 100644 virt/kvm/ioregion.c
> >  create mode 100644 virt/kvm/ioregion.h
> 
> (...)
> 
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index ca41220b40b8..81e775778c66 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -732,6 +732,27 @@ struct kvm_ioeventfd {
> >  	__u8  pad[36];
> >  };
> >  
> > +enum {
> > +	kvm_ioregion_flag_nr_pio,
> > +	kvm_ioregion_flag_nr_posted_writes,
> > +	kvm_ioregion_flag_nr_max,
> > +};
> > +
> > +#define KVM_IOREGION_PIO (1 << kvm_ioregion_flag_nr_pio)
> > +#define KVM_IOREGION_POSTED_WRITES (1 <<
> > kvm_ioregion_flag_nr_posted_writes)
> > +
> > +#define KVM_IOREGION_VALID_FLAG_MASK ((1 <<
> > kvm_ioregion_flag_nr_max) - 1)
> > +
> > +struct kvm_ioregion {
> > +	__u64 guest_paddr; /* guest physical address */
> > +	__u64 memory_size; /* bytes */
> > +	__u64 user_data;
> > +	__s32 rfd;
> > +	__s32 wfd;
> 
> I guess these are read and write file descriptors? 
Yes

> Maybe call them read_fd and write_fd?
> 
Ok

> > +	__u32 flags;
> > +	__u8  pad[28];
> > +};
> > +
> >  #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
> >  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
> >  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> > @@ -1053,6 +1074,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_X86_USER_SPACE_MSR 188
> >  #define KVM_CAP_X86_MSR_FILTER 189
> >  #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> > +#define KVM_CAP_IOREGIONFD 191
> >  
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >  
> > @@ -1308,6 +1330,7 @@ struct kvm_vfio_spapr_tce {
> >  					struct
> > kvm_userspace_memory_region)
> >  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
> >  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> > +#define KVM_SET_IOREGION          _IOW(KVMIO,  0x49, struct
> > kvm_ioregion)
> 
> This new ioctl needs some documentation under
> Documentation/virt/kvm/api.rst. (That would also make review easier.)
> 
Agreed. The latest version of the ioregionfd API can be found in 
https://marc.info/?l=kvm&m=160633710708172&w=2. There are still some
open questions like write coalescing support.  So I think API may still
be changed during code reviews.

> >  
> >  /* enable ucontrol for s390 */
> >  struct kvm_s390_ucas_mapping {
> 
> (...)
> 
> > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > index c2323c27a28b..aadb73903f8b 100644
> > --- a/virt/kvm/eventfd.c
> > +++ b/virt/kvm/eventfd.c
> > @@ -27,6 +27,7 @@
> >  #include <trace/events/kvm.h>
> >  
> >  #include <kvm/iodev.h>
> > +#include "ioregion.h"
> >  
> >  #ifdef CONFIG_HAVE_KVM_IRQFD
> >  
> > @@ -755,6 +756,23 @@ static const struct kvm_io_device_ops
> > ioeventfd_ops = {
> >  	.destructor = ioeventfd_destructor,
> >  };
> >  
> > +#ifdef CONFIG_KVM_IOREGION
> > +/* assumes kvm->slots_lock held */
> > +bool kvm_eventfd_collides(struct kvm *kvm, int bus_idx,
> > +			  u64 start, u64 size)
> > +{
> > +	struct _ioeventfd *_p;
> > +
> > +	list_for_each_entry(_p, &kvm->ioeventfds, list)
> > +		if (_p->bus_idx == bus_idx &&
> > +		    overlap(start, size, _p->addr,
> > +			    !_p->length ? 8 : _p->length))
> 
> Not a problem right now, as this is x86 only, but I'm not sure we can
> define "overlap" in a meaningful way for every bus_idx. (For example,
> the s390-only ccw notifications use addr to identify a device; as
> long
> as addr is unique, there will be no clash. I'm not sure yet if
> ioregions are usable for ccw devices, and if yes, in which form, but
> we
> should probably keep it in mind.)
> 
Thank you for pointing it out. Yes, CCW bus seems to be a special case.

> > +			return true;
> > +
> > +	return false;
> > +}
> > +#endif
> > +
> >  /* assumes kvm->slots_lock held */
> >  static bool
> >  ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
> > @@ -770,6 +788,13 @@ ioeventfd_check_collision(struct kvm *kvm,
> > struct _ioeventfd *p)
> >  		       _p->datamatch == p->datamatch))))
> >  			return true;
> >  
> > +#ifdef CONFIG_KVM_IOREGION
> > +	if (p->bus_idx == KVM_MMIO_BUS || p->bus_idx == KVM_PIO_BUS)
> > +		if (kvm_ioregion_collides(kvm, p->bus_idx, p->addr,
> > +					  !p->length ? 8 : p->length))
> 
> What about KVM_FAST_MMIO_BUS?
> 
Yes, we have already discussed FAST_MMIO support with Jason Wang. TODO.

> > +			return true;
> > +#endif
> > +
> >  	return false;
> >  }
> >  
> 
> (...)
> 
> > +/* check for not overlapping case and reverse */
> > +inline bool
> > +overlap(u64 start1, u64 size1, u64 start2, u64 size2)
> > +{
> > +	u64 end1 = start1 + size1 - 1;
> > +	u64 end2 = start2 + size2 - 1;
> > +
> > +	return !(end1 < start2 || start1 >= end2);
> > +}
> 
> I'm wondering whether there's already a generic function to do a
> check
> like this?
> 
I couldn't find it.

> (...)
> 

