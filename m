Return-Path: <kvm+bounces-68624-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OG+VNlCyb2nMKgAAu9opvQ
	(envelope-from <kvm+bounces-68624-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 17:50:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C9647F4D
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 17:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E4EA470C416
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 14:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B2343DA5E;
	Tue, 20 Jan 2026 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Qj7xAxzI"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32065500940;
	Tue, 20 Jan 2026 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918947; cv=none; b=SVFS0Ka+PjO53QnV60HUDcQC6DBZY8CGrZ4Scy5topH5TwWVShKW5JTiIlXY5Er2X6nA9Z897TzluvWljOimuQKTBGcAcDPxGRv5uJY6kQi4TUqdK7JhCshaub2QSPNgu1fz1+M0xqCFRgatgMM6ygBzLe/W5mQZwOKR1PKyp4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918947; c=relaxed/simple;
	bh=swLXCQOH+1mmpzdujIfEJlXid1sDiggMBxCN37vNuHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CrAhPCxhQS0ECX+RAnnvH4wYF4ea/KnL+mVLCn7Of+ypLBs2SMX/biCcShAIer1bjIOYekPm/Ytrv5O5E31xVfYh9pp/rh7bs64F/CyCi37QKEabyhptRik8mHWgDK/ircDcaMnVnP1mfUSPD/Rs/sh4jNya44wehieqpyjvRW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Qj7xAxzI; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768918938; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=wD/viQYhsRUrgX+bgboJYmyufn5Ii5TsHLlk29tx4N4=;
	b=Qj7xAxzIALcB5+uUzvDddG0O7KBgD2HaUVplzIRtHIo/4LUkXf0V6qUZED130gy2rpJyrne0a041Fca82DKvNGQ4YDB2w828ScoWZz+6gED0OwSEPPC3pia8K4TeQjYtXMiaAfV7lU0XOtbrAcSb9G3mc8KtVUmWvOXt7/04+qc=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WxUjVe1_1768918934 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 20 Jan 2026 22:22:16 +0800
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
Date: Tue, 20 Jan 2026 22:22:10 +0800
Message-Id: <20260120142210.9891-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <6txqxrkyqh4afmked4hdi6qekkqrb54ar3q5upz3ennnuaktsi@dtoarqt7e26t>
References: <6txqxrkyqh4afmked4hdi6qekkqrb54ar3q5upz3ennnuaktsi@dtoarqt7e26t>
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
	TAGGED_FROM(0.00)[bounces-68624-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: 84C9647F4D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

>...
>> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
>> +#ifdef CONFIG_64BIT
>> +		if (cap->args[0] < HGATP_MODE_SV39X4 ||
>> +			cap->args[0] > kvm_riscv_gstage_max_mode)
>> +			return -EINVAL;
>> +		if (kvm->arch.gstage_mode_initialized)
>> +			return 0;
>> +		kvm->arch.gstage_mode_initialized = true;
>> +		kvm->arch.kvm_riscv_gstage_mode = cap->args[0];
>> +		kvm->arch.kvm_riscv_gstage_pgd_levels = 3 +
>> +		    kvm->arch.kvm_riscv_gstage_mode - HGATP_MODE_SV39X4;
>> +		kvm_info("using SV%lluX4 G-stage page table format\n",
>> +			39 + (cap->args[0] - HGATP_MODE_SV39X4) * 9);
>
>I don't think we want this kvm_info line, particularly if it doesn't also
>include a VM ID in some form to allow readers to know which VM is using
>the selected format. Let's either drop it or change it to kvm_debug and
>include a VM ID.

Agreed, I will switch it to kvm_debug() and include a VM ID.

>
>Thanks,
>drew
>
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
>
>

