Return-Path: <kvm+bounces-70139-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sCq/HxXdgmlJdgMAu9opvQ
	(envelope-from <kvm+bounces-70139-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 06:45:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E21D1E214C
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 06:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E7713068258
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 05:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062A932D452;
	Wed,  4 Feb 2026 05:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Bymy2ZVh"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BF4946C;
	Wed,  4 Feb 2026 05:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770183943; cv=none; b=JyBp57jAhiEkOVGRU38EJD4yFGl69CRA7eQZp7OF0s5jR3idHUtRpcBLF2ezJYulvmRWrtsEgkRz8HMglcQoqo2XdHIQrNRfPLmEaXrbED3+E8maVG2ek/uo0HUA2zd82Bkj6/ERsGxcD3ENQvvn7YE/kXMX2Ef7bX4aXU/JBUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770183943; c=relaxed/simple;
	bh=gVpNb2FcJnXvqjd76dpI3QbaGIpY5kIyXa8+4pcw7/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYlBGWmrlKidjHObqqXu6TSdZSSvvlXRKHeKbo4CwmYOvL9pU60BNvbFuTAOx4ubXYAng5cR08tlJPirjWruhEmWdgue02KrAjKVxiKyjKTUU1bQdvVLYZ2TqTZwdbnh6jIDcposCyoIGKVB1yTapnOdkiMBYUdGhL0eOzaNI38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Bymy2ZVh; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770183938; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=kcpw6nzObOocTcTfgP4J3okRdYpVAmfqCq2J3Q4ovjM=;
	b=Bymy2ZVhLBI5bSgdxKjWWwspSU0CEjzd1hef/I2NbwFqiR0IfGs0dHyBVj/Jo4cBe6l6F4OapuxMqk6LJqmHRc7XnpLH2UErWZU4FgPnSgJfzzjhfO0A3ljo+M3ZQqIyrxhgK7aHQUYkcelouZLPcXDzt1BWGUXYgu+tLM7jtcU=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyVYd-Q_1770183935 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Feb 2026 13:45:37 +0800
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
Subject: Re: Re: [PATCH v4 2/4] RISC-V: KVM: Detect and expose supported HGATP G-stage modes 
Date: Wed,  4 Feb 2026 13:45:34 +0800
Message-Id: <20260204054534.89560-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <fazd2fcfuwldtrarm6aw26qa5g6fcieoa35xz3bwchif6qfutw@xuvspa4e533b>
References: <fazd2fcfuwldtrarm6aw26qa5g6fcieoa35xz3bwchif6qfutw@xuvspa4e533b>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_SPACES(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70139-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E21D1E214C
X-Rspamd-Action: no action

>> >> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> >>
>> >> Extend kvm_riscv_gstage_mode_detect() to probe all HGATP.MODE values
>> >> supported by the host and record them in a bitmask. Keep tracking the
>> >> maximum supported G-stage page table level for existing internal users.
>> >>
>> >> Also provide lightweight helpers to retrieve the supported-mode bitmask
>> >> and validate a requested HGATP.MODE against it.
>> >>
>> >> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> >> ---
>> >> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
>> >> @@ -75,4 +76,40 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>> >> +enum kvm_riscv_hgatp_mode_bit {
>> >> +	HGATP_MODE_SV39X4_BIT = 0,
>> >> +	HGATP_MODE_SV48X4_BIT = 1,
>> >> +	HGATP_MODE_SV57X4_BIT = 2,
>> >
>> >I think it's a bit awkward to pass 9 when selecting the hgatp mode, but
>> >then look for bit 0 when detecting it...
>> >Why not to use the RVI defined values for this UABI as well?
>> >
>> >There are only 16 possible hgatp.mode values, so we're fine storing them
>> >in a bitmap even on RV32.
>>
>> I think this is a good point.
>>
>> Using logical bits 0/1/2 is indeed less intuitive than testing
>> BIT(HGATP_MODE_SV39X4) when userspace passes the architectural HGATP.MODE
>> encoding.
>>
>> However, if we use “HGATP.MODE encoding as bit index”, we need to export
>> those encodings to userspace. Today HGATP_MODE_* are not part of the
>> UAPI, so userspace would need to hardcode magic numbers.
>>
>> So if we go with this approach, I’ll add UAPI definitions for the HGATP
>> mode encodings (e.g. #define KVM_RISCV_HGATP_MODE_SV39X4_BIT  8, etc.) and
>> then define the returned bitmask as BIT(mode).
>
>The best part of Radim's suggestion is that there is no need to add the
>bits to UAPI. We can write in the documentation for the capability that
>the mode values match the spec. kvm userspace can then just look at the
>spec to determine those values and create its own defines (which QEMU,
>for example, has certainly already done).

Makes sense, thanks.

If we use the architectural HGATP.MODE encoding as the bit index, we can
indeed avoid adding any extra *_BIT or mode constants to the UAPI.

Not sure why my replies didn’t go through yesterday.

Thanks for the review. I’ll incorporate this feedback as well as your
other suggestions and address them in the next revision of the series.
>
>Thanks,
>drew

Thanks,
Fangyu

