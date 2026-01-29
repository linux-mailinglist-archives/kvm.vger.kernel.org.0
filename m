Return-Path: <kvm+bounces-69640-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MDAxGSbme2n8JAIAu9opvQ
	(envelope-from <kvm+bounces-69640-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:58:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC591B58F9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12BB3302797F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B922936D4E3;
	Thu, 29 Jan 2026 22:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j6VdjXwL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5304E36CE01
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 22:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769727510; cv=pass; b=tyRH0+s0tfV2q2TXAd7MODstXksgThAY7H7nhpv+TLC3TdLDvd8tCj2IwaiuGQEbO0qAm3fmrRwd9iozC/D0qSTN4N7nrO28ZBt68D7wASIWWPcEY2rZOheUKOp6ilbEkJDKLRKVVQpzHrSy1tAglTpND61TH6qvc6HDJvBwWm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769727510; c=relaxed/simple;
	bh=SR/v5TklhOolnIhKUz8r75fq4feIeVJF3sBpfHfQPIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z+oj/SebxenkHjC1YL9ztpmt/EgNZGOa6eRCfYhCnKC+DWeCELaDmiI0Bt+Zp8Ap9/4Qk638B0mgTM9oLlA/QQA6eQs9L6v0ngZroTfoZVEGjJ6Pw+Rzf7mA8znaXTdoafb9V9tkv0OQ7I4NteHl+RIclUD/zoA9ZXuCYHuFwZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j6VdjXwL; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59de66fdb53so1390634e87.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 14:58:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769727506; cv=none;
        d=google.com; s=arc-20240605;
        b=Pa2m50WEO4xqCvMaQX0H0oeQcWdqcUkYgMAGSgrQR90/GSAVdjDEgdpz8MwKUNUx5b
         iDWgjtOAgm0CkolIsFrqqpqfBgksDVtgm1EyXhrgRANWVjR2Rz+qkSkVZAXs8ME6rMiu
         sgYhIkmi0+l/19MFtMvvT7lqxdsL/JMDwbzS23PND9TySetEX580MrPfmVY0SBxGP6X4
         PwUqpp+XjociginbeXs0AnZKGKFzTeJN8r7uOWBd4HS8l/gdW25QP7qOpRnSsUmi4Awx
         17EaSrdxgZkrBnojEa14BCd/gRWxeTKtKrFuQxk6Kj204p8NUvE15/wcGGVL8TYTc+2r
         FmJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F1bZu8R3pK4Srj8vXk4ihEBDH1LGtIFmZ9pqs3VyhmI=;
        fh=Sr9ekqJ5T9Mqez7sDX6N9QzbWItF0rPT+3FJtzHieFE=;
        b=fvtICPO2lsZcHuGbNuzykvZyJ8+uAZOFJMQsBy4YUbMxPamvI6N2w1X80nCIAbj05l
         RfBPJsYF1nfWXn7CH/I8q6fwJsaQ57X+o29vSosdeSp5wqopK8Ft98lhkdDg/8IX3V2q
         izajMZQUJdjYSlA9WDBrdvg4w8YsjzTAcZjHOdzzD6CW35lj5z2TQs1DcGnm+ygw3Gu6
         eDVk8kDA4foOPORyxITiufZzfof6RJRLm2C0tmhINVPXVNwfdIBtXkh+7aFp32jzh2Ib
         XOlgGvQEsClsjcrXvg0zqNf8PztMVDvHlv+mT8p/mGSqbsR6gYwzjMvdrIfauSIlEwT3
         x/zw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769727506; x=1770332306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F1bZu8R3pK4Srj8vXk4ihEBDH1LGtIFmZ9pqs3VyhmI=;
        b=j6VdjXwLnU/GrL4PSycE4Bs8pTm6JUOJaxs5c5AUwWB74VavgxsbMJg9+WIyMY1gag
         9a76sMdqMP2vVr1sSKq1voZzWbHSaB2N88eKi4lAQh5otBeosvof9KeTyGsDzcy3O6M9
         MJWXBS+69m+pNUsbs8yY60tlxf7lI4yOZKJMjQ9x2rWA+Wv+2VSVCMBtywVMTt1ZqElX
         CUpyHCaGmCqaMS8fMH65H5KuF1Ew3TsOjwq5VzBRoKUzJYTnO4k9gTPTXeZsL5hw/Bb+
         rCUziW8b8UorUQ039JoieEPLe4XTN5ftcpU0f1FY6s75AikrDGMCJu+g/KnvFjUYF0Q/
         YKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769727506; x=1770332306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F1bZu8R3pK4Srj8vXk4ihEBDH1LGtIFmZ9pqs3VyhmI=;
        b=gfHgzDB0L87Oj/c1mUu0pJfL3HmJILV7hY1JDOoYB26GlZA+nOVgze+syLOrsp1qMv
         PTkamgZ5s1MVdTvW92ececEQ1Bcxsue3JGaVH1aoemzb6CwwRd0h/b7/ThOXWI1DxYJh
         UOiwCx5HMKlYyb/LnZBg/L/oJUX61cmeqytnQsmIrTwULA6kws0novA5TvA8P9/AI2cw
         AFSfb6z1h+D79cr6YT6DXPEf6R1YZhMdgUhovpXyyYE8FVySqmox+vhHK0a/LgRUBsCf
         Ho6jrHvMt0GoPhnjJKlqPSBBk8x/XhmsHhsFjY1vHKe9hoe8OT50wme35VzPrAsvGg4E
         P5pg==
X-Forwarded-Encrypted: i=1; AJvYcCVjsiZw2XDZXLNLvqHJNfuJvWbNWSFSYvgFII0a6q0VLzWsCZH3dip0EoOLLtQh/u5PsMw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpgnksdkZiVMCAY5BXzl2n4pQrFi0u2Eo2WOQA6qwSODXKpRQq
	gIkYUNsWi/v4/WlOSirCnVkgim0d5dpzWOfLMCL4VDlupMaaCnaaTsAK6az6P3n8xNuomWoLGXJ
	wDQ1xlRMmH/ccbwzCALbOgjcp8O78q9N8t2ZuY5gr
X-Gm-Gg: AZuq6aJvmT3G1y1xpE4UVqeBsxmaretG/pLmTE070zXkKtpfKXKzy979ioWG7ezOIpJ
	tl+lMOlUgQNFoIelyoYx548MQvp/s1jpcTZxCu3vDoCEuDumOgpmFfwG8xLyQ1IOfOyRbmkxkDV
	SB6YzMrucFf9SmLNJL+O1pubAMADd7crbX7vOQW+3SX193qLh8DGnvTDuCKR5BROuGYiu9bK6Az
	ou7zlBv4nARq2jF1a3DtjqzJ4YvRGushi0nOZ5LHuQIsmA15IuqMfgM2ufq9Jt2xwA7mg==
X-Received: by 2002:a05:6512:1329:b0:59e:417:2ad2 with SMTP id
 2adb3069b0e04-59e1645add1mr230619e87.50.1769727506186; Thu, 29 Jan 2026
 14:58:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260128183750.1240176-1-tedlogan@fb.com> <CALzav=dMhycS2iBxkhPCz3tMUKxkfgr1dCLFGYzGuXZCeYhijw@mail.gmail.com>
 <9d992d4a-1aea-42a7-aa79-4ede80293f9b@infradead.org> <CALzav=cWEoydGBpf4j5gPWy0TzLoAPP3YeG3VocbeEzytHTFrw@mail.gmail.com>
 <20260129115039.10fe3c76@shazbot.org>
In-Reply-To: <20260129115039.10fe3c76@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Thu, 29 Jan 2026 14:57:59 -0800
X-Gm-Features: AZwV_QjtbgKitpamFKkDtA6ex3xqSqJUofJoh4JUwSCpyN8Ze7Z7nXH4GwE_IC8
Message-ID: <CALzav=cUDm6xSzw=KZeNmZT2=YKL+9N=_qLRmiCSvSBhbsAfew@mail.gmail.com>
Subject: Re: [PATCH] vfio: selftests: fix format conversion compiler warning
To: Alex Williamson <alex@shazbot.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Ted Logan <tedlogan@fb.com>, 
	Shuah Khan <shuah@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, Alex Mastro <amastro@fb.com>, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69640-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:email,fb.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,intel.com:email,infradead.org:email]
X-Rspamd-Queue-Id: BC591B58F9
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 10:50=E2=80=AFAM Alex Williamson <alex@shazbot.org>=
 wrote:
>
> On Wed, 28 Jan 2026 11:21:52 -0800
> David Matlack <dmatlack@google.com> wrote:
>
> > On Wed, Jan 28, 2026 at 11:12=E2=80=AFAM Randy Dunlap <rdunlap@infradea=
d.org> wrote:
> > > On 1/28/26 11:06 AM, David Matlack wrote:
> > > > On Wed, Jan 28, 2026 at 10:38=E2=80=AFAM Ted Logan <tedlogan@fb.com=
> wrote:
> > > >>
> > > >> Use the standard format conversion macro PRIx64 to generate the
> > > >> appropriate format conversion for 64-bit integers. Fixes a compile=
r
> > > >> warning with -Wformat on i386.
> > > >>
> > > >> Signed-off-by: Ted Logan <tedlogan@fb.com>
> > > >> Reported-by: kernel test robot <lkp@intel.com>
> > > >> Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEF=
D-lkp@intel.com/
> > > >
> > > > Thanks for the patch.
> > > >
> > > > I've been seeing these i386 reports as well. I find the PRIx64, etc=
.
> > > > format specifiers make format strings very hard to read. And I thin=
k
> > > > there were some other issues when building VFIO selftests with i386
> > > > the last time I tried.
> > > >
> > > > I was thinking instead we should just not support i386 builds of VF=
IO
> > > > selftests. But I hadn't gotten around to figuring out the right
> > > > Makefile magic to make that happen.
> > >
> > > There are other 32-bit CPUs besides i386.
> > > Or do only support X86?
> >
> > At this point I would only call x86_64 and arm64 as supported. At
> > least that is all I have access to and tested.
> >
> > If there is legitimate desire to run these tests on 32-bit CPUs, then
> > we can support it.
> >
> > Alex, do you test on 32-bit CPUs?
>
> No, I haven't tested 32-bit in a very long time.  I'd like to think it
> works, but I'm not aware of any worthwhile use case.

Ok, thanks. Then let's defer making the selftests code 32-bit
compatible until there's a use-case / demand.

Ted, would you be able to send another to change to opt-out VFIO
selftests from 32-bit builds to avoid future kernel test robot
reports?

