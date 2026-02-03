Return-Path: <kvm+bounces-70014-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IC45KPcFgmmYNgMAu9opvQ
	(envelope-from <kvm+bounces-70014-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 15:28:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CB0DA8F8
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 15:28:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94A1D314B7C9
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 14:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B993A9603;
	Tue,  3 Feb 2026 14:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ACim2Y/O"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22E83A901D;
	Tue,  3 Feb 2026 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770128544; cv=none; b=XpDK16k46z89KFWwQRwMlnLkTugZvv5TPqVzClUYi6jsVHgWOmXH8dO9+Z8H4dhx2bZivAn0Dn0mmHBQHOFdkCl2AdImVzJr6k0JYYpUbxfxUOMEQ9nptAhmdsOCVjkQPUJ8wADTs67qOdQnThUbD1RFE7XVL6GjwBZrbLZE4w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770128544; c=relaxed/simple;
	bh=9OMtrySsAik6Ak+MHK9o5jJ7Q/IlwAgFk6z6a7uFFZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OnAXB/EeTAruXnYap21h8cNxCjNzfu6GiotO7oHRolOBPM/F6URxszRrAdEUDu8K4xCBW82Dy2p3Y4HkiFITSL/tCuOlDhB9t+hDglQKRL11CKwOeFRxAjPRfESf0zfuW7xyGkfJ3K728Q1U0ng9Q4s0jjo7lrhhBINuSX5M88w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ACim2Y/O; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770128533; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=nm8PIuhdmjvOUlssXNxbPqc5VUHCAA6PpVhh/L+a2hk=;
	b=ACim2Y/OATnsFtDLwuPVEACcOhSixFnmVk1rf4CKVkE8JNhW9idHDT5jlLMuIXuxInulwU5EOdig0XIymq0CIjEmmh1sjkuPMf9fQh2omHfaiG4yRyMnR8HCXUabfvPdHxl3rekqgF5SCRldQ2fl9Tty1DI4lFplwhyfJ/SJazk=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyTLON._1770128530 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Feb 2026 22:22:12 +0800
From: fangyu.yu@linux.alibaba.com
To: andrew.jones@oss.qualcomm.com
Cc: ajones@ventanamicro.com,
	alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	corbet@lwn.net,
	fangyu.yu@linux.alibaba.com,
	guoren@kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pbonzini@redhat.com,
	pjw@kernel.org,
	radim.krcmar@oss.qualcomm.com,
	rkrcmar@ventanamicro.com
Subject: Re: Re: [PATCH v4 3/4] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Date: Tue,  3 Feb 2026 22:22:10 +0800
Message-Id: <20260203142210.98862-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <73zrxri5snnenmezjxrdorbcsps4dlvtrkvkq3w4ain4ggbxdl@hjw4u73msaro>
References: <73zrxri5snnenmezjxrdorbcsps4dlvtrkvkq3w4ain4ggbxdl@hjw4u73msaro>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70014-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NO_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[19];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: 49CB0DA8F8
X-Rspamd-Action: no action

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> 
>> Add a VM capability that allows userspace to select the G-stage page table
>> format by setting HGATP.MODE on a per-VM basis.
>> 
>> Userspace enables the capability via KVM_ENABLE_CAP, passing the requested
>> HGATP.MODE in args[0]. The request is rejected with -EINVAL if the mode is
>> not supported by the host, and with -EBUSY if the VM has already been
>> committed (e.g. vCPUs have been created or any memslot is populated).
>> 
>> KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE) returns a bitmask of the
>> HGATP.MODE formats supported by the host.
>> 
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>>  Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
>>  arch/riscv/kvm/vm.c            | 20 ++++++++++++++++++--
>>  include/uapi/linux/kvm.h       |  1 +
>>  3 files changed, 46 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 01a3abef8abb..1a0c5ddacae8 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -8765,6 +8765,33 @@ helpful if user space wants to emulate instructions which are not
>>  This capability can be enabled dynamically even if VCPUs were already
>>  created and are running.
>>  
>> +7.47 KVM_CAP_RISCV_SET_HGATP_MODE
>> +---------------------------------
>> +
>> +:Architectures: riscv
>
>If we only want this to work for rv64, then we should write riscv64 here,
>but, as I said in the last patch, I think we can just support rv32 too
>by supporting its one and only mode.

Agreed.

I'll update the documentation to list ":Architectures: riscv" and make the
capability available on both RV32 and RV64. For RV32, userspace will be
able to select the single supported G-stage mode (Sv32x4)

>> +:Type: VM
>> +:Parameters: args[0] contains the requested HGATP mode
>> +:Returns:
>> +  - 0 on success.
>> +  - -EINVAL if args[0] is outside the range of HGATP modes supported by the
>> +    hardware.
>> +  - -EBUSY if vCPUs have already been created for the VM, if the VM has any
>> +    non-empty memslots.
>> +
>> +This capability allows userspace to explicitly select the HGATP mode for
>> +the VM. The selected mode must be supported by both KVM and hardware. This
>> +capability must be enabled before creating any vCPUs or memslots.
>
>We should write what happens if the capability (setting the mode) is not
>done, i.e. what's the default mode.

Good point.
I'll update the documentation to explicitly state the default behavior when
KVM_CAP_RISCV_SET_HGATP_MODE is not used: KVM will auto-select the HGATP
G-stage mode during VM initialization. In other words, userspace only needs
to set the capability when it wants to override the default auto-selection.

>> +
>> +``KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE)`` returns a bitmask of
>> +HGATP.MODE values supported by the host. A return value of 0 indicates that
>> +the capability is not supported.
>> +
>> +The returned bitmask uses the following bit positions::
>> +
>> +  bit 0: HGATP.MODE = SV39X4
>> +  bit 1: HGATP.MODE = SV48X4
>> +  bit 2: HGATP.MODE = SV57X4
>
>Could write something along the lines of the UAPI having the bit
>definitions rather than duplicating that information here.
>

Sure. I'll rework this section.

>> +
>>  8. Other capabilities.
>>  ======================
>>  
>> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
>> index 4b2156df40fc..3bbbcb6a17a6 100644
>> --- a/arch/riscv/kvm/vm.c
>> +++ b/arch/riscv/kvm/vm.c
>> @@ -202,6 +202,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_VM_GPA_BITS:
>>  		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
>>  		break;
>> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
>> +		r = kvm_riscv_get_hgatp_mode_mask();
>> +		break;
>>  	default:
>>  		r = 0;
>>  		break;
>> @@ -212,12 +215,25 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  
>>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>  {
>> +	if (cap->flags)
>> +		return -EINVAL;
>> +
>>  	switch (cap->cap) {
>>  	case KVM_CAP_RISCV_MP_STATE_RESET:
>> -		if (cap->flags)
>> -			return -EINVAL;
>>  		kvm->arch.mp_state_reset = true;
>>  		return 0;
>> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
>> +#ifdef CONFIG_64BIT
>> +		if (!kvm_riscv_hgatp_mode_is_valid(cap->args[0]))
>> +			return -EINVAL;
>> +
>> +		if (kvm->created_vcpus || !kvm_are_all_memslots_empty(kvm))
>> +			return -EBUSY;
>> +
>> +		kvm->arch.kvm_riscv_gstage_pgd_levels =
>> +				3 + cap->args[0] - HGATP_MODE_SV39X4;
>> +#endif
>> +		return 0;
>>  	default:
>>  		return -EINVAL;
>>  	}
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index dddb781b0507..00c02a880518 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -974,6 +974,7 @@ struct kvm_enable_cap {
>>  #define KVM_CAP_GUEST_MEMFD_FLAGS 244
>>  #define KVM_CAP_ARM_SEA_TO_USER 245
>>  #define KVM_CAP_S390_USER_OPEREXEC 246
>> +#define KVM_CAP_RISCV_SET_HGATP_MODE 247
>>  
>>  struct kvm_irq_routing_irqchip {
>>  	__u32 irqchip;
>> -- 
>> 2.50.1
>>
>
>Thanks,
>drew

Thanks,
Fangyu

