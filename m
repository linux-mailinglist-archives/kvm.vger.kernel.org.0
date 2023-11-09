Return-Path: <kvm+bounces-1393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1057E7558
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22C7028131C
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 23:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1566538FBA;
	Thu,  9 Nov 2023 23:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dKpxV0Y2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A211D537
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 23:54:54 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE2444A4
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 15:54:53 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da3dd6a72a7so1812619276.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 15:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699574093; x=1700178893; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X4AzsPDPuaaKoRN4/f+ytz5TKai7RNDm9+3R88GkMKg=;
        b=dKpxV0Y28OjwsW6ncMqQG/B2c7YfRppgv7CIikDTvg8HhOWUdOwBFoLylnssRJNuhz
         LgHMRKXB2R7oKnRH2CLzuslZll3vzHYN1yZINdzJk3DHcG7+EC/JWKIRR4esv5TsstoH
         lIojt1AcBRRFExR/EFPLm8ecbAj12AFBG0iGXMaG3RSFCQgHmrlvy5/DU2rEyrQJjsnI
         q2evl5ldNxfOaC668Xu/DjjPlK0rgp2EWuEYnbTtVmq802oeVjFWKwedCKoxFGuSn7Co
         v31TXttt8BCBcBoU3nCvrCGwsBy5x/9LSXP9OUbk+o8iq41NKRITJ4Q51JFuIPtO+cEK
         MN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699574093; x=1700178893;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X4AzsPDPuaaKoRN4/f+ytz5TKai7RNDm9+3R88GkMKg=;
        b=SKpzfLV0dMoqy+pP8UqHvXuJ6CT3K7qzijJ8sdQS2/OGmvQAioAki6ZWeBge4kp0AZ
         toafwEDLcRjY7yk4e+s1iiNOMP/jrc6Ip1bQseKXfafQjMalK6FTukkmQknfPpxqaOMB
         wwphYCBArGjcgT6+ut6xLUT5/g3UU6Sit2EPWql+p+LQih1lxLbs+XJEg/jOYPl+wbds
         xRFUFqENn/w9QkUuhrXwWYGnYkuezpa9TwCG+j2pqxZNfIy99hesmBPGtfjIZ1kAFwfX
         xSaWeeELuK39aCgedggezwlRzmty80z+BYv6GyGRJEbdKQjKkXc4IgkTH2ugoeHzx92F
         NB9g==
X-Gm-Message-State: AOJu0Yzhk5604421ysLa1zlBFVthGCV5IjDSRF7hul0Q9Fsz4nfQniVA
	ipXhuXd7ei22ERnp1FBFwhNsiGrgph4=
X-Google-Smtp-Source: AGHT+IHCWX1lH7qnskX3mMkWilwA8HTAv4r5zrdS+u3hmw1OCBEUs/zOsH0QdoA+EfxsHsoW/KrnsZDxulQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:285:0:b0:dae:baac:5606 with SMTP id
 127-20020a250285000000b00daebaac5606mr167493ybc.6.1699574093131; Thu, 09 Nov
 2023 15:54:53 -0800 (PST)
Date: Thu, 9 Nov 2023 15:54:51 -0800
In-Reply-To: <CALzav=d0KK6ia0=BwUeogeXPXuiyru--i7-t-RTusCyPfy5ruA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com>
 <ZUlLLGLi1IyMyhm4@x1n> <fcef7c96-a1bb-4c1d-962b-1bdc2a3b4f19@redhat.com>
 <ZUq6LJ+YppFlf43f@x1n> <CALzav=d_ZyNGmh0086c8D+arjb6NPABEuOGL=aj3DzhKJ12Vmw@mail.gmail.com>
 <ZU0d2fq5zah5jxf1@google.com> <CALzav=d+3-R1jxmx_J_6etm43LGGQh1T2PF8wAqu-5sqM9Ms5Q@mail.gmail.com>
 <CALzav=d0KK6ia0=BwUeogeXPXuiyru--i7-t-RTusCyPfy5ruA@mail.gmail.com>
Message-ID: <ZU1xS4g1eytrrhbI@google.com>
Subject: Re: RFC: A KVM-specific alternative to UserfaultFD
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>, James Houghton <jthoughton@google.com>, 
	Oliver Upton <oupton@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 09, 2023, David Matlack wrote:
> On Thu, Nov 9, 2023 at 10:33=E2=80=AFAM David Matlack <dmatlack@google.co=
m> wrote:
> > On Thu, Nov 9, 2023 at 9:58=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > For both cases, KVM will need choke points on all accesses to guest m=
emory.  Once
> > > the choke points exist and we have signed up to maintain them, the ex=
tra burden of
> > > gracefully handling "missing" memory versus frozen memory should be r=
elatively
> > > small, e.g. it'll mainly be the notify-and-wait uAPI.
> >
> > To be honest, the choke points are a relatively small part of any
> > KVM-based demand paging scheme. We still need (a)-(e) from my original
> > email.
>=20
> Another small thing here: I think we can find clean choke point(s)
> that fit both freezing and demand paging (aka "missing" pages), but
> there is a difference to keep in mind. To freeze guest memory KVM only
> needs to return an error at the choke point(s). Whereas handling
> "missing" pages may require blocking, which adds constraints on where
> the choke point(s) can be placed.

Rats, I didn't think about not being able to block.  Luckily, that's *almos=
t* a
non-issue as user accesses already might_sleep().  At a glance, it's only x=
86's
shadow paging that uses kvm_vcpu_read_guest_atomic(), everything else eithe=
r can
sleep or uses a gfn_to_pfn_cache or kvm_host_map cache.  Aha!  And all of x=
86's
usage can fail gracefully (for some definitions of gracefully), i.e. will e=
ither
result in the access being retried after dropping mmu_lock or will cause KV=
M to
zap a SPTE instead of doing something more optimal.

