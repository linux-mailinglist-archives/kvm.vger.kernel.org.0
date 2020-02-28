Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36FC4173328
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 09:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgB1IpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 03:45:10 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33902 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgB1IpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 03:45:10 -0500
Received: by mail-pf1-f196.google.com with SMTP id i6so1382621pfc.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 00:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Su9H9ej9DZUb94i0Qqtg6/v9PelYuy4NE1KKJGeMEeU=;
        b=JtkjAEIAPmQ9mHy1wQUro85Xky5kvSr3wa20ZlclSYEVAmAm1XixC2kaRu3Qhe1suR
         oBk7neniqNlDe1IpkVJB2x7QWY/JIvYlOdbSXHj2x3EYtw3WeiJtWMZQHDFIw8HBgPo0
         WXdZBy1dmU7JjMIcyYtF6rJuSMjxsg/PBYhKGkI4LBlv0lAWaOqZt61qhcAvk9unDUuG
         wqQHsDmnhyOfFnhmKq+MTYVuwGH772Qexu2p34Drl3LQUTrinl89ism6L9GhWuk06dl6
         aG92xOJ9Yzq/k7JgtdwIlhu+Qzf8/YzB33FGzCW3a34aMylqCEMybyFrAiLKsmNPJQr7
         cI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Su9H9ej9DZUb94i0Qqtg6/v9PelYuy4NE1KKJGeMEeU=;
        b=XgZYP4BlneoXM7w2+z9WKnLiwKbCz1BcA9+KUPzOM0Ict6NsLGh8k77cR9ysXpVWd0
         FYFzrZw6Im6LqmIWMlnVfuJe3BkzLXG1/k46aKiU0YrJla/63hJeJ13n1Eo1dBBk7nva
         HHPSKMiPAyFG6WJ7OpSExgWQDwndUph+Gq2PhQBC26s1+yblhy/Bf4LCV0aRrhAKC5pq
         GMSOu7UNRnFTEvY65BwTC4maqEYKTFX4jE8ducosY/lYJoYGBxf9f9NDADdpYegwlYBF
         SWiINMY7/N9zWYneFgKY6PaiUeiT2Rag+mbdEF6xcXlVRMD/nv1oWi3Zs/HUhfQIrTdL
         qKew==
X-Gm-Message-State: APjAAAVHricKcH/L+I7eJeyeljS5L4lgrvPD7LBnLNHHu14Blo80nTzB
        L/Cx34V7hfFQZKsRTex1eCCfhOOctp0=
X-Google-Smtp-Source: APXvYqzUPE7AWJ/kOni6jECkNw/626T3Yf/l/SrXls3gBpMLCSOgAhqFn9teCfLl24iMERcyv/F6Aw==
X-Received: by 2002:a63:b22:: with SMTP id 34mr3445208pgl.78.1582879507067;
        Fri, 28 Feb 2020 00:45:07 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id g19sm9988877pfh.134.2020.02.28.00.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 00:45:06 -0800 (PST)
Date:   Fri, 28 Feb 2020 00:45:01 -0800
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: SVM: Inhibit APIC virtualization for X2APIC guest
Message-ID: <20200228084501.GA11772@google.com>
References: <20200228003523.114071-1-oupton@google.com>
 <bde391f9-1f87-dfc9-c0d6-ccd80d537e7d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bde391f9-1f87-dfc9-c0d6-ccd80d537e7d@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Fri, Feb 28, 2020 at 09:01:11AM +0100, Paolo Bonzini wrote:
> On 28/02/20 01:35, Oliver Upton wrote:
> > The AVIC does not support guest use of the x2APIC interface. Currently,
> > KVM simply chooses to squash the x2APIC feature in the guest's CPUID
> > If the AVIC is enabled. Doing so prevents KVM from running a guest
> > with greater than 255 vCPUs, as such a guest necessitates the use
> > of the x2APIC interface.
> > 
> > Instead, inhibit AVIC enablement on a per-VM basis whenever the x2APIC
> > feature is set in the guest's CPUID. Since this changes the behavior of
> > KVM as seen by userspace, add a module parameter, avic_per_vm, to opt-in
> > for the new behavior. If this parameter is set, report x2APIC as
> > available on KVM_GET_SUPPORTED_CPUID. Without opt-in, continue to
> > suppress x2APIC from the guest's CPUID.
> > 
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> 
> Since AVIC is not enabled by default, let's do this always and flip the
> default to avic=1 in 5.7.  People using avic=1 will have to disable
> x2apic manually instead but the default will be the same in practice
> (AVIC not enabled).  And then we can figure out:
> 

I'll drop the new module param in v2 and adopt this suggested behavior.

> - how to do emulation of x2apic when avic is enabled (so it will cause
> vmexits but still use the AVIC for e.g. assigned devices)
>
> - a PV CPUID leaf to tell <=255 vCPUs on AMD virtualization _not_ to use
> x2apic.
>

If a VMM didn't want the guest to use x2APIC in the first place, shouldn't
it instead omit x2APIC from the guest CPUID? I can see a point for this
if folks are inclined to use the same CPUID for VMs regardless of shape.
Just a thought to tackle later down the road :)

Thanks for the review, I'll send a new patch out shortly.

--
Thanks,
Oliver

> Paolo
> 
> > ---
> > 
> >  Parent commit: a93236fcbe1d ("KVM: s390: rstify new ioctls in api.rst")
> > 
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/svm.c              | 19 ++++++++++++++++---
> >  2 files changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 98959e8cd448..9d40132a3ae2 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -890,6 +890,7 @@ enum kvm_irqchip_mode {
> >  #define APICV_INHIBIT_REASON_NESTED     2
> >  #define APICV_INHIBIT_REASON_IRQWIN     3
> >  #define APICV_INHIBIT_REASON_PIT_REINJ  4
> > +#define APICV_INHIBIT_REASON_X2APIC	5
> >  
> >  struct kvm_arch {
> >  	unsigned long n_used_mmu_pages;
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index ad3f5b178a03..95c03c75f51a 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -382,6 +382,10 @@ module_param(sev, int, 0444);
> >  static bool __read_mostly dump_invalid_vmcb = 0;
> >  module_param(dump_invalid_vmcb, bool, 0644);
> >  
> > +/* enable/disable opportunistic use of the AVIC on a per-VM basis */
> > +static bool __read_mostly avic_per_vm;
> > +module_param(avic_per_vm, bool, 0444);
> > +
> >  static u8 rsm_ins_bytes[] = "\x0f\xaa";
> >  
> >  static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
> > @@ -6027,7 +6031,15 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
> >  	if (!kvm_vcpu_apicv_active(vcpu))
> >  		return;
> >  
> > -	guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
> > +	/*
> > +	 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
> > +	 * is exposed to the guest, disable AVIC.
> > +	 */
> > +	if (avic_per_vm && guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
> > +		kvm_request_apicv_update(vcpu->kvm, false,
> > +					 APICV_INHIBIT_REASON_X2APIC);
> > +	else
> > +		guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
> >  
> >  	/*
> >  	 * Currently, AVIC does not work with nested virtualization.
> > @@ -6044,7 +6056,7 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> >  {
> >  	switch (func) {
> >  	case 0x1:
> > -		if (avic)
> > +		if (avic && !avic_per_vm)
> >  			entry->ecx &= ~F(X2APIC);
> >  		break;
> >  	case 0x80000001:
> > @@ -7370,7 +7382,8 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
> >  			  BIT(APICV_INHIBIT_REASON_HYPERV) |
> >  			  BIT(APICV_INHIBIT_REASON_NESTED) |
> >  			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
> > -			  BIT(APICV_INHIBIT_REASON_PIT_REINJ);
> > +			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
> > +			  BIT(APICV_INHIBIT_REASON_X2APIC);
> >  
> >  	return supported & BIT(bit);
> >  }
> > 
> 
