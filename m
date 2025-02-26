Return-Path: <kvm+bounces-39268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84BEBA45B76
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 11:16:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 628A017890B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98FB2459FF;
	Wed, 26 Feb 2025 10:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E/ztWZw5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538891F4177;
	Wed, 26 Feb 2025 10:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740564908; cv=none; b=eeGTgvQfH5ulswe+gbZDMaXgrSdVNQIgRKw/Cbhh1+NKW6Rg7lnpUHmQflFWVz0oqRCHBmBuko9ywTUsLhXx2ABX0nOVrRmgUqkNH+tz+BilNVTJ/F63AZkpNlC9OtifsuWBKLNn6CtJsdOO0MkFeaCDM+NCZVUXxUd31FG/HGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740564908; c=relaxed/simple;
	bh=CEYY9OfuCnZ5U7LCB211l+tkMfFHTw7whNGD1LSDnBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mw+1ydmVjqv0rz6A2NjNCf7yixyt58zpUUpOQ2+zll3bpzGRm71MP71rk8lSo9bVnoFcpdIET3rNhr36gZ++f8Elt9MPjUVvzKwD8rd0qfr0MsZ7UqYT1ad2Le5mFWidgJTKFxe/JGEu6xCwosl3hZRZf42YU9gHVouPp5niWrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E/ztWZw5; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740564908; x=1772100908;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CEYY9OfuCnZ5U7LCB211l+tkMfFHTw7whNGD1LSDnBk=;
  b=E/ztWZw5Er3wR9l96mnf6EJuUAcoIVhhDsOFuPfJQPNOnVFLPh+lFqMG
   tDPrs93faiYSYy83WGg3LPRWK6Boe1NyR85kbmBrQydxAjWdzJOQKhaa0
   QourCK2gBhfSnSumVOKHFGvsyZGeUiDSXqaeUQLytLbjersZSG7mUFjFV
   qdxbn/wcuXUEWO3PEvE0xmUL/AawNwHf/w9DC+pgw3ItGoBMrEgqW83rO
   +AIJlPVcFBc9SFog9779u9HcVtfQCYmyh3AtPaMLNPlnrSVW0nKGxjD7g
   p7ZOwVdXHAL9twERLhQNSZirIwIe8+7Z66ztbn8TfhiZesN/XrxZhG1Io
   g==;
X-CSE-ConnectionGUID: DVOxI7CuQSChmDY8qYsK3A==
X-CSE-MsgGUID: XRQqn7HATdeR7PM5xIdQ9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="51612958"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="51612958"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 02:15:07 -0800
X-CSE-ConnectionGUID: h1x44VhKTce7RJuXpdqvCw==
X-CSE-MsgGUID: GUJLJU4PRdeRWEiykVDtHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117582198"
Received: from xmei3-mobl1.ccr.corp.intel.com (HELO [10.124.242.61]) ([10.124.242.61])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 02:15:03 -0800
Message-ID: <f16d1df0-0948-4ac4-8487-df790c1773f3@linux.intel.com>
Date: Wed, 26 Feb 2025 18:15:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/9] KVM: TDX: Handle TDG.VP.VMCALL<ReportFatalError>
To: Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20250222014225.897298-1-binbin.wu@linux.intel.com>
 <20250222014225.897298-8-binbin.wu@linux.intel.com>
 <68f771b1-0a7e-44e7-8db6-956b8cfb4112@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <68f771b1-0a7e-44e7-8db6-956b8cfb4112@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2025 5:36 PM, Xiaoyao Li wrote:
> On 2/22/2025 9:42 AM, Binbin Wu wrote:
>> @@ -6849,9 +6850,11 @@ Valid values for 'type' are:
>>      reset/shutdown of the VM.
>>    - KVM_SYSTEM_EVENT_SEV_TERM -- an AMD SEV guest requested termination.
>>      The guest physical address of the guest's GHCB is stored in `data[0]`.
>> - - KVM_SYSTEM_EVENT_WAKEUP -- the exiting vCPU is in a suspended state and
>> -   KVM has recognized a wakeup event. Userspace may honor this event by
>> -   marking the exiting vCPU as runnable, or deny it and call KVM_RUN again.
>
> It deletes the description of KVM_SYSTEM_EVENT_WAKEUP by mistake;

Oops, sorry for not being careful enough.

>
> (Maybe we can fix the order of the descriptions by the way, KVM_SYSTEM_EVENT_SEV_TERM gets put in front of KVM_SYSTEM_EVENT_WAKEUP and KVM_SYSTEM_EVENT_SUSPEND)
>
>> + - KVM_SYSTEM_EVENT_TDX_FATAL -- a TDX guest reported a fatal error state.
>> +   KVM doesn't do any parsing or conversion, it just dumps 16 general-purpose
>> +   registers to userspace, in ascending order of the 4-bit indices for x86-64
>> +   general-purpose registers in instruction encoding, as defined in the Intel
>> +   SDM.
>>    - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested a suspension of
>>      the VM.
>


