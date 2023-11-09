Return-Path: <kvm+bounces-1364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 309ED7E7192
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 19:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50E931C20C16
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 18:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B77D37154;
	Thu,  9 Nov 2023 18:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O4OzxmiN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B9D36B0B
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:34:31 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B903C0B
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 10:34:31 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-32ddfb38c02so665420f8f.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 10:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699554869; x=1700159669; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7JLe+M/LGu+aNrdpgA3JXv/nhr/9WCvW0J6kWmOqMw=;
        b=O4OzxmiN7rlIBmslqxq4OiAH4+A2jkcym8SFSWJPkIWaqxSZdV2T9aJgA2SEOyIN6j
         hfOQ1UKh4Vm28ZnlNFNT/8/HG3Soz1XrDph1k+ovLh06j7zdQ4cIIYW3VdOHuDROQiCs
         LqEy+eLNnv3or9P1wflvmCMAzXwZ6GVMkvq9C/UZDH/7ptIZIMWe1gwSMK+IuGlpYGGw
         XCNSI/Cv8fZtJmU8XiDDeVdXQ0lX/y+VL3S6W5bO1ittAhJO/RsvGUmyTE/3E8FeKFq2
         7DqlZlWajweaqcMMtQdJkMjRuf+euQ7MOvG4tmZc0OL5U0LrQGSCKf7/sQpM0IBtcj2g
         KY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699554869; x=1700159669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7JLe+M/LGu+aNrdpgA3JXv/nhr/9WCvW0J6kWmOqMw=;
        b=fSD1ajRSwwuZsO1nA62SDbD/yZjDAvIywXNi8qCurTLfeK2odU8aCF+vPEtyoPYIwk
         +TlszLI4ur9CRWyOH0ymtG3Fh9tWV+4fhkKKB9U+5V8SRARzIW8DC9X9KmlOQBMWrIbJ
         L68bB0Hp2DIR6dSHnXilzLQnpg6FvOYcoio02x/mpXiBf956ct9V53lNJg85bEQunsdx
         VcIyPq+Y26NU367Tqcr1+ai2cjAuOl1inwttWsRtsx8OQV1DkXtvJogXEhIYJgL5At/v
         Huz/1arZyPvnmk8+sfyOS8yzPdu+u/1TA392ruAqoUyfmJ2IRMkY5+6ckfiacPGsh9/c
         L+BA==
X-Gm-Message-State: AOJu0YzioBubt+oUdS5ZATItD4r9+CnOn64K/0HNbWIuMXlq9o1rc8/c
	yyw9O1/qyDhzn7OSTi606K6/i4d+RS2pi6xSi3koOw==
X-Google-Smtp-Source: AGHT+IFone9d3+Uurpk3HoNbcJcDLAyFh2Zbcy+h6BaG/RMpGZpyRm4l8zszelhhSh/n930cck1LshPnyEaeofH8EPA=
X-Received: by 2002:a05:6000:1568:b0:32d:9a88:e36 with SMTP id
 8-20020a056000156800b0032d9a880e36mr5003808wrz.2.1699554869267; Thu, 09 Nov
 2023 10:34:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <ZUq6LJ+YppFlf43f@x1n> <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
 <ZU0d2fq5zah5jxf1@google.com>
In-Reply-To: <ZU0d2fq5zah5jxf1@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 9 Nov 2023 10:33:59 -0800
Message-ID: <CALzav=d+3-R1jxmx_J_6etm43LGGQh1T2PF8wAqu-5sqM9Ms5Q@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 9:58=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
> On Thu, Nov 09, 2023, David Matlack wrote:
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
> mmap()+userfaultfd is the answer for userspace and vhost, but it is most =
defintiely
> not the answer for guest_memfd within KVM.  The main selling point of gue=
st_memfd
> is that it doesn't require mapping the memory into userspace, i.e. userfa=
ultfd
> can't be the answer for KVM accesses unless we bastardize the entire conc=
ept of
> guest_memfd.
>
> And as I've proposed internally, the other thing related to live migratio=
n that I
> think KVM should support is the ability to performantly and non-destructi=
vely freeze
> guest memory, e.g. to allowing blocking KVM accesses to guest memory duri=
ng blackout
> without requiring userspace to destroy memslots to harden against memory =
corruption
> due to KVM writing guest memory after userspace has taken the final snaps=
hot of the
> dirty bitmap.
>
> For both cases, KVM will need choke points on all accesses to guest memor=
y.  Once
> the choke points exist and we have signed up to maintain them, the extra =
burden of
> gracefully handling "missing" memory versus frozen memory should be relat=
ively
> small, e.g. it'll mainly be the notify-and-wait uAPI.

To be honest, the choke points are a relatively small part of any
KVM-based demand paging scheme. We still need (a)-(e) from my original
email.

>
> Don't get me wrong, I think Google's demand paging implementation should =
die a slow,
> horrible death.   But I don't think userfaultfd is the answer for guest_m=
emfd.

I'm a bit confused. Yes, Google's implementation is not good, I said
the same in my original email. But if userfaultfd is not the answer
for guest_memfd, are you saying the KVM _does_ need a KVM-based demand
paging UAPI like I proposed?

