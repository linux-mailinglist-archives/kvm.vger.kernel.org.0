Return-Path: <kvm+bounces-3949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC5D80AC9C
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:04:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB7542815D7
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F036481CD;
	Fri,  8 Dec 2023 19:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EwQqM8Db"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B26111F
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 11:03:59 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5cf4696e202so30849857b3.2
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 11:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702062238; x=1702667038; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pnnp0/fnEWWka5ENVyb9xgW39qrerb88jdwgH/GIHYw=;
        b=EwQqM8DbLJ59QoDGqLny6VazAxVntKD7p3nQjTvzfDsqvJr+4nrr7hCgePfQESJOyU
         NEBiKBlSQqdrhOzoE9XLYGcF354u0k4JIjmTlQeRibVKHG1rshU83o5xvv8RCtsPc4Kg
         JNRqpEjOJ1LuBqSSEc22MJegBL/F72B8f0KvmwOr4/9EwV5hZFwafqo0+Lsmzxj/LQ62
         ZTBGjJ7d2zYIp8M03Kl5VEFsMnmwl//GILZc84526k77Z/fnRfUwQfx4XbccIioZApsK
         TVGqtSbDy3Rj7i2yFo/HpEC1auki1Dzlor/6KbqdAXDTkLqhnNWo8ZQxtbqbhopde3WQ
         7XPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702062238; x=1702667038;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pnnp0/fnEWWka5ENVyb9xgW39qrerb88jdwgH/GIHYw=;
        b=Bbcdd+BKIQloWsL+kOWqwpKH7UrSTnh8bSgW7uA3sPNSvgnBxX9EyYD1WzbcJuodpl
         OfHCme55ffLI1ySfBXxnjZv4lro+S7vhabpOSPT1yc81uzmvQ5tDhxmOraar1oWwkaxJ
         WPTQ7UGgLBV7FdeNlAoXJ1o6OaP1RqmUuXQJUwuGaCODR50wiNKdRy5mhhBKpZbuVwDk
         n5uyxcgKLSk5YxgpVm/H+1KzDSMs9vHaeuj269SmCqUfWlw9jB9+jxfVlM0I5InD2X+I
         z15n6cTyeePSk8tAirJdGP/dOJgS8tbOTBKi1JACbmGRkX6dUWxOAoJ23oHGkCdHBKt7
         WmVw==
X-Gm-Message-State: AOJu0YxbEh5tGus+5+p8nF1+UNhw4VXFiwSuElRGlJDxlaYg1d4imdAU
	DwxvUoKI9f2FNIXvTX0WJgY9TJDdYaw=
X-Google-Smtp-Source: AGHT+IHoX/JR8CN++E5+tp3yzgkmAnPoCjWxHmdzOWRgqCcQC6P5gd4eVJxrokGbbxFq15a3TKUUpHzqCkY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab09:0:b0:db7:dcb9:790c with SMTP id
 u9-20020a25ab09000000b00db7dcb9790cmr3789ybi.8.1702062236159; Fri, 08 Dec
 2023 11:03:56 -0800 (PST)
Date: Fri, 8 Dec 2023 11:03:54 -0800
In-Reply-To: <CABgObfbgs0z0Pe37T=TJprEkq0dZngSxKKKVnM74xHg6eFGegg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208021708.1707327-1-seanjc@google.com> <CABgObfbgs0z0Pe37T=TJprEkq0dZngSxKKKVnM74xHg6eFGegg@mail.gmail.com>
Message-ID: <ZXNomuGtEOuG9hr1@google.com>
Subject: Re: [GIT PULL] KVM: selftests: Fixes and cleanups for 6.7-rcN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 08, 2023, Paolo Bonzini wrote:
> On Fri, Dec 8, 2023 at 3:17=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Please pull selftests fixes/cleanups for 6.7.  The big change is adding
> > __printf() annotation to the guest printf/assert helpers, which is waaa=
y
> > better than me playing whack-a-mole when tests fail (I'm still laughing
> > at myself for not realizing what that annotation does).
> >
> > The following changes since commit e9e60c82fe391d04db55a91c733df4a017c2=
8b2f:
> >
> >   selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11=
:58:25 -0500)
>=20
> This would be a 6.8 change though.

/facepalm

Sorry.  Having to switch to kvm/next to get a sane pull request should have=
 been
a big clue bat for me.

