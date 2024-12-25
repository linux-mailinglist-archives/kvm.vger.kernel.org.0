Return-Path: <kvm+bounces-34374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD929FC37A
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 04:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BA577A111A
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2024 03:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 687F152F88;
	Wed, 25 Dec 2024 03:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J+Eb1syB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59742F56
	for <kvm@vger.kernel.org>; Wed, 25 Dec 2024 03:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735097398; cv=none; b=U2tC/aLvwTJi7z3tnMSWRs8V7HNZJMIUMP5XiOeQmW6dx9oT1DjQ1DMfMVgvx7wGGvjz/SaWz5kDJ4rglJ+4XKu4cCJkwGMiEEXYWQofLFM1F/hnFomHiNM/BUyrtS1vBZNxHHUsxZ+7LLq45dtrE3cU79c5JnrY3p/WtqF0WH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735097398; c=relaxed/simple;
	bh=6KRt73S8jyUxIj99alg4jIGUdSNAt1sqLCp/xyskvtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kREv146y7DPGykYg+RBSiJVqyrQrmT6E9wdHslVOlN07g5crhKRl3Jd8qQX3bbmsXgxzme8fbkYr6H7LgqsZeWSz4EvDW/6tohhtunYth1VoCUIorvS8n9gyyqlnN3b4dCLRIrhFxMwLCIBP49w8rCcUDv7S1NksjX4PE4s5I7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J+Eb1syB; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735097397; x=1766633397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6KRt73S8jyUxIj99alg4jIGUdSNAt1sqLCp/xyskvtI=;
  b=J+Eb1syB3f3Sab17Rlwjo1xKauFiAcIMyv0EhyqfU2SAEpPNlrEnFfun
   Gqh72f7wxg91uDZASjKwNdXztxX/8rOcu8DuQJZA01XqrWY0/8ryqwa2g
   ylmEqpT+n04I48YOF1H0Iqpu8jHttAAW9LrvM+RWI3ttw0SoRUNDFewgf
   n0+uusdBZQua14IXYVxqvYequY/Yym5chMn88eg0BbLinls040TjL88P4
   HAe+WKc1Qj5NRJiUBTI+DXN4Gd5IwpU46xd3SzcsekALZzlyaauz2zN0S
   +uaUqE09mMqSK1ZrDRpJx6XNU4G29xKqV2dIh/pU8DDEsnUG16FBSRr/K
   g==;
X-CSE-ConnectionGUID: EHnphlidT6+RMO/F+3zD2w==
X-CSE-MsgGUID: y1+A8Y/DRi2ZaxUC8OB1kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11296"; a="34831962"
X-IronPort-AV: E=Sophos;i="6.12,262,1728975600"; 
   d="scan'208";a="34831962"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2024 19:29:56 -0800
X-CSE-ConnectionGUID: qpRstatgSFupSRXCMiNDug==
X-CSE-MsgGUID: 3kiwq8OCSB+FFsUsg79H2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104623068"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 24 Dec 2024 19:29:53 -0800
Date: Wed, 25 Dec 2024 11:48:35 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v5 04/11] target/i386/kvm: Only save/load kvmclock MSRs
 when kvmclock enabled
Message-ID: <Z2uAk84u4JYON5tW@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-5-zhao1.liu@intel.com>
 <9d60933c-4713-4d61-b11f-64d4bb667e04@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d60933c-4713-4d61-b11f-64d4bb667e04@redhat.com>

On Tue, Dec 24, 2024 at 04:31:28PM +0100, Paolo Bonzini wrote:
> Date: Tue, 24 Dec 2024 16:31:28 +0100
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: Re: [PATCH v5 04/11] target/i386/kvm: Only save/load kvmclock MSRs
>  when kvmclock enabled
> 
> On 11/6/24 04:07, Zhao Liu wrote:
> > MSR_KVM_SYSTEM_TIME and MSR_KVM_WALL_CLOCK are attached with the (old)
> > kvmclock feature (KVM_FEATURE_CLOCKSOURCE).
> > 
> > So, just save/load them only when kvmclock (KVM_FEATURE_CLOCKSOURCE) is
> > enabled.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > 
> 
> The MSRs contains the same values as the "new" pair; QEMU only has to
> save/restore one of them but the code should be active for both feature bits
> and thus use
> 
> +        if (env->env.features[FEAT_KVM] & (CPUID_KVM_CLOCK |
> +                                           CPUID_KVM_CLOCK2)) {
> 

This is the correct way, thanks.

Regards,
Zhao



