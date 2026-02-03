Return-Path: <kvm+bounces-70015-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sCAfM1QFgmmYNgMAu9opvQ
	(envelope-from <kvm+bounces-70015-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 15:25:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 85564DA8AB
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 15:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A70BB3094A50
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 14:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D703A9612;
	Tue,  3 Feb 2026 14:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HjSDYkkN"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7C5341076;
	Tue,  3 Feb 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770128677; cv=none; b=ZSPAKXj4F3SO8I0teZv9E7+VBtA0GNCQiw09wACesxt3xv8l7v0hKDLw386TLsv95M5RZKK6Z+nS34yCehLOiTzASXHvzhPYHHZrqJIXLZnJ1pr0dBRdnD/Wn7DtymPKVO8SzrTR0ElVjVUfWCr2x8DdhgBoc/Ud1JTQFBrftUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770128677; c=relaxed/simple;
	bh=ffOir72Vs8lqPj8BPkmThj6PjbpIXm1wp44KeiKwcBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CR03Pt81PvFzJmAAz5gZaZ3mVOsjnt74S8xZGG8Ub0tl+DSD42PTyZqqZRAsDfLpeSdS1moAYn2sn3pYIji36v3nYG7Kajc4C3hUR0WdIqTMOTz1KohjCu5gCC4jMM5spwmnmDm6dpbqeRnPRlhOhziN+I2MayEF9+AfawM4Z8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HjSDYkkN; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770128666; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=0M1HZ0jCLyoH118xBYa/oRTWv4PKWmhxkZYP6AlCFTM=;
	b=HjSDYkkNi+2NHAOTQu/gNxrPIjTQI1TFJ7i4a6ybQdk/gb1IvKDJxZZZynl9WyvfvIt9Oz5frhbguPVbJYL9YWvlg/U+ngcoBe5CX3CyyFVcfGsGb68OwamDDlC1+i1+H8ZYdmCwJn4nng3qf013AIjTJ3nIg1QIfQC9O87b4eI=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyTNrow_1770128663 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Feb 2026 22:24:24 +0800
From: fangyu.yu@linux.alibaba.com
To: radim.krcmar@oss.qualcomm.com
Cc: ajones@ventanamicro.com,
	alex@ghiti.fr,
	andrew.jones@oss.qualcomm.com,
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
Subject: Re: Re: [PATCH v4 2/4] RISC-V: KVM: Detect and expose supported HGATP G-stage modes
Date: Tue,  3 Feb 2026 22:24:22 +0800
Message-Id: <20260203142422.99110-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <DG4PS6NRRUC1.1FL8WBJVEEM4D@oss.qualcomm.com>
References: <DG4PS6NRRUC1.1FL8WBJVEEM4D@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.16 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70015-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[19];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: 85564DA8AB
X-Rspamd-Action: no action

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>
>> Extend kvm_riscv_gstage_mode_detect() to probe all HGATP.MODE values
>> supported by the host and record them in a bitmask. Keep tracking the
>> maximum supported G-stage page table level for existing internal users.
>>
>> Also provide lightweight helpers to retrieve the supported-mode bitmask
>> and validate a requested HGATP.MODE against it.
>>
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
>> @@ -75,4 +76,40 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>> +enum kvm_riscv_hgatp_mode_bit {
>> +	HGATP_MODE_SV39X4_BIT = 0,
>> +	HGATP_MODE_SV48X4_BIT = 1,
>> +	HGATP_MODE_SV57X4_BIT = 2,
>
>I think it's a bit awkward to pass 9 when selecting the hgatp mode, but
>then look for bit 0 when detecting it...
>Why not to use the RVI defined values for this UABI as well?
>
>There are only 16 possible hgatp.mode values, so we're fine storing them
>in a bitmap even on RV32.

I think this is a good point.

Using logical bits 0/1/2 is indeed less intuitive than testing
BIT(HGATP_MODE_SV39X4) when userspace passes the architectural HGATP.MODE
encoding.

However, if we use “HGATP.MODE encoding as bit index”, we need to export
those encodings to userspace. Today HGATP_MODE_* are not part of the
UAPI, so userspace would need to hardcode magic numbers.

So if we go with this approach, I’ll add UAPI definitions for the HGATP
mode encodings (e.g. #define KVM_RISCV_HGATP_MODE_SV39X4_BIT  8, etc.) and
then define the returned bitmask as BIT(mode).

>
>Thanks.
>
Thanks,
Fangyu

