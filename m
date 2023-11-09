Return-Path: <kvm+bounces-1355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B277E6F89
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 17:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A0631C20AB4
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 16:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9C2225DD;
	Thu,  9 Nov 2023 16:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cxFerNQl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2E3225CF
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:42:04 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8954C11
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 08:42:04 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-32da7ac5c4fso636551f8f.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 08:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699548122; x=1700152922; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzQkbLCuMidm6Xjw+1NLPXS+0gvplCc7hnkCbAiJ1vY=;
        b=cxFerNQlWyAu3PAMSAy3d41JID53B7xt0rmwOWs9mvmfu/vOyZHD9BVVl/sfCuDppF
         sbgUkqsWngQfO80ibvJsKyoKWj0sH3YFLuoRpPFVVW6q+ifQyMbZshMkqBwYlYLbQh0Q
         3RF7D6GmbYhCFH3XIHZf6kFEv4x81qHdP8DxXeDi2idEaUltXZCJJ/+QCAZXUijnoJ8v
         dZRZ2hPpQqK3VZIz5sK0wBYt9zpMYuqA+NYgHeOlA6YEMpZqhhPLmdz4OhbnLYLoHmwP
         3cXzqwk1SWy73IwU/JoSYqLweocPRs1EYUQ5PhHr7QI3joOdmJNf9eR3XZGWrLSrIR4q
         EX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699548122; x=1700152922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JzQkbLCuMidm6Xjw+1NLPXS+0gvplCc7hnkCbAiJ1vY=;
        b=Nqqa1eas2GYOg5F/F27lL4aW1Xw7gwekTgXO8j5DOtjdRoKIMUuvEjGspBoxAwAW/c
         EGfL1k48pEKWf/syDKmhy5eeeTkhuzX+SUjv9x1B60CfQTKBvEJq3t0b0KEm3buNvZWr
         HoEsPHO7mhvEb0w5+4Ov1/ifmn2a/6UWE87/OuTACBkpt7kjeByq1hQoE2KLBIPaUlF0
         CMoTipzFeP5JMpbKgFxyzq3xxRG9IdEqL1FaJbn3QhBZtFWSufbbmuR2MCQFPwv6EVVb
         NJTW5HsgueaTUSlv+MYsFWISzaXlNZaz4mOAs9pAmNRR/jTUyFcgonmIz4CbrnhBr6M9
         +S0A==
X-Gm-Message-State: AOJu0Yzunx2DFSdEb1PEshwfy7OSqUPX1X64XQde0eA7nBqW0aaXFyGT
	LQ701AMkvoF223sdFjCPKGKBBC7lWV6ckdsqo3rcaQ==
X-Google-Smtp-Source: AGHT+IGJn1Mqk4c9grqBIQZknp7AKef4IRwqtC4jj3BCjOclgyelpttEi8I6Pe/9xAZ2nUv6wBgSLP/HlmzPnEDkxTw=
X-Received: by 2002:a5d:6d4d:0:b0:31f:d2dc:df26 with SMTP id
 k13-20020a5d6d4d000000b0031fd2dcdf26mr4284751wri.28.1699548122488; Thu, 09
 Nov 2023 08:42:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com> <ZUq6LJ+YppFlf43f@x1n>
In-Reply-To: <ZUq6LJ+YppFlf43f@x1n>
From: David Matlack <dmatlack@google.com>
Date: Thu, 9 Nov 2023 08:41:33 -0800
Message-ID: <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Peter Xu <peterx@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 2:29=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
> On Tue, Nov 07, 2023 at 05:25:06PM +0100, Paolo Bonzini wrote:
> > On 11/6/23 21:23, Peter Xu wrote:
> > > On Mon, Nov 06, 2023 at 10:25:13AM -0800, David Matlack wrote:
> > >
> >
> > Once you have the implementation done for guest_memfd, it is interestin=
g to
> > see how easily it extends to other, userspace-mappable kinds of memory.=
  But
> > I still dislike the fact that you need some kind of extra protocol in
> > userspace, for multi-process VMMs.  This is the kind of thing that the
> > kernel is supposed to facilitate.  I'd like it to do _more_ of that (se=
e
> > above memfd pseudo-suggestion), not less.
>
> Is that our future plan to extend gmemfd to normal memories?
>
> I see that gmemfd manages folio on its own.  I think it'll make perfect
> sense if it's for use in CoCo context, where the memory is so special to =
be
> generic anyway.
>
> However if to extend it to generic memories, I'm wondering how do we
> support existing memory features of such memory which already exist with
> KVM_SET_USER_MEMORY_REGION v1.  To name some:
>
>   - numa awareness
>   - swapping
>   - cgroup
>   - punch hole (in a huge page, aka, thp split)
>   - cma allocations for huge pages / page migrations
>   - ...

Sean has stated that he doesn't want guest_memfd to support swap. So I
don't think guest_memfd will one day replace all guest memory
use-cases. That also means that my idea to extend my proposal to
guest_memfd VMAs has limited value. VMs that do not use guest_memfd
would not be able to use it.

Paolo, it sounds like overall my proposal has limited value outside of
GCE's use-case. And even if it landed upstream, it would bifrucate KVM
VM post-copy support. So I think it's probably not worth pursuing
further. Do you think that's a fair assessment? Getting a clear NACK
on pushing this proposal upstream would be a nice outcome here since
it helps inform our next steps.

That being said, we still don't have an upstream solution for 1G
post-copy, which James pointed out is really the core issue. But there
are other avenues we can explore in that direction such as cleaning up
HugeTLB (very nebulous) or adding 1G+mmap()+userfaultfd support to
guest_memfd. The latter seems promising.

