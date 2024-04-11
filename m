Return-Path: <kvm+bounces-14309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2C08A1EAB
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8312C282DD6
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750BC54F87;
	Thu, 11 Apr 2024 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXwVDBYw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385092BCF9;
	Thu, 11 Apr 2024 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712859903; cv=none; b=c4oOjAi1f/b1vRszMvaOXcppWNcxOsXJFZAeLKSC5Ba47Yh7uYRDTqCnJwVO5iHvZ8v6rmMLDzXzA+VWUDS76kEJBptfgVUxyoOi+GwYlQ44i3sYHDg5qnwxGBWDwqXJS+o9iSL6tvYAROARzCBZ2QfnaweJqBQYDRK65Kuh/hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712859903; c=relaxed/simple;
	bh=c2g0tbUCqfPKXbZUyvRm01VrhJY6EMVcc1wcJ3a0Ym0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rgeagb8HhXGEUQgj7qk+M6gOnUS7KMoPQldUlwAn+k+6nO0CwUbSxJ1jhl6V8O9/Dpwb7m0oq2/lArCWY+hVex+RFCikg/jI6Q1HSxevFUk7Cao5CxEXirsVDswqLMR0skC3rBngWGpb1P7HjkhM5mzCK4TnC8+M6Ax0GHYKwW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXwVDBYw; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712859902; x=1744395902;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c2g0tbUCqfPKXbZUyvRm01VrhJY6EMVcc1wcJ3a0Ym0=;
  b=HXwVDBYwjzoa7OLJXyu0+WjdeCyW1HwL3j8ClOAYiBlQpbzutB2DEMiH
   9ppQunxR22MivraSiVHpQ3Aq1tgOh4OUcGAAV+rqnmr6iv9VPVXnSs1xo
   UA8+GfHF1pNqFuYChJrxAv0/H+XSLi8RIqaoX4/9P7qoeSTgDL79++S12
   j9KJRCkdXZ6cWX865I+dZXH/pBNaBR+iJ8xQJVFtIxZ6A54z50Y7FMFTO
   LU6tZTaa4b34YzQQEYZsRV3e+njJb+TZThJR0eAeP14pHz0n8/CjGI4j1
   TV1XwtCyocjed3cpTfpdie1CgDgwqzH6EAIUbI4jQ7SYkwy5u6lazCpE5
   w==;
X-CSE-ConnectionGUID: +oITaEHjQ1u24PElUBtbTQ==
X-CSE-MsgGUID: QIbuvSixQIWCu4Qejlnxlw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8514939"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="8514939"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 11:25:01 -0700
X-CSE-ConnectionGUID: 3QOiQzoGR0OiHwTo7hCQqQ==
X-CSE-MsgGUID: GUYxnY+LQ9+gm23AkhcO6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="51936865"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 11:25:01 -0700
Date: Thu, 11 Apr 2024 11:29:32 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Lu Baolu
 <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jim.harris@samsung.com, a.manzanares@samsung.com, Bjorn Helgaas
 <helgaas@kernel.org>, guang.zeng@intel.com, robert.hoo.linux@gmail.com,
 jacob.jun.pan@linux.intel.com, xin3.li@intel.com
Subject: Re: [PATCH v2 08/13] x86/irq: Install posted MSI notification
 handler
Message-ID: <20240411112932.6b1a4dbb@jacob-builder>
In-Reply-To: <87bk6f262i.ffs@tglx>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-9-jacob.jun.pan@linux.intel.com>
	<87bk6f262i.ffs@tglx>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Thomas,

On Thu, 11 Apr 2024 18:54:29 +0200, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Fri, Apr 05 2024 at 15:31, Jacob Pan wrote:
> >  
> >  #ifdef CONFIG_SMP
> > diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
> > index fc37c8d83daf..f445bec516a0 100644
> > --- a/arch/x86/kernel/idt.c
> > +++ b/arch/x86/kernel/idt.c
> > @@ -163,6 +163,9 @@ static const __initconst struct idt_data
> > apic_idts[] = { # endif
> >  	INTG(SPURIOUS_APIC_VECTOR,
> > asm_sysvec_spurious_apic_interrupt), INTG(ERROR_APIC_VECTOR,
> > 		asm_sysvec_error_interrupt), +# ifdef
> > CONFIG_X86_POSTED_MSI
> > +	INTG(POSTED_MSI_NOTIFICATION_VECTOR,
> > asm_sysvec_posted_msi_notification), +# endif
> >  #endif
> >  };  
> 
> Obviously lacks FRED support...
Good point, forgot FRED is merged :)

Will add an entry to entry_fred.c. I would not be able to test performance
though.

Thanks,

Jacob

