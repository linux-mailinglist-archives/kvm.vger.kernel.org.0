Return-Path: <kvm+bounces-32948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43F2C9E2BD0
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 20:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B341D165849
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 19:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D301FC100;
	Tue,  3 Dec 2024 19:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uus+1SCG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12831FDE05;
	Tue,  3 Dec 2024 19:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733253441; cv=none; b=jOvE6yahPkuZi3KdZFc/vu5dyVjyyqa8YlC+L+ppOF04zyL/A4kefrgnKHIaOe7DEqUrBNOhTUwsXdfyIFsOWfQk4RsA9+O4XGBtGfiE1054U1xrAHGXi0GoCfSyRmUoVdYsP9c1MfmuuW+xhCTunFIMBkcH/LwyNr4FonwI8ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733253441; c=relaxed/simple;
	bh=Gj9U8gjOLgwmXWzIPYtQE17POzTSo+8rK0HOW9AYUaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j5d3knKP0bdde5yO6PuESheC8KUT8MErWysNnf9qh666bOt+8z98Oex77SAo83xOblPvHlEa9xpQ3cwWkQgAMuRRKvRgU7UOf8Y9DY2+Dsey/9QHFUeupbAF9/p1j9eKypVUx49+xMGGT+7gN2jLgJy3H0e8sRv2LSUPdot5oE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uus+1SCG; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733253439; x=1764789439;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gj9U8gjOLgwmXWzIPYtQE17POzTSo+8rK0HOW9AYUaI=;
  b=Uus+1SCG7IvnQ59LbLpWeIFtcDK/laKeaB04JhraEGMAisN22gjO/8AB
   UtP9f8jT+48ji6/6pa8gSqVRV8B1gVXf5UU67bxr/eitgLqAmEJtQBNIl
   a813sRi+d10FMZJdKPn5Dv4pa0LkwVe7vVXpYZKYCDV24NO8a88pAj6ia
   Gbq8wrWl+xD5jXVBXQNEEn7DLCNW6CgG6ZFsDaJLHcwo4+nfPPZ+v76m7
   WgcISUeSaNmr7CYFyTcVfvxIvbTpksbngrgQgZhQa1hEUxlB7sC3ic9TD
   Ih08f5D5xJ+scCN1EQokVkfYtCMM+GYvsjBeT+q+NzFDSArSuWFkHXDBK
   Q==;
X-CSE-ConnectionGUID: QZkUJ56ATfSVmJw309eBcQ==
X-CSE-MsgGUID: ZgqupyhcQdCOiYciTJO6og==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="43968944"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="43968944"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 11:17:17 -0800
X-CSE-ConnectionGUID: 8o3ozbdOQ5S7JUs7VlJJaA==
X-CSE-MsgGUID: kH3OH0VXSq6ekEmu491NXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="93379486"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.0.178])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 11:17:12 -0800
Message-ID: <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com>
Date: Tue, 3 Dec 2024 21:17:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yang, Weijiang" <weijiang.yang@intel.com>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "dmatlack@google.com" <dmatlack@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-8-adrian.hunter@intel.com> <Zz/6NBmZIcRUFvLQ@intel.com>
 <Z0cmEd5ehnYT8uc-@google.com>
 <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
 <Z04Ffd7Lqxr4Wwua@google.com>
 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
 <Z05SK2OxASuznmPq@google.com>
 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/12/24 19:34, Edgecombe, Rick P wrote:
> On Mon, 2024-12-02 at 16:34 -0800, Sean Christopherson wrote:
>>> Small point - the last conversation[0] we had on this was to let *userspace*
>>> ensure consistency between KVM's CPUID (i.e. KVM_SET_CPUID2) and the TDX
>>> Module's view.
>>
>> I'm all for that, right up until KVM needs to protect itself again userspace
>> and
>> flawed TDX architecture.  A relevant comment I made in that thread:
>>
>>  : If the upgrade breaks a setup because it confuses _KVM_, then I'll care
>>
>> As it applies here, letting vCPU CPUID and actual guest functionality diverge
>> for
>> features that KVM cares about _will_ cause problems.
> 
> Right, just wanted to make sure we don't need to re-open the major design.
> 
>>
>> This will be less ugly to handle once kvm_vcpu_arch.cpu_caps is a thing.  KVM
>> can simply force set/clear bits to match the actual guest functionality that's
>> hardcoded by the TDX Module or defined by TDPARAMS.
>>
>>> So the configuration goes:
>>> 1. Userspace configures per-VM CPU features
>>> 2. Userspace gets TDX Module's final per-vCPU version of CPUID configuration
>>> via
>>> KVM API
>>> 3. Userspace calls KVM_SET_CPUID2 with the merge of TDX Module's version,
>>> and
>>> userspace's desired values for KVM "owned" CPUID leads (pv features, etc)
>>>
>>> But KVM's knowledge of CPUID bits still remains per-vcpu for TDX in any
>>> case.
>>>
>>>>
>>>>  - Don't hardcode fixed/required CPUID values in KVM, use available
>>>> metadata
>>>>    from TDX Module to reject "bad" guest CPUID (or let the TDX module
>>>> reject?).
>>>>    I.e. don't let a guest silently run with a CPUID that diverges from
>>>> what
>>>>    userspace provided.
>>>
>>> The latest QEMU patches have this fixed bit data hardcoded in QEMU. Then the
>>> long term solution is to make the TDX module return this data. Xiaoyao will
>>> post
>>> a proposal on how the TDX module should expose this soon.
>>
>> Punting the "merge" to userspace is fine, but KVM still needs to ensure it
>> doesn't
>> have holes where userspace can attack the kernel by lying about what features
>> the
>> guest has access to.  And that means forcing bits in kvm_vcpu_arch.cpu_caps;
>> anything else is just asking for problems.
> 
> Ok, then for now let's just address them on a case-by-case basis for logic that
> protects KVM. I'll add to look at using kvm_vcpu_arch.cpu_caps to our future-
> things todo list.
> 
> I think Adrian is going post a proposal for how to handle this case better.

Perhaps just do without TSX support to start with e.g. drop
this "KVM: TDX: Add TSX_CTRL msr into uret_msrs list" patch
and instead add the following:


From: Adrian Hunter <adrian.hunter@intel.com>
Date: Tue, 3 Dec 2024 08:20:03 +0200
Subject: [PATCH] KVM: TDX: Disable support for TSX and WAITPKG

Support for restoring IA32_TSX_CTRL MSR and IA32_UMWAIT_CONTROL MSR is not
yet implemented, so disable support for TSX and WAITPKG for now.  Clear the
associated CPUID bits returned by KVM_TDX_CAPABILITIES, and return an error
if those bits are set in KVM_TDX_INIT_VM.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 69bb3136076d..947f78dc3429 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -105,6 +105,44 @@ static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
 	return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
 }
 
+#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
+
+static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
+{
+	return entry->function == 7 && entry->index == 0 &&
+	       (entry->ebx & TDX_FEATURE_TSX);
+}
+
+static void clear_tsx(struct kvm_cpuid_entry2 *entry)
+{
+	entry->ebx &= ~TDX_FEATURE_TSX;
+}
+
+static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
+{
+	return entry->function == 7 && entry->index == 0 &&
+	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
+}
+
+static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
+{
+	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
+}
+
+static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
+{
+	if (has_tsx(entry))
+		clear_tsx(entry);
+
+	if (has_waitpkg(entry))
+		clear_waitpkg(entry);
+}
+
+static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
+{
+	return has_tsx(entry) || has_waitpkg(entry);
+}
+
 #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
 
 static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
@@ -124,6 +162,8 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
 	/* Work around missing support on old TDX modules */
 	if (entry->function == 0x80000008)
 		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
+
+	tdx_clear_unsupported_cpuid(entry);
 }
 
 static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
@@ -1235,6 +1275,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
 		if (!entry)
 			continue;
 
+		if (tdx_unsupported_cpuid(entry))
+			return -EINVAL;
+
 		copy_cnt++;
 
 		value = &td_params->cpuid_values[i];
-- 
2.43.0


