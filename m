Return-Path: <kvm+bounces-25670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2F1D9684B3
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 12:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F5DE281400
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 10:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85151422BD;
	Mon,  2 Sep 2024 10:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WFVNqGDm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B83D53E15;
	Mon,  2 Sep 2024 10:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725273101; cv=none; b=n2xTfyXVCFxQUwYnc9ifiJlV57gAuFhm3xwr6qHPrXg4LCj+INsWj+0BvW3GOL2tq9ogz7aGx2069Vj8pFa9p3EKOJOip7zCrWZLGJOwe0gWjgWGSUFgG3GNSvDToHi4FinjoHu5G4Kvqttv3BlTlUb2UEckvVKzjyVWE7S4pOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725273101; c=relaxed/simple;
	bh=r9xXHU6kp7B8Y4fDffwOQIWFSjsqzEw90KZxhqEjb/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeetAiGf9KsWED8milVOi7qUJAb3a4ugmYf85cDQuIyuPmfnOl561RQ+Gxu5DGkud02NjWo7A3unAps1dqOvYC/Q5DUunxSmVEfupHCSBVGHvCcSK8WY3u0X6n6yjjzRab3bC8ZqYsRVpQeCAHORpBZD4GzBxsIgDjM087aUC08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WFVNqGDm; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725273099; x=1756809099;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r9xXHU6kp7B8Y4fDffwOQIWFSjsqzEw90KZxhqEjb/4=;
  b=WFVNqGDm1gcnw+R4U0New+ARgwpKusiGpvNnDODvrI76lMbzBnPOP1H3
   5jAz5f1qX69kXpGXrZy5I3qIbTmXrm1GbcILYyVIRne+SYp05TY6zXMqu
   a9mCklwbtDV2vZpHFB3K4h163qWiStONi/ZNI6kpi91jxJ1A94BoTJXH0
   nobEt30+ksvyCLy8GXQKYmD4nko8oF7Vz0Vpv+2gGXmtNHSy3OV3cXaT5
   IhDzikRd2RopEYlrVywbTL+dJ+mhVR9kcwVJhcF62Y7HUfdVU/EMjuNmS
   3x1LfCF0cIgg1zpstzMNBgFZrhD0BU+qxgYXxSdXNDDYxoh9lo8n6VeYS
   A==;
X-CSE-ConnectionGUID: n5K0c7mhT2S2y8/QM0HwDA==
X-CSE-MsgGUID: FrniisdeSFy26SsRCdUbSg==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="35005342"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="35005342"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:31:38 -0700
X-CSE-ConnectionGUID: e7yJ1H3CSxeSzV5a+Ilxbg==
X-CSE-MsgGUID: HT9qwmxNQD2/GRDH5GY9Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="87807274"
Received: from lbogdanm-mobl3.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.223])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:31:34 -0700
Date: Mon, 2 Sep 2024 13:31:29 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <ZtWUATuc5wim02rN@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
 <ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com>

On Thu, Aug 29, 2024 at 02:27:56PM +0800, Yan Zhao wrote:
> On Mon, Aug 12, 2024 at 03:48:09PM -0700, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> ...
> > +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> > +{
...

> > +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> > +	kvm_tdx->attributes = td_params->attributes;
> > +	kvm_tdx->xfam = td_params->xfam;
> > +
> > +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
> > +	else
> > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
> > +
> Could we introduce a initialized field in struct kvm_tdx and set it true
> here? e.g
> +       kvm_tdx->initialized = true;
> 
> Then reject vCPU creation in tdx_vcpu_create() before KVM_TDX_INIT_VM is
> executed successfully? e.g.
> 
> @@ -584,6 +589,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>         struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>         struct vcpu_tdx *tdx = to_tdx(vcpu);
> 
> +       if (!kvm_tdx->initialized)
> +               return -EIO;
> +
>         /* TDX only supports x2APIC, which requires an in-kernel local APIC. */
>         if (!vcpu->arch.apic)
>                 return -EINVAL;
> 
> Allowing vCPU creation only after TD is initialized can prevent unexpected
> userspace access to uninitialized TD primitives.

Makes sense to check for initialized TD before allowing other calls. Maybe
the check is needed in other places too in additoin to the tdx_vcpu_create().

How about just a function to check for one or more of the already existing
initialized struct kvm_tdx values?

Regards,

Tony

