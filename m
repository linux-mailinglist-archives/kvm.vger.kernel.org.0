Return-Path: <kvm+bounces-69774-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2JPvHG+dfWmYSwIAu9opvQ
	(envelope-from <kvm+bounces-69774-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 07:13:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D57C0ED9
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 07:13:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9A8423003813
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 06:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA3532D0FC;
	Sat, 31 Jan 2026 06:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HGD+EKAr"
X-Original-To: kvm@vger.kernel.org
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1E130EF6C;
	Sat, 31 Jan 2026 06:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769839978; cv=none; b=Q2DEvvz0528FNrCV57029yMiSczsQ0kTypb9P6VRYlChCkd4EOPiZ6wQx7uZOQTZ9hXfcJZygmh2u8d72xapCwgkd2s7eKim1HlAg6KZSaHEa0H3XkwEk+99mUxPfwwkP22ovVOggta9SRMy/vFzFdv6/9MIDsxnKdN3JF+fG18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769839978; c=relaxed/simple;
	bh=4QP9bVrKrV78SQhKFaWofs1UrP9p1qSZtnIkT3cqWSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sW4oI0LXre2AXLiFn1I4/URXdV3YDnF1hOAZiJpPGIsqmozJ9YuahrB86647oM5bD/lMPmuT30wDplRSbKEz6PSBpaHLxJG96PvaHBoKl0N3mnpjHCktkcbG6G9aBwJilPRsRTenyXMTgpY+mJNXxLXyqbbIJhksqCHQRVLGF6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HGD+EKAr; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769839966; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=2OKdCyNJhIVojli7ql3F2hJ/uL4VUVnT1i6U4jxVZT8=;
	b=HGD+EKArb0cF9TN5QS0AEQtpfbkRyzgihlo1kPocv8fBNq9YuL3FP+e4aM8MUV01KlkvcYK3/po85bKJnrmt6lLJOY+sofwU6hpqaAk53JA61tgQ4gN1nI1Pf+2UVBOsLfRG8u+jL3iFawqEGlWoFYIWURyDJ9JcbC/vm2Y1DUE=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyCuJgA_1769839962 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 31 Jan 2026 14:12:44 +0800
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
	pjw@kernel.org
Subject: Re: Re: [PATCH v3 1/2] RISC-V: KVM: Support runtime configuration for per-VM's HGATP mode
Date: Sat, 31 Jan 2026 14:12:38 +0800
Message-Id: <20260131061238.52708-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <DG21QMIKJS7W.1OUK0OFL8S3A8@oss.qualcomm.com>
References: <DG21QMIKJS7W.1OUK0OFL8S3A8@oss.qualcomm.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69774-lists,kvm=lfdr.de];
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
	RCPT_COUNT_TWELVE(0.00)[18];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: 08D57C0ED9
X-Rspamd-Action: no action

>>>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>>> -	kvm_info("using %s G-stage page table format\n", str);
>>>> +	kvm_info("Max G-stage page table format %s\n", str);
>>>
>>>Fun fact: the ISA doesn't define the same hierarchy for hgatp modes as
>>>it does for satp modes, so we could have just Sv57x4 and nothing below.
>>>
>>>We could do just with a code comment that we're assuming vendors will do
>>>better, but I'd rather not introduce more assumptions...
>>>I think the easiest would be to kvm_riscv_gstage_mode_detect() levels in
>>>reverse and stop on the first one that is not supported.
>>>(I'll reply with a patch later.)
>>
>> Please refer to the discussion here:
>> https://github.com/riscv/riscv-isa-manual/issues/2208
>> If Sv57x4 is implemented, then Sv48x4 and Sv39x4 must also be implemented.
>
>I don't think so, sadly, but we're mostly dealing with technicalities
>here.  As Andrew pointed out:
>
>  "The H extension itself does not impose this requirement, so
>  technically Sv57x4 without Sv48x4 conforms to the H extension spec."
>
>This means it's completely valid to support {Bare, Sv39x4, Sv57x4}.
>The RVA23 profile imposes additional constraints via Shgatpa:
>
>  "For each supported virtual memory scheme SvNN supported in satp, the
>  corresponding hgatp SvNNx4 mode must be supported.
>  The hgatp mode Bare must also be supported."
>
>The requirement only goes one way, so an RVA23 implementation with just
>{Bare, Sv39} in satp could support {Bare, Sv39x4, Sv57x4} in hgatp,
>because RVA23 nor ISA prevent Sv57x4 to be there.
>Not that I expect any sensible implementation to do this...
>
>Btw. do we target only RVA23 with KVM?

Thanks for the clarification.

No, I don't think we should assume we're targeting only RVA23 (or any
specific profile) with KVM. In general KVM should work with any
H-extension implementation that satisfies KVM’s requirements, without
depending on additional profile constraints unless explicitly stated.

Given that, relying on “if Sv57x4 exists then Sv48x4/Sv39x4 must exist”
would be an extra assumption. To avoid that, I’ll update the detection
logic to probe modes independently and record all supported modes (and
derive the max level from the resulting set by default).

Also, I will expose the full set of detected host-supported HGATP.MODE
values to userspace via KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE)
as a bitmask, so userspace can select an appropriate mode.

>
>Thanks

Thanks,
Fangyu

