Return-Path: <kvm+bounces-71432-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FyNA4j1mGkaOgMAu9opvQ
	(envelope-from <kvm+bounces-71432-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:00:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FE216B79C
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:00:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8E983045AB1
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB4E3168EF;
	Fri, 20 Feb 2026 23:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XR4LKg6D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785FF314A67
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 23:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771631995; cv=pass; b=mW6pvG6VhLLZh9c32vnBWHSqpZO2o2h285Q4XkU4epSBDsuCi8OtD3VgmGGxiuFFAcZ/jyI1bHiu/GBDKFgnRMBWe2jTjoci91bQPvKkIAUpmIbBrGvi1ySpTpTVFtLGU0fOd56rE/f87z5q1Yb5oM6Sgmn5i2Uc9N8bYidGm68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771631995; c=relaxed/simple;
	bh=VyJ51nvldcOjba54gfvYaCWLkwe2rVqmswtI06TBvPs=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oshl7AN+E81k1VF2GO4gR7ZWQgGq1zq01aIfF5juWtzE23s6rAuUvVyfo/DzbGrLmZ3TuRAEUk8YwJzkyJTxToJl4yltgebtKez03T0NzRZX0/aMJSuUI9NPsvV5Fp11DdCcy7ncVSwrN0+8ThWn3eeGYrdFsU6tcqcRGMVoUvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XR4LKg6D; arc=pass smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-94acd026e45so635169241.3
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 15:59:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771631993; cv=none;
        d=google.com; s=arc-20240605;
        b=YT5FxrRTXWWjBKKAib2dlEhXEjG8y4mJykjHuK3PRwrATodGkT/Jds9NzI+Og/pAKB
         86GxG00CDjw7T/+mu/tG84WyInnwf13AFgoC7Jfu2T1bVXxwDJyR7UG7MZIUA4Lis1Jn
         uPOUPb1SL19XMBnbaNdN7A9acQX8a3P4xSBaDQN9ZyYEUooUff8W24S3Z03TxQXJJqwj
         jlOwKOcsxfq56lU/7+/0ujFQ1jIIr9DdzK+67xV7ncQyRIN6dkfJP1Q/CCIOXQQla+NH
         cYVBlp7k1i4X/Mis3pzPKa37BS6hFFACZkQH2tlacjMywJ5Tg8IEqyEpllC5P3r7hB+5
         8hIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=+f0CcQxmI0koMDUEbyqFOb1QILsoY/SYqmL6D7Q+4cE=;
        fh=dEDVWBmhumOO8YTi3Y/BfZxzoQFon9bpuNfJ62g3nvA=;
        b=c/xUz3LN8V94ngaI77Ny/698GxsTBA7njNukNlQklxsRrbjiPlzTrqYY+JhOA9j9zl
         OGKRlx4u1wR1L8h866Dvs0YXhN8IqyEOIQxlfEvUQNXGhAjTnDz8ebAIcc1a/nyeuoJb
         a3hG/SuX9tCd6uvZAgAMp2FHeLO6VG+JlXPxZTQL4bE5uil71LcBTDZaLqy1us1lKcxn
         fCbABXX9crWTkDiLCoOusqZVZb8XrQjy6K3aVGmuDILNvWFZ+lEx6ws6/L9XEgqBMyIu
         jsk3fm6IAK9E4NtqZUyJOXfbkDqgCvVZL8rBolQaHRXO9EQW87bRlyn/2MA37VDYYxsG
         NVGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771631993; x=1772236793; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+f0CcQxmI0koMDUEbyqFOb1QILsoY/SYqmL6D7Q+4cE=;
        b=XR4LKg6D/gGGvzXgOsfsIBAJrDcsMcXhjNtNNwfnEr6i9g0J1AyDZn6AVkqSvxQXhS
         fJAOqO3YTEXr4q9yR1463W4EfqKu3j5WDxPGhQ9ICKL/tKbWXWpea3htap0LOBnXvz1N
         Mz9PsmXPPIzL2iTCAGXb4v4zl/WTMnbg8l+RQzmrbzQLeNsCGxGWSWlqhkSckiBIHS43
         NGNWbAuPfgb/e5NspKFzZZCh8sF2hopWh+ygjitdJ9YRGBdJEjrvdgwpweg4rvFDHm3R
         X2gSmBBllt4lRx2cuLyEQZDKXGUzTG9sV+nWu1mc43p2XKGi1jyd3LbrQCEsEQ9Gsxno
         YyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771631993; x=1772236793;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+f0CcQxmI0koMDUEbyqFOb1QILsoY/SYqmL6D7Q+4cE=;
        b=VAXrHk6eK2EKY2mif+zjkHTmwb1ByNDFapTIiKTx1OaDq2afycEcijywRbDzf1lwdY
         OQIjF7Jm1HC/4UhG/jXCL0wMuZhUb2p07XLoD+LlQGO+24LDdUzuwrKUblHNWAjcWvq6
         Vwq/JCpJoz8NccBuzugIEnzQZA5RMwTuqAYpAxKh6tU2Hp4YJw+T1S4BSpMwPf4ddrne
         56JQhj0iCiR0H5AZLKw0xgrTCB6/GRPkzb55tukpdgukM6sU+4v4CmTjSnfkn1g1t4L8
         BHWMtjPkH/nPz/kG/bWu4XQH/ROFVxB/FBMneA3FDtXfVgNGcUqSk2LV38eQL/03Rt9P
         ybCw==
X-Forwarded-Encrypted: i=1; AJvYcCUFJ21S1FoTvlj57oJH7zTRJ8rPewgK9Jdy9FE6U5l4ZvYMOrfqbPmfRhPFfh3sUzQSW0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZy2+rgzaHQM8qbFBJQj7Guo8qei7EbBCI6B0DZ0bmqANfNBkZ
	J+YA9si4SECruGcNHYox94tBNvMqIcnsQiQz8PIxDjNdGeRsihBjuA6IolQOyWfSDpzD6/e5jZE
	7/XCEs+q6i8deECox4td/jLp9JZ9nVoPKJ8zjJAmB
X-Gm-Gg: AZuq6aImoXSJNvPQu6fUw0myLktcYmlpZdEs8nn90LENMCm3mNn+9Ezfj3sG7nNMWRL
	aw8bYmq9lxIt2BbY54pISa6OU2uI4tLfzn7/06pbUt2t069yOQmq6nT89NhcJMrNRBBLXwT5V0S
	g+Sl+Dbvu40egYaAjW+Md0AM9rr0CL2cE4q6Y61IP58jhUfPpS+1EdmIqSnzErxMumn6IPntG8J
	2WC0afUfliImrD2aKNRvIQtrHTVqqwPPS5+mdIrx3L9ss0IPSstjUQqeWamUPcLNPAZfq6j8PKR
	KfUjaA8VYzlrUsMHd7q52lx4Tgat8FgwybYq8J5n0w==
X-Received: by 2002:a05:6102:358d:b0:5db:3bbf:8e62 with SMTP id
 ada2fe7eead31-5feb2e60d7dmr725313137.1.1771631992819; Fri, 20 Feb 2026
 15:59:52 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 20 Feb 2026 15:59:51 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 20 Feb 2026 15:59:51 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aZSGD-EGSR3Z5Qyi@google.com>
References: <20260214001535.435626-1-kartikey406@gmail.com>
 <20260217014402.2554832-1-ackerleytng@google.com> <aZSGD-EGSR3Z5Qyi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Feb 2026 15:59:51 -0800
X-Gm-Features: AaiRm50KSzR4QWeR2pY6q56NWZqd8e8f9tXSjFga3oRJAj_7AZ0rMRT-3FKVTjc
Message-ID: <CAEvNRgHQZzdy8+rbsH2EibpCo8ddinXMSSef5h1_r3mK74q-xg@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Test MADV_COLLAPSE on GUEST_MEMFD
To: Sean Christopherson <seanjc@google.com>
Cc: kartikey406@gmail.com, pbonzini@redhat.com, shuah@kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, vannapurve@google.com, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	i@maskray.me, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, shy828301@gmail.com, stable@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71432-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,kernel.org,vger.kernel.org,google.com,oracle.com,linux-foundation.org,linux.alibaba.com,arm.com,maskray.me,linux.dev,kvack.org,syzkaller.appspotmail.com,nvidia.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 62FE216B79C
X-Rspamd-Action: no action

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Feb 17, 2026, Ackerley Tng wrote:
>>
>> [...snip...]
>>
>> +
>> +	/*
>> +	 * Use aligned address so that MADV_COLLAPSE will not be
>> +	 * filtered out early in the collapsing routine.
>
> Please elaborate, the value below is way more magical than just being aligned.
>
>> +	 */
>> +#define ALIGNED_ADDRESS ((void *)0x4000000000UL)
>
> Use a "const void *" instead of #define inside a function.  And use one of the
> appropriate size macros, e.g.
>
> 	const void *ALIGNED_ADDRESS = (void *)(SZ_1G * <some magic value>);
>
> But why hardcode a virtual address in the first place?  If you a specific
> alignment, just allocate enough virtual memory to be able to meet those alignment
> requirements.
>
>> +	mem = mmap(ALIGNED_ADDRESS, pmd_size, PROT_READ | PROT_WRITE,
>> +		   MAP_FIXED | MAP_SHARED, fd, 0);
>>
>> [...snip...]
>>
>> @@ -370,6 +441,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>>  			gmem_test(mmap_supported, vm, flags);
>>  			gmem_test(fault_overflow, vm, flags);
>>  			gmem_test(numa_allocation, vm, flags);
>> +			test_collapse(vm, flags);
>
> Why diverge from everything else?  Yeah, the size is different, but that's easy
> enough to handle.  And presumably the THP query needs to be able to fail gracefully,
> so something like this?
>
>
> [...snip...]
>

Addressed your comments in a v2 [*], thanks for reviewing!

[*] https://lore.kernel.org/all/cover.1771630983.git.ackerleytng@google.com/T/

