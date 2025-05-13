Return-Path: <kvm+bounces-46312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67503AB4F08
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FD371B405D5
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD09214223;
	Tue, 13 May 2025 09:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eXAn8lg+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD4217FAC2;
	Tue, 13 May 2025 09:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747127885; cv=none; b=mwn52zcRfQycERCkRu0FMQC6xCt8W7x51gmbG2n36WJOBQvJa+LXxPASBnP8n1fcRvQ7ld/EzpMY16FbX3cKSmbVyTtw7Pwg8jSvew7XefLR8ay9FepRzXBrS5sJq6mBD8SswY26w749+0gwSQ1+ze4Ic5cWXxggDCMlc/ixPPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747127885; c=relaxed/simple;
	bh=OZJPGrjursZMHwmHj5u/k8EH2OvZh4oaVXSEFgcgksQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fwT6vsx8bJy5nH6YZSi/mKuF9EYzvWW5snLJn1bchyedcRGZmGX+FrDHSyDf5ylvDK3+8WLzdY+nwfRaMkqURjj6/XeFasoUqv4y6qAc8CC2zIMu+r9vf88qJ3awRtLoctvSJj/fPq7ZnnpAAMci2EZ2j2WJvq/KXbDYzuxAq0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eXAn8lg+; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747127884; x=1778663884;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OZJPGrjursZMHwmHj5u/k8EH2OvZh4oaVXSEFgcgksQ=;
  b=eXAn8lg+8TcQParhx4p2OVZXUnSM2mTOdpL2xPFEkmIQmSyyrswchTBQ
   71zwCv40D6RLMjAyTguDoBtAyrJ7G9utTSbwjrdO8DN+tKd284dxnvxW8
   zDXW73KPoXS+c4iZwwHirEPh53EUSO/KbkeE4xdzSWfS4vAEBPj5gwkxu
   q/KfWJFts7uVgQ7PzotAquKV4hBD4hU7szDF4jDdV7okC7i6FsiZFP941
   oRN2oKatxSx//o6hZXqfpNEQVBCN9OKpo5nYYXhxMxLziyAQHgypK47Ju
   zXO+5EvLgFTdRsLxhqTsxyTpgTlct49uleY5HiJTx7Yuvb14Ye2BJnnIG
   A==;
X-CSE-ConnectionGUID: tea5VF+GRTatC3dhYzLSnA==
X-CSE-MsgGUID: R7JQ51KjQ4SOxMpyN8h5KA==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48889202"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48889202"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 02:17:57 -0700
X-CSE-ConnectionGUID: YdHt/kCyTsKIP5+72c6mhw==
X-CSE-MsgGUID: a9W1Fs1aQliG979NGbbLrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="138161553"
Received: from unknown (HELO [10.238.1.183]) ([10.238.1.183])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 02:17:55 -0700
Message-ID: <458bb0e1-ed50-449c-b884-a825eb09b7fe@linux.intel.com>
Date: Tue, 13 May 2025 17:17:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: Check for empty mask of harvested dirty ring
 entries in caller
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
References: <20250508141012.1411952-1-seanjc@google.com>
 <20250508141012.1411952-5-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250508141012.1411952-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/8/2025 10:10 PM, Sean Christopherson wrote:
> When resetting a dirty ring, explicitly check that there is work to be
> done before calling kvm_reset_dirty_gfn(), e.g. if no harvested entries
> are found and/or on the loop's first iteration, and delete the extremely
> misleading comment "This is only needed to make compilers happy".  KVM
> absolutely relies on mask to be zero-initialized, i.e. the comment is an
> outright lie.  Furthermore, the compiler is right to complain that KVM is
> calling a function with uninitialized data, as there are no guarantees
> the implementation details of kvm_reset_dirty_gfn() will be visible to
> kvm_dirty_ring_reset().
>
> While the flaw could be fixed by simply deleting (or rewording) the
> comment, and duplicating the check is unfortunate, checking mask in the
> caller will allow for additional cleanups.
>
> Opportunisticaly drop the zero-initialization of cur_slot and cur_offset.

Opportunisticaly -> Opportunistically


> If a bug were introduced where either the slot or offset was consumed
> before mask is set to a non-zero value, then it is highly desirable for
> the compiler (or some other sanitizer) to yell.
>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/dirty_ring.c | 44 ++++++++++++++++++++++++++++++++++---------
>   1 file changed, 35 insertions(+), 9 deletions(-)
>
[...]
>   
> -	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +	/*
> +	 * Perform a final reset if there are harvested entries that haven't
> +	 * been processed, which is guaranteed if at least one harvested was
> +	 * found.  The loop only performs a reset when the "next" entry can't
> +	 * be batched with "current" the entry(s), and that reset processes the
"current" the entry(s) -> the "current" entry(s) ?

> +	 * _current_ entry(s), i.e. the last harvested entry, a.k.a. next, will
> +	 * always be left pending.
> +	 */
> +	if (mask)
> +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>   
>   	/*
>   	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared


