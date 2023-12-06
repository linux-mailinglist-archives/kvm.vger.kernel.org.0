Return-Path: <kvm+bounces-3683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F521806B1F
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 10:57:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A72D1F213EA
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E571208D7;
	Wed,  6 Dec 2023 09:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C1ne2ZCe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9CA120
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 01:57:10 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-40c19f5f822so2346145e9.1
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 01:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701856629; x=1702461429; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6WOufZeE4P5YrzNvJiHEpQChOUhjcC+wU9d3XJlhAto=;
        b=C1ne2ZCe+LJLDXBkM3gPz7zb6sGhh9R+YqCQFZ++GDnOCxYq+ZCKTq3oyZWXJZHom8
         6sn69TddZcuI0gcdrARvSEKj7m7pWm7Ode0QausIU6lJ6c2EoNfe5UcG+B3qECNbpc3b
         ib+PW4xl2Prav8qOyAXH9mrjuEIMwZ6jOPJrIRjlqVNzKyYK9WLqo++Fgnwet/wT1zPn
         oA0nj3sCYujRvw2kEluab7cAGd3jvT0ZY+/scbufHDRwAvb4yeize2T/1C5D/K4uqGC7
         JTpMYO1ChzeIJXH9FJzT+ljCJi1QEe8cOsNiB8HHM53jTZP5ATQEw3aAgDVEfAOC803u
         8pGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701856629; x=1702461429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WOufZeE4P5YrzNvJiHEpQChOUhjcC+wU9d3XJlhAto=;
        b=UT2K3f9HfXP5FjLZvOWgv5Vn8BweXcPgrZjhk44hwhiNCU7AtbJ4k2xb5wIqixsS1v
         GNA7GGJpAevRMYfBivATRjaS2FvoSH8Ih84sNR5o+jGircSNH/QPawj0eOz0W9Q+ZAWJ
         YUUWXR+uX45EXyt2oOnnMiCzoo+KL8d2yPVM2PnQGQvruzatXspGoj+vNlfHKv2VSUdO
         PH37vT0zAZ2RXj0gw3n3htzfUJlSwHLaSsI14rAmmcy5NJhuqm3a6h1Byx3i/R8rzSzf
         dJ3HntX4pkzgAon2Q+nKw6zYgXwwfTxCqo7X7jB8FLkM+k4+NYIdTwSci9ExI1yMbCcw
         pRvw==
X-Gm-Message-State: AOJu0Yxx1LvAp3Qk8vdm+UWJwW1pNwvo+/k30NLksH2t3y/3Pn5IX/PR
	4DzKUGVDK35RUeZ8ks64RLiUUXPN3Q6sF5mMRxDHDA==
X-Google-Smtp-Source: AGHT+IFsH8K0hxbQzyVbZh44+ZBYduzN3cYJsMNckKn76oaG9oDcMavmkJSmuqzOJjocAnEZClHfhw==
X-Received: by 2002:a05:600c:4d8f:b0:40b:5e56:7b42 with SMTP id v15-20020a05600c4d8f00b0040b5e567b42mr1439954wmp.139.1701856629051;
        Wed, 06 Dec 2023 01:57:09 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id f13-20020a5d64cd000000b003334898aafasm8182940wri.11.2023.12.06.01.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 01:57:08 -0800 (PST)
Date: Wed, 6 Dec 2023 09:57:17 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, Wenkai Lin <linwenkai6@hisilicon.com>
Subject: Re: [PATCH] iommu/arm-smmu-v3: disable stall for quiet_cd
Message-ID: <20231206095717.GA2643771@myrica>
References: <20231206005727.46150-1-zhangfei.gao@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206005727.46150-1-zhangfei.gao@linaro.org>

On Wed, Dec 06, 2023 at 08:57:27AM +0800, Zhangfei Gao wrote:
> From: Wenkai Lin <linwenkai6@hisilicon.com>
> 
> In the stall model, invalid transactions were expected to be
> stalled and aborted by the IOPF handler.
> 
> However, when killing a test case with a huge amount of data, the
> accelerator streamline can not stop until all data is consumed
> even if the page fault handler reports errors. As a result, the
> kill may take a long time, about 10 seconds with numerous iopf
> interrupts.
> 
> So disable stall for quiet_cd in the non-force stall model, since
> force stall model (STALL_MODEL==0b10) requires CD.S must be 1.
> 
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 7445454c2af2..7086e5fa41ff 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1063,6 +1063,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>  	bool cd_live;
>  	__le64 *cdptr;
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> +	struct arm_smmu_device *smmu = master->smmu;
>  
>  	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
>  		return -E2BIG;
> @@ -1077,6 +1078,8 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>  	if (!cd) { /* (5) */
>  		val = 0;
>  	} else if (cd == &quiet_cd) { /* (4) */
> +		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
> +			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
>  		val |= CTXDESC_CD_0_TCR_EPD0;
>  	} else if (cd_live) { /* (3) */
>  		val &= ~CTXDESC_CD_0_ASID;
> -- 
> 2.39.3 (Apple Git-145)
> 

