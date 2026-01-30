Return-Path: <kvm+bounces-69665-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Dc3AWMkfGnsKgIAu9opvQ
	(envelope-from <kvm+bounces-69665-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 04:24:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 74865B6D02
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 04:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CFB73301384A
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 03:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D5434CFDD;
	Fri, 30 Jan 2026 03:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QCvYrkF4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C027E0E8;
	Fri, 30 Jan 2026 03:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769743444; cv=none; b=bL+K10MLSUJuuY9rFaL1H5z+zAmeD0f1mGjwJ1HsTP2KptSe0lUcYZWNNGzBC6ZREyRinexivTkUaJNqxXkPR0FBtT5dp7wlmyk6BnS4QOj/hrRhHQalG7ad5u8oZPjwOtwLsRGvtcdfLsG5362A2eC2U3v9b0zG3dJ0frucKHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769743444; c=relaxed/simple;
	bh=F9atmiyM11HhfTRulkobq/MVMJTG1x4p+28ptQY6q4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=imhUlyx+KSt8lNMa4qAj0zb88JfOCpr2N8Ri1158rDNG/gCKYo3X1YoC9bKafrWNk+tsgN7NC8INAGMMZUix0ses1uCxMPjtW1+MEpLOWg2W79Gbgb1bcx+Yu9yaxTzyulkVb9zYE6mtt/tG7LwNJ97YD5rnqfgdUziQ5PvSdEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QCvYrkF4; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769743443; x=1801279443;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=F9atmiyM11HhfTRulkobq/MVMJTG1x4p+28ptQY6q4U=;
  b=QCvYrkF4mFTTVLFQtnIbcBV7sa8Jx38z5A7v+NKLzVgMUirP3Y0ZQeNp
   FXVnIsSmZVE573jFROcx65bqknGlp5U4Jy/bOjblgAyIXe1++B8W6jqvl
   QfJLF+CmTeRcTj30kc08cqRL99vxW7Wv8FsxeIsHIl453U8k6NueAyYCH
   f8iecNBD/hAQTQA2Zbk4pGq1f1ada5jnZXwx/SJkkMfDLNPt1mky1HQLj
   0ofScF8fmyOGMJZdualPSYmViX899txm9moqvpXj4eBmEHwWj3XG1TWNP
   Q6BycdaP8wpXmPhzMOxMUaeXsVud+FuwRnz6kA8gs6u9GihRCxEqEsvaN
   g==;
X-CSE-ConnectionGUID: jj7vhp0+RIKG3NuSl5bQCg==
X-CSE-MsgGUID: i86VV+A8R+yc8Fp7Hqjfkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70192790"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="70192790"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 19:24:02 -0800
X-CSE-ConnectionGUID: sK9dqNLdTxOAwEijwR7Qcw==
X-CSE-MsgGUID: 4K/+vb0KTJCgSjGtmWW2kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="208660486"
Received: from unknown (HELO [10.238.3.203]) ([10.238.3.203])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 19:23:59 -0800
Message-ID: <e4e52215-3160-4f67-877b-16b9d6cba210@intel.com>
Date: Fri, 30 Jan 2026 11:23:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] KVM: x86: Explicitly configure supported XSS from
 {svm,vmx}_set_cpu_caps()
To: Binbin Wu <binbin.wu@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
 John Allen <john.allen@amd.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Jim Mattson <jmattson@google.com>
References: <20260128014310.3255561-1-seanjc@google.com>
 <20260128014310.3255561-2-seanjc@google.com>
 <9856fb02-b72a-4626-b34a-16a7adb55fc6@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <9856fb02-b72a-4626-b34a-16a7adb55fc6@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69665-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 74865B6D02
X-Rspamd-Action: no action

On 1/29/2026 3:34 PM, Binbin Wu wrote:
> 
> 
> On 1/28/2026 9:43 AM, Sean Christopherson wrote:
>> Explicitly configure KVM's supported XSS as part of each vendor's setup
>> flow to fix a bug where clearing SHSTK and IBT in kvm_cpu_caps, e.g. due
>> to lack of CET XFEATURE support, makes kvm-intel.ko unloadable when nested
>> VMX is enabled, i.e. when nested=1.  The late clearing results in
>> nested_vmx_setup_{entry,exit}_ctls() clearing VM_{ENTRY,EXIT}_LOAD_CET_STATE
>> when nested_vmx_setup_ctls_msrs() runs during the CPU compatibility checks,
>> ultimately leading to a mismatched VMCS config due to the reference config
>> having the CET bits set, but every CPU's "local" config having the bits
>> cleared.
> 
> A bit confuse about the description.
> 
> Before this patch:
> 
> kvm_x86_vendor_init
> | vmx_hardware_setup
> |   nested_vmx_hardware_setup
> |     nested_vmx_setup_ctls_msrs
> | ...
> | for_each_online_cpu(cpu)
> |   smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1)
> |                                 | kvm_x86_check_processor_compatibility
> |                                 |   kvm_x86_call(check_processor_compatibility)()
> |                                 |     vmx_check_processor_compatibility
> |                                 |       setup_vmcs_config
> |                                 |         nested_vmx_setup_ctls_msrs
> | ...
> | //late clearing of SHSTK and IBT
> 
> If we don't consider CPU hotplug case, both the setup of reference VMCS and the
> local config are before the late clearing of SHSTK and IBT. They should be
> consistent.
> 
> So you are referring the mismatch situation during CPU hotplug?

I guess it's triggered the path

   kvm_init()
     kvm_init_virtualization()
       kvm_enable_virtualization()
         cpuhp_setup_state()
           kvm_online_cpu()
             ...

   (note, it requires enable_virt_at_load to be true)

which is after
   vmx_init()
     kvm_x86_vendor_init()

