Return-Path: <kvm+bounces-58413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FC7B935CE
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 23:20:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA51A19C05F7
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 21:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFEFB286D69;
	Mon, 22 Sep 2025 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RekU22S2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5793C274B2F
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 21:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758576048; cv=none; b=hYk0iKukhc7D5/bpfqyyK7lEP6g2KNHWtQMJVSDXSNqwyCVPYH3RMcph8mlTsFZmF1jD+QzTDn9ZpkBXBNEYNeUdgqE8FhXGV/3hpTDJDqFGv3h2lNAvKW7wC6qeHqbMdF+XHY61D7txiZ415Gi3Y7KYnndeaeT/L8WkdabOI0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758576048; c=relaxed/simple;
	bh=xihBR50Hw2D9VbbOxPhiH3tyeef2qtQXdEqxf23CwKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jy2KDMbB+4pCmNNeYmmvcJMpPk3KEN0c6dwqZfqQl6D+qC/7kJcCj2Ahk9dSncnn+gg7/Z9jIGHJC23a8D3V9rPSF1MczXV3GA9yNXZSwPXm9PDjvsxorZXGz19HE+Ab+I/PzswXzqJrgNdMCbVo3Uo2+P8roo9JgaVqXRDxfe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RekU22S2; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-723ad237d1eso45350167b3.1
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 14:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758576045; x=1759180845; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=onj4yFqllMzEveOUk9DfiKAf4L6zZPOcmFKF8e4Prmo=;
        b=RekU22S29EWqJzTI15pNBLvm4dd33dZUs0lq1e/v122oymxTrdV+kuI/xa4wANY21H
         yQ2CshfsR2Ac6bitlycLLtbWa2+8TN4iygiFDW62vYbRj4RORw8TIsFB2inxh7IY3LeY
         eMuggKBcuOVjwazuTlT5F/5h9yOeXBqtFkItsy+U7Ub+RPwYQ1NKQzRF1UzKFT0LH+4+
         CMXLe8j73dgyUIWvznFQRp4CKnZVdbz7PrY/THc+4c6TRXBwQtlgoxHMr2f5FO+w/PVq
         5gW1VRDLSD2g0ZPSpb3p47IxYstYXwpxC91kyzW1wLaAKQ4vBpXsVTxNWCpcQ0HeZa1o
         R9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758576045; x=1759180845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onj4yFqllMzEveOUk9DfiKAf4L6zZPOcmFKF8e4Prmo=;
        b=IdKR4Z6vz+L+A41DJNhHmPE1oHHLLpDSlzbvHrDmolHbdWlbqoBgy7ljRNp+uUkrZ8
         CPwSsJFKwB83Xe+GJEZBT/wWMzS38Edks7msP1CL6K2Oc3+f1apLrsSKin7jsA9ntv48
         FoJHl/QdDm99gRHA603YjQDL2+B9dU+jNkp16miC6UkLVRad8xi1xyct8Olfb7oM5syD
         xxu1lDeIeCCLZlziv8Ku4OEv5G0vgnwtVJbZWHL2Ni/pGT1V5x9J26csDRB36aOVJK3f
         ifuSB3q9ZiHdlg5N1cdCuXNkzrl+K/Npk9SKJ84q+RmFNcPF5WMj1PMRDKH294GDn/VR
         4bLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzsHdFgOMHVegK8Ss8ftyegJSxhDlFFAov+YJq4WwZhrHN/69z5+iumD0OaoK7nIXkIKI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6OlUnJQEcYUKRFWMlki+Ss5gBSiygAhGpwotn7DJWPobx1Vel
	mxVM1lP57fhIEHa5oUlpIYjrs4nVG5heY3eDNkcg5acfaPeBiNJt342U0MImzsu90Hg=
X-Gm-Gg: ASbGnctIQdm5scpWfDKpWnCP5dAf7Wi/SO76EzN/fd37zz1mgPvQjbjaclqLpy3l6Ft
	QmRi3x645+1W9w1MOeK40E3LnKEIoTjIsp1kBWOwlDrp7oFsnnb4J6sQIpDEiixsC6o+Cywvd7e
	drozs550boTyCYYrzn2F0uZiqKp0sf7jG/BPwlNHq6IiE8Ivl7mG8ZGaow9kbBGJGGAX1t+D/u5
	OBdgxJgNTm9CTwTVx7f9LTnAuLCG09hh201L8D+srJF9aimbtljuM5LFML9uATHvENvVNyKTKmt
	SaAvG7wLUl6LL2UCu42ivXf1q0Y5KauQ29uJDu4hFyq7ZvcylvTEhqjleB4sQOINHtEJf2+RH6Y
	rrR3ZiNbnxVDyjW8djhr3SdnO
X-Google-Smtp-Source: AGHT+IEkvQZ5SylVDHV/m2S+NTAyd5wvsiLsp5Pptg5UwT2UN0VbvwmLcskjGP4MQTxbjIrmiAtKRQ==
X-Received: by 2002:a05:690c:4b03:b0:722:6f24:6293 with SMTP id 00721157ae682-758a2d07fd7mr1394647b3.32.1758576045119;
        Mon, 22 Sep 2025 14:20:45 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-633bcce7089sm4581523d50.5.2025.09.22.14.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 14:20:44 -0700 (PDT)
Date: Mon, 22 Sep 2025 16:20:43 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	zong.li@sifive.com, tjeznach@rivosinc.com, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, anup@brainfault.org, atish.patra@linux.dev, tglx@linutronix.de, 
	alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
Message-ID: <20250922-50372a07397db3155fec49c9@orel>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922184336.GD1391379@nvidia.com>

On Mon, Sep 22, 2025 at 03:43:36PM -0300, Jason Gunthorpe wrote:
> On Sat, Sep 20, 2025 at 03:38:58PM -0500, Andrew Jones wrote:
> > When setting irq affinity extract the IMSIC address the device
> > needs to access and add it to the MSI table. If the device no
> > longer needs access to an IMSIC then remove it from the table
> > to prohibit access. This allows isolating device MSIs to a set
> > of harts so we can now add the IRQ_DOMAIN_FLAG_ISOLATED_MSI IRQ
> > domain flag.
> 
> IRQ_DOMAIN_FLAG_ISOLATED_MSI has nothing to do with HARTs.
> 
>  * Isolated MSI means that HW modeled by an irq_domain on the path from the
>  * initiating device to the CPU will validate that the MSI message specifies an
>  * interrupt number that the device is authorized to trigger. This must block
>  * devices from triggering interrupts they are not authorized to trigger.
>  * Currently authorization means the MSI vector is one assigned to the device.

Unfortunately the RISC-V IOMMU doesn't have support for this. I've raised
the lack of MSI data validation to the spec writers and I'll try to raise
it again, but I was hoping we could still get IRQ_DOMAIN_FLAG_ISOLATED_MSI
by simply ensuring the MSI addresses only include the affined harts (and
also with the NOTE comment I've put in this patch to point out the
deficiency).

> 
> It has to do with each PCI BDF having a unique set of
> validation/mapping tables for MSIs that are granular to the interrupt
> number.

Interrupt numbers (MSI data) aren't used by the RISC-V IOMMU in any way.

> 
> As I understand the spec this is is only possible with msiptp? As
> discussed previously this has to be a static property and the SW stack
> doesn't expect it to change. So if the IR driver sets
> IRQ_DOMAIN_FLAG_ISOLATED_MSI it has to always use misptp?

Yes, the patch only sets IRQ_DOMAIN_FLAG_ISOLATED_MSI when the IOMMU
has RISCV_IOMMU_CAPABILITIES_MSI_FLAT and it will remain set for the
lifetime of the irqdomain, no matter how the IOMMU is being applied.

> 
> Further, since the interrupt tables have to be per BDF they cannot be
> linked to an iommu_domain! Storing the msiptp in an iommu_domain is
> totally wrong?? It needs to somehow be stored in the interrupt layer
> per-struct device, check how AMD and Intel have stored their IR tables
> programmed into their versions of DC.

The RISC-V IOMMU MSI table is simply a flat address remapping table,
which also has support for MRIFs. The table indices come from an
address matching mechanism used to filter out invalid addresses and
to convert valid addresses into MSI table indices. IOW, the RISC-V
MSI table is a simple translation table, and even needs to be tied to
a particular DMA table in order to work. Here's some examples

1. stage1 not BARE
------------------

      stage1     MSI table
 IOVA ------> A  ---------> host-MSI-address

2. stage1 is BARE, for example if only stage2 is in use
-------------------------------------------------------

           MSI table
 IOVA == A ---------> host-MSI-address

When used by the host A == host-MSI-address, but at least we can block
the write when an IRQ has been affined to a set of harts that doesn't
include what it's targeting. When used for irqbypass A == guest-MSI-
address and the host-MSI-address will be that of a guest interrupt file.
This ensures a device assigned to a guest can only reach its own vcpus
when sending MSIs.

In the first example, where stage1 is not BARE, the stage1 page tables
must have some IOVA->A mapping, otherwise the MSI table will not get
a chance to do a translation, as the stage1 DMA will fault. This
series ensures stage1 gets an identity mapping for all possible MSI
targets and then leaves it be, using the MSI tables instead for the
isolation.

I don't think we can apply a lot of AMD's and Intel's model to RISC-V.

> 
> It looks like there is something in here to support HW that doesn't
> have msiptp? That's different, and also looks very confused.

The only support is to ensure all the host IMSICs are mapped, otherwise
we can't turn on IOMMU_DMA since all MSI writes will cause faults. We
don't set IRQ_DOMAIN_FLAG_ISOLATED_MSI in this case, though, since we
don't bother unmapping MSI addresses of harts that IRQs have be un-
affined from.

> The IR
> driver should never be touching the iommu domain or calling iommu_map!

As pointed out above, the RISC-V IR is quite a different beast than AMD
and Intel. Whether or not the IOMMU has MSI table support, the IMSICs
must be mapped in stage1, when stage1 is not BARE. So, in both cases we
roll that mapping into the IR code since there isn't really any better
place for it for the host case and it's necessary for the IR code to
manage it for the virt case. Since IR (or MSI delivery in general) is
dependent upon the stage1 page tables, then it's necessary to be tied to
the same IOMMU domain that those page tables are tied to. Patch4's changes
to riscv_iommu_attach_paging_domain() and riscv_iommu_iodir_update() show
how they're tied together.

> Instead it probably has to use the SW_MSI mechanism to request mapping
> the interrupt controller aperture. You don't get
> IRQ_DOMAIN_FLAG_ISOLATED_MSI with something like this though. Look at
> how ARM GIC works for this mechanism.

I'm not seeing how SW_MSI will help here, but so far I've just done some
quick grepping and code skimming.

> 
> Finally, please split this series up, if ther are two different ways
> to manage the MSI aperture then please split it into two series with a
> clear description how the HW actually works.
> 
> Maybe start with the simpler case of no msiptp??

The first five patches plus the "enable IOMMU_DMA" will allow paging
domains to be used by default, while paving the way for patches 6-8 to
allow host IRQs to be isolated to the best of our ability (only able to
access IMSICs to which they are affined). So we could have

series1: irqdomain + map all imsics + enable IOMMU_DMA
series2: actually apply irqdomain in order to implement map/unmap of MSI
         ptes based on IRQ affinity - set IRQ_DOMAIN_FLAG_ISOLATED_MSI,
         because that's the best we've got...
series3: the rest of the patches of this series which introduce irqbypass
         support for the virt use case

Would that be better? Or do you see some need for some patch splits as
well?

Thanks,
drew

