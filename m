Return-Path: <kvm+bounces-34666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0872BA038E1
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 08:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CC973A52EB
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 07:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218C91DF74B;
	Tue,  7 Jan 2025 07:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i886OKPJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4916156F3F;
	Tue,  7 Jan 2025 07:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736235472; cv=none; b=huysIAB7eilpqGdJElvy8qvMctWl4C8H58ED4qxcI7ULIDH8vHMR4tN+wkzXQV3t/wQGZn1FdGWCbLQhaGy+Zga1kJCC14oAlqN0i3RfSeuWKOizH+v+13EBt2x2ii2wRxv8yNR5l6ZW52jgU5FLyARCcCSrWBRnvB0dCunNIH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736235472; c=relaxed/simple;
	bh=HjQsySUcszR7HV1gOOITqX5K1W41N9rl/ECUMbZS1bY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFAANVUVsbmlgm97jUG/ESliyM9WkIwSxn0xziSoOKXEwz2Tu6RlnJPlWFQGSwLrqShGl0dnagmlAqx4GQlFYG8a5No5oQ1TezCI2UiuBqiU2xd18DRolkEEIeAN+qetJjocIWMxVFImUE808TU5TgbxLB57MA76Q7zmGAUwj8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i886OKPJ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736235469; x=1767771469;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HjQsySUcszR7HV1gOOITqX5K1W41N9rl/ECUMbZS1bY=;
  b=i886OKPJ22MAxZiCPDxirLPtEImPgWh1RNlr1QvQfcbVHqwwq6eDxVie
   UDCNB70PPRibt0495Wi+4zRFEdG2A3xvQBpBksEQyV6Go5Wx1PQPhGnG4
   mXFLfOBVO1DxNEeZ6Cv0d2j5+97W82IstIUKyig71sFYZZ/LDbVgLHwSX
   J1JzRdud/Q8jVxPbWBZp+CyYzB4o/le0V6ZemBmM8mKNMLpMxXJzEuqS4
   Ov1v04aNK+qblUmWS83GAKWHUBJNeXWNjxNgHu3YfZZXF6fL77Cn3u0de
   jfCayKdLHg3h3jXuCQdn2CUixgPCxydRCKxmxoZpe9yGjHG5/prt7FQEq
   Q==;
X-CSE-ConnectionGUID: kR64YJOEQIK9SWe41PnT1Q==
X-CSE-MsgGUID: USxoDhy9SMarAihRsRSe8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="39225458"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="39225458"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 23:37:48 -0800
X-CSE-ConnectionGUID: TlawrERQTHa8nWx0ztdNug==
X-CSE-MsgGUID: XE6TkIHrTZyyahk69xl/rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="107656040"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO localhost) ([10.245.246.67])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 23:37:44 -0800
Date: Tue, 7 Jan 2025 09:37:39 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Message-ID: <Z3zZw2jYII2uhoFx@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
 <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>

On Sat, Jan 04, 2025 at 01:43:56AM +0000, Edgecombe, Rick P wrote:
> On Mon, 2024-12-23 at 17:25 +0100, Paolo Bonzini wrote:
> > 22: missing review comment from v1
> > 
> > > +     /* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> > > +     if (!vcpu->arch.apic)
> > > +             return -EINVAL;
> > 
> > nit: Use kvm_apic_present()
> 
> Oops, nice catch.

Sorry this fell through. I made a patch for this earlier but missed it
while rebasing to a later dev branch and never sent it.

Below is a rebased version against the current KVM CoCo queue to fold
in if still needed. Sounds like this might be already dealt with in
Paolo's upcoming CoCo queue branch though.

Regards,

Tony

8< --------------------
From aac264e9923c15522baf9ae765b1d58165c24523 Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony.lindgren@linux.intel.com>
Date: Mon, 2 Sep 2024 13:52:20 +0300
Subject: [PATCH 1/1] KVM/TDX: Use kvm_apic_present() in tdx_vcpu_create()

Use kvm_apic_present() in tdx_vcpu_create(). We need to now export
apic_hw_disabled for kvm-intel to use it.

Suggested-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
 arch/x86/kvm/lapic.c   | 2 ++
 arch/x86/kvm/vmx/tdx.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fcf3a8907196..2b83092eace2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -139,6 +139,8 @@ __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
 
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
+EXPORT_SYMBOL_GPL(apic_hw_disabled);
+
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
 
 static inline int apic_enabled(struct kvm_lapic *apic)
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d0dc3200fa37..6c68567d964d 100644
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
+	if (!kvm_apic_present(vcpu))
 		return -EINVAL;
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
-- 
2.47.1


