Return-Path: <kvm+bounces-34871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E52B7A06E95
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 08:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7602D7A116E
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 07:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74E22036F4;
	Thu,  9 Jan 2025 07:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PMKdCn2V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E67C37160;
	Thu,  9 Jan 2025 07:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736406275; cv=none; b=o3RtoVElc3kPUrN4ErjJp1ZMruyqjr+kcsGogvScwiFjbh4hfwneUJWVhvhx4PRwaW9v6b8Yyu45lrTSD5zjRGENnhAHQavnL2V/HiAmVDkD/iiEUync5d9pDxi9gQvC5PtYp8jpXKdfwta7ldPol0gQnCkbgXwRhNr3gDx9cok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736406275; c=relaxed/simple;
	bh=HKSYTcRYhknUo25TNo0OahISsZXCy/+IkrcIX0iOc4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YWuQUSRTUdUzOmeKy0TQolN1nN5uVwHQUq09lYYBR5gG6/b4qxe2vayPe9aGzOcFW4nDNZ6atMGQJ9avBxaqlXbVIyz40l4GCM9d4ee+hl+sjWS8tMFkFuX06Nz5seahWaXSzUTrnWLq0Sozf53muQ3ne6/eMpMiuV6JZfdmAAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PMKdCn2V; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736406274; x=1767942274;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HKSYTcRYhknUo25TNo0OahISsZXCy/+IkrcIX0iOc4o=;
  b=PMKdCn2ViH48ZCOhSmoHAoR7j4Aq1SFsC1SICmrvm5600nS9ii8u7HCV
   EWLvmidIrFTcepoQeJLFq944TcDyGdF93tNnxJA/diwrR6vtP8zHwU4HA
   Wi+/h/9pbzaDIC1DSIISwJ1ImtJi3E3NbEeLh8TrXMlCilWgsQhb40Zv2
   J1Cfg2vB4IO1QmIRiiLqcTvC6Sq3CiCM4/1FWGR6MFZr3ks4dMV01fzhJ
   +Rw/yEUryg72eQxpCweGTkT9QwCI81KhHXdQ0VJo/7+Bo0JWlpCIB5kId
   II9IfKWKdO8gPjhJJ6zUmNuBNeQ/8aT8ljtg/aSsXTFekrl70EzCpDuBL
   g==;
X-CSE-ConnectionGUID: Vp0yz5uHSOOE9AIAkiUbaA==
X-CSE-MsgGUID: UTsnJ8cASrSgkAWjL/2MIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36535691"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="36535691"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 23:04:33 -0800
X-CSE-ConnectionGUID: GUJCCsf8SKKgx6F602cVgw==
X-CSE-MsgGUID: A5Y1HkxTTZGMaRoSjt/jvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="103291986"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO localhost) ([10.245.246.189])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 23:04:28 -0800
Date: Thu, 9 Jan 2025 09:04:22 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>,
	Rick P Edgecombe <rick.p.edgecombe@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Yan Y Zhao <yan.y.zhao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Message-ID: <Z3909uubxHn8mk0Q@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
 <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>
 <Z3zZw2jYII2uhoFx@tlindgre-MOBL1>
 <7f8d0beb-cc02-467d-ae2a-10e22571e5cf@suse.com>
 <Z34NGyZL7G_j716N@tlindgre-MOBL1>
 <Z36TLcX1kOe1ltjp@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z36TLcX1kOe1ltjp@google.com>

On Wed, Jan 08, 2025 at 07:01:01AM -0800, Sean Christopherson wrote:
> On Wed, Jan 08, 2025, Tony Lindgren wrote:
> > On Tue, Jan 07, 2025 at 02:41:51PM +0200, Nikolay Borisov wrote:
> > > On 7.01.25 г. 9:37 ч., Tony Lindgren wrote:
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -139,6 +139,8 @@ __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
> > > >   EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
> > > >   __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
> > > > +EXPORT_SYMBOL_GPL(apic_hw_disabled);
> > > 
> > > Is it really required to expose this symbol? apic_hw_disabled is defined as
> > > static inline in the header?
> 
> No, apic_hw_disabled can't be "static inline", because it's a variable, not a
> function.
> 
> > For loadable modules yes, otherwise we'll get:
> > 
> > ERROR: modpost: "apic_hw_disabled" [arch/x86/kvm/kvm-intel.ko] undefined!
> > 
> > This is similar to the EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu) already
> > there.
> 
> Heh, which is a hint that you're using the wrong helper.  TDX should check
> lapic_in_kernel(), not kvm_apic_present().  The former verifies that local APIC
> emulation/virtualization is handed in-kernel, i.e. by KVM.  The latter checks
> that the local APIC is in-kernel *and* that the vCPU's local APIC is hardware
> enabled, and checking that the local APIC is hardware enabled is unnecessary
> and only works by sheer dumb luck.

OK makes sense :)

> The only reason kvm_create_lapic() stuffs the enable bit is to avoid toggling
> the static key, which incurs costly IPIs to patch kernel text.  If
> apic_hw_disabled were to be removed (which is somewhat seriously being considered),
> this code would be deleted and TDX would break.
> 
> 	/*
> 	 * Stuff the APIC ENABLE bit in lieu of temporarily incrementing
> 	 * apic_hw_disabled; the full RESET value is set by kvm_lapic_reset().
> 	 */
> 	vcpu->arch.apic_base = MSR_IA32_APICBASE_ENABLE;

Thanks for the clarification. Updated patch below for reference in
case it's still needed.

Regards,

Tony

8< ----------------------
From 1e4b72fe4a69f0bdd7c8379315b97be79fb6cf8a Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony.lindgren@linux.intel.com>
Date: Mon, 2 Sep 2024 13:52:20 +0300
Subject: [PATCH 1/1] KVM/TDX: Use lapic_in_kernel() in tdx_vcpu_create()

Use lapic_in_kernel() in tdx_vcpu_create().

Suggested-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d0dc3200fa37..b905a7c9e2ff 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -8,6 +8,7 @@
 #include "capabilities.h"
 #include "mmu.h"
 #include "x86_ops.h"
+#include "lapic.h"
 #include "tdx.h"
 #include "vmx.h"
 #include "mmu/spte.h"
@@ -674,7 +675,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 		return -EIO;
 
 	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
-	if (!vcpu->arch.apic)
+	if (!lapic_in_kernel(vcpu))
 		return -EINVAL;
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
-- 
2.47.1


