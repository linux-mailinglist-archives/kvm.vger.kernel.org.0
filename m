Return-Path: <kvm+bounces-3695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E8980711B
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 14:47:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 566831F2125E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 13:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC39D3A8EB;
	Wed,  6 Dec 2023 13:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XHF5OnZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71F6C7
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 05:46:52 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-50bf32c0140so4462343e87.1
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 05:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701870411; x=1702475211; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cx5g+5SMQxcicok5kYvCUK6eBKquWgCzB86sfFem4PI=;
        b=XHF5OnZ+sP9TONNa4B4M8V4wwS3S5xh/cM2K6DpM+xYlhyL9f+HFKUrB/zJm+kW4uk
         LMZFb/3NHkA1tg/38CPQOjhPqZQywwuXIYmdkTNLbOr+/K3TglSW27S9mt7d8p5dw+g5
         gAv00fuX1zou/WVdQvI6kdHCWpcrl5rLzed9KY8MFaB17stWfB6zMYdNXknpYL5tajfw
         r9aJvlJq726XByUh2+UWkTEmPDZU185MFcUfUHFaEY6oxT4W2Y3dmt57iOwC+zwVkkmE
         Rp76K9s1LauUx/+Iz1QZT0rMjGZjvPY4qlrtL4wEJvsCUtf7HliXdA1vvuFwrc8qAiOE
         D38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701870411; x=1702475211;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cx5g+5SMQxcicok5kYvCUK6eBKquWgCzB86sfFem4PI=;
        b=WngeW2zs4+is7yS4dhnT9ICvXQ9BHXZ5531TalF51Zzm5qILcXX+iIlvCKIpluG0JL
         8gnYjW0UT7YgE3YCFKaWgz3gShR9WJefGV1zK2bBqbYXc94EgLQMa+9AQMcGazRT1o99
         fwstG+VG1IZ0D4cM3JbtBTMskv5WbRIpIbMcj+zeOrkyDg7E4TkELuwE60VQSDM7OepJ
         GhPwuSCrGnNSwwbdz6inqfOEFpgHs1nlMGcqTpn5b32fltB6VtlhL0sPVL9s4Nk73QbC
         bYJzWtXyC4Ozxg3maIwIXsGiowg71kRdJjhJwvj5YQeNW2q7jPXe405pRLd1fw8rxpEa
         Y0HA==
X-Gm-Message-State: AOJu0YylDbgFWdZD2u1jtdCf3xdIy7fbRVox5fqeJMNd8CS+Q+1616+L
	qY/PocIi2rMrmcaWFiF4IcIzSVCQBkG+DBsNLEYJiQ==
X-Google-Smtp-Source: AGHT+IFDPczFKh5GMvs5SBPQNG9ZyK/pZsKfhVA9gUmBbF0dGQ7YqvGAQFTEpGYilkKRMT/TRZA9w5RZm2ZVFqdXvnc=
X-Received: by 2002:a05:6512:e97:b0:50c:17d6:fff6 with SMTP id
 bi23-20020a0565120e9700b0050c17d6fff6mr314987lfb.1.1701870410783; Wed, 06 Dec
 2023 05:46:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206005727.46150-1-zhangfei.gao@linaro.org> <20231206095717.GA2643771@myrica>
In-Reply-To: <20231206095717.GA2643771@myrica>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 6 Dec 2023 21:46:39 +0800
Message-ID: <CABQgh9E5GH4xm=+doz=FO+yJuFa0w5f6D2hovj0kUhgkr_sr0w@mail.gmail.com>
Subject: Re: [PATCH] iommu/arm-smmu-v3: disable stall for quiet_cd
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, 
	Wenkai Lin <linwenkai6@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 6 Dec 2023 at 17:57, Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
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
> >
> > Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> > Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> > Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>
> Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Thanks Jean.

