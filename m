Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8CC41CDD1
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 23:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346833AbhI2VMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 17:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346355AbhI2VMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 17:12:31 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594DDC06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 14:10:50 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y1so2417709plk.10
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 14:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eSi8jRqHCChCbRdByu+31RRuSb+xYsMKHrZgy6977k4=;
        b=qdfcMPpGzhf3bE3tkqdDAuk6qOvlx0ioEDswRc0v/ON2CoOSIN0QidqCNo5Ikwf/pl
         Q94+bOtcHV8wi+UslP2QhMR4URMwzzIHWGWr4DW1+vKJn0MPAUDcEh3T0bW+s6BWWbu3
         8akzG2wlbKhGSt4xoYoZMX1MfOSzmSm20mjgAZIIcRDXCeOp+lUtjYyXYCwA8sTzkg+Q
         9CaO7kCq2gVrGQcCtkq31MJU7DcXKlB+ZE/pDpJqluHW8guzlIG4PzaKIXHFAlc1Ixcj
         iRU6fOv3iH7P4Oieu811mJVU+EbZKBLTx/ouiVh48jR3CQ1GmRe3HKEazaSFpd7iTwr7
         J8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eSi8jRqHCChCbRdByu+31RRuSb+xYsMKHrZgy6977k4=;
        b=fFI3oQzhAbWsFhwTNesG/PgQLgwPWe6VOKkDOIz44K8J1i+ip1GzqwlVfbNwPNAcVW
         e27PJZXvEWXj0/KIoS406Fb7PEbipwPPTGNttscqMVc6EkqiVDwcNKgHIEjD5W0NMlWe
         MP5YDhnY6+LrD2NeC20KS8ZVlvAft86QedzSnJTOy1btIo2jOapY7cGtsn699QqfW87n
         fCTGVpYl22hoEOG6Jh5B8jEziQyJzdLyEPxYnO+NDhfFSfci1JDl8G+YfI+UyAooScCI
         IR8u1WTxnFMHHUA0vN/H/mvgjnuDOJhg87uLnjr3eiTSeOVrM89JWw5fcy70UAMKoaFC
         LS6g==
X-Gm-Message-State: AOAM532epXea2bUsBgJZte5hcFgPwVlziLc1ZkA2bl3qFQtcxDCeNrRP
        vxEww+DoLUCxDdSXkWUE7HWMGQ==
X-Google-Smtp-Source: ABdhPJwXGd6YAz7NLKLEG9FaWIn3fO6ClLr2KS8DOXFDCqX+t+Q0Fl8tO14XGQ9yUacMtvRgVp7aew==
X-Received: by 2002:a17:902:dac4:b0:13d:acee:cacc with SMTP id q4-20020a170902dac400b0013daceecaccmr755277plx.0.1632949849474;
        Wed, 29 Sep 2021 14:10:49 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id n26sm678894pfo.19.2021.09.29.14.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:10:48 -0700 (PDT)
Date:   Wed, 29 Sep 2021 14:10:45 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
Message-ID: <YVTWVf26yYNUUx2L@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-3-ricarkol@google.com>
 <01a03d81-e98b-a504-f4b7-e4a56ffa78d5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <01a03d81-e98b-a504-f4b7-e4a56ffa78d5@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Wed, Sep 29, 2021 at 06:23:04PM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 9/28/21 8:47 PM, Ricardo Koller wrote:
> > Verify that the redistributor regions do not extend beyond the
> > VM-specified IPA range (phys_size). This can happen when using
> > KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
> > with:
> >
> >   base + size > phys_size AND base < phys_size
> >
> > Add the missing check into vgic_v3_alloc_redist_region() which is called
> > when setting the regions, and into vgic_v3_check_base() which is called
> > when attempting the first vcpu-run. The vcpu-run check does not apply to
> > KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
> > before the first vcpu-run. Note that using the REDIST_REGIONS API
> > results in a different check, which already exists, at first vcpu run:
> > that the number of redist regions is enough for all vcpus.
> >
> > Finally, this patch also enables some extra tests in
> > vgic_v3_alloc_redist_region() by calculating "size" early for the legacy
> > redist api: like checking that the REDIST region can fit all the already
> > created vcpus.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++++--
> >  arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > index a09cdc0b953c..9be02bf7865e 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  	struct vgic_dist *d = &kvm->arch.vgic;
> >  	struct vgic_redist_region *rdreg;
> >  	struct list_head *rd_regions = &d->rd_regions;
> > -	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
> > +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
> > +	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE
> > +			    : nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
> 
> This actually fixes the  vgic_dist_overlap(kvm, base, size=0)
> 
> in case the number of online-vcpus at that time is less than the final
> one (1st run), if count=0 (legacy API) do we ever check that the RDIST
> (with accumulated vcpu rdists) does not overlap with dist.
> in other words shouldn't we call vgic_dist_overlap(kvm, base, size)
> again in vgic_v3_check_base().
> 

I think we're good; that's checked by vgic_v3_rdist_overlap(dist_base)
in vgic_v3_check_base(). This function uses the only region (legacy
case) using a size based on the online_vcpus (in
vgic_v3_rd_region_size()).  This exact situation is tested by
test_vgic_then_vcpus() in the vgic_init selftest.

Thanks,
Ricardo

> Thanks
> 
> Eric
> 
> >  	int ret;
> >  
> >  	/* cross the end of memory ? */
> > @@ -840,7 +842,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  
> >  	rdreg->base = VGIC_ADDR_UNDEF;
> >  
> > -	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
> > +	ret = vgic_check_iorange(kvm, &rdreg->base, base, SZ_64K, size);
> >  	if (ret)
> >  		goto free;
> >  
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 21a6207fb2ee..27ee674631b3 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -486,6 +486,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >  			rdreg->base)
> >  			return false;
> > +
> > +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > +			kvm_phys_size(kvm))
> > +			return false;
> >  	}
> >  
> >  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> 
