Return-Path: <kvm+bounces-70283-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gAaqAUTyg2mGwAMAu9opvQ
	(envelope-from <kvm+bounces-70283-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:28:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 628F6EDA81
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 02:28:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 963293015D20
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 01:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0ED28B7DA;
	Thu,  5 Feb 2026 01:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kQJPMdJM"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD06621ADB7;
	Thu,  5 Feb 2026 01:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770254903; cv=none; b=JRsI8LTPV/BnTX7REVF5LDryAuol4sXq1askbQ7SZ4xokZfVnxRK+bn14aWNwC/Zzs4ivi7nHuxyiSTOmCHmCYXPR4my82IstNLHT6Q6QiBMjG7zeKHsmHonI8m7Z5D3+Xwg6PhWo9fHBAuMYU3EH6dMUyP3RikOb5Cbd0awF/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770254903; c=relaxed/simple;
	bh=U6I0qix+enFlE4sbK3k8XgOzt02MZF0j3tf/bMnHaig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iNV74Df9Qg+u4SBjFnMRfDGQm+gpoDmgWaBx0xaT91GVulXvn0iXhcxUahjmoBblYeMRmBevC/ggPdWZg9UE70zIcJgDxTO08b1G6wEEKP8EGExLhfpejS/lcz6P6FULduKi/X90UpXvqkRD3ErA8nJwDkRmIxCyHN8pGurTbMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kQJPMdJM; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770254893; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ch2lw3Gkx/tmSQGhjBy06LxNeqZ/lvoi8ni6rWgh66M=;
	b=kQJPMdJMKpKWi43ymOHB+IBcV8DKgbFDhzi3mgC4TI4159ZhTTeD4tz/b1imKgGkzbhe0O5kaVqnwemoqw7YVE57HNRAWQ4HHy1iuLtfR9KJeOIreYm+lhTDQKgj+ois6e1Cinetkll/nW/rmyeQKVYg6FG1q9in+UMH3BELMRE=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyZ3nte_1770254889 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Feb 2026 09:28:11 +0800
From: fangyu.yu@linux.alibaba.com
To: andrew.jones@oss.qualcomm.com
Cc: alex@ghiti.fr,
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
	radim.krcmar@oss.qualcomm.com
Subject: Re: Re: [PATCH v5 3/3] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Date: Thu,  5 Feb 2026 09:28:08 +0800
Message-Id: <20260205012808.98973-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <ocfqo4zpsg6yyaz6kd65jrvudtb35uerdsueazqdk6w7c5lvdf@wvwzhc57gxez>
References: <ocfqo4zpsg6yyaz6kd65jrvudtb35uerdsueazqdk6w7c5lvdf@wvwzhc57gxez>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70283-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_NO_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[17];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 628F6EDA81
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
>>  arch/riscv/kvm/vm.c            | 19 +++++++++++++++++--
>>  include/uapi/linux/kvm.h       |  1 +
>>  3 files changed, 45 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 01a3abef8abb..62dc120857c1 100644
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
>> +:Type: VM
>> +:Parameters: args[0] contains the requested HGATP mode
>> +:Returns:
>> +  - 0 on success.
>> +  - -EINVAL if args[0] is outside the range of HGATP modes supported by the
>> +    hardware.
>> +  - -EBUSY if vCPUs have already been created for the VM, if the VM has any
>> +    non-empty memslots.
>> +
>
>Currently the documentation for KVM_SET_ONE_REG has this for EBUSY
>
>  EBUSY    (riscv) changing register value not allowed after the vcpu
>           has run at least once
>
>I suggest we update the KVM_SET_ONE_REG EBUSY description to say
>
>(riscv) changing register value not allowed. This may occur after the vcpu
>has run at least once or when other setup has completed which depends on
>the value of the register.

Thanks for the suggestion.

In this series the HGATP mode is configured via KVM_ENABLE_CAP at the VM level
(kvm_vm_ioctl_enable_cap), not via KVM_SET_ONE_REG. Updating the KVM_SET_ONE_REG
-EBUSY description might be misleading since it is vCPU one-reg specific and not
directly related to this series.

>> +This capability allows userspace to explicitly select the HGATP mode for
>> +the VM. The selected mode must be supported by both KVM and hardware. This
>> +capability must be enabled before creating any vCPUs or memslots.
>> +
>> +If this capability is not enabled, KVM will select the default HGATP mode
>> +automatically. The default is the highest HGATP.MODE value supported by
>> +hardware.
>> +
>> +``KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE)`` returns a bitmask of
>> +HGATP.MODE values supported by the host. A return value of 0 indicates that
>> +the capability is not supported. Supported-mode bitmask use HGATP.MODE
>> +encodings as defined by the RISC-V privileged specification, such as Sv39x4
>> +corresponds to HGATP.MODE=8, so userspace should test bitmask & BIT(8).
>> +
>>  8. Other capabilities.
>>  ======================
>>  
>> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
>> index 4b2156df40fc..7d1e1d257df5 100644
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
>> @@ -212,12 +215,24 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
>> +		if (!kvm_riscv_hgatp_mode_is_valid(cap->args[0]))
>> +			return -EINVAL;
>> +
>> +		if (kvm->created_vcpus || !kvm_are_all_memslots_empty(kvm))
>> +			return -EBUSY;
>> +#ifdef CONFIG_64BIT
>> +		kvm->arch.kvm_riscv_gstage_pgd_levels =
>> +				3 + cap->args[0] - HGATP_MODE_SV39X4;
>> +#endif
>
> 'if (IS_ENABLED(CONFIG_64BIT))' is preferred to the #ifdef.
>
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

