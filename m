Return-Path: <kvm+bounces-66900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FFC6CEB8D2
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 09:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3FFF3045CDE
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 08:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58A5313E02;
	Wed, 31 Dec 2025 08:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mFy9ADcX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF4B18CBE1;
	Wed, 31 Dec 2025 08:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767170222; cv=none; b=iPp9ziuAWgoFo/gTIbW6lZ2Kk/YujmNfi2JUSR5NepegsCORz99k9YIRYMs0eakORXN6j5Tnj4rkGS6ZXbZoJN7I0qYD0dHMGUkNUL/z8NrTNtyZPiO+DJrMyp9Qf788LFg/IOzpLujEIRbwQDB5JfcDFNCLfykb+hqGx7t4u2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767170222; c=relaxed/simple;
	bh=blI6GpL8mo2hOJFqWDE/aCp3PDuJRDyIPZScdgw4U0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXCOZE9c4vhasuOyarYnRQpRk8uBoi7JLd087nrMMT/vxtH76u2hCCh9VnbSI+0sXKUle0Bfb0XtI/G8/cPC4d+HiFsa+70LLh3Wtjk9qFyLkyoW/PIrVetxxb1K70LsIfNq3D/nGwAPvslMBSOVDAE0H3JMuyAdFcWCzc1l/2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mFy9ADcX; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767170222; x=1798706222;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=blI6GpL8mo2hOJFqWDE/aCp3PDuJRDyIPZScdgw4U0o=;
  b=mFy9ADcXVdLHM3k0uceivcW3+2UPBNSlKOGOgUfzlN2gUKY8LUzEWmMg
   sppZeqPXupHq5gGrzmUVmCfKyiz3Ney458itfVjMVqVQzI4Dix4frib5S
   d/Uqpp2uoNH/tb9HH21GTEmQQ1eXUO2GFnohqCZZK5XqwxR/2ZWCbjvye
   mNOs8vcAvwCbxlQmh3wW1hv9bh130WlvQ3Bx1cV0CTJ5MX7bYgyFXxR4d
   SEQBIBeSXYTJxkibj/4CSjOQEna04XpaSwC5TDEFcY7u8cJ4R8bKkv9/9
   uzYMvMJ26dgjeTqD3cwJQfpgWd+uqTBKHeHfQBnW9vx25aD8y6mbe4+9i
   g==;
X-CSE-ConnectionGUID: Uz0FonMGQ5aMhyXS3qqmyA==
X-CSE-MsgGUID: L58mZz51Rui2q8tmBzFpOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11657"; a="68644366"
X-IronPort-AV: E=Sophos;i="6.21,191,1763452800"; 
   d="scan'208";a="68644366"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2025 00:37:01 -0800
X-CSE-ConnectionGUID: chBFWYoIT067+JES92swUQ==
X-CSE-MsgGUID: +t1eGQawSLqd5brHGYTbbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,191,1763452800"; 
   d="scan'208";a="206448863"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2025 00:36:58 -0800
Message-ID: <777040ff-8064-4b19-8bd0-f4262e6c2e68@intel.com>
Date: Wed, 31 Dec 2025 16:36:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Chao Gao <chao.gao@intel.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20251230220220.4122282-1-seanjc@google.com>
 <20251230220220.4122282-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251230220220.4122282-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/31/2025 6:02 AM, Sean Christopherson wrote:
> +/*
> + * Indexing into the vmcs12 uses the VMCS encoding rotated left by 6 as a very
> + * rudimentary compression of the range of indices.  The compression ratio is
> + * good enough to allow KVM to use a (very sparsely populated) array without
> + * wasting too much memory, while the "algorithm" is fast enough to be used to
> + * lookup vmcs12 fields on-demand, e.g. for emulation.
> + */
>   #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
> +#define VMCS12_IDX_TO_ENC(idx) ((u16)(((u16)(idx) >> 6) | ((u16)(idx) << 10)))

Put them together is really good.

And ROL16(val, 16-n) is exactly undoing ROL16(val, n), so that we can 
further do

---8<---
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 98281e019e38..be2f410f82cd 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -19,7 +19,8 @@
   * lookup vmcs12 fields on-demand, e.g. for emulation.
   */
  #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 
- (n)))))
-#define VMCS12_IDX_TO_ENC(idx) ((u16)(((u16)(idx) >> 6) | ((u16)(idx) 
<< 10)))
+#define ENC_TO_VMCS12_IDX(enc) ROL16(enc, 6)
+#define VMCS12_IDX_TO_ENC(idx) ROL16(idx,10)

  struct vmcs_hdr {
         u32 revision_id:31;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index b92db4768346..1ebe67c384ad 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -4,10 +4,10 @@
  #include "vmcs12.h"

  #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
-#define FIELD(number, name)    [ROL16(number, 6)] = VMCS12_OFFSET(name)
+#define FIELD(number, name)    [ENC_TO_VMCS12_IDX(number)] = 
VMCS12_OFFSET(name)
  #define FIELD64(number, name)                                          \
         FIELD(number, name),                                            \
-       [ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
+       [ENC_TO_VMCS12_IDX(number##_HIGH)] = VMCS12_OFFSET(name) + 
sizeof(u32)

  static const u16 kvm_supported_vmcs12_field_offsets[] __initconst = {
         FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),




