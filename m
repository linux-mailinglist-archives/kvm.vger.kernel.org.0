Return-Path: <kvm+bounces-1365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E59B17E7224
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 20:21:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B020B20E13
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 19:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E9E358B4;
	Thu,  9 Nov 2023 19:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gyWQZYVa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1E332C82
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 19:20:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19603A84
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699557647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eO/0Jt9WjQLQJ2tjUlgRHHKcBUo0A0zlhcFJJ9NaV04=;
	b=gyWQZYVawYw0UuEjcBpvAm8ASIXSYAr7JDiwXWWQ8xt4JaBOjkGKCpre/CXUgKq7Nlyymg
	BNPkAkJsB57fYO60hLjDtwmnXILusDaVJJij0zhCxICx8pUCQvXAPopTZ0ltbmIquHP5DJ
	Ifp79nisQ32vuaLSGfDQRuPA4X8020s=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-ne7mG9ICN2mNI3vzZkOxCA-1; Thu, 09 Nov 2023 14:20:46 -0500
X-MC-Unique: ne7mG9ICN2mNI3vzZkOxCA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-778a5286540so10363385a.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 11:20:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699557646; x=1700162446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eO/0Jt9WjQLQJ2tjUlgRHHKcBUo0A0zlhcFJJ9NaV04=;
        b=nJni58moDIAVFH4DGmN/laf/QV677QnVp0XAZF6fmoZkazYoYfE0UsJ03TImRDP0QO
         sSvudkyyE8QCg88xGMAZ/6rZBMGa876dCb4zmXytXlcKI3aY+LpTN96zY+lIFpqE3B1d
         P41g+5ILIF2ts/2XZRw0RW4VFL1b0YMfCsBy/4NkfDN711DgbKMeuBL0mCkjjjAB1+m9
         8Unb5HNKOWFJxZF0ppaUd24jz7JwaDsPBWDpup63c02YoVwdE6NiANLEljizHo893Jql
         btnWBhyR5lTpyRelpSav7GJk9Hgg8vdcaf5BKEdEzUQQTnn5gTqpFXbRKQgyjU6M6dXo
         TQcw==
X-Gm-Message-State: AOJu0YzKOLTXjGkGegya8VAGK1t8FvCNjxW696IqE28NrMsR9ZuVqDzo
	Ggi46U3PeJCLWuNdbH3K5CSqZeFgmge0yNeF/f2NJtLJ9WzXSCVi+1V/I+rMlj90eBKfKYass39
	X/Id/ZDTEgKT1
X-Received: by 2002:a05:620a:199a:b0:778:6059:c368 with SMTP id bm26-20020a05620a199a00b007786059c368mr6014760qkb.7.1699557646139;
        Thu, 09 Nov 2023 11:20:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGshO7hpcVjpep4LIy3p1T169N8dU3HjhtEmSq7v1M2W67IeMct6/hC5KdpH/pu8wiJZ3XS3A==
X-Received: by 2002:a05:620a:199a:b0:778:6059:c368 with SMTP id bm26-20020a05620a199a00b007786059c368mr6014744qkb.7.1699557645878;
        Thu, 09 Nov 2023 11:20:45 -0800 (PST)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id j3-20020a05620a288300b0077411a459a8sm128963qkp.4.2023.11.09.11.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 11:20:45 -0800 (PST)
Date: Thu, 9 Nov 2023 14:20:43 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
	James Houghton <jthoughton@google.com>,
	Oliver Upton <oupton@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
Message-ID: <ZU0xCwvkKcpzBwc-@x1n>
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n>
 <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <ZUq6LJ+YppFlf43f@x1n>
 <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
 <ZU0d2fq5zah5jxf1@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZU0d2fq5zah5jxf1@google.com>

On Thu, Nov 09, 2023 at 09:58:49AM -0800, Sean Christopherson wrote:
> guest_memfd isn't intended to be a wholesale replacement of VMA-based memory.
> IMO, use cases that want to dynamically manage guest memory should be firmly
> out-of-scope for guest_memfd.

I'm not sure whether that will keep true for a longer period (e.g. 5-10
years, or more?), but it makes sense to me for now, at least we don't
already decide to reimplement everything.

If the use case grows and CoCo will become the de-facto standard, hopefully
there's always possibility to refactor mm features that CoCo will need to
cooperate with gmemfd, I guess.

> 
> > Paolo, it sounds like overall my proposal has limited value outside of
> > GCE's use-case. And even if it landed upstream, it would bifrucate KVM
> > VM post-copy support. So I think it's probably not worth pursuing
> > further. Do you think that's a fair assessment? Getting a clear NACK
> > on pushing this proposal upstream would be a nice outcome here since
> > it helps inform our next steps.
> > 
> > That being said, we still don't have an upstream solution for 1G
> > post-copy, which James pointed out is really the core issue. But there
> > are other avenues we can explore in that direction such as cleaning up
> > HugeTLB (very nebulous) or adding 1G+mmap()+userfaultfd support to
> > guest_memfd. The latter seems promising.
> 
> mmap()+userfaultfd is the answer for userspace and vhost, but it is most defintiely
> not the answer for guest_memfd within KVM.  The main selling point of guest_memfd
> is that it doesn't require mapping the memory into userspace, i.e. userfaultfd
> can't be the answer for KVM accesses unless we bastardize the entire concept of
> guest_memfd.

Note that I don't think userfaultfd needs to be bound to VA, even if it is
for now..

> And as I've proposed internally, the other thing related to live migration that I
> think KVM should support is the ability to performantly and non-destructively freeze
> guest memory, e.g. to allowing blocking KVM accesses to guest memory during blackout
> without requiring userspace to destroy memslots to harden against memory corruption
> due to KVM writing guest memory after userspace has taken the final snapshot of the
> dirty bitmap.

Any pointer to this problem you're describing?  Why the userspace cannot
have full control of when to quiesce guest memory accesses (probably by
kicking all vcpus out)?

> For both cases, KVM will need choke points on all accesses to guest memory.  Once
> the choke points exist and we have signed up to maintain them, the extra burden of
> gracefully handling "missing" memory versus frozen memory should be relatively
> small, e.g. it'll mainly be the notify-and-wait uAPI.
> 
> Don't get me wrong, I think Google's demand paging implementation should die a slow,
> horrible death.   But I don't think userfaultfd is the answer for guest_memfd.

As I replied in the other thread, I see possibility implementing
userfaultfd on gmemfd, especially after I know your plan now treating
user/kernel the same way.

But I don't know whether I could have missed something here and there, and
I'd like to read the problem first on above to understand the relationship
between that "freeze guest mem" idea and the demand paging scheme.

One thing I'd agree is we don't necessarily need to squash userfaultfd into
gmemfd support of demand paging.  If gmemfd will only be used in KVM
context then indeed it at least won't make a major difference; but still
good if the messaging framework can be leveraged, meanwhile userspace that
already support userfaultfd can cooperate with gmemfd much easier.

In general, a major part of userfaultfd is really a messaging interface for
faults to me.  A fault trap mechanism will be needed anyway for gmemfd,
AFAIU. When that comes maybe we can have a clearer mind of what's next.

Thanks,

-- 
Peter Xu


