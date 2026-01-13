Return-Path: <kvm+bounces-67905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F095D16935
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 04:59:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C279303525F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 03:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E951131ED8D;
	Tue, 13 Jan 2026 03:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MIc0Oj53"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013222E0925;
	Tue, 13 Jan 2026 03:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768276729; cv=none; b=QQP42Ur2B+ZMKY8aYyLI64kAPSEiXYrb3iX1+wr0CqSaRw5EKUsL6h6JSviXWKsVVSUZmSJ3wieo4QTlpobHE5f+8m/0Fw+T2bcMmV5jeRvg+VaXZHQatJg/BDJ0xmOiY3CKdnl11wsKFuhpvgkBfqlf/CvZ7ZpoZG2slNE1oA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768276729; c=relaxed/simple;
	bh=FvItaEemTJxbw1gAV4qb83fnhQyNwytQF67ujmNQzVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R1U7FdGRA2ucWKQwXwKaQYgGbs2+s+SgITYB1OIuueB/5s2qNS6adHxkMx6ax9Ay58GELxC60YjxT+r9kTtdG4OP+UhEjEs2DtAPbb4pSOQc9Lh8A7rg9R9WOUx6hRKKz/oayPYjhinwB5iQ73ewOaHfeqMcXiyYuBQXLdTP6n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MIc0Oj53; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768276727; x=1799812727;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FvItaEemTJxbw1gAV4qb83fnhQyNwytQF67ujmNQzVQ=;
  b=MIc0Oj53QS83U8PE7CBRojyi/HdOpoq4LH8mJVOIxFc70cdT3X0dEdeM
   OMfa2fDZ2tyWQ+iBNTg1pLr2hFAVblRNy1LpV8bpWE/UnAnj9JBL9qE/c
   FrwQAOlqDXKPYr8eZFhvpYnS9bxfecw2nzZ1HMxYtMwKPuthZsgCQ36Sw
   Fc2FT9vRLijSViUNZVJolDZsLIvGxjXaQj63RlnZoH0AAGyfMkbS6g1kf
   V1P2PDNaAHbgi5h97tBVmQphAPUMqr+QJ6Oijx3iAwqijQxTikD2uNtHc
   7jnaWF2viamAGy19AjSsK0OyxK6/s1P7awKf6UgLTyREd5NmAo2b+PnwJ
   Q==;
X-CSE-ConnectionGUID: q2jc1C1lQWKPw3IUDnxh5A==
X-CSE-MsgGUID: 8GRcrvoPS/K3WirWkaGpww==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69543048"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69543048"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 19:58:46 -0800
X-CSE-ConnectionGUID: fZzLhQSWRKuZw3KxbiK8Gw==
X-CSE-MsgGUID: ArLBE187T4+gukmDQNcdag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204559380"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 19:58:42 -0800
Message-ID: <e2f80e63-302a-47a0-b165-e7abe164a4be@intel.com>
Date: Tue, 13 Jan 2026 11:58:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/virt/tdx: Retrieve TDX module version
To: Xu Yilun <yilun.xu@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org, x86@kernel.org,
 Chao Gao <chao.gao@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Kai Huang <kai.huang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <20260109-tdx_print_module_version-v2-1-e10e4ca5b450@intel.com>
 <93ab41bc-91bf-405a-84c4-6355a556596d@intel.com>
 <f0cc6afe-0f58-4314-9a77-34c5b005b677@intel.com>
 <aWW0TZNdWdN/C6Yi@yilunxu-OptiPlex-7050>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aWW0TZNdWdN/C6Yi@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/2026 10:56 AM, Xu Yilun wrote:
> On Mon, Jan 12, 2026 at 06:56:58AM -0800, Dave Hansen wrote:
>> On 1/11/26 18:25, Xiaoyao Li wrote:
>>> ... I know it's because minor_version has the least field ID among the
>>> three. But the order of the field IDs doesn't stand for the order of the
>>> reading. Reading the middle part y of x.y.z as first step looks a bit odd.
>>
>> I wouldn't sweat it either way. Reading 4, 3, 5 would also look odd. I'm
>> fine with it as-is in the patch.
> 
> I prefer 3, 4, 5. The field IDs are not human readable hex magic so
> should take extra care when copying from excel file to C file manually,
> A different list order would make the code adding & reviewing even
> harder.

I guess eventually we will introduce MACROs for these magic numbers to 
make the code more readable given that the decision is no longer 
auto-generate the code by the script? Though I'm not sure when that will 
happen.



