Return-Path: <kvm+bounces-52720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93241B088B2
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 11:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A01A6189930C
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DDBF288517;
	Thu, 17 Jul 2025 09:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="STr+G78o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C1D1FC0EF;
	Thu, 17 Jul 2025 09:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752742822; cv=none; b=cFnRhan18Yir1G+/8gJvy0igzG2D0QJsP0Ef0/ke6j3ZhJ5FTWQSrzUoFBxwF8A86JVeZa3Y82p8hajilVwZbxSlmEeahi7jsQKM8C0HWFy2F8iT6u/2/4rB2yNTTAbBdGeRGUqMRA6fY7ru+NOCmN3L2h2/PV7iQtkKaH3gOsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752742822; c=relaxed/simple;
	bh=aGbM7IqfeuS/6bF/kHs79qT5aNiBDtA03RdS80GdaYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SKHg3heoJuTzPZftZcGKhEF/TQFf0HMj/XB/xFulAVC9w46qfQC3lbFb41shION8on6bBKosxOLzVxMtm/sGOfON7RtA9Dx5EDxA1T9RAhtsXXDsYCmc9rQ0UlelxrogWK+f09G4BwEHt1YZEcgZQq6x7yrwa/FHx0R+NEQatVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=STr+G78o; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752742821; x=1784278821;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aGbM7IqfeuS/6bF/kHs79qT5aNiBDtA03RdS80GdaYQ=;
  b=STr+G78oxikYynwrPScHa6W1Y5ozyRXDiqW6zUvCZ18B4Y1Tabk+woRv
   4JJrYVM43XniWn23dyQ/8WV2x9cQ0B+qes3SSK7NajqYWZcA7SxgJFyL6
   +tDkOeYRCBbSUIjpwXPXrHb4iaAWANrO6HPnycTUFyqFlj2wx+l9rxBh0
   qvSr43XfzNaVyUiH1z7TCERJ7HxNn/7U8egMzznVCkeuvjCp1faymzliG
   QESDobelImHn9pRYzV66HUA4rSIOlBuloJdoFDyUQqF5H2gegPn8nZZq6
   RoCOWuCZyf1ghFG2lhb62cfCgOwrYZBFIkAm4DWloNQz7SvTtRed3Tk02
   g==;
X-CSE-ConnectionGUID: tsC018F6S4iDt7it1N4k6g==
X-CSE-MsgGUID: 3+9gkivSSHqyAEriQxDcgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54947369"
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="54947369"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 02:00:20 -0700
X-CSE-ConnectionGUID: grRhNT59TOae6QFdno4wGg==
X-CSE-MsgGUID: /gOPa19PR0iPIjZ0z+7J7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="158292638"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 02:00:06 -0700
Message-ID: <dbf3313e-3328-485c-9a77-2f853ad22525@intel.com>
Date: Thu, 17 Jul 2025 17:00:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
To: Fuad Tabba <tabba@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-5-tabba@google.com>
 <b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com>
 <diqzwm87fzfc.fsf@ackerleytng-ctop.c.googlers.com>
 <fef1d856-8c13-4d97-ba8b-f443edb9beac@intel.com>
 <CA+EHjTzZH2NN31ZfTg0NX_o3dryqbkmR4s8Y47eFJ1TcO1kiDA@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CA+EHjTzZH2NN31ZfTg0NX_o3dryqbkmR4s8Y47eFJ1TcO1kiDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/2025 4:49 PM, Fuad Tabba wrote:
> On Thu, 17 Jul 2025 at 02:48, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
>> On 7/17/2025 8:12 AM, Ackerley Tng wrote:
>>> Xiaoyao Li<xiaoyao.li@intel.com> writes:
>>>

...

>>>>
>>>> Btw, it seems that supports_gmem can be enabled for all the types of VM?
>>>>
>>> For now, not really, because supports_gmem allows mmap support, and mmap
>>> support enables KVM_MEMSLOT_GMEM_ONLY, and KVM_MEMSLOT_GMEM_ONLY will
>>> mean that shared faults also get faulted from guest_memfd.
>> No, mmap support is checked by kvm_arch_supports_gmem_mmap() which is
>> independent to whether gmem is supported.
> It is dependent on gmem support:
> 
> kvm_arch_supports_gmem_mmap(kvm) depends on
> CONFIG_KVM_GMEM_SUPPORTS_MMAP, which in turn selects KVM_GMEM.

My bad that my words leads to misunderstanding.

What I wanted to express it that support_gmem doesn't mean mmap support 
is allowed, there is additional specific guard for mmap support via 
kvm_arch_supports_gmem_mmap().

