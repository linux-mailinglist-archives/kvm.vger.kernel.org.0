Return-Path: <kvm+bounces-1030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80C447E45F2
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 17:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B65F3B20EEA
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1E6328CD;
	Tue,  7 Nov 2023 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4PgiLNA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41433328AF
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:25:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65B4325E
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 08:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699374317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1oj2zUCe4iwb1JbZZEDIZKLrowYeaByvajjEffx0qTs=;
	b=X4PgiLNAE7C3rhftBcMiIIajx8jg2Fl4XtXs7NXdt/2X+vaecLhVRnj490ztfJWnU1N086
	5MisxWTKyPCtIQe/8u1JbWmLIVdzHseAdHIvauQjWioiIVkIFciK2/nMfONxtC6CATS9vQ
	rnw4ZnXu5sS6W7gTbY9wNhI7S/saAZA=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-0vqZick-OJ6mbCIkpNbpeg-1; Tue, 07 Nov 2023 11:25:11 -0500
X-MC-Unique: 0vqZick-OJ6mbCIkpNbpeg-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c51a7df557so50741831fa.0
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 08:25:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699374309; x=1699979109;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1oj2zUCe4iwb1JbZZEDIZKLrowYeaByvajjEffx0qTs=;
        b=TTRP9B69pg4+lLjPT0aADW6cKsZ5qQBxmN4ZVXhWqmUiXpkhFCJdNNUriSD/CVh9gO
         bdNOBi+NL/J64ZMVMo0YuEmyUBsPKBKHtBaf5Mxd+UIh9h+QUF58Y7F62t/JPIzGkcOD
         iihYS7c6secLmZrhEW+Ph0t2YC9U6ys36yLR3o7qh2e3GjSm8YykesMkJ0pPc/t0VDZf
         YhkcFLbw46hdNQqLvaEzlFXMSdSGPX52iarRI4zryt9pEjhGmBtdB3enJd1czdNfMfNE
         vNr+eRoKo1CjmIQgJgBKszg41d20XJuSlKtA+blshDgZft4cDx8HhwgsnqkfQkqYRT2z
         xRyg==
X-Gm-Message-State: AOJu0YwlVZqOasak+zL7EOF4DVHXiY54JfB3eQP9QUZmu3IXpkJPcVOq
	JfgVhIrRcucmbGnT80wm9KM410KyOwVfwK0ciPhMZ95K8AnBmGb3ksyWm92qFWEmVltVKcSzxa1
	PjBIgjS0qyLmc
X-Received: by 2002:a2e:8796:0:b0:2bc:f5a0:cc25 with SMTP id n22-20020a2e8796000000b002bcf5a0cc25mr25771042lji.2.1699374309631;
        Tue, 07 Nov 2023 08:25:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEh8a2S/CgmIC36EZ04PCliCm9FE8bZhgHS+Kw5ss+b3Ti3fxYx+JDit77KPZ4yTzXUMfJEqQ==
X-Received: by 2002:a2e:8796:0:b0:2bc:f5a0:cc25 with SMTP id n22-20020a2e8796000000b002bcf5a0cc25mr25771015lji.2.1699374309186;
        Tue, 07 Nov 2023 08:25:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n37-20020a05600c3ba500b003fee6e170f9sm16565129wms.45.2023.11.07.08.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 08:25:08 -0800 (PST)
Message-ID: <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
Date: Tue, 7 Nov 2023 17:25:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Content-Language: en-US
To: Peter Xu <peterx@redhat.com>, David Matlack <dmatlack@google.com>
Cc: kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Andrea Arcangeli <aarcange@redhat.com>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZUlLLGLi1IyMyhm4@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 21:23, Peter Xu wrote:
> On Mon, Nov 06, 2023 at 10:25:13AM -0800, David Matlack wrote:
>> Hi Paolo,
>>
>> I'd like your feedback on whether you would merge a KVM-specific
>> alternative to UserfaultFD.

I'm reply to Peter's message because he already brought up some points 
that I'd have made...

>>    (b) UAPIs for marking GFNs present and non-present.
> 
> Similar, this is something bound to above bitmap design, and not needed for
> uffd.  Extra interface?

We already use fallocate APIs to mark GFNs non-present in guest_memfd; 
and we also use them to mark GFNs present but it would not work to do 
that for atomic copy-and-allocate.  This UAPI could be pwrite() or a 
ioctl().

>>    (c) KVM_RUN support for returning to userspace on guest page faults
>> to non-present GFNs.
> 
> For (1), if the time to resolve a remote page fault is bottlenecked on the
> network, concurrency may not matter a huge deal, IMHO.

That's likely, and it means we could simply extend 
KVM_EXIT_MEMORY_FAULT.  However, we need to be careful not to have a 
maze of twisty APIs, all different.

>>    (d) A notification mechanism and wait queue to coordinate KVM
>> accesses to non-present GFNs.
> 
> Probably uffd's wait queue to be reimplemented more or less.
> Is this only used when there's no vcpu thread context?  I remember Anish's
> other proposal on vcpu exit can already achieve similar without the queue.

I think this synchronization can be done mostly in userspace, at least 
on x86 (just like we got rid of the global VM-level dirty ring). But it 
remains a problem on Arm.

>>    (e) UAPI or KVM policy for collapsing SPTEs into huge pages as guest
>> memory becomes present.
> 
> This interface will also be needed if with userfaultfd, but if with uffd
> it'll be a common interface so can be used outside VM context.

And it can be a generic API anyway (could be fadvise).

>> So why merge a KVM-specific alternative to UserfaultFD?
>>
>> Taking a step back, let's look at what UserfaultFD is actually
>> providing for KVM VMs:
>>
>>    1. Coordination of userspace accesses to guest memory.
>>    2. Coordination of KVM+guest accesses to guest memory.
>>
>> VMMs already need to
>> manually intercept userspace _writes_ to guest memory to implement
>> dirty tracking efficiently. It's a small step beyond that to intercept
>> both reads and writes for post-copy. And VMMs are increasingly
>> multi-process. UserfaultFD provides coordination within a process but
>> VMMs already need to deal with coordinating across processes already.
>> i.e. UserfaultFD is only solving part of the problem for (1.).

This is partly true but it is missing non-vCPU kernel accesses, and it's 
what worries me the most if you propose this as a generic mechanism.  My 
gut feeling even without reading everything was (and it was confirmed 
after): I am open to merging some specific features that close holes in 
the userfaultfd API, but in general I like the unification between 
guest, userspace *and kernel* accesses that userfaultfd brings. The fact 
that it includes VGIC on Arm is a cherry on top. :)

For things other than guest_memfd, I want to ask Peter & co. if there 
could be a variant of userfaultfd that is better integrated with memfd, 
and solve the multi-process VMM issue.  For example, maybe a 
userfaultfd-like mechanism for memfd could handle missing faults from 
_any_ VMA for the memfd.

However, guest_memfd could be a good usecase for the mechanism that you 
suggest.  Currently guest_memfd cannot be mapped in userspace pages.  As 
such it cannot be used with userfaultfd.  Furthermore, because it is 
only mapped by hypervisor page tables, or written via hypervisor APIs, 
guest_memfd can easily track presence at 4KB granularity even if backed 
by huge pages.  That could be a point in favor of a KVM-specific solution.

Also, even if we envision mmap() support as one of the future extensions 
of guest_memfd, that does not mean you can use it together with 
userfaultfd.  For example, if we had restrictedmem-backed guest_memfd, 
or non-struct-page-backed guest_memfd, mmap() would be creating a 
VM_PFNMAP area.

Once you have the implementation done for guest_memfd, it is interesting 
to see how easily it extends to other, userspace-mappable kinds of 
memory.  But I still dislike the fact that you need some kind of extra 
protocol in userspace, for multi-process VMMs.  This is the kind of 
thing that the kernel is supposed to facilitate.  I'd like it to do 
_more_ of that (see above memfd pseudo-suggestion), not less.

>> All of these are addressed with a KVM-specific solution. A
>> KVM-specific solution can have:
>>
>>    * Transparent support for any backing memory subsystem (tmpfs,
>>      HugeTLB, and even guest_memfd).
> 
> I'm curious how hard would it be to allow guest_memfd support userfaultfd.
> David, do you know?

Did I answer above?  I suppose you'd have something along the lines of 
vma_is_shmem() added to vma_can_userfault; or possibly add something to 
vm_ops to bridge the differences.

> The rest are already supported by uffd so I assume not a major problem.

Userfaultfd is kinda unusable for 1GB pages so I'm not sure I'd include 
it in the "already works" side, but yeah.

Paolo


