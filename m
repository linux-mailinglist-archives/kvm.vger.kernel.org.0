Return-Path: <kvm+bounces-37953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB2CA31E49
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 06:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0B97165A15
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 05:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F6D1FAC53;
	Wed, 12 Feb 2025 05:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="auo5J/Xm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762161FAC45;
	Wed, 12 Feb 2025 05:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739339500; cv=none; b=sr/rEKXBOSiKJMa5vN4TKq7TWHwES451rNcFsC+nD13uvBUliCEQib3VpnYcD9pz0lgh2DchhpMRLhGaiZW26VCsl8mtFys5Fdbdur83BVRCnkqj1C+S58VxQLOlIDBgwnM8A1GWMmXFcsWL2bee42RPePnBBaF0NifiCC8Lp2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739339500; c=relaxed/simple;
	bh=OdeC2Rb28IXw9QRvLZlSuGXJ/Uv++46UhvOES/0+HZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xml9FFHMV+MWFPpnAagpSOUgwlyvvQQm0xjhheCDFDFFKfmrtCvxN/yWyBUIJX/5afQ2Vpp20I8JUJOG73IG3GsqHR1vE247+ItZmsraffqi5tzFYN9nEVxYqg0pXdeDx5MSGjsSHunTtjFj35Eg7NiH2ktrytGxA9WKQIBWjSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=auo5J/Xm; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739339499; x=1770875499;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OdeC2Rb28IXw9QRvLZlSuGXJ/Uv++46UhvOES/0+HZc=;
  b=auo5J/XmqJP79frTMvHytaZ9j+6KNxpGXr86BtG4kRz9146fX050lla7
   8G36NlCIR/5vl11KVtZaCzWvOm4izvQOlqffgShM2F7U57GmSF9HGUSj6
   K5beQLeD3fMjO/T5r9HUauxxZpPR/dSTzjPyrqnLjaYvkzx9E3x48XDW0
   lfqg4Bk6CxyDOt3tgNsbqXBpnX1wWoICN2a1ll6TWYnfYxPaHWAW+wDD+
   hleNqHNS8sCqjffEa2zXJuUW3WMAc0qsVeQlg06vwmdsY+laEYXSAgm/Y
   8nxhItuKuViAKQifRCSrv0Vdp0DqRrdQRQ+ZF2dfBCxhS5Ej2yQUSE0PU
   g==;
X-CSE-ConnectionGUID: aEYEbQUJSImXSExfiiZ67w==
X-CSE-MsgGUID: CGy5Zqv9RxGLYyixz46sDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="62448113"
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="62448113"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 21:51:39 -0800
X-CSE-ConnectionGUID: +9YbovWjRVeQsLDdGgZILw==
X-CSE-MsgGUID: V8Zn/khKQZmKVKyErD2MdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112580594"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 21:51:36 -0800
Message-ID: <518a71a9-011f-456c-bc99-639a5d69c144@linux.intel.com>
Date: Wed, 12 Feb 2025 13:51:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/17] KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
 <20250211025828.3072076-10-binbin.wu@linux.intel.com>
 <Z6v9yjWLNTU6X90d@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z6v9yjWLNTU6X90d@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/12/2025 9:47 AM, Sean Christopherson wrote:
> On Tue, Feb 11, 2025, Binbin Wu wrote:
>> +#ifdef CONFIG_KVM_SMM
>> +static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>> +{
>> +	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
>> +		return false;
> Nit, while the name suggests a boolean return, the actual return in -errno/0/1,
> i.e. this should be '0', not "false".
Yes.

>
> A bit late to be asking this, but has anyone verified all the KVM_BUG_ON() calls
> are fully optimized out when CONFIG_KVM_INTEL_TDX=n?
>
> /me rummages around
>
> Sort of.  The KVM_BUG_ON()s are all gone, but sadly a stub gets left behind.  Not
> the end of the world since they're all tail calls, but it's still quite useless,
> especially when using frame pointers.
>
> Aha!  Finally!  An excuse to macrofy some of this!
>
> Rather than have a metric ton of stubs for all of the TDX variants, simply omit
> the wrappers when CONFIG_KVM_INTEL_TDX=n.  Quite nearly all of vmx/main.c can go
> under a single #ifdef.  That eliminates all the silly trampolines in the generated
> code, and almost all of the stubs.
Thanks for the suggestion!

Since the changes will be across multiple sections of TDX KVM support,
instead of modifying them individually, are you OK if we do it in a separate
cleanup patch?

[...]

