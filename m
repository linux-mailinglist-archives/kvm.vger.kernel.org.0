Return-Path: <kvm+bounces-2812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C257FE286
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 23:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6066B2112A
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7474CB44;
	Wed, 29 Nov 2023 22:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="RvsWmgXg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9787B122
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:00:21 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-423c28db22eso11576201cf.1
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1701295220; x=1701900020; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiOfm5uGDMrP0UYnHwC5BRUcA0oU3b2DbcdcIFPiI/Q=;
        b=RvsWmgXgSTSe55spuxPnTVTCjzAxwYMn8vLxWO0UVjnE/+I0G4uCc/mMWkz7TzlfJF
         KtNWzgzGYoJ7fLVvLoxeVMtb3WDlPy+6hP4iRUccXPRDSbTrJ0gTwMO2CKuKMefAWzee
         AWa1cOJNynCMOnsZbRXAg79SjOOjhjwxG/jxiqwbT6OYyryLd2NFMXae+aTGw7ZYNbNT
         lN5L1ym5+VyVJRztXDpUf9KRzZpuOqiQ8vr22ep7YL+20UAw1+yFUey6AP6YH8T7Y0iX
         +xsXaew4+oGxUiXkTu/6edL8aFZwNJyZj60Wggxyt0s69I5lmMnbtZaKAuS/hIAHRZNz
         oSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701295220; x=1701900020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aiOfm5uGDMrP0UYnHwC5BRUcA0oU3b2DbcdcIFPiI/Q=;
        b=cz1ag/CLxc62qcSjxla6KTiz8LKodnDBGw3GClMC59Zq4ImijJ+c5sgeWV+sE/oUYD
         PSoo/6JoxYk4Y2vKfDVfQgxAtLld303o1ykC7jVvpxXxfx80vNVgGVLKsRrsidxxx4/Z
         1vx4a+j4Slw2feUA0N1+FAxJGwrYRCiW4EWWSqtg7NkM1LEzayo5bIMW2Ux3ZNwcpvuw
         vZll/AkjdiI4M+T7zbWROl+GG1ka1MiTYQ1zuNey6ZKaflrV5A6J0KPKSnsIIeOwa4lu
         frA4uGfHPJiTT0vM/ZG0pIRFOmuAnGXLyXePDIpaijU6IWNUfOf7DFgKT4CMC9OSm4vv
         RZ3g==
X-Gm-Message-State: AOJu0Yz5owxvemuZYzSSurqwTbK9iyBkgve9kiQ8DUryuzYYw1ZrF20O
	WzM9MOQbEMGhLuLv+myHgU7JeJ6hNcEXzK2XOWIYCg==
X-Google-Smtp-Source: AGHT+IGmE/x/Q9wBAAP4WSVeu6Pzwkh80gJNXkwIoavJV9VXufokUhNCLXMfXFExg6GRm7Q1Y/p8TrFXYkay1vjqtA4=
X-Received: by 2002:ac8:5ac4:0:b0:41c:d62b:fb51 with SMTP id
 d4-20020ac85ac4000000b0041cd62bfb51mr39263562qtd.26.1701295220560; Wed, 29
 Nov 2023 14:00:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128204938.1453583-1-pasha.tatashin@soleen.com>
 <20231128204938.1453583-10-pasha.tatashin@soleen.com> <20231128235254.GE1312390@ziepe.ca>
In-Reply-To: <20231128235254.GE1312390@ziepe.ca>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 29 Nov 2023 16:59:43 -0500
Message-ID: <CA+CK2bC=vMU54wXz1GSzpOcLFCuX5vuE6tD49JF8cMbz4tis-g@mail.gmail.com>
Subject: Re: [PATCH 09/16] iommu/iommufd: use page allocation function
 provided by iommu-pages.h
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com, 
	alim.akhtar@samsung.com, alyssa@rosenzweig.io, asahi@lists.linux.dev, 
	baolu.lu@linux.intel.com, bhelgaas@google.com, cgroups@vger.kernel.org, 
	corbet@lwn.net, david@redhat.com, dwmw2@infradead.org, hannes@cmpxchg.org, 
	heiko@sntech.de, iommu@lists.linux.dev, jasowang@redhat.com, 
	jernej.skrabec@gmail.com, jonathanh@nvidia.com, joro@8bytes.org, 
	kevin.tian@intel.com, krzysztof.kozlowski@linaro.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-rockchip@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev, 
	linux-tegra@vger.kernel.org, lizefan.x@bytedance.com, marcan@marcan.st, 
	mhiramat@kernel.org, mst@redhat.com, m.szyprowski@samsung.com, 
	netdev@vger.kernel.org, paulmck@kernel.org, rdunlap@infradead.org, 
	robin.murphy@arm.com, samuel@sholland.org, suravee.suthikulpanit@amd.com, 
	sven@svenpeter.dev, thierry.reding@gmail.com, tj@kernel.org, 
	tomas.mudrunka@gmail.com, vdumpa@nvidia.com, virtualization@lists.linux.dev, 
	wens@csie.org, will@kernel.org, yu-cheng.yu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2023 at 6:52=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Tue, Nov 28, 2023 at 08:49:31PM +0000, Pasha Tatashin wrote:
> > Convert iommu/iommufd/* files to use the new page allocation functions
> > provided in iommu-pages.h.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  drivers/iommu/iommufd/iova_bitmap.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> This is a short term allocation, it should not be counted, that is why
> it is already not using GFP_KERNEL_ACCOUNT.

I made this change for completeness. I changed all calls to
get_free_page/alloc_page etc under driver/iommu to use the
iommu_alloc_* variants, this also helps future developers in this area
to use the right allocation functions.
The accounting is implemented using cheap per-cpu counters, so should
not affect the performance, I think it is OK to keep them here.

