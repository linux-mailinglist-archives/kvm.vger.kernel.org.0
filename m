Return-Path: <kvm+bounces-40162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E7CA501E6
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C594B174D72
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 14:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13AF524BCE8;
	Wed,  5 Mar 2025 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A97w7FBM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D59624A077
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 14:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741184794; cv=none; b=Tyj9uwywyfyyEcvhwWysdrlye9HWNNLjmQJKD7TTPsTqYvmb4FRNAcVgGou5jpuK04GxDABaOgR0dTT/5TUeERSfC+nDTab4w83kTrcwvTzQunrPZvifeuSCDhs6UHCDEj4LfqQx+c5E2fcyQsiw4pk+7t9B7jXXnYW5QiJTfyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741184794; c=relaxed/simple;
	bh=BVqqC4oAStGeOipkGPpjlWcVg3qYzVoBzqOa6HasjaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuephnJE8HK1ZbfqcATyRmZfje36kLoHm0PnZC0hQrr/hOQVvQDGSUYLawBYY8uKkbMxs2TPkPWURpdhIyCtG2DCJAG7yVrsTZZetrpJ46HDKjf/ngYehUavN68T5SlsDFmAxlgcW4r9tcR82Y1abxfbKHhgNw8WZLGirj5I8DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A97w7FBM; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741184792; x=1772720792;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BVqqC4oAStGeOipkGPpjlWcVg3qYzVoBzqOa6HasjaM=;
  b=A97w7FBM30dm8vJ+rzX4rhRUfp6OArPPo7tTEabfF8ZUQfynpeP9fSB/
   jn+16LFX0Re6QRNgpfDwlNkrhU0EY47lsJv76Cui93FWQjJ3MZXZukVgF
   P5mYfpAFfmNbFfZhOrz6TDTYkzH69w074IjLs/lmDiDu+rzKco+c8aAwk
   kL5M0GwcfsGoqaqbjKTjePnPXIxa48FiuZ/3Xy9BjhN7Faa3kkVY9/r3D
   rAyCa2WZz9zoWDdiTSMjn61huFjAQv6Runtpqvh//fQQpCCb9qYE+FsOW
   jE+z2nrxaYpXtQPY3g6AUUOfY53MQS2bZFKjr9OLPrmeLppPWGXkNMP1i
   A==;
X-CSE-ConnectionGUID: C3/dk5RlS5mJOdU5OZP74w==
X-CSE-MsgGUID: WtFL1++AS16M5xk0t9MJvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42277570"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="42277570"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 06:26:32 -0800
X-CSE-ConnectionGUID: hqljol+XQH62Na0I4uq5aw==
X-CSE-MsgGUID: IBDtrwGBQb27aA9PkdRS0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="119396142"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 05 Mar 2025 06:26:28 -0800
Date: Wed, 5 Mar 2025 22:46:35 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 03/10] [DO NOT MERGE] kvm: Introduce
 kvm_arch_pre_create_vcpu()
Message-ID: <Z8hjy/8OBTXEA1kp@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-4-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302220112.17653-4-dongli.zhang@oracle.com>

On Sun, Mar 02, 2025 at 02:00:11PM -0800, Dongli Zhang wrote:
> Date: Sun,  2 Mar 2025 14:00:11 -0800
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v2 03/10] [DO NOT MERGE] kvm: Introduce
>  kvm_arch_pre_create_vcpu()
> X-Mailer: git-send-email 2.43.5
> 
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
> work prior to create any vcpu. This is for i386 TDX because it needs
> call TDX_INIT_VM before creating any vcpu.
> 
> The specific implemnet of i386 will be added in the future patch.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>

Your Signed-off is missing...

(When you send the patch, it's better to attach your own Signed-off :-))

> ---
> I used to send a version:
> https://lore.kernel.org/all/20221119122901.2469-2-dongli.zhang@oracle.com/
> Just pick the one from Xiaoyao's patchset as Dapeng may use this version
> as well.
> https://lore.kernel.org/all/20250124132048.3229049-8-xiaoyao.li@intel.com/
> 
>  accel/kvm/kvm-all.c        | 5 +++++
>  include/system/kvm.h       | 1 +
>  target/arm/kvm.c           | 5 +++++
>  target/i386/kvm/kvm.c      | 5 +++++
>  target/loongarch/kvm/kvm.c | 5 +++++
>  target/mips/kvm.c          | 5 +++++
>  target/ppc/kvm.c           | 5 +++++
>  target/riscv/kvm/kvm-cpu.c | 5 +++++
>  target/s390x/kvm/kvm.c     | 5 +++++
>  9 files changed, 41 insertions(+)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


