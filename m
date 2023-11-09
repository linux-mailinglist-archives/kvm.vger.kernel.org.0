Return-Path: <kvm+bounces-1385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D9617E747E
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 23:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF6CC1F20CC8
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 22:44:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D583032E;
	Thu,  9 Nov 2023 22:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vz1sHPcR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3665D307
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 22:44:47 +0000 (UTC)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7714206
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 14:44:47 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-32fadd4ad09so912529f8f.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 14:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699569885; x=1700174685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEHk7Szdsc46fYaY/zOqEjHTCfMq3/MMsT0vQVQOtlY=;
        b=vz1sHPcRPm0IKPinbkse2f5BwvCrUzyPaGVIsRcH7x1Jc/sDZOA8s4hNVyHQsM2XSR
         h4QXbqtfVIBBn5korYm20QiC2AECPmvpQzVlqeY4ALK/ejXMs2mNH2jAmfqpM8/asOpx
         O0xhTqQvfAP+BEwvSDzWKo9Vz/uTAdXbFexUH1Irgcs4M+EoAHwcxExAfBRI+O4wW7zr
         4OBvlO+dIf+fJkE933k46lT1bel1+LI2K1+KswtBl0biMq0JRGGlFiRfsPuT8be8/zTj
         b/lBlQABhLrART+D1PZyVSQittqs9sFOTgnRF05XJoy+SxvIuSce40OkZO6ynWIpCqr7
         dyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699569885; x=1700174685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oEHk7Szdsc46fYaY/zOqEjHTCfMq3/MMsT0vQVQOtlY=;
        b=ZHoMEeFAo7mW1tMbPfAz0u0BlcOrcNcjwWAtVM+nMDWjwVjTPm1n7Te2qukZWKLJpE
         5CubszNGR2cl/v43wQmUgHvSsmhjbGEv/DZDfJDXkK1PjazBl3bvzPMnmh1L489RPcCx
         19R1GjtDOJgTr69t/6l3/iDt1uiQKxN0kmF0054EkdcAKMQ2u6f2K7HWO0locLNa2eda
         p/fsTfSHI3sly/hsNXQAbeVREbQNj9DYOPac0iBiv60UDWyLefY/mKQw0b0PoQf6PfgP
         52NXJnqS/3QAceqCbQdaZM6DznpL7rL+AANZ462g+LE/g+cEVOVkliSBgmaY5J7kVQHi
         SCGw==
X-Gm-Message-State: AOJu0Yz75KQrLdIdFozO37pQMWgCvg6NeCLdA2aXapKrj4jCjgt00tF1
	NQKXwjXVBkxACSECi9AV/4qXE0AMHC5oHZiWTcuOUg==
X-Google-Smtp-Source: AGHT+IHihzgotT8DWstn6jBTf86N0w2EZ704+c2t/i0cb2P2uSYWr6BV5Gys7wu1M6lYRnb2l0ViaAYxUc3Xabe/EFc=
X-Received: by 2002:a05:6000:1863:b0:331:3469:d58c with SMTP id
 d3-20020a056000186300b003313469d58cmr2509193wri.33.1699569885482; Thu, 09 Nov
 2023 14:44:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <ZUq6LJ+YppFlf43f@x1n> <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
 <ZU0d2fq5zah5jxf1@google.com> <CALzav=d+3-R1jxmx_J_6etm43LGGQh1T2PF8wAqu-5sqM9Ms5Q@mail.gmail.com>
In-Reply-To: <CALzav=d+3-R1jxmx_J_6etm43LGGQh1T2PF8wAqu-5sqM9Ms5Q@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 9 Nov 2023 14:44:16 -0800
Message-ID: <CALzav=d0KK6ia0=BwUeogeXPXuiyru--i7-t-RTusCyPfy5ruA@mail.gmail.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 9, 2023 at 10:33=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
> On Thu, Nov 9, 2023 at 9:58=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> > For both cases, KVM will need choke points on all accesses to guest mem=
ory.  Once
> > the choke points exist and we have signed up to maintain them, the extr=
a burden of
> > gracefully handling "missing" memory versus frozen memory should be rel=
atively
> > small, e.g. it'll mainly be the notify-and-wait uAPI.
>
> To be honest, the choke points are a relatively small part of any
> KVM-based demand paging scheme. We still need (a)-(e) from my original
> email.

Another small thing here: I think we can find clean choke point(s)
that fit both freezing and demand paging (aka "missing" pages), but
there is a difference to keep in mind. To freeze guest memory KVM only
needs to return an error at the choke point(s). Whereas handling
"missing" pages may require blocking, which adds constraints on where
the choke point(s) can be placed.

