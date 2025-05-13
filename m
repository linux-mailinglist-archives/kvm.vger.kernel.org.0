Return-Path: <kvm+bounces-46277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3349AB48D1
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 03:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E122E3A43C4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 01:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B156318A959;
	Tue, 13 May 2025 01:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vsk033Sv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A7C28366;
	Tue, 13 May 2025 01:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747099569; cv=none; b=Rewajh0MAj4hIBpFzUuPpYpKvBIhdv1fXnpbozUchHmX+iUdbZD2H5X90BNs5RBSb61ShurH2jPwK8xff4paNcMhK8fJJfXoF2iz27timsd5VWDFbDj5Hd+auy0pz5x3MAAORg6ftbU1AeJRiQyn3rN+mGutLsUKUUFcdjJaN7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747099569; c=relaxed/simple;
	bh=eKcHTXzvmztc5eqDmcOxsw9eHj/ztfSsGBQlW2xyDzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NFhcW+uV/jSQyncd4kbucUcMxGJiNSWDruIsbM7EJJfLDfVLHZkrwQFYMDzy0XfDvoCBes7nbIWbhKq8cPVAsQHXGPCXOht5YpXKr05dLrMxEURimTrpF454OLZQdUM5jQP8U/2thnnQm6DhkxkPpk1tstxyp+dZlsg6TNlMs3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vsk033Sv; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747099569; x=1778635569;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eKcHTXzvmztc5eqDmcOxsw9eHj/ztfSsGBQlW2xyDzc=;
  b=Vsk033SvFnb/nKfojtweB9T1Dvgxslm5wHO7WNg/cb03DrghwTPLkIJs
   sq+F6wTgyvJV2k1hRAUoLOPFRmKXq6Xds+lSzKiitmvSiGjxZBStg+XB6
   T1WGCtuj8Wsg+QmoTAFjchamPL10CkKYlJ29ZsfSgLUUB3LY1JpwRM6DO
   TNfDBfpwdvWTDGlWc31rom8UI9gNcjwRmWQYpH30zweJD/hoLonL36bO6
   UkUymaOQkwNkM36QfDohsncqIiomIgDK015nE462vtG+Aogcd+4d6Pac+
   p9qLwCbWCzkgirXm2yw8QVKxhpuYQMqsjVfp2z0QAsDfFLi8LNyeKQB6Q
   w==;
X-CSE-ConnectionGUID: PPNyX98uT7+KAXgsrgI11Q==
X-CSE-MsgGUID: J0280pdHTyu31BksoliiDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48616481"
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="48616481"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 18:26:08 -0700
X-CSE-ConnectionGUID: bfgqR1ARS+2WDHsEy8DMKA==
X-CSE-MsgGUID: +aLSIoJlQZCKT73aFX3u6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="141586322"
Received: from unknown (HELO [10.238.1.183]) ([10.238.1.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 18:26:03 -0700
Message-ID: <71228787-1cbc-4287-87a3-cda9aabcca3f@linux.intel.com>
Date: Tue, 13 May 2025 09:25:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] KVM: Bound the number of dirty ring entries in a
 single reset at INT_MAX
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
References: <20250508141012.1411952-1-seanjc@google.com>
 <20250508141012.1411952-2-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250508141012.1411952-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/8/2025 10:10 PM, Sean Christopherson wrote:
> Cap the number of ring entries that are reset in a single ioctl to INT_MAX
> to ensure userspace isn't confused by a wrap into negative space, and so
> that, in a truly pathological scenario, KVM doesn't miss a TLB flush due
> to the count wrapping to zero.  While the size of the ring is fixed at
> 0x10000 entries and KVM (currently) supports at most 4096, userspace is
> allowed to harvest entries from the ring while the reset is in-progress,
> i.e. it's possible for the ring to always have harvested entries.
>
> Opportunistically return an actual error code from the helper so that a
> future fix to handle pending signals can gracefully return -EINTR.
>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   include/linux/kvm_dirty_ring.h |  8 +++++---
>   virt/kvm/dirty_ring.c          | 10 +++++-----
>   virt/kvm/kvm_main.c            |  9 ++++++---
>   3 files changed, 16 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> index da4d9b5f58f1..ee61ff6c3fe4 100644
> --- a/include/linux/kvm_dirty_ring.h
> +++ b/include/linux/kvm_dirty_ring.h
> @@ -49,9 +49,10 @@ static inline int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *r
>   }
>   
>   static inline int kvm_dirty_ring_reset(struct kvm *kvm,
> -				       struct kvm_dirty_ring *ring)
> +				       struct kvm_dirty_ring *ring,
> +				       int *nr_entries_reset)
>   {
> -	return 0;
> +	return -ENOENT;
>   }
>   
>   static inline void kvm_dirty_ring_push(struct kvm_vcpu *vcpu,
> @@ -82,7 +83,8 @@ int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring,
>    * called with kvm->slots_lock held, returns the number of
>    * processed pages.
>    */
The comment should be updated as well, since the return value is not the
number of processed pages now.


> -int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
> +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> +			 int *nr_entries_reset);
>   
[...]

