Return-Path: <kvm+bounces-67696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CFE39D10C5F
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 07:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 114A7306BFB3
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 06:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76253322B72;
	Mon, 12 Jan 2026 06:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y78Cdpwr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7410330E846;
	Mon, 12 Jan 2026 06:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768201050; cv=none; b=jlGWoOm7JFSUVgsSCd3v0jn8Hi0mot1uUb0B0JhlzWvUX+Sni5siia09yaOvQns44Ah8rBeZPzD4GYF7rAE3nkKgtj3dXYCtHjKeL9eDF3Ap88AjZMhEKRDNAjlBbxbyY1lpUOD/JF+w1mg2/X2uBX+tU/PZt31DffH0VAWoCtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768201050; c=relaxed/simple;
	bh=Y+CKsY8ozRxqCtRq+eeYgn3o+J/olhPv8FM0d4eUp64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IZv0fBJ4ClRA6ZZBs9FRKtad7VmSP7bl6pZnRpm6hwBE6v9j86qTnzAJXJ1o/rgmdb2qEDd9BeylI1Eh9WrdlrKdWYXPCtZGrajU2gjF/1r/kqJMP/i8boCARhCcg2kiPbL3hzgdjqFEeHfkFbKO/JJRAtPdwAZXNaowzyRFO1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y78Cdpwr; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768201050; x=1799737050;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y+CKsY8ozRxqCtRq+eeYgn3o+J/olhPv8FM0d4eUp64=;
  b=Y78CdpwrjNc5bhGDwTMY99O5BxUPfiFkJ00vYVIbG1pTzAKvLlhgySSJ
   /IdPC2i1XIJ2MQm+0coSnfqLDvVZa/Wf4PZw8s/jUTBDpwKSVGdNJM8Wc
   EtU/5i7dTo3uD61rU2SWxAaBGt9bHl1P+0fzCRwSKeCif7C4AtmEAuheO
   1LIDz7KIHMhty0qF+mAiXps74dTRc6hNjhq/fqZfRI2TRslGS7hIYgmJ/
   K6eQIjWgtXqN5JkCFFfr3LuYBKVo5pX3g6pkaE+oetecLgKxZryk+9Oi4
   dMVnLkvoQc7o1G6KmNd1pizr0ACqK2zTqU0XK7M24UGXojG7r7yHnyerE
   w==;
X-CSE-ConnectionGUID: FOvaex0jSbm/qm6alnKhxw==
X-CSE-MsgGUID: /uLgtp3XTme/Sooatzn54A==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="69547299"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="69547299"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 22:57:29 -0800
X-CSE-ConnectionGUID: HO7kVFxARhOyVCLZUGBmrQ==
X-CSE-MsgGUID: i/tOWdsKTC6wJf+vpDrMEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203927150"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 22:57:25 -0800
Message-ID: <e867398d-6bef-46cf-9c25-91eabd49428c@linux.intel.com>
Date: Mon, 12 Jan 2026 14:57:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] iommu/vt-d: Add support to hitless replace IOMMU
 domain
To: Jason Gunthorpe <jgg@ziepe.ca>, Samiullah Khawaja <skhawaja@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 David Matlack <dmatlack@google.com>, Robin Murphy <robin.murphy@arm.com>,
 Pratyush Yadav <pratyush@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Saeed Mahameed <saeedm@nvidia.com>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 William Tu <witu@nvidia.com>
References: <20260107201800.2486137-1-skhawaja@google.com>
 <20260107202812.GD340082@ziepe.ca> <20260107204607.GE340082@ziepe.ca>
 <CAAywjhTEyOUmxWeCX6GwCBSnMf-p18Ksu2TUYeQ57K8H4RW-9w@mail.gmail.com>
 <20260111221440.GA745888@ziepe.ca>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20260111221440.GA745888@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/26 06:14, Jason Gunthorpe wrote:
>> Thank you for the feedback. I will prepare a v2 series addressing these points.
> I think there are so many problems here you should talk to Kevin and
> Baolu to come up with some plan. A single series is not going to be
> able to do all of this.

Yes, absolutely. I am working on a patch series to address the
fundamental atomicity issue. I hope to post it for discussion soon. Once
that is addressed, we can discuss any additional problems.

Thanks,
baolu

