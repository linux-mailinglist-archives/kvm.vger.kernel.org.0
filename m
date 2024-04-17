Return-Path: <kvm+bounces-14921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 208CB8A7AD9
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 05:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE5C71F22548
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 03:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3EE7BA46;
	Wed, 17 Apr 2024 03:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g8jRRMsN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F3E7470;
	Wed, 17 Apr 2024 03:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713323114; cv=none; b=paaVGVdZBJCCC82UtSR4150Cf44ZezPY5/O3uMvprRTcuB+9q4kJbVnfKfVcwVAtKzAv0sInJOOakq49zYFQO4S56Vs4F60gmalYwpIUdY2brWzF+sjqqERo5c5Y1CKHXbvRAv1GtIY8+yJ0rwlOdnR33PDLCWLBiCj4ngqQWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713323114; c=relaxed/simple;
	bh=Ba8ZIoV9AFjElPasNWGPuIvN3p9BEsdOKGL+1Iz5T/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q8UiUuA0Wikd/sKQ1/ZqQenBQw+S1e19IycWwlo0NwvXnZeGEndwUxRY+qWBwCtl4GZrWxxxFCOxiWRSfPln62mcUVc2inwEoTDZo5G9qmOESmsvIvYRVo+cOv+HMyqNPw2PsmMkx6VYRVkPEMaHeuawbrxiZ6WbqfHxqRALNLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g8jRRMsN; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713323113; x=1744859113;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ba8ZIoV9AFjElPasNWGPuIvN3p9BEsdOKGL+1Iz5T/A=;
  b=g8jRRMsN7piMUDpL8INLkA2KzJfiuPcLICBPb7MXvkkWvdA4zr+3H2VT
   COTHMjk3Jk1D/j/6AFsP4PSa+ibutYFHV/nOxeRL561Sz8WCQZUrIf+MZ
   4vlkTHjyAdJUufPLbf+TrnHM08oPgp8++M5PoaJXFUrdbq32fy0Edg/Ej
   2gPmhyoYdhbCT7z/+qjM9WzSMVY0b6aEEd26CPv3RtZfw6o3bihS61JlB
   +LSopdW9O8eGjVhlQlROIqb57bsial8jo3PIJGDN/K5m+keZ3WXsBczMB
   o6QAwrM6rbcpQ0AA1qaCXGoFdrtHPN5Mglpv3zKpM83Q9VS+1LgItLOEZ
   w==;
X-CSE-ConnectionGUID: u8pyolaaTLGZsvIQVEu74w==
X-CSE-MsgGUID: D67qaksMQMCsxWV70T6lHA==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8720974"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="8720974"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 20:05:11 -0700
X-CSE-ConnectionGUID: dp/KWL6bRM+0UBrKHB5CAQ==
X-CSE-MsgGUID: foXm7HnxRJ6HTGS9uHWSEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22549772"
Received: from unknown (HELO [10.238.13.36]) ([10.238.13.36])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 20:05:07 -0700
Message-ID: <ac0e50a6-6da4-4e07-8422-0e9f477c3fb3@linux.intel.com>
Date: Wed, 17 Apr 2024 11:05:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 102/130] KVM: TDX: handle EXCEPTION_NMI and
 EXTERNAL_INTERRUPT
To: Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <3ac413f1d4adbac7db88a2cade97ded3b076c540.1708933498.git.isaku.yamahata@intel.com>
 <ZgpuqJW365ZfuJao@chao-email>
 <20240403185103.GK2444378@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240403185103.GK2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/4/2024 2:51 AM, Isaku Yamahata wrote:
> On Mon, Apr 01, 2024 at 04:22:00PM +0800,
> Chao Gao <chao.gao@intel.com> wrote:
>
>> On Mon, Feb 26, 2024 at 12:26:44AM -0800, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> Because guest TD state is protected, exceptions in guest TDs can't be
>>> intercepted.  TDX VMM doesn't need to handle exceptions.
>>> tdx_handle_exit_irqoff() handles NMI and machine check.  Ignore NMI and
>> tdx_handle_exit_irqoff() doesn't handle NMIs.
> Will it to tdx_handle_exception().

I don't get  why tdx_handle_exception()?

NMI is handled in tdx_vcpu_enter_exit() prior to leaving the safety of 
noinstr, according to patch 098.
https://lore.kernel.org/kvm/88920c598dcb55c15219642f27d0781af6d0c044.1708933498.git.isaku.yamahata@intel.com/

@@ -837,6 +857,12 @@ static noinstr void tdx_vcpu_enter_exit(struct 
vcpu_tdx *tdx)
      WARN_ON_ONCE(!kvm_rebooting &&
               (tdx->exit_reason.full & TDX_SW_ERROR) == TDX_SW_ERROR);

+    if ((u16)tdx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
+        is_nmi(tdexit_intr_info(vcpu))) {
+        kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
+        vmx_do_nmi_irqoff();
+        kvm_after_interrupt(vcpu);
+    }
      guest_state_exit_irqoff();
  }

>
>
>>> machine check and continue guest TD execution.
>>>
>>> For external interrupt, increment stats same to the VMX case.
>>>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>> arch/x86/kvm/vmx/tdx.c | 23 +++++++++++++++++++++++
>>> 1 file changed, 23 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index 0db80fa020d2..bdd74682b474 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -918,6 +918,25 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>>> 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
>>> }
>>>
>>> +static int tdx_handle_exception(struct kvm_vcpu *vcpu)

Should this function be named as tdx_handle_exception_nmi() since it's 
checking nmi as well?

>>> +{
>>> +	u32 intr_info = tdexit_intr_info(vcpu);
>>> +
>>> +	if (is_nmi(intr_info) || is_machine_check(intr_info))
>>> +		return 1;
>>


