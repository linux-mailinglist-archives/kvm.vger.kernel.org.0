Return-Path: <kvm+bounces-5129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B15B181C6B1
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 09:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAAF71C21EB8
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 08:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AD9DF59;
	Fri, 22 Dec 2023 08:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Grec/3T0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225A3DDA3
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 08:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703234109; x=1734770109;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LoIAA0CvLDyDd2zMRzU7xGB8nmg2Wi0fDASQta4ZIUM=;
  b=Grec/3T0OJW2w4ihOeaat/A655ZrUJlAwRlo4p6GhJtYkHqwu0Q2uR0w
   JKKW4LeK2WkHrXQkNIBEGQBboprYx4R5gG3r7HZQ1aNKYceiyfbaOxEwP
   m7e5oqYVeeX2OtPyMHMLAVkDDQ3AQ/5Qx+KEFMnBGMaxk/KMy5+YQSPRx
   WcnSRtVUtIUZ7n9/H6trzA5fYFyKry5CeKgg6R0sGRV3tGy2jUswBSeX3
   6uKfehltL2D330fKzk5dFHUAG9QgW9DF0IcNTGXg20fbH1ne3lP8Ny+r1
   mmSuDzG18R1yZuG647sp5xbnjsIdqBLx7IU3gWtMb4qwJSADPOo6p5EF5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10931"; a="393255159"
X-IronPort-AV: E=Sophos;i="6.04,294,1695711600"; 
   d="scan'208";a="393255159"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2023 00:35:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10931"; a="753202490"
X-IronPort-AV: E=Sophos;i="6.04,294,1695711600"; 
   d="scan'208";a="753202490"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga006.jf.intel.com with ESMTP; 22 Dec 2023 00:35:00 -0800
Date: Fri, 22 Dec 2023 16:47:46 +0800
From: "Liu, Zhao1" <zhao1.liu@intel.com>
To: "Li, Xin3" <xin3.li@intel.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"eduardo@habkost.net" <eduardo@habkost.net>,
	"seanjc@google.com" <seanjc@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Yang, Weijiang" <weijiang.yang@intel.com>,
	"Wu, Dan1" <dan1.wu@intel.com>
Subject: Re: [PATCH v3A 1/6] target/i386: add support for FRED in CPUID
 enumeration
Message-ID: <ZYVNMh4UvogvuRwt@intel.com>
References: <MW4PR11MB6737DC0CCD50B5D3D00521A7A895A@MW4PR11MB6737.namprd11.prod.outlook.com>
 <20231222030336.38096-1-xin3.li@intel.com>
 <ZYU76ipTvj1WIBgm@intel.com>
 <ZYVFrBvu39X7E1Yf@intel.com>
 <MW4PR11MB6737937A73F2E0D2752F0835A894A@MW4PR11MB6737.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB6737937A73F2E0D2752F0835A894A@MW4PR11MB6737.namprd11.prod.outlook.com>

On Fri, Dec 22, 2023 at 08:24:52AM +0000, Li, Xin3 wrote:
> Date: Fri, 22 Dec 2023 08:24:52 +0000
> From: "Li, Xin3" <xin3.li@intel.com>
> Subject: RE: [PATCH v3A 1/6] target/i386: add support for FRED in CPUID
>  enumeration
> 
> 
> > > >              NULL, NULL, NULL, NULL, @@ -1552,6 +1552,14 @@ static
> > > > FeatureDep feature_dependencies[] = {
> > > >          .from = { FEAT_VMX_SECONDARY_CTLS,
> > VMX_SECONDARY_EXEC_ENABLE_USER_WAIT_PAUSE },
> > > >          .to = { FEAT_7_0_ECX,               CPUID_7_0_ECX_WAITPKG },
> > > >      },
> > > > +    {
> > > > +        .from = { FEAT_7_1_EAX,             CPUID_7_1_EAX_LKGS },
> > > > +        .to = { FEAT_7_1_EAX,               CPUID_7_1_EAX_FRED },
> > > > +    },
> > > > +    {
> > > > +        .from = { FEAT_7_1_EAX,             CPUID_7_1_EAX_WRMSRNS },
> > > > +        .to = { FEAT_7_1_EAX,               CPUID_7_1_EAX_FRED },
> > > > +    },
> > 
> > Oh, sorry, one thing that comes to mind, is this dependency required?
> > Since the FRED spec (v3.0) is all about WRMSR as the example, without
> > mentioning WRMSRNS, could there be other implementations that depend on
> > WRMSR instead of WRMSRNS?
> 
> This is a community ask from tglx:
> https://lkml.kernel.org/kvm/87y1h81ht4.ffs@tglx/
> 
> Boris had the same question:
> https://lore.kernel.org/lkml/20231114050201.GAZVL%2FSd%2FyLIdON9la@fat_crate.local/
> 
> But it needs to go through a formal approach, which takes time, to reach
> the FRED public spec.
> 

Thanks Xin! You can add a simple note in the commit message, such as
FRED's dependency on WRMSRNS will be documented, to avoid confusion
for later reviewers interested in FRED.

Regards,
Zhao


