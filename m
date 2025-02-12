Return-Path: <kvm+bounces-37937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 518B2A31B35
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:32:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D122918859B0
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 01:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094774AEE2;
	Wed, 12 Feb 2025 01:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HCaNYDxp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BF82868B;
	Wed, 12 Feb 2025 01:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739323967; cv=none; b=uwR3seZritlnkJ4WTWEfLia74pmkNsGzRiYt9aWnkAwKzvqsYpStdtoq4TlE5tK9OR8jD7KZwLks76RayXL0s4CCC8Vl0vfjJpxLIEZ6KgnFt8HK+eGEna1mhyJCmMgJFL0wbVN+fw8RltFPPch0BzIrwTtlnT3mv3fwVTJJ+H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739323967; c=relaxed/simple;
	bh=qKG2mLKWq785OyHAIRYQ9cq1Ri0MB1PQtVUqSMFRwN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GGH5GrMN62jjVy+PUPZMBDgDAOU/6oXrKOmu9tlB4XzLS55ccnhN6rjB7Dlod5H/H1l2peaJ6Tq2iTSAl6oWhQFf+hghby5+2tGSuN1GICeGRZ6PnBeOSbWjz1KFl+IpDNsn8tu66mdexJfaXQ0QMnQvAlhyVEFDhR1KmHZGJ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HCaNYDxp; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739323965; x=1770859965;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qKG2mLKWq785OyHAIRYQ9cq1Ri0MB1PQtVUqSMFRwN4=;
  b=HCaNYDxp0/MgskR2UThwtORAaQTdicHrE1FlvKgkoNlJMjbq8SMzpXjJ
   Pqynpm329+L32YeFskDdhM61iuCRHWcYt6m5uFxi3In2ZJFliSSWxVOnD
   kR3d/nbpeOO89x4amOn69hqjWgQ22aIS0DRvxN9nBMwtl1Q9Q4aAeZdAL
   K9d75pHYNc6Ma4ARp2EbIT0B+dbU2xsC/c4IQmSTPChV4D/zRs33IAVwG
   Ak1Ie9u9NNCEjApcGHZswIQgVBI9V0R3Hzs4EvxAmsvcLY2Pk12yWtJKI
   Dw1G9gh4E82hS+69YgZ8JKclhUerJTPM/EFRhCi3bo1xgvU2nHURwBwbz
   Q==;
X-CSE-ConnectionGUID: 5aWDb3s6QhmciM+P1a5pxw==
X-CSE-MsgGUID: 2KIlE1HrTwCZmlwG+3uHnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="51395193"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="51395193"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 17:32:43 -0800
X-CSE-ConnectionGUID: NplJyIkCTRevlCyLmpEmow==
X-CSE-MsgGUID: Qh1q377BR7WofJC6kYjpJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="113569941"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 17:32:38 -0800
Message-ID: <7abea257-7d83-40a2-8d56-c155593153f4@linux.intel.com>
Date: Wed, 12 Feb 2025 09:32:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] KVM: x86: Have ____kvm_emulate_hypercall() read
 the GPRs
To: Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-2-binbin.wu@linux.intel.com>
 <de966c9c-54e4-4da2-8dd3-d23b59b279a3@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <de966c9c-54e4-4da2-8dd3-d23b59b279a3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/11/2025 6:23 PM, Xiaoyao Li wrote:
> On 2/11/2025 10:54 AM, Binbin Wu wrote:
>> Have ____kvm_emulate_hypercall() read the GPRs instead of passing them
>> in via the macro.
>>
>> When emulating KVM hypercalls via TDVMCALL, TDX will marshall registers of
>> TDVMCALL ABI into KVM's x86 registers to match the definition of KVM
>> hypercall ABI _before_ ____kvm_emulate_hypercall() gets called. Therefore,
>> ____kvm_emulate_hypercall() can just read registers internally based on KVM
>> hypercall ABI, and those registers can be removed from the
>> __kvm_emulate_hypercall() macro.
>>
>> Also, op_64_bit can be determined inside ____kvm_emulate_hypercall(),
>> remove it from the __kvm_emulate_hypercall() macro as well.
>
> After this patch, __kvm_emulate_hypercall() becomes superfluous.
> we can just put the logic to call the "complete_hypercall" into ____kvm_emulate_hypercall() and rename it to __kvm_emulate_hypercall()
>
>
According to the commit message of
"KVM: x86: Refactor __kvm_emulate_hypercall() into a macro":
"Rework __kvm_emulate_hypercall() into a macro so that completion of
hypercalls that don't exit to userspace use direct function calls to the
completion helper, i.e. don't trigger a retpoline when RETPOLINE=y."

So I kept the macro.

