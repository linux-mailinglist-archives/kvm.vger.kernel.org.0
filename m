Return-Path: <kvm+bounces-70559-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGhIDC3JiGl1wAQAu9opvQ
	(envelope-from <kvm+bounces-70559-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 18:34:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8989110994C
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 18:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55821301B736
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 17:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9502DB7A3;
	Sun,  8 Feb 2026 17:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bxsvzl6p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEED450F2
	for <kvm@vger.kernel.org>; Sun,  8 Feb 2026 17:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770572062; cv=pass; b=N4vBHp13HTALHIRuhUFiT9t8aikeRSMFiaFz7fWvspriLBhybRvUc5aNKMXkEpCy6HKE64bC6hWGTYo99Sgd+q/57Opi4kf/VkUmfakU/5eb7W0dHKIV31Ar6qcPjSAjYo2yB5BaTvcxZOfM+1f6p+UXfXt3k86esoyrLedLRlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770572062; c=relaxed/simple;
	bh=P7NEL9/T99sH+aRbkoBcuk0gLS6uipp9bsQ1HTNt2YM=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N4+DmD9SNC3GpumC2FmWCtkMtjBbYQ+SNjVMOcewVCSOXn8VEuPwBXKqwuD1xf2pvIVIcgw891p22OGTqOsZtcmYbVx9bTdbFTCwm6w6NY0I2D9l6xqfx9hBCwJhl3UM/fQbPz3M5GAlE+hGhTtdUwVh6A+fguEXJ98EnUsMCVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bxsvzl6p; arc=pass smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-94ac3958788so600389241.0
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 09:34:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770572061; cv=none;
        d=google.com; s=arc-20240605;
        b=TWXgJSmjsfgEMCTVgbpZS4Gtitv5HzxVkDp9FQi63P3wTfoN+jkK4+Qng5VmLlrcXc
         5fMHKxP1RKrNoLqOb6uxZLHPnD4gvILy9RsHGumgxKre1CzT8n/iaN96XgxDMfB3/vk3
         jjfY48MtMH222DOphYXCEdTVlw8OJGrPkF9CvVrIqXvseBl5SCoVoXKc6mRvLlzqwhwc
         sImJMJb9vhwPC3HKNra/I4FLNEV6NWiDT6QiyKzZN5Ffv29irdPkWr5sojGMjpbb+2iw
         xZHozpX2JN/9GE0yw7M1QcHWg5Pxtri/oYDEMDWIJZ5K47OBVAOAKiKbHCBQlF/FiSxU
         DIcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xFKVqTVKeEQVjwbqNpqhuiDRn27zA/oMFkSScIgbuxA=;
        fh=nFU3uYRKfZ0w9fcD4T7+rVQyNdLpy3AsEWgnXEQWwtg=;
        b=IIc48y1hS2owCItz2XAg+u48wP6b4LpBYGCgh5M2bzPkWb9EG/2WImMgN6j9tqlXuW
         jJYrZ32IrnaOccLXBkrpqErzn7it8IsFs3j2ScJM+oljIZwNfJ4oQt7ZzDFcWWxadOzg
         FaY3Y4SLQUtbvGnyi/QN6A8JrOuKJST9MlqFubFoi63+vX8qmyX2BPSytDyDZepQLo4Q
         n2Ig24+goQBWNa+91dmley/j5eWyXyJv9xWPIAqLjf/rE0H3D773s9S4rnn1W5zKctZh
         0h+BMrdAk0b5kIHkaIZM0YFyJqLR/WJpDxF2Y6JBu34Q+4OnyOqR0PKPSaIGWZ2NDw+J
         e7Cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770572061; x=1771176861; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xFKVqTVKeEQVjwbqNpqhuiDRn27zA/oMFkSScIgbuxA=;
        b=bxsvzl6pfbEosFN3Op/C/8hcfhhPYqxTQaQmlU/jusIU3QQg5ZG/egZ+dUPhitD5te
         mRbDiMzp9X7kaI+I+IZdYw8awOKWkY8mg5EWsMNeS6u1JmKYtuo6YJeL52jQEpVTqOE3
         Y++ZvAVP7ujAA9GWieQ4P2Cq51HUzDEpas+h2t99iiPnBXsrAhS0kxKs6aK7jllhpdr5
         7Bj1ZefbOIitVoMO31EnXsIhU/ut3uoTI9rumTXMA74xhLjCCIvmkVd1NZg0RabWZ24B
         sVUIkzPP+2tBfQ2foPGn18Jq4jnVGFeQIC1tpycRTPO5LZ4yvKpwwHrz7DGhiqaX48Bq
         CgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770572061; x=1771176861;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFKVqTVKeEQVjwbqNpqhuiDRn27zA/oMFkSScIgbuxA=;
        b=uICAXc3A2R5qCYHzM5cdO4BoiKD9xQ3LruSpB3CNILkS1EBDmfmAzMKwV6vL1863Sw
         5/qPHPp39KalMD+V2DfWc0sV/qkJBXog4rsbT+X7hKUSJrLygJGzPxDLZP/y8C4KgSwi
         1kUMJWK65mqxNycf7AjUv2YwCq7KVm9P3ltgURwIKMrEp+d18EmpjbFgc7CPguR7JCHU
         dp9LC78tukbpfO1sjFQ4y3jGkFL+iaZOK8LOl/FqwMUaPDvH/fXsmwI8tGI5PI8uWm8P
         5tar3oFoQFh70DyyWtnO+CwSI5dsrqTZwVlFs7iQ+JfjIY8TEFDjeQrXnn3RcUTt3yGh
         AVbw==
X-Forwarded-Encrypted: i=1; AJvYcCVNkIenNWwyjcxm7syybnwD1WkHVCHl9v16TWsm0NGJFhfOYZgfVuPb/nGrBKumTjlSTeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmOuCsMQ++zPEE6nFDs8eKm5wC5+SxOcWwXFF3ByQ5/dIbJgYG
	S5brr/X4wsSCnObGDD3VjCZBTVlmsMShWbaIM7NESO9R+6U3hoat/qLJFj4ZxJyZINy8S4gInmm
	jgZATELaO5mZvp1PhCW0YFuKh4Y/g7CIa5foWHNsA
X-Gm-Gg: AZuq6aLSn4WAiUVl+xLxToCTLK3sIp3gvQhQjo2A52a5fY5rHoYh+FbUpdiQ3VgqWuc
	Zar6Zn71WZUA/Aa+UBktZ5ZXBbvWzMsytoFIKBE0pZ1RMc6ph0FyVZPexsiY58SHA90/4Hc2Zyd
	m1bGB6fItsud7fcyUL2vitiBHqeYzidYB98c2C1ZkLPy+BBaEFHM1He+m8MtXDb+cEKWXmp8wpW
	l2JmWXT3FTOhoD0DUZPWGfqbK2PXI1YXaNGOueWP87oeu8EMgWnt8yh50ml6cRxNmaeYg==
X-Received: by 2002:a05:6102:3f42:b0:5ee:a6f8:f93b with SMTP id
 ada2fe7eead31-5f94cfedc5dmr4124370137.2.1770572061189; Sun, 08 Feb 2026
 09:34:21 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 8 Feb 2026 09:34:20 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 8 Feb 2026 09:34:20 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgHX7MPSBX7pMeSWEtzc0-bJhAZ=pv+WF0VtOv9Tx0Jpxw@mail.gmail.com>
References: <697d115a.050a0220.1d61ec.0004.GAE@google.com> <20260204170144.2904483-1-ackerleytng@google.com>
 <CAEvNRgF75EsHL8idLzFzbk0K9uhE70AMj5Vitp4cKNg_5WqQKw@mail.gmail.com>
 <aYO8DLCWw8FEQUAU@google.com> <16e5a36e-fff0-4a54-9c5c-a8e411659108@kernel.org>
 <CAEvNRgHX7MPSBX7pMeSWEtzc0-bJhAZ=pv+WF0VtOv9Tx0Jpxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 8 Feb 2026 09:34:20 -0800
X-Gm-Features: AZwV_QiM19rQ37sa7OrQX7O0Libb9UqrcrTc82NMLHtwMoyKg_5odVxJSLHr_s4
Message-ID: <CAEvNRgEO3gB6Oee2C-+8Pu=+3KY0C98yrmesKO2SMVSvs3anfA@mail.gmail.com>
Subject: Re: [PATCH] KVM: guest_memfd: Disable VMA merging with VM_DONTEXPAND
To: "David Hildenbrand (arm)" <david@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, michael.roth@amd.com, vannapurve@google.com, 
	kartikey406@gmail.com
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
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[syzkaller.appspotmail.com,vger.kernel.org,redhat.com,googlegroups.com,amd.com,google.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-70559-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 8989110994C
X-Rspamd-Action: no action

Ackerley Tng <ackerleytng@google.com> writes:

>
> [...snip...]
>
>> !thp_vma_allowable_order() must take care of that somehow down in
>> __thp_vma_allowable_orders(), by checking the file).
>>
>> Likely the file_thp_enabled() check is the culprit with
>> CONFIG_READ_ONLY_THP_FOR_FS?
>>
>> Maybe we need a flag to say "even not CONFIG_READ_ONLY_THP_FOR_FS".
>>
>> I wonder how we handle that for secretmem. Too late for me, going to bed :)
>>
>
> Let me look deeper into this. Thanks!
>

I trimmed the repro to this:

static void test_guest_memfd_repro(void)
{
	struct kvm_vcpu *vcpu;
	uint8_t *unaligned_mem;
	struct kvm_vm *vm;
	uint8_t *mem;
	int fd;

	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);

	fd = vm_create_guest_memfd(vm, SZ_2M * 2, GUEST_MEMFD_FLAG_MMAP |
GUEST_MEMFD_FLAG_INIT_SHARED);

	unaligned_mem = mmap(NULL, SZ_2M + SZ_2M, PROT_READ | PROT_WRITE,
MAP_FIXED | MAP_SHARED, fd, 0);
	mem = align_ptr_up(unaligned_mem, SZ_2M);
	TEST_ASSERT(((unsigned long)mem & (SZ_2M - 1)) == 0, "returned
address must be aligned to SZ_2M");

	TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_HUGEPAGE), 0);

	for (int i = 0; i < SZ_2M; i += SZ_4K)
		READ_ONCE(mem[i]);

	TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_COLLAPSE), 0);

	TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_DONTNEED), 0);

	/* This triggers the WARNing. */
	READ_ONCE(mem[0]);

	munmap(unaligned_mem, SZ_2M * 2);

	close(fd);
	kvm_vm_free(vm);
}

And tried to replace the fd creation the secretmem equivalent

	fd = syscall(__NR_memfd_secret, 0);
	TEST_ASSERT(fd >= 0, "Couldn't create secretmem fd.");
	TEST_ASSERT_EQ(ftruncate(fd, SZ_2M * 2), 0);

Should a guest_memfd selftest be added to cover this?

MADV_COLLAPSE fails with EINVAL, but it does go through to
hpage_collapse_scan_file() -> collapse_file(), before failing because
when collapsing the page, copy_mc_highpage() returns > 0.

Not super familiar with copy_mc_highpage() - I haven't looked into why
copy_mc_highpage() failed, but looks like it would have caused
memory_failure_queue() which would be inappropriate.

Since this also affects secretmem, I think thp_vma_allowable_order() is
the best place to intercept the collapsing flow for both secretmem and
guest_memfd.

Let me know if you have any ideas!

>> --
>> Cheers,
>>
>> David

