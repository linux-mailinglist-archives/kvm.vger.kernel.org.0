Return-Path: <kvm+bounces-54338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB15B1F11D
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 00:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C8971720D6
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 22:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFA2246BB7;
	Fri,  8 Aug 2025 22:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pw8YByjV"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259671C8633
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 22:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754693352; cv=none; b=pQv6v085fKcWBrbHc5Mn8DQshz1ZwLWQAVbru0Zj8qqH/F/cMWxl79O6uLpPHZijMD7raqjwJBGXsQoiWl7jfYuilwdmV8ja4Y/A3GSKTMSLYrof39okn7DZOOapWC57LkCrWwUiFF9/2lvHcgebs8H0KcuxdHHd/KolCmtq0rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754693352; c=relaxed/simple;
	bh=oz72LipBuf8tSS0igewxlE8ldmrONktoxkkzMNQzeBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZqMTKlicV7J6scCx9KFlNiv/B3ikURkBu5sVQ4/o1XcaVRlPFIiGS+dJhs7iFNvasAv+qiB9e1vHDbmLFLStTH+C7B+N14Xc1uzk+FeSZczp/L4YiHuo+he4QTm+D6PeGDGRyrUx1iiMuC+CPDKdT9ju+gKi+EFdY2QxqH39hak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pw8YByjV; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 8 Aug 2025 15:48:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754693336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ZJOuuw+L4JCEgAlhgRdeSHgvzwy2a3DZREpYyzI0P0=;
	b=Pw8YByjV545/1c7fBTaoEtEe6bw142ct+rFKef2lDb4d+/XDX3rHueDS6oQK6OWUy3elHa
	2XaCELYPui1H5Pgwjxy3Wr9phxqSCbCch3mr5pSD5zAVG4yon/vQido5k6pgE/xdi8Hf7o
	KSGg2LRITwJacn/nYcst1HHJhLy6LAQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 4/5] KVM: arm64: Expose FEAT_RASv1p1 in a canonical
 manner
Message-ID: <aJZ-wCLYh_STGiTI@linux.dev>
References: <20250806165615.1513164-1-maz@kernel.org>
 <20250806165615.1513164-5-maz@kernel.org>
 <20250807125531.GB2351327@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807125531.GB2351327@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 07, 2025 at 01:55:31PM +0100, Joey Gouly wrote:
> On Wed, Aug 06, 2025 at 05:56:14PM +0100, Marc Zyngier wrote:
> > If we have RASv1p1 on the host, advertise it to the guest in the
> > "canonical way", by setting ID_AA64PFR0_EL1 to V1P1, rather than
> > the convoluted RAS+RAS_frac method.
> > 
> > Note that this also advertises FEAT_DoubleFault, which doesn't
> > affect the guest at all, as only EL3 is concerned by this.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1b4114790024e..66e5a733e9628 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1800,6 +1800,18 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
> >  	if (!vcpu_has_sve(vcpu))
> >  		val &= ~ID_AA64PFR0_EL1_SVE_MASK;
> >  
> > +	/*
> > +	 * Describe RASv1p1 in a canonical way -- ID_AA64PFR1_EL1.RAS_frac
> > +	 * is cleared separately. Note that by advertising RASv1p1 here, we
> 
> Where is it cleared? __kvm_read_sanitised_id_reg() is where I would have
> expected to see it:

Actually, I'm a bit worried this change doesn't give us very much value
since Marc already does the exhaustive RASv1p1 check in the sysreg
emulation.

There's potential for breakage when migrating VMs between new/old kernels
on systems w/ FEAT_RASv1p1 && !FEAT_DoubleFault.

Marc, WDYT about dropping this patch and instead opening up RAS_frac to
writes?

Thanks,
Oliver

