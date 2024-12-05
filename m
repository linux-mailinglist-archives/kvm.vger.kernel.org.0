Return-Path: <kvm+bounces-33116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E039E4F90
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 09:19:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C07FA1628D2
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 08:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65AC41D27BB;
	Thu,  5 Dec 2024 08:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ed/a/koE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC222391BC;
	Thu,  5 Dec 2024 08:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733386756; cv=none; b=WHmNBKx4cXjlrYjUjNIK3qVeALLgQoH2klAspJyUlfiBh1YmSNPtlMCjFZm0EgyL7YlelfkWBiKfVaDaT7W7hdRiKbeVbky/AEqT01ZMxeb52oZQkdstQuK6/VvuorshGR7Ct0QXYRvxJj1LrYpoUDNolDgdRhtWAw5cVBaclps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733386756; c=relaxed/simple;
	bh=JhiphLgWiCNfU2elVpuwBoY3t+FHsdzdxyELcgnhNNI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fMEOLLWrBURuLHb6YYk2mcQKBCOHjobwZA4gOVDsZw41X6n1Fy0j0cLrEI22EbOfJRYKLVzyf909VdIvp/7dgBcTZvJk/FUB4BttSvyO9IG6y2hyAiNn0jUdhiBeFA0RIeDn8B620qiYGrZLurmq85WlGf7+FtpTUsA2DG9fjXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ed/a/koE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74755C4CED1;
	Thu,  5 Dec 2024 08:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733386756;
	bh=JhiphLgWiCNfU2elVpuwBoY3t+FHsdzdxyELcgnhNNI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ed/a/koEM7nuMGLarG44D9RLXHxcLryGUfOLiuP8BxrlWBK0XjjxHncEkZatuuVYx
	 XXdUUf2pd/V9Ed2JvRSa51z9g/lbDlPltAkIMKDe9/irTfAhrGCdDynO7BbogtGq4b
	 d97z8ebzyBTzL/yezLGrvM5z5eAYlQDsOJG8boLGcl5+hBjd7SZjOkJkZv/Eu4kU+S
	 BC2UFVhMu9aoXdQeyx8etMdljW7rIeGopkry93cs0rIZL1AWDUe/wiWTOyjqoPZbny
	 +Ccbq54CF5gcgoq1HA+vXvVPSy6wZt+jMMH8bSpA2am0pRI2ilEdPjDdmIfk7y00k6
	 CR/cMzP+9QVhA==
Date: Thu, 5 Dec 2024 09:19:09 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Shiju Jose
 <shiju.jose@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>, Ani Sinha
 <anisinha@redhat.com>, Dongjiu Geng <gengdongjiu1@gmail.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org
Subject: Re: [PATCH v5 10/16] acpi/ghes: better name GHES memory error
 function
Message-ID: <20241205091909.66f803c5@foz.lan>
In-Reply-To: <20241204174025.52e3756a@imammedo.users.ipa.redhat.com>
References: <cover.1733297707.git.mchehab+huawei@kernel.org>
	<1f16080ef9848dacb207ffdbb2716b1c928d8fad.1733297707.git.mchehab+huawei@kernel.org>
	<20241204174025.52e3756a@imammedo.users.ipa.redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Wed, 4 Dec 2024 17:40:25 +0100
Igor Mammedov <imammedo@redhat.com> escreveu:

> On Wed,  4 Dec 2024 08:41:18 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> 
> > The current function used to generate GHES data is specific for
> > memory errors. Give a better name for it, as we now have a generic
> > function as well.
> > 
> > Reviewed-by: Igor Mammedov <imammedo@redhat.com>
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>  
> 
> not that it matters but for FYI
> Sign off of author goes 1st and then after it other tags
> that were added later

Yes, that's what I usually do, when I'm using my developer's hat. 
Placing reviews before SoB is what I do with my maintainer's hat
at the Kernel :-)

I'll address it for the next (and hopefully final) version.

> 
> > ---
> >  hw/acpi/ghes-stub.c    | 2 +-
> >  hw/acpi/ghes.c         | 2 +-
> >  include/hw/acpi/ghes.h | 4 ++--
> >  target/arm/kvm.c       | 2 +-
> >  4 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
> > index 2b64cbd2819a..7cec1812dad9 100644
> > --- a/hw/acpi/ghes-stub.c
> > +++ b/hw/acpi/ghes-stub.c
> > @@ -11,7 +11,7 @@
> >  #include "qemu/osdep.h"
> >  #include "hw/acpi/ghes.h"
> >  
> > -int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
> > +int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
> >  {
> >      return -1;
> >  }
> > diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> > index 4b5332f8c667..414a4a1ee00e 100644
> > --- a/hw/acpi/ghes.c
> > +++ b/hw/acpi/ghes.c
> > @@ -415,7 +415,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
> >      return;
> >  }
> >  
> > -int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
> > +int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
> >  {
> >      /* Memory Error Section Type */
> >      const uint8_t guid[] =
> > diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> > index 8859346af51a..21666a4bcc8b 100644
> > --- a/include/hw/acpi/ghes.h
> > +++ b/include/hw/acpi/ghes.h
> > @@ -74,15 +74,15 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
> >                       const char *oem_id, const char *oem_table_id);
> >  void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
> >                            GArray *hardware_errors);
> > +int acpi_ghes_memory_errors(uint16_t source_id, uint64_t error_physical_addr);
> >  void ghes_record_cper_errors(const void *cper, size_t len,
> >                               uint16_t source_id, Error **errp);
> > -int acpi_ghes_record_errors(uint16_t source_id, uint64_t error_physical_addr);
> >  
> >  /**
> >   * acpi_ghes_present: Report whether ACPI GHES table is present
> >   *
> >   * Returns: true if the system has an ACPI GHES table and it is
> > - * safe to call acpi_ghes_record_errors() to record a memory error.
> > + * safe to call acpi_ghes_memory_errors() to record a memory error.
> >   */
> >  bool acpi_ghes_present(void);
> >  #endif
> > diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> > index 7b6812c0de2e..b4260467f8b9 100644
> > --- a/target/arm/kvm.c
> > +++ b/target/arm/kvm.c
> > @@ -2387,7 +2387,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> >               */
> >              if (code == BUS_MCEERR_AR) {
> >                  kvm_cpu_synchronize_state(c);
> > -                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
> > +                if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
> >                      kvm_inject_arm_sea(c);
> >                  } else {
> >                      error_report("failed to record the error");  
> 



Thanks,
Mauro

