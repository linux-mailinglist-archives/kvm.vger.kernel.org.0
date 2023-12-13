Return-Path: <kvm+bounces-4276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9688107B4
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 02:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDF72B20AE0
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 01:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA731109;
	Wed, 13 Dec 2023 01:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o6UQ8y9w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE17B2
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 17:36:16 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-50c222a022dso6917551e87.1
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 17:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702431375; x=1703036175; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8Hxc3TLAQxGrVMxCKcgPL57up2sHDuMinvi71A2jdig=;
        b=o6UQ8y9w9dNjYAylF0bVCFUSmfbjacxSJyTHWQlCC00v4Yr5wER2zJBjMYjI/NXP72
         Bpz8ypoZmMamG9ioxO0Te1APdSkk6xgGLm5Tt7o6vGcIRcwK2yyMqBzCduFur1PhSxKG
         s9ZblBnRbjPBtGUkIuWWoDjYISFjR4vrncHjZgjtHI0lQAU1wAmaBleiqJjO5wXEP7SZ
         GrNVsAsQoB8OvG2UTynrIlYWFSdmAxTSckFCgCFDHd9chJChV4HABTotytKdHAklXA6x
         nY+q2mPynPoVJXxFJqTfWJDynQw+mkoi/KP9qegrliyNUcP7Q69H7nk7oyL4llSI5MoT
         6blQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702431375; x=1703036175;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Hxc3TLAQxGrVMxCKcgPL57up2sHDuMinvi71A2jdig=;
        b=SzPVMXYAXiH1ncJdXCNCkisgmQmL7txyYJ8wysGlpgewWiNDpx0EeIy+x4qVH4Q/Ui
         kTxZ2jilgH6ZHgYwHLTIk5OBWFn1z0IrKpraObx7rrI/QXk0s5pYUPfYVNmfrYri6VSa
         s+JO8O/92PM1dkR2d4Og6mgwpiilMTU80mgomu81F8sghylP+uGzyLOFTZYs6Nk8UFwO
         PMAbZlYi2l7nqy6Xx+1Li+/bNtP7SzI2nk0hRRVm52R8B/2Fstr4pT/drDmQNIuWZ+nf
         L41b2lwynygEQLwBjvo4Wf1CGYVJGLPNUpa2AYYpxS4qhvWoYgtavj2R0lFlZtxj3Pa4
         V+Sg==
X-Gm-Message-State: AOJu0Yy0PT0NtjkaWkRQASlGxYc8l8Qd1OpGbcjhtl+FO5C0ALloZ9eJ
	T3NIfMuyKmMVYQe/FdwMqhWxpbcZqHQ5WC+nNoK05g==
X-Google-Smtp-Source: AGHT+IE8qr+3ZvJkExQliW6jHkHk7Az0eZ+hzQWcAo5QVabKY02QemCYudczVw2seK85vsVg+FKoN5iLYzGZmBPee8U=
X-Received: by 2002:a05:6512:aca:b0:50b:e056:396a with SMTP id
 n10-20020a0565120aca00b0050be056396amr4240552lfu.28.1702431374658; Tue, 12
 Dec 2023 17:36:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206005727.46150-1-zhangfei.gao@linaro.org> <170238473311.3099166.16078152394414654471.b4-ty@kernel.org>
In-Reply-To: <170238473311.3099166.16078152394414654471.b4-ty@kernel.org>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 13 Dec 2023 09:36:03 +0800
Message-ID: <CABQgh9EWiHXxEpNPNmS9r1HPSaxraYgtGC+cqJOTeSdYFp1TGw@mail.gmail.com>
Subject: Re: [PATCH] iommu/arm-smmu-v3: disable stall for quiet_cd
To: Will Deacon <will@kernel.org>
Cc: jean-philippe <jean-philippe@linaro.org>, Joerg Roedel <joro@8bytes.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, catalin.marinas@arm.com, kernel-team@android.com, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, 
	Wenkai Lin <linwenkai6@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Dec 2023 at 01:21, Will Deacon <will@kernel.org> wrote:
>
> On Wed, 6 Dec 2023 08:57:27 +0800, Zhangfei Gao wrote:
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
> > [...]
>
> Applied to will (for-joerg/arm-smmu/updates), thanks!
>
> [1/1] iommu/arm-smmu-v3: disable stall for quiet_cd
>       https://git.kernel.org/will/c/b41932f54458

Thanks Will

