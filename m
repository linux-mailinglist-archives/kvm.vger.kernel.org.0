Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A0F56238E
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 21:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiF3Twi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 15:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236739AbiF3Twf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 15:52:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63A0B443E9
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656618753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E7rOXhTCpvGdfk96ClCh2SccjfQHroJxIT08aj32MKE=;
        b=epSEz/GkML85CguRfbjrXTsjpWMjchutYuPlq49ZTL1vMu8hINOQX9b7DdnW3Rxmq5hoHU
        nyfrXelxF/JMS6SBq1+VB/rhfS1dHQ0pSfRDcAZCP6tm2Ydyoxm2OCOEvYdmAc6TUy1hqQ
        iLXNv9zhk9OUg7+Dghm7dgpJz2dQx0M=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-WI7XiWR0PEW5vtlnI6PT8A-1; Thu, 30 Jun 2022 15:52:32 -0400
X-MC-Unique: WI7XiWR0PEW5vtlnI6PT8A-1
Received: by mail-io1-f69.google.com with SMTP id x4-20020a6bd004000000b00675354ad495so83239ioa.20
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=E7rOXhTCpvGdfk96ClCh2SccjfQHroJxIT08aj32MKE=;
        b=H/+RPbx92wu+Gyv3bRkVY9FbbhqgeT5hjKnipswt1gkXGDonQBlvtzUMC+ohhTWg/y
         SkAF/SNgdUEu74OJUH4mgPaUHl0+e66QDu0RwZ92fYWYwa1s7m1MFwhKxw2vtAwr/gH5
         5oLk6ciSVLehVVwShKuSWpRbMYjntQSl32MxqZukRxyISypBpynfD1W0XFa/VyNM0hK1
         /+nZUSqe05G72uVgTSeEweKpSxim+4vh/FdAflrsl+E5KEGSlQOerRXHKnVfXINyaKq5
         ucZi0gcuxJ70XxMSSw+hRPK1i/q+dgS6OWWCnl6Ifn/+O14DvhNdVKgI4l7pOuprhUfo
         a0hw==
X-Gm-Message-State: AJIora/IUvQEUMsC8UH9ammK58oNuXEuxHXEjfn5jWldtZX13zauXZxl
        d4D6tAitPYFP6NxMpvBTODVe4TgaCy4xM5qrQvLoKeYDgg6+0AuZrquM8iI2rJ6lM8/rM19SUoR
        LTLZO0tdaK4mr
X-Received: by 2002:a05:6638:1344:b0:331:f546:69e with SMTP id u4-20020a056638134400b00331f546069emr6718776jad.131.1656618751267;
        Thu, 30 Jun 2022 12:52:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1udFgWMSc1np3jhhSMYyX98gcjlMb7XGAKqrwR5gSW723kcaSbACutNnYXxxxcCKjyG+MZrVQ==
X-Received: by 2002:a05:6638:1344:b0:331:f546:69e with SMTP id u4-20020a056638134400b00331f546069emr6718764jad.131.1656618751071;
        Thu, 30 Jun 2022 12:52:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x42-20020a0294ad000000b00330c5581c03sm8880286jah.1.2022.06.30.12.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 12:52:29 -0700 (PDT)
Date:   Thu, 30 Jun 2022 13:51:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     lizhe.67@bytedance.com
Cc:     cohuck@redhat.com, jgg@ziepe.ca, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan.x@bytedance.com
Subject: Re: [PATCH] vfio: remove useless judgement
Message-ID: <20220630135140.5069b23c.alex.williamson@redhat.com>
In-Reply-To: <20220627035109.73745-1-lizhe.67@bytedance.com>
References: <20220627035109.73745-1-lizhe.67@bytedance.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jun 2022 11:51:09 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> In function vfio_dma_do_unmap(), we currently prevent process to unmap
> vfio dma region whose mm_struct is different from the vfio_dma->task.
> In our virtual machine scenario which is using kvm and qemu, this
> judgement stops us from liveupgrading our qemu, which uses fork() &&
> exec() to load the new binary but the new process cannot do the
> VFIO_IOMMU_UNMAP_DMA action during vm exit because of this judgement.
> 
> This judgement is added in commit 8f0d5bb95f76 ("vfio iommu type1: Add
> task structure to vfio_dma") for the security reason. But it seems that
> no other task who has no family relationship with old and new process
> can get the same vfio_dma struct here for the reason of resource
> isolation. So this patch delete it.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Reviewed-by: Jason Gunthorpe <jgg@ziepe.ca>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 6 ------
>  1 file changed, 6 deletions(-)

Applied to vfio next branch for v5.20.  Thanks,

Alex

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c13b9290e357..a8ff00dad834 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1377,12 +1377,6 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  
>  		if (!iommu->v2 && iova > dma->iova)
>  			break;
> -		/*
> -		 * Task with same address space who mapped this iova range is
> -		 * allowed to unmap the iova range.
> -		 */
> -		if (dma->task->mm != current->mm)
> -			break;
>  
>  		if (invalidate_vaddr) {
>  			if (dma->vaddr_invalid) {

