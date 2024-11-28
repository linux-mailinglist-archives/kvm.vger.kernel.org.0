Return-Path: <kvm+bounces-32723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31DDA9DB1FF
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2B4A282789
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D4A136347;
	Thu, 28 Nov 2024 03:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jj10VN1W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ADA2563;
	Thu, 28 Nov 2024 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732766038; cv=none; b=a2ID6ODkSc2e2iZmFNDW5REXcd1Dg4dYd+uq30Wisbm9Rqea9x7/pqZtvrcluzgXlt9uKNYXihXfJsgpD8A8aWZHVhDO1Hq3r3k9H6sTcPmcSbMLCe935tfODxVsjp+G2va28yANTwoAWF10Is1Z/8rVZreR7N53LG0+q4jIceA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732766038; c=relaxed/simple;
	bh=+cToueDn8bjtrGwZGh8yj967W9auYzQsQSUm/E8KU8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lYwPPf5XyLHQDpHslOAOSxJKIiNvP82earJJkZOQlDlpykz+BpPzLUa5GoELkeRra5PMWSMTvkdRjEagU8YxOdMyH00twmMgMpqTO4xIEFU2b8Aspp4wNu6/uUAXm0BtRXtk/zw/abm0tmC4BNRKnLPvhu+rCDAR4kEsxfRucT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jj10VN1W; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732766036; x=1764302036;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+cToueDn8bjtrGwZGh8yj967W9auYzQsQSUm/E8KU8Q=;
  b=jj10VN1Wn3r77oxxyL/eYp493mTCBwtLCDCNjRQbqCRy00thAuoVOj3/
   rfiB2/9ETHo9i6dInK5YxS76+nXyXAsJu2IwVLdiG2iaJr0UUburvya5z
   wtgHb1q24gRGXOBqjCHcDWiU72HVCnlyz1FqgYIE+rNTuqQFiQFFA+o6S
   OQS3aR0WvZ8m/QST2bi9Lcx2LxtznS83bUYy9ca9sLBesX2wNb/MVhCsg
   +Pd2gfMV0CMmaxP7ctJzE2wbqinAaWjNxW9sIvWcXQGYbWLhy8YIWmb3p
   kBDV73TJexylWQovLEZhMROv4IAMGIZ1tjXTEklCgHHA9ipN1K/66BR6h
   g==;
X-CSE-ConnectionGUID: u8MjAK7+SnyhoVw5Iv6Sag==
X-CSE-MsgGUID: bpAhs/PkSXq3gf7sVa+hAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="43599462"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="43599462"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:53:55 -0800
X-CSE-ConnectionGUID: 6rA7C1OxSAu4J4wIQ4ShCg==
X-CSE-MsgGUID: lhZpvgLmTQiAAukqP2GH0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="92958633"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:53:53 -0800
Message-ID: <adf9d3a0-3134-425b-89e7-0a6881cdcc6c@intel.com>
Date: Thu, 28 Nov 2024 11:53:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Defer SVI update to vmcs01 on EOI when
 L2 is active w/o VID
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, =?UTF-8?Q?Markku_Ahvenj=C3=A4rvi?=
 <mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>
References: <20241128000010.4051275-1-seanjc@google.com>
 <20241128000010.4051275-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241128000010.4051275-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/2024 8:00 AM, Sean Christopherson wrote:
> +void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +
> +	if (WARN_ON_ONCE(!lapic_in_kernel(vcpu)) || !apic->apicv_active)
> +		return;
> +
> +	kvm_x86_call(hwapic_isr_update)(apic->vcpu, apic_find_highest_isr(apic));

Nit:

we have @vcpu already, no need to grab it from apic->vcpu.

> +}
> +EXPORT_SYMBOL_GPL(kvm_apic_update_hwapic_isr);


