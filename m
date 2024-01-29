Return-Path: <kvm+bounces-7391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 056B18413AB
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 20:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 999A91F25945
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB1E76028;
	Mon, 29 Jan 2024 19:41:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63404C631;
	Mon, 29 Jan 2024 19:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706557278; cv=none; b=LYDIMnRnR0bR7IzjaShxrBixdOo8aH9LCChrUMhbzSdtKOdwWFuSsc6QnQTjTaUhw9JLKkPj3G+/IN98zdzwowE5TlaLfKFlye3Tnt2khy7D9NENbWCkGqypo7gHsVpbb9SyD/la5zkBSCTHLySklmY2FYujKuL57N6hrwx+P7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706557278; c=relaxed/simple;
	bh=02F4BmZGj5ppAsaFduYbojUZDMrl9eFlfaZtrQDR+us=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c2e1un2RNeTmu6F4KzkTRAXC+4KNA/J4+fkuQIj34TT+G2iNernVCABO5pilFJHYOShRuIV8Md42TI8LgR6mvRV3LZpVHEleDhIOZPLeYVwKk5ml2E6DzfcJe88OXwr1/I/i2yJ2LL4HDKcROB1nfr6eR1/2UPaQ1EsQgPBG3B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-59a47232667so73356eaf.0;
        Mon, 29 Jan 2024 11:41:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706557275; x=1707162075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afWM7NmgRGkXWPi4gbCyXTYv1beLUmTY618Sp+1Xbuw=;
        b=Bv2Kgk24bRjbug1FdmOM13DFVeEOF46L4JdutM0Wb88gIjaffuRSXDJbyY7MtpiFWQ
         bFNY2+/069ODZH/6x+gqXyfQa7ViG/rrVfzvp626SCbyXf9ktWCdhjNy9rVR2qESVggb
         LyShHA1PuXtdrygTQjUUzMzDCVYj4dGWhZPhJAeqGdnKINztbUz/IOZZ63LwKOGM7P6X
         dhO/iO2ErMkXTiN3Rzu3Q38o+guMkJcsuBepT0TePA8cCP0uBnE6tAj50zCFibPsHcm8
         fXOklsZmwKaKMgxfo5eyh4w2E7nZHCe/RJ3sHivFfecbAwcYhFnHek9s4d1spaTJSN/2
         VhEA==
X-Gm-Message-State: AOJu0YyDDh8oOx89sGNFm2oDAW6ksi9p8O51bGL3CwuX3z1rHwYwT0Le
	p0p2WLGVelljxqyA+AjkV0tSnYdURqwTKVJx2I8sbS4WiOj4HPPQsymBIPcwfCtUEsr8QCkSXGH
	X7XRZ/WO+5IrxaRZSr+ovOJQu92I=
X-Google-Smtp-Source: AGHT+IGlMBGdcniPaeYg1f7crzPdxWPZwO5IgEoMWWaEW5YjxGfUAVODH3bgW6LUqvz/veF3Nr3Y53c1/jrwDBwtmT4=
X-Received: by 2002:a05:6820:228f:b0:599:9e03:68da with SMTP id
 ck15-20020a056820228f00b005999e0368damr9122724oob.0.1706557275609; Mon, 29
 Jan 2024 11:41:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
 <1706524834-11275-8-git-send-email-mihai.carabas@oracle.com>
 <CAJZ5v0gPoLan0M2A-x5V=ZNCxbYdv5e5DvNZTyo6Bd3e9HThYQ@mail.gmail.com> <ceab7277-b95e-477c-9729-d46dc5be54c8@oracle.com>
In-Reply-To: <ceab7277-b95e-477c-9729-d46dc5be54c8@oracle.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 29 Jan 2024 20:41:04 +0100
Message-ID: <CAJZ5v0h_fJuJU+a6z7V8MDy=RJP4bwL=jKaEPFyV6PT5CK77QA@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] cpuidle/poll_state: replace cpu_relax with smp_cond_load_relaxed
To: Mihai Carabas <mihai.carabas@oracle.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
	daniel.lezcano@linaro.org, akpm@linux-foundation.org, pmladek@suse.com, 
	peterz@infradead.org, dianders@chromium.org, npiggin@gmail.com, 
	rick.p.edgecombe@intel.com, joao.m.martins@oracle.com, 
	juerg.haefliger@canonical.com, mic@digikod.net, arnd@arndb.de, 
	ankur.a.arora@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29, 2024 at 8:21=E2=80=AFPM Mihai Carabas <mihai.carabas@oracle=
.com> wrote:
>
> La 29.01.2024 16:52, Rafael J. Wysocki a scris:
> > On Mon, Jan 29, 2024 at 12:56=E2=80=AFPM Mihai Carabas <mihai.carabas@o=
racle.com> wrote:
> >> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
> >> smp_cond_load_relaxed which basically does a "wfe".
> >>
> >> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> >> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> >> ---
> >>   drivers/cpuidle/poll_state.c | 14 +++++++++-----
> >>   1 file changed, 9 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state=
.c
> >> index 9b6d90a72601..440cd713e39a 100644
> >> --- a/drivers/cpuidle/poll_state.c
> >> +++ b/drivers/cpuidle/poll_state.c
> >> @@ -26,12 +26,16 @@ static int __cpuidle poll_idle(struct cpuidle_devi=
ce *dev,
> >>
> >>                  limit =3D cpuidle_poll_time(drv, dev);
> >>
> >> -               while (!need_resched()) {
> >> -                       cpu_relax();
> >> -                       if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> >> -                               continue;
> >> -
> >> +               for (;;) {
> >>                          loop_count =3D 0;
> >> +
> >> +                       smp_cond_load_relaxed(&current_thread_info()->=
flags,
> >> +                                             (VAL & _TIF_NEED_RESCHED=
) ||
> >> +                                             (loop_count++ >=3D POLL_=
IDLE_RELAX_COUNT));
> > The inner parens are not necessary AFAICS.
>
> Provides better reading. Do you want to remove these?

Whether or not it provides better reading is in the eye of the reader.
We seem to disagree here, because IMO redundant characters don't help
clarity.

> > Also, doesn't this return a value which can be used for checking if
> > _TIF_NEED_RESCHED is set instead of the condition below?
>
> Yes, indeed - should I modify this check? (somehow I wanted to preserve
> the original check)

But you haven't - it goes the other way around now.

In theory, _TIF_NEED_RESCHED may be set in the last iteration, in
which the check below will miss it, won't it?

> >> +
> >> +                       if (loop_count < POLL_IDLE_RELAX_COUNT)
> >> +                               break;
> >> +
> >>                          if (local_clock_noinstr() - time_start > limi=
t) {
> >>                                  dev->poll_time_limit =3D true;
> >>                                  break;
> >> --

