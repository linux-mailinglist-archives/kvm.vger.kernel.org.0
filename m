Return-Path: <kvm+bounces-43184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 939AFA8696C
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 01:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CC3D4C17F7
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 23:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF832BEC52;
	Fri, 11 Apr 2025 23:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hvv8jGzH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97DC2BEC59;
	Fri, 11 Apr 2025 23:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744415073; cv=none; b=qp0H4PxHTI0Q7/K7WWu7S2lX+8vqPnczZgb+gB4bCB4BtkFZU7kZXS5ivP+UMPn3XiL6TKWX1cWpo1ovVTfOqdemHEg6Ws0IXo2WzZIdL/E7qCY24rpAQwSLpmIcrzTZcOUsm9qvb/ec2IsIHleqzJHIwCacoJG+vXCeUPkaqpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744415073; c=relaxed/simple;
	bh=nTiktkxwTTIuoaDMGBCESJQS0PIKAYmw7EA1N95Tnhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bOwPUsZ3XRZZVa5vNLTSLLO3Ogr8uP8qX/ZTODb81wJK2V17kpQtFejzclJF+AXBvaCF+JFiAuU4VvrWcIrUHIzPLkz2OI/wx9+1GVG6aXzrMoApk+0EHCxhZNvxz+lhp/qQpU1e5NNisP2GjABRDViE0jm6VCOJvlSXgSbEvKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hvv8jGzH; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744415072; x=1775951072;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nTiktkxwTTIuoaDMGBCESJQS0PIKAYmw7EA1N95Tnhs=;
  b=hvv8jGzH0+iyr+oc42nViBeZzAtDb5E32FzbD6tgZmJs4koG9E87DgRK
   G7/HqodxnVLERFRMGT4Bp/11UF53C4N+z762omKrfQAl/f9LcVjdBauay
   3MHs0S5MKELna8IlZpGdLo8lh1b2TJe54VgYpp1WGSGNgGPswTW6tK429
   ui83al0juWHFnDv2Jni9d0VNiPUqvpxcG42QQeg//ssUGW5VgQeiXzb0f
   67UlsRqdXwCzj/ZnaCbcsiRfDbdw8IyXp54wKvUd7m0qZ55z47NUsikk0
   q56kBI0+R4v+wDlyUdybcYhhS4ExT7gpREARa5RBmrd8gZrNBg0U9F8Y6
   g==;
X-CSE-ConnectionGUID: Qw1wZL/PTs61ZIK87CjCqA==
X-CSE-MsgGUID: aLBCiYS/Th+e5VfsbXRtPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11401"; a="49808013"
X-IronPort-AV: E=Sophos;i="6.15,206,1739865600"; 
   d="scan'208";a="49808013"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 16:44:20 -0700
X-CSE-ConnectionGUID: yeIxdz7XQxqWRWXxqIROJA==
X-CSE-MsgGUID: tOssRkaKTcytuSJFzbuMgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,206,1739865600"; 
   d="scan'208";a="134483138"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.124.221.159]) ([10.124.221.159])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 16:44:16 -0700
Message-ID: <08b63835-121d-4adc-8f03-e68f0b0cabdf@intel.com>
Date: Fri, 11 Apr 2025 16:44:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] x86: remove HIGHMEM64G support
To: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
 x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Sean Christopherson <seanjc@google.com>,
 Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Mike Rapoport <rppt@kernel.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-6-arnd@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20241204103042.1904639-6-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Has anyone run into any problems on 6.15-rc1 with this stuff?

0xf75fe000 is the mem_map[] entry for the first page >4GB. It obviously
wasn't allocated, thus the oops. Looks like the memblock for the >4GB
memory didn't get removed although the pgdats seem correct.

I'll dig into it some more. Just wanted to make sure there wasn't a fix
out there already.

The way I'm triggering this is booting qemu with a 32-bit PAE kernel,
and "-m 4096" (or more).

> [    0.003806] Warning: only 4GB will be used. Support for for CONFIG_HIGHMEM64G was removed!
...
> [    0.561310] BUG: unable to handle page fault for address: f75fe000
> [    0.562226] #PF: supervisor write access in kernel mode
> [    0.562947] #PF: error_code(0x0002) - not-present page
> [    0.563653] *pdpt = 0000000002da2001 *pde = 000000000300c067 *pte = 0000000000000000 
> [    0.564728] Oops: Oops: 0002 [#1] SMP NOPTI
> [    0.565315] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-00288-ge618ee89561b-dirty #311 PREEMPT(undef) 
> [    0.567428] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [    0.568777] EIP: __free_pages_core+0x3c/0x74
> [    0.569378] Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b 03 c1
> [    0.571943] EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
> [    0.572806] ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
> [    0.573776] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
> [    0.574606] CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
> [    0.575464] Call Trace:
> [    0.575816]  memblock_free_pages+0x11/0x2c
> [    0.576392]  memblock_free_all+0x2ce/0x3a0
> [    0.576955]  mm_core_init+0xf5/0x320
> [    0.577423]  start_kernel+0x296/0x79c
> [    0.577950]  ? set_init_arg+0x70/0x70
> [    0.578478]  ? load_ucode_bsp+0x13c/0x1a8
> [    0.579059]  i386_start_kernel+0xad/0xb0
> [    0.579614]  startup_32_smp+0x151/0x154
> [    0.580100] Modules linked in:
> [    0.580358] CR2: 00000000f75fe000
> [    0.580630] ---[ end trace 0000000000000000 ]---
> [    0.581111] EIP: __free_pages_core+0x3c/0x74
> [    0.581455] Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b 03 c1
> [    0.584767] EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
> [    0.585651] ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
> [    0.586530] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
> [    0.587480] CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
> [    0.588344] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.589435] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

> [    0.561310] BUG: unable to handle page fault for address: f75fe000
> [    0.562226] #PF: supervisor write access in kernel mode
> [    0.562947] #PF: error_code(0x0002) - not-present page
> [    0.563653] *pdpt = 0000000002da2001 *pde = 000000000300c067 *pte = 0000000000000000 
> [    0.564728] Oops: Oops: 0002 [#1] SMP NOPTI
> [    0.565315] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-00288-ge618ee89561b-dirty #311 PREEMPT(undef) 
> [    0.567428] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> [    0.568777] EIP: __free_pages_core+0x3c/0x74
> [    0.569378] Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b 03 c1
> [    0.571943] EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
> [    0.572806] ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
> [    0.573776] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
> [    0.574606] CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
> [    0.575464] Call Trace:
> [    0.575816]  memblock_free_pages+0x11/0x2c
> [    0.576392]  memblock_free_all+0x2ce/0x3a0
> [    0.576955]  mm_core_init+0xf5/0x320
> [    0.577423]  start_kernel+0x296/0x79c
> [    0.577950]  ? set_init_arg+0x70/0x70
> [    0.578478]  ? load_ucode_bsp+0x13c/0x1a8
> [    0.579059]  i386_start_kernel+0xad/0xb0
> [    0.579614]  startup_32_smp+0x151/0x154
> [    0.580100] Modules linked in:
> [    0.580358] CR2: 00000000f75fe000
> [    0.580630] ---[ end trace 0000000000000000 ]---
> [    0.581111] EIP: __free_pages_core+0x3c/0x74
> [    0.581455] Code: c3 d3 e6 83 ec 10 89 44 24 08 89 74 24 04 c7 04 24 c6 32 3a c2 89 55 f4 e8 a9 11 45 fe 85 f6 8b 55 f4 74 19 89 d8 31 c9 66 90 <0f> ba 30 0d c7 40 1c 00 00 00 00 41 83 c0 28 39 ce 75 ed 8b 03 c1
> [    0.584767] EAX: f75fe000 EBX: f75fe000 ECX: 00000000 EDX: 0000000a
> [    0.585651] ESI: 00000400 EDI: 00500000 EBP: c247becc ESP: c247beb4
> [    0.586530] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210046
> [    0.587480] CR0: 80050033 CR2: f75fe000 CR3: 02da6000 CR4: 000000b0
> [    0.588344] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.589435] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

