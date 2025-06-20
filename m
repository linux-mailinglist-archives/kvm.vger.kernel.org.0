Return-Path: <kvm+bounces-50015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 076E4AE1187
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 05:05:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F3F84A31FE
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 03:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314851C861A;
	Fri, 20 Jun 2025 03:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dwL9Cm31"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E20101EE;
	Fri, 20 Jun 2025 03:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750388710; cv=none; b=SOfcofd9SvJaajf2AdD8JI6VL/e158N1KSM/EBLX4Lfdyd4WW8NbzoDkOShXo4j9uKCmtHRSQnfP+dWEGoUjjVUzRNZFi8gW83CiGPkF4FcW7nbOJsapL5vCqWSiYr4Rzcg8s3aocZfeunHYXJb4HYt5n5bX74cc2BzKIh6f4w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750388710; c=relaxed/simple;
	bh=+XY2IN5PeXAKIRHok/za964zxGioKvU708pfoy8++6M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=C1zevdJNLc3aNLpV3iuPYgKAKCmdmSrfGEQYC3Y7EWUuRBMuc4rpf4HaYLgtXu8jrjm7x4xp8hNo/24J3aExMBZ1l9lYpkG77WndST2/39UkmuffIuXKA7J5BsxSkodsyevMshA1TWjM4LC5jMsKrZMKw/d5V6hpiKFFVPuRzDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dwL9Cm31; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750388709; x=1781924709;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=+XY2IN5PeXAKIRHok/za964zxGioKvU708pfoy8++6M=;
  b=dwL9Cm31A/0e0LN2hMSoPzM0xeSBm0N3Zh1gUGD4+k8omA255WYXspZY
   oLsnpxM4tFMQTek4CV7hXPEL7twOVAQDoo9pE9nDpzlisRx2YlBCxbc73
   nwcF+QIg4Tcwy3OGQK8cpR6TDkSz3/FwzqFyUr7SCIY57yHfIzs9QBp/Z
   sduU4zM5WZ2dKytIVIMUZiZeqgoiHy6MtPp7sMvQkt85cKNs8DDrKal2u
   V0gP/nD9JH73Nc6XSAgXmpILJzrhDgh+OOfQs92La7c/1ka6X+5oJ4ci8
   G+M1LhnFIhaRH7f1Dpz72TWQ+WmEBNTzNduAWOhnb13TEMIY7k50Pl9ce
   Q==;
X-CSE-ConnectionGUID: 0gaKnjKUTOiyynuzsDOJ4w==
X-CSE-MsgGUID: 806hhBjuRfWAMJaw8JLwFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="52726239"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="52726239"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 20:05:08 -0700
X-CSE-ConnectionGUID: ALWUidTqR7mJNWjOjwF7eQ==
X-CSE-MsgGUID: NJ2RzNgXT0WmD45ZGcAtQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="156597620"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 20:05:04 -0700
Message-ID: <af494dd0-a8f9-460e-b65e-05db6b9c37c8@linux.intel.com>
Date: Fri, 20 Jun 2025 11:05:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, seanjc@google.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 mikko.ylinen@linux.intel.com, kirill.shutemov@intel.com, jiewen.yao@intel.com
References: <20250619180159.187358-1-pbonzini@redhat.com>
 <20250619180159.187358-3-pbonzini@redhat.com>
 <afcb49f2-d881-420d-9727-58182e52f977@linux.intel.com>
Content-Language: en-US
In-Reply-To: <afcb49f2-d881-420d-9727-58182e52f977@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/20/2025 10:57 AM, Binbin Wu wrote:
>
>
> On 6/20/2025 2:01 AM, Paolo Bonzini wrote:
> [...]
>> @@ -7174,6 +7175,52 @@ The valid value for 'flags' is:
>>     - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
>>       in VMCS. It would run into unknown result if resume the target VM.
>>   +::
>> +
>> +        /* KVM_EXIT_TDX */
>> +        struct {
>> +            __u64 flags;
>> +            __u64 nr;
>> +            union {
>> +                struct {
>> +                    u64 ret;
>> +                    u64 data[5];
> Should the interface reserve more elements?
>
> Without considering XMM registers, the possible registers according to GHCI spec
> are RBX, RDX, RBP, RDI, RSI, R8, R9, R12-R15. Since RBP is not suggested to be
> used to pass information, how about make the array 10 elements?

Please Ignore it, there is no need to do this.

>
>
>> +                } unknown;
>> +                struct {
>> +                    u64 ret;
>> +                    u64 gpa;
>> +                    u64 size;
>> +                } get_quote;
>> +            };
>> +        } tdx;
>> +
>


