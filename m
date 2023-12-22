Return-Path: <kvm+bounces-5188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFD681D071
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 00:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 278E3B22E2D
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 23:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1763C33CFE;
	Fri, 22 Dec 2023 23:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EcQQO7Yu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB80033CEA
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 23:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703287525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkEZ1y+Od8QjwKk+xy23eJw9jvF0tR+So/hQMtnbcFI=;
	b=EcQQO7Yum9cQYrRQ7QkJGjqxY3bSIp6C5Jq1Iq5jhkrV+lWyL/wiuzUTSszrAHJB/SJYsH
	THaia+0sEgRXy14PC17sZP2N+cnYDdyV3LynbJVrKtvyTrSibsRsemorZMlixRBk8b1w0u
	Y/xUEOOYQkulz24V+cwLVkVtaTiayLI=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-DLKZqCBnOTSKbuIYFBlmOA-1; Fri, 22 Dec 2023 18:25:22 -0500
X-MC-Unique: DLKZqCBnOTSKbuIYFBlmOA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5e7b49e15c1so34492177b3.1
        for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 15:25:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703287521; x=1703892321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GkEZ1y+Od8QjwKk+xy23eJw9jvF0tR+So/hQMtnbcFI=;
        b=qflO3HRBR6/kvNuKz8aJa6gDtE3MTyXvfnbu5H0BdsHBnKSo86mADR04Q9deS3vU5c
         983cInrKfLF50CwlR+M+c9JejcE4VPq6Cb193MmJfYEotjd6VXIzfD9A7kERdm29e/mS
         XZUipgtIDj2gYaTGoj7g/4s4wG36CR78qlB1j2tZalHCqd7FmAUYa9HVt+4j0Gh8sf+W
         8L+AhCYkm9qTSfdhUkap4/osiZeYK73KlBGeigg5p5HHSyA09L7NUQc28zCl856RZnz/
         Kadt+FXKfRQ4ns6+/rqN99MuXnCC8VVyjfxap6iQ0G5qjNFDJDNDPcZw2wel8O1WLWAS
         YgBw==
X-Gm-Message-State: AOJu0YwIxb8Cny0neTIy79sZlxvxHmKugk4FlZzqIlVy/k5LQY5IoZae
	W9MG86pGiCfYVylfGViTACvqv6ZBhrn12TNv0XDbXVDvw1t0W0Fieyo0a3WOx8zabt2oTdAb4yw
	eoPNj64kG01oWzT2m9YhBo7oOLISxmS+wxenc
X-Received: by 2002:a0d:e60f:0:b0:5e7:731f:cbfd with SMTP id p15-20020a0de60f000000b005e7731fcbfdmr2122781ywe.42.1703287521611;
        Fri, 22 Dec 2023 15:25:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4peG8QFXogPSz9Z8FJhgPYUNNmD67LzVd8kdHknyb1FXrx+tdQwRh4FX14vGlvBNWcvhcSs3HKYyigzXvvr8=
X-Received: by 2002:a0d:e60f:0:b0:5e7:731f:cbfd with SMTP id
 p15-20020a0de60f000000b005e7731fcbfdmr2122772ywe.42.1703287521372; Fri, 22
 Dec 2023 15:25:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZYCaxOtefkuvBc3Z@thinky-boi> <784ab26d-8919-4f08-8440-f66432458492@sirena.org.uk>
 <69259c81441a57ceebcffb0e16895db1@kernel.org> <ffbca4ce-7386-469b-952c-f33e2ba42a51@sirena.org.uk>
 <441ff2c753fbfd69a60e93031070b09e@kernel.org> <cc920d55-39df-4255-b194-a2db1dec6bb7@sirena.org.uk>
In-Reply-To: <cc920d55-39df-4255-b194-a2db1dec6bb7@sirena.org.uk>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 23 Dec 2023 00:25:09 +0100
Message-ID: <CABgObfatzu=tV5UfXOnxZ12GgM=013+-teEj_-5NCLTr6Y82Mg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, part #2
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 22, 2023 at 3:21=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
> > > I see it's not, I'm asking if it should be - given the latencies
> > > involved it seems like it'd be helpful for keeping -next working.
>
> > This is on purpose. We use -next for, well, the next release,
> > and not as a band-aid for some other purpose. If you think things
>
> Note that -next includes pending-fixes which is specifically for the
> purpose of getting coverage for fixes intended to go to mainline (indeed
> this issue was found and reported before the original problematic patch
> was sent to mainline, it's not clear to me what went wrong there).

Indeed most other KVM architectures have a tree included in
linux-next's pending-fixes and kvm/master is included in there.

Knowing that KVM/ARM does not have a fixes tree included in linux-next
might make me get those in kvm/master a bit faster, but then I'd let
them stay in kvm/master, for a day or two of soaking in linux-next.
It's never happened to me to send broken or conflicting pull requests
after -rc1, as far as I remember, and it's indeed unlikely, but
linux-next does provide a little bit of peace of mind.

> He is on CC here.  I'm not sure that it's specifically things not
> getting merged (well, modulo this one fixing an issue in mainline) -

I'm indeed not exactly a speed demon, but in this case I specifically
wanted to make sure to include everything posted before Christmas, as
this was likely going to be the last PR in the release.

I also wouldn't have minded a review or tested-by for
https://www.spinics.net/lists/kvm/msg335755.html :) but in the end I
included it in the pull request anyway.

Paolo


