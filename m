Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E82C41CDED
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 23:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346888AbhI2VSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 17:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244711AbhI2VSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 17:18:54 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C97CC061767
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 14:17:13 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g184so4027387pgc.6
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 14:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=33MJea1whoLNtrMC9eiHI/diRhmiXqXXdKlxLsoaF+0=;
        b=eGI4XVSq3HIPvlsyLN06O8MDA2W61KnG2XZhVXTLSIBo+pmbUFhUiMp/1S+37juyLO
         YO0ULnTTdXXVwSRvCyr4tkVDpjrOJnBARtVzvzrEIFPscfeI4L+w5kMCiQserweIpDlm
         LFOSrZsPTV19Ceofilnf3MuRnRlQKHwgfd03Ihq3WyOkVLw9KcucJZsNrjsWD8RWvSNR
         E0lTVl1x+wVF91qv0PuHHt8cPMkz8WTWKakxFio6snzZ39c5ELi1lQEGLgHktt3ynnKM
         x6KzzuM7sRAp/eja6lcl7LuyNldFSU91V2QrjeUZyDWBakO7skvZ6p3qhEB3qG/YtHN9
         B4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=33MJea1whoLNtrMC9eiHI/diRhmiXqXXdKlxLsoaF+0=;
        b=s+g9JxgjbAwYXMIQQpNChgr+qNCpYAHk9Dd9iArb4nxXD8IOavt42nW8zApKE2Vqmn
         ayW/qRUR4K/Q4gIkDgtxMr+7uRss5f2I1B03I3/6+UryorUVpY6zSwBTGHPwJb6K0GC7
         Vto52z7zJigBle9N0xnYaB0F6t/uyYHfbgvw8oeklYx3apkvI38xPWjPLrYWCRb8+SsG
         F10ceWdrXchEsszImRuRvD1GX9JYrwAao65IJpbvBOSopFWmQgGDqIulLt45m1sKuUmz
         5T8h7fNEnHEMbcbmtzAvFkGRa25u+6GggDv7jHziXIiL06ZJNksnurXO1JUlVJEgq9zL
         5gFA==
X-Gm-Message-State: AOAM532QDh94ll6AOB/q1d8wZwX8a7VAIcencoUXfExkBFYJOUu75o+k
        qGr6LggC4uePRT0L87S4ruLHBg==
X-Google-Smtp-Source: ABdhPJwigR/CWqCj7YE1ZL9tAzR7+KJ0P+RsA3KXHWpL8Gic6pWADyWuuyfLP/thXtjXkEOqgMIWEg==
X-Received: by 2002:a63:1444:: with SMTP id 4mr1669742pgu.381.1632950232579;
        Wed, 29 Sep 2021 14:17:12 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id r29sm624305pfq.74.2021.09.29.14.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:17:11 -0700 (PDT)
Date:   Wed, 29 Sep 2021 14:17:08 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
Message-ID: <YVTX1L8u8NMxHAyE@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
 <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 06:29:21PM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 9/28/21 8:47 PM, Ricardo Koller wrote:
> > Add the new vgic_check_iorange helper that checks that an iorange is
> > sane: the start address and size have valid alignments, the range is
> > within the addressable PA range, start+size doesn't overflow, and the
> > start wasn't already defined.
> >
> > No functional change.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
> >  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
> >  2 files changed, 26 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > index 7740995de982..f714aded67b2 100644
> > --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> >  	return 0;
> >  }
> >  
> > +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> > +		       phys_addr_t addr, phys_addr_t alignment,
> > +		       phys_addr_t size)
> > +{
> > +	int ret;
> > +
> > +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
> nit: not related to this patch but I am just wondering why we are
> passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to
> 
> vgic_check_iorange()? This must be a leftover of some old code?
> 

It's used to check that the base of a region is not already set.
kvm_vgic_addr() uses it to make that check;
vgic_v3_alloc_redist_region() does not:

  rdreg->base = VGIC_ADDR_UNDEF; // so the "not already defined" check passes
  ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);

Thanks,
Ricardo

> > +	if (ret)
> > +		return ret;
> > +
> > +	if (!IS_ALIGNED(size, alignment))
> > +		return -EINVAL;
> > +
> > +	if (addr + size < addr)
> > +		return -EINVAL;
> > +
> > +	if (addr + size > kvm_phys_size(kvm))
> > +		return -E2BIG;
> > +
> > +	return 0;
> > +}
> > +
> >  static int vgic_check_type(struct kvm *kvm, int type_needed)
> >  {
> >  	if (kvm->arch.vgic.vgic_model != type_needed)
> > diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> > index 14a9218641f5..c4df4dcef31f 100644
> > --- a/arch/arm64/kvm/vgic/vgic.h
> > +++ b/arch/arm64/kvm/vgic/vgic.h
> > @@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
> >  int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> >  		      phys_addr_t addr, phys_addr_t alignment);
> >  
> > +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> > +		       phys_addr_t addr, phys_addr_t alignment,
> > +		       phys_addr_t size);
> > +
> >  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
> >  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
> >  void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
> Besides
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Eric
> 
