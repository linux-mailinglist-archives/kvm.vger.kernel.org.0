Return-Path: <kvm+bounces-44279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA03A9C31E
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 11:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 547AD16DD48
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5DC2343AE;
	Fri, 25 Apr 2025 09:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hFsn/Av5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE41F4612
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 09:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745572708; cv=none; b=ICIZYwSpUQvrJ25x6yKJymx+/sXLPNA1sz7ePhKWivtD6ih+VOI13RF2Qh5lpzE4AA1sY3fReMbNZHcnDCdM17FuzLXBzCTSZIe1lWWJbGk+2wI6Xzn/8I9/zYqomCHpEpKdrENpAS3xstVOCSjV+XkGQCWGbQ7Oe9sOtbMCmy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745572708; c=relaxed/simple;
	bh=q8s+GZ7wJiAkeM4rMouGv5MqAa2zRRibXViU1Z94qMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBvo/KGjQFLMb4X0UHGDaUOYEKfTYGIY7mzwZ0FbQ397I1AMrEbPDPoZODL4ZhDn8r3O0bqvB1xBS8CJ8S7E7fUVrJrfsVErX1XzQJUfoq4hrscnr0hRssDVrAFSNvDJhQj2KbDL++bOflT2ayl16IltrLIbNjdDmfDtFIngwRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hFsn/Av5; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745572706; x=1777108706;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=q8s+GZ7wJiAkeM4rMouGv5MqAa2zRRibXViU1Z94qMQ=;
  b=hFsn/Av54gbNkgjSAhr1a1YofgjqYqjgRq5lpY6St18Z4jBNfqBHuknu
   VfEv7v/Jf0m3ZZWofG50SzuZ1Ssw9jMIskgZBiM8z4Nmof2VkIg+S4jFy
   51+YhOziz5QSbvwImOkTf+tukug1AlFisZLm5+AuT7xHtqj8XicGkw4ye
   cgCp/VPhTA6f8gl6QRGeKyRAToUoEI+rGqegljGZqCbCQL2J35Dojsc7e
   sAV6wdMhDeYjohFFFx1Vcqq/oBq+Ju21fim4yTAOTjF1DoTp0NJOGLhbu
   6j67laenmLkOtDs3ZkKbQOJ1qjuWptO7nQUFdhgJ7J36RXMmf+Z1xuTnS
   Q==;
X-CSE-ConnectionGUID: fM0r2uSJRwWPxXUZ04fliQ==
X-CSE-MsgGUID: CJZutd5LTxO4mfDwsfMJzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="47401793"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="47401793"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 02:18:25 -0700
X-CSE-ConnectionGUID: lAFKN5hRQHWPCQL8vIwrpA==
X-CSE-MsgGUID: J/43f1rIQ6+gESFEmGkTow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="137693367"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 25 Apr 2025 02:18:22 -0700
Date: Fri, 25 Apr 2025 17:39:18 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Babu Moger <babu.moger@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
Message-ID: <aAtYRhLiHoiJ4S1p@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-2-zhao1.liu@intel.com>
 <c522ebb5-04d5-49c6-9ad8-d755b8998988@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c522ebb5-04d5-49c6-9ad8-d755b8998988@zhaoxin.com>

> On 4/23/25 7:46 PM, Zhao Liu wrote:
> > 
> > Per SDM, 0x80000005 leaf is reserved for Intel CPU, and its current
> > "assert" check blocks adding new cache model for non-AMD CPUs.
> > 
> > Therefore, check the vendor and encode this leaf as all-0 for Intel
> > CPU. And since Zhaoxin mostly follows Intel behavior, apply the vendor
> > check for Zhaoxin as well.
> 
> Thanks for taking Zhaoxin CPUs into account.
> 
> Zhaoxin follows AMD's definition for CPUID leaf 0x80000005, so this leaf is
> valid on our CPUs rather than reserved. We do, however, follow Intel's
> definition for leaf 0x80000006.

Thank you! I'll revert the change.

> > Note, for !vendor_cpuid_only case, non-AMD CPU would get the wrong
> > information, i.e., get AMD's cache model for Intel or Zhaoxin CPUs.
> > For this case, there is no need to tweak for non-AMD CPUs, because
> > vendor_cpuid_only has been turned on by default since PC machine v6.1.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > ---
> >   target/i386/cpu.c | 16 ++++++++++++++--
> >   1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 1b64ceaaba46..8fdafa8aedaf 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -7248,11 +7248,23 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >           *edx = env->cpuid_model[(index - 0x80000002) * 4 + 3];
> >           break;
> >       case 0x80000005:
> > -        /* cache info (L1 cache) */
> > -        if (cpu->cache_info_passthrough) {
> > +        /*
> > +         * cache info (L1 cache)
> > +         *
> > +         * For !vendor_cpuid_only case, non-AMD CPU would get the wrong
> > +         * information, i.e., get AMD's cache model. It doesn't matter,
> > +         * vendor_cpuid_only has been turned on by default since
> > +         * PC machine v6.1.
> > +         */
> > +        if (cpu->vendor_cpuid_only &&
> > +            (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
> 
> Given that, there is no need to add IS_ZHAOXIN_CPU(env) to the 0x80000005
> path. Note that the L1 TLB constants for the YongFeng core differ from the
> current values in target/i386/cpu.c(YongFeng defaults shown in brackets):
> 
> #define L1_DTLB_2M_ASSOC       1 (4)
> #define L1_DTLB_2M_ENTRIES   255 (32)
> #define L1_DTLB_4K_ASSOC       1 (6)
> #define L1_DTLB_4K_ENTRIES   255 (96)
> 
> #define L1_ITLB_2M_ASSOC       1 (4)
> #define L1_ITLB_2M_ENTRIES   255 (32)
> #define L1_ITLB_4K_ASSOC       1 (6)
> #define L1_ITLB_4K_ENTRIES   255 (96)
> 
> I am still reviewing how these constants flow through cpu_x86_cpuid() for
> leaf 0x80000005, so I'm not yet certain whether they are overridden.
> 
> For now, the patchset can ignore Zhaoxin in leaf 0x80000005. Once I have
> traced the code path, I will send an update if needed. Please include
> Zhaoxin in the handling for leaf 0x80000006.

Sure! And you can add more comment for the special cases.

If possible, could you please help check if there are any other cases :-)
without spec reference, it's easy to cause regression when refactor. As
per Xiaoyao's comment, we would like to further clean up the Intel/AMD
features by minimizing the ¡°incorrect¡± AMD features in Intel Guests
when vendor_cpuid_only (or another enhanced compat option) is turned on.

> I should have sent this after completing my review, but I did not want to
> delay your work. Sorry for the noise.

No problem. And your info really helps me. It will take me a little
while until the next version. It makes it easier to decouple our work
and review them separately in the community!

> Thanks again for your work.

You're welcome!


