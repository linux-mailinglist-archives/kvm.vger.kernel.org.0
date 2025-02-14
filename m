Return-Path: <kvm+bounces-38104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D054CA35333
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 01:48:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6903818914D6
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 00:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9840727540D;
	Fri, 14 Feb 2025 00:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ed3WcOqo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0067136E;
	Fri, 14 Feb 2025 00:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739494076; cv=none; b=XOIYNa7pKYBNyo29K4NiEiFxleFMmfLNGWOsxCALsZsCqN/yRZdGmp117D3vw2cjWGUC8UYfqU9WNXDUkVl7/H9u0+0Tzo+fZGVF2wOQIVxyun758d9NATzZETIWtTh2V42yGEZRdY7njeYnZQMmdEbhK5fly8WjLsfewoDMFYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739494076; c=relaxed/simple;
	bh=1ZPbTiIT14B33E2ZMSCbjGG/Gue/VzNdDfqwdUL1J3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvd9RSdVEqrStSkEGDen95RYd0XzGnT2cyARRZy4rrVfv5ZqWuCsl1Mvm016bQfjylSnRBbpI9NLLEE6OchcDWufdrThq6fxse2u6xArd7oyl6MQMqJEPTs+eCYGUhn/SavMBjV2m526ZWaE/AqZo+DwR25xoZ5Jgv2scEsUapA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ed3WcOqo; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739494075; x=1771030075;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1ZPbTiIT14B33E2ZMSCbjGG/Gue/VzNdDfqwdUL1J3A=;
  b=Ed3WcOqo637B2uMzwDtYnVrXa0psdRfZK48dTX5vS4SBiLoGBfN+Qjtz
   iZ7jQEnKZhnq7YNfrFhbRsnioziyUD1LU6cmFEVlS4xs2j0ZsM3MQjkL3
   6vmCCb2jbnk6mfkMTgesX1x59d5s5IpBjH4Mu12zxcqfg/5AIPoLumru2
   WrdCpgjZ33HMQZ4HGDiNIaKBrHrhraqc99/wgT7AnjOQozpHoqX4y4Ija
   0i7Fmd0y8Y5H8tgJ6f5CWize+X44FnF21UyzaeHjFeQ8kakpJ7ztXs8JG
   gzfBKnd+U0leEkSisIgALfD/TV498jNNX5Kkb7Z9X4nrRnegyfkD1VUb1
   w==;
X-CSE-ConnectionGUID: NnL89+2lSCeFMKDA1XI4wQ==
X-CSE-MsgGUID: bhiv4gGERpm/IVATyyfeiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="50873076"
X-IronPort-AV: E=Sophos;i="6.13,284,1732608000"; 
   d="scan'208";a="50873076"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 16:47:54 -0800
X-CSE-ConnectionGUID: fsDQ7aYFQSGRB2m11xCHig==
X-CSE-MsgGUID: EzNcB3vWSBSd16I4zSs6ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="150484353"
Received: from unknown (HELO [10.238.9.235]) ([10.238.9.235])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 16:47:51 -0800
Message-ID: <aa6a2af0-fa4b-42a7-98d6-d295efbb2732@linux.intel.com>
Date: Fri, 14 Feb 2025 08:47:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] KVM: TDX: Handle TDX PV MMIO hypercall
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
 <kai.huang@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-9-binbin.wu@linux.intel.com>
 <Z6wHZdQ3YtVhmrZs@intel.com>
 <fd496d85-b24f-4c6f-a6c9-3c0bd6784a1d@linux.intel.com>
 <da350e731810aa6726ff7f5dfc489e1969a85afb.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <da350e731810aa6726ff7f5dfc489e1969a85afb.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/14/2025 5:41 AM, Edgecombe, Rick P wrote:
> On Wed, 2025-02-12 at 10:39 +0800, Binbin Wu wrote:
>>> IIRC, a TD-exit may occur due to an EPT MISCONFIG. Do you need to
>>> distinguish
>>> between a genuine EPT MISCONFIG and a morphed one, and handle them
>>> differently?
>> It will be handled separately, which will be in the last section of the KVM
>> basic support.  But the v2 of "the rest" section is on hold because there is
>> a discussion related to MTRR MSR handling:
>> https://lore.kernel.org/all/20250201005048.657470-1-seanjc@google.com/
>> Want to send the v2 of "the rest" section after the MTRR discussion is
>> finalized.
> I think we can just put back the original MTRR code (post KVM MTRR removal
> version) for the next posting of the rest. The reason being Sean was pointing
> that it is more architecturally correct given that the CPUID bit is exposed. So
> we will need that regardless of the guest solution.
The original MTRR code before removing is:
https://lore.kernel.org/kvm/81119d66392bc9446340a16f8a532c7e1b2665a2.1708933498.git.isaku.yamahata@intel.com/

It enforces WB as default memtype and disables fixed/variable range MTRRs.
That means this solution doesn't allow guest to use MTRRs as a communication
channel if the guest firmware wants to program some ranges to UC for legacy
devices.


How about to allow TDX guests to access MTRR MSRs as what KVM does for
normal VMs?

Guest kernels may use MTRRs as a crutch to get the desired memtype for devices.
E.g., in most KVM-based setups, legacy devices such as the HPET and TPM are
enumerated via ACPI.  And in Linux kernel, for unknown reasons, ACPI auto-maps
such devices as WB, whereas the dedicated device drivers map memory as WC or
UC.  The ACPI mappings rely on firmware to configure PCI hole (and other device
memory) to be UC in the MTRRs to end up UC-, which is compatible with the
drivers' requested WC/UC-.

So KVM needs to allow guests to program the desired value in MTRRs in case
guests want to use MTRRs as a communication channel between guest firmware
and the kernel.

Allow TDX guests to access MTRR MSRs as what KVM does for normal VMs, i.e.,
KVM emulates accesses to MTRR MSRs, but doesn't virtualize guest MTRR memory
types.  One open is whether enforce the value of default MTRR memtype as WB.

However, TDX disallows toggling CR0.CD.  If a TDX guest wants to use MTRRs
as the communication channel, it should skip toggling CR0.CD when it
programs MTRRs both in guest firmware and guest kernel.  For a guest, there
is no reason to disable caches because it's in a virtual environment.  It
makes sense for guest firmware/kernel to skip toggling CR0.CD when it
detects it's running as a TDX guest.



>
> But it would probably would be good to update this before re-posting:
> https://lore.kernel.org/kvm/20241210004946.3718496-19-binbin.wu@linux.intel.com/#t
>
> Given the last one got hardly any comments and the mostly recent patches are
> already in kvm-coco-queue, I say we try to review that version a bit more. This
> is different then previously discussed. Any objections?


