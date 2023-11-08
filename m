Return-Path: <kvm+bounces-1276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C2677E5F3E
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:33:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BAC91C20C21
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3C9374CB;
	Wed,  8 Nov 2023 20:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eife3oe2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A1F374C7
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:33:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD961B5
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 12:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699475625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ayI+89hfuZMCOiMpRAKZAscykhUCpA4/hKQmlOEh/Z0=;
	b=Eife3oe2JqW39TdJC8pbvK2JaJm2xoL0dItvq+Gkvg/C/OTidxsa94lQyFRBls68fEQ4sp
	oSDjtXuIdC7Vr38pJxTPvWP7OVnla56uCxOa9eWionJPhuZVelN+cducNkIobrBPUNIjSQ
	G1fS+F/Argl63Q0scXz5TZBVfeQHtlU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-LAvM6WI7PYWj8JtNPekSMg-1; Wed, 08 Nov 2023 15:33:44 -0500
X-MC-Unique: LAvM6WI7PYWj8JtNPekSMg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9d28dd67464so10618366b.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 12:33:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699475623; x=1700080423;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ayI+89hfuZMCOiMpRAKZAscykhUCpA4/hKQmlOEh/Z0=;
        b=lgBo3epAipOm3r84y7mLCnaCxQ93e+BP9F0BTcH94p9MErMOBjJ5Iu//vovD+uN08p
         jFgR/HeBUCyYx4NGikZ+A35/dee5Vujc2imh0NWZMVE2JdjngCQCKQeVDZXj3GEpkBzk
         7ebNGVaNlvZnEJ9PoyvqAK3fbjBHVcNc8CXiVwuIxUJS+BC9oF2EHMoznys+rGSW4c8U
         50LIddV9INFfN5mvHy3C3VJE++C0aiv8jpSr+dqIJWHAaHejBvgZCFzh/bYRGrGVFL8U
         SyaBldNs2nS3Ote6OGhWQBU1amc3wrA3OF4tr4kXnLhA9Y+4t94kHWezGj5t0yiID2OY
         nAzQ==
X-Gm-Message-State: AOJu0YwwUnmcYwk7Ic7inPjD1+15RjuNAkeuGpNEJx1U0Jvyk7KqhLWc
	IAjhlw1vo40/H3y5njgphfetM8R92Ldqi6ofJqYQO39tJQOafgiI+DNh6BmaGJk7R6fjAprw0DS
	Usr5mNDkNR/gC
X-Received: by 2002:a17:907:9692:b0:9b2:f941:6916 with SMTP id hd18-20020a170907969200b009b2f9416916mr2617562ejc.17.1699475622950;
        Wed, 08 Nov 2023 12:33:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUpQsuWu1IpYUSl+Z7/jRsDzeM9LW1wZBkb0YXA53FF1QAVBUgJ3Y5vSQW3mtOK3EMhcLRhA==
X-Received: by 2002:a17:907:9692:b0:9b2:f941:6916 with SMTP id hd18-20020a170907969200b009b2f9416916mr2617543ejc.17.1699475622651;
        Wed, 08 Nov 2023 12:33:42 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id q24-20020a1709066b1800b009b2ca104988sm1573373ejr.98.2023.11.08.12.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Nov 2023 12:33:42 -0800 (PST)
Message-ID: <8109b040-1268-4096-ad31-34a89e0ddf46@redhat.com>
Date: Wed, 8 Nov 2023 21:33:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Content-Language: en-US
To: David Matlack <dmatlack@google.com>, Oliver Upton <oliver.upton@linux.dev>
Cc: Peter Xu <peterx@redhat.com>, kvm list <kvm@vger.kernel.org>,
 Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>, Oliver Upton <oupton@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Andrea Arcangeli <aarcange@redhat.com>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <CALzav=ejfDDRdjtx-ipFYrhNWPZnj3P0RSNHOQCP+OQf5YGX5w@mail.gmail.com>
 <ZUqn0OwtNR19PDve@linux.dev>
 <CALzav=evOG04=mtnc9Tf=bevWq0PbW_2Q=2e=ErruXtE+3gDVQ@mail.gmail.com>
 <ZUrj8IK__59kHixL@linux.dev>
 <CALzav=dXDh4xAzDEbKOxLZkgjEyNs8VLoCOuJg4YYrD0=QzvGw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <CALzav=dXDh4xAzDEbKOxLZkgjEyNs8VLoCOuJg4YYrD0=QzvGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/23 17:56, David Matlack wrote:
> Thanks for the longer explanation. Yes kvm_read_guest() eventually calls 
> __copy_from_user() which will trigger a page fault and UserfaultFD will 
> notify userspace and wait for the page to become present. In the 
> KVM-specific proposal I outlined, calling kvm_read_guest() will 
> ultimately result in a check of the VM's present bitmap and KVM will 
> nnotify userspace and wait for the page to become present if it's not, 
> before calling __copy_from_user(). So I don't expect a KVM-specific 
> solution to have any increased maintenance burden for VGIC (or any other 
> widgets).

It does mean however that we need a cross-thread notification mechanism, 
instead of just relying on KVM_EXIT_MEMORY_FAULT (or another KVM_EXIT_*).

Paolo


