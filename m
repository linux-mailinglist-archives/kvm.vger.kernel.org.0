Return-Path: <kvm+bounces-5132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A7081C79C
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 10:52:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0658287DC0
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 09:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2BEFBEC;
	Fri, 22 Dec 2023 09:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GZlJLnPX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87E3F9EF
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 09:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d3ef33e68dso12213035ad.1
        for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 01:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703238730; x=1703843530; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/oGzqKbAgpu4zySBC+7kLRFWSum1+ZYKYmLtZ1Yu6Nk=;
        b=GZlJLnPXtlm3FYQmq6k+/E7W6LSqBING/MLq6nz4pNeOUMAW65LjoZVhHuoxVUjb/9
         /Pvm2HcWVOfDuhYU85DlBAyZb2g1fJsy00trauaKaZOv+bYzkMAnP0B0Jg5mn1Ry+YhL
         fyL/BaRYxL1qsQi94iZRuaHAYLs//SosFCx/ZCqYnAel2QlpiamW+pEiM8PLvQkgvnPu
         s6hQrlCGmvz0oyfmUiI0tI0GfnapAPZhdwpS+8ca167fdtCoGZT9mP80u6F9/75rcBb9
         P3wsopt1o19G77dsOFngl6QiqdMv1cK2O5+mWuPvTtSAoQ+mkZ7Q1NXMa0ae5GTFWbPu
         w8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703238730; x=1703843530;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/oGzqKbAgpu4zySBC+7kLRFWSum1+ZYKYmLtZ1Yu6Nk=;
        b=NS15XJnn8hlmiH4dTvuJjhw+i1j1qL+BxXxyOO8+e+a5ggtFR9NO2w7ocqAkAC7J5R
         wBgtpW3mhVIgOvJBGgxGRQ140JlZkbMvn/ziICgUt9jBawZv8kW//QV5Kh77U51PexT8
         74RvZFnnw5AynYr2YU+f5j2SzZDct+4P3e65+BZ1mKw7TwgVBBykz/kedwPz831Dg9w/
         l+YvoJUdJwHjwua0mUGGhmK9Ka5Fwy+Ns9yRXgyrc65+2qmYb/iNnM2ZSxXpmeQyO3pK
         vRLtGpcbJLHCFWPhJXp2bhiBXssiUlcdSGVIey5kdu3XZFTTbYZutqH5PbP2hFebFOz9
         QsWQ==
X-Gm-Message-State: AOJu0YyodbLwW6/jQPKXe8MIAGihXpn+z4t3N0l6fZ1b2Q7/EIrbSaRN
	mjxhVZTD3OdC2iaF8sQmCoI=
X-Google-Smtp-Source: AGHT+IFhx3xO2W0ciK9SRJbTwz9Gf645xzxvDZynI5z/OnmVKHMCSfWHi71FKgmV4f8xxVHmz4B7cA==
X-Received: by 2002:a17:902:d54f:b0:1d4:cae:99f9 with SMTP id z15-20020a170902d54f00b001d40cae99f9mr1594572plf.45.1703238729951;
        Fri, 22 Dec 2023 01:52:09 -0800 (PST)
Received: from localhost ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902ea8200b001d1d6f6b67dsm3052737plb.147.2023.12.22.01.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Dec 2023 01:52:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Dec 2023 19:52:04 +1000
Message-Id: <CXURQJVKGNET.OGA1CKMUBD42@wheely>
Cc: <linuxppc-dev@lists.ozlabs.org>, "Laurent Vivier" <lvivier@redhat.com>,
 "Shaoqin Huang" <shahuang@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Nico Boehr" <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 13/29] powerpc: Make interrupt handler
 error more readable
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20231216134257.1743345-1-npiggin@gmail.com>
 <20231216134257.1743345-14-npiggin@gmail.com>
 <4a42b65c-f65b-41cf-91f6-eeb96519dc2c@redhat.com>
In-Reply-To: <4a42b65c-f65b-41cf-91f6-eeb96519dc2c@redhat.com>

On Tue Dec 19, 2023 at 9:53 PM AEST, Thomas Huth wrote:
> On 16/12/2023 14.42, Nicholas Piggin wrote:
> > Installing the same handler twice reports a shifted trap vector
> > address which is hard to decipher. Print the unshifed address.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   lib/powerpc/processor.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> > index aaf45b68..b4cd5b4c 100644
> > --- a/lib/powerpc/processor.c
> > +++ b/lib/powerpc/processor.c
> > @@ -26,7 +26,7 @@ void handle_exception(int trap, void (*func)(struct p=
t_regs *, void *),
> >   	trap >>=3D 8;
>
> You only change this to >>=3D 5 in the next patch...
>
> >   	if (func && handlers[trap].func) {
> > -		printf("exception handler installed twice %#x\n", trap);
> > +		printf("exception handler installed twice %#x\n", trap << 5);
>
> ... so I think you should move this patch here after the next one.

Paper bag for me.

Thanks,
Nick

