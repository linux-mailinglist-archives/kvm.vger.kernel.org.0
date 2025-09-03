Return-Path: <kvm+bounces-56655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60ED7B412F1
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 05:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 251891B631E1
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 03:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB222868B8;
	Wed,  3 Sep 2025 03:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TuUsqaez"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2447542048;
	Wed,  3 Sep 2025 03:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756870243; cv=none; b=axbMXCLbQTNC2I6II0zGeDxJFlszdhus2Kxs2HyZ5zNqUdrbYY0d1hxP9SWsSFNBW6lEcnxgfeSZnd/5czrbNxYJurOWQx0L/2I1WBTB+XUosurAQXpXonuupvI7ZsrlO8uEYapcL4ssXDatWx6akuBBtwBtv5Ey2yXDTxb+9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756870243; c=relaxed/simple;
	bh=enGIRmq1rpGTLE+bdtzFFW8XLM4VsAivd5USY6nk5Yc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AmcZ2mJnH+dRfjn8Q2zdIak4y2+rgXFAUSKTWMxAY7d4ei/gd2q0iEpRNf1jqj94i/XCXBbIk+dQtdxq4zJqeJJMxGzyEpmaDxJFLLyEoUicHoG+H8J1c599TJUCRjKHYm9S33wDg0kbU7Eb/9w1WA1zbaRXcAltK4pvUhva+Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TuUsqaez; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756870242; x=1788406242;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=enGIRmq1rpGTLE+bdtzFFW8XLM4VsAivd5USY6nk5Yc=;
  b=TuUsqaezbOhtrvsFHrFFLpSz53xaOhVe0BQZg1WLm2NmWgAZo48AoYUw
   cHaM1XmNEwNeR8ksSv/pqq6RH6biioY5Hrf9mTpOfqU/WGIEEfeAA0bjQ
   lP8n/2+ilgiR5nKpcR5pyBuaMvCbEB8wEBN6/VonuHdX+93Lzo367jHFC
   rvCgBrB7UsOlJPSULgTmh5UVlPguLTXTZ8OnSezjfUQPSK1FD02/fKO41
   OBSi/e7z9mWa9p3frs9IiU6FhWvMjG84eigicoub44XjAnYBX7TIeWCFt
   scFlp0ytaJswQI7GCfGriXQUW1hb6IO3vG0axvXTvFE1lTaZrWfFA6Nt1
   w==;
X-CSE-ConnectionGUID: gHQhqOU9RcmebOoIf0v0jQ==
X-CSE-MsgGUID: YTk7rvYXTHK92pfNrcStUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59123693"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59123693"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 20:30:42 -0700
X-CSE-ConnectionGUID: ZM2eebWVQIiQA3mcBzFRMQ==
X-CSE-MsgGUID: P5q0N0s2RBGLzbxy7RbALA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171019931"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 20:30:36 -0700
Message-ID: <deeb7ab5-c9e6-44c2-9136-f8e5abe31210@linux.intel.com>
Date: Wed, 3 Sep 2025 11:30:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 11/23] KVM: x86: Reject splitting huge pages under
 shared mmu_lock for mirror root
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
 <20250807094345.4593-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094345.4593-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/7/2025 5:43 PM, Yan Zhao wrote:
> While removing the KVM_BUG_ON() for the mirror root before invoking
> tdp_mmu_split_huge_page() in the fault path, update the hook
> split_external_spt to pass in shared mmu_lock info and invoke the hook in
> set_external_spte_present() on splitting is detected. Reject the splitting
> in TDX if the splitting is under shared mmu_lock.
>
> TDX requires different handling for splitting under shared or exclusive
> mmu_lock.
>
> Under a shared mmu_lock, TDX cannot kick off all vCPUs to avoid BUSY error
> from tdh_mem_page_demote(). As the current TDX module requires
> tdh_mem_range_block() to be invoked before each tdh_mem_page_demote(), if a
> BUSY error occurs, TDX must call tdh_mem_range_unblock() before returning
> the error to the KVM MMU core to roll back the old SPTE and retry. However,
> tdh_mem_range_unblock() may also fail due to contention.
>
> Reject splitting huge pages under shared mmu_lock for mirror root in TDX
> rather than KVM_BUG_ON() in KVM MMU core to allow for future real
> implementation of demote under shared mmu_lock once non-blocking demote is
> available.

Prefer "blockless" used in the cover letter to non-blocking.

[...]

