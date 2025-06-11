Return-Path: <kvm+bounces-48961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1EDAAD48ED
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 04:37:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C4933A678E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51FE3190664;
	Wed, 11 Jun 2025 02:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cu0ockHa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1111C36;
	Wed, 11 Jun 2025 02:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749609444; cv=none; b=obe+cxraFFTD0sltgeIJIx2i5YIMoiI6Bc/WlvEWUo8gCVqdYRGT9YV0T9dJDFuBomwNkYJFbpOohKFkGclL2HHwuqfasUD3IWz0uau6kCSCnx+WosAI0SVbuiu3dFb7L6BX4CCsq89JGQO+jNe7jq4cV+s9jS75jX398Xcj2Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749609444; c=relaxed/simple;
	bh=CHjX7LjrVc1K8jWvxmmWhYpBK+58rdw4xWXA9O0KHXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HxAdbvL1tPDf4MBB2RaUat0QgDptBRYwcvbHwndwREdNqPABMV8XOGs8k4g9fMXB27uNpG+YdhP7Nh/kZQHFWTBAnDp+MaZaRBCye8zGnQMSjqF818lE1xXmSAhvZRI+wRjbR02uDxh1RggyGrw1pVbRTlk2gmlOKuexXOmHN3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cu0ockHa; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749609443; x=1781145443;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CHjX7LjrVc1K8jWvxmmWhYpBK+58rdw4xWXA9O0KHXA=;
  b=cu0ockHaO4mf2Ho8EpfLu6zjmSGtThwMCdaABljhvRUi468BAzxs+olL
   Qvw8PKX2QwY2BbxgFSg2064egKNwkrwktaa/i+s8RbywZIvzClmEQ/zm9
   Y0Qnk4N+NhMye2p32TL7B/ddSbQ4SWHCLa7Pgm/bFt5YRwRXJdNsq9leR
   jHVTCp1M34Aej6FVj0Jlcn6wCjsFJRNBHggcdFh3TpC5pNNns9uvA0eFb
   CMBoW5A5Go2GwxH3WO/zmpGedGBDHEeo/Q+SY8pDIDqAk+jARcGvEVd7u
   wxfOjpJExFhBMKL3rzDDwcL/vfwwomnRzs2cl0RMW5taEfzF5HzapzgS0
   Q==;
X-CSE-ConnectionGUID: nY4BMTBqQ0O1N74c+dznPA==
X-CSE-MsgGUID: Hs0w/OtUQXSvw9oMAt0Yyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51598336"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="51598336"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:37:22 -0700
X-CSE-ConnectionGUID: 54CNzDzuTFuPzi88b46LBw==
X-CSE-MsgGUID: uSvh9rSpT7m/2HVtlDWWdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="152169469"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:37:17 -0700
Message-ID: <d53d6131-bf99-4bb0-8d25-00834864402d@intel.com>
Date: Wed, 11 Jun 2025 10:37:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
To: Binbin Wu <binbin.wu@linux.intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
 <9421ffccdc40fb5a75921e758626354996abb8a9.camel@intel.com>
 <d4285aa9adb60b774ca1491e2a0be573e6c82c07.camel@intel.com>
 <e2e7f3d0-1077-44c6-8a1d-add4e1640d32@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <e2e7f3d0-1077-44c6-8a1d-add4e1640d32@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/11/2025 10:04 AM, Binbin Wu wrote:
> 
> 
> On 6/11/2025 12:54 AM, Edgecombe, Rick P wrote:
>> On Tue, 2025-06-10 at 09:50 -0700, Rick Edgecombe wrote:
>>> Why do we need an opt-in interface instead of a way to expose which 
>>> exit's are
>>> supported by KVM? I would think the need for a TDVMCALL opt-in 
>>> interface would
>>> only come up if there was a bad guest that was making TDVMCALLs that 
>>> it did not
>>> see in GetTdVmCallInfo.
> 
> The opt-in interface can eliminate some requirements for userspace.
> E.g, for GetQuote, this patch set enforces userspace to handle the exit 
> reason
> due to GetQuote as the initial support, because KVM doesn't know if 
> userspace
> is able to handle the exit reason or not without userspace's opt-in, unless
> it's handled by default in userspace.

Beside it.

opt-in is not needed if we only care about <getquote> for now since KVM 
makes <getquote> exit to userspace unconditionally.

But to support any new TDVMCALL leaf that needs to exit userspace, we 
will have to use opt-in. So to me, implement the opt-in at the first 
place as a common interface for all the optional tdvmcall leafs instead 
of making <getquote> specific is not a bad idea to me, especially the 
opt-in implementation doesn't look complicated.

>>>   So that we would actually require an opt-in is not
>>> guaranteed.
>>>
>>> Another consideration could be how to handle GetQuote for an eventual 
>>> TDVMCALL
>>> opt-in interface, should it be needed. The problem would be GetQuote 
>>> would be
>>> opted in by default and make the interface weird. But we may not want 
>>> to have a
>>> TDVMCall specific opt-in interface. There could be other TDX 
>>> behaviors that we
>>> need to opt-in around. In which case the opt-in interface could be 
>>> more generic,
>>> and by implementing the TDVMCall opt-in interface ahead of time we 
>>> would end up
>>> with two opt-in interfaces instead of one.
> 
> Maybe we can use a TDX specific opt-in interface instead of TDVMCALL 
> specific
> interface.
> But not sure we should add it now or later.

For simplicity, I prefer separate opt-in interfaces, it makes code simpler.


