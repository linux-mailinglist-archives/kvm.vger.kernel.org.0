Return-Path: <kvm+bounces-15097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB4B8A9BBF
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 506121C23245
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 13:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D83165FCA;
	Thu, 18 Apr 2024 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dN93vxBl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C726C165FB6;
	Thu, 18 Apr 2024 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713448493; cv=none; b=eItGK2bO/rBmkC5HPo7lvczvAnvWXgtbTfGWSKpSK5woFAgCKWIJPvf2RjuOEjYFPUfl0c3kYnI3RTFDc7y7FO7YPUkfNlK4eLWfqELs6e5OqUuSAXjbHFYXHep7Y6JSZZotf3s6HeJi02T6Oz1CEpwMx7LMdDdXvYMAs1ATQWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713448493; c=relaxed/simple;
	bh=g94a7qkSkn65haHDm+CsriRsABmH8NJg5ir3bpPXwj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DSH9+adRehAEzG1QEuTQEy7dSqH21my/x0PQaSn7IJ32NkMt2Kem9YDSUQE2yD0TxEEafFY0qbzcpTn4ytarJ+8/VXgPZW6OfysSP7wLpqVEi2ib7MNMfIZnzqOXXNclmly5ycEJYJP85zABZ7Sb5olpLPOkHhcH5cq/iQ9OBCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dN93vxBl; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713448492; x=1744984492;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g94a7qkSkn65haHDm+CsriRsABmH8NJg5ir3bpPXwj4=;
  b=dN93vxBlEdrFsDUyYjUE60T8DftfDjo9oLnZQBzhR9tULVbQUGx0fms8
   tbvkm+AeP1Wdd/kg7R0T7iXQN3emQQ2P14it4yICCFRgvkmWaMxAv3b0E
   BvOtlBNeOlwYIsL4JP+4aLt6djQzzSu2SWtATY+uB3T28V//m4Qwx0+r5
   D8sVclIczYvrchQrRsE4Fv3qS8fArSksQRj81f5e9QsaMfsF6UEESH7g0
   simGfcypCWtUYuMYn5gK6hOxLmobwYhFV+vWmumIjYxg4HN+2LvOwZ+s4
   FamFlqLEFmE9o/usclPfo01ukFD1NizJn2Zq4VA5QsIEnSw7oLqeakOCS
   w==;
X-CSE-ConnectionGUID: s/wVNknUSUyvVQtklyQCqg==
X-CSE-MsgGUID: mle7J87DTViRTFnwGpchjA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="26453883"
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="26453883"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 06:54:51 -0700
X-CSE-ConnectionGUID: N9VOFXmTRCmiZ4OALNBa7Q==
X-CSE-MsgGUID: LE/rr+LnRaaDedMot6OSVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="27428787"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 06:54:42 -0700
Message-ID: <cfbe7d5a-e045-4254-8a8c-c0a8199db4b7@linux.intel.com>
Date: Thu, 18 Apr 2024 21:54:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 111/130] KVM: TDX: Implement callbacks for MSR
 operations for TDX
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Implements set_msr/get_msr/has_emulated_msr methods for TDX to handle
> hypercall from guest TD for paravirtualized rdmsr and wrmsr.  The TDX
> module virtualizes MSRs.  For some MSRs, it injects #VE to the guest TD
> upon RDMSR or WRMSR.  The exact list of such MSRs are defined in the spec.
>
> Upon #VE, the guest TD may execute hypercalls,
> TDG.VP.VMCALL<INSTRUCTION.RDMSR> and TDG.VP.VMCALL<INSTRUCTION.WRMSR>,
> which are defined in GHCI (Guest-Host Communication Interface) so that the
> host VMM (e.g. KVM) can virtualize the MSRs.
>
> There are three classes of MSRs virtualization.
> - non-configurable: TDX module directly virtualizes it. VMM can't
>    configure. the value set by KVM_SET_MSR_INDEX_LIST is ignored.

There is no KVM_SET_MSR_INDEX_LIST in current kvm code.
Do you mean KVM_SET_MSRS?

> - configurable: TDX module directly virtualizes it. VMM can configure at
>    the VM creation time.  The value set by KVM_SET_MSR_INDEX_LIST is used.
> - #VE case
>    Guest TD would issue TDG.VP.VMCALL<INSTRUCTION.{WRMSR,RDMSR> and
>    VMM handles the MSR hypercall. The value set by KVM_SET_MSR_INDEX_LIST
>    is used.
>

