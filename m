Return-Path: <kvm+bounces-34494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C07F9FFC9E
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 18:10:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 605CC162163
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 17:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D1916F0E8;
	Thu,  2 Jan 2025 17:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncqyy12a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707ED125D6
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735837805; cv=none; b=SV2PSYwraelea9cDRHqRhno/slPYee3MIjk48lGRt1uxT1yda6Lc3pN6vG+HBk0slb5BlHhWp6Ih/LC/bXgicOoU7tSvPiXC+57CSraWWU9xeGEJaM5ursCu0Jhtv3hVwEc0pBe8T75pD+leGfa62RBz6rQDPMJPOBa81tQrBBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735837805; c=relaxed/simple;
	bh=eUySbjXh+hkGbBWcKfYQVuzd6v3jDGfVZvfxVADnnb8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EZynXBXiRwZg8W7n/8ZJBmKUkoUtLavoKidGBQxrptEPxPF8SREOyLlvGVxX+BUo75oYGfCuXBwbQRMK1pBy4c6dLFYF3vGl06cIt2aBDqMSnsfmFMVGU+m7WoZLwhBB+D9rde1uLNQ0TAJ/72eyKqb6tG4mqT7WcnHYvnHs/yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncqyy12a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C628C4CEDC
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735837804;
	bh=eUySbjXh+hkGbBWcKfYQVuzd6v3jDGfVZvfxVADnnb8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ncqyy12acnJ6mqFClguv1ZVjrnV/tFvo50aqcEkxNfxlvKrYrWY951HlkIm/KQOhy
	 mYgqohisqsX6iOpz//TvNRREIUoeF9ZUWT36rjh8iyZS7YK/XqhfyKgAyvvvr4nnhA
	 a32YLQbrPkCdfCtTPU6oxXPqirNciu5hlEUIbVuOFfUyl/pXhE1WTbsgOriGl6+uxf
	 98rF3sf588l0TgXh1z4c7itTzSBJg62USY/BIn+hkb5ri0nWoaRVoELMhJAh39kOBv
	 JDg3rBy2wGH9a23Nt+YMaOgGE+tHncynN8Yy4Uut7C5LnPJB2yZe7j6egXR14T805s
	 Urt9jbIUZ+whg==
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e4a6b978283so15429244276.0
        for <kvm@vger.kernel.org>; Thu, 02 Jan 2025 09:10:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWK/JfbAlS0ew/aXU33Z3cOcSdhsZmrxQMPxsAlRIDrnkCNNAHfmUFXKeuqFUv++6UZ6xg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCTio8AF8zDK+uTsHNKkM//FBeSVfD8DRvHPP7qX0tNwW7vlQB
	SK6XL65tI6x4QkBeOQM3CdUdVHBB4aTUk2K33xdR94hqg4Q1q/S/N3TV9y85bZLecgoxtMwVWn8
	YE/rRiKkaH4Gokjka+e1cI0dihw==
X-Google-Smtp-Source: AGHT+IF47D5lU6JkW1Kaa8QtNoZZq0x6Cc1vWAXPrrSTATaCt/BbwteBWH387WUpXwiEeCXVuc/Km5KP4xkWM9QEsWo=
X-Received: by 2002:a05:690c:c07:b0:6f0:697:da5f with SMTP id
 00721157ae682-6f3e2b6bb89mr327909417b3.14.1735837803147; Thu, 02 Jan 2025
 09:10:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241219083237.265419-1-zhao1.liu@intel.com> <44212226-3692-488b-8694-935bd5c3a333@redhat.com>
 <Z2t2DuMBYb2mioB0@intel.com> <20250102145708.0000354f@huawei.com>
In-Reply-To: <20250102145708.0000354f@huawei.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 2 Jan 2025 11:09:51 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKeA4dSwO40VgARVAiVM=w1PU8Go8GJYv4v8Wri64UFbw@mail.gmail.com>
Message-ID: <CAL_JsqKeA4dSwO40VgARVAiVM=w1PU8Go8GJYv4v8Wri64UFbw@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] i386: Support SMP Cache Topology
To: Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	=?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Richard Henderson <richard.henderson@linaro.org>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Sia Jee Heng <jeeheng.sia@starfivetech.com>, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 2, 2025 at 8:57=E2=80=AFAM Alireza Sanaee <alireza.sanaee@huawe=
i.com> wrote:
>
> On Wed, 25 Dec 2024 11:03:42 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
>
> > > > About smp-cache
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > The API design has been discussed heavily in [3].
> > > >
> > > > Now, smp-cache is implemented as a array integrated in -machine.
> > > > Though -machine currently can't support JSON format, this is the
> > > > one of the directions of future.
> > > >
> > > > An example is as follows:
> > > >
> > > > smp_cache=3Dsmp-cache.0.cache=3Dl1i,smp-cache.0.topology=3Dcore,smp=
-cache.1.cache=3Dl1d,smp-cache.1.topology=3Dcore,smp-cache.2.cache=3Dl2,smp=
-cache.2.topology=3Dmodule,smp-cache.3.cache=3Dl3,smp-cache.3.topology=3Ddi=
e
> > > >
> > > > "cache" specifies the cache that the properties will be applied
> > > > on. This field is the combination of cache level and cache type.
> > > > Now it supports "l1d" (L1 data cache), "l1i" (L1 instruction
> > > > cache), "l2" (L2 unified cache) and "l3" (L3 unified cache).
> > > >
> > > > "topology" field accepts CPU topology levels including "thread",
> > > > "core", "module", "cluster", "die", "socket", "book", "drawer"
> > > > and a special value "default".
> > >
> > > Looks good; just one thing, does "thread" make sense?  I think that
> > > it's almost by definition that threads within a core share all
> > > caches, but maybe I'm missing some hardware configurations.
> >
> > Hi Paolo, merry Christmas. Yes, AFAIK, there's no hardware has thread
> > level cache.
>
> Hi Zhao and Paolo,
>
> While the example looks OK to me, and makes sense. But would be curious
> to know more scenarios where I can legitimately see benefit there.
>
> I am wrestling with this point on ARM too. If I were to
> have device trees describing caches in a way that threads get their own
> private caches then this would not be possible to be
> described via device tree due to spec limitations (+CCed Rob) if I
> understood correctly.

You asked me for the opposite though, and I described how you can
share the cache. If you want a cache per thread, then you probably
want a node per thread.

Rob

