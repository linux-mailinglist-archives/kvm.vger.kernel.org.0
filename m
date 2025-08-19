Return-Path: <kvm+bounces-54952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F35BB2B8D1
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 07:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBEAF176DE3
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 05:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88AB630FF37;
	Tue, 19 Aug 2025 05:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dRrDMxa0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4C2645;
	Tue, 19 Aug 2025 05:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755582066; cv=none; b=Gib2ti+pm0IIHmEYr5eUzHm2ovcD4lo8A+eMAVDtm9Wz9exrimCPKNaQbTM0kFfGYb/+B+StG7EoBNPC3uEsNA27ysSndVaXDQeZ77U+YwzD0lk+g+BJDheODQ+gukKRqiZlbuthao9uFtxsnKEsnPvtUmvZJpd56nmtnMylqp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755582066; c=relaxed/simple;
	bh=kWV3adSTE0hRt/xjHlQmrI6cUpQMKfUAc0V/ZoE/Xz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Byuxqnl0K0kmMvmrXxgEZreJXk8R9oKTzVPSOWSU5AdW+fhfcBbsUGc7dBMPFoPc/mELWQEfPEaccrLVqC/bXDx0Oqm/FWmbcPftTkhYx5KPX+48IetIDdfUnrG4THzG8S0V/wrRx5MvtmYQY8ajKXevIF+ayi6fpAmEma4vjX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dRrDMxa0; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755582065; x=1787118065;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kWV3adSTE0hRt/xjHlQmrI6cUpQMKfUAc0V/ZoE/Xz4=;
  b=dRrDMxa0GONfue15uRMeIlZwH7x24iEIF/C8pjLKpiVlo5w072GEXIAs
   UM2q3wDQoxJ8vh4Nk2QZiK3zR2OMn+9Fflr4sY9jYUYOWMcfbArN1dI/l
   gG+qdibh1gzkaUM2opp/pF/gnKHPaiJPEvkls7pe1VhNLxO2fhqBSpagr
   lkrj8Oev0mRp0gKdcuy4DR3I+hn0KK1tLR9asJ8oRNU/ZmYVp8PsPtn6M
   4k81edT1OSMrmdZ9wqOOauDdbKRD+7O1Vp8JztJKE0jknSnGDBmUGREQu
   dY2MT1c+Wm/xley53QzIMGqymipMUoEXD96863uMx/GwmFZ4hh+ZR4UGZ
   Q==;
X-CSE-ConnectionGUID: tsbRY70AQoaDAHBDfs2Hig==
X-CSE-MsgGUID: JOy6HBS8QCS+uv7PeOtG+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="80411712"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="80411712"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 22:41:04 -0700
X-CSE-ConnectionGUID: MTZtMf/4SQqwRMDH31DbUw==
X-CSE-MsgGUID: H9PV6qGZSNCBtuPdBdBBOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="198624642"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 22:41:01 -0700
Message-ID: <97d3090d-38c5-40df-bab0-c81fc152321d@linux.intel.com>
Date: Tue, 19 Aug 2025 13:40:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
 <20250816144436.83718-2-adrian.hunter@intel.com>
 <aKMzEYR4t4Btd7kC@google.com>
 <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/19/2025 2:49 AM, Edgecombe, Rick P wrote:
> Attn: Binbin, Xiaoyao
>
> On Mon, 2025-08-18 at 07:05 -0700, Sean Christopherson wrote:
>> NAK.
>>
>> Fix the guest, or wherever else in the pile there are issues.  KVM is NOT carrying
>> hack-a-fixes to workaround buggy software/firmware.  Been there, done that.
> Yes, I would have thought we should have at least had a TDX module change option
> for this.
>
> But side topic. We have an existing arch TODO around creating some guidelines
> around how CPUID bit configuration should evolve.
>
> A new directly configurable CPUID bit that affects host state is an obvious no-
> no. But how about a directly configurable bit that can't hurt the host, but
> requires host changes to virtualize in an x86 arch compliant way? (not quite
> like this MWAIT case)
>
> In some ways KVM shouldn't care since it's between userspace and the TDX module.
> But userspace may try to set it and then we would have a situation where the bit
> would remain malfunctioning until/if KVM decided to add support for the bit. If
> KVM never did then it would be silently broken. It's not a kernel regression,
> but not great either.
>
> If we required some other opt-in for each such feature, it would further
> complicate the CPUID bit configuration interface. I think I'd rather keep
> directly configurable CPUID bits as the main way to configure the TD.

Currently, KVM TDX code filters out TSX (HLE or RTM) and WAITPKG using
tdx_clear_unsupported_cpuid(), which is sort of blacklist.

I am wondering if we could add another array, e.g., tdx_cpu_caps[], which is the
TDX version of kvm_cpu_caps[].

Using tdx_cpu_caps[] is a whitelist way.
For a new feature
- If the developer doesn't know anything about TDX, the bit just be added to
   kvm_cpu_caps[].
- If the developer knows that the feature supported by both non-TDX VMs and TDs
   (either the feature doesn't require any additional virtualization support or
   the virtualization support is added for TDX), extend the macros to set the bit
   both in kvm_cpu_caps[] and tdx_cpu_caps[].
- If there is a feature not supported by non-TDX VMs, but supported by TDs,
   extend the macros to set the bit only in tdx_cpu_caps[].
So, tdx_cpu_caps[] could be used as the filter of configurable bits reported
to userspace.

Comparing to blacklist (i.e., tdx_clear_unsupported_cpuid()), there is no risk
that a feature not supported by TDX is forgotten to be added to the blacklist.
Also, tdx_cpu_caps[] could support a feature that not supported for non-TDX VMs.

Then we don't need a host opt-in for these directly configurable bits not
clobbering host states.

Of course, to prevent userspace from setting feature bit that would clobber host
state, but not included in tdx_cpu_caps[], I think a new feature that would
clobber host state should requires a host opt-in to TDX module.

>
> Maybe we could have the TDX module enumerate which direct bits require VMM
> enabling and KVM could automatically filter them? So then TDX module could add
> simple feature bits without fuss, but KVM could manually enable the bits that
> require consideration.


