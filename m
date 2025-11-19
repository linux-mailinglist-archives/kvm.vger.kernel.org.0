Return-Path: <kvm+bounces-63682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E4DBCC6D0B0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 08:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 825484ECF4E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD16A31813A;
	Wed, 19 Nov 2025 07:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dCOozeIM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506992C235E
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 07:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763536362; cv=none; b=infWgyccYThwFcDhSyoTfT6XY5JK1PKBXoGc8wFBhePnfT18u8e54M11S85fbx3acH9/bDaAw6DktFeccpIkYUnd28PiaxWODuRRp2oXssmUAXQcNlzPZ+9vU4TVkYtwGOli68Xv8Av3gbO9MSDZk6on50yBenVTOc7boHB1D4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763536362; c=relaxed/simple;
	bh=ByplCGQG329EMQifwPghkySu4IjurQY8RGCXOJxk/q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=El54GmoTMclilT11FiBtuJ0EGvw1+H2VtF7S9I212diQJOiG3ivha8A5Jjw6BSrUrjOe3LHmeGiGuEwkZh+KUeWqtAtGzeZh89+2jhM1ME6jEGfJXfyVxCT/P+Z/a0/0w4KyEWw6v2DrXoA5SPUtx0OzjzCAp2RVbA4mlJ8C8hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dCOozeIM; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763536360; x=1795072360;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ByplCGQG329EMQifwPghkySu4IjurQY8RGCXOJxk/q4=;
  b=dCOozeIMhBTloO9UqVm2YUMSC0IpS6t2TpfjPB8IV5daPFM80mzBLsZl
   umWiVym2aGyKhvidcpPit5Bc2gfmAfkgz7IOgfchaI4TdZ0fwsj+ZIvw2
   qlP/cvbo6lWhqEZk8Um/MUcmKQI6Eqz6SEBZXLYI3Br0PI6xvZAKYjttx
   LsePaXQeDQ8I1NsMTT53I7FFeG3TZzToOSqFhusM7Ij4jO4adpsArEQIF
   0DgjgJ57ACBuMM0w4kAq/Xxm1xJOziCbkbLmvdzE6aIv0wujDn1ZuYgD1
   +L1ble8NSEhub60D7pMZq0TPL2Mpue+SI8PJ5zhwFvvDZtyHmTGE5p3Qg
   A==;
X-CSE-ConnectionGUID: M7BVxi+PTc2YZFXSbnqsEQ==
X-CSE-MsgGUID: vHJTOmmdRPqP9kYFcIDtRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65502601"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="65502601"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 23:12:40 -0800
X-CSE-ConnectionGUID: bfOL8vzqRFefP0/JbJ0C1Q==
X-CSE-MsgGUID: eE6YlQUhT3eJEjiMvKEBmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="196108309"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 18 Nov 2025 23:12:38 -0800
Date: Wed, 19 Nov 2025 15:34:57 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>, Xudong Hao <xudong.hao@intel.com>,
	Peter Fang <peter.fang@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH 4/5] i386/cpu: Support APX CPUIDs
Message-ID: <aR1zIb4GHh9FrK31@intel.com>
References: <20251118065817.835017-1-zhao1.liu@intel.com>
 <20251118065817.835017-5-zhao1.liu@intel.com>
 <CABgObfZfGrx3TvT7iR=JGDvMcLzkEDndj7jb5ZVV3G3rK54Feg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfZfGrx3TvT7iR=JGDvMcLzkEDndj7jb5ZVV3G3rK54Feg@mail.gmail.com>

> Please just make the new leaf have constant values based on just
> APX_F. We'll add the optional NCI/NDD/NF support if needed, i.e.
> never. :)

Maybe not never?

> > Note, APX_NCI_NDD_NF is documented as always enabled for Intel
> > processors since APX spec (revision v7.0). Now any Intel processor
> > that enumerates support for APX_F (CPUID.(EAX=0x7, ECX=1).EDX[21])
> > will also enumerate support for APX_NCI_NDD_NF.

This sentence (from APX spec rev.7) emphasizes the ¡°Intel¡± vendor,
and its primary goal was to address and explain compatibility concern
for pre-enabling work based on APX spec v6. Prior to v7, APX included
NCI_NDD_NF by default, but this feature has now been separated from
basic APX and requires explicit checking CPUID bit.

x86 ecosystem advisory group has aligned on APX so it may be possible
for other x86 vendors to implement APX without NCI_NDD_NF and this still
match with the APX spec.

If we default to setting this NCI_NDD_NF bit for APX, then in the future
when we run into other vendors that don't support this feature, we'll not
only have to make it optional again, but we'll also need to do fixes
similar to the ARCH_CAPABILITIES situation - checking vendors, fixing
compatibility issues, and all that stuff.

Therefore, compared to default setting to constant, I think the optional
NCI_NDD_NF now not only aligns with arch spec but also prevents future
compatibility issues. :)

Thanks,
Zhao


