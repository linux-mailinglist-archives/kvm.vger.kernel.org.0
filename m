Return-Path: <kvm+bounces-29083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 612829A255D
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92DA11C23150
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 14:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1801DE4D0;
	Thu, 17 Oct 2024 14:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XwsUerIX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE54D1D461B
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729176319; cv=none; b=ScMcZA+1drOU3wMUeT5DBLy1wLaeGO+hx+8X9VGs3r3NvGKs2tt/41DpUriyPbju2QemmyJbx5Iflsx3rq24K+/GKoMDi+VwpvYJJJLgEQJH/+NG0JkLN3w+BFFpVNseaFkIEmpOwDepGLRCciHC7CFt7zrm+mXgYBnyij+eODc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729176319; c=relaxed/simple;
	bh=zV481lRGbVV63j3CCjzbuapW1g8a4oHW28WTjDZBWng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=larYVUGj5DeTGCB7ywn9v3aIVQ3t9kFI4Sz9XYJv9b451KdSE8hFu7RLxZmufulaLFHexzYl7oE4Go7cdhlFSUiblKieXB6B812C/Bwhgs94J8ZZS9+Sc57oakE+KS2N27VL5YchDYBW9O2BzUNJ6RvUNdlIxBpmj9DWUIuz8XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XwsUerIX; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729176318; x=1760712318;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zV481lRGbVV63j3CCjzbuapW1g8a4oHW28WTjDZBWng=;
  b=XwsUerIXjtBb2paa/YYHEaFu/26hlLwBDE7T7sOu1BxgZziEwjQu08t2
   BoKVN6C62QTuId0E+CdYeKg81IoCjZlP0hjn9FLWx5n7GkSQx3T3loRDe
   1u1muKxQm03nR9wV/RMPnl9QHcMwFekbttFZVmctJY3+Cu6ds2RHspEIL
   f5t6bRTxLABx97/OVtiLGcF3+Vo4h/otwSVzbJqSqIzV+aSu1OYf6Tv5m
   1ouaR9ffRumuy5BVE6cmMygfoxD1niKA4eWMHlV5KFS968NBdFeNm/xvS
   GFF9APCzUk1yrA/KCO9+v1u7hKkr4XqEJ2L/Ee3rj+crr10AAJHhSCq3h
   w==;
X-CSE-ConnectionGUID: VrwPfX28TZqU5eMtts7fIg==
X-CSE-MsgGUID: 2dGTPNLdTgqSMDi94BSA9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11228"; a="31531315"
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="31531315"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 07:45:17 -0700
X-CSE-ConnectionGUID: S7JYt02wSee58G72esSEdQ==
X-CSE-MsgGUID: rTmYgiaESOSOiAQtFw6EsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,211,1725346800"; 
   d="scan'208";a="78708432"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 17 Oct 2024 07:45:11 -0700
Date: Thu, 17 Oct 2024 23:01:26 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?us-ascii?B?PT9JU08tODg1OS0xP1E/TWE/PSA9P0lTTy04ODU5LTE/UT90?=
	=?us-ascii?Q?hieu-Daud=3DE9=3F=3D?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S.Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?us-ascii?B?PT9JU08tODg1OS0xP1E/QmVubj1FOWU/PQ==?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v3 0/7] Introduce SMP Cache Topology
Message-ID: <ZxEmxkwQythD6ILI@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241017141402.0000135b@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017141402.0000135b@Huawei.com>

(Cc and gentlely ping QOM & QAPI maintainers :) )

> > Meanwhile, ARM side has also worked a lot on the smp-cache based on
> > this series [2], so I think we are very close to the final merge, to
> > catch up with this cycle. :)
> 
> This would finally solve a long standing missing control for our
> virtualization usecases (TCG and MPAM stuff is an added bonus),
> so I'm very keen in this making 9.2 (and maybe even the ARM part
> of things happen to move fast enough). Ali is out this week,
> but should be back sometime next week. Looks like rebase of his
> ARM patches on this should be simple!
> 
> I think this set mostly needs a QAPI review (perhaps from Markus?)

Michael mentioned this series also need QOM maintainer's review. So I
pinged maintainers at the beginning of this reply.

> > 
> > This series is based on the commit 7e3b6d8063f2 ("Merge tag 'crypto-
> > fixes-pull-request' of https://gitlab.com/berrange/qemu into staging").
> > 
> > Background
> > ==========
> > 
> > The x86 and ARM (RISCV) need to allow user to configure cache properties
> *laughs*. I definitely going to start emailing ARM folk with
> ARM (RISCV)  
> :)  

:) I remembered you discussing cache topology with Sia (from RISCV).

Thanks,
Zhao



