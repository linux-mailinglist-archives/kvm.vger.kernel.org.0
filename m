Return-Path: <kvm+bounces-71605-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6IawIct6nWmAQAQAu9opvQ
	(envelope-from <kvm+bounces-71605-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:17:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B8318535A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C64B315450E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D166377558;
	Tue, 24 Feb 2026 10:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xutZiDmS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5854A376BC8
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771928049; cv=pass; b=HJGwrXIt5hBmLjgiG88YDpy6dwqERY82unxOak+dkvB8S/iot04gWG6zaPKgEHP0uWsJrm92rkAed55bBv+twFsYjGQa1e4sTCxAUFdXfhrPN13+EOmDEICG9CPW9KHv1N54DD473ZW167q/Oxc/t1kHd3W5ahTvD1W0e7FRBKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771928049; c=relaxed/simple;
	bh=IyKhJiJuQRzoX6JzUZnwApPT0auX0X1bnVL6krBBBGY=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nlFuly0+WAHRzk2LL2DGZy0Vjm9v2nRBxmqZBwRbpNTtwBpWWb7lDnfqQrsoZOnTc+A7o+9C8/k5XRcUKUueqAJ9ErDBB2/eGQvnOzV3s9fsPm7zeQaMqrijQdniQFcxrYu3AHqsL8uc7ssjCOaqscyyBaa4azZ2g6xTdJZQEts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xutZiDmS; arc=pass smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5f9ed174ebcso2965663137.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 02:14:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771928047; cv=none;
        d=google.com; s=arc-20240605;
        b=NaJedhNOf1/mvJ1xMArk48MHIEWb54NxPzNX9jK9XzEBZHE7S7JpdKtKMIoM4l4ayY
         YonFVfNpZ0LHdCwwlGbStrdKkTgh3yBcW3ejU+Nn8yc0lCqiM0XKAaRbo8imi42svRij
         kz17c89/evtn03nLJHSE/vHrCWmUgfhfhU8zSVQSI4nLgAta6yALvvFxWDoSLOsfr8FZ
         iKKzpjjytjGKU8WyICHbjcGxXEAOiONp8xTenv/hi3Bk2PGjzv48a4tmx8/T1nbWbE3c
         NKCLxqKzgn4k4PN43wNOatjDdwJMiUEs4Qqnp2VUyvXv9g7xNQUwmKgr61kc33BJpbDz
         CXbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=LuhKBmL9p2A6pZ7W4MZ0PQ69Fw1Xjb7zt9bmn80iyFA=;
        fh=QuGRZV+lwkLB3Ja08qWMJmOBQhdHSed+R2+HERPlsPk=;
        b=OqCtib3lUu5Jth/jOIohMHsEUDaOlVziCthg9Dh1Y53cIa4oMwxzrYO8HrqRFtDgeP
         MmtHxBqVzyV9i0woX2Ps7IgMFajeFJve+DvwTr8c/5RuSkKufCujNcvxgeq7zUq7+a6Q
         k5T5sEqHdEmlq+8yjOJEyXK8+FbsRcXpu6y/LEWo4IlIxcgD7n6VnBoPNAmMcgQWSCb5
         oOXNMYLrzXeew/gP5C9Jiwx6zG42oisBafscu54wj2nVcJ0vYkqNbmILaPL9YYDEmrsH
         I3Bif12AVe0FD0tjZtBdPCF7vNQ9S8qJj9hdhSGY/0mCIDNtx+cY7pn7H6mlUvPNTA03
         hHMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771928047; x=1772532847; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=LuhKBmL9p2A6pZ7W4MZ0PQ69Fw1Xjb7zt9bmn80iyFA=;
        b=xutZiDmSUlD/DMw9tfRVwQ9hAjtus32ia4wnAOb4AbBw7jr2Pm/Xeyu4VTDbCOhraH
         MrgT5sQiAEgdjnlWVSDG2WKes5jO3DXmb/YOByUrMxO3MXnvVegtgdeaA9+2fF3Wq1Om
         u9Sv0YWyLXsQQd+5xV6tfBcgSbDj2yKpD5aCdSGwyMZACC0ZPvJX6Q39jfIp8NrTgJjw
         kyq5c4qxILldKJznLZvhwWn3nF/DgY5oMxa84BvNp7Jnaejlif8GJxMO6NswQUUEHtsQ
         DMl5rPYwO77Zq/dJ/jbcRSeY2UsVNhd2Nte7ea3TQgG/BmmYWAzBsySDJUuwnLu+KX14
         Nv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771928047; x=1772532847;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LuhKBmL9p2A6pZ7W4MZ0PQ69Fw1Xjb7zt9bmn80iyFA=;
        b=cbNh4D9OUDnjO5CJAO6SrzVlEXRXHXNnZBh0Z0iP6PozvfLnjdMwAhexMA+vYMGCga
         j8R4LvgK4FkTFQYrFs8OHQNPRe6pDsR2OJy/EnF8629mKuGfvvAOrqOSp/m1Lc3JHZD1
         dBTK8hLRN8x2qeEjzOis9hRK0fPDcxpWON1vEwQfK+kNIFOtFp93q79IGnfmCzd9eAvq
         PLTGoC6OA27gjbTxQo8u7cGmmhW/tyue6WMhSca3BM7rAwpvg1mB7DpHeALd0f4l8GLa
         /VYnrTi2pHa/hE6MZJkv5puz6Ehn8UlvSMt6DThmt+gEvh1v0iyO26X1yxY5DHyJc+ry
         09iQ==
X-Gm-Message-State: AOJu0YxKWVe08keOhT3SzW3hEh4Il3kBuF1iB7oaFvu8+OtUP7KvtVIA
	G+pjwjtz8rTneYP4AwGiYM9j8v2t0UME2jKWFu4yKSJSTs8q1Rt1ebdBj1Qd5EDYNB8GTCj8iN0
	fE4u6pl2YaTwRtUCEa9Z/fdRAa/8mUuZs85iZjhuiLAsN5l872bVLPxN0LUpHVA==
X-Gm-Gg: ATEYQzy+F7qcKsZRqM1B1HG5W3kuOI8/BKX6RcLRBiki2DR5k9sOir59A4bHhzIoXwX
	ZAnUb+XRtWlwfNuFRDysICKeGE6e/i4XiTWCrOR0RbRYYL9xK3IISA7wVnmmW0uQ5/EfXNlKghi
	/90Jd757275qGoGAyV0IanqIwtLFsnkuDhJjgSbnpHtLNU3oR1KHgibICBSBGOH3ezKquGJrx+9
	+3/+mz2s8d3p0ygYAtDnxs0nOnVUdN70SHyia6W86QyymrVm4aIaHtRT/0wKqYYiSkXf3AJL6MD
	untlWI2MrbRFScnpF0wGVNVUOb2fmpxGtDsSxE3s
X-Received: by 2002:a05:6102:e11:b0:5f8:d3b4:9517 with SMTP id
 ada2fe7eead31-5feb2c4ea4amr5648164137.0.1771928046467; Tue, 24 Feb 2026
 02:14:06 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 02:14:05 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 02:14:05 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgFMNywpDRr+WeNsVj=MnsbhZp9H3j0QRDo_eOP+kGCNJw@mail.gmail.com>
References: <cover.1770071243.git.ackerleytng@google.com> <86ad28b767524e1e654b9c960e39ca8bfb24c114.1770071243.git.ackerleytng@google.com>
 <CAEvNRgFMNywpDRr+WeNsVj=MnsbhZp9H3j0QRDo_eOP+kGCNJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 24 Feb 2026 02:14:05 -0800
X-Gm-Features: AaiRm51EKOaIOw7Xa64Dg1IqVEZq_6qI_aDRRZTOYQVamaSRRKhT7UeHK_oqjfM
Message-ID: <CAEvNRgFBLgvYoR_XTH-LiN1Q00R9u1HGC5URbstLPxYtedS0MA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/37] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_FROM(0.00)[bounces-71605-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[50];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E7B8318535A
X-Rspamd-Action: no action

Ackerley Tng <ackerleytng@google.com> writes:

> Ackerley Tng <ackerleytng@google.com> writes:
>
>>
>> [...snip...]
>>
> Before this lands, Sean wants, at the very minimum, an in-principle
> agreement on guest_memfd behavior with respect to whether or not memory
> should be preserved on conversion.
>>
>> [...snip...]
>>

Here's what I've come up with, following up from last guest_memfd
biweekly.

Every KVM_SET_MEMORY_ATTRIBUTES2 request will be accompanied by an
enum set_memory_attributes_content_policy:

    enum set_memory_attributes_content_policy {
    	SET_MEMORY_ATTRIBUTES_CONTENT_ZERO,
    	SET_MEMORY_ATTRIBUTES_CONTENT_READABLE,
    	SET_MEMORY_ATTRIBUTES_CONTENT_ENCRYPTED,
    }

Within guest_memfd's KVM_SET_MEMORY_ATTRIBUTES2 handler, guest_memfd
will make an arch call

    kvm_gmem_arch_content_policy_supported(kvm, policy, gfn, nr_pages)

where every arch will get to return some error if the requested policy
is not supported for the given range.

ZERO is the simplest of the above, it means that after the conversion
the memory will be zeroed for the next reader.

+ TDX and SNP today will support ZERO since the firmware handles
  zeroing.
+ pKVM and SW_PROTECTED_VM will apply software zeroing.
+ Purpose: having this policy in the API allows userspace to be sure
  that the memory is zeroed after the conversion - there is no need to
  zero again in userspace (addresses concern that Sean pointed out)

READABLE means that after the conversion, the memory is readable by
userspace (if converting to shared) or readable by the guest (if
converting to private).

+ TDX and SNP (today) can't support this, so return -EOPNOTSUPP
+ SW_PROTECTED_VM will support this and do nothing extra on
  conversion, since there is no encryption anyway and all content
  remains readable.
+ pKVM will make use of the arch function above.

Here's where I need input: (David's questions during the call about
the full flow beginning with the guest prompted this).

Since pKVM doesn't encrypt the memory contents, there must be some way
that pKVM can say no when userspace requests to convert and retain
READABLE contents? I think pKVM's arch function can be used to check
if the guest previously made a conversion request. Fuad, to check that
the guest made a conversion request, what's other parameters are
needed other than gfn and nr_pages?

ENCRYPTED means that after the conversion, the memory contents are
retained as-is, with no decryption.

+ TDX and SNP (today) can't support this, so return -EOPNOTSUPP
+ pKVM and SW_PROTECTED_VM can do nothing, but doing nothing retains
  READABLE content, not ENCRYPTED content, hence SW_PROTECTED_VM
  should return -EOPNOTSUPP.
+ Michael, you mentioned during the call that SNP is planning to
  introduce a policy that retains the ENCRYPTED version for a special
  GHCB call. ENCRYPTED is meant for that use case. Does it work? I'm
  assuming that SNP should only support this policy given some
  conditions, so would the arch call as described above work?
+ If this policy is specified on conversion from shared to private,
  always return -EOPNOTSUPP.
+ When this first lands, ENCRYPTED will not be a valid option, but I'm
  listing it here so we have line of sight to having this support.

READABLE and ENCRYPTED defines the state after conversion clearly
(instead of DONT_CARE or similar).

DESTROY could be another policy, which means that after the
conversion, the memory is unreadable. This is the option to address
what David brought up during the call, for cases where userspace knows
it is going to free the memory already and doesn't care about the
state as long as nobody gets to read it. This will not implemented
when feature first lands, but is presented here just to show how this
can be extended in future.

Right now, I'm thinking that one of the above policies MUST be
specified (not specifying a policy will result in -EINVAL).

How does this sound?

