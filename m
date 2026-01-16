Return-Path: <kvm+bounces-68313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 77512D32AE6
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CD4130AF56F
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 14:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C302B3396F0;
	Fri, 16 Jan 2026 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WWkresjD"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988CD2264B0;
	Fri, 16 Jan 2026 14:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768573805; cv=none; b=MIlBkcEPnXuH92WBbwGeDyYSUhErQMfUlYqP9saJecajV2nbVJAykWhWezVCyOYHeXzJrcoCk73iBeLauRWFbfItHn5yZcQWJ9N4Un1t0DjW55nBDaUWst2c+e60th/ndO29Mlkr8URQn4AcvumR2qwjlacp/eDZ60h4s7Qe4t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768573805; c=relaxed/simple;
	bh=Ze8/tNVvQO7baDWI7fWfu7Bet/8G2e9QTRDyHU8fgn0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NSM5MQeTbf+AEptH2MEbTLq8R2gf2OeJvMZHcU+ZwqEggr4fOqAgrEyENOINKGXTWUcxcTe5IvWw/VmuLw2/aAmq8yBK6QFsnEaKQ/w38H3+jNy4FQFoiDOT9QkzOxLFvSZSxr+4jQINchk3zNQuvb7SibdLs5i27F0H/7zuIz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WWkresjD; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768573794; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=XnMbHiZD4Q8ihaJAYTR3qJJVShDyzERVKVSspF7MbMc=;
	b=WWkresjDY+kOIakHS+Ll9HuhWEMGMZq2hM/VOE18HFCgxoe24Zv+S/wQa8f9+vz1gYn0hjIxfx2HPn7WNf/U3oJQHLn40KaYy+eovkYiRS7bXzmmdOUwYxmpa9QiGPz7VgoQkx3neJtlI+/tGwRwPBO5Ulsdbk6vkTAJrW6glMU=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WxARSAt_1768573791 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Jan 2026 22:29:53 +0800
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
	rkrcmar@ventanamicro.com
Subject: Re: Re: [PATCH v2] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Date: Fri, 16 Jan 2026 22:29:47 +0800
Message-Id: <20260116142947.30520-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <dfhacs3uppweqmw5t6gwli2iy3b7l5oj6saykogjb5qkadl4rc@bi7mvnezkd2m>
References: <dfhacs3uppweqmw5t6gwli2iy3b7l5oj6saykogjb5qkadl4rc@bi7mvnezkd2m>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>
>> This capability allows userspace to explicitly select the HGATP mode
>> for the VM. The selected mode must be less than or equal to the max
>> HGATP mode supported by the hardware. This capability must be enabled
>> before creating any vCPUs, and can only be set once per VM.
>>
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>>  Documentation/virt/kvm/api.rst | 14 ++++++++++++++
>>  arch/riscv/kvm/vm.c            | 26 ++++++++++++++++++++++++--
>>  include/uapi/linux/kvm.h       |  1 +
>>  3 files changed, 39 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 01a3abef8abb..9e17788e3a9d 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -8765,6 +8765,20 @@ helpful if user space wants to emulate instructions which are not
>>  This capability can be enabled dynamically even if VCPUs were already
>>  created and are running.
>>
>> +7.47 KVM_CAP_RISCV_SET_HGATP_MODE
>> +---------------------------------
>> +
>> +:Architectures: riscv
>> +:Type: VM
>> +:Parameters: args[0] contains the requested HGATP mode
>> +:Returns: 0 on success, -EINVAL if arg[0] is outside the range of hgatp
>> +          modes supported by the hardware.
>> +
>> +This capability allows userspace to explicitly select the HGATP mode for
>> +the VM. The selected mode must be less than or equal to the maximum HGATP
>> +mode supported by the hardware. This capability must be enabled before
>> +creating any vCPUs, and can only be set once per VM.
>
>I think I would prefer a KVM_CAP_RISCV_SET_MAX_GPA type of capability. The
>reason is because, while one of the results of the max-gpa being set will
>be to set hgatp, there may be other reasons to track the guest's maximum
>physical address too and kvm userspace shouldn't need to think about each
>individually.

That makes sense, thanks.

>> +
>>  8. Other capabilities.
>>  ======================
>>
>> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
>> index 4b2156df40fc..e9275023a73a 100644
>> --- a/arch/riscv/kvm/vm.c
>> +++ b/arch/riscv/kvm/vm.c
>> @@ -202,6 +202,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_VM_GPA_BITS:
>>  		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
>>  		break;
>> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
>> +#ifdef CONFIG_64BIT
>> +		r = 1;
>> +#else/* CONFIG_32BIT */
>> +		r = 0;
>> +#endif
>
> r = IS_ENABLED(CONFIG_64BIT) ? 1 : 0;

Ack.

>> +		break;
>>  	default:
>>  		r = 0;
>>  		break;
>> @@ -212,12 +219,27 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>
>>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>  {
>> +	if (cap->flags)
>> +		return -EINVAL;
>
>add blank line

Ack, will add a blank line after the flags check.

>
>>  	switch (cap->cap) {
>>  	case KVM_CAP_RISCV_MP_STATE_RESET:
>> -		if (cap->flags)
>> -			return -EINVAL;
>>  		kvm->arch.mp_state_reset = true;
>>  		return 0;
>> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
>> +#ifdef CONFIG_64BIT
>> +		if (cap->args[0] < HGATP_MODE_SV39X4 ||
>> +			cap->args[0] > kvm_riscv_gstage_max_mode)
>> +			return -EINVAL;
>> +		if (kvm->arch.gstage_mode_initialized)
>> +			return 0;
>
>I think we want to return -EBUSY here and it should be documented where it
>already states "...can only be set once per VM"

Agreed.

>> +		kvm->arch.gstage_mode_initialized = true;
>
>In the previous patch I thought we were missing this, but I see now it
>means "user initialized". Let's rename it as such,
>
> gstage_mode_user_initialized

Agreed.

>> +		kvm->arch.kvm_riscv_gstage_mode = cap->args[0];
>> +		kvm->arch.kvm_riscv_gstage_pgd_levels = 3 +
>> +		    kvm->arch.kvm_riscv_gstage_mode - HGATP_MODE_SV39X4;
>> +		kvm_info("using SV%lluX4 G-stage page table format\n",
>> +			39 + (cap->args[0] - HGATP_MODE_SV39X4) * 9);
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
>
Thanks,
Fangyu

