Return-Path: <kvm+bounces-13491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9906897850
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 20:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A6901F24ED3
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 18:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0AFD153BEB;
	Wed,  3 Apr 2024 18:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WyNGf1J0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A05DDBE;
	Wed,  3 Apr 2024 18:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712169277; cv=none; b=IIdcFeBplFDpgcRxzkRqbzK5O7CcYjefBgt/59XDgArzvGuwKCo+fz1TedHi0RUE9LGvTqMFliMliDW8sbjwOIxvPl5R4SSIKDAvvXwCB2azNMJGFA5JWme6dld+qgPfHEmOfbI+LI9/hrzJnvCwXAhMgwOF/4Lh2bOio1bfQrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712169277; c=relaxed/simple;
	bh=tUu+PzesiWg5M8wz+DmngwjAFVy6Jz0rQ0YvK8Qn7p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwFuaPRirojOVkF8CpoMtPMurs4PTMfjk2Cm66NjHypoIVlfWsgxrx/55E/M7NopulV7U/a+Q4v/QfnCftXrXCUdMK0fBzfUl/pnSWJOSHhv22CdlWMYFbjDG8/Q3QHxTbvNE7XJvjajsWGAE1yetTZcBBwBZv3ZuPd3FvMLJwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WyNGf1J0; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712169274; x=1743705274;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tUu+PzesiWg5M8wz+DmngwjAFVy6Jz0rQ0YvK8Qn7p4=;
  b=WyNGf1J0Z16Md3y/f75uHQPPqIYS3kTxWjBLjMdqK9lp1IIXOrD4V6y8
   agMIPUZfkrYKwWn75Oot4K0i0WHBhMIrUozK0gjg8OBXpmu1/m2z/SCGJ
   LXfbFCwA65jO+KK6YB6zr+Hf7EYi7AEdAJ/z3JxyMjdTk36GCJXg05/RQ
   MjfVJI1NeU7rBNOnb5AAEObBqglxG9qOeSm+9OvTNT6VVquSvJSR6KZUw
   4gGvJ5Ruad8tUL8h0yVx74qiR8isrXkNuoZ668vNPOVcveHtqYTBHVyiN
   8H1MNxJT9Gix2PeIo+sTkJFtlIne+hS6HwOOMnXPkm1EVuRE7Btcj1VMa
   g==;
X-CSE-ConnectionGUID: H4Wh3NtBQL6zEfqCLzTOtA==
X-CSE-MsgGUID: cO9lYeNMTkKK7aYyu8pfTg==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7610579"
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="7610579"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 11:34:21 -0700
X-CSE-ConnectionGUID: DRhErx83QeaXAYWFT52Q6A==
X-CSE-MsgGUID: 8DjnPZYtQqymkub4D4qL2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="18373627"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 11:34:21 -0700
Date: Wed, 3 Apr 2024 11:34:20 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 097/130] KVM: x86: Split core of hypercall emulation
 to helper function
Message-ID: <20240403183420.GI2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d6547bd0c1eccdfb4a4908e330cc56ad39535f5e.1708933498.git.isaku.yamahata@intel.com>
 <ZgY0hy6Io72yZ9dF@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgY0hy6Io72yZ9dF@chao-email>

On Fri, Mar 29, 2024 at 11:24:55AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Mon, Feb 26, 2024 at 12:26:39AM -0800, isaku.yamahata@intel.com wrote:
> >@@ -10162,18 +10151,49 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > 
> > 		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
> > 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
> >+		/* stat is incremented on completion. */
> 
> Perhaps we could use a distinct return value to signal that the request is redirected
> to userspace. This way, more cases can be supported, e.g., accesses to MTRR
> MSRs, requests to service TDs, etc. And then ...

The convention here is the one for exit_handler vcpu_enter_guest() already uses.
If we introduce something like KVM_VCPU_CONTINUE=1, KVM_VCPU_EXIT_TO_USER=0, it
will touch many places.  So if we will (I'm not sure it's worthwhile), the
cleanup should be done as independently.


> > 		return 0;
> > 	}
> > 	default:
> > 		ret = -KVM_ENOSYS;
> > 		break;
> > 	}
> >+
> > out:
> >+	++vcpu->stat.hypercalls;
> >+	return ret;
> >+}
> >+EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
> >+
> >+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >+{
> >+	unsigned long nr, a0, a1, a2, a3, ret;
> >+	int op_64_bit;
> >+	int cpl;
> >+
> >+	if (kvm_xen_hypercall_enabled(vcpu->kvm))
> >+		return kvm_xen_hypercall(vcpu);
> >+
> >+	if (kvm_hv_hypercall_enabled(vcpu))
> >+		return kvm_hv_hypercall(vcpu);
> >+
> >+	nr = kvm_rax_read(vcpu);
> >+	a0 = kvm_rbx_read(vcpu);
> >+	a1 = kvm_rcx_read(vcpu);
> >+	a2 = kvm_rdx_read(vcpu);
> >+	a3 = kvm_rsi_read(vcpu);
> >+	op_64_bit = is_64_bit_hypercall(vcpu);
> >+	cpl = static_call(kvm_x86_get_cpl)(vcpu);
> >+
> >+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> >+	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> >+		/* MAP_GPA tosses the request to the user space. */
> 
> no need to check what the request is. Just checking the return value will suffice.

This is needed to avoid updating rax etc.  KVM_HC_MAP_GPA_RANGE is only an
exception to go to the user space.  This check is a bit weird, but I couldn't
find a good way.

> 
> >+		return 0;
> >+
> > 	if (!op_64_bit)
> > 		ret = (u32)ret;
> > 	kvm_rax_write(vcpu, ret);
> > 
> >-	++vcpu->stat.hypercalls;
> > 	return kvm_skip_emulated_instruction(vcpu);
> > }
> > EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
> >-- 
> >2.25.1
> >
> >
> 
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

