Return-Path: <kvm+bounces-67252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6DDCFF390
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 18:55:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 836A430012FC
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 17:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8E2B37D1D2;
	Wed,  7 Jan 2026 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Ch1kgFCN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com [209.85.210.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2612363C6A
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767808313; cv=none; b=fVbwPsSSBiDJKkvJs5T9CGNG6gzYWgiHEqTnCcNWUKmVOdAS/MmIGSSNxJZQ4QbrllHsNHZnA0lfZfmWq2icuLkV5DGgvq3ibgZzpOwjVkkI6xbKEpvEPznlEGK3LOJ63cWu9okA7uDfECawi5TrftFGRKM5HLp1kjos5dXTbjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767808313; c=relaxed/simple;
	bh=RcoDYlucZ66l2Sfv7PYDyJOdRnPBCeYpyqcCKNIchCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHfO4VbnS/tkOxPhEC4uPXYMQUBb42sO41rOXrhQNCsw9UqJX+yutfMIteYRU13wxI7hKJIRUGpc4F5F25TEshk0MX2uYdGRa309sTHQH8Se1PQYvUk8tHoMzYeTJTgDR9KEjB5sqK/HKjo5ueLcQ8HiMCupEQICYMs0EvWBpJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Ch1kgFCN; arc=none smtp.client-ip=209.85.210.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ot1-f67.google.com with SMTP id 46e09a7af769-7c7613db390so1327673a34.2
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 09:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1767808302; x=1768413102; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/E5kiVoPjL6HPjfNbHsUE0ncuM+O4VtxgKzooyiAI6s=;
        b=Ch1kgFCNuj/o4cLx0yF/pnrhRx8vrnNMPxtTz9cLxuWBBjqRZll9ySnpVKSsEe09AB
         sRylTu41RhJDHf9whs3sVIPrEPZjHSQM8HNiN8PzowIhgWDWBFE6qZTN6H0sPv2qKSZ9
         F5kfQhsiSyUV84F5NQOCCZyOo08k1SULFS1040re54QJ8s0i8cCocJg0msivVEZnU265
         AVFU6p+WViRvu75vPMRjZOJXaRqmfqcLk8aO3IVLZ7qzdcCz2/vFPAPkLaSqU9v4SgdA
         VloVbvffGCRSxitUQM8VP9JY6FWIBsmOhtJ9+Qm1o14raCz8rLrh7brhpLhO1R9m4pCG
         4yZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767808302; x=1768413102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/E5kiVoPjL6HPjfNbHsUE0ncuM+O4VtxgKzooyiAI6s=;
        b=NI8JcmHVA3jQf0BCnVWTC6HzkKHwz+6uEVKZkrncvXhwFT+VK6yy4aQqmME4uDTTJz
         8Aeds/R8wUVthxBeTYaqQo9E/Njn9WXb1gTRYEWJ3NQNcxBARxsUCT5TvsQGLtmU6HvY
         Tq/fBe7JKE7/IxCBo5zAVAQr1zp33bQ9BON3kW0E0gthhXkeeYk36hAQZTfFQDDmBFma
         4ZrgehdBrOYA5Gt6KA7jESISzZKpaCUUbHvGVfYJWxru3cdP56SePoScPG2Gg8SS5B25
         0BF63yWYkUgkaeynSYxz9NfvUasrCeFSATrM2B43RF8cpFCZIenfNCWGIK5OChc/l9f1
         U3AA==
X-Forwarded-Encrypted: i=1; AJvYcCVLkQ0LkAIalmrnOwJJhYesWAruCJE1SXdMg2uQltKl97V/jJQNnQVR8xGfTg2fCrES96Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1txhCrZhTEcUQIuKDKuFQ+dyhASAtVpXQoXp3gSCXV1ru3HAw
	2AUiKI8X10SPHn0vfZwqj5qCY9gHda74kvRrVpWR2LHSjEkxZByRFQglJI/g1nQ/o7w=
X-Gm-Gg: AY/fxX5hN443B1HRiwGotQpTXuBc2cCsuUiyh0u3Z6WcMjBdw4ABngX/ss/4k5WwmCi
	OEN8fgLRVwMh/yhubTo9zL/z6LUs8ExVtLLn9fBO1VhOsGPvWET5SILvRA5v8SIAxP40WGk8cM1
	iaqcARH5ldsUjMlOqyJXrT2eIUahdgYtbJ+Izmd/fsPY2d6eZiB43SDSwBHeD7QV5WqFg+EnXM2
	ZcU0kGCMTJ0lNrTpubLrRUyzCec+FT48cTJn8E1PUkVma/ne04QbD4dzXUM6NwshAxI4lVYVRzZ
	kKE6SXumvJkdfHi5pf7ogfqWQJzboA54c4tkAXSGp/A5og47NwxsKHcVHmOewEI16OjmXhPg94c
	YutpFHCUbzSK0MQLfYIOvblLgrkCKDKXRtpKvNcJmBNv1fu+LC1MQCg0RtTes06jIF6i4nU6T/S
	zgK/UoPU4frQC4
X-Google-Smtp-Source: AGHT+IE13osf5CjYyTbx4kUFVq9/wdcOC/ch/TW3ja8QBG6H6cD6+EWQcns0Lx1kzYLZNwCYibHqkw==
X-Received: by 2002:a05:6820:2204:b0:659:9a49:8fe1 with SMTP id 006d021491bc7-65f54ed4064mr1332868eaf.14.1767808301928;
        Wed, 07 Jan 2026 09:51:41 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de8cbfsm3524574fac.3.2026.01.07.09.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 09:51:41 -0800 (PST)
Date: Wed, 7 Jan 2026 11:51:40 -0600
From: Andrew Jones <ajones@ventanamicro.com>
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Zong Li <zong.li@sifive.com>, 
	Tomasz Jeznach <tjeznach@rivosinc.com>, joro@8bytes.org, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Anup Patel <anup@brainfault.org>, atish.patra@linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, alex.williamson@redhat.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, iommu@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv <linux-riscv@lists.infradead.org>, 
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about RISCV IOMMU irqbypass patch series
Message-ID: <20260107-dc4b5f1d879db9afb00a4a87@orel>
References: <CAPYmKFscKJ1ff470d6YmuMxLdJPSZ-ZmuGMMAFO83TT-vvV2JQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPYmKFscKJ1ff470d6YmuMxLdJPSZ-ZmuGMMAFO83TT-vvV2JQ@mail.gmail.com>

On Wed, Jan 07, 2026 at 06:01:26PM +0800, Xu Lu wrote:
> Hi Andrew,
> 
> Thanks for your brilliant job on the RISCV IOMMU irqbypass patch
> series[1]. I have rebased it on v6.18 and successfully passed through
> a nvme device to VM. But I still have some questions about it.
> 
> 1. It seems "irqdomain->host_data->domain" can be NULL for blocking or
> identity domain. So it's better to check whether it's NULL in
> riscv_iommu_ir_irq_domain_alloc_irqs or
> riscv_iommu_ir_irq_domain_free_irqs functions. Otherwise page fault
> can happen.

Indeed. Did you hit the NULL dereference in your testing?

> 
> 2. It seems you are using the first stage iommu page table even for
> gpa->spa, what if a VM needs an vIOMMU? Or did I miss something?

Unfortunately the IOMMU spec wasn't clear on the use of the MSI table
when only stage1 is in use and now, after discussions with the spec
author, it appears what I have written won't work. Additionally, Jason
didn't like this new approach to IRQ_DOMAIN_FLAG_ISOLATED_MSI either,
so there's a lot of rework that needs to be done for v3. I had had hopes
to dedicate December to this but got distracted with other things and
vacation. Now I hope to dedicate this month, but I still need to get
started!

Thanks,
drew

> 
> [1] https://lore.kernel.org/all/20250920203851.2205115-20-ajones@ventanamicro.com/
> 
> Best regards,
> Xu Lu

