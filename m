Return-Path: <kvm+bounces-13741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 208B689A1D4
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 17:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C92811F22405
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 15:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222D1171099;
	Fri,  5 Apr 2024 15:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDejj3ET"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A5F16F28B;
	Fri,  5 Apr 2024 15:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712332231; cv=none; b=Ma+zSv8DXX2U0UQiqfXsJ8cds57f5OSUhOlg+uzWlv9hWuFI/7AF3DSOSpwxLO7SgtzvjyN039vwajIy0OglrU76Ohb/X6phXrQ26d304vgLPME4zca6FypY4TZlDVKB5UMiO+5DGnQO+NU8qAJ1Qhedu0eUbQw7s310Bng9Exo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712332231; c=relaxed/simple;
	bh=JuwIBPyywPFitWU0GAYwZuSb8x811YnAxbc/FR7Z6kg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jBU5MY1W6QRh0+Mx+W/ACK6CMe5kHj6J+IatiYganWDrI5TlDM+zFsOSK4JCSUnBhAt8EVm0ANxwnu/kHMPzM5U8WiwJL2+B3wrl4Iuvu87Ft4bYS9pXqJogKrEAG98O+rEnFJ5HkRyQrFUcPgp6gGDxSYE8eJU15voiYKZYavY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDejj3ET; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712332229; x=1743868229;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JuwIBPyywPFitWU0GAYwZuSb8x811YnAxbc/FR7Z6kg=;
  b=mDejj3ETBMQC3/UBpoaBLyPhW94V8rkm/P03UDmXMLfTpQPQp+is3t2s
   VIjeBble3YCNSruCKVEp+1PrkGqMS9U1Mx1UpDwonWsEPNHTigC7XIupg
   EEas9o2WnYkZT9r+Lx7rZiCsfkLsKxz14dvneTgcH1++SsTrDZ/rISp7o
   EJWdQCBncoiEoqdKTFAoMSY42drhBKfDUWaLbJFVmClcmTaclZTRF+cHM
   3asCrbsPy0m39UxlaDIRqAFrU2rB1It1mvri/xOkpfkhF1ZaCrgzY+suT
   e0tc1pYTf0IjvbSjtlw1XULiu3wGfplKm3mjxVozb6G4i9ri7/5Pp4v3l
   g==;
X-CSE-ConnectionGUID: xaUgz2DZTJOPoNF5yyEW9Q==
X-CSE-MsgGUID: n9S30rN/TRqFM6u0dFIVzA==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="7830974"
X-IronPort-AV: E=Sophos;i="6.07,181,1708416000"; 
   d="scan'208";a="7830974"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 08:50:19 -0700
X-CSE-ConnectionGUID: b+flWz2dSiyMWDRXybRuQw==
X-CSE-MsgGUID: xBkY6l/yQaKUhOjf4ieNSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,181,1708416000"; 
   d="scan'208";a="23905135"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 08:50:19 -0700
Date: Fri, 5 Apr 2024 08:54:46 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Thomas Gleixner
 <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Paul Luse
 <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jens
 Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, maz@kernel.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH 04/15] x86/irq: Add a Kconfig option for posted MSI
Message-ID: <20240405085001.2bb3e8ad@jacob-builder>
In-Reply-To: <89927174-6ca9-4299-8157-a0404b30b156@gmail.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
 <20240126234237.547278-5-jacob.jun.pan@linux.intel.com>
 <89927174-6ca9-4299-8157-a0404b30b156@gmail.com>
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

Hi Robert,

On Fri, 5 Apr 2024 10:28:59 +0800, Robert Hoo <robert.hoo.linux@gmail.com>
wrote:

> On 1/27/2024 7:42 AM, Jacob Pan wrote:
> > This option will be used to support delivering MSIs as posted
> > interrupts. Interrupt remapping is required.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >   arch/x86/Kconfig | 11 +++++++++++
> >   1 file changed, 11 insertions(+)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 5edec175b9bf..79f04ee2b91c 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -463,6 +463,17 @@ config X86_X2APIC
> >   
> >   	  If you don't know what to do here, say N.
> >   
> > +config X86_POSTED_MSI
> > +	bool "Enable MSI and MSI-x delivery by posted interrupts"
> > +	depends on X86_X2APIC && X86_64 && IRQ_REMAP  
> 
> Does posted_msi really depend on x2APIC? PID.NDST encoding supports both
> xAPIC and x2APIC.
No, posted_msi works with xAPIC as well. I just fixed a bug in NDST xAPIC
encoding, will be in v2.

I was thinking from the performance advantage of x2APIC. But you are right
they are orthogonal.

> If posted_msi posts more stringent requirement, I think it deserves an 
> explanation in this patch's description.
> And, X86_X2APIC already depends on IRQ_REMAP, can we just list one of
> them here?
Will drop X2APIC dependency.

Thanks,

Jacob

