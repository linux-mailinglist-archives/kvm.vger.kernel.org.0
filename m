Return-Path: <kvm+bounces-32043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E303D9D2193
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 09:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3D26281B77
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 08:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB3C112CDAE;
	Tue, 19 Nov 2024 08:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mAPh4DbE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6641EA90
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 08:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732004931; cv=none; b=kYSWsJrc4+Eny8bN84PwZXPtflisoyrytMO9+Nsq+J2YwNC1oV3Z9Dx7MmNzmNyt3v7LrfKEiA1ZfHgF2YQr/FBxtvcYbBr40D+SnA3GoWxzA88OHqNHlTkysJpENUWmYNKzQqdaCFMltjH3tGKAGCUiBSgP72ce6izZ+I8r6LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732004931; c=relaxed/simple;
	bh=0AqPpf7RNAcBW72RiT+BB+KFARadjaWyA6dvMRHwBFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XB/JvnAqFbARBLgehf88BppUVJ827OgKJlElBXuB3nmPJmS0PHoDm73ywWaSMgSqONlXaEED5ajMG7JdTAaadwdqutRNu3rDF0WRvXNx7K9dPE0jnZgOVxPACm+TO7kSmQYphLziGo3KxHc9x2N7DE5eK6SyswxKT6rJLPpeydk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=mAPh4DbE; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4314fa33a35so42880135e9.1
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 00:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732004928; x=1732609728; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cyUY32m7VUxlCTDLVt1b+JPHfOUSRIx7q0KXl7IQeQ4=;
        b=mAPh4DbEDhiPH/ULRN+b/B01R39LhE09vR8+KZ80PTqokXeXTWdpdG4loHIqlVzaM/
         vB6qPVsn9KARf4qP4ZfCFR6QZfTT85A3AHyInBAHnNdoAXj2ufCsBFxGpX7Vli/0br8j
         XBM4QTzIBejxOD59snFhChulzCDZ/0D30WjZp2DMW1LGg1KpoHv/4KDwOsU1yFCEtHDm
         nrCZAPH+WQ3xpAGKdBZGnSwaH0sPm4dabtSSC3ztOI9zIsuQwQ7kywhNgRYYNVVArfxE
         +v/i3zYUitVtPlaQDgCtqvzT8ek/omKgazxfujHPySioRmOqVfcOQi70CzJXbIVHUKYs
         CLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732004928; x=1732609728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyUY32m7VUxlCTDLVt1b+JPHfOUSRIx7q0KXl7IQeQ4=;
        b=dupIRgF7QGWwiWrLXDkeBAb6m/cIygRtpCFCSbSu2BybKTazoKMqRWWGGcsQP4Yv5y
         YCqQxhWm6iH+hQUft1nybCkj2JgyDIKvLcHa8TZzk83WxypudgXlYKH8Be65W+vf3JSz
         zGFYZtZD5QfMITzNFnq4ScKV3AR5vxrhTk3Alwk6KaLjJ4OgiQY9doo+85zU7m2EEScj
         9JgRmEyS2l1FIsxcik0sKlZGsxcEie2nbq4jGlndg3u3wW3nbh3wC3xTJFRITQIFepec
         U3TmHhri6F7Uwjf2X4l2DeasbPuUsMMYlP507/l/oH0mroY1FhGDP3WU9i3Mn3TS23pN
         9zRw==
X-Forwarded-Encrypted: i=1; AJvYcCUrjTEDXwZsU0HxGhrpJLBAq4OSTTUWB9tTePjICwuPlE7tTP9Nm2SBh/ZKCg0oAhwmda4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqQbOIrp88hpzgql7Z8ntY7/9a6U82+5UCZruLtQf+rSMZkjFB
	Chv3NvjdQXBkx1qWiDoSswU6F/ELYc6LMuyjaWz5R8hA95Q0NNH3lHkz0ps4Nyt1syDLokfAnh9
	wq7Q=
X-Google-Smtp-Source: AGHT+IHpZMhXyydhQ7Idy4ENb5ObblYkccalbUBLPzNSlCP+c5FRHdBQ5a3DSr77U7024nHK4LI/fg==
X-Received: by 2002:a05:6000:2904:b0:382:4aa0:e728 with SMTP id ffacd0b85a97d-3824aa0e803mr4138031f8f.1.1732004928543;
        Tue, 19 Nov 2024 00:28:48 -0800 (PST)
Received: from localhost (cst2-173-13.cust.vodafone.cz. [31.30.173.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac21a15sm183138595e9.38.2024.11.19.00.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 00:28:48 -0800 (PST)
Date: Tue, 19 Nov 2024 09:28:46 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org, will@kernel.org, 
	anup@brainfault.org, atishp@atishpatra.org, tglx@linutronix.de, 
	alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 04/15] iommu/riscv: report iommu capabilities
Message-ID: <20241119-76c9ff71b8834ef886b3ca86@orel>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-21-ajones@ventanamicro.com>
 <ddd40bc3-7f2a-43c2-8918-a10c63bd05ba@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddd40bc3-7f2a-43c2-8918-a10c63bd05ba@arm.com>

On Fri, Nov 15, 2024 at 03:20:36PM +0000, Robin Murphy wrote:
> On 14/11/2024 4:18 pm, Andrew Jones wrote:
> > From: Tomasz Jeznach <tjeznach@rivosinc.com>
> > 
> > Report RISC-V IOMMU capabilities required by VFIO subsystem
> > to enable PCIe device assignment.
> 
> IOMMU_CAP_DEFERRED_FLUSH has nothing at all to do with VFIO. As far as I can
> tell from what's queued, riscv_iommu_unmap_pages() isn't really implementing
> the full optimisation to get the most out of it either.

Thanks, Robin. I'll drop this cap for the next version.

> 
> I guess IOMMU_CAP_CACHE_COHERENCY falls out of the assumption of a coherent
> IOMMU and lack of PBMT support making everything implicitly IOMMU_CACHE all
> the time whether you want it or not, but clarifying that might be nice
> (especially since there's some chance that something will eventually come
> along to break it...)

Yes, riscv selects ARCH_DMA_DEFAULT_COHERENT and the riscv IOMMU hardware
descriptions don't provide any way to say otherwise. I can put a comment
above the IOMMU_CAP_CACHE_COHERENCY case which states "The RISC-V IOMMU is
always DMA cache coherent", or did you have something else in mind?

Thanks,
drew

> 
> Thanks,
> Robin.
> 
> > Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
> > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >   drivers/iommu/riscv/iommu.c | 12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> > 
> > diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
> > index 8a05def774bd..3fe4ceba8dd3 100644
> > --- a/drivers/iommu/riscv/iommu.c
> > +++ b/drivers/iommu/riscv/iommu.c
> > @@ -1462,6 +1462,17 @@ static struct iommu_group *riscv_iommu_device_group(struct device *dev)
> >   	return generic_device_group(dev);
> >   }
> > +static bool riscv_iommu_capable(struct device *dev, enum iommu_cap cap)
> > +{
> > +	switch (cap) {
> > +	case IOMMU_CAP_CACHE_COHERENCY:
> > +	case IOMMU_CAP_DEFERRED_FLUSH:
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> >   static int riscv_iommu_of_xlate(struct device *dev, const struct of_phandle_args *args)
> >   {
> >   	return iommu_fwspec_add_ids(dev, args->args, 1);
> > @@ -1526,6 +1537,7 @@ static void riscv_iommu_release_device(struct device *dev)
> >   static const struct iommu_ops riscv_iommu_ops = {
> >   	.pgsize_bitmap = SZ_4K,
> >   	.of_xlate = riscv_iommu_of_xlate,
> > +	.capable = riscv_iommu_capable,
> >   	.identity_domain = &riscv_iommu_identity_domain,
> >   	.blocked_domain = &riscv_iommu_blocking_domain,
> >   	.release_domain = &riscv_iommu_blocking_domain,

