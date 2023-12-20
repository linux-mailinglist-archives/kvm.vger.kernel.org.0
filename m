Return-Path: <kvm+bounces-4892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 443B781966D
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6607B25110
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 01:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38D98BFB;
	Wed, 20 Dec 2023 01:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kQgBQyxg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70C279DD
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e5bf8a6f06so3587157b3.1
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 17:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703036223; x=1703641023; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZMpPDRTJH35hvvkbLxFhPjnJilPUQ+sVkxQSPUGNzAE=;
        b=kQgBQyxgba8i8B/eAJOCbjHJg3PgNNBak2NzTlQbQWhqJ3NGY85w6cSEUMZhQIbDxa
         +k3gPddy7z7CH8tW7jqmMuzp8MUpyU/E0XM+piP5lEbQ31u1YUzTJCjK9AGQBg/XM0su
         G0YlvI2/Fgye2NorxkjaV+g2fNbzyLwjtf35Dm0a00E1j6zWiz/dWziS8OXGIa7RwsJo
         i6tBfQZn+wFgbF0RAYganCZQ6i6SC0bviqykXy3ePGCR4/G4whezZWenwMPvLzD1X8PC
         znrPg4inlALehBD+cyx3fNRLWU7GSHmd2pI2iWnsTenltreUBKwsV56QF8BIvE068Tpr
         /wXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703036223; x=1703641023;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZMpPDRTJH35hvvkbLxFhPjnJilPUQ+sVkxQSPUGNzAE=;
        b=fNy0C/YnHHt6Cje9ps8NLJTZu1JAdDRRc3Miv0i3Nbi1NUhngEOXNJpl1kBVVFIwpu
         kDjnRdouLy304XIzP2GJrdOZ77RpHYGWSTQdhgARB0/hF4gIcbKXxuaqJ40kWPX4W/4C
         +wLif0aE5mtqIdrS7LvGeNPXcI7M8KQIEhwIh0HXqoZnVl1VSeO5QtmxF9cKv0MYRfps
         6F3x0YMyEAtQ5D1gME569QZ75FjSUtQeZjdgxGuP+riq7vY0bsdr1sGx0v6vli/XNL2N
         C1mrdSke3X0FXZdLlIGRj95IK+M0veFg5G08h50aFiqVcZccjQzZY5EXXVsQEMaBhNnF
         n2kw==
X-Gm-Message-State: AOJu0YwOvtM3jYIBKCBQlIiRb8EEmiH0Qk47PdOFA75TIZA4dojDYNk4
	3OlmPDgMEO95SxlCJasDPrP1T59+xW2GTqQLYw==
X-Google-Smtp-Source: AGHT+IHkW3C5TUe1j64s0L+R/fMZTOwVtCHzR1lHKvZLh86Uotwca9XCKzPvHhUBb8usj/+FHyFqnAW4Z34=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2913:b0:5e5:d445:d9a9 with SMTP id
 eg19-20020a05690c291300b005e5d445d9a9mr688492ywb.3.1703036223803; Tue, 19 Dec
 2023 17:37:03 -0800 (PST)
Date: Tue, 19 Dec 2023 17:37:02 -0800
In-Reply-To: <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
 <ZUEPn_nIoE-gLspp@google.com> <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
Message-ID: <ZYJFPoFYkp4xajRO@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023, David Stevens wrote:
> On Tue, Oct 31, 2023 at 11:30=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Tue, Oct 31, 2023, David Stevens wrote:
> > > Sean, have you been waiting for a new patch series with responses to
> > > Maxim's comments? I'm not really familiar with kernel contribution
> > > etiquette, but I was hoping to get your feedback before spending the
> > > time to put together another patch series.
> >
> > No, I'm working my way back toward it.  The guest_memfd series took pre=
cedence
> > over everything that I wasn't confident would land in 6.7, i.e. larger =
series
> > effectively got put on the back burner.  Sorry :-(
>=20
> Is this series something that may be able to make it into 6.8 or 6.9?

6.8 isn't realistic.  Between LPC, vacation, and non-upstream stuff, I've d=
one
frustratingly little code review since early November.  Sorry :-(

I haven't paged this series back into memory, so take this with a grain of =
salt,
but IIRC there was nothing that would block this from landing in 6.9.  Timi=
ng will
likely be tight though, especially for getting testing on all architectures=
.

