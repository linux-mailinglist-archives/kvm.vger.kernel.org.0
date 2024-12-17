Return-Path: <kvm+bounces-33939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 440009F4C2F
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:29:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6936416F5F2
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 13:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504DC1F4716;
	Tue, 17 Dec 2024 13:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YBMHLin0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AFE1F1917
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 13:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734441191; cv=none; b=UtTek0M59Vyd7NzKHBfVdzBx7C+No1j9vX9NrMi7ig/rZCzeZ1tC+zxAeLWGxh3jUnrQxSLmYdlifnr5PqWP2RLeyE4BDBZArZYBbwlQcmwM0XtbA2ylx3r/BFgMSyeEObj8a45h+7Fx9+K1E8JCGNGWUfvbr/3ut22xO2VqckU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734441191; c=relaxed/simple;
	bh=l/tSsKwm1ajCw0tcf2ezdFuLqMXsca6a9KbydnDlM4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h3Pg8OpTTmRyWv3QgzV63uhQYoB0bEsmnQIzkQNFQI8VC+oQe+R9WmnNGf4HjFKnqxPLM8NgkYHbu1CmPUuVRI6bRLD7SdWExe+WqjBp1PakaaI4aYsWzmfiUPzg0CORjvosDxtCGc75CcDluAJbG84uXsLizQ9gWyzaDYlUvsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YBMHLin0; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734441189; x=1765977189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=l/tSsKwm1ajCw0tcf2ezdFuLqMXsca6a9KbydnDlM4c=;
  b=YBMHLin0Pk+UO0eUABS3bq/HmB0M4XqPZDkqolqSByvUNcbH/L0T4HFX
   GXVrUab34UzTS3DNKa4awMk9G7PLyYWpKXU0uuJGndis0XjqM/bK0RpbW
   FQ4LUZrtKNOYXGwOL1xg7eAIeB3ugdydEzJHqCdF+fQ8NmbrmeSuFKFY+
   gniKipJ5KXzXjSE0wHFfRjo8nh6pGskhANGg/Rx9QMolvcA65SCt0w7Q/
   kL3Y9rs+km4c9i0h8upfsWQXyp+zHK+Kk2xzX/6xGrXUqt0o+6aMNHKfN
   e+5yYb5/K//BE/XtX9maOnsEyVSASjojetXPuTA6m+Cs1VG4315UqAs8c
   g==;
X-CSE-ConnectionGUID: kubtQvI8QGikLDvDLC/7fw==
X-CSE-MsgGUID: rzAhjnHAT+622hSEfqC7jQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="45352923"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="45352923"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 05:10:37 -0800
X-CSE-ConnectionGUID: glnTXi45RiaU01TPwBjpew==
X-CSE-MsgGUID: RNq2sGcITpqbtNjk+X0dhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,241,1728975600"; 
   d="scan'208";a="98100974"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO localhost) ([10.245.246.36])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 05:10:29 -0800
Date: Tue, 17 Dec 2024 15:10:23 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"riku.voipio@iki.fi" <riku.voipio@iki.fi>,
	"imammedo@redhat.com" <imammedo@redhat.com>,
	"Liu, Zhao1" <zhao1.liu@intel.com>,
	"marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
	"anisinha@redhat.com" <anisinha@redhat.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"armbru@redhat.com" <armbru@redhat.com>,
	"philmd@linaro.org" <philmd@linaro.org>,
	"cohuck@redhat.com" <cohuck@redhat.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"eblake@redhat.com" <eblake@redhat.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"wangyanan55@huawei.com" <wangyanan55@huawei.com>,
	"berrange@redhat.com" <berrange@redhat.com>
Subject: Re: [PATCH v6 09/60] i386/tdx: Initialize TDX before creating TD
 vcpus
Message-ID: <Z2F3mBlIqbf9h4QM@tlindgre-MOBL1>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-10-xiaoyao.li@intel.com>
 <1235bac6ffe7be6662839adb2630c1a97d1cc4c5.camel@intel.com>
 <c0ef6c19-756e-43f3-8342-66b032238265@intel.com>
 <Zyr7FA10pmLhZBxL@tlindgre-MOBL1>
 <Z1scMzIdT2cI4F5T@iweiny-mobl>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z1scMzIdT2cI4F5T@iweiny-mobl>

On Thu, Dec 12, 2024 at 11:24:03AM -0600, Ira Weiny wrote:
> On Wed, Nov 06, 2024 at 07:13:56AM +0200, Tony Lindgren wrote:
> > On Wed, Nov 06, 2024 at 10:01:04AM +0800, Xiaoyao Li wrote:
> > > On 11/6/2024 4:51 AM, Edgecombe, Rick P wrote:
> > > > +Tony
> > > > 
> > > > On Tue, 2024-11-05 at 01:23 -0500, Xiaoyao Li wrote:
> > > > > +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
> > > > > +{
> > > > > +    X86CPU *x86cpu = X86_CPU(cpu);
> > > > > +    CPUX86State *env = &x86cpu->env;
> > > > > +    g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
> > > > > +    int r = 0;
> > > > > +
> > > > > +    QEMU_LOCK_GUARD(&tdx_guest->lock);
> > > > > +    if (tdx_guest->initialized) {
> > > > > +        return r;
> > > > > +    }
> > > > > +
> > > > > +    init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
> > > > > +                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
> > > > > +
> > > > > +    r = setup_td_xfam(x86cpu, errp);
> > > > > +    if (r) {
> > > > > +        return r;
> > > > > +    }
> > > > > +
> > > > > +    init_vm->cpuid.nent = kvm_x86_build_cpuid(env, init_vm->cpuid.entries, 0);
> > > > > +    tdx_filter_cpuid(&init_vm->cpuid);
> > > > > +
> > > > > +    init_vm->attributes = tdx_guest->attributes;
> > > > > +    init_vm->xfam = tdx_guest->xfam;
> > > > > +
> > > > > +    do {
> > > > > +        r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
> > > > > +    } while (r == -EAGAIN);
> > > > 
> > > > KVM_TDX_INIT_VM can also return EBUSY. This should check for it, or KVM should
> > > > standardize on one for both conditions. In KVM, both cases handle
> > > > TDX_RND_NO_ENTROPY, but one tries to save some of the initialization for the
> > > > next attempt. I don't know why userspace would need to differentiate between the
> > > > two cases though, which makes me think we should just change the KVM side.
> > > 
> > > I remember I tested retrying on the two cases and no surprise showed.
> > > 
> > > I agree to change KVM side to return -EAGAIN for the two cases.
> > 
> > OK yeah let's patch KVM for it.
> 
> Will the patch to KVM converge such that it is ok for qemu to loop forever?

Hmm I don't think we should loop forever anywhere, the retries needed should
be only a few. Or what do you have in mind?

Regards,

Tony

