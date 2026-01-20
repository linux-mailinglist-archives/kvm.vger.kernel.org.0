Return-Path: <kvm+bounces-68599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2176BD3C372
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A8DDA52011D
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2098436A002;
	Tue, 20 Jan 2026 09:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ZN/EZVh5"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63356258EE0;
	Tue, 20 Jan 2026 09:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900846; cv=none; b=dF2RzRsKXZLS3K4ft0Dp4gqQKeJ2f8a41VNS2Xs1QE/JOfg4dRZXB1yLQZwBXCLxYsEn8mFOeeeZlDgXYtZDMD7dJc9zfQjLlbNZlR5rpeO+NlnAnoVc3Qgh1I8Ps+sl8aFambVsoN6V/wD4fXUpaAByG74Yh2wAJaAhA0Es5BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900846; c=relaxed/simple;
	bh=zyQH4VwzAAYciwqAnveOM/oZEX06lZVhTtCSb8WY0PU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lgiUrhf/nB36AhGxtFMpK9JiTyM/Uw3zICl7RMYLRDZOtwZdVtIhXtKOEF7geoVdB1mf5icg3XL2saIB8XOqE7cUcaqp7l1VRbEucCkXvYgVcAwaraOTieyJ2Npid4/zomeLlETPYBlxDX0GKllfjdkwmLOQF56LYSJN5kY9gW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ZN/EZVh5; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60K9K5Hj3569621
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 20 Jan 2026 01:20:06 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60K9K5Hj3569621
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1768900807;
	bh=PawMxFO7fnNkcltmh/Uap0vgpCs1sS0yuavaz5i8pwg=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=ZN/EZVh5U533KNiVHFoO1jRh3khTMWRCPJ9YIG9IbNrdVl7TupTcPUqtpTSk8c39y
	 0nHAdUpEBqUg3kXqWR0Oih1aRwB4tOInxd2k84sLDgJutGjhdH69zsFqx9L8/tCwaF
	 GMKww+vakaEsJS1FgwJZEXnY7LOr42CZmerDWifiBRy6hc17WpNj8EXbRiKZSUvDJ9
	 GcETdXzN7gu+2U0QbpyWby0J3Uusn5Hvqq5t/qMqiq2Gr1uUiYiihtUCUXIfBAaPwz
	 eb6uXnybZm8HYdeRIvmzwvztoGlCwk6S9YierIdWTg+8mM1/W19DM8AO2jTnT1O2/n
	 Q1Y186gxARukQ==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 20/22] KVM: nVMX: Validate FRED-related VMCS fields
From: Xin Li <xin@zytor.com>
In-Reply-To: <aRVJucn5t5WjS2fe@intel.com>
Date: Tue, 20 Jan 2026 01:19:55 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <229A00D7-178E-47E4-B596-B467B2C66956@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-21-xin@zytor.com> <aRVJucn5t5WjS2fe@intel.com>
To: Chao Gao <chao.gao@intel.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)

>> @@ -3047,22 +3049,11 @@ static int =
nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>> u8 vector =3D intr_info & INTR_INFO_VECTOR_MASK;
>> u32 intr_type =3D intr_info & INTR_INFO_INTR_TYPE_MASK;
>> bool has_error_code =3D intr_info & INTR_INFO_DELIVER_CODE_MASK;
>> + bool has_nested_exception =3D vmx->nested.msrs.basic & =
VMX_BASIC_NESTED_EXCEPTION;
>=20
> has_error_code reflects whether the to-be-injected event has an error =
code.
> Using has_nested_exception for CPU capabilities here is a bit =
confusing.

Looks better to just remove has_error_code.

>=20
>> bool urg =3D nested_cpu_has2(vmcs12,
>>    SECONDARY_EXEC_UNRESTRICTED_GUEST);
>> bool prot_mode =3D !urg || vmcs12->guest_cr0 & X86_CR0_PE;
>>=20
>> - /* VM-entry interruption-info field: interruption type */
>> - if (CC(intr_type =3D=3D INTR_TYPE_RESERVED) ||
>> -     CC(intr_type =3D=3D INTR_TYPE_OTHER_EVENT &&
>> -        !nested_cpu_supports_monitor_trap_flag(vcpu)))
>> - return -EINVAL;
>> -
>> - /* VM-entry interruption-info field: vector */
>> - if (CC(intr_type =3D=3D INTR_TYPE_NMI_INTR && vector !=3D =
NMI_VECTOR) ||
>> -     CC(intr_type =3D=3D INTR_TYPE_HARD_EXCEPTION && vector > 31) ||
>> -     CC(intr_type =3D=3D INTR_TYPE_OTHER_EVENT && vector !=3D 0))
>> - return -EINVAL;
>> -
>> /*
>>  * Cannot deliver error code in real mode or if the interrupt
>>  * type is not hardware exception. For other cases, do the
>> @@ -3086,8 +3077,28 @@ static int =
nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>> if (CC(intr_info & INTR_INFO_RESVD_BITS_MASK))
>> return -EINVAL;
>>=20
>> - /* VM-entry instruction length */
>> + /*
>> +  * When the CPU enumerates VMX nested-exception support, bit 13
>> +  * (set to indicate a nested exception) of the intr info field
>> +  * may have value 1.  Otherwise bit 13 is reserved.
>> +  */
>> + if (CC(!(has_nested_exception && intr_type =3D=3D =
INTR_TYPE_HARD_EXCEPTION) &&
>> +        intr_info & INTR_INFO_NESTED_EXCEPTION_MASK))
>> + return -EINVAL;
>> +
>> switch (intr_type) {
>> + case INTR_TYPE_EXT_INTR:
>> + break;
>=20
> This can be dropped, as the "default" case will handle it.

We don=E2=80=99t have a default case, as all 8 cases are listed =
(INTR_INFO_INTR_TYPE_MASK is 0x700).

>=20
>> + case INTR_TYPE_RESERVED:
>> + return -EINVAL;
>=20
> I think we need to add a CC() statement to make it easier to correlate =
a
> VM-entry failure with a specific consistency check.

What do you want me to put in CC()?

CC(intr_type =3D=3D INTR_TYPE_RESERVED)?

>=20
>> + case INTR_TYPE_NMI_INTR:
>> + if (CC(vector !=3D NMI_VECTOR))
>> + return -EINVAL;
>> + break;
>> + case INTR_TYPE_HARD_EXCEPTION:
>> + if (CC(vector > 31))
>> + return -EINVAL;
>> + break;
>> case INTR_TYPE_SOFT_EXCEPTION:
>> case INTR_TYPE_SOFT_INTR:
>> case INTR_TYPE_PRIV_SW_EXCEPTION:
>> @@ -3095,6 +3106,24 @@ static int =
nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>>     CC(vmcs12->vm_entry_instruction_len =3D=3D 0 &&
>>     CC(!nested_cpu_has_zero_length_injection(vcpu))))
>> return -EINVAL;
>> + break;
>> + case INTR_TYPE_OTHER_EVENT:
>> + switch (vector) {
>> + case 0:
>> + if (CC(!nested_cpu_supports_monitor_trap_flag(vcpu)))
>> + return -EINVAL;
>=20
> Does this nested_cpu_supports_monitor_trap_flag() check apply to case =
1/2?

I did check the spec when writing the code but I will doublecheck.

>=20
>> + break;
>> + case 1:
>> + case 2:
>> + if (CC(!fred_enabled))
>> + return -EINVAL;
>> + if (CC(vmcs12->vm_entry_instruction_len > =
X86_MAX_INSTRUCTION_LENGTH))
>> + return -EINVAL;
>> + break;
>> + default:
>> + return -EINVAL;
>=20
> Again, I think -EINVAL should be accompanied by a CC() statement.
>=20
>> + }
>> + break;
>> }
>> }
>>=20
>> @@ -3213,9 +3242,29 @@ static int nested_vmx_check_host_state(struct =
kvm_vcpu *vcpu,
>> if (ia32e) {
>> if (CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
>> return -EINVAL;
>> + if (vmcs12->vm_exit_controls & VM_EXIT_ACTIVATE_SECONDARY_CONTROLS =
&&
>> +     vmcs12->secondary_vm_exit_controls & =
SECONDARY_VM_EXIT_LOAD_IA32_FRED) {
>> + if (CC(vmcs12->host_ia32_fred_config &
>> +        (BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2))) ||
>> +     CC(vmcs12->host_ia32_fred_rsp1 & GENMASK_ULL(5, 0)) ||
>> +     CC(vmcs12->host_ia32_fred_rsp2 & GENMASK_ULL(5, 0)) ||
>> +     CC(vmcs12->host_ia32_fred_rsp3 & GENMASK_ULL(5, 0)) ||
>> +     CC(vmcs12->host_ia32_fred_ssp1 & GENMASK_ULL(2, 0)) ||
>> +     CC(vmcs12->host_ia32_fred_ssp2 & GENMASK_ULL(2, 0)) ||
>> +     CC(vmcs12->host_ia32_fred_ssp3 & GENMASK_ULL(2, 0)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_config & =
PAGE_MASK, vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_rsp1, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_rsp2, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_rsp3, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_ssp1, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_ssp2, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->host_ia32_fred_ssp3, =
vcpu)))
>> + return -EINVAL;
>> + }
>> } else {
>> if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
>>     CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
>> +     CC(vmcs12->host_cr4 & X86_CR4_FRED) ||
>>     CC((vmcs12->host_rip) >> 32))
>> return -EINVAL;
>> }
>> @@ -3384,6 +3433,48 @@ static int nested_vmx_check_guest_state(struct =
kvm_vcpu *vcpu,
>>      CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
>> return -EINVAL;
>>=20
>> + if (ia32e) {
>> + if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_FRED) {
>> + if (CC(vmcs12->guest_ia32_fred_config &
>> +        (BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2))) ||
>> +     CC(vmcs12->guest_ia32_fred_rsp1 & GENMASK_ULL(5, 0)) ||
>> +     CC(vmcs12->guest_ia32_fred_rsp2 & GENMASK_ULL(5, 0)) ||
>> +     CC(vmcs12->guest_ia32_fred_rsp3 & GENMASK_ULL(5, 0)) ||
>> +     CC(vmcs12->guest_ia32_fred_ssp1 & GENMASK_ULL(2, 0)) ||
>> +     CC(vmcs12->guest_ia32_fred_ssp2 & GENMASK_ULL(2, 0)) ||
>> +     CC(vmcs12->guest_ia32_fred_ssp3 & GENMASK_ULL(2, 0)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_config & =
PAGE_MASK, vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_rsp1, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_rsp2, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_rsp3, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_ssp1, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_ssp2, =
vcpu)) ||
>> +     CC(is_noncanonical_msr_address(vmcs12->guest_ia32_fred_ssp3, =
vcpu)))
>> + return -EINVAL;
>> + }
>> + if (vmcs12->guest_cr4 & X86_CR4_FRED) {
>> + unsigned int ss_dpl =3D VMX_AR_DPL(vmcs12->guest_ss_ar_bytes);
>> + switch (ss_dpl) {
>> + case 0:
>> + if (CC(!(vmcs12->guest_cs_ar_bytes & VMX_AR_L_MASK)))
>> + return -EINVAL;
>> + break;
>> + case 1:
>> + case 2:
>> + return -EINVAL;
>=20
> Ditto.
>=20
>> + case 3:
>> + if (CC(vmcs12->guest_rflags & X86_EFLAGS_IOPL))
>> + return -EINVAL;
>> + if (CC(vmcs12->guest_interruptibility_info & GUEST_INTR_STATE_STI))
>> + return -EINVAL;
>> + break;
>> + }
>> + }
>> + } else {
>> + if (CC(vmcs12->guest_cr4 & X86_CR4_FRED))
>> + return -EINVAL;
>> + }
>> +
>> if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
>> if (nested_vmx_check_cet_state_common(vcpu, vmcs12->guest_s_cet,
>>       vmcs12->guest_ssp,
>> --=20
>> 2.51.0



