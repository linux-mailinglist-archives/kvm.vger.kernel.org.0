Return-Path: <kvm+bounces-41065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79658A6137B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:18:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EB96178CD0
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD851200B9F;
	Fri, 14 Mar 2025 14:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z2Nc/II7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11941FDE0E;
	Fri, 14 Mar 2025 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741961883; cv=none; b=nDCtSi2frDyeXIttFNSYJ9e/F4/Vlpou4GPzwYfD3A0A7hBhey3q3TxG4DrdXv0m1IHQdEoS68Xeq05IVywwhf/uU4ZYQjD/Hi+bJYh1iFzNNQT0zmIbXxI+HJED50uOHGRbQU1Nr6DyzMoyHeCh7F8G5C7IZ1EhsFCUTR/Yb10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741961883; c=relaxed/simple;
	bh=SsvEq/YsvXN3Wc677Hy5Aoe9CP9mi6fqsBUTe8h/RzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcOcfUuXqaM7mxY2Q3KkAMUVK9u1Q+cUwyrRQK9oT+iUsc0IS0+zhvmWDB0r+uYm+vklRP3eiO0WxQyklsOxWxNim4iVa9j/1AU02j+oYivXLmpa70jKQF7eaZjhxMqD+quN18URXMUip46qidwSQDe2oD93oSzTMldjxWFaI9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z2Nc/II7; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741961881; x=1773497881;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SsvEq/YsvXN3Wc677Hy5Aoe9CP9mi6fqsBUTe8h/RzE=;
  b=Z2Nc/II7DDh8tqOJALOsJzT+PKcR+5H8UEdlSG5I0S0gZllieGqyw4Ws
   /pU7RqvdXT+XHtfC/NgeSO3koJmcn00TzbBlZ2CMJFWaQgetZykTSNJ7r
   xpfygtr0SZES24EJFM+vqs3l2I6A7b6FwnkDSy1Otmz3On4npb6JF6XtG
   y/A0YbOnfu8RH3BVea6GzCRb/JVlBCcgZdZboAtklsAUnfVP6nGoCDnoN
   FMyPxbh9bXjKe8h01S93DaYu0JsDov7xWamImK95pWb1C2h6CeIWSmDS9
   e0MyAviZEpVW8XnUYWBkqVxzLOwj1khBbs0YVn3gM0Nzq18C+zvIqF1fT
   Q==;
X-CSE-ConnectionGUID: zuhmgVQWQ6Gfa+o7xK7qjw==
X-CSE-MsgGUID: tHhjn+XmQdmN6VzTE4rlRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="65574404"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="65574404"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 07:18:00 -0700
X-CSE-ConnectionGUID: ifiKrKLrTvGrfL1SJD7L5g==
X-CSE-MsgGUID: vduzCV4jQk2Vhea+YU+RvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="122006738"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 07:18:00 -0700
Date: Thu, 13 Mar 2025 17:39:33 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>, chao.gao@intel.com,
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Nikunj A Dadhania <nikunj@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 2/2] KVM: x86: Don't allow tsc_offset, tsc_scaling_ratio
 to change
Message-ID: <Z9N6xWQV6e5Tufy4@ls.amr.corp.intel.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <3a7444aec08042fe205666864b6858910e86aa98.1728719037.git.isaku.yamahata@intel.com>
 <510e0391-410b-40be-b556-f91554b8d3a1@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510e0391-410b-40be-b556-f91554b8d3a1@redhat.com>

On Wed, Mar 12, 2025 at 01:24:32PM +0100,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 10/12/24 09:55, Isaku Yamahata wrote:
> > Add guest_tsc_protected member to struct kvm_arch_vcpu and prohibit
> > changing TSC offset/multiplier when guest_tsc_protected is true.
> 
> Thanks Isaku!  To match the behavior of the SEV-SNP patches, this is
> also needed, which I have added to kvm-coco-queue:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dc2f14a6d8a1..ccde7c2b2248 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3919,7 +3925,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_TSC:
>  		if (msr_info->host_initiated) {
>  			kvm_synchronize_tsc(vcpu, &data);
> -		} else {
> +		} else if (!vcpu->arch.guest_tsc_protected) {
>  			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
>  			adjust_tsc_offset_guest(vcpu, adj);
>  			vcpu->arch.ia32_tsc_adjust_msr += adj;

Thank you for catching this. This looks good.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

