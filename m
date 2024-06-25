Return-Path: <kvm+bounces-20454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7806915F36
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 09:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D35DB22C58
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 07:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757CB146A61;
	Tue, 25 Jun 2024 07:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nfEVRvUi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ECC146593;
	Tue, 25 Jun 2024 07:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719298867; cv=none; b=G0brDoqownTrtqod8I680E6RhhWvtkIII4ZOV/dR3bOWwoNVTMTLfF5OEW2eqIKb3PnoyBb6TsOUXzj4BTQTpMVp1YAHcPCNiMw+WhW6KFWSetQNYG6wWIasmHGDufaEhjqds6my6wIZgN6b8uHCD+cl/tMXr7wUfXP8BO1wn+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719298867; c=relaxed/simple;
	bh=xeepw0436JvXkF7t5SqHEVBLg8MBJ44psADaGMG57fA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=otbDbUAq58YCXk2gbD8p+OFiB8o3tpkga+mhdIc/pBLgZPIoBR1TyeZDo0rxVZoChnKB67ag4AWgK2ZrrG5T9Dc9oqSBU2W8HFfaIaarS+C75HCgXhHUNrnpNfHLin28OITjNUOs9p0Q8mZameHZ2J3zzPLQBzLwIN/5GXB0nR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nfEVRvUi; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719298866; x=1750834866;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=xeepw0436JvXkF7t5SqHEVBLg8MBJ44psADaGMG57fA=;
  b=nfEVRvUiK9DOzEnBaZp54IwYnfRxCTZI/EtC5ryRAKN1gEwj37dce5Aj
   RKlDggrBLuxNOWmJUKG5FMx9dZquRv9J9WwyJeRnjfTU+SudNHh4nuDWu
   rP+jKphl12pUT98+hKEUy/WPgfbtV+BcjU8MfLe6YfK0BoK2Ssw5Emqzd
   GV0r9SMMgo6nhXsNAFKh6qVAav2euQr58RbTycQlFDQslX44Mts3rqKCF
   v3EbR4VxZQ0EzMZGYgyPtGxi04loS9VnU946+LGUP6Km+3R37NmrZaLLl
   Njx7/LLeqQuMn/YIM58DHgxToGiopYqfSgX7btnhUzSH+ht+AZwnKeXaR
   A==;
X-CSE-ConnectionGUID: RsPtHC17R5ClF8dH9X8Sow==
X-CSE-MsgGUID: MT3QWbYRSqSyuvlw+Q/wyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="26986978"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="26986978"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 00:01:05 -0700
X-CSE-ConnectionGUID: dcJs2ek7QNSojUybXKCtVg==
X-CSE-MsgGUID: B/o0JsmDTmirdHG4WG967Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="43614242"
Received: from qunyang-mobl1.ccr.corp.intel.com (HELO [10.238.2.59]) ([10.238.2.59])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 00:01:02 -0700
Message-ID: <7fb2b31e-3c4b-4092-a60b-92aaa43821ae@linux.intel.com>
Date: Tue, 25 Jun 2024 15:00:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
From: Binbin Wu <binbin.wu@linux.intel.com>
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
 <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
Content-Language: en-US
In-Reply-To: <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/25/2024 2:54 PM, Binbin Wu wrote:
>
>
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Export kvm_io_bus_read and kvm_mmio tracepoint and wire up TDX PV MMIO
>> hypercall to the KVM backend functions.
>>
>> kvm_io_bus_read/write() searches KVM device emulated in kernel of the 
>> given
>> MMIO address and emulates the MMIO.  As TDX PV MMIO also needs it, 
>> export
>> kvm_io_bus_read().  kvm_io_bus_write() is already exported.  TDX PV MMIO
>> emulates some of MMIO itself.  To add trace point consistently with x86
>> kvm, export kvm_mmio tracepoint.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/vmx/tdx.c | 114 +++++++++++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/x86.c     |   1 +
>>   virt/kvm/kvm_main.c    |   2 +
>>   3 files changed, 117 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 55fc6cc6c816..389bb95d2af0 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -1217,6 +1217,118 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>>       return ret;
>>   }
>>   +static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
>> +{
>> +    unsigned long val = 0;
>> +    gpa_t gpa;
>> +    int size;
>> +
>> +    KVM_BUG_ON(vcpu->mmio_needed != 1, vcpu->kvm);
>> +    vcpu->mmio_needed = 0;
> mmio_needed is used by instruction emulator to setup the complete 
> callback.
> Since TDX handle MMIO in a PV way, mmio_needed is not needed here.
>
>> +
>> +    if (!vcpu->mmio_is_write) {
> It's also needed by instruction emulator, we can use 
> vcpu->run->mmio.is_write instead.
>
>> +        gpa = vcpu->mmio_fragments[0].gpa;
>> +        size = vcpu->mmio_fragments[0].len;
>
> Since MMIO cross page boundary is not allowed according to the input 
> checks from TDVMCALL, these mmio_fragments[] is not needed.
> Just use vcpu->run->mmio.phys_addr and vcpu->run->mmio.len?
>
>> +
>> +        memcpy(&val, vcpu->run->mmio.data, size);
>> +        tdvmcall_set_return_val(vcpu, val);
>> +        trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
>> +    }
>
> Tracepoint for KVM_TRACE_MMIO_WRITE is missing when it is handled in 
> userspace.
>
> Also, the return code is only set when the emulation is done in 
> kernel, but not set when it's handled in userspace.
>
>> +    return 1;
>> +}
>
> How about the fixup as following:
>
> @@ -1173,19 +1173,18 @@ static int tdx_emulate_io(struct kvm_vcpu 
> *vcpu) static int tdx_complete_mmio(struct kvm_vcpu *vcpu) { unsigned 
> long val = 0; - gpa_t gpa; - int size; - - vcpu->mmio_needed = 0; - - 
> if (!vcpu->mmio_is_write) { - gpa = vcpu->mmio_fragments[0].gpa; - 
> size = vcpu->mmio_fragments[0].len; + gpa_t gpa = 
> vcpu->run->mmio.phys_addr; + int size = vcpu->run->mmio.len; + if 
> (vcpu->run->mmio.is_write) { + trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, 
> size, gpa, &val); + } else { memcpy(&val, vcpu->run->mmio.data, size); 
> tdvmcall_set_return_val(vcpu, val); 
> trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val); } + + 
> tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS); return 1; }
>
Sorry for the mess.

@@ -1173,19 +1173,18 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
  static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
  {
         unsigned long val = 0;
-       gpa_t gpa;
-       int size;
-
-       vcpu->mmio_needed = 0;
-
-       if (!vcpu->mmio_is_write) {
-               gpa = vcpu->mmio_fragments[0].gpa;
-               size = vcpu->mmio_fragments[0].len;
+       gpa_t gpa = vcpu->run->mmio.phys_addr;
+       int size = vcpu->run->mmio.len;

+       if (vcpu->run->mmio.is_write) {
+               trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
+       } else {
                 memcpy(&val, vcpu->run->mmio.data, size);
                 tdvmcall_set_return_val(vcpu, val);
                 trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
         }
+
+       tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
         return 1;
  }

>
>
>> +
>> +static inline int tdx_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, 
>> int size,
>> +                 unsigned long val)
>> +{
>> +    if (kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, gpa, size, 
>> &val) &&
>> +        kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
>> +        return -EOPNOTSUPP;
>> +
>> +    trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
>> +    return 0;
>> +}
>> +
>> +static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, 
>> int size)
>> +{
>> +    unsigned long val;
>> +
>> +    if (kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev, gpa, size, 
>> &val) &&
>> +        kvm_io_bus_read(vcpu, KVM_MMIO_BUS, gpa, size, &val))
>> +        return -EOPNOTSUPP;
>> +
>> +    tdvmcall_set_return_val(vcpu, val);
>> +    trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
>> +    return 0;
>> +}
>> +
>> +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm_memory_slot *slot;
>> +    int size, write, r;
>> +    unsigned long val;
>> +    gpa_t gpa;
>> +
>> +    KVM_BUG_ON(vcpu->mmio_needed, vcpu->kvm);
>> +
> [...]
>> +
>> +    /* Request the device emulation to userspace device model. */
>> +    vcpu->mmio_needed = 1;
>> +    vcpu->mmio_is_write = write;
> Then they can be dropped.
>
>
>> +    vcpu->arch.complete_userspace_io = tdx_complete_mmio;
>> +
>> +    vcpu->run->mmio.phys_addr = gpa;
>> +    vcpu->run->mmio.len = size;
>> +    vcpu->run->mmio.is_write = write;
>> +    vcpu->run->exit_reason = KVM_EXIT_MMIO;
>> +
>> +    if (write) {
>> +        memcpy(vcpu->run->mmio.data, &val, size);
>> +    } else {
>> +        vcpu->mmio_fragments[0].gpa = gpa;
>> +        vcpu->mmio_fragments[0].len = size;
> These two lines can be dropped as well.
>
>> + trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL);
>> +    }
>> +    return 0;
>> +
>> +error:
>> +    tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
>> +    return 1;
>> +}
>> +
>
> - /* Request the device emulation to userspace device model. */ - 
> vcpu->mmio_needed = 1; - vcpu->mmio_is_write = write; 
> vcpu->arch.complete_userspace_io = tdx_complete_mmio; 
> vcpu->run->mmio.phys_addr = gpa; @@ -1265,13 +1272,11 @@ static int 
> tdx_emulate_mmio(struct kvm_vcpu *vcpu) vcpu->run->mmio.is_write = 
> write; vcpu->run->exit_reason = KVM_EXIT_MMIO; - if (write) { + if 
> (write) memcpy(vcpu->run->mmio.data, &val, size); - } else { - 
> vcpu->mmio_fragments[0].gpa = gpa; - vcpu->mmio_fragments[0].len = 
> size; + else trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, 
> gpa, NULL); - } + return 0;
>
>
>
-       /* Request the device emulation to userspace device model. */
-       vcpu->mmio_needed = 1;
-       vcpu->mmio_is_write = write;
         vcpu->arch.complete_userspace_io = tdx_complete_mmio;

         vcpu->run->mmio.phys_addr = gpa;
@@ -1265,13 +1272,11 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
         vcpu->run->mmio.is_write = write;
         vcpu->run->exit_reason = KVM_EXIT_MMIO;

-       if (write) {
+       if (write)
                 memcpy(vcpu->run->mmio.data, &val, size);
-       } else {
-               vcpu->mmio_fragments[0].gpa = gpa;
-               vcpu->mmio_fragments[0].len = size;
+       else
                 trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, 
gpa, NULL);
-       }
+
         return 0;

