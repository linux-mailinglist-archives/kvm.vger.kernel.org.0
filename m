Return-Path: <kvm+bounces-44073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 221D6A9A264
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9839177208
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4901DE4DB;
	Thu, 24 Apr 2025 06:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F9P5pmnx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC62C1ABED9
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 06:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745476605; cv=none; b=LiyqMdx4aQgsecGUN8fQfEf+f4esG1X3m8Ap67ZdgOqq3iXnoHpW4gDLzfSlO7Kw5No6+CfEC02HPL9wlkrCkoAqLHGIPQ+NdECHyoh8dZL3soBD+SwzOUTVbQLE5T3pQHGLREuFUGwP1Vnlke4x/DGFhf8WIKQR6NXednMcynU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745476605; c=relaxed/simple;
	bh=N/1BTUctU2lb6VBk1Oib3IvM00J9hBOuNikf/9LtMQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmDpCHp667+yhRKIZ3uFLa18LVr7pNNQqkoQ6jS1iBmW4ud7kDsxBtepQeFFZ/0QFeTCOiLUNGZ0Rj36oNwtMIHLkSZ16AjhMfq5CYAY8gB9eza0cOb9p1awu+3/7WBsTVxZRYbi/y9MID8N62NLpKLfTlE6CLgGrgPwAXBjk04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F9P5pmnx; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745476604; x=1777012604;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N/1BTUctU2lb6VBk1Oib3IvM00J9hBOuNikf/9LtMQ4=;
  b=F9P5pmnx1GH7xB6tzAEbK6Qqwqs64moY8t4ANVFO4Fn+HhTfMPvVmolO
   ao/ncN/d4/Ic88HU5li/cH+i6fTik/obAi8IPZUQh3YpCUfRb5EDcJuCX
   48J9JdzqTV0gsJy7ZjSidcu+3cmtqyFaZhXLXY3EevXw4AX/lhDDxmEcX
   cD+UjRJgsnZC5jUB2z4fMnavVNSujtdIc/8fTNDwX6qXDpfhXngwYWeWg
   gpVxqDl/+7G7wua5cJJPyspOvXfeNy+TUoByQaKC3V1/hlRAdYqyN54oT
   FSDDO86Rph0k0Y4jAtVZ0jDNQWYEp6uOgtgon21Ff4D8WT7TdISdgSge5
   Q==;
X-CSE-ConnectionGUID: NXSbaLHaQJu3yLUI/Lpssg==
X-CSE-MsgGUID: S2JmzYgLSfKdjAgNQfupMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="46977818"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="46977818"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 23:36:42 -0700
X-CSE-ConnectionGUID: XojoAA55T+emk4kqIX2xaA==
X-CSE-MsgGUID: ZM7pO4HHRjeXITCKypZmig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="155756304"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 23 Apr 2025 23:36:38 -0700
Date: Thu, 24 Apr 2025 14:57:33 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Tejus GK <tejus.gk@nutanix.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model &
 topo CPUID enhencement
Message-ID: <aAng3b6hSiZw9MzP@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423114702.1529340-1-zhao1.liu@intel.com>

On Wed, Apr 23, 2025 at 07:46:52PM +0800, Zhao Liu wrote:
> Date: Wed, 23 Apr 2025 19:46:52 +0800
> From: Zhao Liu <zhao1.liu@intel.com>
> Subject: [RFC 00/10] i386/cpu: Cache CPUID fixup, Intel cache model & topo
>  CPUID enhencement
> X-Mailer: git-send-email 2.34.1
> 
> Hi all,
> 
> (Since patches 1 and 2 involve changes to x86 vendors other than Intel,
> I have also cc'd friends from AMD and Zhaoxin.)
> 
> These are the ones I was going to clean up a long time ago:
>  * Fixup CPUID 0x80000005 & 0x80000006 for Intel (and Zhaoxin now).
>  * Add cache model for Intel CPUs.
>  * Enable 0x1f CPUID leaf for specific Intel CPUs, which already have
>    this leaf on host by default.
> 
> Overall, the enhancements to the Intel CPU models are still based on
> feedback received over time, for a long time...
> 
> I'll introduce my changes one by one in the order of importance as I
> see it. (The doc update is missing in this version.)
> 
> 
> Intel Cache Model
> =================
> 
> AMD has supports cache model for a long time. And this feature strats
> from the Eduardo's idea [1].
> 
> Unfortunately, Intel does not support this, and I have received some
> feedback (from Tejus on mail list [2] and kvm forum, and from Jason).

I need to add more background:

the legacy "host-cache-info" is becoming failing... On SRF, we have
observed that it cannot accurately identify cache topology, so we have
to use "smp-cache" to set the cache topology.

However, once "host-cache-info" is disabled, we lose the cache info
that matches the real silicon... Therefore, we can only add the cache
model for the named CPU model.


