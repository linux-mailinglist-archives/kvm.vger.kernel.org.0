Return-Path: <kvm+bounces-55088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBF8BB2D23A
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 05:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C400D581086
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 03:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739E424418E;
	Wed, 20 Aug 2025 03:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TacO3eIF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2042C859;
	Wed, 20 Aug 2025 03:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755658999; cv=none; b=gRZatXw604icjp7HimW1KM9i8w4BgQRNlvFVJL+yVN9Chx/5frKEgOTbEjYr9/1x5eT4r1zY8+drTEoFyYjNfMh250CRx1EjNVBkcA4lAHV9/jPvLCtkgKe4WppjKtVpCL7QnG6Wutm3dzlmqRo/gUsp8vmQnNyPOU5wrekjApA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755658999; c=relaxed/simple;
	bh=dUb5J4XH+q4916VJxIDDUCe2v7YaXyLg5gTQb9sEMLQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ElTMVNibVW1ze910DZXWu9gvfIa3/kPr8B4Z7jVstOon0Z5xwsyDoSQy7zX4f9Bnw/bVn+PYEUNJSjMqpkr9IsEvxIUcyfahzSQ88iwGKidc5OivrdyoSQRHJGeTKZpSQg3rNLMJAgv6G+lPrHb1XiZ715qmSJBz1nEr4mgT170=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TacO3eIF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27067C4CEF1;
	Wed, 20 Aug 2025 03:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755658999;
	bh=dUb5J4XH+q4916VJxIDDUCe2v7YaXyLg5gTQb9sEMLQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TacO3eIFWhHfC9iieBE0ZVulubtG93C+xWiJ94hVccdRj9Od4S0EHBmnzP8cynW+q
	 JWawgVH9Q+GGZQZr1Y4eT11DaWFe5AJNn3JdPJ0ixY6avteUXXDFM4Kj7lrvwhJYu9
	 62C4m8xbI5lhv4I8VO2xDhOXGMwReZ+p6X2VTwvFjv77+Fyumm3lT+e/uSxHHTbsxe
	 fujBmYHh++k6QVhrel0J9R/DBAMA2+aCcRtVRBP/vNd5lCnfda9+NGX3Uq0+9uyXOn
	 7RaKwC7tqvTyPKRXTfKiKL6d8a8j0wBz2BqAjqrGFeq9DoYAgNm++KpczvtvYr8gAo
	 K95syn8Sx8xRQ==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-618b62dbb21so8581987a12.2;
        Tue, 19 Aug 2025 20:03:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVaSeJxkkhSK/OEA7MuwWBLYk6NFQcULlbEzqSOk8T4BjB3iQEPfyEvlKEwwJIW84g8YXM=@vger.kernel.org, AJvYcCX+M9+dAU0prhJ2xgt1sxRk4uYo7pwjHUxQbvLewiUKb0htHDh8DIRKaoqRdbnjVqp2S6X2IDJWeuMGYBoC@vger.kernel.org, AJvYcCXJAVz9Or3F3chgAcheb5vnb97wP3yGnArdLceigpUz2LbrB+Rfx4puU1zhgF0p2apTF9ToVinAv94eJPugIwxfdtT1@vger.kernel.org
X-Gm-Message-State: AOJu0YxFYslHDoTiXTpXfxmDxCo61EyyzS4MgnF9T2dKem9ZJHl8bxMI
	ECX5CQEMKS9SlII9xzGsObWkHN2BQk3WikjnBIoJfdiaodndy24G0Byk7QuZ6K2KO76+z1b+Q+X
	QHMQc1TbMdxkqV0iZBWz8NFUs8zT/eKU=
X-Google-Smtp-Source: AGHT+IGipsXdMkhLBiLLaqBjRzQlCXf5lG2voaM7ZlbwMucGPhtm3dMQcQrGXzIeWhNwxO91JT0saO4PJ+B8zwJNi0k=
X-Received: by 2002:a05:6402:208a:b0:615:b0e2:124b with SMTP id
 4fb4d7f45d1cf-61a9762bcb8mr1222075a12.24.1755658997791; Tue, 19 Aug 2025
 20:03:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250722094734.4920545b@gandalf.local.home> <2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
 <20250723214659.064b5d4a@gandalf.local.home> <15e46f69-f270-0520-1ad4-874448439d2b@loongson.cn>
 <CAAhV-H4TGus35B6ONdkSOMwWw+H6NRmHStV-Xu7vUYYrkDGfUQ@mail.gmail.com> <20250819202715.6f1cf0d6@gandalf.local.home>
In-Reply-To: <20250819202715.6f1cf0d6@gandalf.local.home>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 20 Aug 2025 11:03:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5y8Tckih4jd3C8Q-M6OZiw2szCYuxLQfBXehpWSvrstA@mail.gmail.com>
X-Gm-Features: Ac12FXz1padV2khVDKOyi3ekCMiGCzktzpAq5rTbzGUfDyfjZIQ6IiG85R2dpeE
Message-ID: <CAAhV-H5y8Tckih4jd3C8Q-M6OZiw2szCYuxLQfBXehpWSvrstA@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Move kvm_iocsr tracepoint out of generic code
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Bibo Mao <maobibo@loongson.cn>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Paolo Bonzini <pbonzini@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 8:27=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Thu, 24 Jul 2025 19:56:42 +0800
> Huacai Chen <chenhuacai@kernel.org> wrote:
>
> > On Thu, Jul 24, 2025 at 9:51=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> =
wrote:
> > >
> > >
> > >
> > > On 2025/7/24 =E4=B8=8A=E5=8D=889:46, Steven Rostedt wrote:
> > > > On Thu, 24 Jul 2025 09:39:40 +0800
> > > > Bibo Mao <maobibo@loongson.cn> wrote:
> > > >
> > > >>>    #define kvm_fpu_load_symbol      \
> > > >>>     {0, "unload"},          \
> > > >>>     {1, "load"}
> > > >>>
> > > >> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> > > >
> > > > Thanks,
> > > >
> > > > Should this go through the loongarch tree or should I take it?
> > > Huacai,
> > >
> > > What is your point about this?
> > I will take it, thanks.
> >
> > Huacai
>
> Did this fall through the cracks?
I don't know what this means, but I think you are pinging.

This patch appears after I sent the KVM PR for 6.17, and it isn't a
bugfix, so it will go to 6.18.

Huacai

>
> -- Steve

