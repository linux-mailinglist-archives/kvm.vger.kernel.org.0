Return-Path: <kvm+bounces-68625-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SNdmAcGlb2kfEgAAu9opvQ
	(envelope-from <kvm+bounces-68625-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 16:56:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D3246DD9
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 16:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4B5793CBD94
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 14:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED1043636B;
	Tue, 20 Jan 2026 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="i+ZhZaGJ"
X-Original-To: kvm@vger.kernel.org
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030BB1F1304;
	Tue, 20 Jan 2026 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918991; cv=none; b=uo6GxvSZfppDMl3HfHVgxAWeAe5HwamjgevApYW3JxKMNj73IFxzzAvzJyeRL/oUVt6tu+12X5l5hjvi2ZmBrM4IK+reN2PujNOyOZw4kgj3CSCPavDxjCwIZFugfrjnWTMoHT9JkqMoqKIvBgshw025hCJo9mM6QAa96w7GWyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918991; c=relaxed/simple;
	bh=rW+LTZp/ZJIVdrB3i/54PJ5maH4AYyK2KAerEMHjQlI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gxjKR3NySvsSii2hGy3dpYs6RHP/8yKV6oPYU44hYCgWk5XyuzKQDbljIZZnMhHIw5bnaJ3ZKnBTSM0rjcZC58yz7vuM5wo7Fulu5EHz7ClpkZBDzdoeIGahpkN7YScEAZhS+ZwHjT+mCq6YiM2/3CmSenaXjZpw0eTsOyOdHno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=i+ZhZaGJ; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768918980; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=XjFJwiZwKYWRxhHb7L7H6Uqg4/HCRCOm2ZcJ0CPggm0=;
	b=i+ZhZaGJhTHdIIQ9CEqq17/RUo2bY/2Tw9Q1qsN9LEJyGlxFMalJVkM4x2A0Dr/p+5+p7y4ED1rIsT5hhX6FPm00u5e88BH5AK3zeEemJOysFflE6gd5KbxZvHC5FkQijw0IpVxxC/cXahpUL1LUPoq4jHs5MGoEWD/QQD2pHdg=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WxUghn7_1768918976 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Jan 2026 22:22:58 +0800
From: fangyu.yu@linux.alibaba.com
To: radim.krcmar@oss.qualcomm.com
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
Date: Tue, 20 Jan 2026 22:22:56 +0800
Message-Id: <20260120142256.9968-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <DFSM9IHXY24S.3W4T39VHEH420@oss.qualcomm.com>
References: <DFSM9IHXY24S.3W4T39VHEH420@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-7.46 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[linux.alibaba.com,none];
	TAGGED_FROM(0.00)[bounces-68625-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,alibaba.com:email]
X-Rspamd-Queue-Id: 98D3246DD9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>
>> This capability allows userspace to explicitly select the HGATP mode
>> for the VM. The selected mode must be less than or equal to the max
>> HGATP mode supported by the hardware. This capability must be enabled
>> before creating any vCPUs, and can only be set once per VM.
>>
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
>> @@ -212,12 +219,27 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  
>>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>  {
>> +	if (cap->flags)
>> +		return -EINVAL;
>>  	switch (cap->cap) {
>> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
>> +#ifdef CONFIG_64BIT
>> +		if (cap->args[0] < HGATP_MODE_SV39X4 ||
>> +			cap->args[0] > kvm_riscv_gstage_max_mode)
>> +			return -EINVAL;
>> +		if (kvm->arch.gstage_mode_initialized)
>> +			return 0;
>
>"must be enabled before creating any vCPUs" check is missing.

Agreed, I'll add the missing "must be enabled before creating any vCPUs" check by
rejecting the capability once kvm->created_vcpus is non-zero.

>
>> +		kvm->arch.gstage_mode_initialized = true;
>> +		kvm->arch.kvm_riscv_gstage_mode = cap->args[0];
>> +		kvm->arch.kvm_riscv_gstage_pgd_levels = 3 +
>> +		    kvm->arch.kvm_riscv_gstage_mode - HGATP_MODE_SV39X4;
>
>Even before creating VCPUs, I don't see enough protections to make this
>work.
>
>Userspace can only provide a hint about the physical address space size
>before any other KVM code could have acted on the information.
>It would be a serious issue if some code would operate on hgatp as if it
>were X and others as Y.
>
>The simplest solution would be to ensure that the CAP_SET VM ioctl can
>only be executed before any other IOCTL, but a change in generic code to
>achieve it would be frowned upon...
>I would recommend looking at kvm_are_all_memslots_empty() first, as it's
>quite likely that it could be sufficient for the purposes of changing
>hgatp.

Using kvm_are_all_memslots_empty might be a good idea, and I will add a
check for this function in the v2.

>
>Thanks.

Thanks,
Fangyu

