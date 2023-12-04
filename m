Return-Path: <kvm+bounces-3407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50483803F55
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 21:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E941F1F212C2
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 20:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6009435EE4;
	Mon,  4 Dec 2023 20:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="cbhdkNjm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1B7F0
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 12:31:55 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-42552cfee32so11615911cf.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 12:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1701721915; x=1702326715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Id0A3lPUtQng12VZaa5ELLdYETtg+mY4YWeeL/hdTB8=;
        b=cbhdkNjmP4c7ebttSktKQo9x1uibuNsK+64UIEQfBV4AllnCZNRk4XTqRpSgJCm91d
         jbo7DuAzgcAV//5DRbM3HNAepkAQU68EzQ4Um4xjyCAK1rjX6cnxqW1M9e2PHS4KA6LZ
         L+987kdZ02b5YsxPF5mizPuSnTPSdlFNqCls6w6ey9T4zrc/vJ3M9a1bkyWSZLQZBjCq
         Fa7IEnj8Oc6vXPS0J7M9oownvvn5NPLPf5/onNFq7KoFWaUthePo1mnlOzwDIapSPqSF
         GH1jS0xLPbNCRLRKi1pJEG76Hm2rNO/1XWMQ6U/+XYAWKFRK92OePpDxtkEYPxMQpcrr
         nVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701721915; x=1702326715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Id0A3lPUtQng12VZaa5ELLdYETtg+mY4YWeeL/hdTB8=;
        b=IZlJSwh7DcsCvBDa7Nao1cqA0Hn810y57CMsRJCex3QOqiabY1scnHCPjkL9NmsMh4
         lqY3dxypTic8JGewMUu2gbtbrRWGi/1mKUjw+DdBC0jIaR2z9/90Q38aNWpR+lRZBlHM
         qgM/ara72bp56mmUqTSg5QMv6RdGUvmcGXUGWvA07XWKEJZCQMOXWTxDyNR+Vi8BFL6S
         F9U4K3yoZQ/e0UBH0dFStCG9pp6/lrwHR7BLV62IobVcTqn+JUi3Yxad545ITGUAMiHq
         R9fZeFqGH9z/YAbeFppzzdQLi//MO6iWGPhvm9phoCMhAen298pe+iHs2u2UQMwUeFII
         NQPg==
X-Gm-Message-State: AOJu0YylHzIGKvXBOQO42WM3g5bcxFvxE85DJwRZkWhzxLyBApf+Xy1e
	70h3FM9YTve4Db5E/0tcHshA6sgxO206vJEUkq9zbMhBljZjC/Yn
X-Google-Smtp-Source: AGHT+IG9zqUF3niMJwuQ5C+wqvtP2tD3MC5Fp+mckTJdlEQhrXoY/Uh6svtdslAMunyoI0IBX/qfzNNmqoBPj/fYhEQ=
X-Received: by 2002:a05:622a:1749:b0:425:4043:5f07 with SMTP id
 l9-20020a05622a174900b0042540435f07mr192980qtk.69.1701721914961; Mon, 04 Dec
 2023 12:31:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231130200900.2320829-1-pasha.tatashin@soleen.com> <20231204154614.GO1489931@ziepe.ca>
In-Reply-To: <20231204154614.GO1489931@ziepe.ca>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 4 Dec 2023 15:31:17 -0500
Message-ID: <CA+CK2bCbyO+rXpHJ0AN4F9nzqMKbMnN7g5J_O2dMJGKoB8dC7w@mail.gmail.com>
Subject: Re: [PATCH] vfio: account iommu allocations
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, alex.williamson@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 10:46=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Thu, Nov 30, 2023 at 08:09:00PM +0000, Pasha Tatashin wrote:
> > iommu allocations should be accounted in order to allow admins to
> > monitor and limit the amount of iommu memory.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > This patch is spinned of from the series:
> >
> >https://lore.kernel.org/all/20231128204938.1453583-1-pasha.tatashin@sole=
en.com
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thank you,
Pasha

>
> Jason

