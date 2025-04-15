Return-Path: <kvm+bounces-43323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08366A891A0
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 03:55:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10F17189BD77
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 01:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9245202C2D;
	Tue, 15 Apr 2025 01:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jGKUEPQy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9E913C8F3;
	Tue, 15 Apr 2025 01:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744682137; cv=none; b=YwBx8xILHIkd/TOd4AjnptqgpXYkcIsseFNos/BfLuqYkUZQnjnCezQmpvZYxS1XEvLIzYNMJbYQlKJTWQv6a3u6jj6DWlcLMVKVGjEyE4fifXBwMIzXpsUfMcRI8TVSpsOkHCAvjUuCK3jPIAdSwG4zOxUZtxPL8xCkmYzeYTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744682137; c=relaxed/simple;
	bh=FYw3BhrC8+gaS8WJQ2DcgsM4u20jpYJmqvpK4aofyZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LnFF+eR6pNe+4XrDbb6LsYdsrinmEXGLT9OR87NwK30ilFs86101v5Ot10+iqSWcNXM4I1esD+tsKr5CdILXwqbce6fqPmWjks2Zz6t/KYzjyA3ZGxBXaNbhWqJKa51DlAbk2PoV8/cQYazqQQBQ6NSEYHekeuGEX9kipcHht8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jGKUEPQy; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744682135; x=1776218135;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FYw3BhrC8+gaS8WJQ2DcgsM4u20jpYJmqvpK4aofyZM=;
  b=jGKUEPQyY2MwZr659g0TitcaTuqN+7L9O2FVVxGJhTl3fQ83K52WJZbD
   qkpzkEDodaUKiJ/M0eTZCqWqEohnl5im2CmUjorWc1UdKCdutesRES2pd
   KcdxUU1aBjTXrbv/sDn0zx0yCDeOnoNSrG0N0ZhBl6RTqzJfAMBbaD+ah
   DTWfVXpCokRJIe6uK+zSEQRorDKGi7zFhvIMH3O5lBwuW1dLJ5/s1qspY
   O7X3OqyVXBVI6j2H52k2vwwUBvrsUiZISiQOYLBJAQ1A+xwlJ6gWz/zC1
   ObWXXYVUEFSAbKLbOEVdfKXcBcg8tEta0slNTkcnYdhefOoqnw3tKapvK
   w==;
X-CSE-ConnectionGUID: 3kMCH2HTQhyIu3Ny68thhQ==
X-CSE-MsgGUID: UAdk3f2uS9GHklpDLGIryg==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="45304234"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="45304234"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 18:55:35 -0700
X-CSE-ConnectionGUID: WonOy1W0Tn6N6qlmv/V79Q==
X-CSE-MsgGUID: anLjQ1JcQR+OOByI5y+upw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="130945622"
Received: from unknown (HELO [10.238.11.123]) ([10.238.11.123])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 18:55:31 -0700
Message-ID: <dad54712-8576-47d0-8ef0-8928acb14d6c@linux.intel.com>
Date: Tue, 15 Apr 2025 09:55:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
 <20250402001557.173586-2-binbin.wu@linux.intel.com>
 <98408cbc-4244-4617-864d-c87a3b28b3af@intel.com>
 <b644c042602cac5096b32c0d61e5a2f7acdbcfa0.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <b644c042602cac5096b32c0d61e5a2f7acdbcfa0.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/15/2025 9:51 AM, Edgecombe, Rick P wrote:
> On Tue, 2025-04-15 at 09:49 +0800, Xiaoyao Li wrote:
>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>> index c6988e2c68d5..eca86b7f0cbc 100644
>>> --- a/include/uapi/linux/kvm.h
>>> +++ b/include/uapi/linux/kvm.h
>>> @@ -178,6 +178,7 @@ struct kvm_xen_exit {
>>>     #define KVM_EXIT_NOTIFY           37
>>>     #define KVM_EXIT_LOONGARCH_IOCSR  38
>>>     #define KVM_EXIT_MEMORY_FAULT     39
>>> +#define KVM_EXIT_TDX_GET_QUOTE    41
>> Number 40 is skipped and I was told internally the reason is mentioned
>> in cover letter
>>
>>       Note that AMD has taken 40 for KVM_EXIT_SNP_REQ_CERTS in the
>>       patch [4] under review, to avoid conflict, use number 41 for
>>       KVM_EXIT_TDX_GET_QUOTE and number 42 for
>>       KVM_EXIT_TDX_SETUP_EVENT_NOTIFY.
>>
>> I think we shouldn't give up number 40 unless this series depends on AMD
>> one or it's agreement that AMD one will be queued/merged earlier.
> Yes, if this patch needed to sit in kvm-coco-queue with AMD patches for awhile
> it might make sense. But it sounds like the plan is to include it in base
> support.
Right, now it seems that this patch could probably win the race upstream,
will use number 40 for KVM_EXIT_TDX_GET_QUOTE in the next version if no
objections.


