Return-Path: <kvm+bounces-60751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82250BF9298
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41BEA481739
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01EC32BEC23;
	Tue, 21 Oct 2025 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oz9DC/VV"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE1299A8C
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 22:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761087387; cv=none; b=Vn+n5/t+N0swFwhzUnWQ5fKHL5uEeXRnc0r34d/YW9HpPKwR0jn6+Dz6HmHnnC1+pzRWt5hIUFlb6vCjaurQbYphArkinNEcWc8fi1cT/cnubyuI0LILf70prClZ7oVigEEOkwpx6UvVnsNKnxfourAjw0oky0bbFIOrIjJAUbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761087387; c=relaxed/simple;
	bh=V4NkGznR2T3JDSWLjVwJZnSY0RygDlkJEpy+1BcVOcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfgS0vUfVZaJ+UsDnrG7Z7ekwqyuJbd4j1E/du3IJFcBcwjNoh197dLNKAb0jbwlhGQVl5BGG3Jd57nKPeObQlXM/i1mD/ibv52TSJbViKnrZMARmM81hg7GwW01o2apT09TD6C94kVDiZ4a4tsX9c4J+2C+VVqnAoSsCCVL6yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oz9DC/VV; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 21 Oct 2025 22:56:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761087372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NpRYlL+s+eEOejHoASihIL1oHT0zJD6g2o7SauG22IE=;
	b=oz9DC/VV3MtrfOCesocIxygeMEGMSmJ+eFUdPd0IojRwOa6Nn9/TeiTREaDHgRZ7b8Lnfw
	d9qvXN4phTu3fbIynOrV/lHEMn3XtMx+NM9/TfTyT2MOJb8vFCBuPBUmGp6WO1Yx9SqBmF
	hA/okaduGDC5wtBfwut5SHzWY0Dd7+I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Kai Huang <kai.huang@intel.com>, Eric Auger <eric.auger@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: selftests: Add VM_MODE_PXXV57_4K VM mode
Message-ID: <ffph6d2gjnw3mboy5tm2ulkyhyq7zz5y66zrtdcuutqba75oh5@b7kktjtve2fs>
References: <20250917215031.2567566-1-jmattson@google.com>
 <20250917215031.2567566-4-jmattson@google.com>
 <l7txoioo3gntu3lyl542jg3n3wvkqruf2qh33xy7lmr5mjgfq5@iw4wsfdurlc7>
 <CALMp9eSPgy7RdT9TwKkRD5oh6-74XfCCP_UZ1mJWj6Nb9P4P7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eSPgy7RdT9TwKkRD5oh6-74XfCCP_UZ1mJWj6Nb9P4P7w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 21, 2025 at 03:34:22PM -0700, Jim Mattson wrote:
> On Wed, Oct 15, 2025 at 2:23 PM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> >
> > On Wed, Sep 17, 2025 at 02:48:39PM -0700, Jim Mattson wrote:
> > > Add a new VM mode, VM_MODE_PXXV57_4K, to support tests that require
> > > 5-level paging on x86. This mode sets up a 57-bit virtual address
> > > space and sets CR4.LA57 in the guest.
> > >
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > ---
> > >  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
> > >  tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++
> > >  .../testing/selftests/kvm/lib/x86/processor.c | 23 ++++++++++++-------
> > >  tools/testing/selftests/kvm/lib/x86/vmx.c     |  7 +++---
> > >  4 files changed, 41 insertions(+), 11 deletions(-)
> > >
> > > ...
> > > diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > index d4d1208dd023..1b6d4a007798 100644
> > > --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > @@ -401,11 +401,12 @@ void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> > >       struct eptPageTableEntry *pt = vmx->eptp_hva, *pte;
> > >       uint16_t index;
> > >
> > > -     TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
> > > -                 "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
> > > +     TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K ||
> > > +                 vm->mode == VM_MODE_PXXV57_4K,
> > > +                 "Unknown or unsupported guest mode: 0x%x", vm->mode);
> > >
> > >       TEST_ASSERT((nested_paddr >> 48) == 0,
> > > -                 "Nested physical address 0x%lx requires 5-level paging",
> > > +                 "Nested physical address 0x%lx is > 48-bits and requires 5-level EPT",
> >
> > Shouldn't this assertion be updated now? We technically support 5-level
> > EPT so it should only fire if the mode is VM_MODE_PXXV48_4K. Maybe we
> > should use vm->va_bits?
> 
> I did update the assertion! :)
> 
> init_vmcs_control_fields() hardcodes a page-walk-length of 4 in the
> EPTP, and the loop in __nested_pg_map() counts down from
> PG_LEVEL_512G. There is no support for 5-level EPT here.

__nested_pg_map() will be gone with the series [1] moving nested
mappings to use __virt_pg_map(), and with your series the latter does
support 5-level EPTs. init_vmcs_control_fields() still hardcodes a
page-walk-length of 4 tho.

I actually just realized, my series will already drop these assertions
and rely on the ones in __virt_pg_map(), which do use vm->page_shift, so
the assertion won't fire if init_vmcs_control_fields() starts using
5-level EPTs.

TL;DR nothing to do here.

[1]https://lore.kernel.org/kvm/20251021074736.1324328-1-yosry.ahmed@linux.dev/

> 
> >
> > >                   nested_paddr);
> > >       TEST_ASSERT((nested_paddr % page_size) == 0,
> > >                   "Nested physical address not on page boundary,\n"
> > > --
> > > 2.51.0.470.ga7dc726c21-goog
> > >
> >

