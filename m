Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADE0405B31
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbhIIQs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbhIIQs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:48:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F9CC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 09:47:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id c6so1802301pjv.1
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aqDJdy/bngbKNH/GkT/KKhZxJC8IlkHUa3ohSA9/WQU=;
        b=ONNwLK04smMPzA1dePLbmmudjm0amUNmRtiYHvgryjFJBCMqEiKgQrX5RF1aC1XJJ0
         hWGXF3y+GFritFMHREj/UVar2x+rdaZm0irWxNMv+LtAXnbin8UzvYLQtWYlJG4F3H6G
         w4q9CvLy8UuQA9ibUg+Pkv3NyXGvwD3mDu/SSzCtu6vrwXboszDnNf6rjxv2eQomVE6U
         t2ouvCIt+0W6zIj5Xr5K8DrtFc82Oeihv6JsJwCJ/bb42U3enEoCHMyXy6qgXkAtUxP6
         p3suq2NUa6JIXQWTT0wXjsyD6l0MDq0FsI9i121Xi63gKbdiTks1E+Jh+xMeDaWxf5zP
         1Rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aqDJdy/bngbKNH/GkT/KKhZxJC8IlkHUa3ohSA9/WQU=;
        b=NzjutvRuTu6oMJTlTzYopih1dz29qNRwaWgx+f20DtdASJ2ouLHB0FKtz404y5RwXr
         MATQggmyv4v+RTa/VH25j0cjtivZSI24NnEmxMkAGpxHK9STwJ6wEh3rwvQltJqfcNP3
         wPEeEfsXrygRD9EIEoIP7KPj7d+uyAz/N6ZYKXjspUpZEZuw00QlFPzLgys0U9WsJ/ZN
         kWL1cxDGGYEpK4DqlQgxsSq/HzKn0a+ZTaTkgEtvqa1Lctmmk9r9OCa8ZbWbstn80MO7
         r67w3c8exxrPyCfXRKB1U01FYBVCx1XgSomGqobSuUgmU9HV4JAzTjOShrtSSVpoBEqS
         cnLg==
X-Gm-Message-State: AOAM531o0B7k09SgcbLg1hfvZLY5sYQDF79Hh9DFiKlbmEfHl8XyK+gq
        6tvVRwuO/DNisefe/bXkCOSbaQ==
X-Google-Smtp-Source: ABdhPJyoRFIZmAkN7ZrnaHVghWbLzbIeUZ5Eg97bAH4sMRYbkFXJcKwlS1ZMLW/kE1H7gibUsCPBMg==
X-Received: by 2002:a17:902:c401:b0:138:e450:1ec4 with SMTP id k1-20020a170902c40100b00138e4501ec4mr3508456plk.56.1631206037420;
        Thu, 09 Sep 2021 09:47:17 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id s9sm2622619pfu.129.2021.09.09.09.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 09:47:16 -0700 (PDT)
Date:   Thu, 9 Sep 2021 09:47:13 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YTo6kX7jGeR3XvPg@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 11:20:15AM +0100, Alexandru Elisei wrote:
> Hi Ricardo,
> 
> On 9/8/21 10:03 PM, Ricardo Koller wrote:
> > Extend vgic_v3_check_base() to verify that the redistributor regions
> > don't go above the VM-specified IPA size (phys_size). This can happen
> > when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> >
> >   base + size > phys_size AND base < phys_size
> >
> > vgic_v3_check_base() is used to check the redist regions bases when
> > setting them (with the vcpus added so far) and when attempting the first
> > vcpu-run.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 66004f61cd83..5afd9f6f68f6 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >  			rdreg->base)
> >  			return false;
> > +
> > +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > +			kvm_phys_size(kvm))
> > +			return false;
> 
> Looks to me like this same check (and the overflow one before it) is done when
> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_redist_base()
> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I can tell,
> kvm_vgic_addr() handles both ways of setting the Redistributor address.
> 
> Without this patch, did you manage to set a base address such that base + size >
> kvm_phys_size()?
> 

Yes, with the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API. The easiest way
to get to this situation is with the selftest in patch 2.  I then tried
an extra experiment: map the first redistributor, run the first vcpu,
and access the redist from inside the guest. KVM didn't complain in any
of these steps.

Thanks,
Ricardo

> Thanks,
> 
> Alex
> 
> >  	}
> >  
> >  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
