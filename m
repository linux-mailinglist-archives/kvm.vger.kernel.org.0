Return-Path: <kvm+bounces-15673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FDB58AEACF
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1EC11C20C80
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 15:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B58413DDC6;
	Tue, 23 Apr 2024 15:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UX/mbM5l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDBF13C83C;
	Tue, 23 Apr 2024 15:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713885488; cv=none; b=igrS6Yooki40XFJW0BleV4gB86SF8eeSyJ9W9NsL3dCarchO7UnH9FPV8tCiKsWUCoGA8kCqVvrN9ZCwFzcSemH+D3at2kXNTVFCEBqpZdjJ+dSAQtjbx9OwMvfDNlwb7JHgyiOAC2U6cJRnis1WoBRy6la8zpOdvoOnzS4Pvew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713885488; c=relaxed/simple;
	bh=cXtuzrz0pugD7qW0LzJQMkZH8QRVvVQv977ZzpkGlB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O+/eR/wkwOoltwPBVHeGQ/G1ZcKso2KMA68hvI5ZHrH8rrrdpA1Tp4dJyVrw2lHNCZd9W24BujPEjQ3U5whyzLOkGNfhcuUVjV7at+KdNQr/npWVTMCO/NZ4nVcWOLzZHEU9no1RwVNS6RFXOwbntGmZ4Sqbb7old2rMppF5/+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UX/mbM5l; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713885487; x=1745421487;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cXtuzrz0pugD7qW0LzJQMkZH8QRVvVQv977ZzpkGlB8=;
  b=UX/mbM5lPbUWR9XjnGHMf+/FNs/wX0stitCAAmlYHgcsoRsfBv5fjBBG
   5sU48IUrX6ybvwzDEHpjyLzRgPVpjcUhclAe9/0u/uDeniePQfrOYkgP8
   iJGVJcISaPdyjkPtMUHR0bbxizHynY5RIHWTcknS0jWKiX34nXicr5Ofy
   SJWVBFD8PIujss4l2HZw8fCZNCffLGLHIWCue9pQhjA3gQFoCJcSsEDUf
   BRMv47Ie7hBDkn/UAAxks5hV3aoDkw9ZlK8UjhkHDdbEkiEpq/JZeekWJ
   WNyjZiky+neCVOQDSRalX5yc8i6x2mpu41sZevZkW49OP+DgNJYeXeeWx
   A==;
X-CSE-ConnectionGUID: bgrknfd4RF6HrzqTTD10QQ==
X-CSE-MsgGUID: I176GYuTSEiQdbkPF7DWmw==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="13261682"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="13261682"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 08:18:06 -0700
X-CSE-ConnectionGUID: bYXCDlWGSna35mVH8uSKzg==
X-CSE-MsgGUID: 8YEXGAcARdqFztNbnn3PIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="24439701"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 08:18:04 -0700
Message-ID: <b7d6bb0c-6ee4-4f93-a1a0-5ee6f49c0c59@intel.com>
Date: Tue, 23 Apr 2024 23:18:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] KVM: selftests: x86: Add test for
 KVM_PRE_FAULT_MEMORY
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com, binbin.wu@linux.intel.com, seanjc@google.com,
 rick.p.edgecombe@intel.com
References: <20240419085927.3648704-1-pbonzini@redhat.com>
 <20240419085927.3648704-7-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240419085927.3648704-7-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/2024 4:59 PM, Paolo Bonzini wrote:

...

> +static void __test_pre_fault_memory(unsigned long vm_type, bool private)
> +{
> +	const struct vm_shape shape = {
> +		.mode = VM_MODE_DEFAULT,
> +		.type = vm_type,
> +	};
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_run *run;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +
> +	uint64_t guest_test_phys_mem;
> +	uint64_t guest_test_virt_mem;
> +	uint64_t alignment, guest_page_size;
> +
> +	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
> +
> +	alignment = guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
> +	guest_test_phys_mem = (vm->max_gfn - TEST_NPAGES) * guest_page_size;
> +#ifdef __s390x__
> +	alignment = max(0x100000UL, guest_page_size);
> +#else
> +	alignment = SZ_2M;
> +#endif
> +	guest_test_phys_mem = align_down(guest_test_phys_mem, alignment);
> +	guest_test_virt_mem = guest_test_phys_mem;

guest_test_virt_mem cannot be assigned as guest_test_phys_mem, which 
leads to following virt_map() fails with

==== Test Assertion Failure ====
   lib/x86_64/processor.c:197: sparsebit_is_set(vm->vpages_valid, (vaddr 
 >> vm->page_shift))
   pid=4773 tid=4773 errno=0 - Success
      1	0x000000000040f55c: __virt_pg_map at processor.c:197
      2	0x000000000040605e: virt_pg_map at kvm_util_base.h:1065
      3	 (inlined by) virt_map at kvm_util.c:1571
      4	0x0000000000402b75: __test_pre_fault_memory at 
pre_fault_memory_test.c:96
      5	0x000000000040246e: test_pre_fault_memory at 
pre_fault_memory_test.c:133 (discriminator 3)
      6	 (inlined by) main at pre_fault_memory_test.c:140 (discriminator 3)
      7	0x00007fcb68429d8f: ?? ??:0
      8	0x00007fcb68429e3f: ?? ??:0
      9	0x00000000004024e4: _start at ??:?
   Invalid virtual address, vaddr: 0xfffffffc00000

> +
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +				    guest_test_phys_mem, TEST_SLOT, TEST_NPAGES,
> +				    private ? KVM_MEM_GUEST_MEMFD : 0);
> +	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, TEST_NPAGES);





