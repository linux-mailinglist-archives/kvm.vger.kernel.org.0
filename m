Return-Path: <kvm+bounces-58823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8EB3BA16D2
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 22:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6815716DA2E
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 20:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8965632128C;
	Thu, 25 Sep 2025 20:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cKGZrxvG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BEB30AAC2;
	Thu, 25 Sep 2025 20:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758833384; cv=none; b=Wy3lFtuypr58REkoKontDGdrQXLI5TER5yhygcgol0zwGPzJc8iazKHkCM2Cg9hk71S9LtX31IFjAZ06gog4a5AJ63cqFGxf24f4Ms6F5A4ZRnE6rs8G5yVdiP6Ea2viKNHB6HPHXUBifJ/KDhAJTqy0Mg/tmUYT6KPBhnGy4U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758833384; c=relaxed/simple;
	bh=OnyU4Q1L9SCacqmHd+rQ6xczomV/+OJHDrsu/rkrpT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qnw4YFIy8G9y0WRsKMCCax9zcCo42Ffg+vW87QFk3Ucop5KECg8R1o2/M3GLiUCXHt1dGw4zdBcAcx7d4Hw9P97ofrq2UBRUwWVKaVQ1LWG6mY81QA1/IJrslVKYbVRgxXo+aVYSIPRAlJSyzEPcFWiFCLYH8xtafCwKMjVsLvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cKGZrxvG; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758833383; x=1790369383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=OnyU4Q1L9SCacqmHd+rQ6xczomV/+OJHDrsu/rkrpT4=;
  b=cKGZrxvGof7sLw0wWE2mEnm+1NDnN90HvckReSAYzNbT4lr2nIZ5bGgt
   LdWd+m0gn4jWY7bJtdWfaBhdtEJctGGMgTZVmKqCiYtfp5a1KDng28Mfl
   KAlMKixGNjycjiJ3FVGWJHOWckQHcSrGc4QMkSW0VycyN4H8HRa00xB4H
   3oX7+rJO/yvwPp9+vNTyukUInXyU7vnA31FHLNxYnbKr+Y5Auajf3wwoq
   qNFBpmA2NbLNuWFPwJdJLT6MkiX4ZsvY5rZg03W2PlaloiMkYCgPNlKyx
   rrzMpvG/rAJW2UseLo/PdW4EcmWAHyYa3CHlWMB7wWk0pdv5MTxoODtwx
   Q==;
X-CSE-ConnectionGUID: R4M8ueDTSIaU5oydLhOISQ==
X-CSE-MsgGUID: QC9kLImWSyajtpiaZjEXLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="60203810"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="60203810"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:49:42 -0700
X-CSE-ConnectionGUID: nMFumgokSB2c79eYhB8pEw==
X-CSE-MsgGUID: Y/9woBjEQjupqoPSbBNX6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177052769"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.190])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:49:41 -0700
Date: Thu, 25 Sep 2025 13:49:37 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH 1/2] x86/bhi: Add BHB clearing for CPUs with larger
 branch history
Message-ID: <20250925204937.d4pabsyg3jxnw332@desk>
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
 <20250924-vmscape-bhb-v1-1-da51f0e1934d@linux.intel.com>
 <CALMp9eRcDZoRza7pkCx_fmYZ9UZDGRAXQ_0QP=v+pMMBKx4gfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eRcDZoRza7pkCx_fmYZ9UZDGRAXQ_0QP=v+pMMBKx4gfg@mail.gmail.com>

On Thu, Sep 25, 2025 at 10:54:48AM -0700, Jim Mattson wrote:
> On Wed, Sep 24, 2025 at 8:09 PM Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com> wrote:
> >
> > Add a version of clear_bhb_loop() that works on CPUs with larger branch
> > history table such as Alder Lake and newer. This could serve as a cheaper
> > alternative to IBPB mitigation for VMSCAPE.
> 
> Yay!
> 
> Can we also use this longer loop as a BHI mitigation on (virtual)
> processors with larger branch history tables that don't support
> BHI_DIS_S? Today, we just use the short BHB clearing loop and call it
> good.

I believe you are referring to guests that don't enumerate BHI_DIS_S, but
are running on a host that supports BHI_DIS_S. In that case the longer loop
would work to mitigate BHI.

You probably know it already, the longer loop is not an optimal mitigation
compared to BHI_DIS_S. And on CPUs that don't support BHI_DIS_S, short loop
is sufficient.

I think you are talking about some special use cases like a guest migrating
from a CPU that didn't support BHI_DIS_S to a CPU that does. Using the long
loop in that case would be an option.

