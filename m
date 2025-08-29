Return-Path: <kvm+bounces-56275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E21CB3B865
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 12:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63B761CC071B
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7C53081D6;
	Fri, 29 Aug 2025 10:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="duLn7bQf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A698F2FE07C;
	Fri, 29 Aug 2025 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756462465; cv=none; b=TaSrUOxQfpOrkzIaxTEqBarTInYlLnjB9/vFyrHIQlagLqMrxJ6BbtQJzB+GExLgLQrsbIS8mIMn/J3VDmEj1LI/QyrE4/fL6clFIgm0m4ZbC+2gHhmcvudRGPo3AjX+d7/yJxOO9x+yatw5Xu/J/AJH7i27sFYy6HTvI2VvAYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756462465; c=relaxed/simple;
	bh=9L3UHPz9ESL5lTTjYU5THDZcxPiy1pUN193HAGe45pY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tS/M/OX999eLzaamNAJQyYPrkDUhPgcCMR8tqg/SjUWg5w5f5VuLb6H/k3aBGlwwBtvoHt2OUjC4qMvsxcLIXCN7dikGYOJZYAQHFzM4IzQnZ8E2hDpIzGqPbjCmtiRJ0PGf0yclVhWWN5oXKS/oBtnQVF3NgDtZkP69+kEwQf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=duLn7bQf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD2DC4AF09;
	Fri, 29 Aug 2025 10:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756462465;
	bh=9L3UHPz9ESL5lTTjYU5THDZcxPiy1pUN193HAGe45pY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=duLn7bQfCAeJxmOYL9crnf/8VLSTLWyA9lgWIf6+a6A0ZJb1EcsGJXokKb+u6pF+/
	 4X2Mjou2bJUmSZyg9GMUH+f9QMWRiYY2FeJ3o2ER0x3vol0N6X5aqqz6S6E7twH8tm
	 TL7Jd68WJgY0rktX3mHnFLvoOCHEzK5j6qmLIF9+zR0wSDpr2R3bc4gHG9W5m2qvgq
	 xpaYiW1RCC7BomXlSecCLddpBmPDbaDQLNbfdnz/ln3KBKcRNHaAfmbl0AO+KeMWne
	 21kmxMZs1SmBLGGH2ehNe4BNfoFfgYccXogdLPI3mUHeNheik4uGard4lurz47IKQs
	 HJ1P0hzLmyzng==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb73394b4so276838666b.0;
        Fri, 29 Aug 2025 03:14:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVCAFGpo9L0yxU2N8Ws+YWKoJM+9dFn+orJ29ACVIxUlEu88GbZJOrNGoQN2VrVLmhltcc=@vger.kernel.org, AJvYcCVh2abT9fhNOdU+zKbRpCrN/fSBrvrETZgHn8EL7clVI+iLfryfmsYW2J/YEn4KER3yXKSXFUoTnCU7kI7x@vger.kernel.org, AJvYcCXiBpeVfGME8AwPZJW0AFnEer52TPySODRsnA8j6UJmbo38T9FsfLS3kImHH6AijGzWYXvzXL057/dPuQsZceeRPf5+@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy/MjLn3DvAX0T32FhmEOY0H18QYDkthLsbNuuyDHPQebGJgvi
	4gVJbbrrV31bON5GLoYZUbnzK5UxkRTU+plJLs5cqvCFrLSbmlhse448C7yC+YOCZnpQYypQLyq
	FuUbnTRX3W3usR8s26fLckxp1WNGsOb0=
X-Google-Smtp-Source: AGHT+IE4tDkznKpRE8bSaSs0yvZCPjG4VihnSdRWbw7APVe0xt0cRwrHk2+TIHtgcWifb+Cw6uflU7OkVP6VYiZRiUA=
X-Received: by 2002:a17:907:2d07:b0:af9:4075:4ea5 with SMTP id
 a640c23a62f3a-afe28f5ba80mr2684224366b.25.1756462463946; Fri, 29 Aug 2025
 03:14:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250722094734.4920545b@gandalf.local.home> <2c2f5036-c3ae-3904-e940-8a8b71a65957@loongson.cn>
 <20250723214659.064b5d4a@gandalf.local.home> <15e46f69-f270-0520-1ad4-874448439d2b@loongson.cn>
 <CAAhV-H4TGus35B6ONdkSOMwWw+H6NRmHStV-Xu7vUYYrkDGfUQ@mail.gmail.com>
 <20250819202715.6f1cf0d6@gandalf.local.home> <CAAhV-H5y8Tckih4jd3C8Q-M6OZiw2szCYuxLQfBXehpWSvrstA@mail.gmail.com>
 <20250820093515.17afe135@gandalf.local.home>
In-Reply-To: <20250820093515.17afe135@gandalf.local.home>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 29 Aug 2025 18:14:03 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7KYEU-N42w8O-4BdPmDWtFOVYGmHrzyNvvnPePFg2xbw@mail.gmail.com>
X-Gm-Features: Ac12FXzjrQI3Qe5fl8laVmIxK8ULXzANsts5eixF_GnZp1r-c29iVtabs82QG2s
Message-ID: <CAAhV-H7KYEU-N42w8O-4BdPmDWtFOVYGmHrzyNvvnPePFg2xbw@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: Move kvm_iocsr tracepoint out of generic code
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Bibo Mao <maobibo@loongson.cn>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Paolo Bonzini <pbonzini@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 9:35=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Wed, 20 Aug 2025 11:03:05 +0800
> Huacai Chen <chenhuacai@kernel.org> wrote:
>
> > > Did this fall through the cracks?
> > I don't know what this means, but I think you are pinging.
>
> Sorry for the colloquialism, it's not actually the same as a ping. A ping
> is for something that had no response. This is more about the patch was
> acknowledged but did not go further. "Falling through the cracks" is like
> picking a bunch of things up with a bucket that has a crack in it. Some o=
f
> those things may "fall through the crack" and not be processed.
> >
> > This patch appears after I sent the KVM PR for 6.17, and it isn't a
> > bugfix, so it will go to 6.18.
>
> Well, it will start causing warnings soon because it wastes memory. But
> that will likely begin in 6.18 so we are OK, as long as it gets into
> linux-next before the warning trigger does.
Applied, thanks.

Huacai

>
> -- Steve
>

