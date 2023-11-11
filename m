Return-Path: <kvm+bounces-1517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 213FD7E8B9C
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 17:24:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF336280F32
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 16:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FAA1B28C;
	Sat, 11 Nov 2023 16:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gi3scYge"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44019BBF
	for <kvm@vger.kernel.org>; Sat, 11 Nov 2023 16:24:29 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1632F3A8E
	for <kvm@vger.kernel.org>; Sat, 11 Nov 2023 08:24:28 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-32dcd3e5f3fso1800226f8f.1
        for <kvm@vger.kernel.org>; Sat, 11 Nov 2023 08:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699719866; x=1700324666; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FtHH/xy5yD9SWJ9r7vM+VKfkMfUzYXUFkSgwCQ5s4s=;
        b=gi3scYgeluKWVIBk4jYjq0lC6DTKvQ5DJLFnp0KX0yH4VCBnFKCMey9fGaX7hQZa3c
         QU+Le3w70kqS+uMMMtMQnqIcmsyKg6c5h+sQ4PyDTcfXosG9ftwiU4+x9KmgPMBDuLdC
         CV7CFfVfbddFVq4RsbNkjh3mQoGtSOcDpo3F8XNxlaO05Q9jWYndUJpJst0aSaAwdIyd
         fbEU/9jn5FEjdaQBydh2ofaXax8eSNujrR3xOjd0LtNcTMUxWKcCfvUZiMRTLS4wN2hG
         yzMzRc4KFFIwPCaXkXMTiJ0IAG/jzoHv+bRrHyx6W/Jlg9lK19y0yDWMgj+lsHaJHXKV
         5rOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699719866; x=1700324666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5FtHH/xy5yD9SWJ9r7vM+VKfkMfUzYXUFkSgwCQ5s4s=;
        b=uOA4yN5YFLj+hAafOnv0Id+/FV1aEM1M1mRnrqD2XWpuc6/4o7NiJZI0E2oXU5xoeC
         yXEIN6YTDTLWrNlVCbnJJHb/LK2ILSO1HJLM5JSCsouUyFG/fV3gFl40yl7n0tUTI7cP
         +okOjJHYODolFd9WTOxCo4OkEQRHQNoM9Bvsra70kTOfg7dCENfLycVB0X9PGOGZG+Dn
         iNk5LSlZlptRaQ150fqbBF0uHgYxViO+2XSyKqdhd8T5V/oOeJxuXeZ2e7cNZl8kneHw
         IlsWIueEY/+0CiOWPYipjMPzLkjLvutOyh0sOdeoqmABKqbxp4ahJBh0tVzPaTv1z/jv
         Dz0A==
X-Gm-Message-State: AOJu0Yxbm1NEtTjxDT2QeElKPh3Hx+5f3Lmoz7+xqPvhEDey466ENdH6
	/JZqtgue6Ytt6CFawPRTehnVGNIf4G4rEyoJ3qKQXw==
X-Google-Smtp-Source: AGHT+IG2cuyRNju2kqQKpNXC93wmjYDmGObrjlBpo2WDkIAPO7yBbkPO1hIbLVllpUxePTNDV4+hBHBCxNH2FLv2f8I=
X-Received: by 2002:adf:9b95:0:b0:32d:a8bd:332a with SMTP id
 d21-20020adf9b95000000b0032da8bd332amr1463136wrc.30.1699719866344; Sat, 11
 Nov 2023 08:24:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <ZUq6LJ+YppFlf43f@x1n> <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
 <ZU0d2fq5zah5jxf1@google.com> <ZU0xCwvkKcpzBwc-@x1n>
In-Reply-To: <ZU0xCwvkKcpzBwc-@x1n>
From: David Matlack <dmatlack@google.com>
Date: Sat, 11 Nov 2023 08:23:57 -0800
Message-ID: <CALzav=dyURZ=BOWzsYA8ruSWd3vgPQqxztHURWEUYPvOK=w4Yw@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 11:20=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
> On Thu, Nov 09, 2023 at 09:58:49AM -0800, Sean Christopherson wrote:
> >
> > For both cases, KVM will need choke points on all accesses to guest mem=
ory.  Once
> > the choke points exist and we have signed up to maintain them, the extr=
a burden of
> > gracefully handling "missing" memory versus frozen memory should be rel=
atively
> > small, e.g. it'll mainly be the notify-and-wait uAPI.
> >
> > Don't get me wrong, I think Google's demand paging implementation shoul=
d die a slow,
> > horrible death.   But I don't think userfaultfd is the answer for guest=
_memfd.
>
> As I replied in the other thread, I see possibility implementing
> userfaultfd on gmemfd, especially after I know your plan now treating
> user/kernel the same way.
>
> But I don't know whether I could have missed something here and there, an=
d
> I'd like to read the problem first on above to understand the relationshi=
p
> between that "freeze guest mem" idea and the demand paging scheme.
>
> One thing I'd agree is we don't necessarily need to squash userfaultfd in=
to
> gmemfd support of demand paging.  If gmemfd will only be used in KVM
> context then indeed it at least won't make a major difference; but still
> good if the messaging framework can be leveraged, meanwhile userspace tha=
t
> already support userfaultfd can cooperate with gmemfd much easier.
>
> In general, a major part of userfaultfd is really a messaging interface f=
or
> faults to me.  A fault trap mechanism will be needed anyway for gmemfd,
> AFAIU. When that comes maybe we can have a clearer mind of what's next.

The idea to re-use userfaultfd as a notification mechanism is really
interesting.

I'm almost certain that guest page faults on missing pages can re-use
the KVM_CAP_EXIT_ON_MISSING UAPI that Anish is adding for UFFD [1]. So
that will be the same between VMA-based UserfaultFD and
KVM/guest_memfd-based demand paging.

And for the blocking notification in KVM, re-using the userfaultfd
file descriptor seems like a neat idea. We could have a KVM ioctl to
register the fd with KVM, and then KVM can notify when it needs to
block on a missing page. The uffd_msg struct can be extended to
support a new "gfn" type or "guest_memfd" type fault info. I'm not
quite sure how the wait-queuing will work, but I'm sure it's solvable.

With these 2 together, the UAPI for notifying userspace would be the
same for UserfaultFD and KVM.

As for whether to integrate the "missing" page support in guest_memfd
or KVM... I'm obviously partial to the latter because then Google can
also use it for HugeTLB.

But now that I think about it, isn't the KVM-based approach useful to
the broader community as well? For example, QEMU could use the
KVM-based demand paging for all KVM-generated accesses to guest
memory. This would provide 4K-granular demand paging for _most_ memory
accesses. Then for vhost and userspace accesses, QEMU can set up a
separate VMA mapping of guest memory and use UserfaultFD. The
userspace/vhost accesses would have to be done at the huge page size
granularity (if using HugeTLB). But most accesses should still come
from KVM, so this would be a real improvement over a pure UserfaultFD
approach.

And on the more practical side... If we integrate missing page support
directly into guest_memfd, I'm not sure how one part would even work.
Userspace would need a way to write to missing pages before marking
them present. So we'd need some sort of special flag to mmap() to
bypass the missing page interception? I'm sure it's solvable, but the
KVM-based does not have this problem.

[1] https://lore.kernel.org/kvm/20231109210325.3806151-1-amoorthy@google.co=
m/

