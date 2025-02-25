Return-Path: <kvm+bounces-39138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D52BEA4478E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5F163B04C2
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A539192590;
	Tue, 25 Feb 2025 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="KTHbfxfH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C6021ABC6;
	Tue, 25 Feb 2025 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740503084; cv=none; b=pk7qhEzS1Mt4v3DhRV0TH2/JRRG3im2JVhXyMqh8Y1h0VnF7y81Q42Ec18aqgD9lBZJoIG0sAMM9FX1LbaOZBPH4tMs7ysNvZFf6nQLsWQjPsf94yTZKBwC0A5B6dfPM0/c+6d0zpRSZ+Fj9kfXZ8hIGNHCsLOOkobzb6GfBETA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740503084; c=relaxed/simple;
	bh=wrlipsiZZjYsoy8gKMde6E5ZGT5GjgE+1/Jv+3wci9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xf17j7X6QfTFdIAtWVKYjCSncDLtbLEWurr1P4tkTT5vHwUWKXOghr/NlZi8sI/2xTDqjl965qze7YQtxfdScwWBG6foDOdKjBB3ZVLR4VcibVA6AQgRmnWc/j8m+KoyZo8bFJ8W5dQdTQf+9WkWOkDnBbkGmC/n4HvwW5MW8ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=KTHbfxfH; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 51PH46bx1358733
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 25 Feb 2025 09:04:06 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 51PH46bx1358733
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025021701; t=1740503048;
	bh=BvjjSxkdSG588SGDq663b5zgI3A2wVYCsffSGqh15mo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KTHbfxfH1WLXIAc0WPB5ZGGR//14iUV+4iehEsJ3HZEjn0Zb3xlHeW9MjJpko8qqA
	 7JFYo96FeqJnm0VptIEAaG0ntvzMf6GNcTCYjspwKt5+WuYUQiC6yWNVugT9WndX2G
	 7fnmqq8Fg8UScSHeJ7MkPi4Z02c1NQTicNPtAE861FP4eT5mL5PAHQe6n2MdfWWx6V
	 9EhE8CezjUi4wEEFVjeuenRHTRgpU8l8oM9HSi9MxSHBPL9keYSXDbR4l7xLZBJq8g
	 6Atm5sIXT8Whgete15Y7jvVLoL0HKVu2YuyCHlFOzqvsZZwEHTstqpgUvIjCmIF5w8
	 sYCG8Ylu0bXsg==
Message-ID: <b1f0f8f3-515f-4fde-b779-43ef93484ab3@zytor.com>
Date: Tue, 25 Feb 2025 09:04:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/27] Enable FRED with KVM VMX
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
        pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com
References: <20241001050110.3643764-1-xin@zytor.com>
 <22d4574b-7e2d-4cd8-91bd-f5208e82369e@zytor.com>
 <Z73gxklugkYpwJiZ@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <Z73gxklugkYpwJiZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/2025 7:24 AM, Sean Christopherson wrote:
> On Tue, Feb 18, 2025, Xin Li wrote:
>> On 9/30/2024 10:00 PM, Xin Li (Intel) wrote:
>> While I'm waiting for the CET patches for native Linux and KVM to be
>> upstreamed, do you think if it's worth it for you to take the cleanup
>> and some of the preparation patches first?
> 
> Yes, definitely.  I'll go through the series and see what I can grab now.

I planned to do a rebase and fix the conflicts due to the reordering.
But I'm more than happy you do a first round.

BTW, if you plan to take
	KVM: VMX: Virtualize nested exception tracking
Then as Gao Chao suggested we also need a patch to Save/restore the
nested flag of an exception (obviously a corresponding host patch is
needed).  Following is a version that I have.

Thanks!
     Xin

---
KVM: x86: Save/restore the nested flag of an exception

Save/restore the nested flag of an exception during VM save/restore
and live migration to ensure a correct event stack level is chosen
when a nested exception is injected through FRED event delivery.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Change since v3:
* Add live migration support for exception nested flag (Chao Gao).
---
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b52eb77e29c..ed171fa6926f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1180,6 +1180,10 @@ The following bits are defined in the flags field:
    fields contain a valid state. This bit will be set whenever
    KVM_CAP_EXCEPTION_PAYLOAD is enabled.

+- KVM_VCPUEVENT_VALID_NESTED_FLAG may be set to inform that the
+  exception is a nested exception. This bit will be set whenever
+  KVM_CAP_EXCEPTION_NESTED_FLAG is enabled.
+
  - KVM_VCPUEVENT_VALID_TRIPLE_FAULT may be set to signal that the
    triple_fault_pending field contains a valid state. This bit will
    be set whenever KVM_CAP_X86_TRIPLE_FAULT_EVENT is enabled.
@@ -1279,6 +1283,10 @@ can be set in the flags field to signal that the
  exception_has_payload, exception_payload, and exception.pending fields
  contain a valid state and shall be written into the VCPU.

+If KVM_CAP_EXCEPTION_NESTED_FLAG is enabled, 
KVM_VCPUEVENT_VALID_NESTED_FLAG
+can be set in the flags field to inform that the exception is a nested
+exception and exception_is_nested shall be written into the VCPU.
+
  If KVM_CAP_X86_TRIPLE_FAULT_EVENT is enabled, 
KVM_VCPUEVENT_VALID_TRIPLE_FAULT
  can be set in flags field to signal that the triple_fault field contains
  a valid state and shall be written into the VCPU.
@@ -8258,6 +8266,17 @@ KVM exits with the register state of either the 
L1 or L2 guest
  depending on which executed at the time of an exit. Userspace must
  take care to differentiate between these cases.

+7.37 KVM_CAP_EXCEPTION_NESTED_FLAG
+----------------------------------
+
+:Architectures: x86
+:Parameters: args[0] whether feature should be enabled or not
+
+With this capability enabled, an exception is save/restored with the
+additional information of whether it was nested or not. FRED event
+delivery uses this information to ensure a correct event stack level
+is chosen when a VM entry injects a nested exception.
+
  8. Other capabilities.
  ======================

diff --git a/arch/x86/include/asm/kvm_host.h 
b/arch/x86/include/asm/kvm_host.h
index 4cfe1b8f4547..ede2319cee45 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1441,6 +1441,7 @@ struct kvm_arch {

  	bool guest_can_read_msr_platform_info;
  	bool exception_payload_enabled;
+	bool exception_nested_flag_enabled;

  	bool triple_fault_event;

diff --git a/arch/x86/include/uapi/asm/kvm.h 
b/arch/x86/include/uapi/asm/kvm.h
index 9e75da97bce0..f5167e3a7d0f 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -326,6 +326,7 @@ struct kvm_reinject_control {
  #define KVM_VCPUEVENT_VALID_SMM		0x00000008
  #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
  #define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
+#define KVM_VCPUEVENT_VALID_NESTED_FLAG	0x00000040

  /* Interrupt shadow states */
  #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -363,7 +364,8 @@ struct kvm_vcpu_events {
  	struct {
  		__u8 pending;
  	} triple_fault;
-	__u8 reserved[26];
+	__u8 reserved[25];
+	__u8 exception_is_nested;
  	__u8 exception_has_payload;
  	__u64 exception_payload;
  };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01c945b27f01..80a9fa6ab720 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4675,6 +4675,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
long ext)
  	case KVM_CAP_GET_MSR_FEATURES:
  	case KVM_CAP_MSR_PLATFORM_INFO:
  	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_EXCEPTION_NESTED_FLAG:
  	case KVM_CAP_X86_TRIPLE_FAULT_EVENT:
  	case KVM_CAP_SET_GUEST_DEBUG:
  	case KVM_CAP_LAST_CPU:
@@ -5401,6 +5402,7 @@ static void 
kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
  	events->exception.error_code = ex->error_code;
  	events->exception_has_payload = ex->has_payload;
  	events->exception_payload = ex->payload;
+	events->exception_is_nested = ex->nested;

  	events->interrupt.injected =
  		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
@@ -5426,6 +5428,8 @@ static void 
kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
  			 | KVM_VCPUEVENT_VALID_SMM);
  	if (vcpu->kvm->arch.exception_payload_enabled)
  		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
+	if (vcpu->kvm->arch.exception_nested_flag_enabled)
+		events->flags |= KVM_VCPUEVENT_VALID_NESTED_FLAG;
  	if (vcpu->kvm->arch.triple_fault_event) {
  		events->triple_fault.pending = 
kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
  		events->flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
@@ -5440,7 +5444,8 @@ static int 
kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
  			      | KVM_VCPUEVENT_VALID_SHADOW
  			      | KVM_VCPUEVENT_VALID_SMM
  			      | KVM_VCPUEVENT_VALID_PAYLOAD
-			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT))
+			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT
+			      | KVM_VCPUEVENT_VALID_NESTED_FLAG))
  		return -EINVAL;

  	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -5455,6 +5460,13 @@ static int 
kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
  		events->exception_has_payload = 0;
  	}

+	if (events->flags & KVM_VCPUEVENT_VALID_NESTED_FLAG) {
+		if (!vcpu->kvm->arch.exception_nested_flag_enabled)
+			return -EINVAL;
+	} else {
+		events->exception_is_nested = 0;
+	}
+
  	if ((events->exception.injected || events->exception.pending) &&
  	    (events->exception.nr > 31 || events->exception.nr == NMI_VECTOR))
  		return -EINVAL;
@@ -5486,6 +5498,7 @@ static int 
kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
  	vcpu->arch.exception.error_code = events->exception.error_code;
  	vcpu->arch.exception.has_payload = events->exception_has_payload;
  	vcpu->arch.exception.payload = events->exception_payload;
+	vcpu->arch.exception.nested = events->exception_is_nested;

  	vcpu->arch.interrupt.injected = events->interrupt.injected;
  	vcpu->arch.interrupt.nr = events->interrupt.nr;
@@ -6609,6 +6622,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
  		kvm->arch.exception_payload_enabled = cap->args[0];
  		r = 0;
  		break;
+	case KVM_CAP_EXCEPTION_NESTED_FLAG:
+		kvm->arch.exception_nested_flag_enabled = cap->args[0];
+		r = 0;
+		break;
  	case KVM_CAP_X86_TRIPLE_FAULT_EVENT:
  		kvm->arch.triple_fault_event = cap->args[0];
  		r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 45e6d8fca9b9..b79f3c10a887 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -929,6 +929,7 @@ struct kvm_enable_cap {
  #define KVM_CAP_PRE_FAULT_MEMORY 236
  #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
  #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_EXCEPTION_NESTED_FLAG 239

  struct kvm_irq_routing_irqchip {
  	__u32 irqchip;


> 
> Thanks!
> 
>> Top of my mind are:
>>      KVM: x86: Use a dedicated flow for queueing re-injected exceptions
>>      KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
>>      KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM
>>      KVM: nVMX: Add a prerequisite to existence of VMCS fields
>>      KVM: nVMX: Add a prerequisite to SHADOW_FIELD_R[OW] macros
>>
>> Then specially, the nested exception tracking patch seems a good one as
>> Chao Gao suggested to decouple the nested tracking from FRED:
>>      KVM: VMX: Virtualize nested exception tracking
>>
>> Lastly the patches to add support for the secondary VM exit controls might
>> go in early as well:
>>      KVM: VMX: Add support for the secondary VM exit controls
>>      KVM: nVMX: Add support for the secondary VM exit controls
>>
>> But if you don't like the idea please just let me know.
>>
>> Thanks!
>>      Xin
> 



