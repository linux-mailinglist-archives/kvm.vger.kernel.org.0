Return-Path: <kvm+bounces-70636-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2M0QCGgmimlKHwAAu9opvQ
	(envelope-from <kvm+bounces-70636-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:24:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB08113815
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A60C13022F53
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 18:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0A12FD7BC;
	Mon,  9 Feb 2026 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V6VZKkhb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC272D7DED
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770661468; cv=pass; b=kCjo1SWWfr0Cj0BP0pgxmnwovI2YeaKD3UB5G3y7o9+fWF6ZJ1682jdfZh+qPEpDzTDZ6qp1Lpv9iVi7CZSfwHj9R087A3pUhY72/4vm/GoTQzR69h8PrXATANCQk4Q2jhQ8al5Th8TDzOs1jihGhrBrvBMvVONBZw2CWg0sUPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770661468; c=relaxed/simple;
	bh=/y5nmLlXQLhCviH9PrlLmywFCW/fop04ZmG+mbppY3I=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dd/w3SytecH5Iq7kKsPThQcc9y9pOjMELWOvuZR6KznodGHRjMeUl2/6dMYvRdEigDBcvvXUrKrUo8WkJ2BisnRJ3soIet5+qSUQOKCSkeCjvkfHDLpKNr7g1ZfGSHCCTP0hQzoKLsmJ3gJ1Hnzz+1fqI9QA3anZ+gA0HafVCFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V6VZKkhb; arc=pass smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-948aec218a2so911005241.0
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 10:24:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770661467; cv=none;
        d=google.com; s=arc-20240605;
        b=GkCJjyPulJRtKMFmwaRh0axeLcWXkqgnTNBHMIOqVJjiWN9sl7WArR197xVbJ788gH
         1lAeDEy1HruxayubRF/lp0Mk3CPjtyKlm/xudo3//HIEFQHBYY5kDNnSV5TA51zF6YB2
         MB0GmfexNGbAXD02/U+2N2NdJYU/eVBSIzydwMsbtKm5DzbyiSLeYb78z3sVXdMizf2h
         WkEWJhNa5pyuCOeCK7DJG68mRcLILeBAGP4iuCyyVu//2Hf12/4aPT5Il4c2a5AKUjCK
         0sc03OS0u901VJpnKz8lSXiGEUMFBOR1NDQ15vzWGVo3MWX9y8S6+2GiT8sXNz86p3n3
         rfzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=knxAurKXk3YU+SswynnCpuXiiPFYkxdHw8waIdMc0o8=;
        fh=d+TTK/Z03JguW58HVEgMSwiia30O1SerGJLofe0SRpk=;
        b=SZX+AnJK+9rElmFVlEp3g/Qvpsw4fk56EhCkhxnHmonX5LACmF0HcdKVkN6JJBa4Kz
         dY8jSz+9VAG9qMglsk+VDsO+tczTsSN+1gXZleez1awiVN9sbwa31MjpLETxXdluVBZ4
         CCTNOstZ5+KGy6lH6TbjSllW/hNsb+dwvqj0X3cEce1tpfmqD6SDr92sSql6eI+HfG84
         HeGgT65LWqE7BYv1+ijhjR3bmpvuOiB8IF0xo076pwDFVGK7ZllEQIX4bMW12YtXzw9G
         Pj2RDfxB+KcKm12W4x+kFSmpvFkXwks9F3hDwZX7x5jBSWWU5y1YLb9OfWHNDoUkXs/E
         El/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770661467; x=1771266267; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=knxAurKXk3YU+SswynnCpuXiiPFYkxdHw8waIdMc0o8=;
        b=V6VZKkhbA/0oBWz3sh1UqlSEkb1Lg54WOWcPnMvipCiVCh5094Ay5rk/cmzIJjVUv3
         AZbN/mlKyzWmYwsoTtHMCExzi3r/9/zVp98G1xXmTNg9lK3oG+Fd2VwJeKp1xYehqDUw
         5UeMv6QZ/JaWRvvb/nkKiY/YAGo5HQ/9bbq/+4Pn5Xo0L7mBt4gWAUgm/iCWTyozxFb8
         g2chRWJZIiIhJE1ZummrEPbdHOa5oluvWesE9U7Y9HlJzbsdcPPnRvqmooGiHLT1HvCM
         A1QPMDsGxZ7EeSEhivY1k8wUgtWfAGxcpsOPvm3XRBwXoF0melK0JvWhvlHqEUsf6le8
         SUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770661467; x=1771266267;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=knxAurKXk3YU+SswynnCpuXiiPFYkxdHw8waIdMc0o8=;
        b=Nj/ot34YX3pJz3o3mlaIHbhBwYcZQeNJsOO6sffaMD3SLsBeWaAQQLXr7ZDWMYxNoU
         NlQoAzvP2ys/YyUEbHBGTbcABku3ns5+2yUL5Zad6NhF5AwtmRehVsxkRo/jVK9vnctH
         CNDNNG5NgitRUp3WsqNIbKiSqkxi8J5g2EJ/J/mfjy1ILxtCirpivRSBo155YnFzLPo5
         dUMhOk0dPK8aiUBK9oZBw+8qthb2gehmd8TTPplwbl7AopvMuPleoJ8UK3KF8JqxYbuK
         ce+TdY2sD7+96sm2zEISrxw3ThkNiRBbKOIZQHOUuDfzoG3dIynDXqVME0vzmmFVbJ6s
         VZmw==
X-Forwarded-Encrypted: i=1; AJvYcCXyRBmrPE0lJ2eP+TbWKgS+VrT15bdq4ta/MAgk/cTnR4ejkkUj3dJ7TPan7NHMPy8aPhU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvodJsyUPCXMwYx0gGcVtKVZhnMWNX86uPKGvV6KCm51UirHM0
	zVbRON56JdR5eU4diZ73IiCqeWAXbP0PL0GJlRYJ8kQURIXyBROz/Ec1PrAU7iMksepdjJDI7ut
	gPD7golzFc9Jn2G8d59HM/mvWFTFHc3ohmq1yJjUNnZDOmc6mGYuia8Le
X-Gm-Gg: AZuq6aKCwUjEpGhDZzutAVWXrl9fj0DH9Q5I2L0mCK6AW3WubNufLMgQ5ITDO9fIceX
	swm+hFYBnS/LJfQ0qtsvaABRKnKcmvPWqRScukkFM5xqB1N5Bz4c7/x74hDES8T1v8KkSu9Dd7m
	ylHnKf4bxgKpuW60SjkoQZkcApmbManqy3y3kEnWmGGnNd7ucEy5JOID4NvGRdCV+aIE7THcWxq
	z1tklurTVm0r2XcjL4ZLNEvwK183NLzl7vrpGRBy2C6jWKGnneeyJXjMFHBAu/OpSp7FndD2hIc
	WcWEgeQqS3EHJZUzoPVfXFap4g==
X-Received: by 2002:a05:6102:548c:b0:5ee:a0e6:a9fa with SMTP id
 ada2fe7eead31-5fae8bdfc90mr2529903137.23.1770661466665; Mon, 09 Feb 2026
 10:24:26 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Feb 2026 10:24:25 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Feb 2026 10:24:25 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <442d7ce8-0de3-4f5a-95ed-3be9bdaa7e47@kernel.org>
References: <697d115a.050a0220.1d61ec.0004.GAE@google.com> <20260204170144.2904483-1-ackerleytng@google.com>
 <CAEvNRgF75EsHL8idLzFzbk0K9uhE70AMj5Vitp4cKNg_5WqQKw@mail.gmail.com>
 <aYO8DLCWw8FEQUAU@google.com> <16e5a36e-fff0-4a54-9c5c-a8e411659108@kernel.org>
 <CAEvNRgHX7MPSBX7pMeSWEtzc0-bJhAZ=pv+WF0VtOv9Tx0Jpxw@mail.gmail.com>
 <CAEvNRgEO3gB6Oee2C-+8Pu=+3KY0C98yrmesKO2SMVSvs3anfA@mail.gmail.com> <442d7ce8-0de3-4f5a-95ed-3be9bdaa7e47@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 9 Feb 2026 10:24:25 -0800
X-Gm-Features: AZwV_QideQblMqXKmM93A8Pb9qlXINufpsWOEyzQRrYiS1lOu-e-I9-SEnVm9ro
Message-ID: <CAEvNRgGjcMY-DMLu1ZaCRXA8uCeueBD9a-a1gh-UEB7nqpfTfg@mail.gmail.com>
Subject: Re: [PATCH] KVM: guest_memfd: Disable VMA merging with VM_DONTEXPAND
To: "David Hildenbrand (Arm)" <david@kernel.org>, Sean Christopherson <seanjc@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[syzkaller.appspotmail.com,vger.kernel.org,redhat.com,googlegroups.com,amd.com,google.com,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70636-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Queue-Id: 8AB08113815
X-Rspamd-Action: no action

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 2/8/26 18:34, Ackerley Tng wrote:
>> Ackerley Tng <ackerleytng@google.com> writes:
>>
>>>
>>> [...snip...]
>>>
>>>> !thp_vma_allowable_order() must take care of that somehow down in
>>>> __thp_vma_allowable_orders(), by checking the file).
>>>>
>>>> Likely the file_thp_enabled() check is the culprit with
>>>> CONFIG_READ_ONLY_THP_FOR_FS?
>>>>
>>>> Maybe we need a flag to say "even not CONFIG_READ_ONLY_THP_FOR_FS".
>>>>
>>>> I wonder how we handle that for secretmem. Too late for me, going to bed :)
>>>>
>>>
>>> Let me look deeper into this. Thanks!
>>>
>>
>> I trimmed the repro to this:
>>
>> static void test_guest_memfd_repro(void)
>> {
>> 	struct kvm_vcpu *vcpu;
>> 	uint8_t *unaligned_mem;
>> 	struct kvm_vm *vm;
>> 	uint8_t *mem;
>> 	int fd;
>>
>> 	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);
>>
>> 	fd = vm_create_guest_memfd(vm, SZ_2M * 2, GUEST_MEMFD_FLAG_MMAP |
>> GUEST_MEMFD_FLAG_INIT_SHARED);
>>
>> 	unaligned_mem = mmap(NULL, SZ_2M + SZ_2M, PROT_READ | PROT_WRITE,
>> MAP_FIXED | MAP_SHARED, fd, 0);
>> 	mem = align_ptr_up(unaligned_mem, SZ_2M);
>> 	TEST_ASSERT(((unsigned long)mem & (SZ_2M - 1)) == 0, "returned
>> address must be aligned to SZ_2M");
>>
>> 	TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_HUGEPAGE), 0);
>>
>> 	for (int i = 0; i < SZ_2M; i += SZ_4K)
>> 		READ_ONCE(mem[i]);
>>
>> 	TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_COLLAPSE), 0);
>>
>> 	TEST_ASSERT_EQ(madvise(mem, SZ_2M, MADV_DONTNEED), 0);
>>
>> 	/* This triggers the WARNing. */
>> 	READ_ONCE(mem[0]);
>>
>> 	munmap(unaligned_mem, SZ_2M * 2);
>>
>> 	close(fd);
>> 	kvm_vm_free(vm);
>> }
>>
>> And tried to replace the fd creation the secretmem equivalent
>>
>> 	fd = syscall(__NR_memfd_secret, 0);
>> 	TEST_ASSERT(fd >= 0, "Couldn't create secretmem fd.");
>> 	TEST_ASSERT_EQ(ftruncate(fd, SZ_2M * 2), 0);
>>
>> Should a guest_memfd selftest be added to cover this?
>>
>> MADV_COLLAPSE fails with EINVAL, but it does go through to
>> hpage_collapse_scan_file() -> collapse_file(), before failing because
>> when collapsing the page, copy_mc_highpage() returns > 0.
>
> Just what I suspected. :)
>
> Thanks for digging into the details!
>

Happy to help :)

In general, do we want the reproducers added as selftests? Should this
be added as part of tools/testing/selftests/kvm/guest_memfd_test.c or a
separate file?

> --
> Cheers,
>
> David

