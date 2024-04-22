Return-Path: <kvm+bounces-15497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC468ACD3F
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93288281E5E
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 12:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F18814A08D;
	Mon, 22 Apr 2024 12:49:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C41B3233
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 12:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713790153; cv=none; b=p2S/Su6rP0DoVooE0zy9B2a2CFfTNtdTeUSCv3zViuJwpMbGBVw9Pex5YNxb7hAIhw1qO5adqu5wEfuxkXcv5AA7N/K+8aVMHQDFxRhtaxcOzbGHUA9+Ustsy4KGUJlOyLQWvUxWBqAmCT+WmJWI5K5DVvz5odURKjhCR1rFcOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713790153; c=relaxed/simple;
	bh=A7WbSxvRhkRaygMuG/XdCIzMmoA1hU8yZHwu37RxCko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EPKBmVpJiq7vaEjWt5+0dUOk1vmQIz6r0txrTkvkZYCljfeTTOUjkqzlDbQZBxXRQ2dwub+ADQbqLCZ6Zb/epRJhSmoMKztIunrP9+CjWYdEL2Un+2UHJHRI7+ZSXp3wAJe05ig8/OBO6w8t4Sdqq2Y6/EQzzxktO/hT8PkGzTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-61816fc256dso37729847b3.0
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 05:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713790149; x=1714394949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yqjHhkhZhu016WB+ENEXmAF3a/WNz/OKE8i9tnmvyu0=;
        b=VEFLP1eN7BI7Y76mWXvm/SONfumCaiwMxEXE+Byd6rv5zU0Fqih7QsT+AYWuIMhWHO
         re8bnA7kVbZugFiLKMLxnscCI1jtU+XpX/auq+RgxPpEYOMHyKcQQpEeKZAV7igOjpcU
         XFhWNoHIq+MEd0iHYjywfMF3WsiUqg8DgEPELtLlqo8UkeVpgNh+sEnf/a8SXQtObbxV
         aThTwWgwr8AmB/69OhdA8jECQ2nt0YolRcQ4WM5kZz9ug2NWJto2BD0kWBYyxB/C1lrU
         QD9N2EvdzSIExNSYLNhxixbcmMihLe7DoDUwZ+wPrMTigXHfrXcshBTPnW/qJ35BFbdv
         H5yA==
X-Forwarded-Encrypted: i=1; AJvYcCWtKkMLzXC+HdTi1L8yWWZ5R2iG9MQoQ3qsz9Bnv3DsF7lG6U8BGWWrGcK8/CTVAVuEAiQP3Zdu5xcYqm4KaMTadNpm
X-Gm-Message-State: AOJu0YwMPp696Dgy8oc21cMJrlkADxaIO2AexHA+TCKMEMZ69TLhqPn9
	zPMiq5EvQsvTN5INc/3sU0rFjXPVvYLghBpHhYV3gqhN/PCQ1SwEW5wuKyHd
X-Google-Smtp-Source: AGHT+IFe5cGIQqhe3HyiJL5CwPhtUa18yG0VaLYQ1p6EMPphUmE2ensD//HwfhltydI+gOvkIYa3jw==
X-Received: by 2002:a05:690c:6906:b0:61a:b199:9313 with SMTP id if6-20020a05690c690600b0061ab1999313mr9293056ywb.16.1713790149016;
        Mon, 22 Apr 2024 05:49:09 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id t21-20020a0dea15000000b0061abc6baadfsm1982161ywe.14.2024.04.22.05.49.07
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Apr 2024 05:49:08 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-db4364ecd6aso4240935276.2
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 05:49:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVKvVHyKUjDVF1vpY5oW5gHNfGVRZqWxjhQ5NHsM9tyYsy+KDCEEG9TayWwAsq2CjUzIeKTEGj+/vbVDydPRrbwxupA
X-Received: by 2002:a25:86c7:0:b0:de0:d45f:7c5 with SMTP id
 y7-20020a2586c7000000b00de0d45f07c5mr8238629ybm.20.1713790147656; Mon, 22 Apr
 2024 05:49:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <16-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <6860aa59-3a8b-74ca-3c33-2f3ec936075@linux-m68k.org> <20240422115435.GB45353@nvidia.com>
In-Reply-To: <20240422115435.GB45353@nvidia.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 22 Apr 2024 14:48:56 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXqH1rGWz9d-t=XpWCF5jqDNhao4mJBPaUhBS8Ab_OirA@mail.gmail.com>
Message-ID: <CAMuHMdXqH1rGWz9d-t=XpWCF5jqDNhao4mJBPaUhBS8Ab_OirA@mail.gmail.com>
Subject: Re: [PATCH v6 16/19] iommufd: Add kernel support for testing iommufd
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Anthony Krowiak <akrowiak@linux.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Chaitanya Kulkarni <chaitanyak@nvidia.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Daniel Jordan <daniel.m.jordan@oracle.com>, 
	David Gibson <david@gibson.dropbear.id.au>, Eric Auger <eric.auger@redhat.com>, 
	Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev, 
	Jason Wang <jasowang@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Jason Herne <jjherne@linux.ibm.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Lixiao Yang <lixiao.yang@intel.com>, Matthew Rosato <mjrosato@linux.ibm.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Nicolin Chen <nicolinc@nvidia.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Niklas Schnelle <schnelle@linux.ibm.com>, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Yi Liu <yi.l.liu@intel.com>, 
	Yu He <yu.he@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Mon, Apr 22, 2024 at 1:54=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
> On Mon, Apr 22, 2024 at 09:27:18AM +0200, Geert Uytterhoeven wrote:
> > > +if IOMMUFD
> > > +config IOMMUFD_TEST
> > > +   bool "IOMMU Userspace API Test support"
> > > +   depends on DEBUG_KERNEL
> > > +   depends on FAULT_INJECTION
> > > +   depends on RUNTIME_TESTING_MENU
> > > +   default n
> > > +   help
> > > +     This is dangerous, do not enable unless running
> > > +     tools/testing/selftests/iommu
> > > +endif
> >
> > How dangerous is this?
> > I.e. is it now unsafe to run an allyesconfig or allmodconfig kernel?
>
> Depends what you mean by unsafe? This is less unsafe than /dev/mem,
> for instance.. It does nothing unless poked by userspace.

OK, so the test itself does not cause a crash, or data corruption?

> > Probably this symbol should be tristate?
>
> It is not a seperate module.

Perhaps it should be? ;-)

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

