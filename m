Return-Path: <kvm+bounces-58562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA007B96A92
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 638857B5320
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8609326A0DD;
	Tue, 23 Sep 2025 15:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GnQfH0T/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2211525CC74
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 15:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758642660; cv=none; b=APE/ztSZb0MK/TxuPun8vtTwJrocR4fp11epV1s3aVDIVyAIO204rxCkAzyDspHQy0cReCMAPBOdG4Lpn1eeePYeumANA+8ShYNMuraC9qagasVg9imYQZflBvpYBn2mBeznwwiJd2FGHZHAHz7O3PYTrk3o//KGEUv/FlM+M/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758642660; c=relaxed/simple;
	bh=y4VwCCCCWo6KKwueZ28Bgn8vy5ceg5kGAxCvv+C/JDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvyMrgAZnoJQWEJV3HT8uB9+oObuBnGna8PpgwZ6YxHxEDgeYNro5iUDkXciRyK0yBZvqDtz3t3oFpXZgvSRIm3t4psxgUSmd+HFny6+MLL3DWc8W37Ctl37NYota8AwCl5niH8OD8OtZ/3Mkp5o6dJ40+VtEUkB+udhvcNHhX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GnQfH0T/; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-63606491e66so340699d50.2
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 08:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758642658; x=1759247458; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3CqX8wo4OIF9dVnHcV+vNQ/UyqzH0cRogmJfYlIiKHQ=;
        b=GnQfH0T/1VDaxK9w1S/jyW/3VyzUygOU5OoNakd5PYzvSbc+cVygspptqBCpSLvKzH
         7S2m3iSGsySshFqtSYdIR5WQkggYuM5Amjz5u/ADfpWGNCyGDIm3pQuwV0ZN+3NW/r7l
         YgwlMn/ipWa9jPOJJLEIecSbkUYw38z6MboZ0pv7NCZh/DrcVIIJlM2v2CPDv0zWXD3X
         eVHY/oBGpMOqIX2cEhyaUl6Es2u15jP0hAaP3efN4PVpnwTJHluKgl+Rrh7fQMVj6a1S
         0r/RstOkbpz2IeymhpF4uxDt2TkN9sWRs6dNR56ovrpW+3ns/LDWtDZfjiD89GiD4ad/
         Ynig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758642658; x=1759247458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3CqX8wo4OIF9dVnHcV+vNQ/UyqzH0cRogmJfYlIiKHQ=;
        b=EeKaCYV0Wn0yy3LuyGBFks+9H/Njg3TVQ1JIFLUnRB+b3NAbkPcQX23RB/Aa6vMRwi
         xqUyMJj39CkVe9QT36Upocm2II9U2pscsugqVedKEssfFjiDJzMOJTy/zK23ET7Ym3o/
         B+bxDeUz0JKY7p2Y1v68lRbFli3j/YyCnRdr3xUEd968l/eEZgoYOLyE5+L3esU1vw8F
         IfRlSEld1AJwgagyzH82xyoURex6moT5GxUfpHnL7AMosBK6dJ/fLpDW71ScynVXLKLg
         aOjAuJWOKJIIJqf8ocmoNvGOrj3luJbTlVz0l9B6xC6CjdztUafLL4hZfP86w6KxauHE
         Bt5A==
X-Forwarded-Encrypted: i=1; AJvYcCUR4m/VlbWO2sX6+Hoz5rWmc7PX8DiP6vU3oSQFLDJCCic+x8W8K/1rWNugWwjjhvU2EUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy7sfl57/0cJgjIMLcVYvig5xKf6cXFMwiLPUUVc8rqve1+J5H
	2RiW9tpq1HkqoRKDHYw7fioXJnRUfIdnzuYNHm33WaLV06L6GX6mm2zV8xg8otzn728=
X-Gm-Gg: ASbGncuHfi8tvEAbd/ENj3y70SmN7Hs7OmZ53kPfZfFEEKVALrItcrZWeIFgtHH5YL5
	iLTlHxEpCFLasxmRHMDcFv9pqhpknlYfmczxRs2taFqW1i7aracFbIjAQTyN4U4BzaG16XAG798
	c//tBqMJAMfaRVZ4baLDMbgrv6iSV4P5x0Z3E69dOsz5HkJpZwuVaPLzjym43EaR/7yqewb3PMy
	zuEMc6+sqEDikakuGXQUCM4AkZ6Yv0gSonZZLwAQEvuDfH1Vx7TDyM0YJU5er3gHxZHJy+vPtVR
	A7OZEHWplUT89lYfVSI59T+DM4nl4mVrmMwSahuOXsV0sJ31w/Pu6K5tdFaFrQMPiS1Hhe1odVX
	OwNdNausuWBy2PeUnISUYIqlM
X-Google-Smtp-Source: AGHT+IG9zvGVFr+YOmFk29/0ncfJA3SG76AOSrmrzmJdcjBUK8KbuId/KM4G7ZMmRoUwWwnCaf4a6g==
X-Received: by 2002:a53:83ce:0:b0:636:3cc:28b2 with SMTP id 956f58d0204a3-6360476fce8mr1873137d50.36.1758642658091;
        Tue, 23 Sep 2025 08:50:58 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-633bcb601d6sm5411190d50.0.2025.09.23.08.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 08:50:57 -0700 (PDT)
Date: Tue, 23 Sep 2025 10:50:56 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, iommu@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, zong.li@sifive.com, tjeznach@rivosinc.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com, anup@brainfault.org, atish.patra@linux.dev, 
	alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
Message-ID: <20250923-e459316700c55d661c060b08@orel>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
 <20250922-50372a07397db3155fec49c9@orel>
 <20250922235651.GG1391379@nvidia.com>
 <87ecrx4guz.ffs@tglx>
 <20250923140646.GM1391379@nvidia.com>
 <20250923-b85e3309c54eaff1cdfddcf9@orel>
 <20250923152702.GB2608121@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923152702.GB2608121@nvidia.com>

On Tue, Sep 23, 2025 at 12:27:02PM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 23, 2025 at 10:12:42AM -0500, Andrew Jones wrote:
> > be able to reach be reachable by managing the IOMMU MSI table. This gives
> > us some level of isolation, but there is still the possibility a device
> > may raise an interrupt it should not be able to when its irqs are affined
> > to the same CPU as another device's
> 
> Yes, exactly, this is the problem with basic VFIO support as there is
> no general idea of a virtualization context..
> 
> > and the malicious/broken device uses the wrong MSI data.
> 
> And to be clear it is not a malicious/broken device at issue here. In
> PCI MSI is simple a DMA to a magic address. *ANY* device can be
> commanded by system software to generate *ANY* address/data on PCIe.
> 
> So any VFIO user can effectively generate any MSI it wants. It isn't a
> matter of device brokeness.
> 
> > near isolated enough. However, for the virt case, Addr is set to guest
> > interrupt files (something like virtual IMSICs) which means there will be
> > no other host device or other guest device irqs sharing those Addrs.
> > Interrupts for devices assigned to guests are truly isolated (not within
> > the guest, but we need nested support to fully isolate within the guest
> > anyway).
> 
> At least this is something, and I do think this is enough security to
> be a useful solution. However, Linux has no existing support for the
> idea of a VFIO device that only has access to "guest" interrupt HW.
> 
> Presumably this is direct injection only now?

Yup

> 
> I'm not even sure I could give you a sketch what that would look like,
> it involves co-operation between so many orthogonal layers it is hard
> to imagine :\
> 
> kvm provides the virt context, iommufd controls the MSI aperture, irq
> remapping controls the remap table, vfio sets interrupts..
> 
> VFIO needs to say 'irq layer only establish an interrupt on this KVM'
> as some enforced mode ?
>

Yes, this is the part that I'd like to lean on you for, since I understand
we want to avoid too much KVM/virt special casing for VFIO/IOMMUFD. I was
thinking that if I bit the bullet and implemented nested support than when
nesting was selected it would be apparent we're in virt context. However,
I was hoping to pull together a solution that works with current QEMU and
VFIO too.

Thanks,
drew

