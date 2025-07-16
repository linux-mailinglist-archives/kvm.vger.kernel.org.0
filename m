Return-Path: <kvm+bounces-52561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA00CB06CB2
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 06:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E59A17FCE2
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 04:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF7E0245038;
	Wed, 16 Jul 2025 04:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nSNVgDzG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849CC2E3715
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 04:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752640342; cv=none; b=I8ntdQU+qNRjRkCvio7HDR82RDw6xSFoU5/M7iBeV78rNmQvMusucBvV/IbGN8cAH/ull5T2k+Bl6R1y48WQ8C355i4O+y5GHI7O0Y9IsjcWVUncOin56BoDACD190U0E4b8h9oP3epLRrOhUP1XNdSfZirHbfAWSbGcN1V131Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752640342; c=relaxed/simple;
	bh=2BVHKwrhsznPCq6xBQHl8kRyuU+BRCR0BonggEcp9Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXZf9L8jYN1NZ9lThAYqZfGU8HLRqrpjYiykM5eIw7/1YX8LXcBuv1v1fNCLRBff+/g1ZC7bHmuZUMgMHPOLB+5PLrYgjRYXZcdPIxsgVnE7SdR0aN/uevmeu1Jv9Yn//rGN6lUw2haoMrvEmcBEsQo6kvgoXAVdTkM3bJA+ibA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nSNVgDzG; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752640340; x=1784176340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2BVHKwrhsznPCq6xBQHl8kRyuU+BRCR0BonggEcp9Bc=;
  b=nSNVgDzGrdoVP4WdQlP6gl/50VnfJsK1ocFuPcjK67EkzJn42tlZp9GO
   m5aCE9FZqvI5gTmpHCjQutmFmK0dpm5iVUHmyyKPibV70pI4NNqLyUJCj
   JpgeK+cEXlNUKRUBG96hdv5yP7xJo2IzxVDMVPbSmjwn241dLrOeqjasT
   NOKHGaaxBdcAlg8l4XalwHzniDFbhZdTYgy0GOpcDynD86ItH3g0LFz2C
   izy3Tv7Ms/K9kbb5EJX0xUljFXjj1uArwd0tL41a5MpcIXNvl1iEsLggi
   p7ZBE9EWDfJ4QVGPPkAPQJt1VsyH5LDAceeZMWn2ijOfY4aKukKU5m3sM
   Q==;
X-CSE-ConnectionGUID: OEzEGq9iSFKQhBRV72asmw==
X-CSE-MsgGUID: qIXFfWW+QPOiVdD9pI7+Sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="65135354"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="65135354"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 21:32:19 -0700
X-CSE-ConnectionGUID: jRuyK731SRyhxPAAVVnFXg==
X-CSE-MsgGUID: FyP64Jc6RXevcIRGl1RIUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="157059959"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 15 Jul 2025 21:32:18 -0700
Date: Wed, 16 Jul 2025 12:53:48 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, bp@alien8.de, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] target/i386: Add TSA attack variants TSA-SQ and
 TSA-L1
Message-ID: <aHcwXBFy90lBjcfF@intel.com>
References: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>

On Thu, Jul 10, 2025 at 02:46:10PM -0500, Babu Moger wrote:
> Date: Thu, 10 Jul 2025 14:46:10 -0500
> From: Babu Moger <babu.moger@amd.com>
> Subject: [PATCH v2 1/2] target/i386: Add TSA attack variants TSA-SQ and
>  TSA-L1
> X-Mailer: git-send-email 2.34.1
> 
> Transient Scheduler Attacks (TSA) are new speculative side channel attacks
> related to the execution timing of instructions under specific
> microarchitectural conditions. In some cases, an attacker may be able to
> use this timing information to infer data from other contexts, resulting in
> information leakage.
> 
> AMD has identified two sub-variants two variants of TSA.
> CPUID Fn8000_0021 ECX[1] (TSA_SQ_NO).
> 	If this bit is 1, the CPU is not vulnerable to TSA-SQ.
> 
> CPUID Fn8000_0021 ECX[2] (TSA_L1_NO).
> 	If this bit is 1, the CPU is not vulnerable to TSA-L1.
> 
> Add the new feature word FEAT_8000_0021_ECX and corresponding bits to
> detect TSA variants.
> 
> Link: https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technical-guidance-for-mitigating-transient-scheduler-attacks.pdf
> Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> v2: Split the patches into two.
>     Not adding the feature bit in CPU model now. Users can add the feature
>     bits by using the option "-cpu EPYC-Genoa,+tsa-sq-no,+tsa-l1-no".
> 
> v1: https://lore.kernel.org/qemu-devel/20250709104956.GAaG5JVO-74EF96hHO@fat_crate.local/
> ---
>  target/i386/cpu.c | 17 +++++++++++++++++
>  target/i386/cpu.h |  6 ++++++
>  2 files changed, 23 insertions(+)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


