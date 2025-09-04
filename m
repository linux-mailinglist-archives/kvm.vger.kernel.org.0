Return-Path: <kvm+bounces-56767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2C8B434D5
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89170171EDC
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 07:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50BA12BEFF9;
	Thu,  4 Sep 2025 07:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RSayuYH+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A052BE652;
	Thu,  4 Sep 2025 07:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756972745; cv=none; b=Lf8kl7adteZSVbyF5ii2zLcwx7PE0tyPP0EJE1uIy6gbCArmUAOhLR+xOCR+GLT6fAEWPeEAGPBXC/tnCbdwj0AH7LV6A+nPTDfOoeWBN3pldly5mrWAmVbNvI/M1x7PBaP6HoONH+hYEi1zswmXBRpGXo23RnMG2QTPLGgyJWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756972745; c=relaxed/simple;
	bh=aBuEluC+86E34BYUv5Oa47sk/w75PmXicZuwfYiSDcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kDsU2zi3xCynJYi0OSlJJlEkdPz1CJH3wRMC2n/jHLaeU6BqwAkXcG/JXJm+HjQm+gg0JC2p0taFlCforRUzMpfhtvC5fq+Md9hfjUa7O1gHcTpMoCMTYQWu8htgABg99jFPPyM4wCjqjgAFEg6sjaFs9AE+EGPVfAbk7Rl7sVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RSayuYH+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756972744; x=1788508744;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aBuEluC+86E34BYUv5Oa47sk/w75PmXicZuwfYiSDcM=;
  b=RSayuYH+xgkMOysHOpl3kxO96rcDTxBeCL3QLjjUCXcZxC1yUeVExbs9
   arQ20+ZYV0t6MdMK9kzy7ctKIQVbz7aXeLSvhAqXc8oICzTDtSOTXUSHL
   vvHhfArvrPyo1vtsyU7xti0HqiO5tStNjbjAwzSEINscbw1RFoSd3Ggt3
   WUaPaHtg41FD6YnMEQ3qvPKcPX/gdDj9zXFZUiRXNuhRMU5oBFMFwSZPp
   EjMCqcIvg9l6HujnsCiJmrblgWgFYPWGxlZxile7UKvR3SD++l4Mzn6HY
   KPVE9CtZnwQFMW1OnznsfXd+MBL+9yHAx1soGGX75xUD4tUug3fwfPw/J
   w==;
X-CSE-ConnectionGUID: fLx1pzDISBiRL/L5jMEWAA==
X-CSE-MsgGUID: gANneA5eSmmWL3Y2RFXAwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59217879"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59217879"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 00:59:04 -0700
X-CSE-ConnectionGUID: cK68dvTjQOWIr9ZUxNgrkA==
X-CSE-MsgGUID: hHmZT+vfQqu3I+274QjcUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="175950505"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 00:58:57 -0700
Message-ID: <6b61cee4-0405-4967-afee-af934df34c5f@linux.intel.com>
Date: Thu, 4 Sep 2025 15:58:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 17/23] KVM: guest_memfd: Split for punch hole and
 private-to-shared conversion
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094503.4691-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094503.4691-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/7/2025 5:45 PM, Yan Zhao wrote:
[...]
>   
> @@ -514,6 +554,8 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
>   					   struct conversion_work *work,
>   					   bool to_shared, pgoff_t *error_index)
>   {
> +	int ret = 0;
> +
>   	if (to_shared) {
>   		struct list_head *gmem_list;
>   		struct kvm_gmem *gmem;
> @@ -522,19 +564,24 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
>   		work_end = work->start + work->nr_pages;
>   
>   		gmem_list = &inode->i_mapping->i_private_list;
> +		list_for_each_entry(gmem, gmem_list, entry) {
> +			ret = kvm_gmem_split_private(gmem, work->start, work_end);
> +			if (ret)
> +				return ret;
> +		}
>   		list_for_each_entry(gmem, gmem_list, entry)
> -			kvm_gmem_unmap_private(gmem, work->start, work_end);
> +			kvm_gmem_zap(gmem, work->start, work_end, KVM_FILTER_PRIVATE);
>   	} else {
>   		unmap_mapping_pages(inode->i_mapping, work->start,
>   				    work->nr_pages, false);
>   
>   		if (!kvm_gmem_has_safe_refcount(inode->i_mapping, work->start,
>   						work->nr_pages, error_index)) {
> -			return -EAGAIN;
> +			ret = -EAGAIN;
>   		}

Not from this patch.
When if statement breaks into two lines, are curly braces needed?


>   	}
>   
> -	return 0;
> +	return ret;
>   }
>   
[...]
> @@ -1906,8 +1926,14 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
>   	start = folio->index;
>   	end = start + folio_nr_pages(folio);
>   
> -	list_for_each_entry(gmem, gmem_list, entry)
> -		kvm_gmem_invalidate_begin_and_zap(gmem, start, end);
> +	/* The size of the SEPT will not exceed the size of the folio */
To me, the comment alone without the context doesn't give a direct expression that
split is not needed. If it's not too wordy, could you make it more informative?


> +	list_for_each_entry(gmem, gmem_list, entry) {
> +		enum kvm_gfn_range_filter filter;
> +
> +		kvm_gmem_invalidate_begin(gmem, start, end);
> +		filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED;
> +		kvm_gmem_zap(gmem, start, end, filter);
> +	}
>   
>   	/*
>   	 * Do not truncate the range, what action is taken in response to the


