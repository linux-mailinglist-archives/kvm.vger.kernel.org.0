Return-Path: <kvm+bounces-7341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 140DE84090D
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 15:52:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46BE41C21951
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 14:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78ABC1534ED;
	Mon, 29 Jan 2024 14:52:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92473152DE4;
	Mon, 29 Jan 2024 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706539953; cv=none; b=X2Zau/KCM1yNFrhZUkbxarpgNHYyiAL6jyrBA9PsrYFBktbzGcFpE4oqeqsDKH4QdMvMY+PAZU6qSv1/sThSdb4ELi2JwQVOlSWjTPQhM0VPcVTz5JYQug+cXr7m/gViUtA75CBwWhUXCltzRwjg49YXnDyWTV3eJc8UJfuwi3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706539953; c=relaxed/simple;
	bh=er4E+kldT3HkIVkFzlNFfVMjlPZ/OUYJTRvYzqmxZuI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PLeGecbpIJN1AewU7NtNR1V7O/haIgsbVi7XJe/J5YKd6ESO+I3rSFzBo8j5P89SGrpfrqolZ+PygqEbupxZ8UuXiygqWA6JnEvfNbTM4AKFhhO+fEaReGGYoZoVYfctQH+zh+YysfpvIDMdyTC0d5lszIcdHeg1OzqASAV4K+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3be6b6a79daso30124b6e.0;
        Mon, 29 Jan 2024 06:52:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706539950; x=1707144750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOtU9g2kX1yF7rEI6xIgR7yMtelVCGrmiEAuIJRD/fM=;
        b=ZybFedP6x49l3L8t/okk/2Z5WghPsS4OFLsyyMI+EZtbM3FulzMrYNzvZEZADm6PXM
         /DnpaakjWvc5Zos7IrfgEkvo/m7fujijbJ3zOv4OzI9LN5uol0mZsm/a4TyNGW17a2Cf
         B1U1cDSliQ+EQe92w50+aBAdu3VtTJZvlHoC8mJQhjr8WYa6fMg9wuJSrJvsrz38njiD
         SLsa44iYvjLi29UZxJ6FUG2P3eYTUMJlaKkrQSg5ws6MjL6Cbaz2uBa/eFPsbpRYrpct
         KxdhnjcuT918NuONbHJHfTOCiREzvrzu/4wGDCmYHb7DafcBnYEni1sAJiDJDBnX6XTy
         mF0Q==
X-Gm-Message-State: AOJu0Yzr3khFVPvdYRZtZvKgknFzV8huybsEJlhupEuaX85/hMmXVUV+
	vzrB9ZfmpgUIEIiDEWtuz8L9SGLlhlOwRBvlAyEbobqDJMpv4BsI0GXaHzs0e2HQJuoXIrU8xSE
	iVbeOdQ5tzVr2ruYRhFjtCpvoCRQ=
X-Google-Smtp-Source: AGHT+IG+RO709vmRT5Tc/RSOuavk4HPIQsze3s5xQRhfbWgFCfetxNKZGq70dGVm918oH/ppUElCzdRv4rANW3dsi80=
X-Received: by 2002:a05:6870:9a02:b0:218:75ee:4b49 with SMTP id
 fo2-20020a0568709a0200b0021875ee4b49mr3910317oab.5.1706539950665; Mon, 29 Jan
 2024 06:52:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com> <1706524834-11275-8-git-send-email-mihai.carabas@oracle.com>
In-Reply-To: <1706524834-11275-8-git-send-email-mihai.carabas@oracle.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 29 Jan 2024 15:52:19 +0100
Message-ID: <CAJZ5v0gPoLan0M2A-x5V=ZNCxbYdv5e5DvNZTyo6Bd3e9HThYQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] cpuidle/poll_state: replace cpu_relax with smp_cond_load_relaxed
To: Mihai Carabas <mihai.carabas@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
	rafael@kernel.org, daniel.lezcano@linaro.org, akpm@linux-foundation.org, 
	pmladek@suse.com, peterz@infradead.org, dianders@chromium.org, 
	npiggin@gmail.com, rick.p.edgecombe@intel.com, joao.m.martins@oracle.com, 
	juerg.haefliger@canonical.com, mic@digikod.net, arnd@arndb.de, 
	ankur.a.arora@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29, 2024 at 12:56=E2=80=AFPM Mihai Carabas <mihai.carabas@oracl=
e.com> wrote:
>
> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
> smp_cond_load_relaxed which basically does a "wfe".
>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> ---
>  drivers/cpuidle/poll_state.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> index 9b6d90a72601..440cd713e39a 100644
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -26,12 +26,16 @@ static int __cpuidle poll_idle(struct cpuidle_device =
*dev,
>
>                 limit =3D cpuidle_poll_time(drv, dev);
>
> -               while (!need_resched()) {
> -                       cpu_relax();
> -                       if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> -                               continue;
> -
> +               for (;;) {
>                         loop_count =3D 0;
> +
> +                       smp_cond_load_relaxed(&current_thread_info()->fla=
gs,
> +                                             (VAL & _TIF_NEED_RESCHED) |=
|
> +                                             (loop_count++ >=3D POLL_IDL=
E_RELAX_COUNT));

The inner parens are not necessary AFAICS.

Also, doesn't this return a value which can be used for checking if
_TIF_NEED_RESCHED is set instead of the condition below?

> +
> +                       if (loop_count < POLL_IDLE_RELAX_COUNT)
> +                               break;
> +
>                         if (local_clock_noinstr() - time_start > limit) {
>                                 dev->poll_time_limit =3D true;
>                                 break;
> --

