Return-Path: <kvm+bounces-61490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DA4C21033
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5A22A4ED480
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 15:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FD83655FC;
	Thu, 30 Oct 2025 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HiO5kPSx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767B736449B
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761839117; cv=none; b=klw1+6Xw+lmFqmk4tneW6n9TxTs0EEaKYEBqHhvjOSbO8VijAPnH/1q3gHK74fRpBV8O5XfoK2h+sP0qDMpYAsJ+cu+2Me+XSf9/jIcK6XKqohBCqvhIMnypI8PzSC5DgOD2FFnte21jTPraULzFOBfoZLOGu1lXxBsBmIZiDc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761839117; c=relaxed/simple;
	bh=qS+02fCqSHr3tcnWuRZhV6jK2aqbd4ZTjkQZxDlSqeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vatxe3meoE/xseoOaM/WIClRBxUeWps1phdPBamhvUj49gcTOLACk+Jup36PpRZYSI6c/QBl8dcs2WImWMT4iSitidkVKf8noT4YH0vBPtkyR3l99LTqJ46vrbrhBasfOURIwVQHP3DdUgZIeWJX8pPrsu9pxX6G0mHXIW6dIPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HiO5kPSx; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761839116; x=1793375116;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qS+02fCqSHr3tcnWuRZhV6jK2aqbd4ZTjkQZxDlSqeE=;
  b=HiO5kPSxaUFTrJQyM8dWGcIB0dWes4H4idCGsPJn64MdLT5fEfArG/Ie
   DadpV9vZIxfwCt8p8UJ0MzX0hspJJPw2hlCtang20jK+9Rmp6WpexHqU8
   GTJmfpSMSthhoMULTCfbWDkGD8iZmnGbLRkn972Wpq2ogn/JzVaVf8+fF
   PY/uFvXb/qypH0INbdTfos7HO/o59MKwQf3MlzEHTz4NdFI4HyBvtJWdK
   zSAGd7rYJnltsXdr8xHzCVc4WQ4H8qp5CpUarqg7ozycJ+fdU1EG5/8KJ
   3ua4gboH+kD4KBVd0eJmBmyWx2k5tZIkZ4zJbe76MzK5qm/3BvAZWSh16
   Q==;
X-CSE-ConnectionGUID: P3fpFEUrT4OoRigb8tRshQ==
X-CSE-MsgGUID: cgzMhWakREOIdXoe7KuKlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="64017356"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="64017356"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 08:45:15 -0700
X-CSE-ConnectionGUID: FC40WmS4QyaVU3OXCmeoBA==
X-CSE-MsgGUID: 8ovOVZtJQuCi1zFIX0P/xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="209560818"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 30 Oct 2025 08:45:11 -0700
Date: Fri, 31 Oct 2025 00:07:23 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 20/20] i386/tdx: Add CET SHSTK/IBT into the supported
 CPUID by XFAM
Message-ID: <aQONOxHIu8IUtmiJ@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-21-zhao1.liu@intel.com>
 <ea4ff407-b5ee-4649-b5cd-82b626dca3ee@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea4ff407-b5ee-4649-b5cd-82b626dca3ee@intel.com>

On Tue, Oct 28, 2025 at 04:55:25PM +0800, Xiaoyao Li wrote:
> Date: Tue, 28 Oct 2025 16:55:25 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v3 20/20] i386/tdx: Add CET SHSTK/IBT into the
>  supported CPUID by XFAM
> 
> On 10/24/2025 2:56 PM, Zhao Liu wrote:
> > From: Chenyi Qiang <chenyi.qiang@intel.com>
> > 
> > So that it can be configured in TD guest.
> > 
> > And considerring cet-u and cet-s have the same dependencies, it's enough
> > to only list cet-u in tdx_xfam_deps[].
> 
> In fact, this is not the reason.
> 
> The reason is that CET_U and CET_S bits are always same in supported XFAM
> reported by TDX module, i.e., either 00 or 11. So, we only need to choose
> one of them.

Good words. Will update.

> > Tested-by: Farrah Chen <farrah.chen@intel.com>
> > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> With commit message updated,
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Thanks!

Regards,
Zhao


