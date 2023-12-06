Return-Path: <kvm+bounces-3696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2DB807123
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 14:48:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FA091C20E44
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 13:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C99D13BB31;
	Wed,  6 Dec 2023 13:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EATPFhKR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF76122
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 05:48:02 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-50be58a751cso5518264e87.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 05:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701870480; x=1702475280; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9miOKK/UUvaSvAzOVHQH1JTB5Oh8DCGH0eTcRA1Hgqc=;
        b=EATPFhKR5/xyrbkoX3idqVJF60ZMxQD7SjRVVPHHgkmt3Rk5QvhDzMXzLCWqjxODtW
         Em37h/ZRYT837bWBVZ2gjLbIoUB5eOVtvFkr7S96RAjwkLqHaBS22rR/2YUB9N42S8H6
         J8SJ/gDdjCZxJILs5SZS7BHrwnNMzHfNeHmoupGbb3rY98j7Vw3ehYm3cFNSak0hYg9j
         ElbPVgqWw479nzzKAG6Ruq0AnKClwQgkD14bl5YFlSv4XMCVkpmE903lQpOiBCJT+l2Q
         rEMzIrvySjM8t92qszQVVRmRE8muwvlR0F2B5DSz0fLDMuNN2PizwoEHezcXtNcQ2ZYU
         jtUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701870480; x=1702475280;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9miOKK/UUvaSvAzOVHQH1JTB5Oh8DCGH0eTcRA1Hgqc=;
        b=W1mAfaNZiVrD3PRD0b8+dXQ8u/+eo3ritNChMrlq86WCvYg9PfRwj+VGq0wwRD4HBf
         PcqmNszIEJZrrq+uTSdoYcykkQxPEGBuKEN6zUKNy/1rLQ/6IKj+lx8/tX5VW/jIdhpH
         zClO2lMJGt14+mIcmJdRRMaV17p8oOsrNAwNXBnETXbrT38GE6zGBJVO3yplmqzH34yW
         mUdhxyQZFESO7QSfPeHMKiRfOZvqijTq13l+kKL27e5GOl5sq+/geJyQptNbV6rC08+J
         O9cJPTsiM9HVEKhQRD+zsndGb0V0kouOJBlSxKwXPyDbcLd4twtUwQ9W7W2Wq2p8hKn6
         Af8g==
X-Gm-Message-State: AOJu0YyK4zkvO+/29VETEgVU5rSp9VJA3LFhOiWjYjnhfJAhZn4ozxbx
	JnT0oCQQvphnmrs0DOoEIpUBROAK/wQU8Hp02cpd/A==
X-Google-Smtp-Source: AGHT+IHw3P3cXoW7pJNEQWcIDG3J+FZRlOarsKh/yt7qJA5ssgURhZvvxsqlatP7qeWxo5iGA+5Hy5O+DWF/K4Beido=
X-Received: by 2002:a19:f711:0:b0:50b:e750:dd94 with SMTP id
 z17-20020a19f711000000b0050be750dd94mr588145lfe.1.1701870479946; Wed, 06 Dec
 2023 05:47:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206005727.46150-1-zhangfei.gao@linaro.org> <20231206013039.GN2692119@nvidia.com>
In-Reply-To: <20231206013039.GN2692119@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 6 Dec 2023 21:47:48 +0800
Message-ID: <CABQgh9GVUh-6vXG=pgGgY5YotNb8VMQPUv6ESd11T8rb98Rd1Q@mail.gmail.com>
Subject: Re: [PATCH] iommu/arm-smmu-v3: disable stall for quiet_cd
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	jean-philippe <jean-philippe@linaro.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	Wenkai Lin <linwenkai6@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 6 Dec 2023 at 09:30, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Dec 06, 2023 at 08:57:27AM +0800, Zhangfei Gao wrote:
> > From: Wenkai Lin <linwenkai6@hisilicon.com>
> >
> > In the stall model, invalid transactions were expected to be
> > stalled and aborted by the IOPF handler.
> >
> > However, when killing a test case with a huge amount of data, the
> > accelerator streamline can not stop until all data is consumed
> > even if the page fault handler reports errors. As a result, the
> > kill may take a long time, about 10 seconds with numerous iopf
> > interrupts.
> >
> > So disable stall for quiet_cd in the non-force stall model, since
> > force stall model (STALL_MODEL==0b10) requires CD.S must be 1.
>
> I think this force-stall thing should get a closer look, it doesn't
> look completely implemented and what does it mean for, eg, non-SVA
> domains attached to the device (as we now support with S2 and soon
> with PASID)
>
> The manual says:
>
> 0b10 Stall is forced (all faults eligible to stall cause stall),
>      STE.S2S and CD.S must be 1.
>
> And there is a note:
>
>  Note: For faulting transactions that are associated with client
>  devices that have been configured to stall, but where
>  the system has not explicitly advertised the client devices to be
>  usable with the stall model, Arm recommends for
>  software to expect that events might be recorded with Stall == 0.
>
> Which makes it seem like it isn't actually "force" per-say, but
> something else.
>
> I notice the driver never sets STE.S2S, and it isn't entirely clear
> what software should even do for a standard non-faulting domain where
> non-present means failure? Take the fault event and always respond
> with failure? What is the purpose?

Sorry, I have no idea :)

>
> Aside from that the change looks OK to me:
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks Jason.

